Translates any XML document into the specified language.

## Parameters

`Language`

**Language** (string) — ISO language code

## Input

An XML document. You must mark up the source document with:

1. [Translation metadata](RDF-Translations), showing the location of the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) files which contain the translations of the document.
2. The `xlf:id` attributes which uniquely identify each translation string.

## Output

A translated XML document.

## Description

The stylesheet reconstructs the structure of the source file. For each translatable string, it looks for the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file that corresponds to the specified output language. If the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file is found, it searches for the translated string and includes it in the output document. If the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file or the translated string are not found, or if the translatable string is marked with the `its:translate="no"` attribute, the source string is copied to the output document.