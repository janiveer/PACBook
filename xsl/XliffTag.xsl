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
                xmlns:dita="http://dita.oasis-open.org/architecture/2005"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                exclude-result-prefixes="xlf xd"
                version="1.0">

	<xd:doc>
     Turn inline tags into xliff g, x, ph and mrk elements.
	</xd:doc>

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

	<xsl:template match="xlf:xliff">
		<xliff xmlns="urn:oasis:names:tc:xliff:document:1.2"
           xmlns:db="http://docbook.org/ns/docbook"
           xmlns:xi="http://www.w3.org/2001/XInclude"
           xmlns:xl="http://www.w3.org/1999/xlink"
           xmlns:tei="http://www.tei-c.org/ns/1.0"
           xmlns:dita="http://dita.oasis-open.org/architecture/2005"
           xmlns:its="http://www.w3.org/2005/11/its"
           version="1.2">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:file"/>
		</xliff>
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
			<xsl:apply-templates select="xlf:trans-unit"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:trans-unit">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:source|xlf:target"/>
			<xsl:if test="not(xlf:target/node())">
				<xsl:call-template name="target"/>
			</xsl:if>
			<xsl:apply-templates select="xlf:note"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:source">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:target[node()]">
		<xsl:copy>
			<xsl:copy-of select="@*[not(self::state)]"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:note">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="text()|comment()" mode="il">
		<xsl:copy select="."/>
	</xsl:template>

	<xsl:template match="processing-instruction()" mode="il">
		<xsl:variable name="count">
			<xsl:number count="processing-instruction()" level="multiple" from="xlf:source|xlf:target|xlf:notes"/>
		</xsl:variable>
		<xsl:variable name="parent">
			<xsl:value-of select="ancestor::xlf:trans-unit/@id"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="text()">
				<ph xmlns="urn:oasis:names:tc:xliff:document:1.2">
					<xsl:attribute name="ctype">
						<xsl:value-of select="concat('x-pi-', local-name())"/>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($parent, '.p', $count)"/>
					</xsl:attribute>
					<xsl:value-of select="text()"/>
				</ph>
			</xsl:when>
			<xsl:when test="self::processing-instruction('linebreak')">
				<x xmlns="urn:oasis:names:tc:xliff:document:1.2" ctype="lb">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($parent, '.p', $count)"/>
					</xsl:attribute>
				</x>
			</xsl:when>
			<xsl:otherwise>
				<x xmlns="urn:oasis:names:tc:xliff:document:1.2">
					<xsl:attribute name="ctype">
						<xsl:value-of select="concat('x-pi-', local-name())"/>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($parent, '.p', $count)"/>
					</xsl:attribute>
				</x>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="il">
		<xsl:variable name="count">
			<xsl:number count="*" level="multiple" format="1_1_1_1_1" from="xlf:source|xlf:target|xlf:notes"/>
		</xsl:variable>
		<xsl:variable name="parent">
			<xsl:value-of select="ancestor::xlf:trans-unit/@id"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="*|text()|processing-instruction()|comment()">
				<g xmlns="urn:oasis:names:tc:xliff:document:1.2">
					<xsl:call-template name="ctype"/>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($parent, '.g', $count)"/>
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
					<xsl:call-template name="ctype"/>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($parent, '.x', $count)"/>
					</xsl:attribute>
					<xsl:apply-templates select="@*[localname != 'conref']" mode="at"/>
					<xsl:value-of select="@dita:conref"/>
				</ph>
			</xsl:when>
			<xsl:otherwise>
				<x xmlns="urn:oasis:names:tc:xliff:document:1.2">
					<xsl:call-template name="ctype"/>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($parent, '.x', $count)"/>
					</xsl:attribute>
					<xsl:apply-templates select="@*" mode="at"/>
				</x>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*" mode="at">
		<xsl:variable name="namespace">
			<xsl:choose>
				<xsl:when test="contains(name(), ':')">
					<xsl:value-of select="namespace-uri()"/>
				</xsl:when>
				<xsl:when test="contains(name(..), ':')">
					<xsl:value-of select="namespace-uri(..)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'http://docbook.org/ns/docbook'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="prefix">
			<xsl:choose>
				<xsl:when test="$namespace = 'http://www.tei-c.org/ns/1.0'">
					<xsl:value-of select="'tei'"/>
				</xsl:when>
				<xsl:when test="$namespace = 'http://dita.oasis-open.org/architecture/2005'">
					<xsl:value-of select="'dita'"/>
				</xsl:when>
				<xsl:when test="$namespace = 'http://www.w3.org/2001/XInclude'">
					<xsl:value-of select="'xi'"/>
				</xsl:when>
				<xsl:when test="$namespace = 'http://www.w3.org/1999/xlink'">
					<xsl:value-of select="'xl'"/>
				</xsl:when>
				<xsl:when test="$namespace = 'http://www.w3.org/2005/11/its'">
					<xsl:value-of select="'its'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'db'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="local" select="local-name()"/>
		<xsl:attribute name="{$prefix}:{$local}">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="target">
		<target xmlns="urn:oasis:names:tc:xliff:document:1.2" state="new">
			<xsl:for-each select="xlf:source">
				<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
			</xsl:for-each>
		</target>
	</xsl:template>

	<xsl:template name="ctype">
		<xsl:attribute name="ctype">
			<xsl:value-of select="'x-'"/>
			<xsl:choose>
				<xsl:when test="namespace-uri() = 'http://www.w3.org/2001/XInclude'">
					<xsl:value-of select="'xi-'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'db-'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="local-name()"/>
		</xsl:attribute>
	</xsl:template>

</xsl:stylesheet>
