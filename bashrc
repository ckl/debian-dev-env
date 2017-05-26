stty -ixon  # prevents Ctrl-S freezes in putty
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:[\[\033[33;1m\]\w\[\033[32m\]]\[\033[36m\]\$(get_git_branch)\[\033[1;33m\] -> \[\033[0m\]"

