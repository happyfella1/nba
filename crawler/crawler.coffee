request = require('request')
jsdom = require('jsdom')
fs = require('fs')
jquery = fs.readFileSync("./lib/jquery/jquery-1.9.1.min.js").toString()
logger = require('./logger')
PageHandler = require('./page-handler')
config = require('./config')
#memwatch = require('memwatch')

console.log('Crawling ' + config.crawler.rootUrl + config.crawler.startUrl + ' ...')
logger.info('Crawling ' + config.crawler.rootUrl + config.crawler.startUrl + ' ...')

### Uncomment for memory watch to detect leaks
memwatch.on('leak', 
            (info) ->
                console.log(info)
)
###

process.on('uncaughtException', 
            (err) ->
                logger.error(err)
)

crawler = 
    crawl: (relativeUrl, resultHandler, attempt) =>
        request({
                    uri: config.crawler.rootUrl + relativeUrl
                },
                (error, response, body) ->
                    if (error || response.statusCode != 200)
                        logger.info('Failed to crawl page: ' + config.crawler.rootUrl + relativeUrl)
                        logger.error(error)
                        if (attempt <= config.crawler.maxAttemptsOnError)
                            crawler.crawl(relativeUrl, resultHandler, attempt + 1)
                        return

                    jsdom.env({
                        html: body,
                        src: [jquery],
                        done: (errors, window) -> 
                            if (errors)
                                logger.info('Failed to crawl page: ' + config.crawler.rootUrl + relativeUrl)
                                logger.error(errors)
                                if (attempt <= config.crawler.maxAttemptsOnError)
                                    crawler.crawl(relativeUrl, resultHandler, attempt + 1)
                                return

                            jQuery = window.jQuery
                            logger.info('Successfully crawled page: ' + config.crawler.rootUrl + relativeUrl)
                            resultHandler(config.crawler.rootUrl + relativeUrl, jQuery)
                    })
        )

pageHandler = new PageHandler(crawler, logger)
crawler.crawl(config.crawler.startUrl, pageHandler.handleLandingPage, 1)
