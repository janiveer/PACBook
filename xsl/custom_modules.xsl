<?xml version='1.0'?>

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
                xmlns:vivo="http://vivoweb.org/ontology/core#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:pac="urn:x-pacbook:functions"
                exclude-result-prefixes="xd pac"
                version="1.1">
	<!--
	     Stylesheet for processing modular docbook documents.

	     This stylesheet is called by the XSLT processor using
	     the "xincludes" option so that xincludes are processed.
	     This stylesheet fixes up remote references to translation
	     files, resolves xlink locators and processes release info.
	     The document is then passed to the translation stylesheet.

	     OLinks and ImageData are fixed up after translation.
	-->
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>
	<xsl:include href="common/CommonTemplates.xsl"/>

	<xd:doc>
		===========================
		Recurse through source file
		===========================
	</xd:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:choose>
			<xsl:when test="self::rdf:li and ancestor::vivo:hasTranslation">
				<xsl:call-template name="Fix_Translation"/>
			</xsl:when>
			<xsl:when test="self::db:releaseinfo">
				<xsl:call-template name="Fix_Props"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:if test="@xml:id">
						<xsl:call-template name="Fix_ID"/>
					</xsl:if>
					<xsl:copy-of select="@*[not(name()='xml:id')]"/>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc>
		===================
		Document Properties
		===================
	</xd:doc>
	<xsl:template name="Fix_Props">
		<xsl:variable name="status" select="ancestor-or-self::*[@status][1]/@status"/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="starts-with(., '#Build Number for ANT')">
					<xsl:choose>
						<xsl:when test="$status">
							<xsl:value-of select="pac:uc($status)"/>
							<xsl:if test="contains($status, 'draft')">
								<xsl:text> </xsl:text>
								<xsl:value-of select="substring-before(substring-after(., 'build.number='), '&#10;')"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="''"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		===========
		Translation
		===========
	</xd:doc>
	<xsl:template name="Fix_Translation">
		<rdf:li>
			<xsl:if test="@rdf:resource">
				<xsl:attribute name="rdf:resource">
					<xsl:call-template name="File_Reference">
						<xsl:with-param name="refpath" select="@rdf:resource"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@xml:lang"/>
		</rdf:li>
	</xsl:template>
</xsl:stylesheet>
