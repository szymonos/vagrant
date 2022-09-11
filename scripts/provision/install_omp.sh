#!/bin/bash
: '
scripts/provision/install_omp.sh
'

APP='oh-my-posh'
while [[ -z "$REL" ]]; do
  REL=$(curl -sk https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type "$APP" &>/dev/null; then
  VER=$(oh-my-posh version)
  if [ "$REL" = "$VER" ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
curl -LsOk 'https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64'
mkdir -p /opt/omp && install -o root -g root -m 0755 posh-linux-amd64 /opt/omp/oh-my-posh && rm -f posh-linux-amd64
[ -f /usr/bin/oh-my-posh ] || ln -s /opt/omp/oh-my-posh /usr/bin/oh-my-posh
