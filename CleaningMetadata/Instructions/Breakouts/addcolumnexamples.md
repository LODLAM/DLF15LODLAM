# Add a column by fetching URLs Reconciliation Examples

To see an active use case and very high level instructions (users will need to fill in the rest) for reconciliation in this manner, check out the Mountain West Digital Library OpenRefine transformation using the GeoNames Web Services API Report - https://sites.google.com/site/mwdlgeospatial/home/openrefine

Below are two legacy documentation examples of using the OpenRefine 'Add a new column by fetching URL' functionality with the VIAF API. They are included just as examples of how to use that.

It is recommended for folks to review other methods of using reconciliation available, where possible, either through the DERI RDF extension or the OpenRefine Standard Reconciliation Service API.

## LCNAF - Architects' Names

### Issue/Goal:

To find a way to automatically reconcile names against the Library of Congress Name Authority File (LCNAF).

### Background:

In remediating a certain dataset, we tried to include the architect in a specific field for all records where an architect's name was present. These names, however, were not standardized, nor were they always the names of architects (they could be painters that work in the building, writers that wrote the article about the building, etc.).

So we began to explore possibilities for automating name reconciliation - sort out which ones match the LCNAF immediately, then work with the remainders to see what the issues might be.

### Issues/Improvements:

There were two particular issues with this work.

Although the LCNAF is available as Linked Open Data from the Library of Congress, the NAF as a RDF document (regardless of serialization) is too big for our work or personal computers to manage. This means that, at this point at least, we have to rely on a third party access point to using the LCNAF Data. There are no SPARQL endpoints available for the LCNAF like we have with the LCSH, though. So, we turned to using VIAF and Search/Retrieval via URL as the intermediary.

The LCNAF is not the ideal authority file for trying to single out just architects. So, in the context of this dataset, this automatic reconciliation against the LCNAF occurred after reconciling against Getty's United List of Artists' Names (ULAN). There remains serious personal name reconciliation hesitations - in particular, the plethora of false matches - to consider. Building out this workflow to use the following guidelines could/will help and is being reviewed:

	- If our name data contains life dates that match the life dates in LCNAF record, consider a good match.
	- If our name data contains occupation information that matches occupation information in the LCNAF record, consider a good match.
	- If there is matched birthplace information, considering a match to be reviewed.
	- Otherwise, perhaps pulling in a copy of the matched record for easier browsing and possible match acceptance/denial is worth considering.

### Recipe:
	
For this recipe, you need OpenRefine and an internet connection.


To access the LCNAF, we are going to work through VIAF. 

	1. Find your column in your data that has the list of names that you wish to reconcile.
	2. Go to that column's downward arrow and choose 'Edit column' > 'Add column by fetching URLs'
	3. In the Box that appears, give the new column a name and then enter the following GREL that recreates the VIAF AutoSearch URL with URL-formated cell values attached:
		```"http://viaf.org/viaf/AutoSuggest?query="+ escape(cell.value, 'url')```
	4. Click 'add column' then wait. Wait some more. 
	5. Now you have a column of JSON. Let's deal with the queries that did not return anything first by removing the JSON values that contain 'null'. On the JSON column, go to 'Edit Cells' > 'Transform' and enter the GREL:
		```if(value.contains('null'), value.replace(cell.value, ""), cell.value)```
	6. Now, let's retrieve the terms that are used by the Library of Congress. On the JSON column, choose 'Cell' > 'Transform' and enter the GREL:
		```forEach(value.parseJson().result, v, v.term + ' | ' + v.lc)[0]```
	7. Depending on how many different results the AutoSuggest search returns, you may need to repeat the above step for different array indices, i.e. 
		```forEach(value.parseJson().result, v, v.term + ' | ' + v.lc)[1], forEach(value.parseJson().result, v, v.term + ' | ' + v.lc)[2], etc.```
		This can be automated using your own OpenRefine JSON Code.
	8. Now you can separate the LC names from the LCCN by Going to the JSON column and choosing 'Edit column' > 'Split into several columns' and using ' | ' (the separator value from step 5) as the separator. You now have a column of VIAF/LC reconciled names and the LCCN number they are reconciled against.
	9. The looping function needed to pull out all valid results from the VIAF JSON is not available in GREL - yet. The ForEach loop does part of the work, but for the best results, we have found that going step-by-step through a test set, then saving the JSON codes for those actions, works well. 


## LCNAF - Architects' Names

### Issue/Goal:

To find a way to automatically reconcile names (particularly architects' names) data subsets against Getty's United List of Artists' Names (ULAN).

### Background:

In remediating a particular dataset, we tried to include the architect in a specific field for all records where an architect's name was present. These names, however, were not standardized, nor were they always the names of architects (they could be painters that work in the building, writers that wrote the article about the building, etc.).

So we began to explore possibilities for automating name reconciliation - sort out which ones match ULAN immediately, then work with the remainders to see what the issues might be.

### Issues/Improvements:

A particular issue that comes up when working with the Getty ULAN is that Getty's data is not available as Linked Open Data (at the time these instructions were written). To get around this, we decided to access Getty through VIAF, which includes ULAN among other authority sources. This causes for us another, as-yet-unresolved issue: The names are reconciled against the VIAF entry, but marked as being in ULAN. Work is currently ongoing to fix this. 

### Recipe:
	
For this recipe, you need OpenRefine and an internet connection.


1. Find your column in your data that has the list of names that you wish to reconcile. 
2. Go to that column's downward arrow and choose 'Edit column' > 'Add column by fetching URLs'
3. In the Box that appears, give the new column a name and then enter the following GREL that recreates the VIAF AutoSearch URL with URL-formated cell values attached:
	```"http://viaf.org/viaf/AutoSuggest?query="+ escape(cell.value, 'url')```
4. Now you have a column of JSON. Let's deal with the queries that did not return anything first by removing the JSON values that contain 'null'. On the JSON column, go to 'Edit Cells' > 'Transform' and enter the GREL:
	```if(value.contains('null'), value.replace(cell.value, ""), cell.value)```
5. Now, let's retrieve the terms that are used by ULAN. On the JSON column, choose 'Cell' > 'Transform' and enter the GREL:
	```forEach(value.parseJson().result, v, v.term + ' | ' + v.jpg)[0]```
6. Depending on how many different results the AutoSuggest search returns, you may need to repeat the above step for different array indices 
	```forEach(value.parseJson().result, v, v.term + ' | ' + v.jpg)[1], forEach(value.parseJson().result, v, v.term + ' | ' + v.jpg)[2], etc.```
7. Now you can separate the VIAF/ULAN names from the ULAN Record ID by going to the JSON column and choosing 'Edit column' > 'Split into several columns' and using ' | ' (the separator value from step 5) as the separator. You now have a column of VIAF/ULAN reconciled names and the ULAN Record ID number they are reconciled against.
 
