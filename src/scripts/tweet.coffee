# Description:
#   Display a random tweet from twitter about a subject
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot <keyword> tweet - Returns a link to a tweet about <keyword>
#
# Author:
#   atmos

module.exports = (robot) ->
  robot.respond /(.*) tweet/i, (msg) ->
#    search = escape(msg.match[1])
    search = encodeURIComponent(msg.match[1])
    msg.http('http://search.twitter.com/search.json')
      .query(q: encodeURIComponent search)
      .get() (err, res, body) ->
        tweets = JSON.parse(body)

        if tweets.results? and tweets.results.length > 0
          tweet  = msg.random tweets.results
          msg.send "http://twitter.com/#!/#{tweet.from_user}/status/#{tweet.id_str}"
          msg.send " #{tweet.text}"
        else
          msg.reply "No one is tweeting about that."