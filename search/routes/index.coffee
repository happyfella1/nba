ElasticSearchClient = require('elasticsearchclient')
config = require('../config')

exports.elasticSearchServerOptions = {
    host: config.elasticSearch.host
    port: config.elasticSearch.port
    secure: false
}

exports.elasticSearchClient = new ElasticSearchClient(exports.elasticSearchServerOptions)

exports.index = (req, res) ->
    res.render('index', {})

exports.search = (req, res) ->
    console.log('Search string: ' + req.body.searchString)
    exports.elasticSearchClient.search(config.elasticSearch.indexName, 
        config.elasticSearch.typeName, 
        {"query": {"query_string": {"query": req.body.searchString, "default_operator": "AND"}}},
        (err, data) ->
            results = JSON.parse(data)
            retList = []
            console.log('Search results: ' + data)
            for i in [0..results.hits.hits.length-1] by 1
                retList.push(results.hits.hits[i]._source)
            res.json(retList)
    )