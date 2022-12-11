#!/bin/bash

nocolor=false
for arg in $@
do
    case $arg in
        --nocolor | -n ) nocolor=true
    esac
done

[ "$nocolor" == false ] && {
    dblack="$(echo -ne "\e[0;30m")"
    dred="$(echo -ne "\e[0;31m")"
    dgreen="$(echo -ne "\e[0;32m")"
    dyellow="$(echo -ne "\e[0;33m")"
    dblue="$(echo -ne "\e[0;34m")"
    dpurple="$(echo -ne "\e[0;35m")"
    dlblue="$(echo -ne "\e[0;36m")"
    dwhite="$(echo -ne "\e[0;37m")"
    dnocl="$(echo -ne "\e[0;0m")"
    #
    black="$(echo -ne "\e[1;30m")"
    red="$(echo -ne "\e[1;31m")"
    green="$(echo -ne "\e[1;32m")"
    yellow="$(echo -ne "\e[1;33m")"
    blue="$(echo -ne "\e[1;34m")"
    purple="$(echo -ne "\e[1;35m")"
    lblue="$(echo -ne "\e[1;36m")"
    white="$(echo -ne "\e[1;37m")"
    nocl="$(echo -ne "\e[1;0m")"
}

[ "$str" == '' ] && str="user logname shell br tty arch cpu os br color"

tput sc
echo -n "getting information..."
logname="$(logname)"
whoami="$(whoami)"
hostname="$(hostname)"
tty="$(tty)"
arch="$(arch)"
cpu="$(lscpu | sed -nr '/Model name/ s/.*:\s*(.*) @ .*/\1/p')"
tput rc
echo -ne "\r"
nr=0
[ "$COLUMNS" == '' ] && COLUMNS=$(tput cols)
until [ $nr -ge "$COLUMNS" ]
do echo -n " "
((nr++))
done

function i.user {
    [ "$whoami" == '' ] || [ "$hostname" == '' ] || echo -e "user: ${yellow}${whoami}${nocl}@${red}${hostname}"
}
function i.logname {
    [ "$logname" == '' ] || [ "$hostname" == '' ] ||  echo -e "logname: ${yellow}${logname}${nocl}@${red}${hostname}"
}
function i.tty {
    [ "$tty" == '' ] || echo -e "tty: ${purple}${tty}"
}
function i.arch {
    [ "$arch" == '' ] || echo -e "arch: ${blue}${arch}"
}
function i.os {
    . /etc/os-release
    [ "$NAME" == '' ] || [ "$VERSION" == '' ] || echo -e "os: ${green}${NAME} ${dgreen}${VERSION} "
}
function i.shell {
    [ "$SHELL" == '' ] || echo "shell: ${dblue}${SHELL}"
}
function i.cpu {
    [ "$cpu" == '' ] || echo "cpu: ${dred}${cpu} "
}
function i.color {
    # dark, fg
    nr=30
    while [ $nr -le 37 ]
    do
    echo -ne "\e[0;${nr}m0;${nr}m\e[0;0m"
    #[ "$nr" -eq 33 ] && echo ""
    ((nr++))
    done
    echo ""
    # dark, bg
    nr=40
    while [ $nr -le 47 ]
    do
    echo -ne "\e[0;${nr}m0;${nr}m\e[0;0m"
    #[ "$nr" -eq 43 ] && echo ""
    ((nr++))
    done
    echo ""
    # light, fg
    nr=30
    while [ $nr -le 37 ]
    do
    echo -ne "\e[1;${nr}m1;${nr}m\e[1;0m"
    #[ "$nr" -eq 33 ] && echo ""
    ((nr++))
    done
    echo ""
    # light, bg
    nr=40
    while [ $nr -le 47 ]
    do
    echo -ne "\e[1;${nr}m1;${nr}m\e[1;0m"
    #[ "$nr" -eq 43 ] && echo ""
    ((nr++))
    done
    echo ""
}



# structure resolve
for item in $str
do
    case $item in
        user ) i.user ;;
        logname ) i.logname ;;
        br ) echo "" ;;
        tty ) i.tty ;;
        arch ) i.arch ;;
        os ) i.os ;;
        color ) i.color ;;
        cpu ) i.cpu ;;
        shell ) i.shell ;;
        * ) echo "$item not found."
    esac
    echo -ne "$nocl"
done
