#!/usr/bin/env python3
"""Insert the Karabiner-Elements caveats block into a cargo-dist generated formula.

cargo-dist rewrites Formula/dedent-paste.rb on every release and has no
caveats support, so this script re-applies the block afterwards. It is
idempotent and skips formulas older than 0.4.0, which lack `--install`.
"""
import re
import sys
from pathlib import Path

MIN_VERSION = (0, 4, 0)

CAVEATS = '''  def caveats
    <<~EOS
      dedent-paste is installed, but the Left Option+V hotkey is NOT set up yet.

      1. Install Karabiner-Elements if you have not already:
           brew install --cask karabiner-elements
      2. Register the Left Option+V rule (your Karabiner profile is backed up first):
           dedent-paste --install
      3. Allow Karabiner-Elements under
           System Settings > Privacy & Security > Accessibility

      To remove the rule later:
           dedent-paste --uninstall
    EOS
  end
'''


def main(path: Path) -> int:
    text = path.read_text(encoding="utf-8")

    if "def caveats" in text:
        print(f"{path}: caveats already present")
        return 0

    match = re.search(r'^\s*version "(\d+)\.(\d+)\.(\d+)', text, re.MULTILINE)
    if not match:
        print(f"{path}: could not find version line", file=sys.stderr)
        return 1
    version = tuple(int(part) for part in match.groups())
    if version < MIN_VERSION:
        print(f"{path}: version {'.'.join(map(str, version))} predates --install; skipping")
        return 0

    # Homebrew's style check wants caveats after install, so append the block
    # just before the closing `end` of the formula class.
    stripped = text.rstrip("\n")
    if not stripped.endswith("\nend"):
        print(f"{path}: formula does not end with a class 'end'", file=sys.stderr)
        return 1

    body = stripped[: -len("end")]
    path.write_text(body + "\n" + CAVEATS + "end\n", encoding="utf-8")
    print(f"{path}: caveats added")
    return 0


if __name__ == "__main__":
    sys.exit(main(Path(sys.argv[1] if len(sys.argv) > 1 else "Formula/dedent-paste.rb")))
