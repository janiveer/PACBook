<?xml version='1.0'?>
<!DOCTYPE stylesheet [
	<!ENTITY % xlinkroles
		SYSTEM "http://raw.github.com/STANLEYSecurity/PACBook/master/xsl/xlink-roles.ent">
	%xlinkroles;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:dita="http://dita.oasis-open.org/architecture/2005"
                xmlns:str="http://exslt.org/strings"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="str db xl saxon dita"
                version="1.0">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:strip-space elements="db:resource"/>

	<pac:doc>
		==============
		Main recursion
		==============
	</pac:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:choose>
			<xsl:when test="@dita:conref">
				<xsl:call-template name="Reference"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:if test="@linkend">
						<xsl:call-template name="Fix_Linkend"/>
					</xsl:if>
					<xsl:if test="starts-with(@xl:href, '#')">
						<xsl:call-template name="Fix_XLink"/>
					</xsl:if>
					<xsl:if test="@arearefs">
						<xsl:call-template name="Fix_AreaRefs"/>
					</xsl:if>
					<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<pac:doc>
		==================
		Resolve references
		==================
	</pac:doc>
	<xsl:template name="Reference">
		<xsl:variable name="ref" select="@dita:conref"/>
		<xsl:variable name="def" select="ancestor-or-self::*/db:info/&xl_defs;/db:resource[@xl:label=$ref]"/>
		<xsl:copy>
			<xsl:copy-of select="@*[not(local-name()='conref' and namespace-uri()='http://dita.oasis-open.org/architecture/2005')]"/>
			<xsl:choose>
				<xsl:when test="$def != ''">
					<xsl:for-each select="$def[position() = last()]">
						<xsl:copy-of select="*|text()|processing-instruction()|comment()"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message terminate="no">
						<xsl:text>Reference not found: </xsl:text>
						<xsl:value-of select="$ref"/>
					</xsl:message>
					<xsl:comment>
						<xsl:value-of select="$ref"/>
					</xsl:comment>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<pac:doc>
		===========================
		Resolve linkends using arcs
		===========================
	</pac:doc>
	<xsl:template name="Fix_Linkend">
		<xsl:variable name="pac.linkend" select="@linkend"/>
		<xsl:variable name="pac.arc" select="ancestor-or-self::*/db:info/db:extendedlink/db:arc[@xl:from=$pac.linkend]"/>
		<xsl:choose>
			<xsl:when test="$pac.arc">
				<xsl:attribute name="linkend">
					<xsl:value-of select="$pac.arc/@xl:to"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="@linkend"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<pac:doc>
		================================
		Resolve simple xlinks using arcs
		================================
	</pac:doc>
	<xsl:template name="Fix_XLink">
		<xsl:variable name="pac.linkend" select="substring-after(@xl:href, '#')"/>
		<xsl:variable name="pac.arc" select="ancestor-or-self::*/db:info/db:extendedlink/db:arc[@xl:from=$pac.linkend]"/>
		<xsl:choose>
			<xsl:when test="$pac.arc">
				<xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink">
					<xsl:text>#</xsl:text>
					<xsl:value-of select="$pac.arc/@xl:to"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="@xl:href"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<pac:doc>
		===========================
		Resolve arearefs using arcs
		===========================
	</pac:doc>
	<xsl:template name="Fix_AreaRefs">
		<xsl:variable name="pac.arearefs" select="@arearefs"/>
		<xsl:attribute name="arearefs">
			<xsl:choose>
				<xsl:when test="function-available('str:tokenize')">
					<xsl:for-each select="str:tokenize($pac.arearefs, ' ')">
						<xsl:call-template name="Fix_AreaRef">
							<xsl:with-param name="pac.arearefs" select="$pac.arearefs"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="function-available('saxon:tokenize')">
					<xsl:for-each select="saxon:tokenize($pac.arearefs, ' ')">
						<xsl:call-template name="Fix_AreaRef">
							<xsl:with-param name="pac.arearefs" select="$pac.arearefs"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message terminate="yes">
						<xsl:text>ERROR: Tokenize function not available.</xsl:text>
					</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="Fix_AreaRef">
		<xsl:param name="pac.arearefs"/>
		<xsl:variable name="pac.linkend" select="."/>
		<xsl:for-each select="$pac.arearefs">
			<xsl:variable name="pac.arc" select="ancestor-or-self::*/db:info/db:extendedlink/db:arc[@xl:from=$pac.linkend]"/>
			<xsl:choose>
				<xsl:when test="$pac.arc">
					<xsl:value-of select="$pac.arc/@xl:to"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$pac.linkend"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:if test="position() != last()">
			<xsl:value-of select="' '"/>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
