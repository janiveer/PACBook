Enables fine-grained fixup of simple link attributes after transclusion.

## Parameters

`[RoleURI]`

* **RoleURI** (URI) — A URI which identifies the fixup XLink role. Default is http://stanleysecurity.github.io/PACBook/role/fixup.

## Input

An XML document containing extended links to fix up simple link attributes as described below.

## Output

An XML document, identical to the input except that simple link attributes are fixed up.

## Description

This stylesheet is useful in two scenarios:

1. If you have a subdocument which contains XML IDs and which must be included in an assembly file or master document in two or more places. In order to avoid validation errors, each ID must be unique. The process of making duplicate IDs unique is called ID fixup. After you have fixed up IDs, you may also need to fix up _inbound_ cross references or links that point to those IDs.

2. If you want to include a subdocument containing _outbound_ cross references or links to IDs in other subdocuments which are not present in the current assembly file or master document. You can fix up these links to redirect them to other IDs which are known to be present.

This stylesheet enables you to specify by hand how links should be fixed up, using XLink.

In the assembly file or master document, at the start of each section where you want to fix up links or cross references, you must add an extended link element with the `xl:role` attribute set to the specified fixup role URI. This should contain one arc element for each link that will need fixing up. Each arc element should have:

1. An `xl:from` attribute which matches a link target referenced within the subdocument
2. An `xl:to` attribute which points to the new ID that you want the link to use.

When run, the stylesheet recurses through the document and copies each element. If any element has an `xl:href` attribute, the stylesheet looks for the nearest ancestor which contains an extended link whose `xl:role` attribute is set to the specified fixup role URI _and_ which contains an arc element whose `xl:from` attribute is the same as the `xl:href` attribute. If it finds a matching arc, the stylesheet replaces the value of the `xl:href` attribute with the value of the arc element’s `xl:to` attribute.

For DocBook documents, this stylesheet also fixes up `linkend` attributes and the content of `arearefs` attributes in the same way.

You should run this stylesheet after transclusion. If any of your translation strings contain simple links, you may need to run this stylesheet after translation instead.

For fixing up IDs after transclusion, see [TransID.xsl](TransID.xsl).

## Roadmap

At present this stylesheet requires that the extended links, locators and arcs are DocBook `<extendedlink>`, `<locator>` and `<arc>` elements, meaning that the stylesheet only works with DocBook. In future releases, this stylesheet will be updated to work with any elements with attributes `xl:type='extended'`, `xl:type='locator'` or `xl:type='arc'`. This will make the stylesheets work with any XLink-compliant XML schema, including DocBook 5.1.