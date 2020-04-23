#!/bin/bash

# General options:
tmpdir='tmp'
owner='RakitinMS'

# Files to generate pdfs for:
cv="${owner}_CV"
jobs="${owner}_jobs"
edu="${owner}_edu"
awards="${owner}_awards"
skills="${owner}_skills"
refs="${owner}_refs"
pubs="${owner}_pubs"
confs="${owner}_confs"
bio="${owner}_bio"

# Create a temp dir if it does not exist:
if [ ! -d "$tmpdir" ]; then
    mkdir $tmpdir
fi

# LaTeX options:
outdir="-output-directory=$tmpdir"
nonstop="-interaction=nonstopmode"

# GhostScript parameters:
# gs="ghostscript"
gs="gs"  # on Mac
compatibility="1.4"
quality="printer"

for b in $cv $pubs $jobs $edu $awards $skills $refs $pubs $confs $bio; do
    texfile="${b}.tex"
    auxfile="${b}.aux"
    pdffile="${b}.pdf"
    finalpdf="${b}.pdf"
    compressedpdf="${b}_comp.pdf"

    # Sequence of LaTeX commands from https://tex.stackexchange.com/a/13012.
    latex $nonstop $outdir $texfile
    bibtex ${tmpdir}/${auxfile}
    latex $nonstop $outdir $texfile
    pdflatex -synctex=1 --src-specials $nonstop $outdir $texfile

    # Copy the resulted file from the temp dir:
    cp -fv ${tmpdir}/${pdffile} $finalpdf

    # Compress the file:
    $gs -sDEVICE=pdfwrite -dCompatibilityLevel=$compatibility -dPDFSETTINGS=/$quality -dNOPAUSE -dQUIET -dBATCH -q -sOutputFile=$compressedpdf $finalpdf
    mv -fv $compressedpdf $finalpdf
done
