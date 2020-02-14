#!/bin/bash
dir="$(pwd)"

source ~/dev/booksAlive/bookUtils.sh . mug.pdf

function provideSources()
{
    # https://openlibrary.org/books/OL20522092M/
    if ! [ -f $pdf ]; then
        wget https://ia600206.us.archive.org/22/items/MuggeridgeMalcolmChroniclesOfWastedTime/Muggeridge%2C%20Malcolm%20-%20Chronicles%20of%20Wasted%20Time.pdf
        ln -s "Muggeridge, Malcolm - Chronicles of Wasted Time.pdf" $pdf
        provideSources
    fi
}


#extractPdfImages
#ocrFractured "eng"


function collectMarkdown2()
{
    book=$bookName.md
    mkdir -p "$bookdir"
    bookfile="$bookdir/$book"
    rm $bookfile
    for text in `ls -v $textdir/*/*.md`
    do
        #skip empty files...
        echo "processing "+$text
        #echo "<div id=\"$text\">" >> "$bookfile"

        # mark titles with a 'pos' style
        cat $text \
          | sed -E '0,/^([0-9]{1,3} [A-Z][A-Za-z ]+|[A-Z][A-Za-z ]+[0-9]{1,3}$)/s||<span class=\"pos\">\1</span>|' \
          >> "$bookfile"

        #echo "</div>" >> "$bookfile"
    done
    echo "created $book"
}

collectMarkdown2
#source ~/booksAlive/pdfProdUtils.sh $dir


#pandoc --epub-cover-image="$WORK/pages/page-001-000.png" --epub-chapter-level=2 -f markdown -o "$bookdir/mug.epub" "$WORK/meta.md" "$bookdir/mug-html.md"


function epub()
{
    pandoc --epub-cover-image="$WORK/pages/page-001-000.png" \
     --epub-chapter-level=2 \
     --epub-stylesheet="$WORK/style.css" \
     -f markdown -o "$bookdir/mug.epub" \
     "$WORK/meta.md" \
     "$bookdir/mug.md" \
     $(ls -v text/*/*.md)
}

function kindle()
{
    ebook-convert "$bookdir/mug.epub" "$bookdir/mug.azw3"
}

epub
#bookToPDF


