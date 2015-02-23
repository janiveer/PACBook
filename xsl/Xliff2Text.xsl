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
                version="1.0">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="EOL" select="'&#x0d;&#x0a;'"/>
	<xsl:param name="Tab" select="'&#x09;'"/>
	<xd:doc>
		Outputs an XLIFF file to a tab-delimited text file
		with CRLF line endings.
	</xd:doc>
	<xsl:template match="xlf:xliff">
		<xsl:apply-templates select="xlf:file"/>
	</xsl:template>
	<xsl:template match="xlf:file">
		<xsl:text>Message ID</xsl:text>
		<xsl:value-of select="$Tab"/>
		<xsl:value-of select="@source-language"/>
		<xsl:value-of select="$Tab"/>
		<xsl:value-of select="@target-language"/>
		<xsl:value-of select="$EOL"/>
		<xsl:apply-templates select="xlf:body"/>
	</xsl:template>
	<xsl:template match="xlf:body">
		<xsl:apply-templates select="xlf:trans-unit"/>
	</xsl:template>
	<xsl:template match="xlf:trans-unit">
		<xsl:value-of select="@id"/>
		<xsl:value-of select="$Tab"/>
		<xsl:value-of select="xlf:source"/>
		<xsl:value-of select="$Tab"/>
		<xsl:value-of select="xlf:target"/>
		<xsl:value-of select="$EOL"/>
	</xsl:template>
</xsl:stylesheet>
