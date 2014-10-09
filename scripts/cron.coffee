# Description
#  cron jobs
TIMEZONE = "Asia/Tokyo"
ROOM = "#test"
cron = require('cron').CronJob

module.exports = (robot) ->
  # room = process.env.HUBOT_HIPCHAT_ROOMS_ANNOUNCE
  new cron '* * * * *', () =>
    robot.send {room: ROOM}, "cronテスト", null, true, TIMEZONE
