#!/usr/bin/env bash

if [ -n "$(grep -i nixos < /etc/os-release)" ]; then
  echo "Verified this is NixOS."
  echo "-----"
else
  echo "This is not NixOS or the distribution information is not available."
  exit
fi

if command -v git &> /dev/null; then
  echo "Git is installed, continuing with installation."
  echo "-----"
else
  echo "Git is not installed. Please install Git and try again."
  echo "Example: nix-shell -p git"
  exit
fi

echo "Default options are in brackets []"
echo "Just press enter to select the default"
sleep 2

echo "-----"

echo "Ensure In Home Directory"
cd || exit

echo "-----"

read -rp "Enter Your New Hostname: [ default ] " hostName
if [ -z "$hostName" ]; then
  hostName="default"
fi

echo "-----"

backupname=$(date "+%Y-%m-%d-%H-%M-%S")
if [ -d "moguchos" ]; then
  echo "MoguchOS exists, backing up to .config/moguchos-backups folder."
  if [ -d ".config/moguchos-backups" ]; then
    echo "Moving current version of MoguchOS to backups folder."
    mv "$HOME"/moguchos .config/moguchos-backups/"$backupname"
    sleep 1
  else
    echo "Creating the backups folder & moving MoguchOS to it."
    mkdir -p .config/moguchos-backups
    mv "$HOME"/moguchos .config/moguchos-backups/"$backupname"
    sleep 1
  fi
else
  echo "Thank you for choosing MoguchOS."
  echo "I hope you find your time here enjoyable!"
fi

echo "-----"

echo "Cloning & Entering MoguchOS Repository"
git clone https://github.com/Moguchiu/moguchos
cd moguchos || exit
mkdir hosts/"$hostName"
cp hosts/default/*.nix hosts/"$hostName"
git config --global user.name "installer"
git config --global user.email "installer@gmail.com"
git add .
sed -i "/^\s*host[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$hostName\"/" ./flake.nix


read -rp "Enter your keyboard layout: [ us ] " keyboardLayout
if [ -z "$keyboardLayout" ]; then
  keyboardLayout="us"
fi

sed -i "/^\s*keyboardLayout[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$keyboardLayout\"/" ./hosts/$hostName/variables.nix

echo "-----"

installusername=$(echo $USER)
sed -i "/^\s*username[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$installusername\"/" ./flake.nix

echo "-----"

echo "Generating The Hardware Configuration"
sudo nixos-generate-config --show-hardware-config > ./hosts/$hostName/hardware.nix

echo "-----"

echo "Setting Required Nix Settings Then Going To Install"
NIX_CONFIG="experimental-features = nix-command flakes"

echo "-----"

sudo nixos-rebuild switch --flake ~/maoguchos/#${hostName}
