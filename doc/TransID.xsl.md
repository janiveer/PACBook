Enables fine-grained fixup of `xml:id` attributes after transclusion.

## Parameters

`[RoleURI]`

* **RoleURI** (URI) — A URI which identifies the fixup XLink role. Default is http://stanleysecurity.github.io/PACBook/role/fixup.

## Input

An XML document containing extended links to fix up transcluded XML IDs as described below.

## Output

An XML document, identical to the input except that XML IDs are fixed up.

## Description

This stylesheet is useful if you have a subdocument which contains XML IDs and which must be transcluded into an assembly file or master document in two or more places. In order to avoid validation errors, each ID must be unique. The process of making duplicate IDs unique is called ID fixup. Other ID fixup mechanisms take a blanket approach to fixup, e.g. by adding a suffix to each ID in the transcluded subdocuments. This stylesheet is useful for cases when a fine-grained approach is required. It enables you to specify by hand how each transcluded ID should be fixed up, using XLinks.

In the assembly file or master document, at each point where you want to transclude the target subdocument, you must add an extended link element with the `xl:role` attribute set to the specified fixup role URI. This should contain one locator element for each ID that will need fixing up. Each locator element should have:

1. An `xl:label` attribute which matches one `xml:id` attribute in the subdocument.
2. An `xl:href` attribute which points to the new ID that you want the target subdocument to use.

When run, the stylesheet recurses through the document and copies each element. If any element has an `xml:id` attribute, the stylesheet looks for the nearest ancestor which contains an extended link whose `xl:role` attribute is set to  the specified fixup role URI _and_ which contains a locator element whose `xl:label` attribute is the same as the `xml:id` attribute. If it finds a matching locator, the stylesheet replaces the value of the `xml:id` attribute with the value of the locator element’s `xl:href` attribute.

You should run this stylesheet immediately after transclusion. If any of your translation strings contain `xml:id` attributes, you may need to run this stylesheet again immediately after translation.

After you have fixed up IDs, you may also need to fix up cross references or links that point to those IDs. See [TransLinks.xsl](TransLinks.xsl).

## Roadmap

At present this stylesheet requires that the extended links, locators and arcs are DocBook `<extendedlink>`, `<locator>` and `<arc>` elements, meaning that the stylesheet only works with DocBook. In future releases, this stylesheet will be updated to work with any elements with attributes `xl:type='extended'`, `xl:type='locator'` or `xl:type='arc'`. This will make the stylesheets work with any XLink-compliant XML schema, including DocBook 5.1.