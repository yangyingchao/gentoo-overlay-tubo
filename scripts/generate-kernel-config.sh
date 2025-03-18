#!/usr/bin/env bash

set -eo pipefail # Exit immediately if a command exits with a non-zero status.
set -u			 # Treat unset variables as an error when substituting.
# set -x		 # Print commands and their arguments as they are executed.

printf "\nBackup kernel config...\n"
config_dir=profiles/kernel.conf
config_file=$config_dir/kernel-config-$(LANG=C lscpu | grep -i 'vendor' | awk -F ':' '{print $2}' | xargs)

mkdir -p "${config_dir}"
if [[ "${KCONF}" = "/proc/config" ]]; then
    conf=$(gzip -d -c /proc/config)
else
    conf=$(cat "${KCONF}")
fi

echo "${conf}" | tail -n +4 | sed -E "/^CONFIG_(AS|GCC|CLANG|CC|LD|LLD)_VERSION/d" > ${config_file}

printf "\nBackup portage...\n"
pushd "$(git rev-parse --show-toplevel)"

printf "\nAdd to stage area....\n"
git add "${config_file}" portage
