# first do:
#
# ```sh
# $ bundle install
# # then, to get a console
# $ bundle console
# ```
#
# bundle console should do this for you, but if you opened your own 
# REPL session, do:
# require 'rdf'
# require 'rdf/turtle'
# require 'rdf/rdfa'

# I really did this, but you can load it all into memory as below
# require 'rdf/blazegraph'
#
# repo = RDF::Blazegraph::Repository.new('http://52.32.85.29:9999/bigdata/sparql')
repo = RDF::Repository.new
graph = RDF::Graph.new(data: repo)

graph << [RDF::URI('http://lodlam.new/ns/SPARQL_DLF2015'), 
          RDF::Vocab::DC.creator, 
          RDF::URI('http://github.com/no-reply#self')]
graph << [RDF::URI('http://github.com/no-reply#self'),
          RDF::RDFS.label,
          "Tom Johnson"]

graph.load('http://bnb.data.bl.uk/id/person/JanssonTove')
graph.load('http://bnb.data.bl.uk/id/person/JanssonLars')

graph.query([RDF::URI('http://bnb.data.bl.uk/id/person/JanssonTove'), 
         RDF::URI('http://www.bl.uk/schemas/bibliographic/blterms#hasCreated'), 
         :item]).each_object do |obj|
  graph.load(obj)
end

# sneaking in Slick Rick
# try structured data linter:
# @see: http://linter.structured-data.org/?url=https:%2F%2Fmusicbrainz.org%2Fartist%2F486af4f0-a79b-468f-be73-527cd4caf6ea
graph.load('https://musicbrainz.org/artist/486af4f0-a79b-468f-be73-527cd4caf6ea')
rick = RDF::Graph.new('http://lodlam.net/ns/slick_rick', data: repo)
rick.load('https://musicbrainz.org/artist/486af4f0-a79b-468f-be73-527cd4caf6ea')
big = RDF::Graph.new('http://lodlam.net/ns/b.i.g.', data: repo)
big.load('https://musicbrainz.org/artist/d5d97b2b-b83b-4976-814a-056d9076c8c3')

dc = RDF::Graph.new(RDF::DC, data: repo)
dc.load(RDF::DC)

geonames = RDF::Graph.new('http://lodlam.net/ns/geonames', data: repo)
geonames.load('http://sws.geonames.org/6173331/about.rdf')
geonames.load('http://sws.geonames.org/660013/about.rdf')
