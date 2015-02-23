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
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:xl="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="db xd xlf xl its"
                version="1.0">

<!--
     Extracts translation fragments to an XLIFF file.
     Must run XlateMarkup on the Source document first.
-->

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:param name="Source"/>

	<xsl:template match="/">
		<xsl:if test="$Source = ''">
			<xsl:message terminate="yes">
				<xsl:text>Please specify $Source: name of source document.</xsl:text>
			</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="*" mode="root"/>
	</xsl:template>

	<xsl:template match="*" mode="root">
		<xliff version="1.2" xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<file datatype="xml">
				<xsl:attribute name="original">
					<xsl:value-of select="$Source"/>
				</xsl:attribute>
				<xsl:attribute name="source-language">
					<xsl:value-of select="@xml:lang"/>
				</xsl:attribute>
				<header>
					<note>
						<xsl:value-of select="//db:biblioid[@class='pubsnumber']"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="//db:edition"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="//db:releaseinfo"/>
					</note>
				</header>
				<body>
					<xsl:apply-templates select="//*[@xlf:id][not(@its:translate='no')]" mode="unit"/>
				</body>
			</file>
		</xliff>
	</xsl:template>

	<xsl:template match="*[@xlf:id][not(@its:translate='no')]" mode="unit">
		<trans-unit xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:attribute name="id">
				<xsl:value-of select="@xlf:id"/>
			</xsl:attribute>
			<source>
				<xsl:apply-templates select="text()|processing-instruction()|*" mode="span"/>
			</source>
		</trans-unit>
	</xsl:template>
	<xsl:template match="text()" mode="span">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="processing-instruction()" mode="span">
		<xsl:text>&lt;?</xsl:text>
		<xsl:value-of select="name(.)"/>
		<xsl:if test="not(.='')">
			<xsl:text> </xsl:text>
			<xsl:value-of select="."/>
		</xsl:if>
		<xsl:text>?&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="*" mode="span">
		<xsl:choose>
			<xsl:when test="text()|processing-instruction()|*">
				<xsl:text>&lt;</xsl:text>
					<xsl:value-of select="name(.)"/>
					<xsl:apply-templates select="@*" mode="attributes"/>
				<xsl:text>&gt;</xsl:text>
				<xsl:apply-templates select="text()|processing-instruction()|*" mode="span"/>
				<xsl:text>&lt;/</xsl:text>
					<xsl:value-of select="name(.)"/>
				<xsl:text>&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&lt;</xsl:text>
					<xsl:value-of select="name(.)"/>
					<xsl:apply-templates select="@*" mode="attributes"/>
				<xsl:text>/&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*" mode="attributes">
		<xsl:text> </xsl:text>
		<xsl:value-of select="name(.)"/>
		<xsl:text>="</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>"</xsl:text>
	</xsl:template>
</xsl:stylesheet>
