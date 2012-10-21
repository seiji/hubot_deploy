url     = require "url"
mongodb = require "mongodb"

module.exports = (robot) ->
  info  = url.parse process.env.MONGO_URL || 'http://127.0.0.1:27017/pubsub'
  server = new mongodb.Server(info.hostname, (Number) info.port, {})
  collection_name = process.env.MONGO_COLLECTION || 'messages' 
  
  # check if there is authentication info
  if info.auth
    # and obtain the username and password
    authArray = info.auth.split ":"
    username = authArray[0]
    password = authArray[1]

  databaseArray = info.pathname.split "/"
  client = new mongodb.Db(databaseArray[1], server, {safe:false});

  #open a connection
  client.open (err, connection) ->
    if err
      throw err
    else if connection
      # if any authentication info was received.
      if info.auth
        # authenticate against the mongo database
        client.authenticate username, password, (err, loggedIn) ->
          if err
            throw err
          else if loggedIn
            connectionOpened robot, client, connection
      else
        connectionOpened robot, client, connection, collection_name

connectionOpened = (robot, client, connection, collection_name) ->
  send = (room, msg) ->
    response = new robot.Response(robot, {user : {id : -1, name : room}, text : "none", done : false}, [])
    response.send msg

  connection.collection collection_name, (err, collection) ->
    if err
      throw err
    collection.find({}).sort({$natural:-1}).limit(1).nextObject (err, doc) ->
      if err
        throw err
      else
        query = { _id: { $gt: doc._id }}
        options = { tailable: true, awaitdata: true, numberOfRetries: -1 }

        cursor = collection.find(query, options).sort({$natural:1})
        
        (next = () ->
          cursor.nextObject (err, message) ->
            if err
              throw err
            else
              console.log message
              send process.env.HUBOT_IRC_ROOMS, message['message']
              next()
        )()

