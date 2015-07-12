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
                xmlns:str="http://exslt.org/strings"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:pac="urn:x-pacbook:functions"
                exclude-result-prefixes="str db saxon pac xd"
                version="1.0">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

	<xd:doc>
		========================================================
		Stylesheet for fixing up links after transclusion.

		Fixes up each link destination with pac:fixup().
		========================================================
	</xd:doc>
	<xsl:include href="common/CommonFunctions.xsl"/>
	<xsl:param name="linkRole" select="'http://stanleysecurity.github.io/PACBook/role/link'"/>

	<xd:doc>
		==============
		Main recursion
		==============
	</xd:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="starts-with(@xl:href, '#') and not(self::db:locator)">
				<xsl:call-template name="Fix_XLink"/>
			</xsl:if>
			<xsl:if test="@linkend">
				<xsl:call-template name="Fix_Linkend"/>
			</xsl:if>
			<xsl:if test="@arearefs">
				<xsl:call-template name="Fix_AreaRefs"/>
			</xsl:if>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		==============================
		Fixup simple xlinks using arcs
		==============================
	</xd:doc>
	<xsl:template name="Fix_XLink">
		<xsl:variable name="start.id" select="substring-after(@xl:href, '#')"/>
		<xsl:variable name="fixup.id" select="pac:fixup($start.id, $linkRole)"/>
		<xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink">
			<xsl:text>#</xsl:text>
			<xsl:choose>
				<xsl:when test="$fixup.id">
					<xsl:value-of select="$fixup.id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$start.id"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xd:doc>
		=========================
		Fixup linkends using arcs
		=========================
	</xd:doc>
	<xsl:template name="Fix_Linkend">
		<xsl:variable name="start.id" select="@linkend"/>
		<xsl:variable name="fixup.id" select="pac:fixup($start.id, $linkRole)"/>
		<xsl:attribute name="linkend">
			<xsl:choose>
				<xsl:when test="$fixup.id">
					<xsl:value-of select="$fixup.id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$start.id"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xd:doc>
		=========================
		Fixup arearefs using arcs
		=========================
	</xd:doc>
	<xsl:template name="Fix_AreaRefs">
		<xsl:variable name="pac.arearefs" select="@arearefs"/>
		<xsl:attribute name="arearefs">
			<xsl:choose>
				<xsl:when test="function-available('str:tokenize')">
					<xsl:for-each select="str:tokenize($pac.arearefs, ' ')">
						<xsl:call-template name="Fix_AreaRef">
							<xsl:with-param name="pac.arearefs" select="$pac.arearefs"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="function-available('saxon:tokenize')">
					<xsl:for-each select="saxon:tokenize($pac.arearefs, ' ')">
						<xsl:call-template name="Fix_AreaRef">
							<xsl:with-param name="pac.arearefs" select="$pac.arearefs"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message terminate="yes">
						<xsl:text>ERROR: Tokenize function not available.</xsl:text>
					</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="Fix_AreaRef">
		<xsl:param name="pac.arearefs"/>
		<xsl:variable name="start.id" select="."/>
		<xsl:for-each select="$pac.arearefs">
			<xsl:variable name="fixup.id" select="pac:fixup($start.id, $linkRole)"/>
			<xsl:choose>
				<xsl:when test="$fixup.id">
					<xsl:value-of select="$fixup.id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$start.id"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:if test="position() != last()">
			<xsl:value-of select="' '"/>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
