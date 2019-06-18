#!/bin/bash
rm -rf out
mkdir out
mkdir out/joined
dir="$(pwd)"

#deps
sudo apt install texlive-xetex texlive-fonts-recommended

function pagePdf()
{
    #pdf with original image + revised OCR text
    md=$1
    bmd=`basename $md`
    page=${bmd#*schilling}
    #=page-XXX-XYZ
    page=${page:0:12}
    no=${page:5:3}
    img=out/joined/page-$no.img.pdf
    echo "img pdf: $img"
    pdfseparate -f $no -l $no ../johannheinrichj04grolgoog.pdf $img
    echo "ocr pdf: $md"
    pandoc $md --latex-engine=xelatex pdf-meta.yaml -o out/$bmd.pdf
    echo "merging: $img out/$bmd.pdf"
    pdfunite $img out/$bmd.pdf  out/joined/translated-page-$no.pdf
    
    # cleanup single files    
    rm $img
    rm out/$bmd.pdf
}

function uniteChapter()
{
    container="$1"
    for md in `ls -v $container/schilling*.md`
    do
        pagePdf $md
    done
    pages=`ls -v out/joined/translated-page*.pdf`
    echo "book: $pages"
    pdfunite $pages out/$container.pdf
    #cleanup single pages    
    rm $pages
}

#pagePdf book1/schillingpage-080-082.pbm.txt.md

#unite em all...
uniteChapter 0intro
uniteChapter book1

pdfunite out/0intro.pdf out/book1.pdf out/schilling-dasHeimweh.pdf




