Enables you to include or exclude parts of a document conditionally based on the document’s ID.

## Parameters

All of the DocBook XSL stylesheet profiling parameters, except for **profile.condition** — see below.

## Input

A DocBook document with conditional profiling attributes.

## Output

A profiled DocBook document.

## Description

This stylesheet is a custom layer which imports the `profile.xsl` stylesheet from the DocBook XSL stylesheets.

For quicker processing and to save network bandwith, you should set up your XML catalog so that http://docbook.sourceforge.net/release/xsl-ns/current/profiling/profile.xsl is redirected to your local copy of `profile.xsl`.

This stylesheet takes the `xml:id` attribute from the root element in the document and passes that to `profile.xsl` as the value of the `profile.condition` parameter. The result of this is that any elements in the document which have the `condition` attribute set to the document’s XML ID are included in the output; any which have the `condition` attribute set to something else are excluded.

This enables you to specify that certain parts of a subdocument should be omitted and certain parts kept when the subdocument is transcluded into a particular master document, based solely on that master document’s ID.

If necessary, you can supply a fake ID value to the `profile.xsl` stylesheet by adding a `condition` attribute to the root element of the master document. The stylesheet will take this as the value of the `profile.condition` parameter in preference to the root `xml:id` attribute.

It is recommended to perform conditional profiling as a separate step when using PACBook. For example, you should process parametrised transclusion _before_ conditional profiling, and you should process dynamic links, simple lists and syntactic processing _after_ conditional profiling. 

## Roadmap

Add support for `its:localeFilterList` and `its:localeFilterType` attributes.