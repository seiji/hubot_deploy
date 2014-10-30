# Description:
#   Get lgtm image from lgtm.in
#
# Commands:
#   hubot lgtm - Get image url
#

cheerio = require 'cheerio'

module.exports = (robot) ->
  robot.respond /LGTM/i, (msg) ->
    robot.http('http://www.lgtm.in/g').get() (err, res, body) ->
      if err
        msg.send 'failed'
      else
        $ = cheerio.load body
        msg.send $('#imageUrl').val()

