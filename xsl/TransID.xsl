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
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                exclude-result-prefixes="xd"
                version="1.1">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

	<xd:doc>
		=========================================================
		Stylesheet for resolving @xml:id after transclusion.

		Changes @xml:id to @xl:href of nearest locator with
		matching @xl:label.
		=========================================================
	</xd:doc>

	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="@xml:id">
				<xsl:variable name="pac.id" select="@xml:id"/>
				<xsl:variable name="pac.locator" select="ancestor-or-self::*/db:info/db:extendedlink/db:locator[@xl:label=$pac.id]"/>
				<xsl:choose>
					<xsl:when test="$pac.locator">
						<xsl:variable name="pac.href" select="$pac.locator/@xl:href"/>
						<xsl:attribute name="xml:id">
							<xsl:value-of select="substring-after($pac.href, '#')"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="@xml:id"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
