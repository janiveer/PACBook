Makes sure that abbreviations are punctuated correctly after transclusion.

## Parameters

`[abbrevClassRef]`

* **abbrevClassRef** (URI) — a URI that identifies abbreviations. Default http://dbpedia.org/ontology/abbreviation.

## Input

An XML document. Any abbreviations whose punctuation needs checking must be marked up with ITS 2.0 text analysis attributes as described below.

## Output

An XML document, identical to the input except that abbreviations are punctuated correctly.

## Description

The stylesheet recurses through the document and copies each element. If any element has the attribute `its:taClassRef='http://dbpedia.org/ontology/abbreviation'`, the stylesheet adds punctuation to the element according to the following algorithm:

1. If the text within the element already ends with a full stop, the full stop is stripped off;
2. If there is a full stop immediately following the element, the element is written to the output document with no following full stop; otherwise, the element is written to the output document with a following full stop.

This means that the abbreviation will be written out with just one following full stop. If you transclude the abbreviation at the end of sentence it will _not_ end up with two following full stops.

To use the `its:taClassRef` attribute you must set `its:version='2.0'` on the element or on the containing document.
