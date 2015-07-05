Checks an XML document against an existing translation and a differential translation in the specified language and generates a new [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file merging the two translations.

## Parameters

`(Language | Xliff)  Diff`

* **Language** (string) — ISO language code,
* **Xliff** (URI) — The URI of the original [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file
* **Diff** (URI) — The URI of the differential [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file

## Input

An XML document. You must mark up the source document with:

1. The `xlf:id` attributes which uniquely identify each translation string.
2. Optionally, [translation metadata](RDF-Translations), showing the location of the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) files which contain the translations of the document — this is only required if you are not specifying the `Xliff` parameter explicitly.

## Output

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document.

## Description

The stylesheet examines the source file for translatable elements. (A translatable element is one which has an `xlf:id` attribute and does not have the `its:translate="no"` attribute.)

For each translatable element, the stylesheet searches the differential [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file for the translation unit with the same `xlf:id`. If found, and if the target of the translation unit has the attribute `status="translated"`, this translation unit is copied to the output.

If the translation unit is not found in the differential [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file, the stylesheet looks for the specified original [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file, or if not specified, the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file that corresponds to the specified output language, according to the [translation metadata](RDF-Translations).

If the original [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file is found, the stylesheet searches for the translation unit with the same `xlf:id`. If found, this translation unit is copied to the output.

If the corresponding translation unit does not exist in the differential [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file or the original [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file, there is no output.

If the original [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file is not found, there is no output.

### Note

In the output file, all `<trans-unit>` elements are contained in a single, flat `<file>` element. Any multiple `<file>` or `<group>` elements from the original or differential [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) files are not copied to the output file.