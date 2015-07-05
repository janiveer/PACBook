Converts a temporary, invalid [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file with unescaped inline markup to a valid XLIFF file with `<g>`, `<x>`, `<ph>` and `<mrk>` elements.

## Parameters

`[DefaultNS]`

* **DefaultNS** (URI) — The URI of the default namespace of the inline elements. Default is the DocBook namespace.

## Input

A temporary, invalid [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document containing unescaped inline markup.

## Output

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document containing `<g>`, `<ph>`, `<x>` and `<mrk>` elements. This is the format preferred by many translation houses.

## Description

The stylesheet copies the structure and content of the input document to the output document. Any inline markup within the input document is transformed as follows.

Processing instructions with no content are exported as `<x>` elements. The `ctype` attribute is set to `x-pi-` plus the name of the processing instruction. As an exception, the `<?linebreak?>` processing instruction is exported as an `<x>` element with `ctype="lb"`.

Processing instructions containing text are exported as `<ph>` elements. The `ctype` attribute is set to `x-pi-` plus the name of the processing instruction. The content of the processing instruction is exported as the content of the `<ph>` element.

Elements containing no content are exported as `<x>` elements. The `ctype` attribute is set to `x-`, followed by the prefix associated with the namespace of the current element, followed by a hyphen, followed by the name of the current element. If the namespace of the element is not specified, it is assumed to be the namespace associated with the URI specified by the `DefaultNS` parameter — by default, DocBook.

Elements containing content are exported as `<g>` elements. The `ctype` attribute is set to `x-`, followed by the prefix associated with the namespace of the current element, followed by a hyphen, followed by the name of the current element. If the namespace of the element is not specified, it is assumed to be the namespace associated with the URI specified by the `DefaultNS` parameter — by default, DocBook.

The `<g>` or `<x>` elements have an `id` attribute whose value is unique and is based on the ID of the current translation unit.

Child attributes of the elements in the input file are added to the `<g>` or `<x>` element. If the attribute is in an explicit namespace, the attribute is exported in the same namespace. If the attribute is in no namespace, it is exported in a special namespace whose prefix is `nn` and whose URI is `urn:x-no-namespace`. This is to distinguish between [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) attributes and attributes from the source file.

There are three exceptions:

* Elements with the `dita:conref` attribute are exported as `<ph>` elements whose content is the value of the `dita:conref` attribute. This makes the translation unit read more naturally and can help the translators establish the correct word order and punctuation. The `ctype` and other attributes of this `<ph>` element are set as above.

* The `its:term="yes"` attribute is exported as a child `<mrk mtype="term">` element which contains the content of the parent element.

* The `its:locNote` attribute is exported as a child `<mrk mtype="phrase">` element which contains the content of the parent element. The value of the `its:locNote` attribute is exported as a `comment` attribute on the `<mrk mtype="phrase">` element.

The content of the `<source>` element is copied to any `<target>` element which is currently empty. This is to meet the requirements of translation houses who prefer the `<target>` element to start with the `<source>` text.
The output of the [XliffTemp.xsl](XliffTemp.xsl) stylesheet is intended to be used as input for this stylesheet.