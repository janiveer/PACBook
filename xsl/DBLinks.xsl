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
                exclude-result-prefixes="data pac xd"
                version="1.0">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>

	<!-- Parameters -->
	<xsl:param name="docRoot" select="/"/>

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

</xsl:stylesheet>
