# Description
#  cron jobs
ROOM = "#news"

cronJob = require('cron').CronJob
hackerNews = require('../libs/hacker-news')

module.exports = (robot) ->
  apiHN = new cronJob('*/10 * * * *', () =>
    hackerNews.updates(robot, (json) ->
      for itemID in json.items
        if not hackerNews.isRead(robot, itemID)
          hackerNews.read(robot, itemID)
          hackerNews.item(robot, itemID, (item) ->
            type = item.type
            if type not in ['comment', 'job', 'poll', 'pollopt']
              robot.send {room: ROOM}, "[HN] #{item.title}\n- #{pad(item.score, 4, ' ')} points #{item.url}"
          )
    )
  )
  apiHN.start()

pad = (val, length, padChar = '0') ->
  val += ''
  numPads = length - val.length
  if (numPads > 0) then new Array(numPads + 1).join(padChar) + val else val
