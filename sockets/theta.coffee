debug = require('debug')('theta-live-viewer:controller:theta')

Theta = require 'ricoh-theta'
theta = new Theta()
theta.connect process.env.THETA_ADDR or '192.168.1.1'

theta.once 'connect', ->
  theta.capture (err) ->
    debug err if err

module.exports = (app) ->
  io = app.get 'socket.io'

  io.on 'connection', (socket) ->
    debug 'new connection'

    io.sockets.emit 'new picture',
      url: "/pictures/theta.jpg"

  theta.on 'objectAdded', (object_id) ->
    debug "objectAdded: #{object_id}"
    theta.getPicture object_id, (err, res) ->
      return debug err if err
      picture.data = res
      io.sockets.emit 'new picture',
        url: '/picture.jpg'
        date: picture.create_at = Date.now()

