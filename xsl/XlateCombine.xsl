<?xml version="1.0" encoding="UTF-8"?>
<!--
     Copies the structure of the source DocBook file.
     When it finds a translateable element, it copies
     in the translated fragments from all specified
     XLIFF files and the special ZXX file to make a
     combined, in-line multi-language translation.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:my="urn:x-pacbook:functions"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="str xlf saxon"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="http://www.jabadaw.com/PAC/xsl/common/CommonFunctions.xsl"/>
	<xsl:key name="xlate" match="xlf:trans-unit" use="@id"/>
	<xsl:param name="Language"/>

	<!-- Set language and content of document -->
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
				<xsl:text>mul</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<!-- Parse child elements of source file -->
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:choose>
			<!-- If the current element is a translateable segment ... -->
			<xsl:when test="@xlf:id and not(@its:translate='no')">
				<xsl:variable name="El" select="local-name()"/>
				<xsl:variable name="Ns" select="namespace-uri()"/>
				<xsl:variable name="Id" select="@xlf:id"/>
				<xsl:variable name="thisNode" select="."/>
				<!-- Create a similar element in the output file -->
				<xsl:message terminate="no">
					<xsl:text>Translating </xsl:text>
					<xsl:value-of select="$El"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="substring('           ', 1, 11 - string-length($El))"/>
					<xsl:value-of select="$Id"/>
				</xsl:message>
				<xsl:copy>
					<xsl:copy-of select="$thisNode/@*"/>
					<!-- Copy the current segment -->
					<xsl:copy-of select="$thisNode/child::node()"/>
					<!-- Get the separator text for this segment -->
					<xsl:variable name="zxxFile" select="my:xliff('zxx')"/>
					<xsl:variable name="zxxText">
						<xsl:choose>
							<xsl:when test="$zxxFile">
								<!-- ... is there a corresponding target in the .XLIFF file? -->
								<xsl:for-each select="document($zxxFile, /)">
									<xsl:choose>
										<xsl:when test="key('xlate', $Id)/xlf:target != ''">
											<xsl:value-of select="key('xlate', $Id)/xlf:target"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text> · </xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text> · </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- For each language ... -->
					<xsl:choose>
						<xsl:when test="function-available('str:tokenize')">
							<xsl:for-each select="str:tokenize($Language, ';')">
								<xsl:call-template name="LangToken">
									<xsl:with-param name="zxxText"  select="$zxxText"/>
									<xsl:with-param name="thisNode" select="$thisNode"/>
									<xsl:with-param name="Id"       select="$Id"/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="function-available('saxon:tokenize')">
							<xsl:for-each select="saxon:tokenize($Language, ';')">
								<xsl:call-template name="LangToken">
									<xsl:with-param name="zxxText"  select="$zxxText"/>
									<xsl:with-param name="thisNode" select="$thisNode"/>
									<xsl:with-param name="Id"       select="$Id"/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message terminate="yes">
								<xsl:text>ERROR: Tokenize function not available.</xsl:text>
							</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:copy>
			</xsl:when>
			<!-- ... or if the current element is non-translateable, just copy it and all
					 its attributes, then recursively parse its children -->
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="LangToken">
		<xsl:param name="zxxText"/>
		<xsl:param name="thisNode"/>
		<xsl:param name="Id"/>
		<xsl:variable name="thisLang" select="."/>
		<!-- Insert the separator text -->
		<xsl:value-of select="$zxxText" disable-output-escaping="yes"/>
		<!-- Find the  .XLIFF file which matches the specified language -->
		<xsl:for-each select="$thisNode">
			<xsl:variable name="Xlate" select="my:xliff($thisLang)"/>
			<!-- ... is the .XLIFF file specified? -->
			<xsl:choose>
				<xsl:when test="$Xlate">
					<!-- ... is there a corresponding target in the .XLIFF file? -->
					<xsl:for-each select="document($Xlate, /)">
						<xsl:choose>
							<xsl:when test="key('xlate', $Id)/xlf:target != ''">
								<xsl:value-of select="key('xlate', $Id)/xlf:target"
								              disable-output-escaping="yes"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="$thisNode/child::node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$thisNode/child::node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
