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
                xmlns="http://docbook.org/ns/docbook"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:pac="urn:x-pacbook:functions"
                exclude-result-prefixes="pac xd"
                version="1.0">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>

	<xd:doc>
		===========================================================
		Stylesheet for processing autotext in docbook documents.

		This uses disable-output-escaping to unescape the inline tags from DataLabels.
		This is necessary because of the way TMX escapes inline markup. Saxon supports
		disable-output-escaping only when writing to the final result tree. We know
		that only conjunctions may contain inline markup, so it's only done here.
		All in all, this is hideous. Need to move to XSLT 2.0 to get rid of this.
		===========================================================
	</xd:doc>
	<xsl:template match="/">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

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
		============
		Simple Lists
		============
	</xd:doc>
	<xsl:template match="db:simplelist[@type='inline']">
		<xsl:variable name="Conjunction">
			<xsl:choose>
				<xsl:when test="@role='and' or @role='or'">
					<xsl:text> </xsl:text>
					<xsl:value-of select="pac:label(pac:lang(), @role)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="','"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="db:member">
			<xsl:if test="position() != 1">
				<xsl:choose>
					<xsl:when test="position() = last()">
						<xsl:value-of select="$Conjunction" disable-output-escaping="yes"/>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>, </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
