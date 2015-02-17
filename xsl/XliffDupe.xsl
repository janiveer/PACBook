<?xml version="1.0" encoding="UTF-8"?>
<!--
     Purges duplicate translation units from an XLIFF file.
     This is a deterministic deduplication; the stylesheet
     checks for translation units with duplicate IDs, keeps
     the first and discards any others.

     TODO: Check content of translation units with duplicate
     IDs and flag any which have different content.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                exclude-result-prefixes="xlf"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:template match="xlf:xliff">
		<xliff version="1.2" xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:file"/>
		</xliff>
	</xsl:template>
	<xsl:template match="xlf:file">
		<file datatype="xml" xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="xlf:header"/>
			<xsl:apply-templates select="xlf:body"/>
		</file>
	</xsl:template>
	<xsl:template match="xlf:body">
		<body xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:trans-unit"/>
		</body>
	</xsl:template>
	<xsl:template match="xlf:trans-unit">
		<xsl:variable name="thisID" select="@id"/>
		<xsl:choose>
			<xsl:when test="preceding-sibling::xlf:trans-unit/@id=$thisID">
				<!-- Do not copy -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
