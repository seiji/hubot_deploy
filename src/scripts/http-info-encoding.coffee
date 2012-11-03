# Description:
#   Returns title and description when links are posted
#
# Dependencies:
#   "iconv": "1.2.3"
#   "cheerio": "0.10.1"
#
# Configuration:
#   None
#
# Commands:
#   http(s)://<site> - prints the title and meta description for sites linked.
#
# Authors:
#   

#request = require('request')
http    = require('http')
https   = require('https')
urlutil = require("url")
Iconv = require('iconv').Iconv
cheerio = require('cheerio')

charsetDetector = require("node-icu-charset-detector");
CharsetMatch    = charsetDetector.CharsetMatch;


module.exports = (robot) ->

  robot.hear /http(s?):\/\/(.*)/i, (msg) ->
    url = msg.match[0] 
    return if url.match(/^http(s?):\/\/twitter\.com/)
 
    unless url.match(/\.(png|jpg|jpeg|gif|txt|zip|tar\.bz|js|css)/) # filter out some common files from trying
      urlElements = urlutil.parse(url, false)

      client = if (urlElements.protocol == 'https:') then https else http

      options =
        # uri:url
        # timeout:2000
        # encoding:null
        host: urlElements.hostname,
        port: urlElements.port,
        path: urlElements.path,
        headers: {
          'User-Agent': 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)'
        }

      request = client.get options, (res) ->
        binaryText = ''
        res.setEncoding('binary');

        res.on 'data', (chunk) ->
          binaryText += chunk

        res.on 'end',  () ->
          textBuffer = new Buffer(binaryText, 'binary')
          charsetMatch = new CharsetMatch(textBuffer)
          text = bufferToString(textBuffer, charsetMatch.getName())

          $ = cheerio.load(text)
          title = $('title').text()
          description = $('meta[name=description]').attr("content") || ""

          msg.notice "#{title}"
          msg.notice "#{description}"

bufferToString = (buffer, charset) ->
  try
    return buffer.toString(charset)
  catch error
    charsetConverter = new Iconv(charset, "utf8")
    return charsetConverter.convert(buffer).toString()
