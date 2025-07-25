# mv-merge

A command line utility to **merge directories and files** with optional features like comparison, dry-run, interactive mode, copying, and cleanup of identical files. 
Designed for power users handling large directory trees or organizing bulk content.

Unlike `rsync`, which always copies files, `mv-merge` focuses on **moving** or **optionally copying** only when necessary.
This makes it ideal for reorganizing large file collections without redundant disk I/O when operating on the same mount.

**By no means this is a `rsync` replacement!**

---

## 🚀 Features

- **Merge directories** recursively
- **Preserve file timestamps**
- **Interactive and force modes**
- **Dry-run support**: preview all operations without making changes
- **Remove identical duplicates** with `--compare-existing` and `--rm-identical`
- **Support for file comparisons** using CRC32 and size checks
- **Optional file copying** instead of moving
- **Clean up empty folders** automatically after operations
- **Verbose mode** for detailed output
- **Summary statistics** after completion

---

## 🛠️ Usage

```sh
mv-merge [options] <source>... <destination>
```

| Option                     | Description                                        |
| -------------------------- | -------------------------------------------------- |
| `-f`, `--force`            | Overwrite existing files without prompting         |
| `-i`, `--interactive`      | Prompt before overwriting or removing files        |
| `-n`, `--dry-run`          | Show what would be done, but don’t make changes    |
| `-C`, `--copy`             | Copy files instead of moving them                  |
| `-c`, `--compare-existing` | Compare existing destination files using CRC32     |
| `-r`, `--rm-identical`     | Delete source files if they're identical to target |
| `-t`, `--preserve-times`   | Preserve modification timestamps                   |
| `-v`, `--verbose`          | Print detailed information about each operation    |
| `-s`, `--summary`          | Print summary statistics at the end                |


## 📁 Example
Checkout `example.sh`
```sh
$ tree project/
project/
├── dst
│   ├── data.csv        # Different
│   ├── important.txt   # Exist only in dst
│   ├── notes
│   │   └── hello.txt   # Identical
│   └── report.txt      # Identical
└── src
    ├── data.csv        # Different
    ├── notes
    │   ├── hello.txt   # Identical
    │   └── hi.txt      # Exist only in src
    └── report.txt      # Identical

5 directories, 8 files
```
Lets merge src into dst:
```sh
$ mv-merge --compare-existing --rm-identical --verbose --dry-run project/src project/dst
WOULD MOVE: project/src/notes/hi.txt -> project/dst/notes/hi.txt

==> Comparing:
SRC: project/src/notes/hello.txt
DST: project/dst/notes/hello.txt
SRC Size: 7 bytes
DST Size: 7 bytes
SRC Time: 2025-07-25 15:21:26.999873715 +0200
DST Time: 2025-07-25 15:21:27.001873719 +0200
SRC CRC32: 113449826
DST CRC32: 113449826
Files IDENTICAL
WOULD REMOVE: project/src/notes/hello.txt

==> Comparing:
SRC: project/src/data.csv
DST: project/dst/data.csv
SRC Size: 27 bytes
DST Size: 24 bytes
SRC Time: 2025-07-25 15:21:26.999873715 +0200
DST Time: 2025-07-25 15:21:26.999873715 +0200
Files DIFFER (size mismatch)
SKIPPED (no force): project/dst/data.csv

==> Comparing:
SRC: project/src/report.txt
DST: project/dst/report.txt
SRC Size: 50 bytes
DST Size: 50 bytes
SRC Time: 2025-07-25 15:21:26.995873708 +0200
DST Time: 2025-07-25 15:21:26.998873713 +0200
SRC CRC32: 3775304161
DST CRC32: 3775304161
Files IDENTICAL
WOULD REMOVE: project/src/report.txt
```
After checking everything is like we want it to:
```sh
$ mv-merge --compare-existing --rm-identical --summary project/src project/dst
====== Summary ======
Moved      : 1
Copied     : 0
Overwritten: 0
Removed    : 2
Skipped    : 1
Compared   : 3
Errors     : 0
=====================
```
The tree afterwards:
```sh
$ tree project/
project/
├── dst
│   ├── data.csv
│   ├── important.txt
│   ├── notes
│   │   ├── hello.txt
│   │   └── hi.txt
│   └── report.txt
└── src
    └── data.csv

4 directories, 6 files
```

## 🧩 Dependencies

- bash
- cksum (for CRC32)
- stat, cp, mv, rm, rmdir, find (GNU coreutils)

## 🛡️ Safety Notes

No files are overwritten unless `--force` or `--interactive` is specified.  
In `--dry-run` mode, no changes are made. Use it to validate outcomes!  
When using `--rm-identical`, only identical files (based on CRC32 and size) will be deleted.

## 📖 License

This project is released under the MIT License. Feel free to use, modify, and distribute.