Checks an XML document against an existing translation in the specified language and generates a new [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file containing the strings which are new or changed.

## Parameters

`(Language | Xliff)`

* **Language** (string) — ISO language code
* **Xliff** (URI) — The URI of the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file you want to compare

## Input

An XML document. You must mark up the source document with:

1. The `xlf:id` attributes which uniquely identify each translation string.
2. Optionally, [translation metadata](RDF-Translations), showing the location of the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) files which contain the translations of the document — this is only required if you are not specifying the `Xliff` parameter explicitly.

## Output

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document.

## Description

The stylesheet examines the source file for translatable elements. (A translatable element is one which has an `xlf:id` attribute and does not have the `its:translate="no"` attribute.)

For each translatable element, the stylesheet looks for the specified [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file, or if not specified, the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file that corresponds to the specified output language, according to the [translation metadata](RDF-Translations).

If the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file is found, the stylesheet searches for the translation unit with the same `xlf:id`, and compares its source with the translatable element in the source document.

If the corresponding translation unit does not exist in the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file, a new translation unit is written to the output document which contains this translatable element as its source.

If the corresponding translation unit exists in the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file, but its source is different from the translatable element in the source document, a translation unit is written to the output document which contains this translatable element as its source and the target text from the original [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file as its target.

If the corresponding translation unit exists in the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file, and its source is the same as the translatable element in the source document, and the target is empty or marked as incomplete, the translation unit is copied from the original [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file to the output document.

If the corresponding translation unit exists in the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file, and its source is the same as the translatable element in the source document, and the target is not empty or marked as incomplete, there is no output.

If the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file is not found, there is no output.

### Note

In the output file, all `<trans-unit>` elements are contained in a single, flat `<file>` element. Any multiple `<file>` or `<group>` elements from the original [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file are not copied to the output file.