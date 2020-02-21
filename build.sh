#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source bookUtils.sh . untoCaesar.pdf

# source: https://babel.hathitrust.org/cgi/pt?id=mdp.39015027244600&view=1up&seq=7
# downloader: https://sourceforge.net/projects/hathidownloadhelper/

function noWatermarkImg()
{
    cropDir="./pages"
    mkdir -p $cropDir
    for img in $( ls -v ./images/*.png ); do
        imgName="$(basename "$img")"
        targetFile="$cropDir/$imgName"
        echo "writing $targetFile"
        convert "$img" -crop 1360x2170+0-90 "$targetFile"
    done
}

function provideSources()
{
    if ! [ -d "./pages" ]; then
        noWatermarkImg
    fi

    if ! [ -d "./text" ]; then
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
    for text in `ls -v *.md`
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

        # sed4: remove hyphens at the end of the a line
        # sed5: mark titles with a 'pos' style
        # sed6: remove section brakes by wrong detected white spaces
        cat $text \
          | sed ':a;N;$!ba;s/-\n//g' \
          | sed -E '0,/^([0-9]{1,3} [A-Z][A-Za-z’? ]+|[A-Z][A-Za-z’? ]+[0-9]{1,3}$)/s||<span class=\"pos\">\1</span>|' \
          | sed -E ':a;N;$!ba;s/([a-z,])\n\n([a-z])/\1 \2/g' \
          >> "$target"
    done

    cd "$DIR"
}

function epub()
{
    pandoc \
     --epub-chapter-level=2 \
     --epub-stylesheet="$WORK/style.css" \
     -f markdown -o "$bookdir/$bookName.epub" \
     "$WORK/meta.md" \
     $(ls -v ./trans/*.md)
}

provideSources
transformMarkdown
epub
bookToKindle
