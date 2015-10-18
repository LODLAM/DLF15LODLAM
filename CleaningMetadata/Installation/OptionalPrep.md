# LODLAM Workshop: Metadata Cleaning Portion Installation Instructions
## Optional Installations

The following is optional for the workshop. If you want to work with reconciliation services in OpenRefine, I strongly recommend you get the Python local reconciliation service requirements installed (section 2) and run the test. 

### 1. RDF Editors
What we create in the process of this workshop will be a RDF document that you might want to see how it looks outside of LODRefine. 

If you just want a nice editor for reviewing & basic edits of RDF:

- Any text editor can do this - even just TextEdit.
- Most editors like Notepad++ or Sublime have decent interfaces and either native support or good packages for different RDF serialization highlighting
- We might play with web-based tools like [RDF Distiller](http://rdf.greggkellogg.net/distiller) if time for things like RDF serialization conversion
- If you really want to get into RDF ontology editing, there is [Protégé](http://protegewiki.stanford.edu/wiki/Main_Page) - available in an either [web-based version](http://webprotege.stanford.edu/) or for [download](http://protege.stanford.edu/products.php#desktop-protege) - and [Vitro](http://vitro.mannlib.cornell.edu/) (only available for download and installation).

### 2. Python Local Reconciliation Service Requirements
If you are interested in running many/more of the reconciliation service functions we'll see (whether they leverage Linked Open Data or not), install the following.

This can be move involved installation-wise, so please don't hesitate to ask [Christina](mailto:cmharlow@gmail.com) if you have questions. We can also take a lunch or coffee break at DLF if necessary to debug this.

#### Installation
**Python**
Install or ensure that you have at least python 2.7 installed on your computer. 

You can check if your computer has python installed by going to your command line interface or client (standard on a Mac is Terminal, on Windows, the Command Prompt; if you have Linux, I'm assuming you know how to make Linux work), then type in 'python --version'. If it gives you a response such as 'Python 2.7.10', you're good to move on. If it doesn't, the Python beginner's documentation is your friend: https://wiki.python.org/moin/BeginnersGuide/Download

**Pip**
Different LODRefine reconciliation services built in Python require different Python libraries to run (although there are a number of libraries that are pretty standard across services). Because you this, you probably want a Python package manager like Pip to easily handle installing requirements. This should come automatically with Python 2.7.9 and later.

You can check if your computer has pip installed by going to your command line interface or client, then type in 'pip --version'. If it gives you a response such as 'pip 7.1.2 from /usr/local/lib/python2.7/site-packages (python 2.7)', you're good to move on. 

If it doesn't, the Pip insatllation documentation is your friend: https://pip.pypa.io/en/latest/installing/

#### Test
Try either git cloning or downloading this OpenRefine reconciliation service and running through the instructions: https://github.com/cmh2166/geonames-reconcile

### 3. Linked Data Fragments Server/Client Installation
[Linked Data Fragments](http://linkeddatafragments.org/) will not be a part of the metadata cleaning workshop, but it will be mentioned in passing and discussed possibly in the clinic portion. Mainly, its a new-fangled, wicked awesome project that I want to mention.

In particular, in the context of metadata cleanup, Linked Data Fragments offers one way to approach better performance of reconciliation with and querying of RDF datasets - whether they be the traditional library authorities like Getty AAT or Library of Congress, or your own local authorities.

#### Installation
If you'd like to try running your own Linked Data Fragments Server (supplying your own or other RDF data), you will need to [install [**Node.js** (preferably v0.10.x) and **NPM**, the Node package manager](https://docs.npmjs.com/getting-started/installing-node). See the instructions linked to.

If you really don't want to use Node, there are [LDF Server applications written in other languages available (Java, NetKernel)](http://linkeddatafragments.org/software/#server), but they will not offer all the functionalities available in the Node.js version, nor will I really be able to help debug issues with the other versions as I've just worked with the Node.js version.

Once Node and NPM is installed, to install a LDF Server on your computer, follow the instructions here: https://github.com/LinkedDataFragments/Server.js. Don't worry about configuring the data sources - you can use the default they provide. If you have issues installing the HDT requirement, skip it. It has some known bugs/confusion.

The above will install a LDF Server locally. If you'd like to then push that LDF Server to the web using Heroku ([here is an example](http://aqueous-eyrie-5164.herokuapp.com/)), follow **just the first 2 steps - Introduction and Setup** [on this page.](https://devcenter.heroku.com/articles/getting-started-with-nodejs#introduction)

We can then make this a possible clinic session.

Questions? Get in touch with [Christina](mailto:cmharlow@gmail.com).

[Back to the Metadata Cleaning Agenda](../)

[Back to the LODLAM Workshop Agenda](https://github.com/cmh2166/DLF15LODLAM/)
