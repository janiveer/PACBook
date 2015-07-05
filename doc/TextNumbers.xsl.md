Makes sure that numbers are punctuated correctly according to the document language.

## Parameters

`[numberClassRef]`

* **numberClassRef** (URI) — a URI that identifies numbers. Default http://dbpedia.org/ontology/number.

## Input

An XML document. Any numbers which need localisation must be marked up with ITS 2.0 text analysis attributes as described below.

## Output

An XML document, identical to the input except that numbers are localised.

## Description

The stylesheet recurses through the document and copies each element. If any element has the attribute `its:taClassRef='http://dbpedia.org/ontology/number'` and contains just a plain XML number, i.e. with no grouping separators and a full stop for the decimal separator, the stylesheet formats the number according to the language defined by the nearest ancestor `xml:lang` attribute.

Usually you would rely on translators to localise the format of numbers in the document. This stylesheet is useful if you want to enforce a consistent number format for each locale, or if any translation strings contain just numbers and you don’t want to bother translating them.

The following languages are currently supported: `en-GB`, `en-US`, `fr`, `de`, `nl`, `es`, `sv`, `nb`, `pt`, `it`, `fi`, `zh` and the special ISO language codes `und`, `mul`, `mis` and `zxx`. The localisation formats are taken from [IBM](http://www-01.ibm.com/support/knowledgecenter/SSS28S_3.0.0/com.ibm.help.forms.doc/locale_spec/i_xfdl_r_locale_quick_reference.html).

To use the `its:taClassRef` attribute you must set `its:version='2.0'` on the element or on the containing document.