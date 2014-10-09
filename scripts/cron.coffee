# Description
#  cron jobs
cron = require('cron').CronJob

module.exports = (robot) ->
  # room = process.env.HUBOT_HIPCHAT_ROOMS_ANNOUNCE
  room = "#test"
  new cron '0 * * * *', () =>
     robot.send {room: room}, "cronテスト"
     , null, true, "Asia/Tokyo"
