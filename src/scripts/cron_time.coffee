cronJob = require('cron').CronJob
 
module.exports = (robot) ->
  send = (room, msg) ->
    response = new robot.Response(robot, {user : {id : -1, name : room}, text : "none", done : false}, [])
    response.send msg
 
  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cronJob('0 8 * * * *', () ->
    currentTime = new Date
    console.log(process.env.HUBOT_IRC_ROOMS)
    send process.env.HUBOT_IRC_ROOMS, "current times is #{currentTime}"
  ).start()

