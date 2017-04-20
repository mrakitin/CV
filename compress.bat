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

set compressed_file=RakitinMS_CV_compressed.pdf
set original_file=RakitinMS_CV.pdf
set compatibility=1.4
set quality=printer

@echo on
"C:\Program Files\gs\gs9.21\bin\gswin64.exe" -sDEVICE=pdfwrite -dCompatibilityLevel=%compatibility% -dPDFSETTINGS=/%quality% -dNOPAUSE -dQUIET -dBATCH -sOutputFile=%compressed_file% %original_file%

move /Y %compressed_file% %original_file%

pause