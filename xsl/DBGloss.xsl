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

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

	<xsl:param name="maxRecurseDepth" select="8"/>
	<xsl:key name="glossEntry" match="db:glossentry" use="@xml:id"/>

	<xd:doc>
		============================================================
		This stylesheet builds DocBook glossary collections.

		A glossary collection is a glossary which has @role
		set to 'collection'. The glossary must contain a full list
		of glossentries. The stylesheet only copies out those
		glossentries which are referenced within the document.
		============================================================
	</xd:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		============================================================
		Building a collection is a two-step process.

		(1) The stylesheet looks at every glossentry in the current
		glossary. If there is a corresponding glossterm in the
		document, the id is copied to a temporary list of glossids.
		Then the stylesheet recurses through any linked glossary
		entries and adds those to the temporary list also.
		To avoid getting trapped in circular references, it only
		recurses through {$maxRecurseDepth} linked entries.

		(2) Now the stylesheet goes through the current glossary
		and looks at every glossentry again. If there is a
		corresponding gloss id in the temporary list, the
		glossentry is copied to the output.
		============================================================
	</xd:doc>
	<xsl:template match="db:glossary[@role='collection']">
		<xsl:variable name="glossCompile">
			<xsl:for-each select="db:glossentry">
				<xsl:variable name="glossID" select="@xml:id"/>
				<xsl:if test="//db:olink[@type='glossterm'][@targetptr=$glossID] or
				              //db:glossterm[@linkend=$glossID] or
				              //db:glossterm[starts-with(@xl:href, '#')][substring-after(@xl:href, '#')=$glossID]">
					<!-- TODO: glossname, glossdiv -->
					<xsl:value-of select="@xml:id"/>
					<xsl:text>;</xsl:text>
					<xsl:apply-templates select="db:glosssee|db:glossdef" mode="recurse">
						<xsl:with-param name="recurseDepth" select="0"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="*[not(self::db:glossentry)]|processing-instruction()|comment()"/>
			<xsl:for-each select="db:glossentry">
				<xsl:variable name="glossID" select="@xml:id"/>
				<xsl:if test="contains($glossCompile, $glossID)">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		==================
		Glossary recursion
		==================
	</xd:doc>
	<xsl:template match="db:glossdef" mode="recurse">
		<xsl:param name="recurseDepth"/>
		<xsl:apply-templates select="db:glossseealso" mode="recurse">
			<xsl:with-param name="recurseDepth" select="$recurseDepth"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="db:glosssee|db:glossseealso" mode="recurse">
		<xsl:param name="recurseDepth"/>
		<xsl:variable name="glossRef" select="@otherterm"/>
		<xsl:apply-templates select="ancestor::db:glossary//db:glossentry[@xml:id=$glossRef]" mode="recurse">
			<xsl:with-param name="recurseDepth" select="$recurseDepth"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="db:glossentry" mode="recurse">
		<xsl:param name="recurseDepth"/>
		<xsl:if test="$recurseDepth &lt; $maxRecurseDepth">
			<xsl:value-of select="@xml:id"/>
			<xsl:text>;</xsl:text>
			<xsl:apply-templates select="db:glosssee|db:glossdef" mode="recurse">
				<xsl:with-param name="recurseDepth" select="$recurseDepth + 1"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		=================================================
		Adds an xl:title to every glossterm in a document
		containing a preview of that term’s definition.
		=================================================
	</xd:doc>
	<xsl:template match="db:glossterm[@xl:href]|db:glossterm[@linkend]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="not(@xl:title)">
				<xsl:variable name="reference">
					<xsl:if test="@xl:href">
						<xsl:value-of select="substring-after(@xl:href, '#')"/>
					</xsl:if>
					<xsl:if test="@linkend and not(@xl:href)">
						<xsl:value-of select="@linkend"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="definition">
					<xsl:apply-templates select="key('glossEntry', $reference)/db:glossdef"/>
				</xsl:variable>
				<xsl:if test="$definition">
					<xsl:attribute name="xl:title">
						<xsl:value-of select="normalize-space($definition)"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
