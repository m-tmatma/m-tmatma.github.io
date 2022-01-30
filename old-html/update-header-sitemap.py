#!/usr/bin/python

import os
import codecs
import string
import re

def get_meta(path):
	metas = []
	f_in  = codecs.open(path, 'r', 'utf-8')

	try:
		lines = f_in.readlines()
	except:
		print "error on reading " + path
		raise
	f_in.close()

	for line in lines:
		match1 = re.match(r'<meta name="keywords" content="(.*?)"', line, re.IGNORECASE)
		if match1:
			meta = match1.group(1)
			metas.append(meta)

	return metas

def insert_meta(path, metas):
	if not str:
		return

	f_in  = codecs.open(path, 'r', 'utf-8')
	try:
		lines = f_in.readlines()
	except:
		print "error on reading " + path
		raise
	f_in.close()

	firstMeta = False
	f_out  = codecs.open(path, 'w', 'utf-8')
	for line in lines:
		match = re.match(r'<meta name="keywords"', line, re.IGNORECASE)
		if match:
			if firstMeta == False:
				firstMeta = True

				for meta in metas:
					f_out.write(r'<meta name="keywords" content="' + meta + '" />\n')
		else:
			f_out.write(line)
	f_out.close()

metas_hash = {}
scriptdir = os.path.dirname(os.path.realpath(__file__))
for dirpath, dirnames, filenames in os.walk(scriptdir):
	for file in filenames:
		if file.endswith('.html'):
			path = os.path.join(dirpath, file)
			
			metas = get_meta(path)
			for meta in metas:
				metas_hash[meta] = 1

scriptdir = os.path.dirname(os.path.realpath(__file__))
footer_path = os.path.join(scriptdir, 'sitemap-header.txt')

total_metas = metas_hash.keys()
total_metas.sort()
insert_meta(footer_path, total_metas)
