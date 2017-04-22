@echo off

:: Download free ghostscript - https://ghostscript.com/download/gsdnld.html.
::
:: Solution - https://tex.stackexchange.com/a/41273:
::
:: > gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=small.pdf big.pdf
::
:: The level of compression is adjusted by the -dPDFSETTINGS switch:
::
:: -dPDFSETTINGS=/screen   (screen-view-only quality, 72 dpi images)
:: -dPDFSETTINGS=/ebook    (low quality, 150 dpi images)
:: -dPDFSETTINGS=/printer  (high quality, 300 dpi images)
:: -dPDFSETTINGS=/prepress (high quality, color preserving, 300 dpi imgs)
:: -dPDFSETTINGS=/default  (almost identical to /screen)

:: General options:
set tmpdir=tmp
set owner=RakitinMS

:: Files to generate pdfs for:
set cv=%owner%_CV
set jobs=%owner%_jobs
set edu=%owner%_edu
set awards=%owner%_awards
set skills=%owner%_skills
set refs=%owner%_refs
set pubs=%owner%_pubs
set confs=%owner%_confs

:: Create a temp dir if it does not exist:
if not exist %tmpdir% (
    md %tmpdir%
)

:: LaTeX options:
set outdir="--output-directory=%tmpdir%"
set nonstop="-interaction=nonstopmode"

:: GhostScript parameters:
set gs="C:\Program Files\gs\gs9.21\bin\gswin64.exe"
set compatibility=1.4
set quality=printer

setlocal enabledelayedexpansion
for %%b in (%cv% %pubs% %jobs% %edu% %awards% %skills% %refs% %pubs% %confs%) do (
    :: Set loop-dependent variables:
    set texfile=%%b.tex
    set auxfile=%%b.aux
    set pdffile=%%b.pdf
    set finalpdf="%%b.pdf"
    set compressedpdf="%%b_comp.pdf"

    :: Sequence of LaTeX commands from https://tex.stackexchange.com/a/13012.
    :: Solution for the local variables from http://stackoverflow.com/a/13809834/4143531.
    latex %nonstop% %outdir% !texfile!
    bibtex %tmpdir%\!auxfile!
    latex %nonstop% %outdir% !texfile!
    pdflatex -synctex=1 %nonstop% --src-specials %outdir% !texfile!

    :: Copy the resulted file from the temp dir:
    copy /Y %tmpdir%\!pdffile! !finalpdf!

    :: Compress the file:
    %gs% -sDEVICE=pdfwrite -dCompatibilityLevel=%compatibility% -dPDFSETTINGS=/%quality% -dNOPAUSE -dQUIET -dBATCH -q -sOutputFile=!compressedpdf! !finalpdf!
    move /Y !compressedpdf! !finalpdf!
)

pause
