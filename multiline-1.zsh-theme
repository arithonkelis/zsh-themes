#depends on oh-my-zsh for the git / mercurial integration.

spotColor="%F{blue}"
warnColor="%F{red}"
# Return Indicator Character
# May be >1 char
ric="└ "

##############################################################################

nrm="%f%k"
suppressErrorDisplay="";

# Handle multiple enter presses -- only really used to suppress the error
# display after it has been shown once.
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

	unset l_prompt
	unset r_prompt
	local -a l_prompt
	local -a r_prompt
	

	# First, show the return code, if present
	if [[ "$rCode" -ne "0" && -z "$suppressErrorDisplay" ]];
	then
		l_prompt+=( "$ric%{$warnColor%}returned $rCode at %*%{$nrm%}" )
	fi


	if [ $UID -eq 0 ]; then
		p_col="$warnColor"
	else
		p_col="$spotColor"
	fi
	dirLine="%{$nrm%}%~%{$p_col%}>%{$nrm%} "
	l_prompt+=( "$dirLine" )

	if [[ -e .hg ]]; then
		hg_stuff="$(hg_prompt_info)"
		if [[ -n "$hg_stuff" ]]; then
			r_prompt+=( "hg: $hg_stuff " )
		fi
	fi

	if [[ -e .git ]]; then
		ZSH_THEME_GIT_PROMPT_PREFIX="git: %{$nrm%}"
		ZSH_THEME_GIT_PROMPT_SUFFIX="%{$nrm%}"
		ZSH_THEME_GIT_PROMPT_DIRTY="%{%F{yellow}%} (dirty)" # Ⓓ
		ZSH_THEME_GIT_PROMPT_UNTRACKED="%{%F{cyan}%} (untracked)" # ⓣ
		ZSH_THEME_GIT_PROMPT_CLEAN="%{%F{green}%} (clean)" # Ⓞ
		ZSH_THEME_GIT_PROMPT_ADDED="%{%F{cyan}%} (added)" # ⓐ ⑃
		ZSH_THEME_GIT_PROMPT_MODIFIED="%{%F{yellow}%} (modified)"  # ⓜ ⑁
		ZSH_THEME_GIT_PROMPT_DELETED="%{%F{red}%} (deleted)" # ⓧ ⑂
		ZSH_THEME_GIT_PROMPT_RENAMED="%{%F{blue}%} (renamed)" # ⓡ ⑄
		ZSH_THEME_GIT_PROMPT_UNMERGED="%{%F{magenta}%} (unmerged)" # ⓤ ⑊
		ZSH_THEME_GIT_PROMPT_AHEAD="%{%F{blue}%} (ahead)"

		git_stuff="$(git_prompt_info)"
		if [[ -n "$git_stuff" ]]; then
			r_prompt+=( "$git_stuff ")
		fi
	fi
	
	r_prompt+=("%{$p_col%}<%{$nrm%}%n%{$p_col%}@%{$nrm%}%m")
	RPS1="${r_prompt}"
	RPS2="\\"
	
	PS1="${(F)l_prompt}"
}

zle -N handle-empty-command
bindkey '^M' handle-empty-command
