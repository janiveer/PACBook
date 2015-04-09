<?xml version="1.0" encoding="UTF-8"?>

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
                xmlns:str="http://exslt.org/strings"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:pac="urn:x-pacbook:functions"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                exclude-result-prefixes="str xlf saxon xd pac xd"
                version="1.0">

	<xd:doc>
     Copies the structure of the source DocBook file.
     When it finds a translateable element, it copies
     in the translated fragments from all specified
     XLIFF files and the special ZXX file to make a
     combined, in-line multi-language translation.
	</xd:doc>

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>
	<xsl:key name="xlate" match="xlf:trans-unit" use="@id"/>
	<xsl:param name="Language"/>

	<xd:doc>
		Set language and content of document
	</xd:doc>
	<xsl:template match="/">
		<xsl:if test="$Language = ''">
			<xsl:message terminate="yes">Please specify $Language: ISO language code.</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="*" mode="root"/>
	</xsl:template>

	<xd:doc>
		Root element and attributes
	</xd:doc>
	<xsl:template match="*" mode="root">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="xml:lang">
				<xsl:text>mul</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		Parse child elements of source file. If the current element is a translatable segment,
		create a similar element in the output file, then copy in the content of the current
		segment. Get the separator text for this segment, then parse each of the languages
		specified in the document. If the current element is non-translatable, just copy it
		and all its attributes, then recursively parse its children.
	</xd:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:choose>
			<xsl:when test="@xlf:id and not(@its:translate='no')">
				<xsl:variable name="El" select="local-name()"/>
				<xsl:variable name="Ns" select="namespace-uri()"/>
				<xsl:variable name="Id" select="@xlf:id"/>
				<xsl:variable name="thisNode" select="."/>
				<xsl:message terminate="no">
					<xsl:text>Translating </xsl:text>
					<xsl:value-of select="$El"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="substring('           ', 1, 11 - string-length($El))"/>
					<xsl:value-of select="$Id"/>
				</xsl:message>
				<xsl:copy>
					<xsl:copy-of select="$thisNode/@*"/>
					<xsl:copy-of select="$thisNode/child::node()"/>
					<xsl:variable name="zxxFile" select="pac:xliff('zxx')"/>
					<xsl:variable name="zxxText">
						<xsl:choose>
							<xsl:when test="$zxxFile">
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
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc>
		For each language specified in the document, insert the separator text. Find the
		.XLIFF file which matches the specified language. If the .XLIFF file is specified,
		and there is a corresponding target in the .XLIFF file, copy the target to the output;
		otherwise, the copy the source to the target.
	</xd:doc>
	<xsl:template name="LangToken">
		<xsl:param name="zxxText"/>
		<xsl:param name="thisNode"/>
		<xsl:param name="Id"/>
		<xsl:variable name="thisLang" select="."/>
		<xsl:value-of select="$zxxText" disable-output-escaping="yes"/>
		<xsl:for-each select="$thisNode">
			<xsl:variable name="Xlate" select="pac:xliff($thisLang)"/>
			<xsl:choose>
				<xsl:when test="$Xlate">
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
