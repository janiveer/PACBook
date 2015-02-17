<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copies the content of the source DocBook file. Adds the
     current language code to the end of all XML:ID, LinkEnd,
     EndTerm, AreaRefs and XL:HRef attributes.

     If you want xrefs or links which will not be fixed up, use
     @xl:href with @xl:role='http://schema.org/significantLink'
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:dita="http://dita.oasis-open.org/architecture/2005"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:str="http://exslt.org/strings"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="str saxon"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:variable name="Lang" select="db:book/@xml:lang|db:article/@xml:lang"/>

	<!-- Root -->
	<xsl:template match="db:book|db:article">
		<xsl:if test="$Lang = ''">
			<xsl:message terminate="yes">Input document has no xml:lang attribute.</xsl:message>
		</xsl:if>
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<!-- Elements -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<!-- Attributes -->
	<xsl:template match="@*">
		<xsl:variable name="Attribute" select="name()"/>
		<xsl:attribute name="{$Attribute}">
			<xsl:choose>
				<xsl:when test="$Attribute='xml:id' or
                        $Attribute='linkend' or
                        $Attribute='endterm' or
                       ($Attribute='xl:href' and
                        not(../@xl:role='http://schema.org/significantLink'))">
					<xsl:value-of select="."/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="$Lang"/>
				</xsl:when>
				<xsl:when test="$Attribute='arearefs'">
					<xsl:choose>
						<xsl:when test="function-available('str:tokenize')">
							<xsl:for-each select="str:tokenize(., ' ')">
								<xsl:call-template name="COToken"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="function-available('saxon:tokenize')">
							<xsl:for-each select="saxon:tokenize(., ' ')">
								<xsl:call-template name="COToken"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message terminate="yes">
								<xsl:text>ERROR: Tokenize function not available.</xsl:text>
							</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
	<xsl:template name="COToken">
		<xsl:value-of select="."/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="$Lang"/>
		<xsl:if test="position() != last()">
			<xsl:value-of select="' '"/>
		</xsl:if>
	</xsl:template>

	<!-- Other nodes -->
	<xsl:template match="text()|processing-instruction()|comment()">
		<xsl:copy-of select="."/>
	</xsl:template>
</xsl:stylesheet>
