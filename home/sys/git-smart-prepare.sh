#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

CURRENT_BRANCH=$(git branch --show-current)
# DEFAULT_BRANCH=$(git default-branch-name)

if [[ "$CURRENT_BRANCH" == "release" ]]; then
	notify-send -a 'git' "can't commit to release branch"
	exit 111
fi

if (($(git status -s | wc -l) < 1)); then
	notify-send -a 'git' "nothing to commit"
	exit 111
elif (($(git diff --cached | wc -l) <= 1)); then
	git add --all
	notify-send -a 'git' "staging all changes"
else
	if (($(git staged-files-with-unstaged-changes | wc -l) >= 1)); then
		notify-send -a 'git' "staged files with unstaged changes!" "$(git staged-files-with-unstaged-changes)"
	fi
fi
