<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:db="http://docbook.org/ns/docbook"
                version="1.1">
	<!--
	     This stylesheet exports various values from the document
	     metadata to an ANT properties file which can then be
	     used by ANT, e.g. to place the document version number
	     into the exported PDF’s file name.
	-->
	<xsl:output method="text" encoding="UTF-8"/>

	<pac:doc>
		=======
		Edition
		=======
	</pac:doc>
	<xsl:template match="/*/db:info/db:edition">
		<xsl:text>edition=</xsl:text>
		<xsl:value-of select="translate(., '.', '')"/>
	</xsl:template>

	<pac:doc>
		=================
		Ignore other text
		=================
	</pac:doc>
	<xsl:template match="text()" />

</xsl:stylesheet>
