<?xml version='1.0'?>

<!--
    Copyright © 2015 Stanley Security Solutions Limited.

    This file is part of PACBook.

    PACBook is free software: you can redistribute it and/or modify it under the
    terms of the GNU Lesser General Public License as published by the Free
    Software Foundation, either version 3 of the License, or (at your option)
    any later version.

    PACBook is distributed in the hope that it will be useful, but WITHOUT ANY
    WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
    more details.

    You should have received a copy of the GNU Lesser General Public License
    along with PACBook.  If not, see <http://www.gnu.org/licenses/>.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:ling="http://stanleysecurity.github.io/PACBook/ns/linguistics"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:pac="urn:x-pacbook:functions"
                exclude-result-prefixes="xd pac tei db"
                version="1.1">
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	<xsl:include href="common/CommonFunctions.xsl"/>
	<xsl:param name="Verbose" select="false()"/>
	<xsl:param name="Dictionary" select="'data/DataSyntax.xml'"/>

	<xd:doc>
		===========================================================
		Stylesheet for processing morphology in XML documents.

		This stylesheet inflects dependent words by phonological
		environment, case, gender and number.
		===========================================================
	</xd:doc>

	<xd:doc>
		==============
		Main recursion
		==============
	</xd:doc>
	<xsl:template match="*|text()|processing-instruction()|comment()">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
		</xsl:copy>
	</xsl:template>

	<xd:doc>
		============
		Morphosyntax
		============
	</xd:doc>
	<xsl:template match="db:wordasword|*[@ling:type='depend']">
		<xsl:variable name="my.word" select="text()"/>
		<xsl:variable name="my.norm" select="pac:lc($my.word)"/>
		<xsl:variable name="my.lang" select="pac:lang()"/>
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
					<xsl:if test="$my.init = pac:uc($my.init) and not(@ling:orth)">
						<xsl:attribute name="ling:orth">
							<xsl:value-of select="'sentence'"/>
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

	<xd:doc>
		=========
		Phonology
		=========
	</xd:doc>
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
					<xsl:value-of select="following-sibling::*/descendant-or-self::db:phrase[@ling:pron][1]/@ling:pron"/>
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

	<xd:doc>
		======
		Number
		======
	</xd:doc>
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
					<xsl:value-of select="ancestor-or-self::*[descendant-or-self::*[@ling:num]][1]/descendant-or-self::*[@ling:num]/@ling:num"/>
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

	<xd:doc>
		====
		Case
		====
	</xd:doc>
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
					<xsl:value-of select="ancestor-or-self::*[descendant-or-self::*[@ling:case]][1]/descendant-or-self::*[@ling:case]/@ling:case"/>
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

	<xd:doc>
		======
		Gender
		======
	</xd:doc>
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
					<xsl:value-of select="ancestor-or-self::*[descendant-or-self::*[@ling:gen]][1]/descendant-or-self::*[@ling:gen]/@ling:gen"/>
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

	<xd:doc>
		============
		Definiteness
		============
	</xd:doc>
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
					<xsl:value-of select="ancestor-or-self::*[descendant-or-self::*[@ling:class]][1]/descendant-or-self::*[@ling:class]/@ling:class"/>
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
