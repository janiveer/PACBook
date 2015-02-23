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
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                exclude-result-prefixes="xd"
                version="1.0">
	<!--
	     Stylesheet for fixing remote references in docbook documents.

	     It is assumed that _all_ olinks are internal links
	     _within_ the completed document; as such they are converted
	     to xrefs, links or glossterms with @targetptr as the @linkend and
	     @localinfo as the @endterm. @targetdoc is ignored at the moment.

	     If the olink has a type attribute, it is converted to the specified
	     type of element. If it has no @type, but has child nodes, then it is
	     converted to a link; if it has no @type and no child nodes, it is
	     converted to an xref. @localinfo is always converted to @endterm.

	     If you want to link to a destination outside the current document
	     that will validate, but you don't want to use an olink, use xref
	     with the xl:href="#linkend" attribute.

	     It is also assumed that all modules refer to image files relative to
	     their own location; as such image @filerefs are modified to point
	     to the location of the _original_ image relative to the completed
	     document's location.

	     For common preface modules, images should be stored in the PACBook
	     modules/images folder. Refer to images relative to the preface module's
	     location, e.g. "../images/pic.svg". This will give the correct result.
	-->
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonTemplates.xsl"/>

	<xd:doc>
		===========================
		Recurse through source file
		===========================
	</xd:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:choose>
			<xsl:when test="self::db:olink">
				<xsl:call-template name="FixOLink"/>
			</xsl:when>
			<xsl:when test="self::db:imagedata">
				<xsl:call-template name="FixImageData"/>
			</xsl:when>
			<xsl:otherwise>
<!--
				<xsl:copy>
					<xsl:copy-of select="@*[not(name()='xml:base')]"/>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:copy>
-->
				<xsl:copy>
					<xsl:if test="@xml:id">
						<xsl:call-template name="Fix_ID"/>
					</xsl:if>
					<xsl:copy-of select="@*[not(name()='xml:id')][not(name()='xml:base')]"/>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="FixOLink">
		<xsl:choose>
			<xsl:when test="@type='xref' or @type='glossterm' or @type='link'">
				<xsl:element name="{@type}" namespace="http://docbook.org/ns/docbook">
					<xsl:call-template name="Link_Attributes"/>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="node()">
						<xsl:element name="link" namespace="http://docbook.org/ns/docbook">
							<xsl:call-template name="Link_Attributes"/>
							<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="xref" namespace="http://docbook.org/ns/docbook">
							<xsl:call-template name="Link_Attributes"/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Link_Attributes">
		<xsl:if test="@targetptr">
			<xsl:attribute name="linkend">
				<xsl:value-of select="@targetptr"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="@localinfo">
			<xsl:attribute name="endterm">
				<xsl:value-of select="@localinfo"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:copy-of select="@xrefstyle"/>
		<xsl:copy-of select="@xl:href"/>
		<xsl:copy-of select="@xl:show"/>
	</xsl:template>

	<xsl:template name="FixImageData">
		<xsl:element name="imagedata" namespace="http://docbook.org/ns/docbook">
			<xsl:if test="@fileref">
				<xsl:attribute name="fileref">
					<xsl:call-template name="File_Reference">
						<xsl:with-param name="refpath" select="@fileref"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@entityref">
				<xsl:attribute name="fileref">
					<xsl:value-of select="unparsed-entity-uri(@entityref)"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@format|@width|@depth|@scalefit|@align|@valign|@contentwidth|@contentdepth"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
