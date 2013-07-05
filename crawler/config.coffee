config = {}

config.crawler = {}
config.elasticSearch = {}

config.crawler.maxAttemptsOnError = 3
config.crawler.rootUrl = 'http://www.basketball-reference.com'
config.crawler.startUrl = '/players'

config.elasticSearch.host = 'localhost'
config.elasticSearch.port = 9200
config.elasticSearch.indexName = 'nba'
config.elasticSearch.typeName = 'player'

module.exports = config