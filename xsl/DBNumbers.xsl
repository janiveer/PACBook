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
                xmlns:data="urn:x-pacbook:data"
                xmlns:pac="urn:x-pacbook:functions"
                exclude-result-prefixes="data pac xd"
                version="1.0">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>

	<xd:doc>
		===========================================================
		Stylesheet for localising numbers in DocBook documents.

		If the content of the element is a number,
		reformat it using the local number format.
		===========================================================
	</xd:doc>
	<xsl:param name="numberClassRef" select="'http://dbpedia.org/ontology/number'"/>

	<!-- Data -->
	<data:num-form lang="en-GB">#,###.#</data:num-form>
	<data:num-form lang="en-US">#,###.#</data:num-form>
	<data:num-form lang="fr"># ###,#</data:num-form>
	<data:num-form lang="de">#.###,#</data:num-form>
	<data:num-form lang="nl">#.###,#</data:num-form>
	<data:num-form lang="es">#.###,#</data:num-form>
	<data:num-form lang="sv"># ###,#</data:num-form>
	<data:num-form lang="nb"># ###,#</data:num-form>
	<data:num-form lang="pt">#.###,#</data:num-form>
	<data:num-form lang="it">#.###,#</data:num-form>
	<data:num-form lang="fi"># ###,#</data:num-form>
	<data:num-form lang="zh">#,###.#</data:num-form>
	<data:num-form lang="und">#,###.#</data:num-form>
	<data:num-form lang="mul">#,###.#</data:num-form>
	<data:num-form lang="mis">#,###.#</data:num-form>
	<data:num-form lang="zxx">#,###.#</data:num-form>

	<!-- Decimal Formats -->
	<xsl:decimal-format name="en-GB" grouping-separator="," decimal-separator="."/>
	<xsl:decimal-format name="en-US" grouping-separator="," decimal-separator="."/>
	<xsl:decimal-format name="mul"   grouping-separator="," decimal-separator="."/>
	<xsl:decimal-format name="und"   grouping-separator="," decimal-separator="."/>
	<xsl:decimal-format name="mis"   grouping-separator="," decimal-separator="."/>
	<xsl:decimal-format name="zxx"   grouping-separator="," decimal-separator="."/>
	<xsl:decimal-format name="zh"    grouping-separator="," decimal-separator="."/>
	<xsl:decimal-format name="de"    grouping-separator="." decimal-separator=","/>
	<xsl:decimal-format name="nl"    grouping-separator="." decimal-separator=","/>
	<xsl:decimal-format name="es"    grouping-separator="." decimal-separator=","/>
	<xsl:decimal-format name="pt"    grouping-separator="." decimal-separator=","/>
	<xsl:decimal-format name="it"    grouping-separator="." decimal-separator=","/>
	<xsl:decimal-format name="fr"    grouping-separator=" " decimal-separator=","/>
	<xsl:decimal-format name="sv"    grouping-separator=" " decimal-separator=","/>
	<xsl:decimal-format name="nb"    grouping-separator=" " decimal-separator=","/>
	<xsl:decimal-format name="fi"    grouping-separator=" " decimal-separator=","/>

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
		=======
		Numbers
		=======
	</xd:doc>
	<xsl:template match="db:literal">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="string(number(.))='NaN'">
					<xsl:copy-of select="child::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="my.lang" select="pac:lang()"/>
					<xsl:variable name="my.format">
						<xsl:value-of select="document('')//data:num-form[@lang=$my.lang]"/>
					</xsl:variable>
					<xsl:value-of select="format-number(., $my.format, $my.lang)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
