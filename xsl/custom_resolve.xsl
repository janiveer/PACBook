<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:resolver="http://xmlresolver.org"
                exclude-result-prefixes="saxon resolver db pac"
                version="1.1">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="no"/>
	<xsl:param name="Target"/>
	<xsl:script language="java"
	            implements-prefix="resolver"
	            src="java:org.apache.xml.resolver.tools.CatalogResolver"/>

	<pac:doc>
		================
		Check parameters
		================
	</pac:doc>
	<xsl:template match="/">
		<xsl:if test="not($Target='images' or $Target='xlate')">
			<xsl:message terminate="yes">$Target must be 'images' or 'xlate'.</xsl:message>
		</xsl:if>
		<xsl:if test="not(function-available('resolver:get-resolved-entity'))">
			<xsl:message terminate="yes">Required Java function not available.</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
	</xsl:template>

	<pac:doc>
		==============
		Main recursion
		==============
	</pac:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:choose>
			<xsl:when test="$Target='xlate' and self::dc:relation">
				<xsl:call-template name="Resolve_Resource"/>
			</xsl:when>
			<xsl:when test="$Target='xlate' and self::dc:source">
				<xsl:call-template name="Resolve_Resource"/>
			</xsl:when>
			<xsl:when test="$Target='images' and self::db:imagedata">
				<xsl:call-template name="Resolve_Fileref"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<pac:doc>
		===================
		Resource resolution
		===================
	</pac:doc>
	<xsl:template name="Resolve_Resource">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="starts-with(@rdf:resource, 'http://')">
				<xsl:attribute name="resource" namespace="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
					<xsl:call-template name="Catalog">
						<xsl:with-param name="URI" select="@rdf:resource"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<pac:doc>
		==================
		FileRef resolution
		==================
	</pac:doc>
	<xsl:template name="Resolve_Fileref">
		<xsl:element name="imagedata" namespace="http://docbook.org/ns/docbook">
			<xsl:copy-of select="@*"/>
			<xsl:if test="starts-with(@fileref, 'http://')">
				<xsl:attribute name="fileref">
					<xsl:call-template name="Catalog">
						<xsl:with-param name="URI" select="@fileref"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
		</xsl:element>
	</xsl:template>

	<pac:doc>
		==============
		Catalog lookup
		==============
	</pac:doc>
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
