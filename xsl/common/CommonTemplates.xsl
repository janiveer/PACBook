<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="saxon str pac db xl"
                version="1.0">
	<pac:doc>
		=========================================================
		File_Reference
		$refpath

		Fixes relative file references to include all @xml:bases
		=========================================================
	</pac:doc>
	<xsl:template name="File_Reference">
		<xsl:param name="refpath"/>
		<xsl:choose>
			<xsl:when test="starts-with($refpath, '/') or contains($refpath, '://')">
				<xsl:value-of select="$refpath"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="refbase">
					<xsl:if test="ancestor-or-self::*[@xml:base]">
						<xsl:call-template name="Path_Recursion">
							<xsl:with-param name="mynode" select="ancestor-or-self::*[@xml:base][1]"/>
							<xsl:with-param name="myfull" select="''"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:variable>
				<xsl:value-of select="concat($refbase, $refpath)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="Path_Recursion">
		<xsl:param name="mynode"/>
		<xsl:param name="myfull"/>
		<xsl:for-each select="$mynode">
			<xsl:variable name="mybase" select="@xml:base"/>
			<xsl:choose>
				<xsl:when test="contains($mybase, '://')">
					<xsl:call-template name="Is_URI">
						<xsl:with-param name="mybase" select="$mybase"/>
						<xsl:with-param name="myfull" select="$myfull"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="starts-with($mybase, '/')">
					<xsl:call-template name="Is_Root">
						<xsl:with-param name="mybase" select="$mybase"/>
						<xsl:with-param name="myfull" select="$myfull"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="Is_Relative">
						<xsl:with-param name="mybase" select="$mybase"/>
						<xsl:with-param name="myfull" select="$myfull"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="Is_URI">
		<xsl:param name="mybase"/>
		<xsl:param name="myfull"/>
		<xsl:variable name="myproto">
			<xsl:value-of select="substring-before($mybase, '://')"/>
			<xsl:text>://</xsl:text>
		</xsl:variable>
		<xsl:variable name="mytail">
			<xsl:value-of select="substring-after($mybase, '://')"/>
		</xsl:variable>
		<xsl:variable name="myroot">
			<xsl:if test="starts-with($mytail, '/')">
				<xsl:text>/</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="mypath">
			<xsl:call-template name="Strip_File">
				<xsl:with-param name="mybase" select="$mytail"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat($myproto, $myroot, $mypath, $myfull)"/>
	</xsl:template>

	<xsl:template name="Is_Root">
		<xsl:param name="mybase"/>
		<xsl:param name="myfull"/>
		<xsl:variable name="myroot">
			<xsl:text>/</xsl:text>
		</xsl:variable>
		<xsl:variable name="mypath">
			<xsl:call-template name="Strip_File">
				<xsl:with-param name="mybase" select="$mybase"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat($myroot, $mypath, $myfull)"/>
	</xsl:template>

	<xsl:template name="Is_Relative">
		<xsl:param name="mybase"/>
		<xsl:param name="myfull"/>
		<xsl:variable name="mypath">
			<xsl:call-template name="Strip_File">
				<xsl:with-param name="mybase" select="$mybase"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="mynext">
			<xsl:choose>
				<xsl:when test="ancestor::*[@xml:base]">
					<xsl:call-template name="Path_Recursion">
						<xsl:with-param name="mynode" select="ancestor::*[@xml:base][1]"/>
						<xsl:with-param name="myfull" select="concat($mypath, $myfull)"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($mypath, $myfull)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$mynext"/>
	</xsl:template>

	<xsl:template name="Strip_File">
		<xsl:param name="mybase"/>
		<xsl:choose>
			<xsl:when test="function-available('str:tokenize')">
				<xsl:for-each select="str:tokenize($mybase, '/')">
					<xsl:if test="position() != last()">
						<xsl:value-of select="."/>
						<xsl:value-of select="'/'"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="function-available('saxon:tokenize')">
				<xsl:for-each select="saxon:tokenize($mybase, '/')">
					<xsl:if test="position() != last()">
						<xsl:value-of select="."/>
						<xsl:value-of select="'/'"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">
					<xsl:text>ERROR: Tokenize function not available.</xsl:text>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<pac:doc>
		=========================================================
		Fix_ID

		Changes @xml:id to @xl:href of nearest locator with
		matching @xl:label
		=========================================================
	</pac:doc>
	<xsl:template name="Fix_ID">
		<xsl:variable name="pac.id" select="@xml:id"/>
		<xsl:variable name="pac.locator" select="ancestor-or-self::*/db:info/db:extendedlink/db:locator[@xl:label=$pac.id]"/>
		<xsl:choose>
			<xsl:when test="$pac.locator">
				<xsl:variable name="pac.href" select="$pac.locator/@xl:href"/>
				<xsl:attribute name="xml:id">
					<xsl:value-of select="substring-after($pac.href, '#')"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="@xml:id"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
