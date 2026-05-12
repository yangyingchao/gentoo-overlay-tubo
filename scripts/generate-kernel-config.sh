#!/usr/bin/env bash

set -Eeuo pipefail

(
    cd "$(git rev-parse --show-toplevel)"

    printf "\nBackup kernel config...\n"

    CPU=$(LANG=C lscpu | grep -i 'vendor' | awk -F ':' '{print $2}' | xargs)

    config_dir=profiles/kernel.conf.d
    config_files=()

    mkdir -p "${config_dir}"

    while IFS= read -r -d '' fn; do
        if [[ "$fn" == *.old ]]; then
            echo "Skip: $fn"
            continue
        fi
        printf "Proc: %s" "$fn"
        ver=$(echo "$fn" | sed -E 's/.*config-([0-9]+).([0-9]+).*/\1.\2/g')
        config_file=$config_dir/kernel-config-${ver}-$CPU
        printf " ==> %s," "$config_file"

        sed -E -e "/^CONFIG_(AS|GCC|CLANG|CC|LD|LLD)_VERSION/d" \
            -e "/^# Linux.* Kernel Configuration$/d" \
            "$fn" >"${config_file}"
        printf " done...\n"
        config_files+=("$config_file")
    done < <(find /boot -name "config-*" -print0)

    printf "\nAdd to stage area: %s....\n" "${config_files[*]}"
    git add "${config_files[@]}" portage
)
