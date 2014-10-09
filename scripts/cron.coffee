# Description
#  cron jobs
ROOM = "#news"
async = require('async')
cronJob = require('cron').CronJob
hackerNews = require('../libs/hacker-news')

module.exports = (robot) ->
  apiHN = new cronJob('*/10 * * * *', () =>
    hackerNews.updates(robot, (json) ->
      msgs = []
      async.each json.items, (itemID, cb) ->
        if not hackerNews.isRead(robot, itemID)
          hackerNews.read(robot, itemID)
          hackerNews.item(robot, itemID, (item) ->
            type = item.type
            if type not in ['comment', 'job', 'poll', 'pollopt']
              msgs.push " #{pad(item.score, 3, ' ')}pt [#{item.title}](#{item.url})"
            cb()
          )
      , (err) ->
        if msgs.length > 0
          robot.send {room: ROOM}, "HackerNews"
          for msg in msgs
            robot.send {room: ROOM}, msg
    )
  )
  apiHN.start()

pad = (val, length, padChar = '0') ->
  val += ''
  numPads = length - val.length
  if (numPads > 0) then new Array(numPads + 1).join(padChar) + val else val
