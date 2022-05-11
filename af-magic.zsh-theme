# af-magic.zsh-theme
#
# Author: Andy Fleming
# URL: http://andyfleming.com/

# dashed separator size
function afmagic_dashes {
  # check either virtualenv or condaenv variables
  local python_env="${VIRTUAL_ENV:-$CONDA_DEFAULT_ENV}"

  # if there is a python virtual environment and it is displayed in
  # the prompt, account for it when returning the number of dashes
  if [[ -n "$python_env" && "$PS1" = \(* ]]; then
    echo $(( COLUMNS - ${#python_env} - 3 ))
  else
    echo $COLUMNS
  fi
}

# settings
typeset +H return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
typeset +H my_gray="$FG[240]"
typeset +H my_orange="$FG[214]"

function virtualenv_display {
	local PYTHON_ENV="$( echo $VIRTUAL_ENV | awk -F "/" '{print (NF>1)? $NF : ""}')"
	if [[ -n "$PYTHON_ENV" ]]; then
		echo "($PYTHON_ENV)"
	else
		echo ''
	fi
}

# primary prompt
(( $+functions[virtualenv_prompt_info] )) && PS1='$FG[237]${(l.$(afmagic_dashes)..-.)}%{$reset_color%}
$(virtualenv_display)$(tf_prompt_info) $FG[032]%~$(git_prompt_info)$(hg_prompt_info) $FG[105]%(!.#.»)%{$reset_color%} '
PS2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'

# right prompt
RPS1+=' $my_gray%n%{$reset_color%} [ %DT%T ]%'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="${FG[075]}(${FG[078]}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

# hg settings
ZSH_THEME_HG_PROMPT_PREFIX="${FG[075]}(${FG[078]}"
ZSH_THEME_HG_PROMPT_CLEAN=""
ZSH_THEME_HG_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_HG_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

# virtualenv settings
ZSH_THEME_VIRTUALENV_PREFIX=" $FG[075]"
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}"
