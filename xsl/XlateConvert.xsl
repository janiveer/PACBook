<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copies the structure of the source document.
     When it finds a translateable element, it copies
     in the translated fragment from the $XLATE file.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:my="urn:x-pacbook:functions"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:its="http://www.w3.org/2005/11/its"
                exclude-result-prefixes="xlf my"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="http://www.jabadaw.com/PAC/xsl/common/CommonFunctions.xsl"/>
	<xsl:param name="Language"/>
	<xsl:key name="xlate" match="xlf:trans-unit" use="@id"/>

	<!-- Source language -->
	<xsl:variable name="Source">
		<xsl:choose>
			<xsl:when test="/*/@xml:lang">
				<xsl:value-of select="/*/@xml:lang"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'en-GB'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Target language and content of document -->
	<xsl:template match="/">
		<xsl:if test="$Language = ''">
			<xsl:message terminate="yes">Please specify $Language: ISO language code.</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="*" mode="root"/>
	</xsl:template>

	<!-- Root element and attributes -->
	<xsl:template match="*" mode="root">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="xml:lang">
				<xsl:value-of select="$Language"/>
			</xsl:attribute>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<!-- Child elements and attributes -->
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<!-- If the current element is marked for translation ... -->
				<xsl:when test="@xlf:id and not(@its:translate='no')">
					<xsl:variable name="El" select="local-name()"/>
					<xsl:variable name="Id" select="@xlf:id"/>
					<xsl:variable name="thisNode" select="."/>
					<xsl:variable name="Message">
						<xsl:text>Translating </xsl:text>
						<xsl:value-of select="$El"/>
						<xsl:text>: </xsl:text>
						<xsl:value-of select="substring('           ', 1, 11 - string-length($El))"/>
						<xsl:value-of select="$Id"/>
						<xsl:text> ... </xsl:text>
					</xsl:variable>
					<!-- Find the .XLIFF file which matches the specified language -->
					<xsl:variable name="Xlate" select="my:xliff($Language)"/>
					<!-- ... is the .XLIFF file specified? -->
					<xsl:choose>
						<xsl:when test="$Xlate">
							<!-- ... is there a corresponding target in the .XLIFF file? -->
							<xsl:for-each select="document($Xlate, /)">
								<xsl:choose>
									<xsl:when test="key('xlate', $Id)/xlf:target != ''">
										<xsl:message terminate="no">
											<xsl:value-of select="$Message"/>
											<xsl:text>OK</xsl:text>
										</xsl:message>
										<xsl:value-of select="key('xlate', $Id)/xlf:target" disable-output-escaping="yes"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:message terminate="no">
											<xsl:value-of select="$Message"/>
											<xsl:text>No translation</xsl:text>
										</xsl:message>
										<xsl:call-template name="Untranslated">
											<xsl:with-param name="thisNode" select="$thisNode"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message terminate="no">
								<xsl:value-of select="$Message"/>
								<xsl:text>XLIFF not found</xsl:text>
							</xsl:message>
							<xsl:call-template name="Untranslated">
								<xsl:with-param name="thisNode" select="$thisNode"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- ... or if the current element is non-translateable, recurse -->
				<xsl:otherwise>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<!-- Copy current element if it cannot be translated -->
	<xsl:template name="Untranslated">
		<xsl:param name="thisNode"/>
		<xsl:attribute name="xml:lang">
			<xsl:value-of select="$Source"/>
		</xsl:attribute>
		<xsl:for-each select="$thisNode">
			<xsl:copy-of select="*|text()|processing-instruction()|comment()"/>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
