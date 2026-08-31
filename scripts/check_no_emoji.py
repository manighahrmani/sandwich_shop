#!/usr/bin/env python3
"""Fail if any staged/checked text file contains an emoji character."""
import re
import sys

# Pictograph/emoji Unicode ranges only. Deliberately excludes arrows and
# general typographic symbol blocks, which are common in plain prose.
EMOJI_PATTERN = re.compile(
    "["
    "\U0001F300-\U0001FAFF"
    "\U00002600-\U000026FF"
    "\U00002700-\U000027BF"
    "\U0001F1E6-\U0001F1FF"
    "\U0000FE0F"
    "]"
)


def main() -> int:
    failed = False
    for path in sys.argv[1:]:
        try:
            with open(path, "r", encoding="utf-8") as f:
                text = f.read()
        except (UnicodeDecodeError, OSError):
            continue
        for lineno, line in enumerate(text.splitlines(), start=1):
            match = EMOJI_PATTERN.search(line)
            if match:
                msg = f"{path}:{lineno}: emoji character '{match.group()}' is not allowed"
                sys.stdout.buffer.write((msg + "\n").encode("utf-8"))
                failed = True
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
