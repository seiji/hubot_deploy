# Description
#  cron jobs
ROOM = "#news"
LIMIT = 10
async = require('async')
cronJob = require('cron').CronJob
hackerNews = require('../libs/hacker-news')

module.exports = (robot) ->
  # apiHN = new cronJob('*/10 * * * *', () =>
  # apiHN = new cronJob('0 * * * *', () =>
  #   msgs = {}
  #   countItem = 0
  #   hackerNews.topstories(robot, (itemIDList) ->
  #     async.forEach itemIDList, (itemID, next) ->
  #       if not hackerNews.isRead(robot, itemID) and (countItem < LIMIT)
  #         hackerNews.item(robot, itemID, (item) ->
  #           type = item.type
  #           if type not in ['comment', 'job', 'poll', 'pollopt'] and (item.score > 0)
  #             msgs[itemID] = item
  #             countItem++
  #           else
  #             hackerNews.read(robot, itemID)
  #           next()
  #         )
  #       else
  #         next()
  #     , (err) ->
  #       if Object.keys(msgs).length > 0
  #         robot.send {room: ROOM}, "# HackerNews -----"
  #         keys = Object.keys(msgs).sort (a, b) -> msgs[b].score - msgs[a].score
  #         for itemID in keys
  #           item = msgs[itemID]
  #           hackerNews.read(robot, itemID)
  #           robot.send {room: ROOM}, " #{pad(item.score, 3, ' ')}pt [#{item.title}](#{item.url} )"
  #   )
  # )
  # apiHN.start()

pad = (val, length, padChar = '0') ->
  val += ''
  numPads = length - val.length
  if (numPads > 0) then new Array(numPads + 1).join(padChar) + val else val
