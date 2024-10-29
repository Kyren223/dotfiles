#!/bin/zsh
# https://drive.proton.me/urls/DS2CFQYQHR#5aibRkZNmELZ
# https://drive.proton.me/urls/1R0E5Z633W#reuxfaCJfM5n same as proton
# Automatic commits
git fetch --all
git add .
timestamp=$(date +%s)
git commit -m "$timestamp"
git push origin master

