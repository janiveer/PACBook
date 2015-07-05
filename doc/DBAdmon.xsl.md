Creates automatic titles for admonitions in a DocBook document.

## Parameters

None.

## Input

A DocBook document. Any admonitions (`important`, `caution`, `note`, `tip` or `warning`) for which you want an automatic title must have an empty `<title>` element.

## Output

A DocBook document, identical to the input except that admonitions have titles in the appropriate language.

## Description

The stylesheet recurses through the document and copies each element. When it finds the title element of an admonition, if the title element is empty, the stylesheet gets the language specified by the nearest ancestor `xml:lang` attribute and looks up the correct wording for the title in the `DataLabels.xml` file.

The relevant title strings in the `DataLabels.xml` file are called `important`, `caution`, `note`, `tip` and `warning`.

If the admonition is a `<note>` or a `<tip>` and it contains more than one `<para>` element, the stylesheet uses the `notes` and `tips` strings respectively. 

The following languages are currently supported: `de`, `en`, `fr`, `nl`, `es`, `sv`, `nb`, `pt`, `it`, `fi` and `zh`.