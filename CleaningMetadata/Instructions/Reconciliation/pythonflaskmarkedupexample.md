# Marked Up Example (reconcile.py file from Ted Lawless' FAST Reconciliation Service)

### File structure:
	* .gitignore
	* LICENSE
	* README.md <= please include this with documentation, use cases, links to other examples!
	* reconcile.py <= heart of the reconciliation work, shown below with comments
	* requirements.txt <= tells the local environment what is needed for this particular recon service API to work
	* text.py <= used in reconcile.py for data normalization before querying external data source

### reconcile.py:

```python
"""
An OpenRefine reconciliation service for the API provided by
OCLC for FAST.
See API documentation:
http://www.oclc.org/developer/documentation/fast-linked-data-api/request-types
This code is adapted from Michael Stephens:
https://github.com/mikejs/reconcile-demo
"""
```

_Below, we import a bunch of python libraries needed for making this API - namely, flask, a [microframework:](http://flask.pocoo.org/), the json library for working the the json data received and sent, _

```python
from flask import Flask
from flask import request
from flask import jsonify

import json
from operator import itemgetter
import urllib
```

_For scoring results: The fuzzy wuzzy library is used in a number of OpenRefine Recon APIs for matching. It does text matching based off of use of the levenshtein distance metric: https://en.wikipedia.org/wiki/Levenshtein_distance._

```python
from fuzzywuzzy import fuzz
import requests
```

_This recon service uses the Flask 'microframework' to create the HTTP-based REST API. Users will use flask commands to get this API running locally, so that it can both take the HTTP requests from OpenRefine, as well as send and receive HTTP requests with the external dataset._

```python
app = Flask(__name__)
```

_some config: This is where the external data API-specific information is put in. Below, this url is made into a variable for constructing the API queries._

```python
api_base_url = 'http://fast.oclc.org/searchfast/fastsuggest'
```

_For constructing links to FAST. The following URL is a python structure for then creating URIs for the external data API values returned. This is based off of the structure of that particular dataset - here, FAST URIs. Note that the {0} portion is a way for python to know to put in the retrieved identifers in that part of the URI._

```python
fast_uri_base = 'http://id.worldcat.org/fast/{0}'
```

_If it's installed, use the requests_cache library to cache calls to the FAST API. Caching helps improve performance in sending and receiving data from the external API._

```python
try:
    import requests_cache
    requests_cache.install_cache('fast_cache')
except ImportError:
    app.logger.debug("No request cache found.")
    pass
```

_Helper text processing - this imports the external text.py document in this set of code for use in data normalization on the OpenRefine values before the API call. The normalized values are then sent to the external data service. Review the text.py file to get an idea of what data normalization occurs._

```python
import text
```

_Map the FAST query indexes to service entity types. This is where the OpenRefine Reconciliation Service structure comes into play. In order to allow different the OpenRefine user to call different FAST API indices for different reconciliation calls, an OpenRefine entity type is assigned to each here, with the required metadata (id, name, index). One only needs to include the default_query for this to work with OpenRefine, however. Note that the ids below are related to how OpenRefine holds the entity types, and the indices are based on how the search indices available with the FAST API._

```python
default_query = {
    "id": "/fast/all",
    "name": "All FAST terms",
    "index": "suggestall"
}

refine_to_fast = [
    {
        "id": "/fast/geographic",
        "name": "Geographic Name",
        "index": "suggest51"
    },
    {
        "id": "/fast/corporate-name",
        "name": "Corporate Name",
        "index": "suggest10"
    },
    {
        "id": "/fast/personal-name",
        "name": "Personal Name",
        "index": "suggest00"
    },
    {
        "id": "/fast/event",
        "name": "Event",
        "index": "suggest11"
    },
    {
        "id": "/fast/title",
        "name": "Uniform Title",
        "index": "suggest30"
    },
    {
        "id": "/fast/topical",
        "name": "Topical",
        "index": "suggest50"
    },
    {
        "id": "/fast/form",
        "name": "Form",
        "index": "suggest55"
    }
]
refine_to_fast.append(default_query)
```

_Make a copy of the FAST mappings._

```python
query_types = [{'id': item['id'], 'name': item['name']} for item in refine_to_fast]
```

_Basic service metadata. There are a number of other documented options but this is all we need for a simple service. This is required for OpenRefine to recognize this standard Reconciliation service. The view is where one could put additional search within OpenRefine options, as well as constructs the URL (here, also the FAST URI) for the results._

```python
metadata = {
    "name": "Fast Reconciliation Service",
    "defaultTypes": query_types,
    "view": {
        "url": "{{id}}"
    }
}
```

_Function for making the FAST URI, which is also a URL. URL is used in the OpenRefine interface_

```python
def make_uri(fast_id):
    """
    Prepare a FAST url from the ID returned by the API.
    """
    fid = fast_id.lstrip('fst').lstrip('0')
    fast_uri = fast_uri_base.format(fid)
    return fast_uri
```

_This helps the OpenRefine Service API work with JSON - both sending the JSONP service metadata back to OpenRefine when registering, as well working with JSON data from OpenRefine for querying and returned from external API post-matching for ranking._

```python
def jsonpify(obj):
    """
    Helper to support JSONP
    """
    try:
        callback = request.args['callback']
        response = app.make_response("%s(%s)" % (callback, json.dumps(obj)))
        response.mimetype = "text/javascript"
        return response
    except KeyError:
        return jsonify(obj)
```

_The function where we tell our OpenRefine service how to create and handle the external data API calls._

```python
def search(raw_query, query_type='/fast/all'):
    """
    Hit the FAST API for names. Create out for what we'll return to OpenRefine. unique_fast_ids  is to help store results for faster matching. Assign the default query type if no given type exists. Then pull the query_index from that type.
    """
    out = []
    unique_fast_ids = []
    query = text.normalize(raw_query).replace('the university of', 'university of').strip()
    query_type_meta = [i for i in refine_to_fast if i['id'] == query_type]
    if query_type_meta == []:
        query_type_meta = default_query
    query_index = query_type_meta[0]['index']
```

_Now building the FAST API query URL. Logger the URL in the CLI where this is running. If there is an exception, that is logged._


```python
    try:
        #### FAST api requires spaces to be encoded as %20 rather than +
        url = api_base_url + '?query=' + urllib.quote(query)
        url += '&rows=30&queryReturn=suggestall%2Cidroot%2Cauth%2cscore&suggest=autoSubject'
        url += '&queryIndex=' + query_index + '&wt=json'
        app.logger.debug("FAST API url is " + url)
        resp = requests.get(url)
        results = resp.json()
    except Exception, e:
        app.logger.warning(e)
        return out
```

_Now, will run through the FAST API results to see if we can change match from False to True. To do so, get the name as well as the alternate name from the FAST matches. Get the ID for the FAST match and build a FAST URL/URI from it. Get rid of duplicate FAST matches._

```python
    for position, item in enumerate(results['response']['docs']):
        match = False
        name = item.get('auth')
        alternate = item.get('suggestall')
        if (len(alternate) > 0):
            alt = alternate[0]
        else:
            alt = ''
        fid = item.get('idroot')
        fast_uri = make_uri(fid)
        #The FAST service returns many duplicates.  Avoid returning many of the
        #same result
        if fid in unique_fast_ids:
            continue
        else:
            unique_fast_ids.append(fid)
```

_With the information we want from the FAST API responses, we'll now use the fuzzy wuzzy library to make match scores for each FAST match's name and alternate name. The scores are returned for ranking. If the OpenRefine query exactly matches the FAST match, we'll consider it a match as well._

```python
        score_1 = fuzz.token_sort_ratio(query, name)
        score_2 = fuzz.token_sort_ratio(query, alt)
        #Return a maximum score
        score = max(score_1, score_2)
        if query == text.normalize(name):
            match = True
        elif query == text.normalize(alt):
            match = True
```

_This creates the reconciliation objects we will return to OpenRefine, with sorting and only the top three matches are returned._

```python
        resource = {
            "id": fast_uri,
            "name": name,
            "score": score,
            "match": match,
            "type": query_type_meta
        }
        out.append(resource)
    #Sort this list by score
    sorted_out = sorted(out, key=itemgetter('score'), reverse=True)
    #Refine only will handle top three matches.
    return sorted_out[:3]
```

_How to handle the HTTP POST/GET requests here._

```python
@app.route("/reconcile", methods=['POST', 'GET'])
def reconcile():
    #Single queries have been deprecated.  This can be removed.
    #Look first for form-param requests.
    query = request.form.get('query')
```

_HTTP POST Query is constructed, with the default FAST index used is a JSON object is not sent from OpenRefine to this API. If a series of queries (usually ten at a time) are sent from OpenRefine, then instead of just proceeding with a default FAST index, it asks the uses to select an index. For the results, they are stored in JSON object with a results array._

```python
    if query is None:
        #Then normal get param.s
        query = request.args.get('query')
        query_type = request.args.get('type', '/fast/all')
    if query:
        # If the 'query' param starts with a "{" then it is a JSON object
        # with the search string as the 'query' member. Otherwise,
        # the 'query' param is the search string itself.
        if query.startswith("{"):
            query = json.loads(query)['query']
        results = search(query, query_type=query_type)
        return jsonpify({"result": results})
    # If a 'queries' parameter is supplied then it is a dictionary
    # of (key, query) pairs representing a batch of queries. We
    # should return a dictionary of (key, results) pairs.
    queries = request.form.get('queries')
    if queries:
        queries = json.loads(queries)
        results = {}
        for (key, query) in queries.items():
            qtype = query.get('type')
            #If no type is specified this is likely to be the initial query
            #so lets return the service metadata so users can choose what
            #FAST index to use.
            if qtype is None:
                return jsonpify(metadata)
            data = search(query['query'], query_type=qtype)
            results[key] = {"result": data}
        return jsonpify(results)
    # If neither a 'query' nor 'queries' parameter is supplied then
    # we should return the service metadata.
    return jsonpify(metadata)
```

_Flask specific needs to define how this flask app/the API works. Adds the debug options someone can run to see how the HTTP requests between this API and the FAST API work._

```python
if __name__ == '__main__':
    from optparse import OptionParser
    oparser = OptionParser()
    oparser.add_option('-d', '--debug', action='store_true', default=False)
    opts, args = oparser.parse_args()
    app.debug = opts.debug
    app.run(host='0.0.0.0')
```
