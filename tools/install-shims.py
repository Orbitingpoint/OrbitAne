#!/usr/bin/env python3
"""Install freshly built FRE shim DLLs into existing ANEs (and optionally an app).

Usage:
    python tools/install-shims.py <ane-dir> [<app-dir>] [--shim-dir PATH]

For every .ane in <ane-dir> the native library file names declared per
platform are looked up in the shim build output (shim/x86 and shim/x64) and
the matching DLLs replace whatever the ANE currently carries. When an app
directory is given, the same replacement is applied to the extension copy
AIR unpacked there, so an existing build can be retested without a full
rebuild.

This is the operation that produced ane-win/out_shim from ane-win/out:
same zip entries, same catalog/signatures, only the Windows DLLs swapped.

NOTE: replacing files inside a signed ANE invalidates META-INF/signatures.xml.
AIR does not verify ANE signatures at load time in the captive runtime, so
private test builds keep working. For redistribution, repackage and sign the
ANE with adt instead.
"""

import argparse
import os
import shutil
import sys
import zipfile

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_SHIM = os.path.join(REPO, "shim")


def native_names(zf, platform):
    prefix = "META-INF/ANE/%s/" % platform
    return [n for n in zf.namelist() if n.startswith(prefix) and n.lower().endswith(".dll")]


def replace_in_ane(ane_path, report, shim_dir):
    x86 = os.path.join(shim_dir, "x86")
    x64 = os.path.join(shim_dir, "x64")
    with zipfile.ZipFile(ane_path) as zf:
        replacements = {}
        for platform, built_dir in (("Windows-x86", x86), ("Windows-x86-64", x64)):
            for member in native_names(zf, platform):
                name = os.path.basename(member)
                built = os.path.join(built_dir, name)
                if os.path.exists(built):
                    replacements[member] = built
    if not replacements:
        report.append("  skip  %s (no shim build matches its native libraries)" % os.path.basename(ane_path))
        return False
    tmp = ane_path + ".tmp"
    with zipfile.ZipFile(ane_path, "r") as zin, zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as out:
        for info in zin.infolist():
            data = zin.read(info.filename)
            if info.filename in replacements:
                with open(replacements[info.filename], "rb") as fh:
                    data = fh.read()
            zi = zipfile.ZipInfo(info.filename, date_time=info.date_time)
            # ANE archives keep the first entry ("mimetype") stored, like SWFs do.
            zi.compress_type = (
                zipfile.ZIP_STORED
                if info.filename == "mimetype" or info.compress_type == zipfile.ZIP_STORED
                else zipfile.ZIP_DEFLATED
            )
            zi.external_attr = info.external_attr
            out.writestr(zi, data)
    shutil.move(tmp, ane_path)
    for member, built in sorted(replacements.items()):
        report.append("  ane   %s :: %s <- %s (%d bytes)" % (
            os.path.basename(ane_path), member, os.path.basename(built), os.path.getsize(built)))
    return True


def replace_in_app(app_dir, report, shim_dir):
    x86 = os.path.join(shim_dir, "x86")
    x64 = os.path.join(shim_dir, "x64")
    ext_root = os.path.join(app_dir, "META-INF", "AIR", "extensions")
    if not os.path.isdir(ext_root):
        report.append("  no extension directory in %s" % app_dir)
        return
    for ext_id in sorted(os.listdir(ext_root)):
        ane_root = os.path.join(ext_root, ext_id, "META-INF", "ANE")
        if not os.path.isdir(ane_root):
            continue
        for platform, built_dir in (("Windows-x86", x86), ("Windows-x86-64", x64)):
            plat_dir = os.path.join(ane_root, platform)
            if not os.path.isdir(plat_dir):
                continue
            for name in os.listdir(plat_dir):
                if not name.lower().endswith(".dll"):
                    continue
                built = os.path.join(built_dir, name)
                if os.path.exists(built):
                    shutil.copyfile(built, os.path.join(plat_dir, name))
                    report.append("  app   %s :: %s <- %s (%d bytes)" % (
                        ext_id, name, os.path.basename(built), os.path.getsize(built)))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("ane_dir", help="folder containing .ane files to patch in place")
    ap.add_argument("app_dir", nargs="?", help="optional unpacked/bundled app directory")
    ap.add_argument("--shim-dir", default=DEFAULT_SHIM, help="folder containing x86/ and x64/ shim DLLs")
    args = ap.parse_args()

    report = []
    for name in sorted(os.listdir(args.ane_dir)):
        if name.endswith(".ane"):
            replace_in_ane(os.path.join(args.ane_dir, name), report, os.path.abspath(args.shim_dir))
    if args.app_dir:
        replace_in_app(args.app_dir, report, os.path.abspath(args.shim_dir))
    print("\n".join(report))


if __name__ == "__main__":
    main()
