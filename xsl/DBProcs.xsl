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
                xmlns="http://docbook.org/ns/docbook"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:pac="urn:x-pacbook:functions"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:bibo="http://purl.org/ontology/bibo/"
                xmlns:vivo="http://vivoweb.org/ontology/core#"
                xmlns:doap="http://usefulinc.com/ns/doap#"
                exclude-result-prefixes="pac xd"
                version="1.0">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>

	<xd:doc>
		============================================================
		Transforms PAC processing instructions in DocBook documents.

		pac-revhistory:    builds revision history table
		pac-applicability: builds applicability table
		pac-pubsnumber:    copy of biblio ID with class pubsnumber
		pac-edition:       copy of edition
		pac-releaseinfo:   copy of document status
		============================================================
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
		================
		Revision History
		================
	</xd:doc>
	<xsl:attribute-set name="pac.revhistory.table">
		<xsl:attribute name="frame">all</xsl:attribute>
		<xsl:attribute name="rowsep">1</xsl:attribute>
		<xsl:attribute name="colsep">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="pac.revhistory.col.version">
		<xsl:attribute name="colwidth">14.5%</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="pac.revhistory.col.date">
		<xsl:attribute name="colwidth">14.5%</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="pac.revhistory.col.author">
		<xsl:attribute name="colwidth">14.5%</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="pac.revhistory.col.detail">
		<xsl:attribute name="colwidth">55.5%</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="processing-instruction('pac-revhistory')">
		<xsl:if test="/*/db:info/db:revhistory">
			<informaltable xsl:use-attribute-sets="pac.revhistory.table">
				<tgroup cols="4">
					<colspec xsl:use-attribute-sets="pac.revhistory.col.version"/>
					<colspec xsl:use-attribute-sets="pac.revhistory.col.date"/>
					<colspec xsl:use-attribute-sets="pac.revhistory.col.author"/>
					<colspec xsl:use-attribute-sets="pac.revhistory.col.detail"/>
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
									<para><xsl:copy-of select="db:revnumber/child::node()"/></para>
								</entry>
								<entry>
									<para><xsl:apply-templates select="db:date"/></para>
								</entry>
								<entry>
									<para><xsl:apply-templates select="db:authorinitials"/></para>
								</entry>
								<entry>
									<para><xsl:copy-of select="db:revremark/child::node()"/></para>
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
	<xsl:attribute-set name="pac.applicability.table">
		<xsl:attribute name="frame">all</xsl:attribute>
		<xsl:attribute name="rowsep">1</xsl:attribute>
		<xsl:attribute name="colsep">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="pac.applicability.col.product">
		<xsl:attribute name="colwidth">19%</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="pac.applicability.col.name">
		<xsl:attribute name="colwidth">27%</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="pac.applicability.col.detail">
		<xsl:attribute name="colwidth">42%</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="pac.applicability.col.version">
		<xsl:attribute name="colwidth">12%</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="processing-instruction('pac-applicability')">
		<xsl:if test="//bibo:Document/vivo:hasSubjectArea">
			<informaltable xsl:use-attribute-sets="pac.applicability.table">
				<tgroup cols="4">
					<colspec xsl:use-attribute-sets="pac.applicability.col.product"/>
					<colspec xsl:use-attribute-sets="pac.applicability.col.name"/>
					<colspec xsl:use-attribute-sets="pac.applicability.col.detail"/>
					<colspec xsl:use-attribute-sets="pac.applicability.col.version"/>
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
		<xsl:value-of select="pac:uc(/*/@status)"/>
		<!-- TODO: Add release info as well -->
	</xsl:template>

</xsl:stylesheet>
