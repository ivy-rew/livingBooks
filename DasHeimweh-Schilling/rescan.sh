#!/bin/bash

page=$1
img=page-$page.png
lang=$2

current=text/1-ersterTeil/page-$1.md
text=out/rescanpage-$page

echo "rescanning pages/$img"
tesseract pages/$img $text -l deu_frak$lang+deu_frak
meld $current $text.txt

read -p 'replace? (y/n)' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff
  echo "replacing...$current"
  mv $text.txt $current
fi
