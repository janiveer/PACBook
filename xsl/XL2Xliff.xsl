<?xml version="1.0" encoding="UTF-8"?>

<!--
    Copyright © 2015 Stanley Security Solutions Limited.

    This file is part of PACBook.

    PACBook is free software: you can redistribute it and/or modify it under the
    terms of the GNU Lesser General Public License as published by the Free
    Software Foundation, either version 3 of the License, or (at your option)
    any later version.

    PACBook is distributed in the hope that it will be useful, but WITHOUT ANY
    WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
    more details.

    You should have received a copy of the GNU Lesser General Public License
    along with PACBook.  If not, see <http://www.gnu.org/licenses/>.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
                xmlns:html="http://www.w3.org/TR/REC-html40"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns="urn:oasis:names:tc:xliff:document:1.2"
                exclude-result-prefixes="o x ss html xd"
                version="1.0">

	<xd:doc>
     Converts an XLXML file to an XLIFF file.
     Gets header information from the doc properties.
	</xd:doc>

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

	<xsl:template match="/">
		<xliff version="1.2">
			<xsl:apply-templates select="ss:Workbook"/>
		</xliff>
	</xsl:template>

	<xsl:template match="ss:Workbook">
		<file datatype="xml">
			<xsl:apply-templates select="o:CustomDocumentProperties"/>
			<xsl:apply-templates select="o:DocumentProperties"/>
			<xsl:apply-templates select="ss:Worksheet"/>
		</file>
	</xsl:template>

	<xsl:template match="o:CustomDocumentProperties">
		<xsl:apply-templates select="o:Source"/>
		<xsl:apply-templates select="o:Language"/>
		<xsl:apply-templates select="o:Destination"/>
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

	<xsl:template match="o:DocumentProperties">
		<header>
			<note>
				<xsl:apply-templates select="o:Title"/>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="o:Subject"/>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="o:Version"/>
			</note>
		</header>
	</xsl:template>

	<xsl:template match="ss:Worksheet[@ss:Name='Xlate']">
		<body>
			<xsl:apply-templates select="ss:Table"/>
		</body>
	</xsl:template>

	<xsl:template match="ss:Worksheet"/>

	<xsl:template match="ss:Table">
		<xsl:apply-templates select="ss:Row"/>
	</xsl:template>

	<xsl:template match="ss:Row">
		<xsl:if test="not(position() = 1)">
			<trans-unit>
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
			<source>
				<xsl:apply-templates select="ss:Data"/>
			</source>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ss:Cell[3]">
		<xsl:if test="ss:Data">
			<target>
				<xsl:apply-templates select="ss:Data"/>
			</target>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ss:Cell[4]">
		<xsl:if test="ss:Data">
			<note>
				<xsl:apply-templates select="ss:Data"/>
			</note>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ss:Cell"/>

	<xsl:template match="ss:Data|o:Title|o:Subject|o:Version">
		<xsl:value-of select="text()"/>
	</xsl:template>

</xsl:stylesheet>
