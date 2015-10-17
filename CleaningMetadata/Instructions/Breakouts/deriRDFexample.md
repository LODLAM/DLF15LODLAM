# DERI RDF Extension Example

_Below are is a legacy documentation of using the OpenRefine DERI RDF extenstion RDF Document Reconciliation functionality with the Library of Congress Thesaurus for Graphic Materials._

_This requires the DERI RDF Extension be installed in OpenRefine to work: http://refine.deri.ie/_

___

You may have noticed that many library authorities are now available as Linked Open Data, usually available for download as RDF files in a variety of serializations and using different schemas. We are going to experiment with the Linked Open Data authority files available for download from the Library of Congress at [http://id.loc.gov/download/](http://id.loc.gov/download/).

To update this metadata, we need to first set up the RDF reconciliation option in OpenRefine/LODRefine. A different RDF reconciliation option needs to be set up for each, different RDF set that you wish to reconcile against. We are going to create a RDF reconciliation option with the RDF file of the Thesaurus of Graphic Material (available for download at [http://id.loc.gov/download/](http://id.loc.gov/download/)). Here are the steps:

*   Download from [http://id.loc.gov/download/](http://id.loc.gov/download/) the Thesaurus for Graphic Materials (TGM) in the N-Triples (nt) serialization.

*   It will be a compressed file - find the downloaded file on your computer and expand the archive.

*   Just to see what we are working with, open up the file in your preferred text editor (anything other than Microsoft Office - use Notepad or TextEdit if nothing else).

*   Observe how MADS is used - triples indicating the preferred label use the predicate &lt;[http://www.loc.gov/mads/rdf/v1#authoritativeLabel](http://www.loc.gov/mads/rdf/v1#authoritativeLabel)&gt;. Make a note of this, as it will be important for our reconciliation set-up.

*   Let us now set up the RDF file reconciliation option in OpenRefine/LODRefine:

    *   Click on RDF (a button in the top right corner), then choose ‘Add reconciliation service...’ and ‘Based on RDF file...’

    *   In the dialog box that appears, give this reconciliation option a name (I chose 'LCTGM').

    *   Next, choose to ‘Upload file’, then find your expanded authority file on your computer.

    *   For the file format, choose ‘N-Triple’.

    *   Now, for label properties, unclick ‘rdfs:label’ and click ‘other’. In the dialog box that appears, add[http://www.loc.gov/mads/rdf/v1#authoritativeLabel](http://www.loc.gov/mads/rdf/v1#authoritativeLabel) - the predicate we noted when looking at the downloaded RDF file earlier.

    *   Click OK.

*   It will take a second for OpenRefine/LODRefine to load the new RDF reconciliation option - which is why we choose a small file to experiment with - but once it is finished, find the column of data values in your project that you would like to reconcile with the Thesaurus of Graphic Materials. For my sample metadata set, it is the column with the name 'item - MODS - Form/Genre' (the odd naming conventions for these columns came from the process of a data dump from an Omeka project and the following flattening into a spreadsheet form). Next, for that column, we:

    *   Click on the arrow/triangle at the top of that column.

    *   Choose ‘Reconcile’ &gt; ‘Start reconciling’.

    *   Choose the RDF reconciliation option that we just created.

    *   Choose to reconcile with the type ‘MADS Topic’.

    *   Click on ‘start reconciling’.

*   Again, it will take a second for OpenRefine/LODRefine to process this request depending on the metadata set size (which is why we have a micro-sample for this experiment). Once the reconciliation is complete, you can click on the reconciled values to see the Thesaurus of Graphic Materials term that our metadata was reconciled with, or search for other terms if we disagree with the reconciliation.

*   Finally, let’s pull in the related Thesaurus of Graphic Materials URIs for the values we decided to keep in our reconciled metadata. To do so:

    *   Click on the arrow/triangle at the top of the column we reconciled.

    *   Choose ‘Edit column &gt; Add column based on this column’.

    *   Give the new column a name.

    *   Enter into the Expression text box ‘cell.recon.match.id’. Click enter.

    *   You now have a new column with the URIs of the authorized values.