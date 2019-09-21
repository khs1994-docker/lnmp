#!/usr/bin/env sh

# https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/

BRANCH=`git rev-parse --abbrev-ref HEAD`
COMMIT_MESSAGE=`git log -n 1`

# GITHUB_REF=refs/heads/feature-branch-1

_check_commit_message_fail() {
  echo "Commit Message Check Fail"
  exit 78
}

if [ -n "${PCIT_WHEN_BRANCH}" -a ${BRANCH} != "${PCIT_WHEN_BRANCH}" ];then \
  echo "Branch Check Fail"; exit 78; fi

# 包含某个标志才运行
if [ -n "${PCIT_WHEN_COMMIT_MESSAGE_INCLUDE}" ];then \
 echo ${COMMIT_MESSAGE} | grep -i -q "\[${PCIT_WHEN_COMMIT_MESSAGE_INCLUDE}\]" \
   && exit 0 || _check_commit_message_fail;
fi

# 包含某个标志时不运行

if [ "${PCIT_WHEN_COMMIT_MESSAGE:-1}" != "1" ];then \
  echo "Skip Check Commit Message"; exit 0; fi

## 自定义标志
if [ -n "${PCIT_WHEN_COMMIT_MESSAGE_SKIP}" ];then
  echo ${COMMIT_MESSAGE} | grep -i -q "\[${PCIT_WHEN_COMMIT_MESSAGE_SKIP}\]" \
    && _check_commit_message_fail || true
fi
