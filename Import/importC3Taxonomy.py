import os, sys, shutil

sys.path.append(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Common"))
from Common import *
sys.path.append(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "MDA"))
from WikiGenerator import *

'''
if not MediaWiki.login("em"):
	raise "Login failed!"

wiki = WikiDownloader("em")
wiki.downloadCategoryPages("ACO Directives", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("ACO Manuals", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("ACT Directives", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("Allied Publications", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("EXTACs", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("Bi-SC Directives", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("MC Documents", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("MCM Documents", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("Other References", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("GEOINT Standards", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("Other Standards", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("XEPs", dataDirName("NISP", "Content", "Pages"))   						#Concept was called "XMPP Extension Protocol"
wiki.downloadCategoryPages("W3C Standards", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("STANAGs", dataDirName("NISP", "Content", "Pages"))						#Concept was called "Standardisation Agreements"
wiki.downloadCategoryPages("RFCs", dataDirName("NISP", "Content", "Pages"))							#Concept was called "Request for Comments"
wiki.downloadCategoryPages("ITU-R Recommendations", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("ITU-T Recommendations", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("Applications", dataDirName("NISP", "Content", "Pages"))
wiki.downloadCategoryPages("Services", dataDirName("NISP", "Content", "Pages"))
'''

if not MediaWiki.login("nisp11"):
	raise "Login failed!"

uploader = WikiUploader()
uploader.uploadPages(dataDirName("NISP", "Content", "Pages"))
