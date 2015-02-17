<?xml version="1.0" encoding="UTF-8"?>
<!--
     Extracts glossary definitions to a JS file.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                exclude-result-prefixes="db"
                version="1.0">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="EOL" select="'&#x0d;&#x0a;'"/>

	<xsl:template match="/">
		<xsl:apply-templates select="db:glossary"/>
	</xsl:template>

	<xsl:template match="db:glossary">
		<xsl:text>popfont="Frutiger Linotype, 10pt, UTF-8, PLAIN"</xsl:text>
		<xsl:value-of select="$EOL"/>
		<xsl:apply-templates select="db:glossentry"/>
	</xsl:template>

	<xsl:template match="db:glossentry">
		<xsl:value-of select="@xml:id"/>
		<xsl:text>="</xsl:text>
		<xsl:apply-templates select="db:glossdef"/>
		<xsl:text>"</xsl:text>
		<xsl:value-of select="$EOL"/>
	</xsl:template>

	<xsl:template match="db:glossdef">
		<xsl:apply-templates select="db:para"/>
	</xsl:template>

</xsl:stylesheet>
