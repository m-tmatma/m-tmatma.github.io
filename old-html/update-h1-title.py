#!/usr/bin/python

import os
import codecs
import string
import re


def get_h1(path):
	t1_tag = ""
	f_in  = codecs.open(path, 'r', 'utf-8')

	try:
		lines = f_in.readlines()
	except:
		print "error on reading " + path
		raise

	for line in lines:
		match = re.match(r'<h1>(.*?)</h1>', line, re.IGNORECASE)
		if match:
			t1_tag = match.group(1)
			break

	f_in.close()
	
	if not t1_tag:
		print path

	return t1_tag

def replace_title(path, str):
	if not str:
		return

	f_in  = codecs.open(path, 'r', 'utf-8')
	try:
		lines = f_in.readlines()
	except:
		print "error on reading " + path
		raise
	f_in.close()

	while True:
		match = re.match(r'<.*?>', str)
		if not match:
			break

		str = re.sub(r'<.*?>', "", str)

	f_out  = codecs.open(path, 'w', 'utf-8')
	for line in lines:
		line2 = re.sub(r'<title>(.*?)</title>', r"<title>" + str + r"</title>", line)
		f_out.write(line2)
	f_out.close()

scriptdir = os.path.dirname(os.path.realpath(__file__))
for dirpath, dirnames, filenames in os.walk(scriptdir):
	for file in filenames:
		if file.endswith('.html'):
			path = os.path.join(dirpath, file)
			
			t1_tag = get_h1(path)
			replace_title(path, t1_tag)
