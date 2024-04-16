#!/usr/bin/bash

source ~/.zshrc.d/01_env.zsh && setup_proxy

REPO=${HOME}/Work/calibre/
URL=git@github.com:yangyingchao/calibre.git
BRANCH=yc-hacking

die() {
notify-send "$*"
exit 1
}

[  -d "${REPO}" ] || die "Directory ${REPO} does not exist."

pushd "${REPO}"
[[ "$(git config remote.origin.url)" != "${URL}" ]] && die "Should clone from ${URL} manually."
[[ "$(git symbolic-ref --short HEAD)" != "${BRANCH}" ]] && die "Bad branch: $(git symbolic-ref --short HEAD)"
popd

export CALIBRE_DEVELOP_FROM="${REPO}/src"
/opt/calibre/calibre-debug -g
