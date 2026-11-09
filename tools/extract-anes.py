#!/usr/bin/env python3
"""Extract ANEs from the World Flipper APK (or from a folder of .ane files).

Usage:
    python tools/extract-anes.py <World Flipper.apk> <dest>
    python tools/extract-anes.py <folder-with-ane-files> <dest>
    python tools/extract-anes.py <apk> <dest> --ffdec ..\\tools\\ffdec\\ffdec.bat

The APK stores its extensions as loose files under
    assets/META-INF/AIR/extensions/<extensionID>/
so each extension is written to <dest>/<extensionID>/ exactly as AIR ships it.
A folder of .ane files is simply unzipped to <dest>/<file-stem>/.

--ffdec additionally runs FFDec's "export script" on each library.swf to get
readable ActionScript sources in <dest>/<extensionID>/src.  Those sources are
starting points: the extension's own TimeZone/Embed helpers often need small
edits before compc accepts them (see the README).

This script only reads the APK / ANEs; it never modifies the source copy.
"""

import argparse
import os
import subprocess
import zipfile


def extract_apk(apk, dest):
    prefix = "assets/META-INF/AIR/extensions/"
    ids = set()
    with zipfile.ZipFile(apk) as z:
        for name in z.namelist():
            if not name.startswith(prefix):
                continue
            rest = name[len(prefix):]
            if not rest or rest.startswith("/"):
                continue
            ext_id = rest.split("/", 1)[0]
            ids.add(ext_id)
            rel = rest[len(ext_id):].lstrip("/")
            out = os.path.join(dest, ext_id, rel)
            if name.endswith("/"):
                os.makedirs(out, exist_ok=True)
                continue
            os.makedirs(os.path.dirname(out), exist_ok=True)
            with z.open(name) as src, open(out, "wb") as dst:
                dst.write(src.read())
    return sorted(ids)


def extract_anes(folder, dest):
    ids = []
    for name in sorted(os.listdir(folder)):
        if not name.lower().endswith(".ane"):
            continue
        ext_id = os.path.splitext(name)[0]
        out = os.path.join(dest, ext_id)
        os.makedirs(out, exist_ok=True)
        with zipfile.ZipFile(os.path.join(folder, name)) as z:
            z.extractall(out)
        ids.append(ext_id)
    return ids


def run(cmd):
    print("+ " + subprocess.list2cmdline(cmd))
    subprocess.check_call([os.environ.get("COMSPEC", "cmd.exe"), "/c"] + cmd)


def find_library_swf(root):
    """APK loose extensions keep it under META-INF/ANE; a zip .ane has it at root."""
    for rel in ("META-INF/ANE/library.swf", "library.swf"):
        p = os.path.join(root, rel)
        if os.path.isfile(p):
            return p
    return None


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("source", help="World Flipper.apk or a folder containing .ane files")
    ap.add_argument("dest", help="output folder")
    ap.add_argument("--ffdec", help="path to ffdec.bat/ffdec.exe; also export ActionScript sources")
    args = ap.parse_args()

    os.makedirs(args.dest, exist_ok=True)
    if os.path.isdir(args.source):
        ids = extract_anes(args.source, args.dest)
    elif os.path.isfile(args.source):
        ids = extract_apk(args.source, args.dest)
    else:
        raise SystemExit("not found: %s" % args.source)

    print("\nextracted %d extension(s) to %s\n" % (len(ids), args.dest))
    for ext_id in ids:
        root = os.path.join(args.dest, ext_id)
        swf = find_library_swf(root)
        print("  %-34s library.swf=%s" % (ext_id, "yes" if swf else "NO"))

    if args.ffdec:
        ffdec = os.path.abspath(args.ffdec)
        if not os.path.isfile(ffdec):
            raise SystemExit("ffdec not found: %s" % ffdec)
        for ext_id in ids:
            swf = find_library_swf(os.path.join(args.dest, ext_id))
            if not swf:
                continue
            src = os.path.join(args.dest, ext_id, "src")
            os.makedirs(src, exist_ok=True)
            run([ffdec, "-export", "script", src, swf])


if __name__ == "__main__":
    main()
