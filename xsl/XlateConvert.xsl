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
                xmlns:pac="urn:x-pacbook:functions"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:its="http://www.w3.org/2005/11/its"
                exclude-result-prefixes="xlf pac xd"
                version="1.0">

	<xd:doc>
     Copies the structure of the source document.
     When it finds a translateable element, it copies
     in the translated fragment from the $XLATE file.
	</xd:doc>

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>
	<xsl:param name="Language"/>
	<xsl:key name="xlate" match="xlf:trans-unit" use="@id"/>

	<xd:doc>
		Get source language
	</xd:doc>
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

	<xd:doc>
		Get target language
	</xd:doc>
	<xsl:template match="/">
		<xsl:if test="$Language = ''">
			<xsl:message terminate="yes">Please specify $Language: ISO language code.</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="*" mode="root"/>
	</xsl:template>

	<xd:doc>
		Copy root element and attributes
	</xd:doc>
	<xsl:template match="*" mode="root">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="xml:lang">
				<xsl:value-of select="$Language"/>
			</xsl:attribute>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		Copy child elements and attributes. If the current element is marked for translation,
		find the .XLIFF file which matches the specified language. If the .XLIFF file is
		specified, and there is a corresponding target in the .XLIFF file, copy the target
		to the output; otherwise, the current element is untranslated. If the current element
		is non-translatable, recurse.
	</xd:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
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
					<xsl:variable name="Xlate" select="pac:xliff($Language)"/>
					<xsl:choose>
						<xsl:when test="$Xlate">
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
				<xsl:otherwise>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		Copy current element if it cannot be translated
	</xd:doc>
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
