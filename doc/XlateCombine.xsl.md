Translates any XML document into the specified languages.

## Parameters

`Language`

**Language** (string) — List of ISO language codes, separated by `;`

## Input

An XML document. You must mark up the source document with:

1. [Translation metadata](RDF-Translations), showing the location of the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) files which contain the translations of the document.
2. The `xlf:id` attributes which uniquely identify each translation string.

In the [translation metadata](RDF-Translations), one of the specified translations should have the language code `zxx` and should point to a file which contains the separator text to display between each language.

## Output

A multi-lingual XML document.

## Description

The stylesheet reconstructs the structure of the source file. For each translatable string, it looks first for the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file that corresponds to the `zxx` output language. If the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file is found, it searches for the translated string and sets that as the separator text; if the separator text is not specified for this translatable string, or if the separator text file is not found, a middle dot ` · ` is set as the separator text.

The stylesheet outputs the source translatable string to the output file. Then, the stylesheet parses the list of target languages. For each target language, it first outputs the separator text. Then it looks for the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file that corresponds to the specified language. If the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file is found, it searches for the translated string and includes it in the output document. If the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file or the translated string are not found, the source string is copied to the output document again.

If the translatable string is marked with the `its:translate="no"` attribute, the source string is simply copied to the output document and the list of output languages is not parsed.

### Note

The language of the output document is set to `xml:lang="mul"`, the ISO code for multiple languages.