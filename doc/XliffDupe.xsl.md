Purges duplicate translation units from an [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file.

## Parameters

None.

## Input

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document.

## Output

An [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) document.

## Description

This is a deterministic deduplication; the stylesheet checks for translation units with duplicate IDs, keeps the first and discards any others.