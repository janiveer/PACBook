Resolves image file references against all ancestor `xml:base` attributes.

## Parameters

None.

## Input

A DocBook document. Chapters or sections which have been transcluded must have `xml:base` attributes giving their origin, either absolute or relative to the complete document.

## Output

A DocBook document, identical to the input except that any image file references are resolved against all ancestor `xml:base` attributes.

## Description

The stylesheet recurses through the document and copies each element. For each `<imagedata>` element, if there is a `fileref` attribute, it is resolved against all ancestor `xml:base` attributes and written to the output document.

It is assumed that document modules refer to image files relative to their own location. You can use this stylesheet to modify image file references to point to the location of the original image relative to the assembled document’s location. The transclusion or assembly process used to build the document must add `xml:base` attributes to show the origin of each document module.
