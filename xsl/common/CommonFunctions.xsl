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
                xmlns:exsl="http://exslt.org/common"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:str="http://exslt.org/strings"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:data="urn:x-pacbook:data"
                xmlns:pac="urn:x-pacbook:functions"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:tmx="http://www.lisa.org/tmx14"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="func"
                exclude-result-prefixes="func exsl date str xd data pac db xl l tmx dc rdf saxon"
                version="1.1">

	<xsl:variable name="Labels" select="'../data/DataLabels.xml'"/>
	<xsl:param name="abcBlock" select="'AÁÀÂÄÅÆBCÇDEÉÈÊËFGHIÍÌÎÏJKLMNÑOÓÒÔÖØŒPQRSTUÚÙÛÜVWXYÝỲŶŸZ'"/>
	<xsl:param name="abcSmall" select="'aáàâäåæbcçdeéèêëfghiíìîïjklmnñoóòôöøœpqrstuúùûüvwxyýỳŷÿz'"/>

	<xd:doc>
		*******************************************************
		pac:uc('text')

		Transforms text to uppercase.
		*******************************************************
	</xd:doc>
	<func:function name="pac:uc">
		<xsl:param name="strText"/>
		<func:result select="translate($strText, $abcSmall, $abcBlock)"/>
	</func:function>

	<xd:doc>
		*******************************************************
		pac:lc('text')

		Transforms text to lowercase.
		*******************************************************
	</xd:doc>
	<func:function name="pac:lc">
		<xsl:param name="strText"/>
		<func:result select="translate($strText, $abcBlock, $abcSmall)"/>
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
		pac:decode('uri')

		Decodes a URI to a file path. The protocol and initial
		double slashes are removed, encoded spaces are decoded
		*******************************************************
	</xd:doc>
	<func:function name="pac:decode">
		<xsl:param name="URI"/>
		<xsl:variable name="noProto">
			<xsl:choose>
				<xsl:when test="starts-with($URI, 'file:')">
					<xsl:value-of select="substring-after($URI, 'file:')"/>
				</xsl:when>
				<xsl:when test="starts-with($URI, 'http:')">
					<xsl:value-of select="substring-after($URI, 'http:')"/>
				</xsl:when>
				<xsl:when test="starts-with($URI, 'ftp:')">
					<xsl:value-of select="substring-after($URI, 'ftp:')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$URI"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="noSlashes">
			<xsl:choose>
				<xsl:when test="starts-with($noProto, '//')">
					<xsl:value-of select="substring-after($noProto, '//')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$noProto"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="noEsc20">
			<xsl:value-of select="str:replace($noSlashes, '%20', ' ')"/>
		</xsl:variable>
		<func:result select="$noEsc20"/>
	</func:function>

	<xd:doc>
		*******************************************************
		pac:resource('path', 'prefix', 'parent')

		Encodes a file path to a local resource path
		* Path is the file path to encode
		* Prefix is prepended to the local resource path
		* Parent replaces '..' in the file path
		*******************************************************
	</xd:doc>
	<func:function name="pac:resource">
		<xsl:param name="Path"/>
		<xsl:param name="Prefix"/>
		<xsl:param name="Parent"/>
		<xsl:variable name="Input">
			<xsl:value-of select="pac:decode($Path)"/>
		</xsl:variable>
		<xsl:variable name="Result">
			<xsl:value-of select="$Prefix"/>
			<xsl:text>/</xsl:text>
			<xsl:choose>
				<xsl:when test="function-available('str:tokenize')">
					<xsl:for-each select="str:tokenize($Input, '/')">
						<xsl:call-template name="pac:_resource">
							<xsl:with-param name="Parent" select="$Parent"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="function-available('saxon:tokenize')">
					<xsl:for-each select="saxon:tokenize($Input, '/')">
						<xsl:call-template name="pac:_resource">
							<xsl:with-param name="Parent" select="$Parent"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message terminate="yes">
						<xsl:text>ERROR: Tokenize function not available.</xsl:text>
					</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<func:result select="$Result"/>
	</func:function>
	<xsl:template name="pac:_resource">
		<xsl:param name="Parent"/>
		<xsl:choose>
			<xsl:when test=".='..'">
				<xsl:value-of select="$Parent"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(., ':', '')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="position() != last()">
			<xsl:text>/</xsl:text>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		*******************************************************
		pac:xliff('language')

		Finds the nearest ancestor of the current element which
		has an RDF resource of type "translations", then from
		there gets the uri of the .XLIFF file which matches
		the specified language (whew!)
		*******************************************************
	</xd:doc>
	<func:function name="pac:xliff">
		<xsl:param name="strLang"/>
		<func:result select="ancestor-or-self::*[*/rdf:RDF/rdf:Description[@dc:type='translations']][1]/*/rdf:RDF/rdf:Description[@dc:type='translations'][1]/dc:relation[@xml:lang=$strLang]/@rdf:resource"/>
	</func:function>

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
		*******************************************************
		pac:pseudo-attrib('name')

		Returns the value of the specified pseudo-attribute.
		*******************************************************
	</xd:doc>
	<func:function name="pac:pseudo-attrib">
		<xsl:param name="strName"/>
		<xsl:variable name="strResult" select="substring-before(substring-after(., concat($strName, '=&quot;')), '&quot;')"/>
		<func:result select="$strResult"/>
	</func:function>

	<xd:doc>
		*******************************************************
		str:replace('string', 'search', 'replace')

		by Jeni Tennison
		http://www.exslt.org/str/functions/replace/index.html
		*******************************************************
	</xd:doc>
	<func:function name="str:replace">
		<xsl:param name="string" select="''" />
		<xsl:param name="search" select="/.." />
		<xsl:param name="replace" select="/.." />
		<xsl:choose>
				<xsl:when test="not($string)">
					<func:result select="/.." />
				</xsl:when>
				<xsl:when test="function-available('exsl:node-set')">
					<!--  this converts the search and replace arguments to node sets
								if they are one of the other XPath types -->
					<xsl:variable name="search-nodes-rtf">
						<xsl:copy-of select="$search" />
					</xsl:variable>
					<xsl:variable name="replace-nodes-rtf">
						<xsl:copy-of select="$replace" />
					</xsl:variable>
					<xsl:variable name="replacements-rtf">
							<xsl:for-each select="exsl:node-set($search-nodes-rtf)/node()">
								<xsl:variable name="pos" select="position()" />
								<replace search="{.}">
										<xsl:copy-of select="exsl:node-set($replace-nodes-rtf)/node()[$pos]" />
								</replace>
							</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="sorted-replacements-rtf">
							<xsl:for-each select="exsl:node-set($replacements-rtf)/replace">
								<xsl:sort select="string-length(@search)" data-type="number" order="descending" />
								<xsl:copy-of select="." />
							</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="result">
						<xsl:choose>
								<xsl:when test="not($search)">
									<xsl:value-of select="$string" />
								</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="str:_replace">
										<xsl:with-param name="string" select="$string" />
										<xsl:with-param name="replacements" select="exsl:node-set($sorted-replacements-rtf)/replace" />
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<func:result select="exsl:node-set($result)/node()" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:message terminate="yes">
							ERROR: function implementation of str:replace() relies on exsl:node-set().
					</xsl:message>
				</xsl:otherwise>
		</xsl:choose>
	</func:function>
	<xsl:template name="str:_replace">
		<xsl:param name="string" select="''" />
		<xsl:param name="replacements" select="/.." />
		<xsl:choose>
			<xsl:when test="not($string)" />
			<xsl:when test="not($replacements)">
				<xsl:value-of select="$string" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="replacement" select="$replacements[1]" />
				<xsl:variable name="search" select="$replacement/@search" />
				<xsl:choose>
					<xsl:when test="not(string($search))">
						<xsl:value-of select="substring($string, 1, 1)" />
						<xsl:copy-of select="$replacement/node()" />
						<xsl:call-template name="str:_replace">
							<xsl:with-param name="string" select="substring($string, 2)" />
							<xsl:with-param name="replacements" select="$replacements" />
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="contains($string, $search)">
						<xsl:call-template name="str:_replace">
							<xsl:with-param name="string" select="substring-before($string, $search)" />
							<xsl:with-param name="replacements" select="$replacements[position() > 1]" />
						</xsl:call-template>
						<xsl:copy-of select="$replacement/node()" />
						<xsl:call-template name="str:_replace">
							<xsl:with-param name="string" select="substring-after($string, $search)" />
							<xsl:with-param name="replacements" select="$replacements" />
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="str:_replace">
							<xsl:with-param name="string" select="$string" />
							<xsl:with-param name="replacements" select="$replacements[position() > 1]" />
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
