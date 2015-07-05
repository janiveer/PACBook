Sets the orthographic case of specified text in an XML document.

## Parameters

`[ShortWords]`

* **ShortWords** (string) — English words which should not be capitalised in title case.

## Input

An XML document. You must mark up the source document with linguistic attributes describing the orthographic case which is required for the specified text — see description below.

## Output

An XML document, identical to the input except that marked text is set to the required orthographic case. 

## Description

The stylesheet recurses through the document and copies each element. If any element has the `ling:orth` attribute, the stylesheet changes the case of the text nodes in this element and all descendent elements.

This is useful for transclusion. If you transclude a term at the start of a sentence, you may want to set the case of the transcluded term to sentence case. If you transclude a term into a title, you may want to set the case of the transcluded term to title case.

This stylesheet is only relevant to languages which use orthographic case. The stylesheet supports all alphabets supported by the [XSL Standard Library](http://xsltsl.sourceforge.net/) string stylesheets, including Latin, Greek and Cyrillic.

The namespace URI for the linguistic attributes is `http://stanleysecurity.github.io/PACBook/ns/linguistics`.

The `ling:orth` attribute may have any of the following values:

* upper
* lower
* sentence
* title

### Upper

Changes the case of text nodes to upper case. This is applied to text in the current element and all descendent elements, unless any descendent elements have a different `ling:orth` attribute.

### Lower

Changes the case of text nodes to lower case. This is applied to text in the current element and all descendent elements, unless any descendent elements have a different `ling:orth` attribute.

### Sentence

Finds the first text node child of the current element and changes the first character of the word to upper case. The rest of the text nodes in this element and all descendent elements are left unchanged, unless any descendent elements have a different `ling:orth` attribute.

### Title

Splits the text into words (at spaces). If a word is _not_ listed in the `ShortWords` parameter, changes the first character of the word to upper case. This is applied to text nodes in the current element and all descendent elements, unless any descendent elements have a different `ling:orth` attribute.

Title case only supports English. For other languages, use sentence case. The default value of the `ShortWords` parameter is hard coded into the stylesheet.