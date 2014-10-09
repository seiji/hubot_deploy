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
              robot.send {room: ROOM}, "[HN] #{item.title}\n- #{item.score} points #{item.url}"
          )
    )
  )
  apiHN.start()
