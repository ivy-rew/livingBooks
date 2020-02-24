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

function improveMd()
{
    textIn="$1"
    # sed1: mark titles with a 'pos' style
    # sed2: remove hyphens at the end of the a line
    # sed3: remove section brakes by wrong detected white spaces
    cat "$textIn" \
        | sed -E '0,/^([0-9]{1,3} [A-Z][A-Za-z’? ]+|[A-Z][A-Za-z’? ]+[0-9]{1,3}$)/s||<span class=\"pos\">\1</span>|' \
        | sed ':a;N;$!ba;s/-\n//g' \
        | sed -E ':a;N;$!ba;s/([a-z,])\n\n([a-z])/\1 \2/g'
}


if ! [ "$1" == "test" ]; then
    provideSources
    transformMarkdown
    bookToEPUB './trans/*.md'
    bookToKindle
fi
