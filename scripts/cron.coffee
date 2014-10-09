# Description
#  cron jobs
ROOM = "#test"
API_HN_UPDATES = "https://hacker-news.firebaseio.com/v0/updates.json"

cronJob = require('cron').CronJob
hackerNews = require('../libs/hacker-news')

module.exports = (robot) ->
  # room = process.env.HUBOT_HIPCHAT_ROOMS_ANNOUNCE
  api_hn = new cronJob('*/5 * * * *', () =>
    # envelope = room: ROOM
    robot.http(API_HN_UPDATES).get() (err, res, body) ->
      if (!err)
        json = JSON.parse body
        robot.send {room: ROOM}, "items #{json.items}"
  )
  api_hn.start()
