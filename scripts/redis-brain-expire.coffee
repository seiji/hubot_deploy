# Description:
#   None
#
# Dependencies:
#   "redis": "0.8.4"
#
# Configuration:
#   REDISTOGO_URL or REDISCLOUD_URL or BOXEN_REDIS_URL or REDIS_URL.
#   URL format: redis://<host>:<port>[/<brain_prefix>]
#   If not provided, '<brain_prefix>' will default to 'hubot'.
#
# Commands:
#   None
#
# Authors:
#   atmos
#   jan0sch
#   spajus

Url   = require "url"
Redis = require "redis"
Async = require "async"

module.exports = (robot) ->
  info   = Url.parse process.env.REDISTOGO_URL or process.env.REDISCLOUD_URL or process.env.BOXEN_REDIS_URL or process.env.REDIS_URL or 'redis://localhost:6379', true
  client = Redis.createClient(info.port, info.hostname)
  prefix = info.path?.replace('/', '') or 'hubot'

  getData = ->
    client.keys "#{prefix}:storage:*", (err, postKeys) ->
      if err
        throw err
      else if postKeys
        robot.logger.info "Data for #{prefix} brain retrieved from Redis"
        Async.map postKeys, (postKey, callback) ->
          client.get postKey, (err, value) ->
            if err
              callback err
            else
              callback null, { key: postKey, value:value }
        , (err, postList) ->
          if err
            throw err
          data = {}
          for post in postList
            key   = post['key']
            value = post['value']
            key = key.replace("#{prefix}:storage:", "")
            data[key] = { value: value, expire: 0 }
          robot.brain.mergeData data
      else
        robot.logger.info "Initializing new data for #{prefix} brain"
        robot.brain.mergeData {}

  if info.auth
    client.auth info.auth.split(":")[1], (err) ->
      if err
        robot.logger.error "Failed to authenticate to Redis"
      else
        robot.logger.info "Successfully authenticated to Redis"
        getData()

  client.on "error", (err) ->
    robot.logger.error err

  client.on "connect", ->
    robot.logger.debug "Successfully connected to Redis"
    getData() if not info.auth

  robot.brain.on 'save', (data = {}) ->
    for k,v of data
      if k != 'users' && k != '_private'
        value  = v['value']
        expire = v['expire']
        if expire > 0
          setKey = "#{prefix}:storage:#{k}"
          client.setex setKey, expire, value
          data[k] = { value: value, expire: 0 }

  robot.brain.on 'close', ->
    client.quit()
