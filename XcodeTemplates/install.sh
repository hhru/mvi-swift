#!/bin/bash

readonly script_dir=$(dirname "$0")
readonly default_xcode_templates_dir="$HOME/Library/Developer/Xcode/Templates/File Templates"
readonly xcode_templates_destination_dir="$default_xcode_templates_dir/hh"
readonly hh_templates_dir="CodeTemplates"
readonly hh_templates_directories=("HeadHunter VIPER Module" "HeadHunter" "MVI" "hh") 

cleanup() {
    echo "Cleaning up old templates..."

    for dir in "${hh_templates_directories[@]}"; do

        template_dir="${default_xcode_templates_dir}/${dir}/"
        if [ -d "${template_dir}" ]; then
            echo "  Removing ${template_dir}"
            rm -rf "${template_dir}"
        fi

    done
}

copy() {
    echo "Copying templates to $xcode_templates_destination_dir"

    mkdir -p "$xcode_templates_destination_dir/"
    cp -r "$hh_templates_dir/" "$xcode_templates_destination_dir/"

    echo "Done"
}

cd "$script_dir" || exit
cleanup
copy
