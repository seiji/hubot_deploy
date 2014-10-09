# Description
#  cron jobs
ROOM = "#test"

cronJob = require('cron').CronJob
hackerNews = require('../libs/hacker-news')

module.exports = (robot) ->
  # room = process.env.HUBOT_HIPCHAT_ROOMS_ANNOUNCE
  api_hn = new cronJob('*/5 * * * *', () =>
    hackerNews.updates(robot, (json) ->
      for itemID in json.items
        if not hackerNews.isRead(robot, itemID)
          hackerNews.read(robot, itemID)
          hackerNews.item(robot, itemID, (item) ->
            type = item.type
            if type not in ['comment']
              robot.send {room: ROOM}, "item #{item.title}\n-#{item.url}"
          )
    )
  )
  api_hn.start

