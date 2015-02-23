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
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                exclude-result-prefixes="xd"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="no"/>
	<xsl:key name="Glossary" match="db:glossentry" use="@xml:id"/>

	<xd:doc>
		=================================================
		Adds an xl:title to every glossterm in a document
		containing a preview of that term’s definition.
		=================================================
	</xd:doc>

	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="db:glossterm[@xl:href]|db:glossterm[@linkend]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="not(@xl:title)">
				<xsl:variable name="Reference">
					<xsl:if test="@xl:href">
						<xsl:value-of select="substring-after(@xl:href, '#')"/>
					</xsl:if>
					<xsl:if test="@linkend and not(@xl:href)">
						<xsl:value-of select="@linkend"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="Definition">
					<xsl:apply-templates select="key('Glossary', $Reference)/db:glossdef"/>
				</xsl:variable>
				<xsl:if test="$Definition">
					<xsl:attribute name="xl:title">
						<xsl:value-of select="normalize-space($Definition)"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
