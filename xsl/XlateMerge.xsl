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
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:pac="urn:x-pacbook:functions"
                xmlns:db="http://docbook.org/ns/docbook"
                exclude-result-prefixes="db xlf pac xd its xl"
                version="1.0">

	<xd:doc>
     Searches the source DocBook file and compares it to
     the specified $Xliff file and the specified $Diff file
     to create a new, merged .XLIFF file.
	</xd:doc>

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>
	<xsl:param name="Language" select="''"/>
	<xsl:param name="Xliff" select="''"/>
	<xsl:param name="Diff" select="''"/>
	<xsl:variable name="docRoot" select="/"/>
	<xsl:key name="trans_unit" match="xlf:trans-unit" use="@id"/>

	<xsl:template match="/">
		<xsl:if test="$Language = '' and $Xliff = ''">
			<xsl:message terminate="yes">Please specify $Language or $Xliff.</xsl:message>
		</xsl:if>
		<xsl:if test="$Diff = ''">
			<xsl:message terminate="yes">Please specify $Diff: file name and location.</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="*" mode="root"/>
	</xsl:template>

	<xsl:template match="*" mode="root">
		<xliff version="1.2" xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<file datatype="xml" xmlns="urn:oasis:names:tc:xliff:document:1.2">
				<xsl:attribute name="original">
					<xsl:value-of select="@xml:id"/>
				</xsl:attribute>
				<xsl:attribute name="source-language">
					<xsl:value-of select="@xml:lang"/>
				</xsl:attribute>
				<xsl:attribute name="target-language">
					<xsl:choose>
						<xsl:when test="$Xliff != ''">
							<xsl:value-of select="document($Xliff, /)//xlf:file[1]/@target-language"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$Language"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<header xmlns="urn:oasis:names:tc:xliff:document:1.2">
					<note xmlns="urn:oasis:names:tc:xliff:document:1.2">
						<xsl:value-of select="//db:biblioid[@class='pubsnumber']"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="//db:edition"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="//db:releaseinfo"/>
					</note>
				</header>
				<body xmlns="urn:oasis:names:tc:xliff:document:1.2">
					<xsl:apply-templates select="//*[@xlf:id][not(@its:translate='no')]" mode="unit"/>
				</body>
			</file>
		</xliff>
	</xsl:template>

	<xd:doc>
		Parse child elements of source file. If the current element is marked for translation,
		find the .XLIFF file which matches the specified language. If the .XLIFF file is
		specified, check if there is a corresponding trans-unit in the $Diff file. If the
		corresponding trans-unit is complete, copy it to the output file. Otherwise, check if
		there is there a corresponding trans-unit in the $Xliff file. If there is, copy that
		to the output file. If there is not, do not output the current element.
	</xd:doc>
	<xsl:template match="*[@xlf:id][not(@its:translate='no')]" mode="unit">
		<xsl:variable name="El" select="local-name()"/>
		<xsl:variable name="Id" select="@xlf:id"/>
		<xsl:variable name="LocalSource">
			<xsl:apply-templates select="text()|processing-instruction()|*" mode="span"/>
		</xsl:variable>
		<xsl:variable name="LocalNorm" select="normalize-space($LocalSource)"/>
		<xsl:variable name="Xlate">
			<xsl:choose>
				<xsl:when test="$Xliff != ''">
					<xsl:value-of select="$Xliff"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="pac:xliff($Language)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$Xlate">
				<xsl:variable name="Message">
					<xsl:text>Checking </xsl:text>
					<xsl:value-of select="$El"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="substring('           ', 1, 11 - string-length($El))"/>
					<xsl:value-of select="$Id"/>
					<xsl:text> ... </xsl:text>
				</xsl:variable>
				<xsl:for-each select="document($Diff, /)">
					<xsl:choose>
						<xsl:when test="key('trans_unit', $Id)/xlf:source != ''">
							<xsl:message terminate="no">
								<xsl:value-of select="$Message"/>
								<xsl:text>Merged</xsl:text>
							</xsl:message>
							<xsl:copy-of select="key('trans_unit', $Id)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="document($Xlate, $docRoot)">
								<xsl:choose>
									<xsl:when test="key('trans_unit', $Id)/xlf:source != ''">
										<xsl:message terminate="no">
											<xsl:value-of select="$Message"/>
											<xsl:text>Original</xsl:text>
										</xsl:message>
										<xsl:copy-of select="key('trans_unit', $Id)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:message terminate="no">
											<xsl:value-of select="$Message"/>
											<xsl:text>No translation found!</xsl:text>
										</xsl:message>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">
					<xsl:text>No XLIFF file defined for </xsl:text>
					<xsl:value-of select="$Language"/>
					<xsl:text>.</xsl:text>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
