# Filename: intro_xpath.R (02/12/2016)
# ported to 'xml2' package in Oct 2019

# TO DO: introducing the xpath-syntax

# Author(s): Dr. Jannes Muenchow, Patrick Schratz

# CONTENTS-------------------------------------------------

# ATTACH PACKAGES AND DATA------------------------------------------------------

# attach packages
library("xml2")

# 1 XPATH-----------------------------------------------------------------------

# before we begin, let's have a look at:
browseURL("https://www.w3schools.com/xml/xpath_intro.asp")

# retrieve an XML-example
doc = read_xml("https://www.w3schools.com/xml/books.xml")
class(doc)
# find the root node
root <- xml_root(doc)
class(root)

# name of the root node
xml_name(root)

# get the nodes
children = xml_children(root)
children

# attributes of the root node's children
xml_attrs(children)

# navigating through a XML-document
xml_contents(children[2])

# retrieving the value of a single node (same as above)
# von der root aus gesehen
xml_child(root, 2)

# selecting all title nodes with an attribute named 'lang'
# attributes are queried using "@"
# WICHTIGSTE FUNKTION
xml_find_all(root, "//title[@lang]")

# Selecting all the title elements that have a "lang" attribute with a value of
# "en"
xml_find_all(root, '//title[@lang="en"]')

# Selects all the book elements of the bookstore element that have a price
# element with a value greater than 35.00
xml_find_all(root, '/bookstore/book[price>35.00]')

# Selects all the title elements of the book elements of the bookstore element
# that have a price element with a value greater than 35.00
xml_find_all(root, '/bookstore/book[price>35.00]/title')

# Umwandlung in R lists (mutable with purrr package)
rlist = xml2::as_list(doc)

# in tibble
library(tibble)
a = as_tibble(rlist)