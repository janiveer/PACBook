Adds a language code to `xml:id` attributes and the links that refer to them.

## Parameters

`[maxRecurseDepth]`

* **noFixupURI** (URI) — the XLink role used to identify links which should not be fixed up; default `http://schema.org/significantLink`.

## Input

An XML document. The root element of the document must have an `xml:lang` attribute.

## Output

An XML document.

## Description

This stylesheet copies the source document, and adds the language code specified on the document’s root element to the end of all `xml:id` attributes and all `xl:href` attributes which contain a fragment identifier.

If you do not want the language code to be added to an `xl:href` attribute, you must add an `xl:role` attribute to the linking element and set its value to the URI specified by the `noFixupURI` parameter, `http://schema.org/significantLink` by default.

In DocBook files, the language code is also added to all `linkend` and `endterm` attributes and to every value in `arearefs` attributes. This is not affected by the `xl:role` attribute.

In all cases the language code is separated from the value to which it is added by a full stop.

This stylesheet is meant to be used when combining several translated documents into a multi-lingual document.