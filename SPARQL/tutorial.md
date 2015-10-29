SPARQL Tutorial
===============

#### Alternate Title: `Who will comfort Toffle? : a tale of Moomin Valley`
#### Alternate Alternate Title: `The exploits of Moominpappa, described by himself`

#### Endpoints: (please be nice to the public servers)
  - http://bit.ly/blazegraph
  - http://bnb.data.bl.uk/flint-sparql
  - http://vocab.getty.edu/sparql
  - http://dbpedia.org/snorql/

## Why A Graph Query Language?

[SPARQL 1.1](http://www.w3.org/TR/2013/REC-sparql11-query-20130321/): __S__PARQL
__P__rotocol __a__nd __R__DF __Q__uery __L__anguage.

![A Graph](https://en.wikipedia.org/wiki/Graph_database#/media/File:GraphDatabase_PropertyGraph.png)

## Basic Graph Patterns

```sparql
SELECT * WHERE { ?s ?p ?o }
```

This grabs and returns all the triples in the dataset. Whoa! That might give a
lot of solutions! Let's take a step back...

```sparql
SELECT * WHERE { ?s ?p ?o } LIMIT 100
```

We can use `LIMIT` to reduce the size of the result set. Generally, this means
our query doesn't need to load the whole set, and is much less resource
intensive; especially over large potential result sets.

If we want to access additional results, we can introduce sorting and offsets
to create paged results:

```sparql
SELECT * WHERE { ?s ?p ?o } ORDER BY ?s LIMIT 100
```

```sparql
SELECT * WHERE { ?s ?p ?o } ORDER BY ?s LIMIT 100 OFFSET 100
```

### Better Patterns 

But can't we query for something interesting?

```sparql
PREFIX dct: <http://purl.org/dc/terms/>

SELECT * WHERE {
  ?item dct:license <http://creativecommons.org/publicdomain/zero/1.0/> .
}
```

But I want to know the topic! I can use a group pattern to narrow my results:

```sparql
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>

SELECT * WHERE {
  ?item dct:license <http://creativecommons.org/publicdomain/zero/1.0/> .
  ?item foaf:primaryTopic ?topic 
}
```

### A Note About Prefixes

For the remainder of the queries in this tutorial, we'll assume the following
prefixes:

```sparql
# Common Bibliographic Vocabularies
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX bibo: <http://purl.org/ontology/bibo/>
PREFIX dct: <http://purl.org/dc/terms/>

# W3C
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix owl: <http://www.w3.org/2002/07/owl#>
```

## Variables & Binding

SPARQL builds solutions for patterns by binding resources in the graph to the
variables you declare. You don't need to return all your variables; supposing
I want the topics of CC0 items, but don't care about the items themselves.

```sparql
SELECT ?topic WHERE {
  ?item dct:license <http://creativecommons.org/publicdomain/zero/1.0/> .
  ?item foaf:primaryTopic ?topic 
}
```

Variables may be unbound in a result, as long as the pattern is satisfied. As a
really basic example:

```sparql
SELECT ?s ?p ?o ?x WHERE { ?s ?p ?o }
```

This will be more interesting later, I promise.

We can also bind variables manually:

```sparql
SELECT ?s ?p ?o ?x WHERE {
  ?s ?p ?o .
  BIND("moomin" AS ?x)
}
```

### Blank Nodes

Blank Nodes represent a special case of an unnamed, _existentially quantified_
resource. A statement using a Blank Node is equivalent to asserting "there
exists some resource such that...". Generally, Blank Nodes should not be used to
create nested structures as would be common in XML metadata.

![Nameless Nodes, credit Vuk Miličić](http://milicicvuk.com/blog/wp-content/uploads/2011/07/bnode.png)

We say "Blank Nodes are unnamed", though in serialization syntaxes, they
commonly have identifers. These identifiers are always local to a document;
they allow one Blank Node to be referenced in more than one statement.

```ntriples
<http://example.org/moomin> dct:creator _:tove .
_:tove rdf:type foaf:Person .
```

These are not considered as names for the node, which may be identified by
a different label each time the graph we retrieve a graph. In some
serializations, the node may have no label at all:

```turtle
<http://example.org/moomin> dct:creator [
  a foaf:Person .
] .
```

Some resources on blank nodes:

 - [RDF 1.1 Concepts & Abstract Syntax](http://www.w3.org/TR/rdf11-concepts/#section-blank-nodes)
 - [Everything You Always Wanted to Know About Blank Nodes](http://www.websemanticsjournal.org/index.php/ps/article/download/365/387)
 - [Problems of the RDF model: Blank Nodes](http://milicicvuk.com/blog/2011/07/14/problems-of-the-rdf-model-blank-nodes/) (pre-RDF 1.1)

## Query Forms

### SELECT

> The SELECT form of results returns variables and their bindings directly. It
> combines the operations of projecting the required variables with introducing
> new variable bindings into a query solution.

OK?!

### CONSTRUCT

`CONSTRUCT` queries can be used to create a new graph structured from the query
results. As simple example:

```sparql
CONSTRUCT {
  ?item dct:title ?title
} WHERE {
  ?item dct:title ?title
}
```

This common pattern results in a graph containing all of the `dct:title`
statements in the dataset. This pattern is handy enough that it has a
special shorter syntax in SPARQL 1.1:

```sparql
CONSTRUCT WHERE { ?item dct:title ?title }
```

Expand on this by querying for other properties of the item:

```sparql
CONSTRUCT WHERE {
  ?item dct:title ?title
  ?item dct:creator ?creator
}
```

`CONSTRUCT` can also be used for more complex graph transformations:

I'd really like to pretend all of Tove Jansson's work are this:

![Comet in Moominland](http://t0.gstatic.com/images?q=tbn:ANd9GcTdeIvBI5iJNgsnSzZfeoyoiSTSUq7EEgzoRwehISDsa82jLunU)

```sparql
CONSTRUCT {
  ?item dct:title "Comet in Moominland" .
  ?item dct:modified ?now
} WHERE {
  ?item dct:creator ?person .
  ?person rdf:type foaf:Person .
  ?person owl:sameAs <http://viaf.org/viaf/111533709> .
  BIND(now() AS ?now) 
}
```

### ASK

> Applications can use the ASK form to test whether or not a query pattern
> has a solution. No information is returned about the possible query
> solutions, just whether or not a solution exists.

For a non-empty dataset, this is always `true`:

```sparql
ASK { ?s ?p ?o }
```
Do we have any books by Tove Jansson?

```sparql
ASK {
  ?item rdf:type bibo:Book .
  ?item dct:creator <http://bnb.data.bl.uk/id/person/JanssonTove>
}
```

### DESCRIBE

> The DESCRIBE form returns a single result RDF graph containing RDF data about
> resources... The description is determined by the query service.

Typically, `DESCRIBE` returns all statements with the selected resource(s) in
the subject place.

```sparql
DESCRIBE <http://bnb.data.bl.uk/id/person/JanssonTove>
```

You can select multiple resources with `WHERE`.

```sparql
DESCRIBE ?book WHERE {
  ?item rdf:type bibo:Book .
  ?item dct:creator <http://bnb.data.bl.uk/id/person/JanssonTove>
}
```

## Filters & Datatypes

So far we haven't queried for any literal values. How can we discover resources
with SPARQL when we don't already know URIs?

```sparql
SELECT ?item WHERE {
   ?item dct:creator ?tove .
   ?tove foaf:name ?name .
   FILTER(?name = "Tove Jansson")
}
```

And we have functions! We saw a function before with `now()`, here, `regex()`
comes in handy:

```sparql
SELECT ?item ?tove WHERE {
   ?item dct:creator ?tove .
   ?tove foaf:name ?name .
   FILTER regex(?name, "^Tove")
}
```

There is a long list of default function definitions in the [SPARQL 1.1
specification](http://www.w3.org/TR/2013/REC-sparql11-query-20130321/#SparqlOps).
Other functions may be available as extensions for a specific server. For
example: [GeoSPARQL](http://www.opengeospatial.org/standards/geosparql) provides
a suite of these for handling spatial data.

## Optional Patterns & Union

What if we know a bit less about the contents of the data, or some results may
be less rich? Let's try optional patterns.

```sparql
SELECT ?creator ?name WHERE {
   ?item dct:creator ?creator .
   OPTIONAL { ?creator foaf:name ?name } .
}
```

Lots of repeated results there, let's squash them down:

```sparql
SELECT DISTINCT ?creator ?name WHERE {
   ?item dct:creator ?creator .
   OPTIONAL { ?creator foaf:name ?name } .
}
```

You can use alternative patterns with `UNION`:

```sparql
SELECT DISTINCT ?creator ?name WHERE {
   ?item dct:creator ?creator .
   { ?creator foaf:name ?name } UNION { ?creator rdfs:label ?name }
}
```

## SPARQL Datasets & RDF Named Graphs

![Graphs](http://www.w3.org/TR/rdf11-mt/RDF11SemanticsDiagrams/example5.jpg)

A SPARQL endpoint provides access to a _SPARQL Dataset_, and a _Dataset_ may
contain multiple graphs.

We have been querying the "default graph". Often, this graph is the union of
other graphs in the Dataset, but not always. We can query other graphs
specifically by _graph name_.

In the sample dataset, we have graph names:

```sparql
SELECT ?g WHERE { GRAPH ?g {} }
```

 - bd:nullGraph (Blazegraph's Default Graph)
 - <http://lodlam.net/ns/slick_rick>
 - <http://lodlam.net/ns/b.i.g.>

We can query named graphs with syntax like:

```sparql
SELECT * WHERE { GRAPH <http://lodlam.net/ns/slick_rick> { ?s ?p ?o }}
```

## Other RDF Topics & Protocols

### [SPARQL Update](http://www.w3.org/TR/2013/REC-sparql11-update-20130321/)

### [SPARQL Graph Store Protocol](http://www.w3.org/TR/2013/REC-sparql11-http-rdf-update-20130321/)

### [Property Path Syntax](http://www.w3.org/TR/2013/REC-sparql11-query-20130321/#pp-language)

### [Linked Data Platform](http://www.w3.org/TR/ldp/)

 - [LDP Primer](http://www.w3.org/TR/ldp-primer/)


