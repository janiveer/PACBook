Purges completed translation units from an [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file.

## Parameters

None.

## Input

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document.

## Output

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document.

## Description

The stylesheet copies the structure and content of the input document to the output document. If any translation units have a target with the attribute `state="translated"`, they are not copied to the output document.

This stylesheet may be useful if you have partially translated a differential [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file, and have just run [XlateMerge.xsl](XlateMerge.xsl) to merge the completed translation units back into the main [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file.