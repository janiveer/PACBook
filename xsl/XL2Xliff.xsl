<?xml version="1.0" encoding="UTF-8"?>
<!--
     Converts an XLXML file to an XLIFF file.
     Gets header information from the doc properties.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
                xmlns:html="http://www.w3.org/TR/REC-html40"
                exclude-result-prefixes="o x ss html"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:template match="/">
		<xliff version="1.2" xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:apply-templates select="ss:Workbook"/>
		</xliff>
	</xsl:template>
	<xsl:template match="ss:Workbook">
		<file datatype="xml" xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:apply-templates select="o:CustomDocumentProperties"/>
			<xsl:apply-templates select="ss:Worksheet"/>
		</file>
	</xsl:template>
	<xsl:template match="o:CustomDocumentProperties">
		<xsl:apply-templates select="o:Source"/>
		<xsl:apply-templates select="o:Language"/>
		<xsl:apply-templates select="o:Destination"/>
<!--
				<header>
					<note>
						<xsl:value-of select="//db:biblioid[@class='pubsnumber']"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="//db:edition"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="//db:releaseinfo"/>
					</note>
				</header>
-->
	</xsl:template>
	<xsl:template match="o:Source">
		<xsl:attribute name="original">
			<xsl:value-of select="text()"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="o:Language">
		<xsl:attribute name="source-language">
			<xsl:value-of select="text()"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="o:Destination">
		<xsl:attribute name="target-language">
			<xsl:value-of select="text()"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="ss:Worksheet[@ss:Name='Xlate']">
		<body xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:apply-templates select="ss:Table"/>
		</body>
	</xsl:template>
	<xsl:template match="ss:Table">
		<xsl:apply-templates select="ss:Row"/>
	</xsl:template>
	<xsl:template match="ss:Row">
		<xsl:if test="not(position() = 1)">
			<trans-unit xmlns="urn:oasis:names:tc:xliff:document:1.2">
				<xsl:apply-templates select="ss:Cell"/>
			</trans-unit>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ss:Cell[1]">
		<xsl:if test="ss:Data">
			<xsl:attribute name="id">
				<xsl:apply-templates select="ss:Data"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ss:Cell[2]">
		<xsl:if test="ss:Data">
			<source xmlns="urn:oasis:names:tc:xliff:document:1.2">
				<xsl:apply-templates select="ss:Data"/>
			</source>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ss:Cell[3]">
		<xsl:if test="ss:Data">
			<target xmlns="urn:oasis:names:tc:xliff:document:1.2">
				<xsl:apply-templates select="ss:Data"/>
			</target>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ss:Data">
		<xsl:value-of select="text()"/>
	</xsl:template>
</xsl:stylesheet>
