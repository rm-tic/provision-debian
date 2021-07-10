#!/bin/bash

# Author: Rodrigo Martins
# E-mail: rodrigomartins.tic@gmail.com


function gterm_load(){
  GTERM_DIR="$HOME/.gterm"
  GTERM_FILE="$GTERM_DIR/gterm-profile.dconf"
  GTERM_RC="$GTERM_DIR/gterm.rc"
  GTERM_URL="https://raw.githubusercontent.com/rm-tic/provision-debian/main/gterm-profile.dconf"


  if [[ ! -d $GTERM_DIR  || "$(cat $GTERM_RC)" != "0" ]]; then
    mkdir $GTERM_DIR
    echo "0" > $GTERM_RC
    wget -qO $GTERM_FILE $GTERM_URL

    # DCONF Export
    #dconf dump /org/gnome/terminal/legacy/profiles:/ > $GTERM_FILE

    # DCONF Import
    dconf load /org/gnome/terminal/legacy/profiles:/ < $GTERM_FILE
  fi
}

function packages_status(){
  PACKAGE="$1"
  PACKAGE_STATUS="$(dpkg-query -W -f='${db:Status-Abbrev}' $PACKAGE 2> /dev/null | cut -c 1-2)"

  if [ "$PACKAGE_STATUS" = "ii" ]; then
    echo "present"
  else
    echo "absent"
  fi
}

function apt_update(){
  if [ "$UPDATE_RC" != "0" ]; then
    $sh_c 'apt-get update -qq'
    UPDATE_RC="0"
  fi
}

function packages_setup(){

  GIT_STATUS="$(packages_status git)"
  PYTHON3_VIRTUALENV_STATUS="$(packages_status python3-virtualenv)"
  CURL_STATUS="$(packages_status curl)"

  echo ">>> Installing Essential Packages..."

  if [ "$CURL_STATUS" = "absent" ]; then
    apt_update
    $sh_c 'apt-get install -y curl > /dev/null 2>&1'
    echo ">>> Essential Packages: curl installed."
  else
    echo ">>> Essential Packages: curl is already installed."
  fi

  if [ "$PYTHON3_VIRTUALENV_STATUS" = "absent" ]; then
    apt_update
    $sh_c 'apt-get install -y python3-virtualenv > /dev/null 2>&1'
    echo ">>> Essential Packages: python3-virtualenv installed."
  else
    echo ">>> Essential Packages: python3-virtualenv is already installed."
  fi

  if [ "$GIT_STATUS" = "absent" ]; then
    apt_update
    $sh_c 'apt-get install -y git > /dev/null 2>&1'
    echo ">>> Essential Packages: git installed."
    echo
  else
    echo ">>> Essential Packages: git is already installed."
    echo
  fi
}

function github_clone_repo(){
   REPO_DIR="/tmp/provision-debian"
   REPO_URL="https://github.com/rm-tic/provision-debian.git"

  echo ">>> Cloning repository in $REPO_DIR..."
  echo
  git clone $REPO_URL $REPO_DIR > /dev/null 2>&1
}

function python_venv_create(){
  echo ">>> Creating python3 virtualenv..."
  python3 -m virtualenv -q "$REPO_DIR/.venv"
}

function python_venv_activate(){
  echo ">>> Enabling virtualenv..."
  echo
  source "$REPO_DIR/.venv/bin/activate"
}

function python_venv_setup(){
  echo ">>> Installing playbook dependencies via pip..."
  echo
  python3 -m pip -q install -U -r "$REPO_DIR/requirements.txt"
}

function ansible_collections(){
  echo ">>> Ansible: Install community.general collection"
  echo
  ansible-galaxy collection install community.general > /dev/null 2>&1
}

function ansible_run(){
  echo ">>> Ansible: Starting playbook..."
  echo
  ansible-playbook "$REPO_DIR/main.yml"
}

function main(){

  if [ "$(id -un)" = "root" ]; then
    sh_c="sh -c"
  else
    sh_c="sudo sh -c"
  fi

  echo
  echo "+----------------------------------+"
  echo "| Invencible (Ansible)             |"
  echo "| Project: provision-debian        |"
  echo "| Author: Rodrigo Martins (IceTux) |"
  echo "| Creation Date: 2021-07-09        |"
  echo "+----------------------------------+"
  echo
  echo

  # Load Functions
  gterm_load
  packages_setup
  github_clone_repo
  python_venv_create
  python_venv_activate
  python_venv_setup
  ansible_collections
  ansible_run
}

main