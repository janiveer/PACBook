# PACBook

PACBook is a suite of pre-processing tools for working with XML documentation. It deals
with two inter-related areas:

1. Translating documents;

2. The linguistic consequences of
[transclusion](https://en.wikipedia.org/wiki/Transclusion) and / or [conditional
processing](https://en.wikipedia.org/wiki/Conditional_%28computer_programming%29).

PACBook was originally written for pre-processing [DocBook XML](http://docbook.org/)
files. Parts of it are specific to DocBook 5.0 or later. Most of it is intended for
general use with any XML documentation schema, even SVG images.

## Documentation

For information on each stylesheet, see the
[wiki](https://github.com/STANLEYSecurity/PACBook/wiki) or the Documentation folder.

## Prerequisites

To run PACBook, you need an XSLT processor compatible with [XSLT 1.0 or
1.1](http://www.w3.org/TR/xslt) and [eXSLT](http://exslt.org/). PACBook has been tested
with [XSLTProc](http://xmlsoft.org/libxslt/) and [Saxon
6.5.5](http://saxon.sourceforge.net/saxon6.5.5/).

PACBook is a pre-processor. It doesn’t produce formatted output. You will require third
party processing tools to take the XML that PACBook produces and and turn it into
something meaningful. For example, you can use the [DocBook XSL
stylesheets](http://docbook.sourceforge.net/) to turn a pre-processed DocBook file into
Web help or an ePub file. Or you could use [Apache
Batik](https://xmlgraphics.apache.org/batik/) to render a pre-processed SVG file as PNG
or JPEG.

The stylesheet **DBProfile.xsl** relies on the [DocBook XSL
stylesheets](http://docbook.sourceforge.net/). The stylesheet **RefResolve.xsl** relies
on the [Apache Commons XML Catalog
resolver](https://projects.apache.org/projects/xml_commons_resolver.html).

Finally, to save processing time and bandwidth, you should set up an [XML
catalog](https://www.oasis-open.org/committees/download.php/14809/xml-catalogs.html) so
that your XSLT processor uses local copies of all stylesheets and data files.

[DocBook XSL: The Complete Guide](http://www.sagehill.net/docbookxsl/) by Bob Stayton
contains comprehensive instructions for setting up an XSLT processor, the DocBook XSL
stylesheets, and XML catalog files.

## Installation

Clone the project, or click on **Download Zip** and unzip it to a directory of your
choice.

## Running

Example 1: create an XLIFF diff file using XSLTProc

	xsltproc --stringparam Xliff Current_Translations.de.xliff \
	         --stringparam Language de \
	         --output Changed_Translations.de.xliff \
	         $PACBOOK/xsl/XlateDiff.xsl \
	         My_File.docbook

Example 2: create an XLIFF diff file using Saxon

	java com.icl.saxon.StyleSheet -o Changed_Translations.de.xliff \
	                              My_File.docbook \
	                              $PACBOOK/xsl/XlateDiff.xsl \
	                              Xliff=Current_Translations.de.xliff \
	                              Language=de

## Pipelining

PACBook is a set of small XSLT stylesheets, each of which does one particular job. To use
PACBook most effectively you should chain the stylesheets together so that each
successive stylesheet works on the output of the previous one.

You can use a shell script, batch file or Apache ANT build script to chain stylesheets
together, but the most effective method would be to use an [XProc](http://xproc.org/)
pipeline. More information on this soon.

## License

PACBook is released under the LGPL. See the **LICENSE** file.

PACBook includes code from the XSLT Standard Library project, which is also released
under the LGPL.

## Contributions

Contributions are welcome. In particular, PACBook needs translations and contributions
from linguists for the syntactic dictionaries. Please fork the code and send a pull
request!

## Acknowledgements

Thanks to:

* STANLEY Security for help and support when developing and releasing these tools.

* Edwin Beasant, Peter Crowther, Mina Nielsen for suggestions on licensing.
