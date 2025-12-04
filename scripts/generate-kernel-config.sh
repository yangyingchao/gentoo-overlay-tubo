#!/usr/bin/env bash

set -eo pipefail # Exit immediately if a command exits with a non-zero status.

pushd "$(git rev-parse --show-toplevel)"

printf "\nBackup kernel config...\n"

CPU=$(LANG=C lscpu | grep -i 'vendor' | awk -F ':' '{print $2}' | xargs)
VER=$(uname -r | awk -F '.' '{print $1"."$2}')

config_dir=profiles/kernel.conf.d
config_file=$config_dir/kernel-config-${VER}-$CPU

mkdir -p "${config_dir}"
gzip -d -c /proc/config | sed -E "/^CONFIG_(AS|GCC|CLANG|CC|LD|LLD)_VERSION/d" > "${config_file}"

printf "\nAdd to stage area....\n"
git add "${config_file}" portage
