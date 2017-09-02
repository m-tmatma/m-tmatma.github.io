#!/usr/bin/python

import os
import codecs
import string
import re
from collections import OrderedDict

class Information():
	def __init__(self, reldir):
		self.reldir = reldir
		self.indexhtml = None
		self.children = OrderedDict()
		self.filelist = []

	def getChild(self, elem):
		if self.children.has_key(elem) == False:
			self.children[elem] = Information(elem)
		return self.children[elem]

	def getElement(self, reldir):
		if reldir == '.':
			return self

		path_elem = re.split(r'[\\/]', reldir)
		current = self
		for elem in path_elem:
			current = current.getChild(elem)
		return current

	def setIndexhtml(self, path):
		self.indexhtml = path

	def insertFile(self, path):
		self.filelist.append(path)

def create_list(scriptdir):
	trees = Information('.')

	for dirpath, dirnames, filenames in os.walk(scriptdir):
		reldir = os.path.relpath(dirpath, scriptdir)

		found = False
		for file in filenames:
			if file.endswith('.html'):
				found = True

		if found:
			current = trees.getElement(reldir)

			for file in filenames:
				if file.endswith('index.html'):
					path = os.path.join(reldir, file)
					current.setIndexhtml(path)

			for file in filenames:
				if file.endswith('index.html'):
					pass
				elif file.endswith('.html'):
					path = os.path.join(reldir, file)
					current.insertFile(path)

	return trees

def get_title(path):
	title = ""
	f_in  = codecs.open(path, 'r', 'utf-8')

	try:
		lines = f_in.readlines()
	except:
		print "error on reading " + path
		raise

	for line in lines:
		match = re.match(r'<title>(.*?)</title>', line, re.IGNORECASE)
		if match:
			title = match.group(1)

	f_in.close()
	return title

def dump_tree(trees, level, f_out):
	f_out.write("\t" * level +  "<!-- start " + str(level) + " -->\n")
	f_out.write("\t" * level +  '<ul>' + '\n')
	if trees.indexhtml:
		title = get_title(trees.indexhtml)
		if not title:
			title = 'empty'
		url = trees.indexhtml.replace('\\', '/')
		f_out.write("\t" * (level + 1) + '<li><a href="' + url + '">' + title + '</a></li>' + '\n')

	if trees.filelist:
		f_out.write("\t" * (level + 1) +  '<ul>' + '\n')
		for path in trees.filelist:
			title = get_title(path)
			if not title:
				title = 'empty'
			url = path.replace('\\', '/')
			f_out.write("\t" * (level + 2) + '<li><a href="' + url + '">' + title + '</a></li>' + '\n')
		f_out.write("\t" * (level + 1) + '</ul>' + '\n')

	for value in trees.children.keys():
		dump_tree(trees.children[value], level + 1, f_out)
	f_out.write("\t" * level + '</ul>' + '\n')
	f_out.write("\t" * level +  "<!-- end " + str(level) + " -->\n")

def read_all_file(path):
	f_in = codecs.open(path, 'r', 'utf-8')
	lines = f_in.readlines()
	f_in.close()
	return lines

scriptdir = os.path.dirname(os.path.realpath(__file__))
sitemapfile = 'sitemap.html'
temporalfile = 'sitemap.txt'
sitemap_path = os.path.join(scriptdir, sitemapfile)
temporal_path = os.path.join(scriptdir, temporalfile)

header = 'sitemap-header.txt'
footer = 'sitemap-footer.txt'
header_path = os.path.join(scriptdir, header)
footer_path = os.path.join(scriptdir, footer)

if os.path.isfile(sitemap_path):
	os.remove(sitemap_path)

trees = create_list(scriptdir)

header_lines = read_all_file(header_path)
footer_lines = read_all_file(footer_path)

f_out  = codecs.open(temporal_path, 'w', 'utf-8')

for line in header_lines:
	f_out.write(line)

dump_tree(trees, 0, f_out)

for line in footer_lines:
	f_out.write(line)

f_out.close()

os.rename(temporal_path, sitemap_path)

