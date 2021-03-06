alias ga='git_add'              # Git Add
alias gb='git branch'           # Git Branch
alias gbc='git_branch_checkout' # Git Branch Checkout
alias gbd='git_branch_delete'   # Git Branch Delete
alias gbs='git_branch_select'   # Git Branch Select
alias gc='git_commit'           # Git Commit
alias gd='git diff'             # Git Diff
alias gf='git fetch'            # Git Fetch
alias gl='git pull'             # Git pulL
alias gp='git push'             # Git Push
alias gs='git status'           # Git Status

function git_add() {
	if [[ "$@" != "" ]]; then
		git add $@
	else
		git add --all
	fi
}

function git_branch_checkout() {
	local B=($(git_branch_select $1))
	if [ $#B -le 0 ]; then
		echo "No branch selected.\nCurrent branch: $(color red)$(git_branch_current)$(color)"
		return 1
	fi

	if [[ "${B[*]}" =~ "origin" ]]; then
		git checkout --quiet -b "${B[(($#B))]}" "${B[(($#B - 1))]}/${B[(($#B))]}" >/dev/null
	else
		git checkout --quiet "${B[1]}"
	fi

	echo "Successfully checkouted.\nCurrent Branch: $(color red)$(git_branch_current)$(color)"
}

function git_branch_select() {
	[ "$1" != "" ] && git fetch -p
	git branch $@ | sed -e 's/^[[:space:]]//' -e 's/^ //' -e '/\*/d' | peco | head -1 | sed 's/\// /g'
}

function git_branch_current() {
	git branch | sed -e '/\*/!d' -e 's/\* //'
}

function git_branch_delete() {
	local B=($(git_branch_select $1))
	[ $#B -gt 0 ] && git branch -d "${B[1]}"
}

function git_commit() {
	local message="$1"
	local commit_message="$(echo "$(date '+%Y-%m-%d %H:%M:%S') ${message}" | xargs echo -n)"
	git commit -m "${commit_message}"
}

function git_checkout_files() {
	local branch=($(git_branch_select))
	local checkout_list=($(cat $1))
	if [ $#branch -gt 0 ]; then
		for checkout_path in ${checkout_list[*]}; do
			git checkout ${branch} ${checkout_path}
		done
	fi
}
