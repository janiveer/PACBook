<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:func="http://exslt.org/functions"
                xmlns:exsl="http://exslt.org/common"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:str="http://exslt.org/strings"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:data="urn:x-pacbook:data"
                xmlns:my="urn:x-pacbook:functions"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="func"
                exclude-result-prefixes="func exsl date str pac data my db xl l dc rdf saxon"
                version="1.0">
	<xsl:variable name="strPath" select="'http://docbook.sourceforge.net/release/xsl-ns/current/common/'"/>
	<xsl:variable name="Labels" select="'../data/DataLabels.xml'"/>
	<data:lang name="en-GB" fallback="en"/>
	<data:lang name="en-US" fallback="en"/>
	<data:lang name="mis"   fallback="en"/>
	<data:lang name="und"   fallback="en"/>
	<data:lang name="mul"   fallback="en"/>
	<data:lang name="zxx"   fallback="en"/>
	<xsl:param name="abcInput" select="'aáàâäÁÀÂÄåÅæÆbcçÇdeéèêëÉÈÊËfghiíìîïÍÌÎÏjklmnñÑoóòôöÓÒÔÖøØœŒpqrstuúùûüÚÙÛÜvwxyýỳŷÿÝỲŶŸz'"/>
	<xsl:param name="abcBlock" select="'AÁÀÂÄÁÀÂÄÅÅÆÆBCÇÇDEÉÈÊËÉÈÊËFGHIÍÌÎÏÍÌÎÏJKLMNÑÑOÓÒÔÖÓÒÔÖØØŒŒPQRSTUÚÙÛÜÚÙÛÜVWXYÝỲŶŸÝỲŶŸZ'"/>
	<xsl:param name="abcSmall" select="'aáàâäáàâäååææbcççdeéèêëéèêëfghiíìîïíìîïjklmnññoóòôöóòôöøøœœpqrstuúùûüúùûüvwxyýỳŷÿýỳŷÿz'"/>
	<xsl:param name="abcUpper" select="'AAAAAAAAAAAÆÆBCCCDEEEEEEEEEFGHIIIIIIIIIJKLMNNNOOOOOOOOOOOŒŒPQRSTUUUUUUUUUVWXYYYYYYYYYZ'"/>
	<xsl:param name="abcLower" select="'aaaaaaaaaaaææbcccdeeeeeeeeefghiiiiiiiiijklmnnnoooooooooooœœpqrstuuuuuuuuuvwxyyyyyyyyyz'"/>

	<pac:doc>
		*******************************************************
		my:uc('text')

		Transforms text to uppercase.
		*******************************************************
	</pac:doc>
	<func:function name="my:uc">
		<xsl:param name="strText"/>
		<func:result select="translate($strText, $abcSmall, $abcBlock)"/>
	</func:function>

	<pac:doc>
		*******************************************************
		my:lc('text')

		Transforms text to lowercase.
		*******************************************************
	</pac:doc>
	<func:function name="my:lc">
		<xsl:param name="strText"/>
		<func:result select="translate($strText, $abcBlock, $abcSmall)"/>
	</func:function>

	<pac:doc>
		*******************************************************
		my:brand('vendor', 'branding')

		Opens DataBrands.xml and returns the text associated
		with the given branding.
		*******************************************************
	</pac:doc>
	<func:function name="my:brand">
		<xsl:param name="strVendor"/>
		<xsl:param name="strBranding"/>
		<xsl:variable name="Brands" select="'../data/DataBrands.xml'"/>
		<func:result select="document($Brands)//data:vendor[@name=$strVendor]/data:branding[@name=$strBranding]"/>
	</func:function>

	<pac:doc>
		*******************************************************
		my:local('language', 'context', 'template')

		Opens DataLabels.xml and the DocBook XSL localisation
		file for the given language and returns the text
		associated with the given context and given template.
		*******************************************************
	</pac:doc>
	<func:function name="my:local">
		<xsl:param name="strLang"/>
		<xsl:param name="strContext"/>
		<xsl:param name="strTemplate"/>
		<xsl:variable name="strName">
			<xsl:value-of select="my:fallback($strLang)"/>
		</xsl:variable>
		<xsl:variable name="strDoc">
			<xsl:value-of select="concat($strPath, $strName, '.xml')"/>
		</xsl:variable>
		<xsl:variable name="strStock">
			<xsl:value-of select="document($strDoc)//l:context[@name=$strContext]/l:template[@name=$strTemplate]/@text"/>
		</xsl:variable>
		<xsl:variable name="strCustom">
			<xsl:value-of select="document($Labels)//l:l10n[@language=$strName]/l:context[@name=$strContext]/l:template[@name=$strTemplate]/@text"/>
		</xsl:variable>
		<xsl:variable name="strResult">
			<xsl:choose>
				<xsl:when test="not($strCustom='')">
					<xsl:value-of select="$strCustom"/>
				</xsl:when>
				<xsl:when test="not($strStock='')">
					<xsl:value-of select="$strStock"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$strTemplate"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<func:result select="$strResult"/>
	</func:function>

	<pac:doc>
		*******************************************************
		my:text('language', 'key')

		Opens DataLabels.xml and the DocBook XSL localisation
		file for the given language and returns the text
		associated with the given key.
		*******************************************************
	</pac:doc>
	<func:function name="my:text">
		<xsl:param name="strLang"/>
		<xsl:param name="strKey"/>
		<xsl:variable name="strName">
			<xsl:value-of select="my:fallback($strLang)"/>
		</xsl:variable>
		<xsl:variable name="strDoc">
			<xsl:value-of select="concat($strPath, $strName, '.xml')"/>
		</xsl:variable>
		<xsl:variable name="strStock">
			<xsl:value-of select="document($strDoc)//l:gentext[@key=$strKey]/@text"/>
		</xsl:variable>
		<xsl:variable name="strCustom">
			<xsl:value-of select="document($Labels)//l:l10n[@language=$strName]/l:gentext[@key=$strKey]/@text"/>
		</xsl:variable>
		<xsl:variable name="strResult">
			<xsl:choose>
				<xsl:when test="not($strCustom='')">
					<xsl:value-of select="$strCustom"/>
				</xsl:when>
				<xsl:when test="not($strStock='')">
					<xsl:value-of select="$strStock"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$strKey"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<func:result select="$strResult"/>
	</func:function>

	<pac:doc>
		*******************************************************
		my:dingbat('language', 'key')

		Opens DataLabels.xml and the DocBook XSL localisation
		file for the given language and returns the dingbat
		associated with the given key.
		*******************************************************
	</pac:doc>
	<func:function name="my:dingbat">
		<xsl:param name="strLang"/>
		<xsl:param name="strKey"/>
		<xsl:variable name="strName">
			<xsl:value-of select="my:fallback($strLang)"/>
		</xsl:variable>
		<xsl:variable name="strDoc">
			<xsl:value-of select="concat($strPath, $strName, '.xml')"/>
		</xsl:variable>
		<xsl:variable name="strStock">
			<xsl:value-of select="document($strDoc)//l:dingbat[@key=$strKey]/@text"/>
		</xsl:variable>
		<xsl:variable name="strCustom">
			<xsl:value-of select="document($Labels)//l:l10n[@language=$strName]/l:dingbat[@key=$strKey]/@text"/>
		</xsl:variable>
		<xsl:variable name="strResult">
			<xsl:choose>
				<xsl:when test="not($strCustom='')">
					<xsl:value-of select="$strCustom"/>
				</xsl:when>
				<xsl:when test="not($strStock='')">
					<xsl:value-of select="$strStock"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$strKey"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<func:result select="$strResult"/>
	</func:function>

	<pac:doc>
		*******************************************************
		my:collate($collection)

		Sorts collection according to the sort order specified
		for the current language in DataLocales.xml
		*******************************************************
	</pac:doc>
	<func:function name="my:collate">
		<xsl:param name="this"/>
		<xsl:variable name="Locales" select="'../data/DataLocales.xml'"/>
		<xsl:variable name="thisLang" select="my:lang()"/>
		<!-- Convert upper case to lower case (ignoring diacritics for now) -->
		<xsl:variable name="thisABCUpper" select="document($Locales)//data:abcupper[@lang=$thisLang]"/>
		<xsl:variable name="thisABCLower" select="document($Locales)//data:abclower[@lang=$thisLang]"/>
		<xsl:variable name="thisLowerCase" select="translate($this, $thisABCUpper, $thisABCLower)"/>
		<!-- Protect special alphabetic characters for this locale -->
		<xsl:variable name="thisProtect" select="document($Locales)//data:protect[@lang=$thisLang]"/>
		<xsl:variable name="thisReplace" select="document($Locales)//data:replace[@lang=$thisLang]"/>
		<xsl:variable name="thisNormalized" select="translate($thisLowerCase, $thisProtect, $thisReplace)"/>
		<!-- Convert accented characters to lower case and remove accents -->
		<xsl:variable name="thisNoAccents" select="translate($thisNormalized, $abcInput, $abcLower)"/>
		<!-- Convert ligatures to separate letters -->
		<xsl:variable name="thisNoAE">
			<xsl:value-of select="my:replace($thisNoAccents, 'æ', 'ae')"/>
		</xsl:variable>
		<xsl:variable name="thisNoOE">
			<xsl:value-of select="my:replace($thisNoAE, 'œ', 'oe')"/>
		</xsl:variable>
		<xsl:variable name="thisNoSZ">
			<xsl:value-of select="my:replace($thisNoOE, 'ß', 'ss')"/>
		</xsl:variable>
		<!-- Unprotect special characters -->
		<xsl:variable name="thisUnsorted" select="translate($thisNoSZ, $thisReplace, $thisProtect)"/>
		<!-- Convert to sort order for this locality -->
		<xsl:variable name="thisABCOrder" select="document($Locales)//data:abcorder[@lang=$thisLang]"/>
		<xsl:variable name="thisSortOrder" select="translate($thisUnsorted, $thisABCLower, $thisABCOrder)"/>
		<!-- Return result -->
		<func:result select="$thisSortOrder"/>
	</func:function>

	<pac:doc>
		*******************************************************
		my:replace('string', 'character', 'replacement')

		Searches string and replaces character with replacement
		*******************************************************
	</pac:doc>
	<func:function name="my:replace">
		<xsl:param name="strText"/>
		<xsl:param name="strReplace"/>
		<xsl:param name="strBy"/>
		<xsl:variable name="strResult">
			<xsl:choose>
				<xsl:when test="contains($strText, $strReplace)">
					<xsl:variable name="strPadding" select="concat(' ', $strText, ' ')"/>
					<xsl:choose>
						<xsl:when test="function-available('str:tokenize')">
							<xsl:for-each select="str:tokenize($strPadding, $strReplace)">
								<xsl:value-of select="."/>
								<xsl:if test="position() != last()">
									<xsl:value-of select="$strBy"/>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="function-available('saxon:tokenize')">
							<xsl:for-each select="saxon:tokenize($strPadding, $strReplace)">
								<xsl:value-of select="."/>
								<xsl:if test="position() != last()">
									<xsl:value-of select="$strBy"/>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message terminate="yes">
								<xsl:text>ERROR: Tokenize function not available.</xsl:text>
							</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$strText"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<func:result select="normalize-space($strResult)"/>
	</func:function>

	<pac:doc>
		*******************************************************
		my:decode('uri')

		Decodes a URI to a file path. The protocol and initial
		double slashes are removed, encoded spaces are decoded
		*******************************************************
	</pac:doc>
	<func:function name="my:decode">
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

	<pac:doc>
		*******************************************************
		my:resource('path', 'prefix', 'parent')

		Encodes a file path to a local resource path
		* Path is the file path to encode
		* Prefix is prepended to the local resource path
		* Parent replaces '..' in the file path
		*******************************************************
	</pac:doc>
	<func:function name="my:resource">
		<xsl:param name="Path"/>
		<xsl:param name="Prefix"/>
		<xsl:param name="Parent"/>
		<xsl:variable name="Input">
			<xsl:value-of select="my:decode($Path)"/>
		</xsl:variable>
		<xsl:variable name="Result">
			<xsl:value-of select="$Prefix"/>
			<xsl:text>/</xsl:text>
			<xsl:choose>
				<xsl:when test="function-available('str:tokenize')">
					<xsl:for-each select="str:tokenize($Input, '/')">
						<xsl:call-template name="my:_resource">
							<xsl:with-param name="Parent" select="$Parent"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="function-available('saxon:tokenize')">
					<xsl:for-each select="saxon:tokenize($Input, '/')">
						<xsl:call-template name="my:_resource">
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
	<xsl:template name="my:_resource">
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

	<pac:doc>
		*******************************************************
		my:xliff('language')

		Finds the nearest ancestor of the current element which
		has an RDF resource of type "translations", then from
		there gets the uri of the .XLIFF file which matches
		the specified language (whew!)
		*******************************************************
	</pac:doc>
	<func:function name="my:xliff">
		<xsl:param name="strLang"/>
		<func:result select="ancestor-or-self::*[*/rdf:RDF/rdf:Description[@dc:type='translations']][1]/*/rdf:RDF/rdf:Description[@dc:type='translations'][1]/dc:relation[@xml:lang=$strLang]/@rdf:resource"/>
	</func:function>

	<pac:doc>
		*******************************************************
		my:lang()

		Finds language of the current node. If not specified,
		returns "mis" (missing linguistic information).
		*******************************************************
	</pac:doc>
	<func:function name="my:lang">
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

	<pac:doc>
		*******************************************************
		my:fallback('language')

		Replaces language name with fallback language name
		*******************************************************
	</pac:doc>
	<func:function name="my:fallback">
		<xsl:param name="strLang"/>
		<xsl:variable name="strResult">
			<xsl:choose>
				<xsl:when test="document('')//data:lang[@name=$strLang]">
					<xsl:value-of select="document('')//data:lang[@name=$strLang]/@fallback"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$strLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<func:result select="$strResult"/>
	</func:function>

	<pac:doc>
		*******************************************************
		my:pseudo-attrib('name')

		Returns the value of the specified pseudo-attribute.
		*******************************************************
	</pac:doc>
	<func:function name="my:pseudo-attrib">
		<xsl:param name="strName"/>
		<xsl:variable name="strResult" select="substring-before(substring-after(., concat($strName, '=&quot;')), '&quot;')"/>
		<func:result select="$strResult"/>
	</func:function>

	<pac:doc>
		*******************************************************
		my:twips('length')

		Converts the specified length to twips.
		*******************************************************
	</pac:doc>
	<func:function name="my:twips">
		<xsl:param name="strLength"/>
		<xsl:variable name="strResult">
			<xsl:choose>
				<xsl:when test="substring($strLength, string-length($strLength) - 1, 2) = 'mm'">
					<xsl:value-of select="number(substring-before($strLength, 'mm')) * 56.7"/>
				</xsl:when>
				<xsl:when test="substring($strLength, string-length($strLength) - 1, 2) = 'cm'">
					<xsl:value-of select="number(substring-before($strLength, 'cm')) * 567"/>
				</xsl:when>
				<xsl:when test="substring($strLength, string-length($strLength) - 1, 2) = 'in'">
					<xsl:value-of select="number(substring-before($strLength, 'in')) * 1440"/>
				</xsl:when>
				<xsl:when test="substring($strLength, string-length($strLength) - 1, 2) = 'pc'">
					<xsl:value-of select="number(substring-before($strLength, 'pc')) * 6"/>
				</xsl:when>
				<xsl:when test="substring($strLength, string-length($strLength) - 1, 2) = 'pt'">
					<xsl:value-of select="number(substring-before($strLength, 'pt')) * 20"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$strLength"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<func:result select="round($strResult)"/>
	</func:function>

	<pac:doc>
		*******************************************************
		my:date('language', 'format')

		Renders the current date in the specified language
		using the specified format.
		*******************************************************
	</pac:doc>
	<func:function name="my:date">
		<xsl:param name="strLang"/>
		<xsl:param name="strFormat"/>
		<xsl:variable name="strYear" select="date:year()"/>
		<xsl:variable name="strMonth" select="date:month-name()"/>
		<xsl:variable name="strAbbrev" select="date:month-abbreviation()"/>
		<xsl:variable name="strResult">
			<xsl:choose>
				<xsl:when test="not($strFormat='')">
					<xsl:choose>
						<xsl:when test="function-available('str:tokenize')">
							<xsl:for-each select="str:tokenize($strFormat, ' ')">
								<xsl:call-template name="my:_date">
									<xsl:with-param name="strLang" select="$strLang"/>
									<xsl:with-param name="strYear" select="$strYear"/>
									<xsl:with-param name="strMonth" select="$strMonth"/>
									<xsl:with-param name="strAbbrev" select="$strAbbrev"/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="function-available('saxon:tokenize')">
							<xsl:for-each select="saxon:tokenize($strFormat, ' ')">
								<xsl:call-template name="my:_date">
									<xsl:with-param name="strLang" select="$strLang"/>
									<xsl:with-param name="strYear" select="$strYear"/>
									<xsl:with-param name="strMonth" select="$strMonth"/>
									<xsl:with-param name="strAbbrev" select="$strAbbrev"/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message terminate="yes">
								<xsl:text>ERROR: Tokenize function not available.</xsl:text>
							</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($strMonth, ' ', $strYear)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<func:result select="$strResult"/>
	</func:function>
	<xsl:template name="my:_date">
		<xsl:param name="strLang"/>
		<xsl:param name="strYear"/>
		<xsl:param name="strMonth"/>
		<xsl:param name="strAbbrev"/>
		<xsl:choose>
			<xsl:when test=".='b'">
				<xsl:value-of select="my:local($strLang, 'datetime-abbrev', $strAbbrev)"/>
			</xsl:when>
			<xsl:when test=".='B'">
				<xsl:value-of select="my:local($strLang, 'datetime-full', $strMonth)"/>
			</xsl:when>
			<xsl:when test=".='Y'">
				<xsl:value-of select="$strYear"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="position() != last()">
			<xsl:value-of select="' '"/>
		</xsl:if>
	</xsl:template>

	<pac:doc>
		*******************************************************
		str:replace('string', 'search', 'replace')

		by Jeni Tennison
		http://www.exslt.org/str/functions/replace/index.html
		*******************************************************
	</pac:doc>
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
