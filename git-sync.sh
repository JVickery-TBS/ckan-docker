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

BRANCH_NAME="master"

if [[ $1 ]]; then

  if [[ "$1" == "ckan" ]]; then

    printf "${EOL}${Cyan}Syncing local master to upstream master for ${BOLD}CKAN${HAIR}${NC}${EOL}"

    LOCAL_GITDIR="./ckan/registry/src/ckan/.git"
    LOCAL_WORKTREE="./ckan/registry/src/ckan"
    UPSTREAM="https://github.com/ckan/ckan.git"

  elif [[ "$1" == "ckanapi" ]]; then

    printf "${EOL}${Cyan}Syncing local master to upstream master for ${BOLD}CKAN API${HAIR}${NC}${EOL}"

    LOCAL_GITDIR="./ckan/registry/src/ckanapi/.git"
    LOCAL_WORKTREE="./ckan/registry/src/ckanapi"
    UPSTREAM="https://github.com/ckan/ckanapi.git"

  elif [[ "$1" == "cloudstorage" ]]; then

    printf "${EOL}${Cyan}Syncing local master to upstream master for ${BOLD}CLOUDSTORAGE${HAIR}${NC}${EOL}"

    LOCAL_GITDIR="./ckan/registry/src/ckanext-cloudstorage/.git"
    LOCAL_WORKTREE="./ckan/registry/src/ckanext-cloudstorage"
    UPSTREAM="https://github.com/datopian/ckanext-cloudstorage.git"

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

  elif [[ "$1" == "scheming" ]]; then

    printf "${EOL}${Cyan}Syncing local master to upstream master for ${BOLD}SCHEMING${HAIR}${NC}${EOL}"

    LOCAL_GITDIR="./ckan/registry/src/ckanext-scheming/.git"
    LOCAL_WORKTREE="./ckan/registry/src/ckanext-scheming"
    UPSTREAM="https://github.com/ckan/ckanext-scheming.git"

  elif [[ "$1" == "security" ]]; then

    printf "${EOL}${Cyan}Syncing local master to upstream master for ${BOLD}SECURITY${HAIR}${NC}${EOL}"

    LOCAL_GITDIR="./ckan/registry/src/ckanext-security/.git"
    LOCAL_WORKTREE="./ckan/registry/src/ckanext-security"
    UPSTREAM="https://github.com/data-govt-nz/ckanext-security.git"

  elif [[ "$1" == "validation" ]]; then

    printf "${EOL}${Cyan}Syncing local master to upstream master for ${BOLD}VALIDATION${HAIR}${NC}${EOL}"

    LOCAL_GITDIR="./ckan/registry/src/ckanext-validation/.git"
    LOCAL_WORKTREE="./ckan/registry/src/ckanext-validation"
    UPSTREAM="https://github.com/frictionlessdata/ckanext-validation.git"

  elif [[ "$1" == "xloader" ]]; then

    printf "${EOL}${Cyan}Syncing local master to upstream master for ${BOLD}XLOADER${HAIR}${NC}${EOL}"

    LOCAL_GITDIR="./ckan/registry/src/ckanext-xloader/.git"
    LOCAL_WORKTREE="./ckan/registry/src/ckanext-xloader"
    UPSTREAM="https://github.com/ckan/ckanext-xloader.git"
    EXTRA_UPSTREAM_1="https://github.com/qld-gov-au/ckanext-xloader.git"
    EXTRA_UPSTREAM_1_NAME="queensland"

  else

    printf "${EOL}${Yellow}Please supply a valid argument (ckan, ckanapi, cloudstorage, dcat, fluent, scheming, validation, xloader)${NC}${EOL}${EOL}"
    return

  fi;

else

  printf "${EOL}${Yellow}Please supply an argument (ckan, ckanapi, cloudstorage, dcat, fluent, scheming, validation, xloader)${NC}${EOL}${EOL}"
  return

fi;

if [[ "$2" ]]; then

  BRANCH_NAME="$2"

fi;

git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} remote add upstream ${UPSTREAM} || true
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} fetch upstream

git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} checkout ${BRANCH_NAME}
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} fetch origin
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} reset --hard upstream/${BRANCH_NAME}
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} push origin ${BRANCH_NAME} --force

if [[ $EXTRA_UPSTREAM_1 && $EXTRA_UPSTREAM_1_NAME ]]; then

  printf "${EOL}${Cyan}Fetching extra upstream ${BOLD}${EXTRA_UPSTREAM_1_NAME}${HAIR}${Cyan} from ${BOLD}${EXTRA_UPSTREAM_1}${HAIR}${NC}${EOL}"

  git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} remote add ${EXTRA_UPSTREAM_1_NAME} ${EXTRA_UPSTREAM_1} || true
  git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} fetch ${EXTRA_UPSTREAM_1_NAME}

fi;

printf "${EOL}${Cyan}${BOLD}Done!${HAIR}${NC}${EOL}${EOL}"
