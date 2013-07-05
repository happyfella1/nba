nba
===
nba consists of two projects crawler and search-app, both of which use CoffeeScript on Node.JS with ElasticSearch.

crawler is a spider that crawls http://www.basketball-reference.com and indexes player details.

search-app is a web interface to search the indexed player details.


## crawler

Use config.coffee to configure crawler.

ElasticSearch server must be started before crawler is run.


`cd crawler`

`npm install`

`coffee crawler.coffee`


crawler logs in crawler/log
