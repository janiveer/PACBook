Uses the Apache Catalog Resolver to resolve URIs, e.g. image file references, against an XML catalog.

## Parameters

None.

## Input

A DocBook document, in which some images have a `fileref` attribute which is set to a URI.

## Output

A DocBook document, identical to the input except that any `fileref` attributes are resolved against the XML catalog.

## Description

The stylesheet recurses through the document and copies each element. If any element has the attribute `fileref`, which contains a URI starting with `http://`, the stylesheet resolves the URI against the XML catalog.

This is useful if you wish to reference remote resources in the document.

## Notes

This stylesheet only works with Java-based XSLT processors. It has been tested with Saxon 6.5.5. To use it, you must:

1. Download the XML Catalog Resolver from the [Apache XML Commons](http://xerces.apache.org/xml-commons/).

2. Set up your XML catalog correctly.

3. Configure your `CatalogManager.properties` file to point to your XML catalog.

4. Add `resolver.jar` and `CatalogManager.properties` to your classpath when you invoke the XSLT processor.

## Roadmap

Generalise to work with any specified attribute in any specified namespace.