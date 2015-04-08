<?xml version="1.0" encoding="UTF-8"?>

<!--
    Copyright © 2015 Stanley Security Solutions Delimiterited.

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
	<xsl:param name="EOL"><xsl:text>&#x0d;&#x0a;</xsl:text></xsl:param>
	<xsl:param name="Separator"><xsl:text>&#x09;</xsl:text></xsl:param>
	<xsl:param name="Delimiter"><xsl:text>'</xsl:text></xsl:param>
	<xsl:param name="Header" select="false()"/>

	<xd:doc>
		Outputs an XLIFF file to a delimited text file.
	</xd:doc>

	<xsl:template match="xlf:xliff">
		<xsl:apply-templates select="xlf:file"/>
	</xsl:template>

	<xsl:template match="xlf:file">
		<xsl:if test="boolean($Header)">
			<xsl:value-of select="$Delimiter"/>
			<xsl:text>ID</xsl:text>
			<xsl:value-of select="$Delimiter"/>
			<xsl:value-of select="$Separator"/>
			<xsl:value-of select="$Delimiter"/>
			<xsl:value-of select="@source-language"/>
			<xsl:value-of select="$Delimiter"/>
			<xsl:value-of select="$Separator"/>
			<xsl:value-of select="$Delimiter"/>
			<xsl:value-of select="@target-language"/>
			<xsl:value-of select="$Delimiter"/>
			<xsl:value-of select="$Separator"/>
			<xsl:value-of select="$Delimiter"/>
			<xsl:text>Note</xsl:text>
			<xsl:value-of select="$Delimiter"/>
			<xsl:value-of select="$EOL"/>
		</xsl:if>
		<xsl:apply-templates select="xlf:body"/>
	</xsl:template>

	<xsl:template match="xlf:body">
		<xsl:apply-templates select="xlf:group|xlf:trans-unit"/>
	</xsl:template>

	<xsl:template match="xlf:group">
		<xsl:apply-templates select="xlf:group|xlf:trans-unit"/>
	</xsl:template>

	<xsl:template match="xlf:trans-unit">
		<xsl:apply-templates select="@id"/>
		<xsl:value-of select="$Separator"/>
		<xsl:apply-templates select="xlf:source"/>
		<xsl:value-of select="$Separator"/>
		<xsl:apply-templates select="xlf:target"/>
		<xsl:value-of select="$Separator"/>
		<xsl:apply-templates select="xlf:note"/>
		<xsl:value-of select="$EOL"/>
	</xsl:template>

	<xsl:template match="@id|xlf:source|xlf:target|xlf:note">
		<xsl:value-of select="$Delimiter"/>
		<xsl:value-of select="."/>
		<xsl:value-of select="$Delimiter"/>
	</xsl:template>

</xsl:stylesheet>
