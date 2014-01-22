s_c="$fg[blue]"
warn_color="$fg[red]"
nrm="$reset_color"
p_col="$s_c"
suppressErrorDisplay="";

# Handle multiple enter presses -- only really used to suppress the error display after it has been shown once.
function handle-empty-command () {
	if [[ -z $BUFFER ]]; then
		suppressErrorDisplay=1;
	else
		suppressErrorDisplay="";
	fi
	zle accept-line
}

# Set up the prompt
function precmd() {
	rCode="$?"

	# Right side of the prompt...
	rp_builder="%~ %{$s_c%}<%{$reset_color%}%* %n%{$s_c%}@%{$reset_color%}%m"

	if [[ -e .hg ]]; then
		hg_stuff="$(hg_prompt_info)"
		if [[ -n "$hg_stuff" ]]; then
			rp_builder="hg:($hg_stuff) $rp_builder"
		fi
	fi


	if [[ -e .git ]]; then
		ZSH_THEME_GIT_PROMPT_PREFIX="git: %{$reset_color%}"
		ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
		ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} (dirty)" # Ⓓ
		ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} (untracked)" # ⓣ
		ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} (clean)" # Ⓞ
		ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} (added)" # ⓐ ⑃
		ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} (modified)"  # ⓜ ⑁
		ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} (deleted)" # ⓧ ⑂
		ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[$s_c]%} (renamed)" # ⓡ ⑄
		ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} (unmerged)" # ⓤ ⑊
		ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%} (ahead)"

		git_stuff="$(git_prompt_info)"
		if [[ -n "$git_stuff" ]]; then
			rp_builder="$git_stuff $rp_builder"
		fi
	fi

	if [[ "$rCode" -ne "0" && -z "$suppressErrorDisplay" ]]; then
		if [[ -n "$errorCodeOnRight" ]]; then
			return_code="ℯ%{$fg[red]%}$rCode%{$reset_color%}\r\n"
			rp_builder="$return_code $rp_builder"
		else

			plain=" $fg[red]↳ $rCode $reset_color\r\n"
			#plain="$fg[red]ℯ $rCode $reset_color\r\n"
			print -n "$plain\r\n"
		fi
	fi

	RPROMPT="$rp_builder"


	# Left side of the prompt
	if [ $UID -eq 0 ]; then
		p_col="$warn_color"
	else
		p_col="$s_c"
	fi

	PROMPT="%{$p_col%}>%{$reset_color%}"
}

zle -N handle-empty-command
bindkey '^M' handle-empty-command
