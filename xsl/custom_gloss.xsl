<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:pac="http://www.pac.co.uk"
                exclude-result-prefixes="pac"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="no"/>
	<xsl:key name="Glossary" match="db:glossentry" use="@xml:id"/>

	<pac:doc>
		=================================================
		Adds an xl:title to every glossterm in a document
		containing a preview of that term’s definition.
		=================================================
	</pac:doc>

	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="db:glossterm[@xl:href]|db:glossterm[@linkend]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="not(@xl:title)">
				<xsl:variable name="Reference">
					<xsl:if test="@xl:href">
						<xsl:value-of select="substring-after(@xl:href, '#')"/>
					</xsl:if>
					<xsl:if test="@linkend and not(@xl:href)">
						<xsl:value-of select="@linkend"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="Definition">
					<xsl:apply-templates select="key('Glossary', $Reference)/db:glossdef"/>
				</xsl:variable>
				<xsl:if test="$Definition">
					<xsl:attribute name="xl:title">
						<xsl:value-of select="normalize-space($Definition)"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
