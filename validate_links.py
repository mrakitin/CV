import glob
from TexSoup import TexSoup


# Custom links (such as 'mylink') defined via new commands:
new_commands = []
with open('src/header.tex') as hdr:
    soup_hdr = TexSoup(hdr.read())
    new_commands += list(soup_hdr.find_all('newcommand'))

link_names = []
for cmd in new_commands:
    child = next(cmd.children)
    if 'link' in child.name:
        link_names.append(child.name)

links = []
for file in sorted(glob.glob('**/*.tex', recursive=True)):
    with open(file) as f:
        soup = TexSoup(f.read())
        for link in ['href'] + link_names:
            links += list(soup.find_all(link))

unique_links = []
for i, link in enumerate(links):
    print(i, link)
    link_text = next(link.text)
    if link_text not in unique_links:
        unique_links.append(link_text)
