#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bookUtils="$DIR/bookUtils.sh"
if ! [ -f "$bookUtils" ]; then
  curl -L -o "$bookUtils" "https://github.com/ivy-rew/booksAlive/raw/master/bookUtils.sh"
fi
source "$bookUtils" . mug.pdf

function provideSources()
{
    # http://archive.org/details/MuggeridgeMalcolmChroniclesOfWastedTime
    if ! [ -f $pdf ]; then
        wget https://ia600206.us.archive.org/22/items/MuggeridgeMalcolmChroniclesOfWastedTime/Muggeridge%2C%20Malcolm%20-%20Chronicles%20of%20Wasted%20Time.pdf
        ln -s "Muggeridge, Malcolm - Chronicles of Wasted Time.pdf" $pdf
    fi
    if [ ! -d "$DIR/pages" ]; then
        extractPdfImages
    fi
    if [ ! -d "$DIR/text" ]; then
        ocrFractured "eng"
    fi
}

function transformMarkdown()
{
    tdir="$DIR/trans"
    rm -r -v "$tdir"
    mkdir -p "$tdir"
    rm "$bookfile"

    cd "$textdir"
    for text in `ls -v */*.md`
    do
        echo "processing "$text

        parent=$(dirname "$text")
        mkdir -p "$tdir/$parent"
        target="$tdir/$text"

        file=$(basename $text)
        cleaned=$(find "$DIR/clean" -name "$file")
        if ! [ -z "$cleaned" ]; then
            text="$cleaned" #prefer local modified to generated
        fi

        # sed1-3: fix frequent false positives from OCR
        # sed4: remove hyphens at the end of the a line
        # sed5: mark titles with a 'pos' style
        # sed6: remove section brakes by wrong detected white spaces
        cat $text \
          | sed 's/Who Whom? = /Who Whom? /' \
          | sed 's/ ©The Infernal Grove/ The Infernal Grove\n/' \
          | sed 's/The Victor’s Camp = /The Victor’s Camp /' \
          | sed ':a;N;$!ba;s/-\n//g' \
          | sed -E '0,/^([0-9]{1,3} [A-Z][A-Za-z’? ]+|[A-Z][A-Za-z’? ]+[0-9]{1,3}$)/s||<span class=\"pos\">\1</span>|' \
          | sed -E ':a;N;$!ba;s/([a-z,])\n\n([a-z])/\1 \2/g' \
          >> "$target"
    done

    cd "$DIR"
}

function epub()
{
    pandoc --epub-cover-image="$WORK/pages/page-001-000.png" \
     --epub-chapter-level=2 \
     --epub-stylesheet="$WORK/style.css" \
     -f markdown -o "$bookdir/$bookName.epub" \
     "$WORK/meta.md" \
     $(ls -v trans/*/*.md)
}

provideSources
transformMarkdown
epub
bookToKindle
