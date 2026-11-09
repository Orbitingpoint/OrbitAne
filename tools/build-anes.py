#!/usr/bin/env python3
"""Build Windows .ane files from ext/<extensionID>/.

For every entry in manifest.json:
  1. compc  compiles ext/<id>/src -> build/<id>/lib.swc
  2. the library.swf is extracted from the SWC into dflt/, win86/, win64/
  3. the matching native DLL is copied from native/<arch>/ (vendor) or
     shim/<arch>/ (built by shim/build-shim.bat)
  4. adt packages the three platform folders into out_shim/<id>.ane

Requirements:
  * Harman AIR SDK 51.4.1 (compc.bat, adt.bat)
  * Python 3.8+
  * shim DLLs built first (shim/build-shim.bat) or vendor DLLs in ext/*/native/

Examples:
  python tools/build-anes.py
  python tools/build-anes.py --only com.distriqt.Battery
  python tools/build-anes.py --air-sdk "C:\\AIRSDK\\AIRSDK_51.4.1" --storepass secret
"""

import argparse
import json
import os
import shutil
import subprocess
import sys
import zipfile

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FALLBACK_AIRSDK = r"C:\AIRSDK\AIRSDK_51.4.1"


def default_air_sdk():
    candidates = [
        os.environ.get("AIRSDK"),
        os.environ.get("AIR_HOME"),
        os.path.join(REPO, "tools", "air"),
        FALLBACK_AIRSDK,
    ]
    for c in candidates:
        if c and os.path.isfile(os.path.join(c, "bin", "adt.bat")) \
                and os.path.isfile(os.path.join(c, "bin", "compc.bat")):
            return os.path.abspath(c)
    return os.environ.get("AIRSDK") or os.path.join(REPO, "tools", "air")


DEFAULT_AIRSDK = default_air_sdk()


def cmdline(args):
    return subprocess.list2cmdline(args)


def run(args):
    print("+ " + cmdline(args))
    # .bat launchers (compc.bat, adt.bat) need cmd.exe on Windows.
    subprocess.check_call([os.environ.get("COMSPEC", "cmd.exe"), "/c"] + args)


def find_exe(sdk, name):
    p = os.path.join(sdk, "bin", name)
    if not os.path.isfile(p):
        raise SystemExit("not found: %s (set AIRSDK or pass --air-sdk)" % p)
    return p


def extract_library_swf(swc_path, dest_path):
    with zipfile.ZipFile(swc_path) as z:
        data = z.read("library.swf")
    with open(dest_path, "wb") as f:
        f.write(data)


def resolve_dll(entry, arch, shim_dir):
    """Return the DLL path for an architecture.

    arch is 'x86' or 'x64'.  Vendor DLLs live in ext/<id>/native/win86|win64;
    shim DLLs live in shim/x86|x64.  The file name must match <nativeLibrary>.
    """
    dll = entry["dll"]
    win_dir = "win86" if arch == "x86" else "win64"
    candidates = [
        os.path.join(REPO, entry["source"].replace("/src", ""), "native", win_dir, dll),
        os.path.join(shim_dir, arch, dll),
    ]
    for p in candidates:
        if os.path.isfile(p):
            return p
    raise SystemExit(
        "missing %s for %s\n  looked in:\n    %s\n"
        "  build it with shim\\build-shim.bat or put the vendor DLL in ext\\%s\\native\\%s\\"
        % (dll, entry["id"], "\n    ".join(candidates), entry["id"], win_dir)
    )


def build_one(entry, args, sdk):
    ext_id = entry["id"]
    ext_dir = os.path.join(REPO, "ext", ext_id)
    build_dir = os.path.join(REPO, "build", ext_id)
    out_dir = os.path.abspath(args.out)
    os.makedirs(build_dir, exist_ok=True)
    os.makedirs(out_dir, exist_ok=True)

    src_dir = os.path.join(ext_dir, "src")
    if not os.path.isdir(src_dir):
        raise SystemExit("missing source directory: %s" % src_dir)

    platform_dirs = {
        "default": os.path.join(build_dir, "dflt"),
        "Windows-x86": os.path.join(build_dir, "win86"),
        "Windows-x86-64": os.path.join(build_dir, "win64"),
    }
    for d in platform_dirs.values():
        os.makedirs(d, exist_ok=True)

    lib_swc = os.path.join(build_dir, "lib.swc")
    compc = find_exe(sdk, "compc.bat")
    compc_args = [
        compc,
        "-output", lib_swc,
        "-source-path", src_dir,
        "-include-classes",
    ] + list(entry["classes"])
    run(compc_args)

    for d in platform_dirs.values():
        extract_library_swf(lib_swc, os.path.join(d, "library.swf"))

    for platform, arch in (("Windows-x86", "x86"), ("Windows-x86-64", "x64")):
        dll = resolve_dll(entry, arch, os.path.abspath(args.shim_dir))
        shutil.copyfile(dll, os.path.join(platform_dirs[platform], entry["dll"]))
        print("   %s/%s <- %s" % (platform, entry["dll"], dll))

    out_ane = os.path.join(out_dir, ext_id + ".ane")
    adt = find_exe(sdk, "adt.bat")
    adt_args = [
        adt,
        "-package",
        "-storetype", "pkcs12",
        "-keystore", os.path.abspath(args.keystore),
        "-storepass", args.storepass,
        "-target", "ane",
        out_ane,
        os.path.join(ext_dir, "extension.xml"),
        "-swc", lib_swc,
    ]
    for platform in ("default", "Windows-x86", "Windows-x86-64"):
        adt_args += ["-platform", platform, "-C", platform_dirs[platform], "."]
    run(adt_args)
    print("   -> %s\n" % out_ane)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--air-sdk", default=DEFAULT_AIRSDK, help="AIR SDK root (default: AIRSDK env or %s)" % DEFAULT_AIRSDK)
    ap.add_argument("--keystore", default=os.path.join(REPO, "cert.p12"), help="PKCS12 signing cert (default: cert.p12)")
    ap.add_argument("--storepass", default=os.environ.get("STOREPASS", "password"), help="keystore password (default: STOREPASS env or 'password')")
    ap.add_argument("--out", default=os.path.join(REPO, "out_shim"), help="output folder for .ane files")
    ap.add_argument("--shim-dir", default=os.path.join(REPO, "shim"), help="folder containing x86/ and x64/ shim DLLs")
    ap.add_argument("--only", action="append", metavar="ID", help="build only this extension ID (repeatable)")
    args = ap.parse_args()

    sdk = os.path.abspath(args.air_sdk)
    if not os.path.isfile(args.keystore):
        raise SystemExit(
            "keystore not found: %s\n"
            "create one with tools\\make-cert.bat, or pass --keystore/--storepass" % args.keystore
        )

    with open(os.path.join(REPO, "manifest.json"), encoding="utf-8") as f:
        manifest = json.load(f)

    selected = manifest
    if args.only:
        wanted = set(args.only)
        selected = [e for e in manifest if e["id"] in wanted]
        missing = wanted - {e["id"] for e in selected}
        if missing:
            raise SystemExit("unknown extension ID(s): %s" % ", ".join(sorted(missing)))

    print("AIR SDK : %s" % sdk)
    print("output  : %s" % os.path.abspath(args.out))
    print("building: %d extension(s)\n" % len(selected))
    for entry in selected:
        print("== %s (%s)" % (entry["id"], entry["dll"]))
        build_one(entry, args, sdk)
    print("done.")


if __name__ == "__main__":
    main()
