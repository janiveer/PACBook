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
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:db="http://docbook.org/ns/docbook"
                exclude-result-prefixes="xd"
                version="1.1">
	<!--
	     This stylesheet exports various values from the document
	     metadata to an ANT properties file which can then be
	     used by ANT, e.g. to place the document version number
	     into the exported PDF’s file name.
	-->
	<xsl:output method="text" encoding="UTF-8"/>

	<xd:doc>
		=======
		Edition
		=======
	</xd:doc>
	<xsl:template match="/*/db:info/db:edition">
		<xsl:text>edition=</xsl:text>
		<xsl:value-of select="translate(., '.', '')"/>
	</xsl:template>

	<xd:doc>
		=================
		Ignore other text
		=================
	</xd:doc>
	<xsl:template match="text()" />

</xsl:stylesheet>
