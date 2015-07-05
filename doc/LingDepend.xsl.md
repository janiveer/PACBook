Uses a [TEI](http://www.tei-c.org/) syntactic dictionary to inflect specified words, e.g. determiners, adjectives, and relative pronouns, in an XML document.

## Parameters

`[Verbose] [Dictionary]`

* **Verbose** (Boolean) — Whether full error messages should be displayed.
* **Dictionary** (URI) — the location of the [TEI](http://www.tei-c.org/) syntactic dictionary, absolute or relative to the stylesheet.

## Input

An XML document. You must mark up the source document with linguistic attributes identifying the dependent words in the document and describing the syntactic and / or phonetic environment for each dependent word.

## Output

An XML document, identical to the input except that dependent words are inflected by phonology, case, gender and number.

## Description

The stylesheet recurses through the document and copies each element. If any element has the attribute `ling:type='depend'`, the stylesheet changes the text nodes in this element to match the phonological and syntactic environment.

This is useful for transclusion. If you transclude a term into a document, you can inflect dependent words such as determiners, adjectives, and relative pronouns which surround the transcluded term.

To determine the phonetic environment for a dependent word, the stylesheet looks for the nearest following sibling element which has a `ling:pron` attribute, or which has a child element with a `ling:pron` attribute.

To determine the syntactic environment for a dependent word, the stylesheet looks for the nearest element in the document tree with a `ling:num`, `ling:case`, `ling:gen` or `ling:class` attribute. In elements containing a single head word, these attributes can be marked on the head word. (The head word must be wrapped in a suitable element such as `<phrase>` in DocBook.) In elements containing multiple head words, attributes which are intrinsic to the head word (i.e. `ling:num` and `ling:gen`) may be marked on the head word, and attributes which describe the syntactic role of the word in the sentence (i.e. `ling:case` and `ling:class`) may be marked on another wrapper element that surrounds a single head word and all its dependent words.

The linguistic attributes are as follows:

* `ling:pron` — Indicates the pronunciation or phonetic environment that the head word governs. This is not the full pronunciation of the word. For most languages that require this feature, `ling:pron="V"` indicates that
the word is pronounced with an initial vowel; `ling:pron="C"` that the word is pronounced with an initial consonant. The value of the attribute can be tailored to the language. So for Italian, `ling:pron="S"` indicates that the word is pronounced with an initial “s” cluster, “gn”, “ps”, “x” or “z”. For Spanish, `ling:pron="A"` indicates that the word has an initial stressed “a”.

* `ling:num` — Indicates grammatical number. Possible values are `sg` singular, `pl` plural, etc.

* `ling:case` — Indicates grammatical case. Possible values are `nom` nominative, `gen` genitive, `dat` dative, `acc` accusative, etc.

* `ling:gen` — Indicates grammatical gender. Possible values are `c` common, `m` masculine, `f` feminine, `n` neutral, etc.

* `ling:class` — Indicates the inflection class. Possible values are `def` definite, `ind` indefinite, `strong`, `weak`, `mixed`, etc.

The namespace URI for the linguistic attributes is `http://stanleysecurity.github.io/PACBook/ns/linguistics`.

Having found the head word and determined the syntactic and phonetic environment, the stylesheet looks for the syntactic dictionary. This is an XML dictionary using a schema which complies with the dictionary module of the Text Encoding Initiative [TEI](http://www.tei-c.org/). The dictionary is primarily designed to handle words in closed semantic categories, e.g. definite and indefinite articles, demonstrative adjectives. The dictionary also contains common contractions, such as German _im_, _vom_, _beim_, or French _des_, _aux_. Words in open semantic categories pose more of a problem. It does not yet contain very many adjectives. 

The stylesheet uses the text content of the dependent word to look up the correct word in the dictionary. It then uses the syntactic and phonetic environment to select the correct inflected form of the word, and copies this into the document.

If no [TEI](http://www.tei-c.org/) dictionary is specified, the default is the `DataSyntax.xml` file supplied with this stylesheet.

If the `Verbose` parameter is set to true, i.e. anything other than 0 or the empty string, detailed messages are displayed as each dependent word is inflected. This can help to work out what’s gone wrong when a word is not inflected properly.

## Roadmap

The stylesheet matches DocBook `<wordasword>` elements as well as elements with the `ling:type='depend'` attribute. Remove this in a future release.