# Description
#  cron jobs
TIMEZONE = "Asia/Tokyo"
ROOM = "#test"
cron = require('cron').CronJob

module.exports = (robot) ->
  # room = process.env.HUBOT_HIPCHAT_ROOMS_ANNOUNCE
  test = new cron('* * * * *', () =>
    envelope = room: ROOM
    robot.send envelope, "ここにメッセージを突っ込みます。"
  )
  test.start()
