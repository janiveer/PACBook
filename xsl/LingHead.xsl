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
                xmlns:ling="http://stanleysecurity.github.io/PACBook/ns/linguistics"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                exclude-result-prefixes="xd db"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

	<xd:doc>
		===========================================================
		Stylesheet for processing declension in XML documents.

		This stylesheet selects the correct declension of a noun
		based on the case and definiteness specified by the
		nearest ancestor element.
		===========================================================
	</xd:doc>

	<xd:doc>
		==============
		Main recursion
		==============
	</xd:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		==========
		Declension
		==========
	</xd:doc>
	<xsl:template match="db:token|*[@ling:type='head']">
		<xsl:variable name="req.case">
			<xsl:choose>
				<xsl:when test="ancestor::*[@ling:case]">
					<xsl:value-of select="ancestor::*[@ling:case][1]/@ling:case"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'nom'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="req.definiteness">
			<xsl:choose>
				<xsl:when test="ancestor::*[@ling:class]">
					<xsl:value-of select="ancestor::*[@ling:class][1]/@ling:class"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'ind'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="this.case">
			<xsl:choose>
				<xsl:when test="@ling:case">
					<xsl:value-of select="@ling:case"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'nom'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="this.definiteness">
			<xsl:choose>
				<xsl:when test="@ling:class">
					<xsl:value-of select="@ling:class"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'ind'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$this.case != $req.case">
				<!-- NOP -->
			</xsl:when>
			<xsl:when test="$this.definiteness != $req.definiteness">
				<!-- NOP -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
