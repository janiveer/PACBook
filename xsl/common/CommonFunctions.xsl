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
                xmlns:func="http://exslt.org/functions"
                xmlns:uri="http://xsltsl.org/uri"
                xmlns:str="http://xsltsl.org/string"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:vivo="http://vivoweb.org/ontology/core#"
                xmlns:tmx="http://www.lisa.org/tmx14"
                xmlns:pac="urn:x-pacbook:functions"
                extension-element-prefixes="func"
                exclude-result-prefixes="func uri str xd xl rdf vivo tmx pac"
                version="1.1">

	<xsl:import href="../../lib/xsltsl/stdlib.xsl"/>

	<xsl:variable name="Labels" select="'../data/DataLabels.xml'"/>

	<xd:doc>
		*******************************************************
		pac:uc('text')

		Transforms text to uppercase.
		*******************************************************
	</xd:doc>
	<func:function name="pac:uc">
		<xsl:param name="strText"/>
		<xsl:variable name="strResult">
			<xsl:call-template name="str:to-upper">
				<xsl:with-param name="text" select="$strText"/>
			</xsl:call-template>
		</xsl:variable>
		<func:result select="$strResult"/>
	</func:function>

	<xd:doc>
		*******************************************************
		pac:lc('text')

		Transforms text to lowercase.
		*******************************************************
	</xd:doc>
	<func:function name="pac:lc">
		<xsl:param name="strText"/>
		<xsl:variable name="strResult">
			<xsl:call-template name="str:to-lower">
				<xsl:with-param name="text" select="$strText"/>
			</xsl:call-template>
		</xsl:variable>
		<func:result select="$strResult"/>
	</func:function>

	<xd:doc>
		*******************************************************
		pac:label('language', 'tuid')

		Opens DataLabels.xml and returns the segment
		associated with the given language and trans unit ID.
		If the given trans unit does not have a variant
		in the given language, the source language is used.
		*******************************************************
	</xd:doc>
	<func:function name="pac:label">
		<xsl:param name="strLang"/>
		<xsl:param name="strTUID"/>
		<xsl:variable name="srcLang">
			<xsl:value-of select="document($Labels)//tmx:header/@srclang"/>
		</xsl:variable>
		<xsl:variable name="rtfUnit">
			<xsl:copy-of select="document($Labels)//tmx:tu[@tuid=$strTUID]"/>
		</xsl:variable>
		<xsl:variable name="strCustom">
			<xsl:choose>
				<xsl:when test="$rtfUnit//tmx:tuv[@xml:lang=$strLang]">
					<xsl:value-of select="$rtfUnit//tmx:tuv[@xml:lang=$strLang]/tmx:seg"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$rtfUnit//tmx:tuv[@xml:lang=$srcLang]/tmx:seg"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="strResult">
			<xsl:choose>
				<xsl:when test="not($strCustom='')">
					<xsl:value-of select="$strCustom"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$strTUID"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<func:result select="$strResult"/>
	</func:function>

	<xd:doc>
		*******************************************************
		pac:xliff('language')

		Finds the nearest ancestor of the current element which
		has an RDF resource of type "vivo:hasTranslation", then
		gets from it the URI of the XLIFF file which matches
		the specified language (whew!)

		We want to be able to resolve the URI of the XLIFF file
		against the xml:base of the element that references it.
		Saxon can’t cope if the xml:base requires lookup in an
		XML catalog. So having found the URI of an XLIFF file
		we must make the reference absolute by resolving it
		against the element’s xml:base. Saxon can then look up
		the absolute URI in an XML catalog.
		*******************************************************
	</xd:doc>
	<func:function name="pac:xliff">
		<xsl:param name="Lang"/>
		<xsl:variable name="xliffURI">
			<xsl:for-each select="ancestor-or-self::*[*/rdf:RDF//vivo:hasTranslation][1]/*/rdf:RDF//vivo:hasTranslation[1]//rdf:li[@xml:lang=$Lang]">
				<xsl:value-of select="pac:xbase(@rdf:resource)"/>
			</xsl:for-each>
		</xsl:variable>
		<func:result select="$xliffURI"/>
	</func:function>

	<xd:doc>
		*******************************************************
		pac:xbase('uri')

		Resolves a URI against any xml:base attributes which
		apply to the current element.
		*******************************************************
	</xd:doc>
	<func:function name="pac:xbase">
		<xsl:param name="refURI"/>
		<xsl:variable name="resolvedURI">
			<xsl:call-template name="uri:resolve-uri">
				<xsl:with-param name="reference" select="$refURI"/>
				<xsl:with-param name="base">
					<xsl:apply-templates select="ancestor-or-self::*[@xml:base][1]" mode="XMLBase"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<func:result select="$resolvedURI"/>
	</func:function>
	<xsl:template match="*[@xml:base]" mode="XMLBase">
		<xsl:call-template name="uri:resolve-uri">
			<xsl:with-param name="reference" select="@xml:base"/>
			<xsl:with-param name="base">
				<xsl:apply-templates select="ancestor::*[@xml:base][1]" mode="XMLBase"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xd:doc>
		*******************************************************
		pac:lang()

		Finds language of the current node. If not specified,
		returns "mis" (missing linguistic information).
		*******************************************************
	</xd:doc>
	<func:function name="pac:lang">
		<xsl:variable name="strLang" select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
		<xsl:variable name="strResult">
			<xsl:choose>
				<xsl:when test="$strLang">
					<xsl:value-of select="$strLang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'mis'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<func:result select="$strResult"/>
	</func:function>

	<xd:doc>
		**********************************************************
		pac:fixup('id', 'uri')

		From the context node, finds the nearest locator whose
		@xl:href matches {$id} in an extended link whose @xl:role
		is {$uri}. Follows the arc to its other locator and
		returns the ID specified by that locator's @xl:href.
		**********************************************************
	</xd:doc>
	<func:function name="pac:fixup">
		<xsl:param name="start.id"/>
		<xsl:param name="role.uri"/>
		<xsl:variable name="start.ref" select="concat('#', $start.id)"/>
		<xsl:variable name="this.link" select="ancestor-or-self::*/db:info/db:extendedlink[@xl:role=$role.uri] |
                                           ancestor-or-self::*//*[@xl:type='extended'][@xl:role=$role.uri]"/>
		<xsl:variable name="start.loc" select="$this.link/db:locator[@xl:href=$start.ref][1] |
                                           $this.link/*[xl:type='locator'][@xl:href=$start.ref][1]"/>
		<xsl:variable name="start.lbl" select="$start.loc/@xl:label"/>
		<xsl:variable name="start.arc" select="$this.link/db:arc[@xl:from=$start.lbl][1] |
                                           $this.link/*[xl:type='arc'][@xl:from=$start.lbl][1]"/>
		<xsl:variable name="fixup.lbl" select="$start.arc/@xl:to"/>
		<xsl:variable name="fixup.loc" select="$this.link/db:locator[@xl:label=$fixup.lbl][1] |
                                           $this.link/*[xl:type='locator'][@xl:label=$fixup.lbl][1]"/>
		<xsl:variable name="fixup.ref" select="$fixup.loc/@xl:href"/>
		<xsl:variable name="fixup.id"  select="substring-after($fixup.ref, '#')"/>
		<func:result>
			<xsl:choose>
				<xsl:when test="$fixup.id">
					<xsl:value-of select="$fixup.id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$start.id"/>
				</xsl:otherwise>
			</xsl:choose>
		</func:result>
	</func:function>

</xsl:stylesheet>
