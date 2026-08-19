# Aliases
alias lb='git branch --sort="-committerdate" --format="%(color:green)%(committerdate:relative)%(color:reset) %(refname:short)" | head -n 10'
alias sz='source ~/.zshrc'
alias vz='vi ~/.zshrc'
alias c='clear && clear'
alias gc='git commit'
alias gp='git push'
alias pd='pnpm dev'
gch() {
	if [[ "$1" != "-d" ]]; then
		git checkout "$@"
		return
	fi

	shift
	if (( $# != 1 )); then
		print -u2 'usage: gch -d <branch>'
		return 2
	fi

	local branch="$1"
	local branch_ref="refs/heads/${branch#refs/heads/}"
	local line worktree_path current_worktree

	while IFS= read -r -d '' line; do
		case "$line" in
			worktree\ *) current_worktree="${line#worktree }" ;;
			branch\ "$branch_ref") worktree_path="$current_worktree"; break ;;
		esac
	done < <(git worktree list --porcelain -z) || return

	if [[ -n "$worktree_path" ]]; then
		current_worktree=$(git rev-parse --show-toplevel) || return
		if [[ "${worktree_path:A}" == "${current_worktree:A}" ]]; then
			print -u2 "gch: refusing to remove the current worktree: $worktree_path"
			return 1
		fi

		git worktree remove -- "$worktree_path" || return
	fi

	git checkout "$branch"
}
gmp() {
	local default
	default=$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
	[[ -z "$default" ]] && default=$(git remote show origin 2>/dev/null | awk '/HEAD branch/ {print $NF}')
	git checkout "$default" && git pull
}
alias gpu='git push --set-upstream origin $(git branch --show-current)'

cda() {
	local gitroot=$(git rev-parse --show-toplevel)
	if [[ -n "$gitroot" ]]; then
		cd "$gitroot/apps/$1"
	fi
}

_cda_autocomplete() {
	local gitroot=$(git rev-parse --show-toplevel)
	if [[ -n "$gitroot" ]]; then
		_arguments "1:path:_path_files -W $gitroot/apps -/"
	fi
}

compdef _cda_autocomplete cda

cdp() {
	local gitroot=$(git rev-parse --show-toplevel)
	if [[ -n "$gitroot" ]]; then
		cd "$gitroot/packages/$1"
	fi
}

_cdp_autocomplete() {
	local gitroot=$(git rev-parse --show-toplevel)
	if [[ -n "$gitroot" ]]; then
		_arguments "1:path:_path_files -W $gitroot/packages -/"
	fi
}

compdef _cdp_autocomplete cdp

cds() {
	local gitroot=$(git rev-parse --show-toplevel)
	if [[ -n "$gitroot" ]]; then
		cd "$gitroot/services/$1"
	fi
}

_cds_autocomplete() {
	local gitroot=$(git rev-parse --show-toplevel)
	if [[ -n "$gitroot" ]]; then
		_arguments "1:path:_path_files -W $gitroot/services -/"
	fi
}

compdef _cds_autocomplete cds

# Starship prompt
if [[ -o interactive ]]; then
	eval "$(starship init zsh)"
fi
