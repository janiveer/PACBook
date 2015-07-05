Enables parametrised transclusion.

## Parameters

`[defRole]`

* **defRole** (URI) — A URI which identifies the transclusion XLink role. Default is http://stanleysecurity.github.io/PACBook/role/transclusion.

## Input

An XML document containing parameter definitions and references.

## Output

An XML document, identical to the input except that parameter references are replaced by their definitions.

## Description

This stylesheet enables you to transclude small snippets of XML to other locations within the document. It is complementary to the standard XML methods of transclusion using XInclude, in that it enables you to redefine text replacements locally. It is based on early versions of the [proposed standard for DocBook transclusion](http://docbook.org/docs/transclusion).

Transclusion can be divided into large scale, context-free transclusion and small scale, parametrised transclusion. It is often necessary to perform the two types of transclusion in separate steps. For example, in DocBook, using an assembly to include chapters or sections in a book is also large scale and context-free. This stylesheet, on the other hand, is designed for small scale, parametrised transclusion; for example, inserting a product name at multiple locations in the document.

To define XML snippets for transclusion (“parameter definitions”) create an extended link element with the specified transclusion role URI in the metadata at the start of the document. Within this extended link element add XLink resource elements which contain the XML text or elements for transclusion. (To refer to an external set of definitions, use XInclude to transclude the parameter definitions into the document!) Each XLink resource must have an `xl:label` attribute which enables you to refer to this parameter.

To redefine parameters locally, e.g. within a single section of the document, add new parameter definitions in the same way to the metadata at the start of that section.

To mark the places where the XML snippets should be transcluded (“parameter references”) add elements with the `content:ref` attribute to the body of the document. The `content:ref` attribute should contain the name of the parameter that you want to include at this point. Which element you use depends on the circumstances. For purposes of validation you should use an element which is permitted at the location of the parameter reference. In most cases you may want to use an empty generic wrapper element, such as `<phrase>` in DocBook.

When the stylesheet is run, it parses the document and finds any element with the `content:ref` attribute. When it does so, it finds the nearest ancestor element which contains an extended link element with the specified transclusion role URI, which in turn contains a parameter definition whose `xl:label` attribute matches the `content:ref` attribute. The stylesheet keeps the reference element, but replaces the content of the element with the content of the parameter definition.

You should run this stylesheet after initial large scale, context-free transclusion. If any of your translation strings contain parameter references, you may need to run this stylesheet after translation instead.

Small scale, inline transclusion can have linguistic consequences. See [LingHead.xsl](LingHead.xsl), [LingDepend.xsl](LingDepend.xsl), [LingCasing.xsl](LingCasing.xsl) and [TextAbbrev.xsl](TextAbbrev.xsl) for details of stylesheets that attempt to deal with these problems.

### Notes

* In order to avoid the problem of duplicate IDs, parameter definitions simply should not contain XML IDs. You could use a schematron rule to enforce this.

* It is the responsibility of the author to ensure that the content of the parameter definitions is valid in all the locations where it is transcluded. You may want to validate the document after parametrised transclusion is complete.

## Roadmap

Extended links are overloaded in PACBook. Find some other markup for parameter definitions. Perhaps [DoCO](http://purl.org/spar/doco) or the [Document Structural Patterns Ontology](http://www.essepuntato.it/2008/12/pattern).