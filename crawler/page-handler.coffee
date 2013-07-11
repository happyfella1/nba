PlayerInfo = require('./player-info')
Indexer = require('./indexer')

class PageHandler
    crawler: null
    logger: null
    indexer: null

    constructor: (@crawler, @logger) ->
        @indexer = new Indexer(@logger)

    handleLandingPage: (pageUrl, jQuery) =>
        jQuery('#page_content table td.xx_large_text a').each((index, element) =>
            url = jQuery(element).attr('href')
            @crawler.crawl(url, @handleListingPage, 1)
        )
        jQuery = null

    handleListingPage: (pageUrl, jQuery) =>
        jQuery('#players tr').each((index, element) =>
            playerLink = jQuery(element).find('td:first-child a')
            return if (playerLink.length == 0)
            url = playerLink.attr('href')
            @crawler.crawl(url, @handlePlayerPage, 1)
        )
        jQuery = null

    handlePlayerPage: (pageUrl, jQuery) =>
        playerInfoBox = jQuery('#info_box')
        playerNameH1 = playerInfoBox.find('h1')
        if (playerNameH1.length == 0)
            @logger.info('Failed to get player details')
            jQuery = null
            return

        playerPositionSpan = playerNameH1.parent().find('p span').filter(':contains("Position:")')
        playerCollegeSpan = playerNameH1.parent().find('p span').filter(':contains("College:")')
        playerDraftSpan = playerNameH1.parent().find('p span').filter(':contains("Draft:")')
        playerDebutSpan = playerNameH1.parent().find('p span').filter(':contains("NBA Debut:")')

        if (playerNameH1.length > 0)
            playerName = @getDOMNodeValue(playerNameH1[0])
        else
            playerName = ''
        if (playerPositionSpan.length > 0)
            playerPosition = @getDOMNodeValue(playerPositionSpan[0].nextSibling)
        else
            playerPosition = ''
        if (playerCollegeSpan.length > 0 && playerCollegeSpan[0].nextSibling)
            playerCollege = @getDOMNodeValue(playerCollegeSpan[0].nextSibling.nextSibling)
        else
            playerCollege = ''
        if (playerDraftSpan.length > 0 && playerDraftSpan[0].nextSibling && playerDraftSpan[0].nextSibling.nextSibling && playerDraftSpan[0].nextSibling.nextSibling.nextSibling)
            playerDraft = @getDOMNodeValue(playerDraftSpan[0].nextSibling.nextSibling.nextSibling.nextSibling)
        else
            playerDraft = ''
        if (playerDebutSpan.length > 0 && playerDebutSpan[0].nextSibling)
            playerDebut = @getDOMNodeValue(playerDebutSpan[0].nextSibling.nextSibling)
        else
            playerDebutSpan = playerNameH1.parent().find('p span').filter(':contains("ABA Debut:")')
            if (playerDebutSpan.length > 0)
                playerDebut = @getDOMNodeValue(playerDebutSpan[0].nextSibling.nextSibling)
            else
                playerDebut = ''
        
        playerInfo = new PlayerInfo(playerName, playerPosition, playerCollege, playerDraft, playerDebut, pageUrl)
        @indexer.index(playerInfo)
        @logger.info('Player details: ' + playerInfo)

        jQuery = null

    getDOMNodeValue: (domNode) =>
        nodeValue = ''
        if (!domNode)
            return nodeValue

        if (domNode.nodeType == 1)
            nodeValue = domNode.innerHTML.trim()
        else if (domNode.nodeType == 3)
            nodeValue = domNode.nodeValue.trim()
        nodeValue

module.exports = PageHandler