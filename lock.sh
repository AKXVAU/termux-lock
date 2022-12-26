#!/bin/bash
#colors and other variables.
R='\e[1;31m'
C='\e[0;36m'
B='\e[1;34m'
G='\e[1;32m'
Y='\e[1;33m'
N='\e[0m'
FILE=$(which login)

#Banner
read -r -d '' BANNER << EOF
$B ======================================
$B  ==> [$Y+$B]$C TERMUX FINGERPRINT LOCK
$B  ==> [$Y+$B]$C     =>> @ITSN0B1T4
$B ======================================
$R
EOF

function authenticate() {
  termux-fingerprint | grep -q "AUTH_RESULT_SUCCESS"
}

function error_exit() {
  echo -e "$R\n$0: $1$N" >&2
  exit 1
}

function check_dependency() {
  if ! type -p termux-fingerprint &>/dev/null; then
    echo -e "$Y[*] Installing Dependencies$B\n"

    (pkg update && pkg upgrade -y && \
      pkg install termux-api -y) || \
      error_exit "NO INTERNET CONNECTION"

    if check_dependency ; then
      echo -e "\n$G[-] Dependencies Installed\n"
    fi
  fi
}

trap 'echo -e "$N"' 1 15 20

clear
echo -e "${BANNER}\n"

if grep -q "termux-fingerprint" $FILE; then
  echo -e "$Y[*] Fingerprint lock already exist\n"
  echo -e "$Y[*] Removing Fingerprint Lock\n"


  sleep 1
 
  if authenticate; then
    sed -i '/termux-fingerprint/d' $FILE

    echo -e "$G[-] Fingerprint Lock Removed Successfully$N\n"
    exit 0

  else
    error_exit "Authenticatiin Error"
  fi

else
  check_dependency

  echo -e "$Y[*] Fingerprint Lock Adding\n"

  sleep 1
 
  if authenticate; then
    sed -i '2 a termux-fingerprint -c Exit | grep -q "AUTH_RESULT_SUCCESS"; [ $? -ne 0 ] && exit' $FILE

    echo -e "$G[-] Fingerprint lock added successfully$N\n"
    exit 0
  else
    error_exit "Authenticatiin Error"
  fi
fi