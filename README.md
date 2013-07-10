nba
===
nba consists of two projects crawler and search-app, both of which use CoffeeScript on Node.JS with ElasticSearch.

crawler is a spider that crawls http://www.basketball-reference.com and indexes player details.

search-app is a web interface to search the indexed player details.


## crawler

Use config.coffee to configure crawler.

ElasticSearch server must be started before crawler is run.

To run crawler:

`cd crawler`

`npm install`

`coffee crawler.coffee`


crawler logs in crawler/log

## search

Use config.coffee to configure search.

ElasticSearch server must be started before search is run.

To run search:

`cd search`

`npm install`

`coffee app.coffee`

In your web browser goto 'localhost:3000'

