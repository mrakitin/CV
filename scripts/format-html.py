import os
import sys

links_file = sys.argv[1]
html_file = f"{os.path.splitext(os.path.basename(links_file))[0]}.html"

print(f"{links_file = }\n{html_file = }")

with open(links_file, "r") as f:
    all_links = f.read()

links_list = all_links.split("\n")

fmtd = """\
<!DOCTYPE html>
<html>
  <head>
    <title>All links</title>
  </head>
  <body>
"""

for link in links_list:
    if link:
        fmtd += f'    <a href="{link}">{link}</a><br>\n'

fmtd += "  </body>\n</html>"

with open(html_file, "w") as f:
    f.write(fmtd)
