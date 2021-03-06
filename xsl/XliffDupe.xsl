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
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                exclude-result-prefixes="xlf xd"
                version="1.0">

	<xd:doc>
     Purges duplicate translation units from an XLIFF file.
     This is a deterministic deduplication; the stylesheet
     checks for translation units with duplicate IDs, keeps
     the first and discards any others.

     TODO: Check content of translation units with duplicate
     IDs and flag any which have different content.
	</xd:doc>

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

	<xsl:template match="xlf:xliff">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:file"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:file">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="xlf:header"/>
			<xsl:apply-templates select="xlf:body"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:body">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:group|xlf:trans-unit|xlf:bin-unit"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:group">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="xlf:context-group|xlf:count-group|xlf:prop-group|xlf:note"/>
			<xsl:copy-of select="*[not(namespace-uri()='urn:oasis:names:tc:xliff:document:1.2')]"/>
			<xsl:apply-templates select="xlf:group|xlf:trans-unit|xlf:bin-unit"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:trans-unit">
		<xsl:variable name="thisID" select="@id"/>
		<xsl:choose>
			<xsl:when test="preceding-sibling::*/@id=$thisID">
				<!-- Do not copy -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="xlf:bin-unit">
		<xsl:variable name="thisID" select="@id"/>
		<xsl:choose>
			<xsl:when test="preceding-sibling::*/@id=$thisID">
				<!-- Do not copy -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
