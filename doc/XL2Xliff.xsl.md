Exports from a Microsoft Excel 2003 XML workbook to an [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file.

## Parameters

None.

## Input

A Microsoft Excel 2003 XML workbook.

## Output

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file.

## Description

The stylesheet exports the content of a Microsoft Excel 2003 XML workbook to an [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file.

The workbook’s `Source` custom property is exported as the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file’s `original` property. The `Language` custom property is exported as the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file’s `source-language` property. The `Destination` custom property is exported as the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file’s `target-language` property.

The `Title`, `Subject` and `Version` properties of the workbook are exported to the `note` element within the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file’s `header` element.

The spreadsheet to be exported must be titled `Xlate`. Every other spreadsheet in the workbook is ignored.

Within the exported spreadsheet, each row is exported to a single translation unit. The first row in the spreadsheet is assumed to be a header row and is ignored.

In each row, the content of the first column is exported as the `ID` attribute of the translation unit. The content of the second column is exported as the content of the `source` element. The content of the third column is exported as the content of the `target` element. The content of the fourth column, if any, is exported as the content of the `note` element. All other content is ignored.