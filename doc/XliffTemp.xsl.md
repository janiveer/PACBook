Unescapes escaped markup in an [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file.

## Parameters

None.

## Input

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document containing escaped inline markup.

## Output

A temporary, invalid [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document containing unescaped inline markup.

## Description

The stylesheet copies the structure and content of the input document to the output document. Any escaped inline  markup within the input document is unescaped.

The output of this stylesheet is intended to be used as input for [XliffTag.xsl](XliffTag.xsl), which turns the inline markup into valid [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) `<g>`, `<ph>`, `<x>` and `<mrk>` elements.