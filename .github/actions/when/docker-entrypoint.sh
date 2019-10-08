#!/usr/bin/env sh

# https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/

if [ -n "$GITHUB_ACTION" ];then
  # "refs/heads/19.03"
  echo $GITHUB_REF | grep 'refs/tags/' && IS_TAG=1 || true
  BRANCH=$(echo $GITHUB_REF | cut -d '/' -f 3)
  PCIT_WHEN_COMMIT_MESSAGE=${INPUT_COMMIT_MESSAGE:-}
  PCIT_WHEN_BRANCH=${INPUT_BRANCH:-}
  PCIT_WHEN_COMMIT_MESSAGE_SKIP=${INPUT_COMMIT_MESSAGE_SKIP:-}
  PCIT_WHEN_COMMIT_MESSAGE_INCLUDE=${INPUT_COMMIT_MESSAGE_INCLUDE:-}
else
  BRANCH=`git rev-parse --abbrev-ref HEAD`
fi

COMMIT_MESSAGE=`git log -n 1`

_check_commit_message_fail() {
  echo "Commit Message Check Fail $@"
  exit 78
}

if [ "${IS_TAG}" != 1 ];then

if [ -n "${PCIT_WHEN_BRANCH}" ] && [ "${BRANCH}" != "${PCIT_WHEN_BRANCH}" ];then \
  echo "Branch Check Fail"; exit 78; fi

else
  echo "tag event, not check branch"
fi

# 包含某个标志才运行
if [ -n "${PCIT_WHEN_COMMIT_MESSAGE_INCLUDE}" ];then \
 echo ${COMMIT_MESSAGE} | grep -i -q "\[${PCIT_WHEN_COMMIT_MESSAGE_INCLUDE}\]" \
   && exit 0 || _check_commit_message_fail notInclude;
fi

# 包含某个标志时不运行

if [ "${PCIT_WHEN_COMMIT_MESSAGE:-1}" != "1" ];then \
  echo "Skip Check Commit Message"; exit 0; fi

## 自定义标志
if [ -n "${PCIT_WHEN_COMMIT_MESSAGE_SKIP}" ];then
  echo ${COMMIT_MESSAGE} | grep -i -q "\[${PCIT_WHEN_COMMIT_MESSAGE_SKIP}\]" \
    && _check_commit_message_fail skipByMessage || true
fi
