#!/bin/bash
rm -rf out
mkdir out
dir="$(pwd)"

function collectMarkdown()
{
    $txtBook = "$1"
    for text in `ls -v schilling*.md`
    do
        echo "processing "+$text
        echo "<div id=$text>" >> "$txtBook"
        cat $text >> "$txtBook"
        echo "</div>" >> "$txtBook"
    done
    echo "created $txtBook"
}

cd book1
txtBook="$dir/out/book1.md"
collectMarkdown $txtBoox

cd "$dir"
txtBook="$dir/out/full.md"
collectMarkdown $txtBoox

echo "creating epub"
pandoc -o out/schilling.epub 0-intro.md out/book1.md out/full.md
