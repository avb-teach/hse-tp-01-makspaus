#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Correct format is: collect_files.sh <input_dir> <output_dir> [--max_depth <depth>]"
    exit 1
fi

input_dir=$1
output_dir=$2
max_depth=0

if [ "$#" -eq 4 ] && [ "$3" == "--max_depth" ]; then
    max_depth=$4
fi

mkdir -p "$input_dir"
mkdir -p "$output_dir"

python3 <<EOF

import os
import shutil

input_dir = "$input_dir"
output_dir = "$output_dir"
max_depth = $max_depth


def collect_files(input_dir, output_dir, max_depth, current_depth):
    if(max_depth != 0 and current_depth >= max_depth):
        return

    for root, directories, files in os.walk(input_dir):
        current_depth = root[len(input_dir):].count(os.sep)

        for file_name in files:
            input_file = os.path.join(root, file_name)

            base_name, extension = os.path.splitext(file_name)
            new_file_name = file_name
            count = 1

            while(os.path.exists(os.path.join(output_dir, new_file_name))):
                new_file_name = base_name + str(count) + extension
                count += 1

            output_file = os.path.join(output_dir, new_file_name)

            shutil.copy(input_file, output_file)

        if(max_depth != 0 and current_depth >= (max_depth-1)):
            break


collect_files(input_dir, output_dir, max_depth, 0)

EOF

echo "Все файлы были успешно скопированы в $output_dir"

