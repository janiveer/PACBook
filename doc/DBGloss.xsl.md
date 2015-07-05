Builds glossaries automatically and adds XLink titles to glossary terms in the document.

## Parameters

`[maxRecurseDepth]`

* **maxRecurseDepth** (Integer) — the maximum number of recursions that the stylesheet should make when following `<glosssee>` and `<glossseealso>` links; default 8.

## Input

A DocBook document. Any glossary which is to be build automatically must be marked up as described below.

## Output

A DocBook document, identical to the input except the glossary is built and glossary entries have XLink titles.

## Description

The stylesheet recurses through the document and copies each element. If any element is a `<glossary>` with the `role='collection'` attribute, the stylesheet checks every `<glossentry>` element to see if it is referenced by a  `<glossterm>` element in the document. If it is, the `<glossentry>` is written to the output document.

The functionality of this stylesheet is based on the glossary collection function in the DocBook XSL stylesheets, with the following differences:

1. Glossary entries which are referenced within the glossary via `<glosssee>` and `<glossseealso>` elements are included in the built glossary.

2. It is assumed that all required `<glossentry>` elements are already included in the glossary. To include an external glossary, use XInclude.

For example:
 
	<glossary xml:id="glossary" role="collection">
		<xi:include href="http://DBK/Topics/Common/modules/gloss_access_full.docbook"
		            xpointer="xmlns(db=http://docbook.org/ns/docbook)
		                      xpath(//db:glossary/node())"/>
	</glossary>

When following `<glosssee>` and `<glossseealso>` elements, there is a risk that the stylesheet will get trapped in circular references. To avoid this, the stylesheet will only recurse through 8 `<glosssee>` or `<glossseealso>` links. You can change the recursion depth by passing the `maxRecurseDepth` parameter to the stylesheet.

In addition to this, the stylesheet also adds an `xl:title` attribute to every `<glossterm>` element in the document. This contains the text of the referenced glossary definition. As a result, if you use the DocBook XSL stylesheets to transform the document into a web page, web site or compiled HTML help file, users will be able see a preview of a glossary definition by hovering the mouse pointer on the glossary term.

To use this stylesheet, `<glossentry>` elements must have an `xml:id` attribute and `<glossterm>` elements must reference them via their `linkend` or `xl:href` attributes.