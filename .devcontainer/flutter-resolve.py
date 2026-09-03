#!/usr/bin/env python3
"""Resolve a Flutter release from the official Flutter releases JSON.

Prints "<archive-url> <sha256>" for a given version (exact like "3.38.7" or
wildcard like "3.38.x", resolved to the latest stable patch) so it can be
downloaded and checksum-verified in the devcontainer Dockerfile.

Same resolution pattern as ios/ci_scripts/ci_post_clone.sh (used by Xcode Cloud).

Environment variables:
    RELEASES_JSON    Path to the downloaded releases_linux.json
    FLUTTER_VERSION  Exact version ("3.38.7") or wildcard ("3.38.x")
    FLUTTER_CHANNEL  Release channel, default "stable"
    TARGETARCH       Docker target architecture (amd64/arm64), default "amd64"
"""

import json
import os
import sys


def main() -> None:
    data = json.load(open(os.environ["RELEASES_JSON"]))
    base_url = data["base_url"]
    version_input = os.environ["FLUTTER_VERSION"]
    channel = os.environ.get("FLUTTER_CHANNEL", "stable")
    arch = os.environ.get("TARGETARCH", "amd64")

    # Filter by channel + version pattern
    if version_input.endswith(".x"):
        prefix = version_input[:-2] + "."
        candidates = [
            r
            for r in data["releases"]
            if r["channel"] == channel and r["version"].startswith(prefix)
        ]
    else:
        candidates = [
            r
            for r in data["releases"]
            if r["channel"] == channel and r["version"] == version_input
        ]

    if not candidates:
        sys.exit(f"ERROR: No {channel} Linux release found for Flutter '{version_input}'")

    # Pick the latest patch version
    candidates.sort(key=lambda r: [int(x) for x in r["version"].split(".")])
    latest_version = candidates[-1]["version"]
    candidates = [r for r in candidates if r["version"] == latest_version]

    # Prefer architecture-specific archive; fall back to any if not found
    if arch == "arm64":
        arch_matches = [r for r in candidates if "arm64" in r["archive"]]
    else:
        arch_matches = [r for r in candidates if "arm64" not in r["archive"]]

    release = (arch_matches or candidates)[0]

    print(
        f"  Resolved version : {release['version']}",
        file=sys.stderr,
    )
    print(
        f"  Dart SDK         : {release.get('dart_sdk_version', 'unknown')}",
        file=sys.stderr,
    )
    print(f"  Archive          : {release['archive']}", file=sys.stderr)
    print(f"{base_url}/{release['archive']} {release['sha256']}")


if __name__ == "__main__":
    main()
