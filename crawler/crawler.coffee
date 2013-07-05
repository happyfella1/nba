request = require('request')
jsdom = require('jsdom')
fs = require('fs')
jquery = fs.readFileSync("./lib/jquery/jquery-1.9.1.min.js").toString()
logger = require('./logger')
PageHandler = require('./page-handler')
config = require('./config')

console.log('Crawling ' + config.crawler.rootUrl + config.crawler.startUrl + ' ...')
logger.info('Crawling ' + config.crawler.rootUrl + config.crawler.startUrl + ' ...')

process.on('uncaughtException', 
            (err) ->
                logger.error(err)
)

crawler = 
    crawl: (url, resultHandler, attempt) ->
        request({
                uri: url
            }, 
            (error, response, body) ->
                if (error || response.statusCode != 200)
                    logger.error('Failed to crawl: ' + url + ' - ' + error)
                    crawler.crawl(url, resultHandler, attempt + 1) if (attempt <= config.crawler.maxAttemptsOnError)
                    return

                jsdom.env({
                    html: body,
                    src: [jquery],
                    done: (errors, window) -> 
                        if (errors)
                            logger.info('Failed to crawl page: ' + url)
                            logger.error(errors)
                            crawler.crawl(url, resultHandler, attempt + 1) if (attempt <= config.crawler.maxAttemptsOnError)
                            return

                        logger.info('Successfully crawled page: ' + url)
                        $ = window.$
                        resultHandler($)
                })
        )

pageHandler = new PageHandler(crawler, config.crawler.rootUrl, logger)
crawler.crawl(config.crawler.rootUrl + config.crawler.startUrl, pageHandler.handleLandingPage, 1)

#crawler.crawl('http://www.basketball-reference.com/players/a/abdelal01.html', pageHandler.handlePlayerPage, 1)
