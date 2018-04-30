import csv, os, sys, urlparse, uuid

sys.path.append(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Common"))
from Common import *

#
#	Connect to Wiki
#

if not MediaWiki.login("nisp11"):
	raise "Login failed!"

#
#	Get current list of standards and related UUIDs
#

oldUUIDs = {}

for entry, oldUUID in ask("[[Category:Standards]][[Is published by::Internet Engineering Task Force]]", "?UUID"):
	oldUUIDs[entry] = oldUUID

#
#	Download dataset if required
#

url = "ftp://ftp.rfc-editor.org/in-notes/rfc-index.xml"
filename = dataFileName("NISP", "Imports", os.path.basename(urlparse.urlparse(url).path))

if not os.path.exists(filename):
	downloadURL(filename, url)

#
#	Parse all entries
#

tree = parse(filename)

for entry in tree.findall(".//{http://www.rfc-editor.org/rfc-index}rfc-entry"):
	docid = entry.find("{http://www.rfc-editor.org/rfc-index}doc-id").fulltext()
	title = entry.find("{http://www.rfc-editor.org/rfc-index}title").fulltext()
	date = entry.find("{http://www.rfc-editor.org/rfc-index}date")
	month = date.find("{http://www.rfc-editor.org/rfc-index}month").fulltext()
	year = date.find("{http://www.rfc-editor.org/rfc-index}year").fulltext()
	status = entry.find("{http://www.rfc-editor.org/rfc-index}current-status").fulltext()
	code = docid[3:]
	editors = []

	for author in entry.findall(".//{http://www.rfc-editor.org/rfc-index}author"):
		editors.append(author.find("{http://www.rfc-editor.org/rfc-index}name").fulltext())

	name = "RFC %s" % code

	text = ("{{Standard\n|uuid=%s\n|code=%s\n|title=%s\n|version=\n|publisher=%s\n|" + \
		"dateissued=%s %s\n|description=\n|lifecycle=%s\n|source=\n|editor=%s\n}}") % \
		   (oldUUIDs.get(name, uuid.uuid4()),
			code,
			title,
			"Internet Engineering Task Force",
			month, year,
			status,
			", ".join(editors))

	print name, text
	updatePage(name, text)

	if name in oldUUIDs:
		del oldUUIDs[name]

	else:
		protectPage(name)

for oldEntry in oldUUIDs.keys():
	print "Deleting [" + oldEntry + "]"
	deletePage(oldEntry)
