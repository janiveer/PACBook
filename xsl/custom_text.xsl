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

<!DOCTYPE stylesheet [
	<!ENTITY % xlinkroles
		SYSTEM "http://raw.github.com/STANLEYSecurity/PACBook/master/xsl/xlink-roles.ent">
	%xlinkroles;
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns="http://docbook.org/ns/docbook"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:data="urn:x-pacbook:data"
                xmlns:pac="urn:x-pacbook:functions"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:bibo="http://purl.org/ontology/bibo/"
                xmlns:vivo="http://vivoweb.org/ontology/core#"
                xmlns:doap="http://usefulinc.com/ns/doap#"
                exclude-result-prefixes="data pac xd"
                version="1.0">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>

	<!-- Parameters -->
	<xsl:param name="docRoot" select="/"/>
	<xsl:param name="MaxRecurseDepth" select="8"/>

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
		===========================================================
		Stylesheet for processing autotext in docbook documents.

		This stylesheet creates the titles for admonitions
		and builds glossary collections. The document is then
		passed through for morphosyntactic processing.
		===========================================================
	</xd:doc>
	<xsl:template match="/">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

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
		=============
		Related Links
		=============
		If a section of the document contains an extended link
		with @xl:role='http://schema.org/relatedLink', this template
		looks at the label(s) specified by the arc elements; finds
		other sections which contain an extended link with
		@xl:role='http://schema.org/isPartOf' and which in turn
		contains a resource element with the same label; and then
		creates a list of links to those other sections.

		If the extended link contains an xlink title element,
		that element is used as the title of the list of links.
		Otherwise the phrase called 'PAC.Links' is used as the title
		of the list of links in the appropriate language.
	</xd:doc>
	<xsl:template match="db:chapter|db:section|db:sect1|db:sect2|db:sect3|db:sect4">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="db:title|db:subtitle|db:titleabbrev|db:info|db:para|db:formalpara|db:equation|db:informalequation|db:mediaobject|db:mediaobjectco|db:figure|db:informalfigure|db:screen|db:programlisting|db:indexterm|db:itemizedlist|db:orderedlist|db:simplelist|db:calloutlist|db:variablelist|db:segmentedlist|db:glosslist|db:qandaset|db:bridgehead|db:procedure|db:informaltable|db:table|db:informalexample|db:example|db:important|db:caution|db:note|db:tip|db:warning|db:sidebar|processing-instruction()|comment()"/>
			<xsl:if test="db:info/&xl_link;">
				<para>
					<xsl:choose>
						<xsl:when test="db:info/&xl_link;/*[@xl:type='title']">
							<xsl:apply-templates select="db:info/&xl_link;/*[@xl:type='title']/node()"/>
						</xsl:when>
						<xsl:when test="db:info/&xl_link;/db:title">
							<xsl:apply-templates select="db:info/&xl_link;/db:title/node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="pac:label(pac:lang(), 'links')"/>
						</xsl:otherwise>
					</xsl:choose>
				</para>
				<xsl:for-each select="db:info/&xl_link;/db:arc">
					<xsl:variable name="Link_To" select="@xl:to"/>
					<itemizedlist>
						<xsl:for-each select="$docRoot//*[db:info/&xl_part;/db:resource[@xl:label=$Link_To]]">
							<xsl:variable name="Link_ID" select="@xml:id"/>
							<listitem>
								<para>
									<xref>
										<xsl:attribute name="linkend">
											<xsl:value-of select="$Link_ID"/>
										</xsl:attribute>
										<xsl:attribute name="xrefstyle">
											<xsl:value-of select="'select: pacref title'"/>
										</xsl:attribute>
									</xref>
								</para>
							</listitem>
						</xsl:for-each>
					</itemizedlist>
				</xsl:for-each>
			</xsl:if>
			<xsl:apply-templates select="db:section|db:sect1|db:sect2|db:sect3|db:sect4|db:simplesect"/>
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

	<xd:doc>
		=======
		Numbers
		=======
		If the content of the element is a number,
		reformat it using the local number format.
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
						<xsl:value-of select="document('data/DataFormats.xml')//data:num-form[@lang=$my.lang]"/>
					</xsl:variable>
					<xsl:value-of select="format-number(., $my.format, $my.lang)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		========
		Glossary
		========
		A glossary collection is a glossary which has @role
		set to 'collection'. The glossary must contain a full list
		of glossentries. The stylesheet only copies out those
		glossentries which are referenced within the document.

		Building a collection is a two-step process. (1) The
		stylesheet looks at every glossentry in the current
		glossary. If there is a corresponding glossterm in the
		document, the id is copied to a temporary list of glossids.
		Then the stylesheet recurses through any linked glossary
		entries and adds those to the temporary list also.
		To avoid getting trapped in circular references, it only
		recurses through {$MaxRecurseDepth} linked entries.
		(2) Now the stylesheet goes through the current glossary
		and looks at every glossentry again. If there is a
		corresponding gloss id in the temporary list, the
		glossentry is copied to the output.
	</xd:doc>
	<xsl:template match="db:glossary[@role='collection']">
		<xsl:variable name="glossCompile">
			<xsl:for-each select="db:glossentry">
				<xsl:variable name="glossID" select="@xml:id"/>
				<xsl:if test="//db:olink[@type='glossterm'][@targetptr=$glossID] or //db:glossterm[@linkend=$glossID] or //db:glossterm[starts-with(@xl:href, '#')][substring-after(@xl:href, '#')=$glossID]">
					<!-- TODO: glossname -->
					<xsl:value-of select="@xml:id"/>
					<xsl:text>;</xsl:text>
					<xsl:apply-templates select="db:glosssee|db:glossdef" mode="recurse">
						<xsl:with-param name="RecurseDepth" select="0"/>
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
		<xsl:param name="RecurseDepth"/>
		<xsl:apply-templates select="db:glossseealso" mode="recurse">
			<xsl:with-param name="RecurseDepth" select="$RecurseDepth"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="db:glosssee|db:glossseealso" mode="recurse">
		<xsl:param name="RecurseDepth"/>
		<xsl:variable name="glossRef" select="@otherterm"/>
		<xsl:apply-templates select="ancestor::db:glossary//db:glossentry[@xml:id=$glossRef]" mode="recurse">
			<xsl:with-param name="RecurseDepth" select="$RecurseDepth"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="db:glossentry" mode="recurse">
		<xsl:param name="RecurseDepth"/>
		<xsl:if test="$RecurseDepth &lt; $MaxRecurseDepth">
			<xsl:value-of select="@xml:id"/>
			<xsl:text>;</xsl:text>
			<xsl:apply-templates select="db:glosssee|db:glossdef" mode="recurse">
				<xsl:with-param name="RecurseDepth" select="$RecurseDepth + 1"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		===========
		Punctuation
		===========
	</xd:doc>
	<xsl:template match="db:abbrev">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="substring(text(), string-length(text())) = '.'">
					<xsl:value-of select="substring(text(), 1, string-length(text())-1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="text()"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="substring(following-sibling::text()[1], 1, 1)!='.'">
				<xsl:text>.</xsl:text>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		============
		Simple Lists
		============
		This uses disable-output-escaping to unescape the inline tags from DataLabels.
		This is necessary because of the way TMX escapes inline markup. Saxon supports
		disable-output-escaping only when writing to the final result tree. We know
		that only conjunctions may contain inline markup, so it's only done here.
		All in all, this is hideous. Need to move to XSLT 2.0 to get rid of this.
	</xd:doc>
	<xsl:template match="db:simplelist[@type='inline']">
		<xsl:variable name="Conjunction">
			<xsl:choose>
				<xsl:when test="@role='and' or @role='or'">
					<xsl:text> </xsl:text>
					<xsl:value-of select="pac:label(pac:lang(), @role)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="','"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="db:member">
			<xsl:if test="position() != 1">
				<xsl:choose>
					<xsl:when test="position() = last()">
						<xsl:value-of select="$Conjunction" disable-output-escaping="yes"/>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>, </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:for-each>
	</xsl:template>

	<xd:doc>
		================
		Revision History
		================
	</xd:doc>
	<xsl:template match="processing-instruction('pac-revhistory')">
		<xsl:if test="/*/db:info/db:revhistory">
			<informaltable frame="all" rowsep="1" colsep="1">
				<tgroup cols="4">
					<colspec colwidth="14.5%"/>
					<colspec colwidth="14.5%"/>
					<colspec colwidth="14.5%"/>
					<colspec colwidth="55.5%"/>
					<thead>
						<row>
							<entry>
								<para><xsl:value-of select="pac:label(pac:lang(), 'version')"/></para>
							</entry>
							<entry>
								<para><xsl:value-of select="pac:label(pac:lang(), 'date')"/></para>
							</entry>
							<entry>
								<para><xsl:value-of select="pac:label(pac:lang(), 'author')"/></para>
							</entry>
							<entry>
								<para><xsl:value-of select="pac:label(pac:lang(), 'detail')"/></para>
							</entry>
						</row>
					</thead>
					<tbody>
						<xsl:for-each select="/*/db:info/db:revhistory/db:revision">
							<row>
								<entry>
									<para><xsl:apply-templates select="db:revnumber"/></para>
								</entry>
								<entry>
									<para><xsl:apply-templates select="db:date"/></para>
								</entry>
								<entry>
									<para><xsl:apply-templates select="db:authorinitials"/></para>
								</entry>
								<entry>
									<para><xsl:apply-templates select="db:revremark"/></para>
								</entry>
							</row>
						</xsl:for-each>
					</tbody>
				</tgroup>
			</informaltable>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		=============
		Applicability
		=============
	</xd:doc>
	<xsl:template match="processing-instruction('pac-applicability')">
		<xsl:if test="//bibo:Document/vivo:hasSubjectArea">
			<informaltable frame="all" rowsep="1" colsep="1">
				<tgroup cols="4">
					<colspec colwidth="19%"/>
					<colspec colwidth="27%"/>
					<colspec colwidth="42%"/>
					<colspec colwidth="12%"/>
					<thead>
						<row>
							<entry>
								<para><xsl:value-of select="pac:label(pac:lang(), 'product')"/></para>
							</entry>
							<entry>
								<para><xsl:value-of select="pac:label(pac:lang(), 'name')"/></para>
							</entry>
							<entry>
								<para><xsl:value-of select="pac:label(pac:lang(), 'detail')"/></para>
							</entry>
							<entry>
								<para><xsl:value-of select="pac:label(pac:lang(), 'version')"/></para>
							</entry>
						</row>
					</thead>
					<tbody>
						<xsl:for-each select="//bibo:Document/vivo:hasSubjectArea/rdf:Bag/rdf:li">
							<row>
								<entry>
									<para><xsl:copy-of select="doap:shortdesc/child::node()"/></para>
								</entry>
								<entry>
									<para><xsl:copy-of select="doap:name/child::node()"/></para>
								</entry>
								<entry>
									<para><xsl:copy-of select="doap:description/child::node()"/></para>
								</entry>
								<entry>
									<para><xsl:copy-of select="doap:revision/child::node()"/></para>
								</entry>
							</row>
						</xsl:for-each>
					</tbody>
				</tgroup>
			</informaltable>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		=============================
		Other processing instructions
		=============================
	</xd:doc>
	<xsl:template match="processing-instruction('pac-pubsnumber')">
		<xsl:value-of select="/*/db:info/db:biblioid[@class='pubsnumber']"/>
	</xsl:template>
	<xsl:template match="processing-instruction('pac-edition')">
		<xsl:value-of select="/*/db:info/db:edition"/>
	</xsl:template>
	<xsl:template match="processing-instruction('pac-releaseinfo')">
		<xsl:value-of select="/*/db:info/db:releaseinfo"/>
	</xsl:template>

</xsl:stylesheet>
