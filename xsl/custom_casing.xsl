<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:my="urn:x-pacbook:functions"
                xmlns:str="http://exslt.org/strings"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="my saxon str"
                version="1.1">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="no"/>
	<xsl:include href="http://www.jabadaw.com/PAC/xsl/common/CommonFunctions.xsl"/>
	<xsl:include href="http://www.jabadaw.com/PAC/xsl/common/CommonParameters.xsl"/>

	<pac:doc>
		===========================================================
		Stylesheet for processing orthography in docbook documents.

		This stylesheet sets marked text to the required case:
		upper, lower, title or sentence. The document is then
		passed through for final processing.
		===========================================================
	</pac:doc>

	<pac:doc>
		=========
		Recursion
		=========
	</pac:doc>
	<xsl:template match="*[@tei:oRef='uppercase']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="uc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*[@tei:oRef='lowercase']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="lc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*[@tei:oRef='capitalize']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="tc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*[@tei:oRef='initial']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="sc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<pac:doc>
		==========
		Upper case
		==========
	</pac:doc>
	<xsl:template match="*[@tei:oRef]|processing-instruction()|comment()" mode="uc">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<xsl:template match="*[not(@tei:oRef)]" mode="uc">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="uc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="text()" mode="uc">
		<xsl:value-of select="my:uc(string(.))"/>
	</xsl:template>

	<pac:doc>
		==========
		Lower case
		==========
	</pac:doc>
	<xsl:template match="*[@tei:oRef]|processing-instruction()|comment()" mode="lc">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<xsl:template match="*[not(@tei:oRef)]" mode="lc">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="lc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="text()" mode="lc">
		<xsl:value-of select="my:lc(string(.))"/>
	</xsl:template>

	<pac:doc>
		==========
		Title case
		==========
	</pac:doc>
	<xsl:template match="*[@tei:oRef]|processing-instruction()|comment()" mode="tc">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<xsl:template match="*[not(@tei:oRef)]" mode="tc">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="tc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="text()" mode="tc">
		<xsl:if test="starts-with(., ' ')">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="function-available('str:tokenize')">
				<xsl:for-each select="str:tokenize(string(.), ' ')">
					<xsl:call-template name="tc_token"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="function-available('saxon:tokenize')">
				<xsl:for-each select="saxon:tokenize(string(.), ' ')">
					<xsl:call-template name="tc_token"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">
					<xsl:text>ERROR: Tokenize function not available.</xsl:text>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="substring(., string-length(.), 1) = ' '">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="tc_token">
		<xsl:choose>
			<xsl:when test="not(contains($ShortWords, .))">
				<xsl:value-of select="my:uc(substring(., 1, 1))"/>
				<xsl:value-of select="substring(., 2)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="text()"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="position() != last()">
			<xsl:value-of select="' '"/>
		</xsl:if>
	</xsl:template>

	<pac:doc>
		=============
		Sentence case
		=============
	</pac:doc>
	<xsl:template match="*[@tei:oRef]|processing-instruction()|comment()" mode="sc">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<xsl:template match="*[not(@tei:oRef)]" mode="sc">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="sc"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="text()" mode="sc">
		<xsl:variable name="ID" select="generate-id(ancestor::*[@tei:oRef='initial'])"/>
		<xsl:choose>
			<xsl:when test="preceding::text()[generate-id(ancestor::*[@tei:oRef='initial'])=$ID]">
				<xsl:copy-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="my:uc(substring(., 1, 1))"/>
				<xsl:value-of select="substring(., 2)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:param name="ShortWords">
		<xsl:text>about above across after against along among amongst around as aside at before behind below beneath beside besides between beyond but by circa c. ca. down for from in inside into near of off on onto out over per plus pro qua than through throughout till to toward towards under until unto up upon versus vs. v. via with within without the an a this these that those and or but</xsl:text>
	</xsl:param>

</xsl:stylesheet>
