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
oldFileNames = {}

for entry, oldUUID, oldFileName in ask("[[Category:Cover Documents]][[Publisher::NATO Standardization Office]]", "?UUID", "?Link"):
	oldUUIDs[entry] = oldUUID
	oldFileNames[entry] = oldFileName

#
#	Download dataset if required
#

url = "https://tide.act.nato.int/em/images/9/90/Stanags.csv"
filename = dataFileName("NISP", "Imports", os.path.basename(urlparse.urlparse(url).path))

if not os.path.exists(filename):
	downloadURL(filename, url)

#
#	Process all entries
#

for row in csv.DictReader(open(filename, "U")):
	if field(row, "STATUS") == "PROMULGATED":
		name = "STANAG %s" % field(row, "STANAG")

		if len(field(row, "PART")):
			name += " " + field(row, "PART")

		text = ("{{Cover Document\n|uuid=%s\n|code=%s\n|title=%s\n|alternativetitle=%s\n|description=%s\n" + \
				"|publisher=%s\n|editor=%s\n|language=%s\n|source=%s\n|status=%s\n|classification=%s\n|link=%s\n}}") % \
			   (oldUUIDs.get(name, uuid.uuid4()),
				"STANAG " + field(row, "STANAG"),
				field(row, "ENGLISH TITLE"),
				"",
				"",
				"NATO Standardization Office",
				field(row, "TASKING AUTHORITY"),
				"",
				"",
				field(row, "STATUS"),
				field(row, "CLASSIFICATION"),
				oldFileNames.get(name, ""),
				)

		print name, text
		updatePage(name, text)

		if name in oldUUIDs:
			del oldUUIDs[name]
			del oldFileNames[name]

		else:
			protectPage(name)

for oldEntry in oldUUIDs.keys():
	print "Deleting [" + oldEntry + "]"
	deletePage(oldEntry)
