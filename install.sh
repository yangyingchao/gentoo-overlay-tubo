#!/usr/bin/env bash
#
pushd "$(git rev-parse --show-toplevel)"

for hook in post-merge pre-commit; do
    [[ -f .git/hooks/$hook ]] || ln -sf "${PWD}"/scripts/${hook} .git/hooks/$hook
done

./scripts/post-merge

popd
