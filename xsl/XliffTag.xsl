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
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:ling="http://stanleysecurity.github.io/PACBook/ns/linguistics"
                xmlns:dita="http://dita.oasis-open.org/architecture/2005"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:data="urn:x-pacbook:data"
                xmlns:xx="urn:x-xml-namespace"
                xmlns:nn="urn:x-no-namespace"
                exclude-result-prefixes="xlf xd data"
                version="1.0">

	<xd:doc>
     Turn inline tags into xliff g, x, ph and mrk elements.
	</xd:doc>

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:param name="DefaultNS" select="'http://docbook.org/ns/docbook'"/>

	<xsl:template match="xlf:xliff">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:file"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:file">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="xlf:header"/>
			<xsl:apply-templates select="xlf:body"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:body">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:group|xlf:trans-unit|xlf:bin-unit"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:group">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="xlf:context-group|xlf:count-group|xlf:prop-group|xlf:note"/>
			<xsl:copy-of select="*[not(namespace-uri()='urn:oasis:names:tc:xliff:document:1.2')]"/>
			<xsl:apply-templates select="xlf:group|xlf:trans-unit|xlf:bin-unit"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:trans-unit">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:source|xlf:seg-source|xlf:target[node()]"/>
			<xsl:if test="not(xlf:target/node())">
				<xsl:call-template name="CopyTarget"/>
			</xsl:if>
			<xsl:copy-of select="xlf:context-group|xlf:count-group|xlf:prop-group|xlf:note"/>
			<xsl:apply-templates select="xlf:alt-trans"/>
			<xsl:copy-of select="*[not(namespace-uri()='urn:oasis:names:tc:xliff:document:1.2')]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:alt-trans">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:source|xlf:seg-source|xlf:target"/>
			<xsl:copy-of select="xlf:context-group|xlf:count-group|xlf:prop-group|xlf:note"/>
			<xsl:copy-of select="*[not(namespace-uri()='urn:oasis:names:tc:xliff:document:1.2')]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:bin-unit">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="xlf:source|xlf:seg-source|xlf:target[node()]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="text()|comment()" mode="il">
		<xsl:copy/>
	</xsl:template>

	<xsl:template match="processing-instruction()" mode="il">
		<xsl:variable name="Count">
			<xsl:number count="processing-instruction()" level="multiple" from="xlf:source|xlf:seg-source|xlf:target"/>
		</xsl:variable>
		<xsl:variable name="UnitID">
			<xsl:value-of select="ancestor::xlf:trans-unit/@id"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="text()">
				<ph xmlns="urn:oasis:names:tc:xliff:document:1.2">
					<xsl:attribute name="ctype">
						<xsl:value-of select="concat('x-pi-', local-name())"/>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($UnitID, '.p', $Count)"/>
					</xsl:attribute>
					<xsl:value-of select="text()"/>
				</ph>
			</xsl:when>
			<xsl:when test="self::processing-instruction('linebreak')">
				<x xmlns="urn:oasis:names:tc:xliff:document:1.2" ctype="lb">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($UnitID, '.p', $Count)"/>
					</xsl:attribute>
				</x>
			</xsl:when>
			<xsl:otherwise>
				<x xmlns="urn:oasis:names:tc:xliff:document:1.2">
					<xsl:attribute name="ctype">
						<xsl:value-of select="concat('x-pi-', local-name())"/>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($UnitID, '.p', $Count)"/>
					</xsl:attribute>
				</x>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="il">
		<xsl:variable name="Count">
			<xsl:number count="*" level="multiple" format="1_1_1_1_1" from="xlf:source|xlf:seg-source|xlf:target"/>
		</xsl:variable>
		<xsl:variable name="UnitID">
			<xsl:value-of select="ancestor::xlf:trans-unit/@id"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="*|text()|processing-instruction()|comment()">
				<g xmlns="urn:oasis:names:tc:xliff:document:1.2">
					<xsl:call-template name="SetContentType"/>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($UnitID, '.g', $Count)"/>
					</xsl:attribute>
					<xsl:apply-templates select="@*" mode="at"/>
					<xsl:choose>
						<xsl:when test="@its:term = 'yes'">
							<mrk xmlns="urn:oasis:names:tc:xliff:document:1.2" mtype="term">
								<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
							</mrk>
						</xsl:when>
						<xsl:when test="@its:locNote">
							<mrk xmlns="urn:oasis:names:tc:xliff:document:1.2" mtype="phrase">
								<xsl:attribute name="comment">
									<xsl:value-of select="@its:locNote"/>
								</xsl:attribute>
								<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
							</mrk>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
						</xsl:otherwise>
					</xsl:choose>
				</g>
			</xsl:when>
			<xsl:when test="@dita:conref">
				<ph xmlns="urn:oasis:names:tc:xliff:document:1.2">
					<xsl:call-template name="SetContentType"/>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($UnitID, '.x', $Count)"/>
					</xsl:attribute>
					<xsl:apply-templates select="@*[localname != 'conref']" mode="at"/>
					<xsl:value-of select="@dita:conref"/>
				</ph>
			</xsl:when>
			<xsl:otherwise>
				<x xmlns="urn:oasis:names:tc:xliff:document:1.2">
					<xsl:call-template name="SetContentType"/>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($UnitID, '.x', $Count)"/>
					</xsl:attribute>
					<xsl:apply-templates select="@*" mode="at"/>
				</x>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*" mode="at">
		<xsl:variable name="AttribNS">
			<xsl:choose>
				<xsl:when test="namespace-uri()='http://www.w3.org/XML/1998/namespace'">
					<xsl:value-of select="'urn:x-xml-namespace'"/>
				</xsl:when>
				<xsl:when test="namespace-uri()=''">
					<xsl:value-of select="'urn:x-no-namespace'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="namespace-uri()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="AttribPref">
			<xsl:value-of select="document('data/DataNamespaces.xml')//data:namespace[@uri=$AttribNS]/@prefix"/>
		</xsl:variable>
		<xsl:variable name="AttribName">
			<xsl:value-of select="local-name()"/>
		</xsl:variable>
		<xsl:attribute name="{$AttribPref}:{$AttribName}">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="CopyTarget">
		<target xmlns="urn:oasis:names:tc:xliff:document:1.2" state="new">
			<xsl:for-each select="xlf:source">
				<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
			</xsl:for-each>
		</target>
	</xsl:template>

	<xsl:template name="SetContentType">
		<xsl:variable name="ElementNS">
			<xsl:choose>
				<xsl:when test="namespace-uri()='urn:oasis:names:tc:xliff:document:1.2' or namespace-uri()=''">
					<xsl:value-of select="$DefaultNS"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="namespace-uri()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="ctype">
			<xsl:value-of select="'x-'"/>
			<xsl:value-of select="document('data/DataNamespaces.xml')//data:namespace[@uri=$ElementNS]/@prefix"/>
			<xsl:value-of select="'-'"/>
			<xsl:value-of select="local-name()"/>
		</xsl:attribute>
	</xsl:template>

</xsl:stylesheet>
