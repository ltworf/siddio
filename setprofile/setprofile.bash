# Copy this file in /etc/bash_completion.d/
# For this to work you need to have the bash-completion package installed

_setprofile_tab_complete () {
    #local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    #prev="${COMP_WORDS[COMP_CWORD-1]}"

    words="--list $(setprofile --list)"

    COMPREPLY=( $(compgen -W "${words}" -- ${cur}) )
    return 0
}
complete -F _setprofile_tab_complete setprofile
