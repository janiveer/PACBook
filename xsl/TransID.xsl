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
                xmlns:pac="urn:x-pacbook:functions"
                exclude-result-prefixes="pac xd"
                version="1.1">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

	<xd:doc>
		========================================================
		Stylesheet for fixing up @xml:id after transclusion.

		Fixes up each @xml:id with pac:fixup().
		========================================================
	</xd:doc>
	<xsl:include href="common/CommonFunctions.xsl"/>
	<xsl:param name="idRole" select="'http://stanleysecurity.github.io/PACBook/role/id'"/>

	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="@xml:id">
				<xsl:variable name="start.id" select="@xml:id"/>
				<xsl:variable name="fixup.id" select="pac:fixup($start.id, $idRole)"/>
				<xsl:choose>
					<xsl:when test="$fixup.id">
						<xsl:attribute name="xml:id">
							<xsl:value-of select="$fixup.id"/>
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
