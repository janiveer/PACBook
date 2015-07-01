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
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:its="http://www.w3.org/2005/11/its"
                exclude-result-prefixes="xd"
                version="1.0">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

	<xd:doc>
		=============================================================
		Stylesheet for processing abbreviations in DocBook documents.

		Abbreviations should have a full stop afterwards. But there
		should not be two full stops at the end of a sentence.
		=============================================================
	</xd:doc>
	<xsl:param name="abbrevClassRef" select="'http://dbpedia.org/ontology/abbreviation'"/>

	<xd:doc>
		==============
		Main recursion
		==============
	</xd:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		===========
		Punctuation
		===========
	</xd:doc>
	<xsl:template match="db:abbrev|*[@its:taClass=$abbrevClassRef]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="substring(text(), string-length(text())) = '.'">
					<xsl:value-of select="substring(text(), 1, string-length(text())-1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="text()"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="substring(following-sibling::text()[1], 1, 1) != '.'">
				<xsl:text>.</xsl:text>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
