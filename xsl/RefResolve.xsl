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
                xmlns:resolver="http://xmlresolver.org"
                exclude-result-prefixes="resolver db xd"
                version="1.1">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="no"/>
	<xsl:script language="java"
	            implements-prefix="resolver"
	            src="java:org.apache.xml.resolver.tools.CatalogResolver"/>

	<xd:doc>
		============================================================
		Stylesheet for resolving arbitrary URIs in XML documents.

		Copies the XML document. By default, if the stylesheet
		finds a db:imagedata element which has a fileref attribute
		containing a URI, the stylesheet resolves the URI against
		an XML catalog.

		You can specify a different target element and attribute
		using the parameters.
		============================================================
	</xd:doc>
	<xsl:param name="ElemNS"   select="'http://docbook.org/ns/docbook'"/>
	<xsl:param name="Elem"     select="'imagedata'"/>
	<xsl:param name="AttribNS" select="''"/>
	<xsl:param name="Attrib"   select="'fileref'"/>

	<xd:doc>
		==============
		Check function
		==============
	</xd:doc>
	<xsl:template match="/">
		<xsl:if test="not(function-available('resolver:get-resolved-entity'))">
			<xsl:message terminate="yes">Required Java function not available.</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
	</xsl:template>

	<xd:doc>
		====================
		Reference resolution
		====================
	</xd:doc>
	<xsl:template match="@*" mode="Ref">
		<xsl:if test="starts-with(., 'http://') or starts-with(., 'https://')">
			<xsl:attribute namespace="{$AttribNS}" name="{$Attrib}">
				<xsl:call-template name="Catalog">
					<xsl:with-param name="URI" select="."/>
				</xsl:call-template>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		==============
		Main recursion
		==============
	</xd:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="namespace-uri()=$ElemNS and local-name()=$Elem">
				<xsl:apply-templates select="@*[namespace-uri()=$AttribNS][local-name()=$Attrib]" mode="Ref"/>
			</xsl:if>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		==============
		Catalog lookup
		==============
	</xd:doc>
	<xsl:template name="Catalog">
		<xsl:param name="URI"/>
		<xsl:variable name="New" select="resolver:new()"/>
		<xsl:variable name="Out" select="resolver:get-resolved-entity($New, '', $URI)"/>
		<xsl:variable name="Result">
			<xsl:choose>
				<xsl:when test="$Out">
					<xsl:value-of select="$Out"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$URI"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="starts-with($Result, 'file:/') and
			                not(starts-with($Result, 'file:///'))">
				<xsl:value-of select="concat('file:///', substring-after($Result, 'file:/'))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$Result"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
