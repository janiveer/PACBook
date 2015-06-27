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
                exclude-result-prefixes="str db xl saxon xd"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

	<xd:doc>
		==============
		Main recursion
		==============
	</xd:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		==============================
		Fixup simple xlinks using arcs
		==============================
	</xd:doc>
	<xsl:template match="@xl:href[starts-with(., '#')]">
		<xsl:variable name="pac.linkend" select="substring-after(., '#')"/>
		<xsl:variable name="pac.arc" select="ancestor-or-self::*/db:info/db:extendedlink/db:arc[@xl:from=$pac.linkend]"/>
		<xsl:choose>
			<xsl:when test="$pac.arc">
				<xsl:copy>
					<xsl:text>#</xsl:text>
					<xsl:value-of select="$pac.arc/@xl:to"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc>
		=========================
		Fixup linkends using arcs
		=========================
	</xd:doc>
	<xsl:template match="@linkend">
		<xsl:variable name="pac.linkend" select="."/>
		<xsl:variable name="pac.arc" select="ancestor-or-self::*/db:info/db:extendedlink/db:arc[@xl:from=$pac.linkend]"/>
		<xsl:choose>
			<xsl:when test="$pac.arc">
				<xsl:copy>
					<xsl:value-of select="$pac.arc/@xl:to"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc>
		=========================
		Fixup arearefs using arcs
		=========================
	</xd:doc>
	<xsl:template name="@arearefs">
		<xsl:variable name="pac.arearefs" select="."/>
		<xsl:copy>
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
		</xsl:copy>
	</xsl:template>

	<xsl:template name="Fix_AreaRef">
		<xsl:param name="pac.arearefs"/>
		<xsl:variable name="pac.linkend" select="."/>
		<xsl:for-each select="$pac.arearefs">
			<xsl:variable name="pac.arc" select="ancestor-or-self::*/db:info/db:extendedlink/db:arc[@xl:from=$pac.linkend]"/>
			<xsl:choose>
				<xsl:when test="$pac.arc">
					<xsl:value-of select="$pac.arc/@xl:to"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$pac.linkend"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:if test="position() != last()">
			<xsl:value-of select="' '"/>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		================
		Other attributes
		================
	</xd:doc>
	<xsl:template match="@*">
		<xsl:copy-of select="."/>
	</xsl:template>

</xsl:stylesheet>
