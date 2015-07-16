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
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:data="urn:x-pacbook:data"
                xmlns:svg="http://www.w3.org/2000/svg"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:ling="http://stanleysecurity.github.io/PACBook/ns/linguistics"
                xmlns:content="http://stanleysecurity.github.io/PACBook/ns/transclusion"
                xmlns:nn="urn:x-no-namespace"
                exclude-result-prefixes="xlf xd data its xi xl db svg mml ling content nn"
                version="1.0">

	<xd:doc>
     Turn xliff g, x, ph and mrk elements into escaped inline tags.

     This is complicated because it processes (in one step) inline
     tags in the target which get all their attributes from a tag in
     the source with the same id. If I'd split it into two stylesheets
     (one to copy source tags into the targets, the other to process
     them) it would probably have been a lot more straightforward.
	</xd:doc>

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:param name="DefaultNS" select="'http://docbook.org/ns/docbook'"/>

	<xd:doc>
		==============
		File structure
		==============
	</xd:doc>
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
			<xsl:apply-templates select="xlf:source|xlf:seg-source|xlf:target"/>
			<xsl:copy-of select="xlf:context-group|xlf:count-group|xlf:prop-group|xlf:note"/>
			<!-- TODO: xlf:alt-trans -->
			<xsl:copy-of select="*[not(namespace-uri()='urn:oasis:names:tc:xliff:document:1.2')]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:bin-unit">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="xlf:source|xlf:seg-source">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="src"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="xlf:target">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="tgt"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		================
		Source: Segments
		================
	</xd:doc>
	<xsl:template match="xlf:mrk[@mtype='seg']" mode="src">
		<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="src"/>
	</xsl:template>

	<xd:doc>
		============
		Source: Text
		============
	</xd:doc>
	<xsl:template match="text()|comment()|processing-instruction()" mode="src">
		<xsl:copy/>
	</xsl:template>

	<xd:doc>
		============================
		Source: Generic placeholders
		============================
	</xd:doc>
	<xsl:template match="xlf:x" mode="src">
		<xsl:variable name="NodeType">
			<xsl:call-template name="GetNodeFromCType">
				<xsl:with-param name="CType" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Name">
			<xsl:call-template name="GetNameFromCType">
				<xsl:with-param name="CType" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Prefix">
			<xsl:call-template name="GetPrefixFromCType">
				<xsl:with-param name="CType" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$NodeType='processing-instruction'">
				<xsl:text>&lt;?</xsl:text>
				<xsl:value-of select="$Name"/>
				<xsl:text>?&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="$Prefix"/>
				<xsl:value-of select="$Name"/>
				<xsl:apply-templates select="@*" mode="at"/>
				<xsl:text>/&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc>
		==========================
		Source: Group placeholders
		==========================
	</xd:doc>
	<xsl:template match="xlf:g" mode="src">
		<xsl:variable name="Name">
			<xsl:call-template name="GetNameFromCType">
				<xsl:with-param name="CType" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Prefix">
			<xsl:call-template name="GetPrefixFromCType">
				<xsl:with-param name="CType" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="$Prefix"/>
		<xsl:value-of select="$Name"/>
		<xsl:apply-templates select="@*" mode="at"/>
		<xsl:apply-templates select="mrk" mode="at"/>
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="src"/>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="$Prefix"/>
		<xsl:value-of select="$Name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xd:doc>
		===========================
		Source: Phrase placeholders
		===========================
	</xd:doc>
	<xsl:template match="xlf:ph" mode="src">
		<xsl:variable name="NodeType">
			<xsl:call-template name="GetNodeFromCType">
				<xsl:with-param name="CType" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Name">
			<xsl:call-template name="GetNameFromCType">
				<xsl:with-param name="CType" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Prefix">
			<xsl:call-template name="GetPrefixFromCType">
				<xsl:with-param name="CType" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$NodeType='processing-instruction'">
				<xsl:text>&lt;?</xsl:text>
				<xsl:value-of select="$Name"/>
				<xsl:value-of select="text()"/>
				<xsl:text>?&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="$Prefix"/>
				<xsl:value-of select="$Name"/>
				<xsl:apply-templates select="@*" mode="at"/>
				<xsl:apply-templates select="mrk" mode="at"/>
				<xsl:text> content:ref="</xsl:text>
				<xsl:value-of select="text()"/>
				<xsl:text>"/&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc>
		================
		Target: Segments
		================
	</xd:doc>
	<xsl:template match="xlf:mrk[@mtype='seg']" mode="tgt">
		<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="tgt"/>
	</xsl:template>

	<xd:doc>
		============
		Target: Text
		============
	</xd:doc>
	<xsl:template match="text()|comment()|processing-instruction()" mode="tgt">
		<xsl:copy/>
	</xsl:template>

	<xd:doc>
		============================
		Target: Generic placeholders
		============================
	</xd:doc>
	<xsl:template match="xlf:x" mode="tgt">
		<xsl:variable name="Me" select="@id"/>
		<xsl:variable name="CTypeFromSource">
			<xsl:value-of select="ancestor::xlf:trans-unit/xlf:source/*[@id=$Me]/@ctype" />
		</xsl:variable>
		<xsl:variable name="NodeType">
			<xsl:call-template name="GetNodeFromCType">
				<xsl:with-param name="CType" select="$CTypeFromSource"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Name">
			<xsl:call-template name="GetNameFromCType">
				<xsl:with-param name="CType" select="$CTypeFromSource"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Prefix">
			<xsl:call-template name="GetPrefixFromCType">
				<xsl:with-param name="CType" select="$CTypeFromSource"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$NodeType='processing-instruction'">
				<xsl:text>&lt;?</xsl:text>
				<xsl:value-of select="$Name"/>
				<xsl:text>?&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="$Prefix"/>
				<xsl:value-of select="$Name"/>
				<xsl:for-each select="ancestor::xlf:trans-unit/xlf:source/*[@id=$Me]">
					<xsl:apply-templates select="@*" mode="at"/>
				</xsl:for-each>
				<xsl:text>/&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc>
		==========================
		Target: Group placeholders
		==========================
	</xd:doc>
	<xsl:template match="xlf:g" mode="tgt">
		<xsl:variable name="Me" select="@id"/>
		<xsl:variable name="CTypeFromSource">
			<xsl:value-of select="ancestor::xlf:trans-unit/xlf:source/*[@id=$Me]/@ctype" />
		</xsl:variable>
		<xsl:variable name="Name">
			<xsl:call-template name="GetNameFromCType">
				<xsl:with-param name="CType" select="$CTypeFromSource"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Prefix">
			<xsl:call-template name="GetPrefixFromCType">
				<xsl:with-param name="CType" select="$CTypeFromSource"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="$Prefix"/>
		<xsl:value-of select="$Name"/>
		<xsl:for-each select="ancestor::xlf:trans-unit/xlf:source/*[@id=$Me]">
			<xsl:apply-templates select="@*" mode="at"/>
		</xsl:for-each>
		<xsl:apply-templates select="mrk" mode="at"/>
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="src"/>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="$Prefix"/>
		<xsl:value-of select="$Name"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xd:doc>
		===========================
		Target: Phrase placeholders
		===========================
	</xd:doc>
	<xsl:template match="xlf:ph" mode="tgt">
		<xsl:variable name="Me" select="@id"/>
		<xsl:variable name="CTypeFromSource">
			<xsl:value-of select="ancestor::xlf:trans-unit/xlf:source/*[@id=$Me]/@ctype" />
		</xsl:variable>
		<xsl:variable name="NodeType">
			<xsl:call-template name="GetNodeFromCType">
				<xsl:with-param name="CType" select="$CTypeFromSource"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Name">
			<xsl:call-template name="GetNameFromCType">
				<xsl:with-param name="CType" select="$CTypeFromSource"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="Prefix">
			<xsl:call-template name="GetPrefixFromCType">
				<xsl:with-param name="CType" select="$CTypeFromSource"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$NodeType='processing-instruction'">
				<xsl:text>&lt;?</xsl:text>
				<xsl:value-of select="$Name"/>
				<xsl:for-each select="ancestor::xlf:trans-unit/xlf:source/*[@id=$Me]">
					<xsl:value-of select="text()"/>
				</xsl:for-each>
				<xsl:text>?&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="$Prefix"/>
				<xsl:value-of select="$Name"/>
				<xsl:for-each select="ancestor::xlf:trans-unit/xlf:source/*[@id=$Me]">
					<xsl:apply-templates select="@*" mode="at"/>
				</xsl:for-each>
				<xsl:apply-templates select="mrk" mode="at"/>
				<xsl:text> content:ref="</xsl:text>
				<xsl:value-of select="text()"/>
				<xsl:text>"/&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc>
		=======
		Markers
		=======
	</xd:doc>
	<xsl:template match="xlf:mrk[@mtype='term']" mode="at">
		<xsl:text> its:term="yes"</xsl:text>
	</xsl:template>
	<xsl:template match="xlf:mrk[@mtype='phrase']" mode="at">
		<xsl:text> its:locNote="</xsl:text>
		<xsl:value-of select="@comment"/>
		<xsl:text>"</xsl:text>
	</xsl:template>

	<xd:doc>
		==========
		Attributes
		==========
		If the attribute is in the XLIFF namespace or no namespace, ignore it.
		If the attribute is in {urn:x-xml-namespace}, recreate it in the xml namespace.
		If the attribute is in {urn:x-no-namespace}, recreate it in no namespace.
		Otherwise, recreate the attribute in the correct namespace.
	</xd:doc>
	<xsl:template match="@*" mode="at">
		<xsl:variable name="AttribNS" select="namespace-uri()"/>
		<xsl:if test="$AttribNS!='urn:oasis:names:tc:xliff:document:1.2' and
		              $AttribNS!=''">
			<xsl:variable name="AttribPref">
				<xsl:choose>
					<xsl:when test="$AttribNS='urn:x-no-namespace'">
						<xsl:value-of select="''"/>
					</xsl:when>
					<xsl:when test="$AttribNS='urn:x-xml-namespace'">
						<xsl:value-of select="'xml:'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="document('data/DataNamespaces.xml')//data:namespace[@uri=$AttribNS]/@prefix"/>
						<xsl:text>:</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="AttribName" select="local-name()"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$AttribPref"/>
			<xsl:value-of select="$AttribName"/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>"</xsl:text>
		</xsl:if>
	</xsl:template>

	<xd:doc>
		=========================
		Get node type from @ctype
		=========================
		If the current CType is ‘lb’, or if it begins with ‘x-pi-’,
		then the node is a processing instruction; otherwise it’s
		an element.
	</xd:doc>
	<xsl:template name="GetNodeFromCType">
		<xsl:param name="CType"/>
		<xsl:choose>
			<xsl:when test="$CType='lb'">
				<xsl:text>processing-instruction</xsl:text>
			</xsl:when>
			<xsl:when test="starts-with($CType, 'x-pi-')">
				<xsl:text>processing-instruction</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>element</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xd:doc>
		===========================
		Get node prefix from @ctype
		===========================
		Look through each namespace in the namespace document.
		If the current CType is based on this namespace’s prefix,
		then output this namespace’s prefix, unless this namespace
		is no namespace or the default namespace. (There are no
		likely elements in the xml namespace.)
	</xd:doc>
	<xsl:template name="GetPrefixFromCType">
		<xsl:param name="CType"/>
		<xsl:for-each select="document('data/DataNamespaces.xml')//data:namespace">
			<xsl:if test="starts-with($CType, concat('x-', @prefix, '-'))">
				<xsl:choose>
					<xsl:when test="@uri=$DefaultNS">
						<!-- Nope -->
					</xsl:when>
					<xsl:when test="@uri='urn:x-no-namespace'">
						<!-- Nope -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@prefix"/>
						<xsl:text>:</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xd:doc>
		=========================
		Get node name from @ctype
		=========================
		If the current CType is ‘lb’, output linebreak. Otherwise,
		look through each namespace in the namespace document.
		If the current CType is based on this namespace’s prefix,
		then output the text after this namespace’s prefix.
	</xd:doc>
	<xsl:template name="GetNameFromCType">
		<xsl:param name="CType"/>
		<xsl:choose>
			<xsl:when test="$CType='lb'">
				<xsl:text>linebreak</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="document('data/DataNamespaces.xml')//data:namespace">
					<xsl:if test="starts-with($CType, concat('x-', @prefix, '-'))">
						<xsl:value-of select="substring-after($CType, concat('x-', @prefix, '-'))"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
