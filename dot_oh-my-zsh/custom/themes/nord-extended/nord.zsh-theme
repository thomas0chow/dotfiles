ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%} on %{$fg_bold[yellow]%}\xee\x82\xa0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$reset_color%}%{$fg_bold[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT=$'\n%{\e[1;35m%}'$'\xf3\xb0\x84\x9b'$' %{\e[1;34m%}%n %{\e[1;37m%}at %{\e[1;36m%}%m %{\e[1;37m%}in %{\e[1;32m%}%3c%{\e[0m%}$(git_prompt_info)%{\e[0m%}\n%{\e[1;37m%}› %{\e[0m%}'
RPROMPT=''
