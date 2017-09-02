#!/usr/bin/python

import os
import codecs
import string
import re

def add_viewport(path):
	if not str:
		return

	f_in  = codecs.open(path, 'r', 'utf-8')
	try:
		lines = f_in.readlines()
	except:
		print "error on reading " + path
		raise
	f_in.close()

	# <meta name="viewport" content="width=device-width,initial-scale=1">
	f_out  = codecs.open(path, 'w', 'utf-8')
	for line in lines:
		match1 = re.match(r'<head>\r\n', line, re.IGNORECASE)
		match2 = re.match(r'<meta name="viewport"', line, re.IGNORECASE)
		if match1:
			f_out.write(line)
			f_out.write('<meta name="viewport" content="width=device-width,initial-scale=1">\r\n')
		elif match2:
			pass
		else:
			f_out.write(line)
	f_out.close()

scriptdir = os.path.dirname(os.path.realpath(__file__))
for dirpath, dirnames, filenames in os.walk(scriptdir):
	for file in filenames:
		if file.endswith('.html'):
			path = os.path.join(dirpath, file)
			add_viewport(path)
