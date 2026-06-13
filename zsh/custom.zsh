# Aliases
alias lb='git branch --sort="-committerdate" --format="%(color:green)%(committerdate:relative)%(color:reset) %(refname:short)" | head -n 10'
alias sz='source ~/.zshrc'
alias vz='vi ~/.zshrc'
alias p='it2profile -g'
alias c='clear && clear'
alias gc='git commit'
alias gp='git push'
alias pd='pnpm dev'
alias gch='git checkout'
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
