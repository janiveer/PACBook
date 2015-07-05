To use the PACBook stylesheets to translate an XML document, you need to tell PACBook where the translations for that document are. You do this by adding translation metadata to the document.

## Where to Add Translation Metadata

Translation metadata takes the form of RDF triples. You add it to the metadata section of the XML document. So, for a DocBook 5.0 document, you add it to the `<info>` element at the start of the document. For an SVG document, you add it to the `<metadata>` element at the start of the document.

## How to Write It

Typical translation metadata for a DocBook document looks like this:

	<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	         xmlns:bibo="http://purl.org/ontology/bibo/"
	         xmlns:vivo="http://vivoweb.org/ontology/core#"
		<bibo:Document rdf:about="">
			<vivo:hasTranslation xml:base="http://DBK/Topics/512_Series/xlate/">
				<rdf:Alt>
					<rdf:li xml:lang="de" rdf:resource="ac_de.xliff"/>
					<rdf:li xml:lang="es" rdf:resource="ac_es.xliff"/>
					<rdf:li xml:lang="fr" rdf:resource="ac_fr.xliff"/>
					<rdf:li xml:lang="nb" rdf:resource="ac_nb.xliff"/>
					<rdf:li xml:lang="nl" rdf:resource="ac_nl.xliff"/>
					<rdf:li xml:lang="sv" rdf:resource="ac_sv.xliff"/>
					<rdf:li xml:lang="zh" rdf:resource="ac_zh.xliff"/>
				</rdf:Alt>
			</vivo:hasTranslation>
			<!-- Other RDF properties ... -->
		</bibo:Document>
	</rdf:RDF>

In this example:

* The `<bibo:Document>` element declares that this file is a document and that it this document is the subject of the translation metadata. You could (but don’t have to) use `<bibo:Image>` instead of `<bibo:Document>` in translation metadata that applies to an SVG file.

* The `<vivo:hasTranslation>` element declares that this document has translations associated with it. The optional `xml:base` attribute can be used to indicate where all the translations are.

* The translations are indicated by `<rdf:li>` elements all wrapped within the `<rdf:Alt>` element. For each translation, the `xml:lang` attribute represents the language; the `rdf:resource` attribute shows the name of the [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) file which contains the translation in that language. The `rdf:resource` attribute may contain an absolute or relative URI; if relative, it is combined with the `xml:base` attribute of the `<vivo:hasTranslation>` element to define the full URI.

* Notice that you need to declare the `rdf`, `bibo` and `vivo` namespaces.

## Translation Metadata for Part of a Document

Different parts of a document might store their translations in different [XLIFF](http://docs.oasis-open.org/xliff/v1.2/os/xliff-core.html) files. To specify translation metadata for part of a file, you add it to the metadata section for that part. So, to specify translation metadata that only applies to a particular chapter in a DocBook file, you would add the translation metadata to the `<info>` element at the start of the chapter. This would override any translation metadata at the start of the book.

You could (but don’t have to) use `<bibo:DocumentPart>` instead of `<bibo:Document>` in translation metadata that only applies to part of a document.

To work out which XLIFF file to use when translating a particular element, the PACBook stylesheets look for the nearest ancestor element which has a child element which contains translation metadata as described above.