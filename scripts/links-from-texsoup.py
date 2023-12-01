import glob

from TexSoup import TexSoup

# Custom links (such as 'mylink') defined via new commands:
new_commands = []
with open("src/header.tex") as hdr:
    soup_hdr = TexSoup(hdr.read())
    new_commands += list(soup_hdr.find_all("newcommand"))

link_names = []
for cmd in new_commands:
    for child in cmd.children:
        if "link" in child.name:
            link_names.append(child.name)

links = []
for file in sorted(glob.glob("**/*.tex", recursive=True)):
    with open(file) as f:
        soup = TexSoup(f.read())
        for link in ["href"] + link_names:
            links += list(soup.find_all(link))

unique_links = []
for i, link in enumerate(links):
    # print(i, link)
    for lt in link.text:
        if lt not in unique_links:
            unique_links.append(lt)

urls = []
for link in unique_links:
    if "http" in link:
        urls.append(link)
        print(link)

# with open("parsed-tex.txt", "w") as f:
#     f.write("\n".join(urls))
