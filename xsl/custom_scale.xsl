<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xep="http://www.renderx.com/XEP/xep"
                version="1.1">
	<!--
	     Stylesheet to resize XEPOUT files by the required factor.

	     Parameters:
	     $Scale:    Factor by which to resize the pages.

	-->
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:param name="Scale"/>
	<xsl:template match="xep:document">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="xep:internal-bookmark|xep:page"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="xep:internal-bookmark">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="destination-x">
				<xsl:value-of select="@destination-x * number($Scale)"/>
			</xsl:attribute>
			<xsl:attribute name="destination-y">
				<xsl:value-of select="@destination-y * number($Scale)"/>
			</xsl:attribute>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="xep:page">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="width">
				<xsl:value-of select="@width * number($Scale)"/>
			</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:value-of select="@height * number($Scale)"/>
			</xsl:attribute>
			<xep:transform b="0" c="0" e="0" f="0">
				<xsl:attribute name="a">
					<xsl:value-of select="$Scale"/>
				</xsl:attribute>
				<xsl:attribute name="d">
					<xsl:value-of select="$Scale"/>
				</xsl:attribute>
			</xep:transform>
			<xsl:copy-of select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
