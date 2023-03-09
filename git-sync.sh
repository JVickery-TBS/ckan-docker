#!/bin/bash

set -e

LOCAL_GITDIR="./ckan/registry/src/ckan/.git"
LOCAL_WORKTREE="./ckan/registry/src/ckan"

git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} remote add upstream https://github.com/ckan/ckan.git || true
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} fetch upstream

git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} checkout master
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} fetch origin
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} reset --hard upstream/master
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} push origin master --force

LOCAL_GITDIR="./ckan/registry/src/ckanext-dcat/.git"
LOCAL_WORKTREE="./ckan/registry/src/ckanext-dcat"

git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} remote add upstream https://github.com/ckan/ckanext-dcat.git || true
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} fetch upstream

git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} checkout master
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} fetch origin
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} reset --hard upstream/master
git --git-dir=${LOCAL_GITDIR} --work-tree=${LOCAL_WORKTREE} push origin master --force
