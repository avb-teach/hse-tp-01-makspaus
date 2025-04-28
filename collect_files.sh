#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Correct format is: collect_files.sh <input_dir> <output_dir> [--max_depth <depth>]"
    exit 1
fi

input_dir=$1
output_dir=$2
max_depth=-1

if [ "$#" -eq 4 ] && [ "$3" == "--max_depth" ]; then
    max_depth=$4
fi
