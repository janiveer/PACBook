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
                exclude-result-prefixes="db"
                version="1.0">

<!--
     Extracts glossary definitions to a JS file.
-->

	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="EOL" select="'&#x0d;&#x0a;'"/>

	<xsl:template match="/">
		<xsl:apply-templates select="db:glossary"/>
	</xsl:template>

	<xsl:template match="db:glossary">
		<xsl:text>popfont="Frutiger Linotype, 10pt, UTF-8, PLAIN"</xsl:text>
		<xsl:value-of select="$EOL"/>
		<xsl:apply-templates select="db:glossentry"/>
	</xsl:template>

	<xsl:template match="db:glossentry">
		<xsl:value-of select="@xml:id"/>
		<xsl:text>="</xsl:text>
		<xsl:apply-templates select="db:glossdef"/>
		<xsl:text>"</xsl:text>
		<xsl:value-of select="$EOL"/>
	</xsl:template>

	<xsl:template match="db:glossdef">
		<xsl:apply-templates select="db:para"/>
	</xsl:template>

</xsl:stylesheet>
