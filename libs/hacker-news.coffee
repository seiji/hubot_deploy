API_HN_ITEM    = "https://hacker-news.firebaseio.com/v0/item/"
API_HN_UPDATES = "https://hacker-news.firebaseio.com/v0/updates.json"

module.exports =
  updates: (robot, callback) ->
    robot.http(API_HN_UPDATES).get() (err, res, body) ->
      if (!err)
        json = JSON.parse body
        callback(json)
  item: (robot, itemID, callback) ->
    robot.http(API_HN_ITEM + itemID + ".json").get() (err, res, body) ->
      if (!err)
        json = JSON.parse body
        callback(json)
  read: (robot, itemID) ->
    sign = "hn_#{itemID}"
    robot.brain.data[sign] = 1
    robot.brain.save()

  isRead: (robot, itemID) ->
    sign = "hn_#{itemID}"
    return robot.brain.data[sign] > 0

