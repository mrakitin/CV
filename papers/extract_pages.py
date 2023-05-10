import os
from collections import OrderedDict
from pathlib import Path

from PyPDF2 import PdfFileReader, PdfFileWriter
from tqdm import tqdm

root_dir = Path(os.path.abspath(os.path.dirname(__file__)))
print("\n\tRoot dir: {}\n".format(root_dir))

pdfs = {
    "2016.10_Mirzaev.pdf": [14],
    "2017.05_Blednykh.pdf": [1],
    "2017.05_Chubar.pdf": [1],
    "2017.05_Davari.pdf": [1],
    "2017.08-01_Idir.pdf": range(2, 3),
    "2017.08-02_Wiegart.pdf": range(2, 3),
    "2017.08-03_Chubar.pdf": range(2, 3),
    "2017.08-04_Chubar.pdf": range(2, 3),
    "2017.08-05_Rakitin.pdf": range(2, 3),
}

pdfs = OrderedDict(sorted(pdfs.items(), reverse=True))

one_file = True
# one_file = False
if one_file:
    output = PdfFileWriter()

for pdf_name, pdf_pages in tqdm(pdfs.items()):
    full_path = root_dir / Path(pdf_name)

    inputpdf = PdfFileReader(open(full_path, "rb"))
    msg = "specified pages range {} is out of range ({})"
    num_pages = inputpdf.numPages
    for page in pdf_pages:
        assert page <= num_pages, msg.format(pdf_name, num_pages)

    n, e = os.path.splitext(full_path)
    pages_range = "-".join([str(x) for x in pdf_pages])
    out_name = "{}_{}{}".format(n, pages_range, e)
    tqdm.write(
        "  Input  file: {} (pages: {} out of total {})".format(
            full_path, pages_range, num_pages
        )
    )

    if not one_file:
        tqdm.write("  Output file: {}".format(out_name))
        output = PdfFileWriter()

    for i in pdf_pages:
        tqdm.write("      Getting page {}...".format(i))
        output.addPage(inputpdf.getPage(i - 1))

    if not one_file:
        with open(out_name, "wb") as oStream:
            output.write(oStream)

    tqdm.write("")

if one_file:
    out_name = "mrakitin_2017_papers.pdf"
    tqdm.write("\n\tOutput file: {}".format(out_name))
    with open(out_name, "wb") as oStream:
        output.write(oStream)
