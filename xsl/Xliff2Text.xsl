<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:pac="http://www.pac.co.uk"
                version="1.0">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="EOL" select="'&#x0d;&#x0a;'"/>
	<xsl:param name="Tab" select="'&#x09;'"/>
	<pac:doc>
		Outputs an XLIFF file to a tab-delimited text file
		with CRLF line endings.
	</pac:doc>
	<xsl:template match="xlf:xliff">
		<xsl:apply-templates select="xlf:file"/>
	</xsl:template>
	<xsl:template match="xlf:file">
		<xsl:text>Message ID</xsl:text>
		<xsl:value-of select="$Tab"/>
		<xsl:value-of select="@source-language"/>
		<xsl:value-of select="$Tab"/>
		<xsl:value-of select="@target-language"/>
		<xsl:value-of select="$EOL"/>
		<xsl:apply-templates select="xlf:body"/>
	</xsl:template>
	<xsl:template match="xlf:body">
		<xsl:apply-templates select="xlf:trans-unit"/>
	</xsl:template>
	<xsl:template match="xlf:trans-unit">
		<xsl:value-of select="@id"/>
		<xsl:value-of select="$Tab"/>
		<xsl:value-of select="xlf:source"/>
		<xsl:value-of select="$Tab"/>
		<xsl:value-of select="xlf:target"/>
		<xsl:value-of select="$EOL"/>
	</xsl:template>
</xsl:stylesheet>
