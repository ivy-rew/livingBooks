#!/bin/bash
dir="$(pwd)"

# https://openlibrary.org/books/OL20522092M/
if ! [ -f johannheinrichj04grolgoog.pdf ]; then
    wget https://archive.org/download/johannheinrichj04grolgoog/johannheinrichj04grolgoog.pdf
fi

source ~/booksAlive/bookUtils.sh . johannheinrichj04grolgoog.pdf
extractPdfImages


