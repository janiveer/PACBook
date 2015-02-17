<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:pac="http://www.pac.co.uk"
                version="1.0">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="EOL"><xsl:text>&#x0d;&#x0a;</xsl:text></xsl:param>
	<xsl:param name="Tab"><xsl:text>,</xsl:text></xsl:param>
	<xsl:param name="Lim"><xsl:text>'</xsl:text></xsl:param>
	<pac:doc>
		Outputs an XLIFF file in CSV format.
	</pac:doc>
	<xsl:template match="xlf:xliff">
		<xsl:apply-templates select="xlf:file"/>
	</xsl:template>
	<xsl:template match="xlf:file">
		<xsl:apply-templates select="xlf:body"/>
	</xsl:template>
	<xsl:template match="xlf:body">
		<xsl:apply-templates select="xlf:trans-unit"/>
	</xsl:template>
	<xsl:template match="xlf:trans-unit">
		<xsl:apply-templates select="@id"/>
		<xsl:value-of select="$Tab"/>
		<xsl:apply-templates select="xlf:source"/>
		<xsl:value-of select="$Tab"/>
		<xsl:apply-templates select="xlf:target"/>
		<xsl:value-of select="$Tab"/>
		<xsl:apply-templates select="xlf:note"/>
		<xsl:value-of select="$EOL"/>
	</xsl:template>
	<xsl:template match="@id|xlf:source|xlf:target|xlf:note">
		<xsl:value-of select="$Lim"/>
		<xsl:value-of select="."/>
		<xsl:value-of select="$Lim"/>
	</xsl:template>
</xsl:stylesheet>
