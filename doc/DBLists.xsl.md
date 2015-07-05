Turns simple inline lists into punctuated lists and adds a final “and” or “or” in the appropriate language.

## Parameters

None.

## Input

A DocBook document containing `<simplelist type='inline'>` elements.

## Output

A DocBook document, identical to the input except that any `<simplelist type='inline'>` elements are replaced with punctuated inline lists with a final “and” or “or” in the appropriate language.

## Description

The stylesheet recurses through the document and copies each element. For each `<simplelist type='inline'>` element, the members of the list are output as a comma separated inline list.

If the `role` attribute of the `<simplelist>` is set to `and`, the conjunction “and” is added before the final member of the list in the language specified by the nearest ancestor `xml:lang` element. Likewise, if the `role` attribute of the `<simplelist>` is set to `or`, the conjunction “or” is added before the final member of the list in the language specified by the nearest ancestor `xml:lang` element.

This stylesheet has similar functionality to the way `<simplelist type='inline'>` elements are processed by the DocBook XSL stylesheets. The differences are:

1. The final conjunction is specified via the `role` attribute.

2. For languages which require it, the final conjunction is output within a wrapper element with the `ling:type='dep'` attribute. This enables you to use the [LingDepend.xsl](LingDepend.xsl) stylesheet on the output file to select the correct form of the final conjunction, depending on the phonetic environment.

For example, in Spanish, if the `role` attribute is set to `and`, the [LingDepend.xsl](LingDepend.xsl) stylesheet will change the final conjunction to “e” if the following word begins with an “i” sound, or “y” otherwise. (There must be wrapper elements, e.g. `<phrase>`, around each term in the list, using the `ling:pron` attribute to indicate the initial sound of each term.)

The final conjunctions are specified in the `DataLabels.xml` file. The supported languages are German, English, Spanish, Finnish, French, Italian, Norwegian Bokmål, Dutch, Portuguese, Swedish and Simplified Chinese.