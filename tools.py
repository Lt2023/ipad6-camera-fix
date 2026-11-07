import os, pathlib, plistlib, hashlib
p = pathlib.Path
original = p(os.environ["ORIGINAL_POLICY"]).read_bytes()
reference = plistlib.loads(p(os.environ["REFERENCE_POLICY"]).read_bytes())
d = plistlib.loads(original)
key = "com.apple.cameracaptured"
for section in ("Default", "Override"):
    assert key not in d["Version4"]["Daemon"][section], "Input must be unpatched"
    d["Version4"]["Daemon"][section][key] = reference["Version4"]["Daemon"][section][key]
modified = plistlib.dumps(d, fmt=plistlib.FMT_BINARY)
expected_original = "b80a3facc9b6a4be90692e2a6dd771442f926991e05ca61c64ae8fe64c70a16c"
expected_modified = "46d191569d46c6a32d489d57560537840deb54dc0f79b8a93ba252a3e51be06a"
assert hashlib.sha256(original).hexdigest() == expected_original, "Untested original policy"
assert hashlib.sha256(modified).hexdigest() == expected_modified, "Untested reference policy"
root = p(".build/jetsam")
for name, content in (("original", original), ("patched", modified)):
    (root / "usr/share/local-j71b-camera" / name).write_bytes(content)
for name in ("postinst", "prerm"):
    target = root / "DEBIAN" / name
    target.write_bytes((p("src") / name).read_bytes())
    target.chmod(0o755)
