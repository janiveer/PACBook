Transforms PAC processing instructions in DocBook documents.

## Parameters

None.

## Input

A DocBook file containing PAC processing instructions as described below.

## Output

A DocBook file in which the PAC processing instructions have been transformed as described below.

## Description

The stylesheet copies the structure and content of the input document to the output document. Any PAC processing instructions within the input document are transformed as follows.

### <?pac-revhistory?>

You can use this processing instruction to place a revision history table at a precise place in the document. When the stylesheet encounters this processing instruction, it builds a DocBook `<informaltable>` containing four columns: **Version**, **Date**, **Author** and **Detail**. The table uses the CALS table model.

The table header is populated in the language specified by the nearest ancestor `xml:lang` attribute. The labels are taken from `DataLabels.xml`. The only fully-supported languages at present are German, English, Spanish, French and Dutch.

Each table row is populated by the details given in the `<revhistory>` element in the document’s `<info>` section, if there is one.

The attributes of the `<informaltable>`, e.g. framing, row separators and column separators, are given by the `pac.revhistory.table` attribute set. The attributes of the four columns, e.g. column width, are given by the `pac.revhistory.col.version`, `pac.revhistory.col.date`, `pac.revhistory.col.author` and `pac.revhistory.col.detail` attribute sets.

### <?pac-applicability?>

You can use this processing instruction to place an applicability table at a precise place in the document. When the stylesheet encounters this processing instruction, it builds a DocBook `<informaltable>` containing four columns: **Product**, **Name**, **Detail** and **Version**. The table uses the CALS table model.

The table header is populated in the language specified by the nearest ancestor `xml:lang` attribute. The labels are taken from `DataLabels.xml`. The only fully-supported languages at present are German, English, French and Dutch.

Each table row is populated by the details given in the document’s [applicability metadata](RDF-Applicability), if there are any.

The attributes of the `<informaltable>`, e.g. framing, row separators and column separators, are given by the `pac.applicability.table` attribute set. The attributes of the four columns, e.g. column width, are given by the `pac.applicability.col.product`, `pac.applicability.col.name`, `pac.applicability.col.detail` and `pac.applicability.col.version` attribute sets.

### <?pac-pubsnumber?>

When the stylesheet encounters this processing instruction it creates a copy of the content of the `<biblioid @class='pubsnumber'>` element in the document’s `<info>` section, if there is one.

### <?pac-edition?>

When the stylesheet encounters this processing instruction it creates a copy of the content of the `<edition>` element in the document’s `<info>` section, if there is one.

### <?pac-releaseinfo?>

When the stylesheet encounters this processing instruction it creates a copy of the value of the `status` attribute on the document’s root element, if there is one.

## Roadmap

The `<?pac-releaseinfo?>` processing instruction should actually output the document’s release info...