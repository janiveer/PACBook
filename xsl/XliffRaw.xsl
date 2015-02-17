<?xml version="1.0" encoding="UTF-8"?>
<!--
     Turn xliff g, x, ph and mrk elements into escaped inline tags.

     This is complicated because it processes (in one step) inline
     tags in the target which get all their attributes from a tag in
     the source with the same id. If I'd split it into two stylesheets
     (one to copy source tags into the targets, the other to process
     them) it would probably have been a lot more straightforward.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlf="urn:oasis:names:tc:xliff:document:1.2"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xl="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="xlf"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<pac:doc>
		==============
		File structure
		==============
	</pac:doc>
	<xsl:template match="xlf:xliff">
		<xliff version="1.2" xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:file"/>
		</xliff>
	</xsl:template>
	<xsl:template match="xlf:file">
		<file datatype="xml" xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="xlf:header"/>
			<xsl:apply-templates select="xlf:body"/>
		</file>
	</xsl:template>
	<xsl:template match="xlf:body">
		<body xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:trans-unit"/>
		</body>
	</xsl:template>
	<xsl:template match="xlf:trans-unit">
		<trans-unit xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xlf:source|xlf:target|xlf:notes"/>
		</trans-unit>
	</xsl:template>
	<xsl:template match="xlf:source">
		<source xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
		</source>
	</xsl:template>
	<xsl:template match="xlf:target">
		<target xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="xid"/>
		</target>
	</xsl:template>
	<xsl:template match="xlf:notes">
		<notes xmlns="urn:oasis:names:tc:xliff:document:1.2">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
		</notes>
	</xsl:template>
	<pac:doc>
		============
		Source: Text
		============
	</pac:doc>
	<xsl:template match="text()|comment()|processing-instruction()" mode="il">
		<xsl:copy select="."/>
	</xsl:template>
	<pac:doc>
		============================
		Source: Generic placeholders
		============================
	</pac:doc>
	<xsl:template match="xlf:x" mode="il">
		<xsl:variable name="namespace">
			<xsl:call-template name="namespace-from-ctype">
				<xsl:with-param name="ctype" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:call-template name="localname-from-ctype">
				<xsl:with-param name="ctype" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$namespace='processing-instruction'">
				<xsl:text>&lt;?</xsl:text>
				<xsl:value-of select="$localname"/>
				<xsl:text>?&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="$namespace"/>
				<xsl:value-of select="$localname"/>
				<xsl:apply-templates select="@*" mode="at"/>
				<xsl:text>/&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<pac:doc>
		==========================
		Source: Group placeholders
		==========================
	</pac:doc>
	<xsl:template match="xlf:g" mode="il">
		<xsl:variable name="namespace">
			<xsl:call-template name="namespace-from-ctype">
				<xsl:with-param name="ctype" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:call-template name="localname-from-ctype">
				<xsl:with-param name="ctype" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="$namespace"/>
		<xsl:value-of select="$localname"/>
		<xsl:apply-templates select="@*" mode="at"/>
		<xsl:apply-templates select="mrk" mode="at"/>
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="$namespace"/>
		<xsl:value-of select="$localname"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>
	<pac:doc>
		===========================
		Source: Phrase placeholders
		===========================
	</pac:doc>
	<xsl:template match="xlf:ph" mode="il">
		<xsl:variable name="namespace">
			<xsl:call-template name="namespace-from-ctype">
				<xsl:with-param name="ctype" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:call-template name="localname-from-ctype">
				<xsl:with-param name="ctype" select="@ctype"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$namespace='processing-instruction'">
				<xsl:text>&lt;?</xsl:text>
				<xsl:value-of select="$localname"/>
				<xsl:value-of select="text()"/>
				<xsl:text>?&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="$namespace"/>
				<xsl:value-of select="$localname"/>
				<xsl:apply-templates select="@*" mode="at"/>
				<xsl:apply-templates select="mrk" mode="at"/>
				<xsl:text> dita:conref="</xsl:text>
				<xsl:value-of select="text()"/>
				<xsl:text>"/&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<pac:doc>
		================
		Target: Segments
		================
	</pac:doc>
	<xsl:template match="xlf:mrk[@mtype='seg']" mode="xid">
		<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="xid"/>
	</xsl:template>
	<pac:doc>
		============
		Target: Text
		============
	</pac:doc>
	<xsl:template match="text()|comment()|processing-instruction()" mode="xid">
		<xsl:copy select="."/>
	</xsl:template>
	<pac:doc>
		============================
		Target: Generic placeholders
		============================
	</pac:doc>
	<xsl:template match="xlf:x" mode="xid">
		<xsl:variable name="me" select="@id"/>
		<xsl:variable name="ctype-from-source">
			<xsl:value-of select="ancestor::xlf:trans-unit/xlf:source/*[@id=$me]/@ctype" />
		</xsl:variable>
		<xsl:variable name="namespace">
			<xsl:call-template name="namespace-from-ctype">
				<xsl:with-param name="ctype" select="$ctype-from-source"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:call-template name="localname-from-ctype">
				<xsl:with-param name="ctype" select="$ctype-from-source"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$namespace='processing-instruction'">
				<xsl:text>&lt;?</xsl:text>
				<xsl:value-of select="$localname"/>
				<xsl:text>?&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="$namespace"/>
				<xsl:value-of select="$localname"/>
				<xsl:for-each select="ancestor::xlf:trans-unit/xlf:source/*[@id=$me]">
					<xsl:apply-templates select="@*" mode="at"/>
				</xsl:for-each>
				<xsl:text>/&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<pac:doc>
		==========================
		Target: Group placeholders
		==========================
	</pac:doc>
	<xsl:template match="xlf:g" mode="xid">
		<xsl:variable name="me" select="@id"/>
		<xsl:variable name="ctype-from-source">
			<xsl:value-of select="ancestor::xlf:trans-unit/xlf:source/*[@id=$me]/@ctype" />
		</xsl:variable>
		<xsl:variable name="namespace">
			<xsl:call-template name="namespace-from-ctype">
				<xsl:with-param name="ctype" select="$ctype-from-source"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:call-template name="localname-from-ctype">
				<xsl:with-param name="ctype" select="$ctype-from-source"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="$namespace"/>
		<xsl:value-of select="$localname"/>
		<xsl:for-each select="ancestor::xlf:trans-unit/xlf:source/*[@id=$me]">
			<xsl:apply-templates select="@*" mode="at"/>
		</xsl:for-each>
		<xsl:apply-templates select="mrk" mode="at"/>
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="il"/>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="$namespace"/>
		<xsl:value-of select="$localname"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>
	<pac:doc>
		===========================
		Target: Phrase placeholders
		===========================
	</pac:doc>
	<xsl:template match="xlf:ph" mode="xid">
		<xsl:variable name="me" select="@id"/>
		<xsl:variable name="ctype-from-source">
			<xsl:value-of select="ancestor::xlf:trans-unit/xlf:source/*[@id=$me]/@ctype" />
		</xsl:variable>
		<xsl:variable name="namespace">
			<xsl:call-template name="namespace-from-ctype">
				<xsl:with-param name="ctype" select="$ctype-from-source"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:call-template name="localname-from-ctype">
				<xsl:with-param name="ctype" select="$ctype-from-source"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$namespace='processing-instruction'">
				<xsl:text>&lt;?</xsl:text>
				<xsl:value-of select="$localname"/>
				<xsl:for-each select="ancestor::xlf:trans-unit/xlf:source/*[@id=$me]">
					<xsl:value-of select="text()"/>
				</xsl:for-each>
				<xsl:text>?&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select="$namespace"/>
				<xsl:value-of select="$localname"/>
				<xsl:for-each select="ancestor::xlf:trans-unit/xlf:source/*[@id=$me]">
					<xsl:apply-templates select="@*" mode="at"/>
				</xsl:for-each>
				<xsl:apply-templates select="mrk" mode="at"/>
				<xsl:text> dita:conref="</xsl:text>
				<xsl:value-of select="text()"/>
				<xsl:text>"/&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<pac:doc>
		=======
		Markers
		=======
	</pac:doc>
	<xsl:template match="xlf:mrk[@mtype='term']" mode="at">
		<xsl:text> its:term="yes"</xsl:text>
	</xsl:template>
	<xsl:template match="xlf:mrk[@mtype='phrase']" mode="at">
		<xsl:text> its:locNote="</xsl:text>
		<xsl:value-of select="@comment"/>
		<xsl:text>"</xsl:text>
	</xsl:template>
	<pac:doc>
		==========
		Attributes
		==========
	</pac:doc>
	<xsl:template match="@*" mode="at">
		<xsl:if test="namespace-uri() != 'urn:oasis:names:tc:xliff:document:1.2' and
		              namespace-uri() != ''">
			<xsl:variable name="prefix">
				<xsl:choose>
					<xsl:when test="namespace-uri() = 'http://www.w3.org/1999/xlink'">
						<xsl:value-of select="'xl:'"/>
					</xsl:when>
					<xsl:when test="namespace-uri() = 'http://www.w3.org/2005/11/its'">
						<xsl:value-of select="'its:'"/>
					</xsl:when>
					<xsl:when test="namespace-uri() = 'http://www.tei-c.org/ns/1.0'">
						<xsl:value-of select="'tei:'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="''"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="local" select="local-name()"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$prefix"/>
			<xsl:value-of select="$local"/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>"</xsl:text>
		</xsl:if>
	</xsl:template>
	<pac:doc>
		==========================
		Set $namespace from @ctype
		==========================
	</pac:doc>
	<xsl:template name="namespace-from-ctype">
		<xsl:param name="ctype"/>
		<xsl:choose>
			<xsl:when test="$ctype='lb'">
				<xsl:text>processing-instruction</xsl:text>
			</xsl:when>
			<xsl:when test="starts-with($ctype, 'x-pi-')">
				<xsl:text>processing-instruction</xsl:text>
			</xsl:when>
			<xsl:when test="starts-with($ctype, 'x-xi-')">
				<xsl:text>xi:</xsl:text>
			</xsl:when>
			<xsl:when test="starts-with($ctype, 'x-pac-')">
				<xsl:text>pac:</xsl:text>
			</xsl:when>
			<xsl:when test="starts-with($ctype, 'x-db-')">
				<xsl:text></xsl:text>
			</xsl:when>
			<xsl:when test="starts-with($ctype, 'x-svg-')">
				<xsl:text></xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<pac:doc>
		==========================
		Set $localname from @ctype
		==========================
	</pac:doc>
	<xsl:template name="localname-from-ctype">
		<xsl:param name="ctype"/>
		<xsl:choose>
			<xsl:when test="$ctype='lb'">
				<xsl:text>linebreak</xsl:text>
			</xsl:when>
			<xsl:when test="starts-with($ctype, 'x-pi-')">
				<xsl:value-of select="substring-after($ctype, 'x-pi-')"/>
			</xsl:when>
			<xsl:when test="starts-with($ctype, 'x-xi-')">
				<xsl:value-of select="substring-after($ctype, 'x-xi-')"/>
			</xsl:when>
			<xsl:when test="starts-with($ctype, 'x-pac-')">
				<xsl:value-of select="substring-after($ctype, 'x-pac-')"/>
			</xsl:when>
			<xsl:when test="starts-with($ctype, 'x-db-')">
				<xsl:value-of select="substring-after($ctype, 'x-db-')"/>
			</xsl:when>
			<xsl:when test="starts-with($ctype, 'x-svg-')">
				<xsl:value-of select="substring-after($ctype, 'x-svg-')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
