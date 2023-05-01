#!/bin/bash

set -e

Cyan='\033[0;36m'
Yellow='\033[1;33m'
Red='\033[0;31m'
Green='\033[0;32m'
NC='\033[0;0m'
EOL='\n'
BOLD='\033[1m'
HAIR='\033[0m'

if [[ $1 ]]; then

  if [[ "$1" == "ckan" ]]; then

    printf "${EOL}${Cyan}Syncing local master to upstream master for ${BOLD}CKAN${HAIR}${NC}${EOL}"

    LOCAL_GITDIR="./ckan/registry/src/ckan/.git"
    LOCAL_WORKTREE="./ckan/registry/src/ckan"
    UPSTREAM="https://github.com/ckan/ckan.git"

  elif [[ "$1" == "dcat" ]]; then

    printf "${EOL}${Cyan}Syncing local master to upstream master for ${BOLD}DCAT${HAIR}${NC}${EOL}"

    LOCAL_GITDIR="./ckan/registry/src/ckanext-dcat/.git"
    LOCAL_WORKTREE="./ckan/registry/src/ckanext-dcat"
    UPSTREAM="https://github.com/ckan/ckanext-dcat.git"

  elif [[ "$1" == "fluent" ]]; then

    printf "${EOL}${Cyan}Syncing local master to upstream master for ${BOLD}FLUENT${HAIR}${NC}${EOL}"

    LOCAL_GITDIR="./ckan/registry/src/ckanext-fluent/.git"
    LOCAL_WORKTREE="./ckan/registry/src/ckanext-fluent"
    UPSTREAM="https://github.com/ckan/ckanext-fluent.git"

  elif [[ "$1" == "cloudstorage" ]]; then

    printf "${EOL}${Cyan}Syncing local master to upstream master for ${BOLD}CLOUDSTORAGE${HAIR}${NC}${EOL}"

    LOCAL_GITDIR="./ckan/registry/src/ckanext-cloudstorage/.git"
    LOCAL_WORKTREE="./ckan/registry/src/ckanext-cloudstorage"
    UPSTREAM="https://github.com/datopian/ckanext-cloudstorage.git"

  elif [[ "$1" == "xloader" ]]; then

    printf "${EOL}${Cyan}Syncing local master to upstream master for ${BOLD}XLOADER${HAIR}${NC}${EOL}"

    LOCAL_GITDIR="./ckan/registry/src/ckanext-xloader/.git"
    LOCAL_WORKTREE="./ckan/registry/src/ckanext-xloader"
    UPSTREAM="https://github.com/ckan/ckanext-xloader.git"

  else

    printf "${EOL}${Yellow}Please supply a valid argument (ckan, dcat, fluent)${NC}${EOL}${EOL}"
    return

  fi;

else

  printf "${EOL}${Yellow}Please supply an argument (ckan, dcat, fluent)${NC}${EOL}${EOL}"
  return

fi;


git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} remote add upstream ${UPSTREAM} || true
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} fetch upstream

git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} checkout master
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} fetch origin
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} reset --hard upstream/master
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} push origin master --force

printf "${EOL}${Cyan}${BOLD}Done!${HAIR}${NC}${EOL}${EOL}"
