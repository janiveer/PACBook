Selects the required declension of head nouns in an XML document.

## Parameters

None.

## Input

An XML document. You must mark up the source document with linguistic attributes describing the syntactic case and / or definiteness required for each head noun in the document.

## Output

An XML document, identical to the input except that head nouns are declined for syntactic case and / or definiteness. 

## Description

The stylesheet recurses through the document and copies each element. If any element is marked as a head noun, the  stylesheet selects the correct declension based on the syntactic case and definiteness specified by the nearest ancestor element.

This is useful when you need to transclude a term into a sentence and want to select the correct form of the term, depending on the case and / or definiteness required in the target sentence.

When you define a noun for transclusion, you must include in the transcluded text all the possible forms of the head noun in the current language. Each form must be wrapped in a suitable spanning element, e.g. `<phrase>` in DocBook, `<ph>` in DITA or `<span>` in HTML. Each form should have the `ling:type='head'` to indicate that it is a head noun, and should also have `ling:case` and `ling:class` attributes to specify the case and / or definiteness of each form, depending on the language.

At each location where the term is to be transcluded, you must wrap the transcluded term and any preceding or following dependent words, e.g. articles or adjectives, in another spanning element. This spanning element should be marked up with the case and / or definiteness you require for this instance of the term, depending on the current language.

* The `ling:case` attribute may have any string value, as long as it matches a value used to mark case in the PACBook syntactic dictionary for the current language. In the PACBook syntactic dictionaries, the values used are `nom` for nominative, `acc` for accusative, `gen` for genitive and `dat` for dative. The `gen` case is used to mark the possessive in English. If the stylesheet cannot determine the required case for a transcluded term, it assumes the nominative form is required.

* The `ling:class` attribute may have any string value, as long as it matches a value used to mark inflectional class in the PACBook syntactic dictionary for the current language. In the PACBook syntactic dictionaries, the values used in German are `strong`, `weak` and `mixed`; the values used in Dutch, Swedish and Norwegian  are `ind` for indefinite, `def` for definite. If the stylesheet cannot determine the required inflectional class for a transcluded term, it assumes the indefinite form is required.

The namespace URI for the linguistic attributes is `http://stanleysecurity.github.io/PACBook/ns/linguistics`.

This stylesheet should be applied after the head nouns have all been transcluded into place. When the stylesheet finds a head element, it checks whether the element’s definiteness and / or case match the definiteness and / or case of the nearest ancestor element. If they match, the head element is copied to the output; if not, the head element and all its descendent elements are deleted.

## Roadmap

The stylesheet matches DocBook `<token>` elements as well as elements with the `ling:type='head'` attribute. Remove this in a future release.