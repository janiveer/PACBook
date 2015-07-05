Creates automatic links between sections in a document.

## Parameters

`[linkHome] [linkPart] [linkStyle]`

* **linkHome** (URI) — the XLink role used to identify the start of automatic links; default http://www.iana.org/assignments/relation/item.

* **linkPart** (URI) — the XLink role used to identify the targets of automatic links; default http://www.iana.org/assignments/relation/collection.

* **linkStyle** (String) — the style string that determines the content of the automatic links; default `select: title`.

## Input

A DocBook document. The start locations and sections to be included in automatic links must be marked up as described below.

## Output

A DocBook document, identical to the input but with automatic links between sections of the document.

## Description

To use this stylesheet you must assign a name to each set of related sections. You mark up the location for a list of automatic links by adding, in the `<info>` section at the start of a chapter or section, an `<extendedlink>` element with the `xl:role` attribute set to http://www.iana.org/assignments/relation/item.

Within this `<extendedlink>` element, add an `<arc>` child element whose `xl:to` attribute contains the name you have assigned to this set of related sections. (You can add more than one `<arc>` element if you want to create links to several named sets of related sections.)

In each chapter or section that you want to include in a set of related sections, you must add an `<extendedlink>` element with the `xl:role` attribute set to http://www.iana.org/assignments/relation/collection. This must contain a `<locator>` element whose `xl:label` attribute contains the name you have assigned to this set of related sections. (You can add more than one `<locator>` element if you want to include this chapter or section in several named sets of related sections.)

Each `<locator>` must have an `xl:href` attribute; it is good practice for this to point to the chapter or section which contains it, but the stylesheet does not look at it. It takes the ID of the containing chapter or section as the target of the link.

The stylesheet recurses through the document and copies each element. If any chapter or section of the document is marked as the start of an automatic link, the stylesheet builds an `<itemizedlist>` containing links to all the chapters or sections which are marked to be included in that named set of related sections.

The list is positioned after any body text, but before any subsections. Each link in the list is an `<xref>` element; the content is determined by the `xrefstyle` attribute, which by default is set to `select: title`.

### Link Titles

Before the `<itemizedlist>` of links, the stylesheet creates an introductory `<para>` element in the language determined by the nearest ancestor `xml:lang` attribute. By default, this contains the text called `links` from `DataLabels.xml`. In English, this is ‬“See the following sections:”. The supported languages are German, English, Spanish, French, Dutch and Swedish.

It is possible to specify different text for the introductory paragraph by adding an XLink title element to the `<extendedlink>` that marks the start of the automatic link. This is not possible in DocBook 5.0. The PACBook custom schema adds a `<title>` element to `<extendedlink>` to enable this; in DocBook 5.1, you can use a `<link xl:type='title'>` element within the `<extendedlink>`.

### Note

[RFC 6573](https://tools.ietf.org/html/rfc6573) specifies that the `item` relation points _from_ the collection _towards_ the item; the `collection` relation points _from_ the item _towards_ the collection.