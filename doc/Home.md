PACBook enables you to:

## Transclusion stylesheets

1. Perform parametrised transclusion … [TransParam.xsl](TransParam.xsl)

2. Fix up duplicate IDs … [TransID.xsl](TransID.xsl)

3. Fix up links to duplicate IDs or links to non-existent targets … [TransLinks.xsl](TransLinks.xsl)

## Linguistic stylesheets

1. Select the correct form of transcluded terms, depending on their syntactic environment … [LingHead.xsl](LingHead.xsl)

2. Inflect text which depends syntactically on any transcluded terms … [LingDepend.xsl](LingDepend.xsl)

3. Select the correct orthographic case for text, depending on environment … [LingCasing.xsl](LingCasing.xsl)

## Text stylesheets

1. Punctuate abbreviations correctly so they don’t have two full stops at the end of a
sentence … [TextAbbrev.xsl](TextAbbrev.xsl)

2. Localised number formatting … [TextNumbers.xsl](TextNumbers.xsl)

## DocBook stylesheets

1. Resolve image references against xml:base … [DBImages.xsl](DBImages.xsl)

2. Resolve image references against the XML Catalog … [RefResolve.xsl](RefResolve.xsl)

3. Enhanced DocBook conditional profiling … [DBProfile.xsl](DBProfile.xsl)

4. Automatic titles for DocBook admonitions … [DBAdmon.xsl](DBAdmon.xsl)

5. Enhanced formatting of DocBook simple lists — select the correct form of
conjunctions based on the phonetic environment, for languages which demand it … [DBLists.xsl](DBLists.xsl)

6. Create revision history and applicability tables based on the document metadata … [DBProcs.xsl](DBProcs.xsl)

7. Enhanced DocBook glossary processing — include terms in the glossary if they are
referred to by other terms … [DBGloss.xsl](DBGloss.xsl)

8. Create automatic links between DocBook sections, based on shared subject matter … [DBLinks.xsl](DBLinks.xsl)

## Translation stylesheets

1. Translate the document using a single XLIFF file … [XlateConvert.xsl](XlateConvert.xsl)

2. Multilingual translations, using several XLIFF files … [XlateCombine.xsl](XlateCombine.xsl)

3. Fix up IDs in multilingual translations … [XlateID.xsl](XlateID.xsl)

4. Mark up elements in a file for translation … [XlateMarkup.xsl](XlateMarkup.xsl)

5. Extract translation elements to an XLIFF file … [XlateExtract.xsl](XlateExtract.xsl)

6. Compare document to existing XLIFF file and create diff file … [XlateDiff.xsl](XlateDiff.xsl)

7. Merge new translation units into existing XLIFF file … [XlateMerge.xsl](XlateMerge.xsl)

## XLIFF management stylesheets

1. Remove duplicate translation units from XLIFF file … [XliffDupe.xsl](XliffDupe.xsl)

2. Remove completed translation units from XLIFF file … [XliffPurge.xsl](XliffPurge.xsl)

3. Escape inline markup in an XLIFF file … [XliffRaw.xsl](XliffRaw.xsl)

4. Unescape inline markup in an XLIFF file … [XliffTemp.xsl](XliffTemp.xsl), [XliffTag.xsl](XliffTag.xsl)

5. Export an XLIFF file to CSV … [Xliff2CSV.xsl](Xliff2CSV.xsl)

6. Import from Microsoft Excel XML to XLIFF … [XL2Xliff.xsl](XL2Xliff.xsl)

### Note

It’s important to note that PACBook is not a natural language processor. The author or
translator must mark up text for linguistic processing by hand.
