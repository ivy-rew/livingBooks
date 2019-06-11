#!/bin/bash

page=$1
img=page-$page.pbm
lang=$2

current=schillingpage-$page.pbm.txt.md
text=out/schillingpage-$page.pbm

tesseract scanned/$img $text -l deu_frak$lang+deu_frak
meld $current $text.txt

read -p 'replace? (y/n)' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff
  echo "replacing...$current"
  mv $text.txt $current
fi
