ElasticSearchClient = require('elasticsearchclient')
config = require('./config')

class Indexer
    serverOptions = {
        host: config.elasticSearch.host
        port: config.elasticSearch.port
        secure: false
    }
    elasticSearchClient: null
    logger: null

    constructor: (@logger) ->
        @elasticSearchClient = new ElasticSearchClient(serverOptions)
        @elasticSearchClient.deleteIndex(config.elasticSearch.indexName)
            .on('data',
                (err) =>
                    @createIndex()
            )
            .on('error',
                (done) =>
                    @createIndex()
            )
            .exec()

    createIndex: () =>
        @elasticSearchClient.createIndex(config.elasticSearch.indexName)
            .on('data', 
                (data) =>
                    mapping = {
                        "player": {
                            "properties": {
                                "name": { "type": "string" }
                                "position": { "type": "string" }
                                "college": { "type": "string" }
                                "draftYear": { "type": "string" }
                                "debutYear": { "type": "string" }
                                "url": {"type": "string", "index": "no"}
                            }
                        }
                    }
                    @elasticSearchClient.putMapping(config.elasticSearch.indexName, config.elasticSearch.typeName, mapping)
                        .on('data', 
                            (data) =>
                        )
                        .on('error', 
                            (err) =>
                                @logger.error(err)
                        )
                        .exec()
            )
            .on('error', 
                (err) =>
                    @logger.error(err)
            )
            .exec()

    index: (playerInfo) =>
        @elasticSearchClient.index(config.elasticSearch.indexName, config.elasticSearch.typeName, JSON.parse(playerInfo.toJSON()))
            .on('data', 
                (data) =>
            )
            .on('error', 
                (err) =>
                    @logger.error(err)
            )
            .exec()

module.exports = Indexer