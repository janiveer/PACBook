<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
	<!ENTITY % trans-units
		SYSTEM "http://raw.github.com/STANLEYSecurity/PACBook/master/xsl/trans-units.ent">
	%trans-units;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:data="urn:x-pacbook:data"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:pac="http://www.pac.co.uk"
                exclude-result-prefixes="db data pac xlf its xl"
                version="1.1">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="no"/>
	<xsl:param name="Counter" select="''"/>
	<xsl:param name="carried" select="number(document($Counter)/data:counter[1])"/>
	<xsl:param name="prefix">
		<xsl:choose>
			<xsl:when test="document($Counter)/data:counter[1]/@prefix">
				<xsl:value-of select="document($Counter)/data:counter[1]/@prefix"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'u'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
	<xsl:param name="initial">
		<xsl:choose>
			<xsl:when test="$carried = $carried">
				<xsl:value-of select="$carried"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<pac:doc>
		=======================================
		Marks up a DocBook file for translation
		=======================================
	</pac:doc>
	<xsl:template match="/">
		<xsl:if test="$Counter = ''">
			<xsl:message terminate="yes">
				<xsl:text>Please specify $Counter: full path to trans-unit counter file.</xsl:text>
			</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="*|text()|processing-instruction()"/>
		<xsl:call-template name="write_total"/>
	</xsl:template>

	<pac:doc>
		====================================
		Finds unmarked translation units and
		calls 'xliff_id' with current count
		====================================
	</pac:doc>
	<xsl:template match="&unmarked_trans_units;">
		<xsl:variable name="element" select="local-name()"/>
		<xsl:variable name="namespace" select="namespace-uri()"/>
		<xsl:element name="{$element}" namespace="{$namespace}">
			<xsl:copy-of select="@*"/>
			<xsl:call-template name="xliff_id">
				<xsl:with-param name="prefix" select="$prefix"/>
				<xsl:with-param name="count">
					<xsl:value-of select="$initial + 1 + count(&preceding_unmarked_trans_units;)"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:element>
	</xsl:template>

	<pac:doc>
		================================
		Recursion through other elements
		================================
	</pac:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<pac:doc>
		===================================
		Adds @xlf:id based on current count
		===================================
	</pac:doc>
	<xsl:template name="xliff_id">
		<xsl:param name="prefix"/>
		<xsl:param name="count"/>
		<xsl:variable name="format">
			<xsl:number value="$count" format="00001"/>
		</xsl:variable>
		<xsl:attribute name="id" namespace="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:value-of select="concat($prefix, $format)"/>
		</xsl:attribute>
	</xsl:template>

	<pac:doc>
		=====================
		Writes out new totals
		=====================
	</pac:doc>
	<xsl:template name="write_total">
		<xsl:variable name="total">
			<xsl:for-each select="&descendant_unmarked_trans_units;">
				<xsl:if test="position() = last()">
					<xsl:value-of select="$initial + 1 + count(&preceding_unmarked_trans_units;)"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="output">
			<xsl:value-of select="'counter.xml'"/>
		</xsl:variable>
		<xsl:document href="{$output}" method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes">
			<data:counter xmlns:data="urn:x-pacbook:data">
				<xsl:attribute name="prefix">
					<xsl:value-of select="$prefix"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$total = ''">
						<xsl:value-of select="$initial"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$total"/>
					</xsl:otherwise>
				</xsl:choose>
			</data:counter>
		</xsl:document>
	</xsl:template>
</xsl:stylesheet>
