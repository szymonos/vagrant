#!/bin/bash
APP='k9s'
while [[ -z $REL ]]; do
  REL=$(curl -k https://api.github.com/repos/derailed/k9s/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type yq &>/dev/null; then
  VER=$(k9s version -s | grep '^Version' | sed  -r 's/.*\s+v([0-9\.]+)$/\1/')
  if [ $REL == $VER ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
curl -Lsk "https://github.com/derailed/k9s/releases/download/v${REL}/k9s_Linux_x86_64.tar.gz" | tar -xz
mkdir -p /opt/k9s && install -m 0755 k9s /opt/k9s/k9s && rm -f k9s
[ -f /usr/bin/k9s ] || ln -s /opt/k9s/k9s /usr/bin/k9s
