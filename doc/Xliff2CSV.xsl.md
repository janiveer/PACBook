Exports an [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file to a tab or comma delimited text file.

## Parameters

`[EOL] [Separator] [Delimiter] [Header]`

* **EOL** (String) — The line ending characters. Default carriage return + line feed.
* **Separator** (String) — The character between fields. Default tab.
* **Delimiter** (String) — Character surrounding fields. Default single quote.
* **Header** (Boolean) — Whether or not the first row is a header row. Default false.

## Input

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document.

## Output

A tab or comma delimited text file.

## Description

The stylesheet exports the content of an [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file as a UTF-8 encoded, tab or comma delimited text file. This can be imported into a spreadsheet.

The first column contains the translation unit ID, second column the `resname` attribute, third column the source text, fourth column the target text and fifth column notes, if any.

If the `Header` parameter is set to true, i.e. anything other than 0 or the empty string, the first row of the exported text file is a header row containing the text `ID`, source language code, target language code, `Notes`.