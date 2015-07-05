You can add applicability metadata to a DocBook document to declare the hardware or software products that the document applies to.

## Where to Add Applicability Metadata

Applicability metadata takes the form of RDF triples. For a DocBook 5.0 document, you add it to the `<info>` element at the start of the document.

## How to Write It

Typical applicability metadata for a DocBook document looks like this:

	<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	         xmlns:bibo="http://purl.org/ontology/bibo/"
	         xmlns:vivo="http://vivoweb.org/ontology/core#"
	         xmlns:doap="http://usefulinc.com/ns/doap#">
		<bibo:Document rdf:about="">
			<vivo:hasSubjectArea>
				<rdf:Bag>
					<rdf:li rdf:parseType="Resource">
						<doap:shortdesc>P/N 1234</doap:shortdesc>
						<doap:name>Foo 3000</doap:name>
						<doap:description>Quantum Accelerator</doap:description>
						<doap:revision>1.0.1</doap:revision>
					</rdf:li>
					<rdf:li rdf:parseType="Resource">
						<doap:shortdesc>P/N 5678</doap:shortdesc>
						<doap:name>Foo Explorer</doap:name>
						<doap:description>Config File Viewer</doap:description>
						<doap:revision>1.0.2</doap:revision>
					</rdf:li>
				</rdf:Bag>
			</vivo:hasSubjectArea>
			<!-- Other RDF properties ... -->
		</bibo:Document>
	</rdf:RDF>

In this example:

* The `<bibo:Document>` element declares that this file is a document and that this document is the subject of the applicability metadata.

* The `<vivo:hasSubjectArea>` element declares that this document applies to the following products.

* The products are indicated by `<rdf:li>` elements all wrapped within the `<rdf:Bag>` element. Each `<rdf:li>` element has `rdf:parseType` set to `Resource`; this enables you to specify the properties of each product inline.

* The properties of each product are indicated by elements in the `doap` namespace. In PACBook, `<doap:shortdesc>` is used for the product’s part number, `<doap:name>` is used for the product name, `<doap:description>` for a description of the product and `<doap:revision>` for the product version number.

* Note that you need to declare the `rdf`, `bibo`, `vivo` and `doap` namespaces.

## Roadmap

The ultimate intention is that each `<rdf:li>` could point to an external RDF resource which contains the details of the product in a single location, e.g. in a products database. This is not yet implemented.
