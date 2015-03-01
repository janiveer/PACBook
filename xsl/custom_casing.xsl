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
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:pac="urn:x-pacbook:functions"
                xmlns:str="http://exslt.org/strings"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="pac saxon str xd"
                version="1.1">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="no"/>
	<xsl:include href="common/CommonFunctions.xsl"/>

	<xd:doc>
		===========================================================
		Stylesheet for processing orthography in XML documents.

		This stylesheet sets marked text to the required case:
		upper, lower, title or sentence. The document is then
		passed through for final processing.
		===========================================================
	</xd:doc>

	<xd:doc>
		=========
		Recursion
		=========
		<xd:detail>Recurses through the document and copies each element. If any
		element has the tei:oRef attribute, the respective mode templates are
		applied to change the case of the text nodes in this element and all
		descendent elements.</xd:detail>
	</xd:doc>
	<xsl:template match="*[@tei:oRef='uppercase']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="uc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*[@tei:oRef='lowercase']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="lc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*[@tei:oRef='capitalize']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="tc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*[@tei:oRef='initial']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="sc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		==========
		Upper case
		==========
		<xd:detail>Uses the pac:uc() function to change the case of text nodes to
		upper case. This is applied to text in the current element and all
		descendent elements, unless any descendent elements have a different
		tei:oRef attribute.</xd:detail>
	</xd:doc>
	<xsl:template match="*[@tei:oRef]|processing-instruction()|comment()" mode="uc">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<xsl:template match="*[not(@tei:oRef)]" mode="uc">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="uc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="text()" mode="uc">
		<xsl:value-of select="pac:uc(string(.))"/>
	</xsl:template>

	<xd:doc>
		==========
		Lower case
		==========
		<xd:detail>Uses the pac:lc() function to change the case of text nodes to
		lower case. This is applied to text in the current element and all
		descendent elements, unless any descendent elements have a different
		tei:oRef attribute.</xd:detail>
	</xd:doc>
	<xsl:template match="*[@tei:oRef]|processing-instruction()|comment()" mode="lc">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<xsl:template match="*[not(@tei:oRef)]" mode="lc">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="lc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="text()" mode="lc">
		<xsl:value-of select="pac:lc(string(.))"/>
	</xsl:template>

	<xd:doc>
		==========
		Title case
		==========
		<xd:detail>Splits the text into words (at spaces). If a word is not in the
		$ShortWords list, uses the pac:uc() function to change the first character
		of the word to upper case. This is applied to text nodes in the current
		element and all descendent elements, unless any descendent elements have a
		different tei:oRef attribute.</xd:detail>
	</xd:doc>
	<xsl:template match="*[@tei:oRef]|processing-instruction()|comment()" mode="tc">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<xsl:template match="*[not(@tei:oRef)]" mode="tc">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="tc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="text()" mode="tc">
		<xsl:if test="starts-with(., ' ')">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="function-available('str:tokenize')">
				<xsl:for-each select="str:tokenize(string(.), ' ')">
					<xsl:call-template name="tc_token"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="function-available('saxon:tokenize')">
				<xsl:for-each select="saxon:tokenize(string(.), ' ')">
					<xsl:call-template name="tc_token"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">
					<xsl:text>ERROR: Tokenize function not available.</xsl:text>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="substring(., string-length(.), 1) = ' '">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="tc_token">
		<xsl:choose>
			<xsl:when test="not(contains($ShortWords, .))">
				<xsl:value-of select="pac:uc(substring(., 1, 1))"/>
				<xsl:value-of select="substring(., 2)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="text()"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="position() != last()">
			<xsl:value-of select="' '"/>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		=============
		Sentence case
		=============
		<xd:detail>Finds the first text node child of the current element and uses
		the pac:uc() function to change the first character of the word to upper
		case. The rest of the text nodes in this element and all descendent elements
		are left unchanged, unless any descendent elements have a different tei:oRef
		attribute.</xd:detail>
	</xd:doc>
	<xsl:template match="*[@tei:oRef]|processing-instruction()|comment()" mode="sc">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<xsl:template match="*[not(@tei:oRef)]" mode="sc">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="sc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="text()" mode="sc">
		<xsl:variable name="ID" select="generate-id(ancestor::*[@tei:oRef='initial'])"/>
		<xsl:choose>
			<xsl:when test="preceding::text()[generate-id(ancestor::*[@tei:oRef='initial'])=$ID]">
				<xsl:copy-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="pac:uc(substring(., 1, 1))"/>
				<xsl:value-of select="substring(., 2)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc type="string">
		<xd:short>Short Words</xd:short>
		<xd:detail>List of short words that should not be capitalized in title case
		text. English-only, since English is the only language among the supported
		languages that uses title case.</xd:detail>
	</xd:doc>
	<xsl:param name="ShortWords">
		<xsl:text>about above across after against along among amongst around as aside at before behind below beneath beside besides between beyond but by circa c. ca. down for from in inside into near of off on onto out over per plus pro qua than through throughout till to toward towards under until unto up upon versus vs. v. via with within without the an a this these that those and or but</xsl:text>
	</xsl:param>

</xsl:stylesheet>
