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
                xmlns:saxon="http://icl.com/saxon"
                xmlns:dyn="http://exslt.org/dynamic"
                xmlns:set="http://exslt.org/sets"
                xmlns:data="urn:x-pacbook:data"
                exclude-result-prefixes="db xl xlf its xd saxon dyn set data"
                version="1.1">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="no"/>
	<xsl:param name="ITS" select="'its/DocBook.its'"/>
	<xsl:param name="Counter" select="'counter.xml'"/>
	<xsl:param name="Carried" select="'counter.xml'"/>

	<xd:doc>
		=======================================
		Marks up a DocBook file for translation
		=======================================
	</xd:doc>

	<xd:doc>
		=======================================
		Set initial count of translation units
		and prefix for translation unit IDs.
		Assume base uri of $Counter is relative
		to location of input file.
		=======================================
	</xd:doc>
	<xsl:variable name="Initial">
		<xsl:choose>
			<xsl:when test="document($Counter, /)/data:counter">
				<xsl:value-of select="number(document($Counter, /)/data:counter[1])"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="Prefix">
		<xsl:choose>
			<xsl:when test="document($Counter, /)/data:counter[1]/@prefix">
				<xsl:value-of select="document($Counter, /)/data:counter[1]/@prefix"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'u'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xd:doc>
		===============================================================
		Looks in $ITS for selectors to find translatable elements. A
		translatable element is one which is not within text, does not
		already have an @xlf:id, and is not marked as untranslatable.
		In addition, any other element which does not have an @xlf:id
		and is explicitly marked for translation is included. The
		stylesheet then uses the Evaluate function to select the set of
		all translatable elements in the current document.
		===============================================================
	</xd:doc>
	<xsl:template match="/">
		<xsl:variable name="AllSelectors">
			<xsl:for-each select="document($ITS)//its:withinTextRule[@withinText='no']">
				<xsl:value-of select="@selector"/>
				<xsl:text>[not(@xlf:id)][not(@its:translate='no')]|</xsl:text>
			</xsl:for-each>
			<xsl:text>//*[not(@xlf:id)][@its:translate='yes']</xsl:text>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="function-available('dyn:evaluate')">
				<xsl:variable name="AllUnits" select="dyn:evaluate($AllSelectors)"/>
				<xsl:apply-templates select="*|text()|processing-instruction()">
					<xsl:with-param name="AllUnits" select="$AllUnits"/>
				</xsl:apply-templates>
				<xsl:call-template name="Total">
					<xsl:with-param name="AllUnits" select="$AllUnits"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="function-available('saxon:evaluate')">
				<xsl:variable name="AllUnits" select="saxon:evaluate($AllSelectors)"/>
				<xsl:apply-templates select="*|text()|processing-instruction()">
					<xsl:with-param name="AllUnits" select="$AllUnits"/>
				</xsl:apply-templates>
				<xsl:call-template name="Total">
					<xsl:with-param name="AllUnits" select="$AllUnits"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">
					<xsl:text>ERROR: Evaluate function not available.</xsl:text>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc>
		===============================================================
		Recurses through each element. If this element is in the set of
		translatable elements, add an @xlf:id attribute whose value is
		based on the count of preceding translatable elements
		===============================================================
	</xd:doc>
	<xsl:template match="*">
		<xsl:param name="AllUnits"/>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="function-available('set:has-same-node')
				                and function-available('set:leading')">
					<xsl:if test="set:has-same-node($AllUnits, .)">
						<xsl:variable name="Count">
							<xsl:value-of select="$Initial + count(set:leading($AllUnits, .)) + 1"/>
						</xsl:variable>
						<xsl:variable name="Format">
							<xsl:number value="$Count" format="00001"/>
						</xsl:variable>
						<xsl:attribute name="xlf:id">
							<xsl:value-of select="concat($Prefix, $Format)"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()">
						<xsl:with-param name="AllUnits" select="$AllUnits"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message terminate="yes">
						<xsl:text>ERROR: Set functions not available.</xsl:text>
					</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		===================
		Copy other elements
		===================
	</xd:doc>
	<xsl:template match="text()|processing-instruction()|comment()">
		<xsl:copy/>
	</xsl:template>

	<xd:doc>
		====================
		Write out new totals
		====================
	</xd:doc>
	<xsl:template name="Total">
		<xsl:param name="AllUnits"/>
		<xsl:document href="{$Carried}" method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes">
			<data:counter>
				<xsl:attribute name="prefix">
					<xsl:value-of select="$Prefix"/>
				</xsl:attribute>
				<xsl:value-of select="$Initial + count($AllUnits)"/>
			</data:counter>
		</xsl:document>
	</xsl:template>

</xsl:stylesheet>
