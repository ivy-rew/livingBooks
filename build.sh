#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source bookUtils.sh . storyOfAChild.pdf

# source: https://babel.hathitrust.org/cgi/pt?id=hvd.hxdh1g&view=1up&seq=31
# downloader: https://sourceforge.net/projects/hathidownloadhelper/

function pdfPagesToImg()
{
    imagesDir="images"
    if ! [ -d ${imagesDir} ]; then
        mkdir ${imagesDir}
        for pdf in $( ls -v ./pdfs/*.pdf ); do
            p=$(echo "${pdf}" | sed 's|pdfs/hvd.hxdh1g_||')
            pdfimages -png -p $pdf ${imagesDir}/$p
        done
    fi
}

function noWatermarkImg()
{
    cropDir="./pages"
    if ! [ -d ${cropDir} ]; then
        mkdir -p $cropDir
        for img in $( ls -v ./images/*000.png ); do
            cp $img $cropDir
        done
    fi
}

function provideSources()
{
    noWatermarkImg

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
