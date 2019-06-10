#!/bin/bash

for f in *.pbm
do
  tesseract $f schilling$f -l deu_frakschilling+deu_frak
  cat schilling$f.txt
done
