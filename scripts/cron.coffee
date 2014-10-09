# Description
#  cron jobs
ROOM = "#test"
API_HN_UPDATES = "https://hacker-news.firebaseio.com/v0/updates.json"

cronJob = require('cron').CronJob

module.exports = (robot) ->
  # room = process.env.HUBOT_HIPCHAT_ROOMS_ANNOUNCE
  test = new cronJob('5/* * * * *', () =>
    # envelope = room: ROOM
    http = robot.http(API_HN_UPDATES)
    http (err, res, body) ->
      if (!err)
        json = JSON.parse body
        robot.send {room: ROOM}, "items #{json.items}"
  )
  test.start()
