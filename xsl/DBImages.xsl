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
                exclude-result-prefixes="xd pac"
                version="1.0">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>

	<xd:doc>
		====================================================================
		Stylesheet for resolving image references in DocBook documents.

		It is assumed that document modules refer to image files relative to
		their own location. Therefore, image @filerefs are modified using
		@xml:base to point to the location of the original image relative to
		the assembled document's location.
		====================================================================
	</xd:doc>

	<xd:doc>
		==============
		Main recursion
		==============
	</xd:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*[not(name()='xml:base')]"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="db:imagedata">
		<xsl:copy>
			<xsl:copy-of select="@*[not(name()='xml:base')]"/>
			<xsl:if test="@fileref">
				<xsl:attribute name="fileref">
					<xsl:value-of select="pac:xbase(@fileref)"/>
				</xsl:attribute>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
