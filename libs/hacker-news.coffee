API_HN_ITEM    = "https://hacker-news.firebaseio.com/v0/item/"
API_HN_UPDATES = "https://hacker-news.firebaseio.com/v0/updates.json"
API_HN_TOPSTORIES = "https://hacker-news.firebaseio.com/v0/topstories.json"
module.exports =
  updates: (robot, callback) ->
    robot.http(API_HN_UPDATES).get() (err, res, body) ->
      if (!err)
        json = JSON.parse body
        callback json

  topstories: (robot, callback) ->
    robot.http(API_HN_TOPSTORIES).get() (err, res, body) ->
      if (!err)
        json = JSON.parse body
        callback json
  item: (robot, itemID, callback) ->
    robot.http(API_HN_ITEM + itemID + ".json").get() (err, res, body) ->
      if (!err)
        json = JSON.parse body
        if not json.url
          json.url = "https://news.ycombinator.com/item?id=#{json.id}"
        callback json
  read: (robot, itemID) ->
    sign = "hn_#{itemID}"
    robot.brain.data[sign] = { v: 1, e: 3600 * 24 }
    robot.brain.save()

  isRead: (robot, itemID) ->
    sign = "hn_#{itemID}"
    return robot.brain.data.hasOwnProperty(sign)

