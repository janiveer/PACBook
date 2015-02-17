<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:pac="http://www.pac.co.uk"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

	<pac:doc>
		===========================================================
		Stylesheet for processing declension in docbook documents.

		This stylesheet selects the correct declension of a noun
		based on the case and definiteness specified by the
		nearest ancestor element.
		===========================================================
	</pac:doc>

	<pac:doc>
		==============
		Main recursion
		==============
	</pac:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:choose>
			<xsl:when test="self::db:token">
				<xsl:call-template name="Declension"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<pac:doc>
		==========
		Declension
		==========
	</pac:doc>
	<xsl:template name="Declension">
		<xsl:variable name="req.case">
			<xsl:choose>
				<xsl:when test="ancestor::*[@tei:case]">
					<xsl:value-of select="ancestor::*[@tei:case][1]/@tei:case"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'nom'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="req.definiteness">
			<xsl:choose>
				<xsl:when test="ancestor::*[@tei:oVar]">
					<xsl:value-of select="ancestor::*[@tei:oVar][1]/@tei:oVar"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'ind'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="this.case">
			<xsl:choose>
				<xsl:when test="@tei:case">
					<xsl:value-of select="@tei:case"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'nom'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="this.definiteness">
			<xsl:choose>
				<xsl:when test="@tei:oVar">
					<xsl:value-of select="@tei:oVar"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'ind'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$this.case != $req.case">
				<!-- NOP -->
			</xsl:when>
			<xsl:when test="$this.definiteness != $req.definiteness">
				<!-- NOP -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
