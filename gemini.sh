#!/bin/bash

#colores
W="\e[0m"
N="\e[30;1m"
n="\e[30m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
P="\e[35m"
C="\e[36m"
L="\e[37;2m"

#resaltado
rW="\e[48m"
rN="\e[40;1m"
rG="\e[42m"
rY="\e[43m"
rB="\e[44m"
rP="\e[45m"
rC="\e[46m"
rL="\e[47m"

#mas
bol="${W}\033[1m"
cur="\033[3m"
sub="\033[4m"

#salidas/entradas
cent="\e[38;2;255;174;3m"
bord=$N
#exU="\e[38;2;255;187;65m"
#exU="\e[38;2;146;255;112m"
exU="\e[38;2;214;214;214m"
excr=$W
info=$cent
ban=$W

T="$bord [${cent}+${W}${bord}]$excr"
F="$bord [${cent}-${W}${bord}]$excr"

A="${W}$bord [${bol}${Y}!${W}${bord}]$excr"
E="${W}$bord [${bol}${R}✘${W}${bord}]$excr"
S="${W}$bord [${bol}${G}✓${W}${bord}]$excr"

I="$bord [${cent}\$${bord}]${cent}❯$excr"
IA="$bord [${W}${cent}󰙴${bord}]${W}${cent}❯$excr"
gU="$bord [${W}${cent}${bord}]${W}${cent}❯$excr"
#U="$bord [${W}${G}  󰻂${bord}]${W}${G}❯$excr"
U="$bord [${W}${exU}${bord}]${W}${exU}❯$exU"

YN="$bord[${cent}Y${bord}/${cent}N${bord}]${excr}"

#info
autor="${bol}$bord [$W ${info}Json Security${bord} ]"
script="${bol}$bord [$W ${info}Gemini${bord} ]"

promt=""
APIKEY=$(cat .APIKEY 2>/dev/null)

if [[ ! -n $APIKEY ]];then
	echo -e "\n$E APIKEY not found"
	exit 1
fi

banner() {
	clear
	echo -e """$cent
            ...',,,,,,''..
         ..,;cccc::::::cccc:,..
       .':cc:,...      ...,;cc:,.
      ':lc,.                .,:lc,.
    .;cc;.   ${ban}    '. ${cent}          .,cl:.  $W$cent
   .;cc,.   ${ban}    ,l:.${cent}            'cl:.
   'cl;.    ${ban}  .;lllc;'. ${cent}         ,cl, $W$cent
  .;lc.  ${ban} ..,cllllloolc;'. ${cent}      .:l:.
  .:l:.  ${ban}  ..;cllllllc;'.  ${cent}      .;lc.
  .;l:.  ${ban}     .,col;'.    ,   ${cent}    .;l:.
   ,cc,    ${ban}     .c,      .,. ${cent}    'cl;.
   .:lc'     ${ban}    ..   ..;llc.. ${cent} .:lc.
    .:l:'       ${ban}        .;:'  ${cent} .:lc'
     .;cc;.        ${ban}      . ${cent}  .;cl:.
       .;cc:,..          ..';cc:'.
         .,:ccc:;,,''',;;:cc:;..
            .',;;:::::::;,'..
                   ...
                   
     ${autor}$W$cent ${script}$W
    """
}

request() {

curl -sN https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$APIKEY \
 -H 'Content-Type: application/json' \
 -d    "{
            \"contents\":
            {
                \"role\": \"user\",
                \"parts\":
                    {
                \"text\": \"$promt\"
                }
            },
        }" -o chat.txt

	c="33"
    b="e[${c}m"

    chat=$(cat chat.txt \
        | awk -F"\"text\":" '{print $2}' \
        | tr -d '\n' \
        | sed 's/^ *"//; s/" *$//' \
        | sed 's!\*\*!\\'"$b"'!g' \
        | sed 's!'"$c"'m\\n!0m\\n!g' \
        | sed 's!'"$c"'m !0m !g' \
        | sed 's!\\n\*!\\n -!g' \
        | sed 's!\\"!"!g')

	if [[ ! -n $chat ]];then
		echo -e "$E Response not found :("
	else
    	echo -e " $chat"
    fi
}

interactive() {
	banner

	while true;do
		printf "$U "
		read promt
		printf "$W\n"
		request
		printf "\n"
	done
}

help() {
	echo -e "[+] Usage:
\t-p <promt>           # Promt
\t-i                   # Interactive
\t-h                   # Help"
	    exit 0
}

if [ ! $1 ];then
	help
	exit 1
fi

while getopts h,p:,i arg;do
	case $arg in
		h) help;;
		p) promt=$OPTARG;request;;
		i) interactive;;
		*) help;;
	esac
done
