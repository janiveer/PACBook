Copies translatable elements from an XML document to a new [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file.

## Parameters

`Source`

* **Source** (string) — the name of the source document 

## Input

An XML document. You must mark up the source document with:

1. The `xlf:id` attributes which uniquely identify each translation string.

## Output

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document.

## Description

The stylesheet examines the source file for translatable elements. (A translatable element is one which has an `xlf:id` attribute and does not have the `its:translate="no"` attribute.)

For each translatable element, a new translation unit is written to the output document which contains this translatable element as its source.

For DocBook files, a header is added containing some bibliographical metadata from the source file — `db:biblioid[@class='pubsnumber']`, `db:edition` and `db:releaseinfo`.

Any inline markup within the translatable element is escaped. This enables you to examine the inline markup in a translation editor such as Virtaal.