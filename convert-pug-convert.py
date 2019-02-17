import os

def convert_to_pug(htmlfile, pugfile):
	command = "html2pug < %s > %s" % (htmlfile, pugfile)
	print (command)

def convert_from_pug(pugfile):
	command = "pug %s --pretty" % (pugfile)
	print (command)

scriptdir = os.path.dirname(os.path.realpath(__file__))
for dirpath, dirnames, filenames in os.walk(scriptdir):
	for file in filenames:
		if file.endswith('.html'):
			base, ext = os.path.splitext(file)
		
			htmlPath = os.path.join(dirpath, file)
			pugPath  = os.path.join(dirpath, base + ".pug")

			convert_to_pug(htmlPath, pugPath)
			convert_from_pug(pugPath)
