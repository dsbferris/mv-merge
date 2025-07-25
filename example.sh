#!/bin/bash

mkdir -p project/src/notes
mkdir -p project/dst/notes

# Identical report.txt in both src and dst
echo "Weekly Report\n-------------\nEverything is fine." > project/src/report.txt
cp project/src/report.txt project/dst/report.txt

# Different data.csv files
echo "2023-12-31,Old Data,999" > project/dst/data.csv
echo "2024-01-01,Sample Data,123" > project/src/data.csv

# New file only in src
echo "Hi there!" > project/src/notes/hi.txt

# hello.txt exists and is identical in both src and dst
echo "Hello!" > project/src/notes/hello.txt
cp project/src/notes/hello.txt project/dst/notes/hello.txt

# File only in dst
echo "Important notes here." > project/dst/important.txt
