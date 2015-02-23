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
                xmlns:func="http://exslt.org/functions"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:pac="urn:x-pacbook:functions"
                xmlns:xl="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="pac func xd"
                extension-element-prefixes="pac func"
                version="1.0">
	<xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/profiling/profile.xsl"/>
	<xsl:include href="common/CommonFunctions.xsl"/>

	<xd:doc>
		==================
		Profile parameters
		==================
		If the root element has a condition attribute, we profile the document by
		condition using the value provided. Otherwise, we profile the document by
		condition using the root document's xml:id attribute. Conditional text in
		transcluded documents can thus be included / ignored based on the xml:id
		(or condition attribute) of the including document.
	</xd:doc>
	<xsl:param name="profile.condition">
		<xsl:choose>
			<xsl:when test="/*/@condition">
				<xsl:value-of select="/*/@condition"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/*/@xml:id"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<xd:doc>
		=========
		Resources
		=========
	</xd:doc>
	<xsl:template match="db:imagedata[starts-with(@fileref, '../')]|db:imagedata[contains(@fileref, '://')]" mode="profile">
		<xsl:choose>
			<xsl:when test="$profile.attribute='outputformat' and $profile.value='help'">
				<xsl:element name="imagedata" namespace="http://docbook.org/ns/docbook">
					<xsl:copy-of select="@*"/>
					<xsl:attribute name="fileref">
						<xsl:value-of select="pac:resource(@fileref, 'resources', '__')"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
