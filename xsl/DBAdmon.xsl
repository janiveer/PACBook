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
                xmlns:pac="urn:x-pacbook:functions"
                exclude-result-prefixes="pac xd"
                version="1.0">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>

	<xd:doc>
		===========================================================
		Creates automatic titles for DocBook admonitions.
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
		=========
		Important
		=========
	</xd:doc>
	<xsl:template match="db:title[parent::db:important]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="child::node()">
					<xsl:copy-of select="child::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="pac:label(pac:lang(), 'important')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		=======
		Caution
		=======
	</xd:doc>
	<xsl:template match="db:title[parent::db:caution]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="child::node()">
					<xsl:copy-of select="child::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="pac:label(pac:lang(), 'caution')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		====
		Note
		====
	</xd:doc>
	<xsl:template match="db:title[parent::db:note]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="child::node()">
					<xsl:copy-of select="child::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="AdLang" select="pac:lang()"/>
					<xsl:choose>
						<xsl:when test="count(parent::db:note//db:para) &gt; 1">
							<xsl:value-of select="pac:label($AdLang, 'notes')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="pac:label($AdLang, 'note')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		===
		Tip
		===
	</xd:doc>
	<xsl:template match="db:title[parent::db:tip]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="child::node()">
					<xsl:copy-of select="child::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="AdLang" select="pac:lang()"/>
					<xsl:choose>
						<xsl:when test="count(parent::db:tip//db:para) &gt; 1">
							<xsl:value-of select="pac:label($AdLang, 'tips')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="pac:label($AdLang, 'tip')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		=======
		Warning
		=======
	</xd:doc>
	<xsl:template match="db:title[parent::db:warning]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="child::node()">
					<xsl:copy-of select="child::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="pac:label(pac:lang(), 'warning')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
