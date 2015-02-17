<?xml version="1.0" encoding="UTF-8"?>
<!--
     Turn escaped tags in XLIFF segments into real tags.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                exclude-result-prefixes="xlf"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:template match="xlf:xliff">
		<xliff xmlns="urn:oasis:names:tc:xliff:document:1.2"
           xmlns:db="http://docbook.org/ns/docbook"
           xmlns:xi="http://www.w3.org/2001/XInclude"
           xmlns:xl="http://www.w3.org/1999/xlink"
           xmlns:tei="http://www.tei-c.org/ns/1.0"
           xmlns:dita="http://dita.oasis-open.org/architecture/2005"
           xmlns:its="http://www.w3.org/2005/11/its"
           version="1.2">
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
		<trans-unit xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:source|xlf:target|xlf:note"/>
		</trans-unit>
	</xsl:template>
	<xsl:template match="xlf:source">
		<source xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="text()" disable-output-escaping="yes"/>
		</source>
	</xsl:template>
	<xsl:template match="xlf:target">
		<target xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="text()" disable-output-escaping="yes"/>
		</target>
	</xsl:template>
	<xsl:template match="xlf:note">
		<note xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="text()" disable-output-escaping="yes"/>
		</note>
	</xsl:template>
</xsl:stylesheet>
