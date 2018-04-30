import csv, os, rdflib, sys, urlparse, uuid

sys.path.append(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Common"))
from Common import *

#
#	Translation tables
#

statusTable = {
	"WD" : "Working Draft",
	"TRPub" : "Technical Report",
	"REC" : "Recommendation",
	"CR" : "Candidate Recommendation",
	"PR" : "Proposed Recommendation",
	"PER" : "Proposed Edited Recommendation",
	"NOTE" : "Note",
	"Retired" : "Retired"
}

#
#	Download dataset if required
#

url = "http://www.w3.org/2002/01/tr-automation/tr.rdf"
filename = dataFileName("NISP", "Imports", os.path.basename(urlparse.urlparse(url).path))

if not os.path.exists(filename):
	downloadURL(filename, url)

#
#	Connect to Wiki
#

if not MediaWiki.login("nisp11"):
	raise "Login failed!"

#
#	Get current list of standards and related UUIDs
#

oldUUIDs = {}

for entry, oldUUID in ask("[[Category:Cover Documents]][[Publisher::World Wide Web Consortium]]", "?UUID"):
	oldUUIDs[entry] = oldUUID

#
#	Process all entries
#

g = rdflib.graph.Graph()
g.parse(filename)

for s in g.subjects(rdflib.term.URIRef(u"http://purl.org/dc/elements/1.1/title")):
	for o in g.objects(s, rdflib.term.URIRef(u"http://www.w3.org/1999/02/22-rdf-syntax-ns#type")):
		stat = o.split("#")[1]

		if stat in statusTable:
			status = statusTable[stat]

	if status != "Retired":
		title = g.value(s, rdflib.term.URIRef(u"http://purl.org/dc/elements/1.1/title"))
		date = g.value(s, rdflib.term.URIRef(u"http://purl.org/dc/elements/1.1/date"))
		link = s

		editors = []

		for o in g.objects(s, rdflib.term.URIRef(u"http://www.w3.org/2001/02pd/rec54#editor")):
			editors.append(unicode(g.value(o, rdflib.term.URIRef(u"http://www.w3.org/2000/10/swap/pim/contact#fullName"))))

		name = "W3C - %s" % title

		text = "{{Standard\n|uuid=%s\n|title=%s\n|publisher=%s\n|lifecycle=%s\n|dateissued=%s\n|editor=%s\n|link=%s\n}}" % \
			   (oldUUIDs.get(name, uuid.uuid4()),
				title,
				"World Wide Web Consortium",
				status,
				date,
				", ".join(editors),
				link)

		try:
			print name, text
			updatePage(name, text)
		except:
			pass

		if name in oldUUIDs:
			del oldUUIDs[name]

		else:
			protectPage(name)

for oldEntry in oldUUIDs.keys():
	print "Deleting [" + oldEntry + "]"
	deletePage(oldEntry)
