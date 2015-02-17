<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:my="urn:x-pacbook:functions"
                exclude-result-prefixes="pac my"
                version="1.1">
	<!--
	     Stylesheet for processing modular docbook documents.

	     This stylesheet is called by the XSLT processor using
	     the "xincludes" option so that xincludes are processed.
	     This stylesheet fixes up remote references to translation
	     files, resolves xlink locators and processes release info.
	     The document is then passed to the translation stylesheet.

	     OLinks and ImageData are fixed up after translation.
	-->
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="http://www.jabadaw.com/PAC/xsl/common/CommonFunctions.xsl"/>
	<xsl:include href="http://www.jabadaw.com/PAC/xsl/common/CommonTemplates.xsl"/>

	<pac:doc>
		===========================
		Recurse through source file
		===========================
	</pac:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:choose>
			<xsl:when test="self::dc:relation">
				<xsl:call-template name="Fix_Translation"/>
			</xsl:when>
			<xsl:when test="self::db:releaseinfo">
				<xsl:call-template name="Fix_Props"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:if test="@xml:id">
						<xsl:call-template name="Fix_ID"/>
					</xsl:if>
					<xsl:copy-of select="@*[not(name()='xml:id')]"/>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<pac:doc>
		===================
		Document Properties
		===================
	</pac:doc>
	<xsl:template name="Fix_Props">
		<xsl:variable name="status" select="ancestor-or-self::*[@status][1]/@status"/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="starts-with(., '#Build Number for ANT')">
					<xsl:choose>
						<xsl:when test="$status">
							<xsl:value-of select="my:uc($status)"/>
							<xsl:if test="contains($status, 'draft')">
								<xsl:text> </xsl:text>
								<xsl:value-of select="substring-before(substring-after(., 'build.number='), '&#10;')"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="''"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<pac:doc>
		===========
		Translation
		===========
	</pac:doc>
	<xsl:template name="Fix_Translation">
		<xsl:element name="relation" namespace="http://purl.org/dc/elements/1.1/">
			<xsl:if test="@rdf:resource">
				<xsl:attribute name="rdf:resource">
					<xsl:call-template name="File_Reference">
						<xsl:with-param name="refpath" select="@rdf:resource"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@xml:lang"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
