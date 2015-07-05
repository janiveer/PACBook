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
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:dita="http://dita.oasis-open.org/architecture/2005"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:ling="http://stanleysecurity.github.io/PACBook/ns/linguistics"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:str="http://exslt.org/strings"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                exclude-result-prefixes="str saxon xd"
                version="1.0">

	<xd:doc>
     Copies the content of the source XML file. Adds the
     current language code to the end of all xml:id and
     xl:href attributes.

     If it’s a DocBook file, also adds the current language
     code to the end of all linkend, endterm and arearefs
     attributes.

     If you want xrefs or links which will not be fixed up, use
     @xl:href with @xl:role='http://schema.org/significantLink'
	</xd:doc>

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:param name="noFixupURI" select="'http://schema.org/significantLink'"/>
	<xsl:variable name="Lang" select="/*/@xml:lang"/>

	<xd:doc>
		Root
	</xd:doc>
	<xsl:template match="/">
		<xsl:if test="$Lang = ''">
			<xsl:message terminate="yes">Input document has no xml:lang attribute.</xsl:message>
		</xsl:if>
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		Elements
	</xd:doc>
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		Attributes
	</xd:doc>
	<xsl:template match="@*">
		<xsl:variable name="Attribute" select="name()"/>
		<xsl:attribute name="{$Attribute}">
			<xsl:choose>
				<xsl:when test="$Attribute='xml:id' or
				                $Attribute='linkend' or
				                $Attribute='endterm' or
				               ($Attribute='xl:href' and
				                not(substring-after(., '#')='') and
				                not(../@xl:role=$noFixupURI))">
					<xsl:value-of select="."/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="$Lang"/>
				</xsl:when>
				<xsl:when test="$Attribute='arearefs'">
					<xsl:choose>
						<xsl:when test="function-available('str:tokenize')">
							<xsl:for-each select="str:tokenize(., ' ')">
								<xsl:call-template name="COToken"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="function-available('saxon:tokenize')">
							<xsl:for-each select="saxon:tokenize(., ' ')">
								<xsl:call-template name="COToken"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message terminate="yes">
								<xsl:text>ERROR: Tokenize function not available.</xsl:text>
							</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
	<xsl:template name="COToken">
		<xsl:value-of select="."/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="$Lang"/>
		<xsl:if test="position() != last()">
			<xsl:value-of select="' '"/>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		Other nodes
	</xd:doc>
	<xsl:template match="text()|processing-instruction()|comment()">
		<xsl:copy-of select="."/>
	</xsl:template>

</xsl:stylesheet>
