# .bashrc

export HOME='/root'

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
 . /etc/bashrc
fi

# User specific aliases and functions
alias ebr='vim ~/.bashrc'
alias sbr='source ~/.bashrc'
alias ebp='vim ~/.bash_profile'
alias sbp='source ~/.bash_profile'

# git aliases
alias gs='git status'
alias gp='git push origin'
alias gpf='git push --force'
alias gd='git diff'
alias gpl='git pull --rebase origin'
alias gsa='git stash'
alias gsp='git stash pop'
alias gb='git branch'
alias gc='git checkout'
alias gco='git commit'
alias ga='git add'
alias gl='git log'

# vim aliases
alias v='vim'
alias vrc='vim ~/.vimrc'
alias ic='cd /src/iso-console && vim'
alias im='cd /src/iso-model && vim'
alias cic='cd /src/iso-console/'
alias cim='cd /src/iso-model/'
alias sb='cd /src/split-brain && vim'

# some tools that are packaged in the
# dev directory using yarn...
alias webpack='yarn run webpack'
alias eslint='yarn run eslint'
alias tslint='yarn run tslint'
alias babel='yarn run babel'

# misc aliases
alias c='clear'
alias s='cd /src'
alias pawk='perl -ane'

# TODO(mprast): since we use typescript,
# we need to use something like tslint_d,
# but as far as I can tell that doesn't
# exist yet. we really need to find
# something we can use!
#
# eslint is fast, but node startup and
# package loading makes it slow (almost a
# second to lint a file). This isn't tenable
# if we want to do linting on open/save
# (in vim, for example), so we use eslint_d,
# which will preload eslint in a daemon for us.
# HOWEVER, the daemon sticks around even when
# we leave our editor, and in fact even when
# we leave the container (since we're just
# using chroot via rkt fly, the container
# shares a process namespace with the host).
# This can lead to us spawning tons of eslint_d
# processes, but also will break linting if
# ~/.eslint_d exists, since the editor will
# try to connect to the server via the port
# listed in that file (and fail - I _think_
# because switching containers messes with the
# network namespace). In any case, three cases
# we need to consider, since bashrc will get
# called any time we spawn an interactive
# session:
#
# 1) no ~/.eslint_d at all - clean up any
# eslint_d processes
#
# 2) ~/.eslint_d exists but we can't
# connect to the server - clean up both the
# file and process(es) so we can start over
# next time we use our editor.
#
# 3) ~/.eslint_d exists and we _can_ connect -
# leave everything alone; we're probably in
# the middle of a session
#
# if [ "$(eslint_d status)" != 'Running' ]
#   then
#     pkill -f 'usr/lib/node_modules/eslint_d/lib/server.js'
#     # file might not exist, but we don't care
#     rm ~/eslint_d 2>/dev/null
# fi


# CTRL-S sends the XOFF signal to the terminal
# driver, which makes it stop ending the
# terminal data. This makes it appear to the user
# that they can't type anything anymore. This
# is annoying and we probably don't need XON and
# XOFF enabled anyway, so
# we disable them with this command.
stty -ixon

# we need to export this manually since it
# isn't in the fedora container by default
export TERM=screen.xterm-256color

# this is to ensure that we can auth to things
# like github via our private key from within
# the container. We do this by manually setting
# the name of the ssh agent socket on our host
# and pulling it in so that ssh can use it
# here. /ssh_agent is rbind mounted from a
# dir on the host
export SSH_AUTH_SOCK=/ssh_agent/ssh_agent.socket

# for git commit messages
export EDITOR=vim

# and finally
export PATH

