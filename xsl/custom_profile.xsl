<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:func="http://exslt.org/functions"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:my="urn:x-pacbook:functions"
                xmlns:xl="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="my func"
                extension-element-prefixes="my func"
                version="1.0">
	<xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/profiling/profile.xsl"/>
	<xsl:include href="http://www.jabadaw.com/PAC/xsl/common/CommonFunctions.xsl"/>

	<pac:doc>
		==================
		Profile parameters
		==================
		If the root element has a condition attribute, we profile the document by
		condition using the value provided. Otherwise, we profile the document by
		condition using the root document's xml:id attribute. Conditional text in
		transcluded documents can thus be included / ignored based on the xml:id
		(or condition attribute) of the including document.
	</pac:doc>
	<xsl:param name="profile.condition">
		<xsl:choose>
			<xsl:when test="/*/@condition">
				<xsl:value-of select="/*/@condition"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/*/@xml:id"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<pac:doc>
		=========
		Resources
		=========
	</pac:doc>
	<xsl:template match="db:imagedata[starts-with(@fileref, '../')]|db:imagedata[contains(@fileref, '://')]" mode="profile">
		<xsl:choose>
			<xsl:when test="$profile.attribute='outputformat' and $profile.value='help'">
				<xsl:element name="imagedata" namespace="http://docbook.org/ns/docbook">
					<xsl:copy-of select="@*"/>
					<xsl:attribute name="fileref">
						<xsl:value-of select="my:resource(@fileref, 'resources', '__')"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
