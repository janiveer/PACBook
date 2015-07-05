Converts an [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file with `<g>`, `<x>`, `<ph>` and `<mrk>` elements to an [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file with escaped inline markup.

## Parameters

`[DefaultNS]`

* **DefaultNS** (URI) — The URI of the default namespace of the inline elements. Default is the DocBook namespace.

## Input

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document containing `<g>`, `<ph>`, `<x>` and `<mrk>` elements.

## Output

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document containing escaped inline markup. This the format used by PACBook.

## Description

The stylesheet copies the structure and content of the input document to the output document. Any `<g>`, `<ph>`, `<x>` and `<mrk>` elements within the `<source>` elements in the input document are transformed as follows.

Any `<x>` elements whose `ctype` attribute is `lb` are exported as escaped `<?linebreak?>` processing instructions.

Any `<x>` elements whose `ctype` attribute starts with `x-pi-` are exported as escaped processing instructions with no content. The name of the processing instruction is taken from the `ctype` attribute.

Any `<ph>` elements whose `ctype` attribute starts with `x-pi-` are exported as escaped processing instructions with content. The name of the processing instruction is taken from the `ctype` attribute. The content of the `<ph>` element is exported as the content of the processing instruction.

Any other `<x>` elements are exported as escaped elements containing no content. The namespace and name of the element are taken from the `ctype` attribute. If the namespace of the element is the same as the namespace specified by the `DefaultNS` parameter — by default, DocBook — the namespace prefix is not output.

Any other `<ph>` elements are exported as escaped elements containing no content. The namespace and name of the element are taken from the `ctype` attribute. If the namespace of the element is the same as the namespace specified by the `DefaultNS` parameter — by default, DocBook — the namespace prefix is not output. The content of the `<ph>` element is exported as a `dita:conref` attribute on the exported element.

Any `<g>` elements are exported as escaped elements containing content. The namespace and name of the element are taken from the `ctype` attribute. If the namespace of the element is the same as the namespace specified by the `DefaultNS` parameter — by default, DocBook — the namespace prefix is not output.

Child attributes of the `<g>` or `<x>` element are added to the elements in the output file. If the attribute is in an explicit namespace, the attribute is exported in the same namespace. If the attribute is in the `urn:x-no-namespace` namespace, it is exported in no namespace. If the attribute is in no namespace or the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) namespace, it is ignored.

Any `<mrk mtype="term">` elements are exported as `its:term="yes"` attributes on the parent exported element. The content of the `<mrk>` element becomes the content of the parent exported element.

Any `<mrk mtype="phrase">` elements are exported as `its:locNote` attributes on the parent exported element. The value of the `comment` attribute is exported as value of the `its:locNote` attribute. The content of the `<mrk>` element becomes the content of the parent exported element.

Any `<g>`, `<ph>`, `<x>` and `<mrk>` elements within the `<target>` elements in the input document are transformed as above, using the attributes of the corresponding `<g>`, `<ph>`, `<x>` and `<mrk>` elements within the associated `<source>` element.

This stylesheet forms a round trip with the [XliffTemp.xsl](XliffTemp.xsl) and [XliffTag.xsl](XliffTag.xsl) stylesheets.