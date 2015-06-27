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
                xmlns:dita="http://dita.oasis-open.org/architecture/2005"
                xmlns:str="http://exslt.org/strings"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="str db xl saxon dita xd"
                version="1.0">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:strip-space elements="db:resource"/>

	<xsl:param name="defRole" select="'http://docbook.org/docs/transclusion'"/>

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
		==================
		Resolve references
		==================
	</xd:doc>
	<xsl:template match="*[@dita:conref]">
		<xsl:variable name="ref" select="@dita:conref"/>
		<xsl:variable name="def" select="ancestor-or-self::*/db:info/db:extendedlink[@xl:role=$defRole]/db:resource[@xl:label=$ref]"/>
		<xsl:copy>
			<xsl:copy-of select="@*[not(name()='dita:conref')]"/>
			<xsl:choose>
				<xsl:when test="$def != ''">
					<xsl:for-each select="$def[position() = last()]">
						<xsl:copy-of select="*|text()|processing-instruction()|comment()"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message terminate="no">
						<xsl:text>Reference not found: </xsl:text>
						<xsl:value-of select="$ref"/>
					</xsl:message>
					<xsl:comment>
						<xsl:value-of select="$ref"/>
					</xsl:comment>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
