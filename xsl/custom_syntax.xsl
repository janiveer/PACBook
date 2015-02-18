<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:pac="http://www.pac.co.uk"
                xmlns:my="urn:x-pacbook:functions"
                exclude-result-prefixes="my"
                version="1.1">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>
	<xsl:param name="Verbose" select="false()"/>
	<xsl:param name="Dictionary" select="'data/DataSyntax.xml'"/>

	<pac:doc>
		===========================================================
		Stylesheet for processing morphology in docbook documents.

		This stylesheet inflects dependent words by phonological
		environment, case, gender and number.
		===========================================================
	</pac:doc>

	<pac:doc>
		==============
		Main recursion
		==============
	</pac:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:choose>
			<xsl:when test="self::db:wordasword">
				<xsl:call-template name="Morphosyntax"/>
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
		============
		Morphosyntax
		============
	</pac:doc>
	<xsl:template name="Morphosyntax">
		<xsl:variable name="my.word" select="text()"/>
		<xsl:variable name="my.norm" select="my:lc($my.word)"/>
		<xsl:variable name="my.lang" select="my:lang()"/>
		<xsl:if test="$Verbose=true()">
			<xsl:if test="not(document($Dictionary))">
				<xsl:message terminate="no">
					<xsl:text>Could not find </xsl:text>
					<xsl:value-of select="$Dictionary"/>
				</xsl:message>
			</xsl:if>
		</xsl:if>
		<!-- Get dictionary for current language -->
		<xsl:variable name="my.div">
			<xsl:copy-of select="document($Dictionary)//tei:div[@xml:lang=$my.lang]"/>
		</xsl:variable>
		<xsl:if test="$Verbose=true()">
			<xsl:if test="not($my.div/*)">
				<xsl:message terminate="no">
					<xsl:text>No dictionary for </xsl:text>
					<xsl:value-of select="$my.lang"/>
				</xsl:message>
			</xsl:if>
		</xsl:if>
		<!-- Get entry for current word -->
		<xsl:variable name="my.entry">
			<xsl:copy-of select="$my.div//tei:entry[@n=$my.norm]"/>
		</xsl:variable>
		<xsl:if test="$Verbose=true()">
			<xsl:if test="not($my.entry/*)">
				<xsl:message terminate="no">
					<xsl:text>No entry for </xsl:text>
					<xsl:value-of select="$my.norm"/>
				</xsl:message>
			</xsl:if>
		</xsl:if>
		<!-- Get inflections of current word -->
		<xsl:variable name="out.entry">
			<xsl:copy-of select="$my.entry//tei:form"/>
		</xsl:variable>
		<!-- Select number -->
		<xsl:variable name="out.num">
			<xsl:call-template name="Number">
				<xsl:with-param name="my.word" select="$my.word"/>
				<xsl:with-param name="my.tree" select="$out.entry"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Select phonologically-conditioned variant -->
		<xsl:variable name="out.pron">
			<xsl:call-template name="Phonology">
				<xsl:with-param name="my.word" select="$my.word"/>
				<xsl:with-param name="my.tree" select="$out.num"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Select case -->
		<xsl:variable name="out.case">
			<xsl:call-template name="Case">
				<xsl:with-param name="my.word" select="$my.word"/>
				<xsl:with-param name="my.tree" select="$out.pron"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Select gender -->
		<xsl:variable name="out.gen">
			<xsl:call-template name="Gender">
				<xsl:with-param name="my.word" select="$my.word"/>
				<xsl:with-param name="my.tree" select="$out.case"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Select definiteness -->
		<xsl:variable name="out.oVar">
			<xsl:call-template name="Definiteness">
				<xsl:with-param name="my.word" select="$my.word"/>
				<xsl:with-param name="my.tree" select="$out.gen"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Select the remaining word form -->
		<xsl:variable name="out.orth" select="$out.oVar//tei:orth/text()"/>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="$out.orth">
					<!-- If the first letter of $my.word is capitalised,
							 capitalise the first letter of the returned word;
							 otherwise give the returned word in lower case -->
					<xsl:variable name="my.init" select="substring($my.word, 1, 1)"/>
					<xsl:if test="$my.init = my:uc($my.init) and not(@tei:oRef)">
						<xsl:attribute name="tei:oRef">
							<xsl:value-of select="'initial'"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$out.orth"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message terminate="no">
						<xsl:text>WARNING: Could not inflect </xsl:text>
						<xsl:value-of select="generate-id()"/>
						<xsl:text>: </xsl:text>
						<xsl:value-of select="$my.norm"/>
					</xsl:message>
					<xsl:comment>
						<xsl:value-of select="generate-id()"/>
					</xsl:comment>
					<xsl:value-of select="$my.word"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<pac:doc>
		=========
		Phonology
		=========
	</pac:doc>
	<xsl:template name="Phonology">
		<xsl:param name="my.word"/>
		<xsl:param name="my.tree"/>
		<xsl:choose>
			<xsl:when test="$my.tree//tei:gramGrp/tei:usg">
				<xsl:if test="$Verbose=true()">
					<xsl:message terminate="no">
						<xsl:value-of select="$my.word"/>
						<xsl:text> has phonological variants.</xsl:text>
					</xsl:message>
				</xsl:if>
				<xsl:variable name="my.pron">
					<xsl:value-of select="following-sibling::*/descendant-or-self::db:phrase[@tei:pron][1]/@tei:pron"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$my.pron != ''">
						<xsl:copy-of select="$my.tree/tei:form[contains(tei:gramGrp/tei:usg/@value, $my.pron)]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$Verbose=true()">
							<xsl:message terminate="no">
								<xsl:text>WARNING: phonetic environment could not be determined.</xsl:text>
							</xsl:message>
						</xsl:if>
						<xsl:copy-of select="$my.tree"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Verbose=true()">
					<xsl:message terminate="no">
						<xsl:value-of select="$my.word"/>
						<xsl:text> has no phonological variants.</xsl:text>
					</xsl:message>
				</xsl:if>
				<xsl:copy-of select="$my.tree"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<pac:doc>
		======
		Number
		======
	</pac:doc>
	<xsl:template name="Number">
		<xsl:param name="my.word"/>
		<xsl:param name="my.tree"/>
		<xsl:choose>
			<xsl:when test="$my.tree//tei:gramGrp/tei:num">
				<xsl:if test="$Verbose=true()">
					<xsl:message terminate="no">
						<xsl:value-of select="$my.word"/>
						<xsl:text> has number variants.</xsl:text>
					</xsl:message>
				</xsl:if>
				<xsl:variable name="my.num">
					<xsl:value-of select="ancestor-or-self::*[descendant-or-self::*[@tei:num]][1]/descendant-or-self::*[@tei:num]/@tei:num"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$my.num != ''">
						<xsl:copy-of select="$my.tree/tei:form[contains(tei:gramGrp/tei:num/@value, $my.num)]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$Verbose=true()">
							<xsl:message terminate="no">
								<xsl:text>WARNING: number could not be determined.</xsl:text>
							</xsl:message>
						</xsl:if>
						<xsl:copy-of select="$my.tree"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Verbose=true()">
					<xsl:message terminate="no">
						<xsl:value-of select="$my.word"/>
						<xsl:text> has no number variants.</xsl:text>
					</xsl:message>
				</xsl:if>
				<xsl:copy-of select="$my.tree"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<pac:doc>
		====
		Case
		====
	</pac:doc>
	<xsl:template name="Case">
		<xsl:param name="my.word"/>
		<xsl:param name="my.tree"/>
		<xsl:choose>
			<xsl:when test="$my.tree//tei:gramGrp/tei:case">
				<xsl:if test="$Verbose=true()">
					<xsl:message terminate="no">
						<xsl:value-of select="$my.word"/>
						<xsl:text> has case variants.</xsl:text>
					</xsl:message>
				</xsl:if>
				<xsl:variable name="my.case">
					<xsl:value-of select="ancestor-or-self::*[descendant-or-self::*[@tei:case]][1]/descendant-or-self::*[@tei:case]/@tei:case"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$my.case != ''">
						<xsl:copy-of select="$my.tree/tei:form[contains(tei:gramGrp/tei:case/@value, $my.case)]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$Verbose=true()">
							<xsl:message terminate="no">
								<xsl:text>WARNING: case could not be determined.</xsl:text>
							</xsl:message>
						</xsl:if>
						<xsl:copy-of select="$my.tree"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Verbose=true()">
					<xsl:message terminate="no">
						<xsl:value-of select="$my.word"/>
						<xsl:text> has no case variants.</xsl:text>
					</xsl:message>
				</xsl:if>
				<xsl:copy-of select="$my.tree"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<pac:doc>
		======
		Gender
		======
	</pac:doc>
	<xsl:template name="Gender">
		<xsl:param name="my.word"/>
		<xsl:param name="my.tree"/>
		<xsl:choose>
			<xsl:when test="$my.tree//tei:gramGrp/tei:gen">
				<xsl:if test="$Verbose=true()">
					<xsl:message terminate="no">
						<xsl:value-of select="$my.word"/>
						<xsl:text> has gender variants.</xsl:text>
					</xsl:message>
				</xsl:if>
				<xsl:variable name="my.gen">
					<xsl:value-of select="ancestor-or-self::*[descendant-or-self::*[@tei:gen]][1]/descendant-or-self::*[@tei:gen]/@tei:gen"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$my.gen != ''">
						<xsl:copy-of select="$my.tree/tei:form[contains(tei:gramGrp/tei:gen/@value, $my.gen)]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$Verbose=true()">
							<xsl:message terminate="no">
								<xsl:text>WARNING: gender could not be determined.</xsl:text>
							</xsl:message>
						</xsl:if>
						<xsl:copy-of select="$my.tree"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Verbose=true()">
					<xsl:message terminate="no">
						<xsl:value-of select="$my.word"/>
						<xsl:text> has no gender variants.</xsl:text>
					</xsl:message>
				</xsl:if>
				<xsl:copy-of select="$my.tree"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<pac:doc>
		============
		Definiteness
		============
	</pac:doc>
	<xsl:template name="Definiteness">
		<xsl:param name="my.word"/>
		<xsl:param name="my.tree"/>
		<xsl:choose>
			<xsl:when test="$my.tree//tei:gramGrp/tei:oVar">
				<xsl:if test="$Verbose=true()">
					<xsl:message terminate="no">
						<xsl:value-of select="$my.word"/>
						<xsl:text> has (in)definite variants.</xsl:text>
					</xsl:message>
				</xsl:if>
				<xsl:variable name="my.oVar">
					<xsl:value-of select="ancestor-or-self::*[descendant-or-self::*[@tei:oVar]][1]/descendant-or-self::*[@tei:oVar]/@tei:oVar"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$my.oVar != ''">
						<xsl:copy-of select="$my.tree/tei:form[contains(tei:gramGrp/tei:oVar/@value, $my.oVar)]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$Verbose=true()">
							<xsl:message terminate="no">
								<xsl:text>WARNING: definiteness could not be determined.</xsl:text>
							</xsl:message>
						</xsl:if>
						<xsl:copy-of select="$my.tree"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$Verbose=true()">
					<xsl:message terminate="no">
						<xsl:value-of select="$my.word"/>
						<xsl:text> has no (in)definite variants.</xsl:text>
					</xsl:message>
				</xsl:if>
				<xsl:copy-of select="$my.tree"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
