#!/bin/bash
txtBook=out/full.md
rm -rf out
mkdir out
for text in `ls -v *.md`
do
    echo "processing "+$text
    echo "<div id=$text>" >> "$txtBook"
    cat $text >> "$txtBook"
    echo "</div>" >> "$txtBook"
done
echo "created $txtBook"

echo "creating epub"
pandoc -o out/schilling.epub out/full.md
