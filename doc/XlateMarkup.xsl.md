Marks up translatable elements in an XML document with a unique `xlf:id` attribute.

## Parameters

`[ITS] [Counter] [Carried]`

* **ITS** (URI) — URI of the [ITS](http://www.w3.org/TR/its20/) rules file, absolute or relative to the stylesheet
* **Counter** (URI) — URI of the input counter file, absolute or relative to the input document
* **Carried** (URI) — URI of the output counter file, absolute or relative to the input document

## Input

An XML document. DocBook is supported by default; SVG to follow.

## Output

An XML document, identical to the input except that translation strings are uniquely identified by auto-generated `xlf:id` attributes. 

## Description

The stylesheet first looks for the translation unit counter specified by the `Counter` parameter. This translation unit counter is an automatically-generated XML document containing a single element, `<data:counter xmlns:data="urn:x-pacbook:data">`. The `<data:counter>` element contains a text node, which must be an integer. It can also have a single attribute, `prefix`, which should contain an alphanumeric string. 

The purpose of the translation unit counter is to keep track of the translation unit IDs which have been assigned to this document, and ensure that newly marked-up translatable elements get unique IDs. The simplest use case would be to have a single translation unit counter for all your documents. Realistically you would use more than one translation counter. Several related documents might share a translation unit counter; this would imply that the related documents are all translated together, using a single [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file for each target language. You could also, if you wanted, use a different prefix with each translation unit counter, but this is not necessary.

If the translation unit counter is not specified, it is assumed to be `counter.xml` in the same location as the input document.

If the specified translation unit counter is not found, the prefix is assumed to be `u` and the count is set to 0.

The stylesheet then looks for the specified [ITS](http://www.w3.org/TR/its20/) rules file. This is a set of [ITS](http://www.w3.org/TR/its20/) 2.0 rules that specify which elements in the input file correspond to translation units. For each `<its:withTextRule>` element in the [ITS](http://www.w3.org/TR/its20/) rules file, if the `withinText` attribute is set to `no`, the elements specified by the `selector` attribute correspond to translation units. If no [ITS](http://www.w3.org/TR/its20/) rules file is specified, the default is the `DocBook.its` file supplied with this stylesheet.

The stylesheet then copies the structure and content of the input document to the output document. Any elements which match the specified [ITS](http://www.w3.org/TR/its20/) rules are marked up with a unique `xlf:id` attribute, as long as:

1. They are _not_ marked with the `its:translate="no"` attribute, and
3. They do not have an `xlf:id` attribute already.

Furthermore, any elements which are marked with the `its:translate="yes"` attribute are also marked up with a unique `xlf:id` attribute, as long as they do not have an `xlf:id` attribute already.

The value of the `xlf:id` attribute consists of the specified prefix, followed by a sequential count of the newly marked up translatable elements, starting at the next number after the number specified in the translation unit counter, if any. (The `xlf:id` attribute is used in preference to `xml:id` because transclusion might mean that the same translatable element occurs in several places in the same document, and `xml:id` must contain unique values.)

Finally, the new total number of marked up translatable elements is written out to the translation unit counter file specified by the `Carried` parameter. By default, this is assumed to be `counter.xml` in the same location as the input document, thus overwriting the original translation unit counter file with the new total.

In theory, this stylesheet can be used to mark up any XML document, as long as a correctly formatted [ITS](http://www.w3.org/TR/its20/) rules file is supplied. However, you must make sure that any namespaces specified in the [ITS](http://www.w3.org/TR/its20/) rules file are also declared in this stylesheet. 