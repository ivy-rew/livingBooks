#!/bin/bash
dir="$(pwd)"


function provideSources()
{
    # https://openlibrary.org/books/OL20522092M/
    if ! [ -f mug.pdf ]; then
        wget https://ia600206.us.archive.org/22/items/MuggeridgeMalcolmChroniclesOfWastedTime/Muggeridge%2C%20Malcolm%20-%20Chronicles%20of%20Wasted%20Time.pdf
        ln -s "Muggeridge, Malcolm - Chronicles of Wasted Time.pdf" mug.pdf
    fi
}

provideSources

source ~/dev/booksAlive/bookUtils.sh . mug.pdf
#extractPdfImages
#ocrFractured "eng"


function collectMarkdown2()
{
    book=$bookName.md
    mkdir -p "$bookdir"
    bookfile="$bookdir/$book"
    for text in `ls -v $textdir/*/*.md`
    do
        #skip empty files...
        echo "processing "+$text
        #echo "<div id=\"$text\">" >> "$bookfile"
        cat $text | sed -E 's|^([0-9]+[A-Za-z ]+\|[A-Za-z ]+[0-9]+)|<span class=\"site\">\1</span>|' >> "$bookfile"
        #echo "</div>" >> "$bookfile"
    done
    echo "created $book"
}

#collectMarkdown2
#source ~/booksAlive/pdfProdUtils.sh $dir

function epub()
{
    pandoc --epub-cover-image="$WORK/pages/page-001-000.png" --epub-chapter-level=2 -f markdown -o "$bookdir/mug.epub" "$WORK/meta.md" "$bookdir/mug-html.md"
}

epub
#bookToPDF


