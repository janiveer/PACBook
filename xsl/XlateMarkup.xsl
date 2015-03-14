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
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:dyn="http://exslt.org/dynamic"
                xmlns:set="http://exslt.org/sets"
                exclude-result-prefixes="db xd its xl dyn set"
                version="1.1">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="no"/>
	<xsl:param name="ITS" select="'its/DocBook.its'"/>
	<xsl:param name="Counter" select="''"/>

	<xd:doc>
		=======================================
		Marks up a DocBook file for translation
		=======================================
	</xd:doc>

	<xsl:variable name="carried">
		<xsl:if test="$Counter = ''">
			<xsl:message terminate="yes">
				<xsl:text>Please specify $Counter: full path to trans-unit counter file.</xsl:text>
			</xsl:message>
		</xsl:if>
		<xsl:value-of select="number(document($Counter)/data:counter[1])"/>
	</xsl:variable>
	<xsl:variable name="prefix">
		<xsl:choose>
			<xsl:when test="document($Counter)/data:counter[1]/@prefix">
				<xsl:value-of select="document($Counter)/data:counter[1]/@prefix"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'u'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="initial">
		<xsl:choose>
			<xsl:when test="$carried = $carried">
				<xsl:value-of select="$carried"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="AllSelectors">
		<xsl:if test="$ITS = ''">
			<xsl:message terminate="yes">
				<xsl:text>Please specify $ITS: full path to ITS file.</xsl:text>
			</xsl:message>
		</xsl:if>
		<xsl:for-each select="document($ITS)//its:withinTextRule">
			<xsl:value-of select="@selector"/>
			<xsl:text>[not(@xlf:id)][not(@its:translate='no')]|</xsl:text>
		</xsl:for-each>
		<xsl:text>//*[not(@xlf:id)][@its:translate='yes']</xsl:text>
	</xsl:variable>
	<xsl:variable name="AllUnits" select="dyn:evaluate($AllSelectors)"/>

	<xd:doc>
		=====================
		Writes out new totals
		=====================
	</xd:doc>
	<xsl:template match="/">
		<xsl:apply-templates select="*|text()|processing-instruction()"/>
		<xsl:variable name="total">
			<xsl:value-of select="count($AllUnits)"/>
		</xsl:variable>
		<xsl:variable name="output">
			<xsl:value-of select="'counter.xml'"/>
		</xsl:variable>
		<xsl:document href="{$output}" method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes">
			<data:counter xmlns:data="urn:x-pacbook:data">
				<xsl:attribute name="prefix">
					<xsl:value-of select="$prefix"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$total = ''">
						<xsl:value-of select="$initial"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$total"/>
					</xsl:otherwise>
				</xsl:choose>
			</data:counter>
		</xsl:document>
	</xsl:template>

	<xd:doc>
		====================================
		Finds unmarked translation units and
		adds @xlf:id based on current count
		====================================
	</xd:doc>
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="set:has-same-node($AllUnits, .)">
				<xsl:variable name="count">
					<xsl:value-of select="$initial + count(set:leading($AllUnits, .)) + 1"/>
				</xsl:variable>
				<xsl:variable name="format">
					<xsl:number value="$count" format="00001"/>
				</xsl:variable>
				<xsl:attribute name="xlf:id">
					<xsl:value-of select="concat($prefix, $format)"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		================================
		Recursion through other elements
		================================
	</xd:doc>
	<xsl:template match="text()|processing-instruction()|comment()">
		<xsl:copy/>
	</xsl:template>

</xsl:stylesheet>
