fs   = require 'fs'
path = require 'path'

_     = require 'lodash'
debug = require('debug')('theta-live-viewer:sockets:theta')
Theta = require 'ricoh-theta'
theta = new Theta()
theta.connect process.env.THETA_ADDR

theta.once 'connect', ->
  theta.capture (err) ->
    debug err if err

module.exports = (app) ->

  io = app.get 'socket.io'

  ## 新規クライアントに全写真を通知する
  io.on 'connection', (socket) ->
    debug 'new connection'
    fs.readdir path.resolve("public/pictures"), (err, files) ->
      return debug err if err
      files = _.filter files, (file) -> /^\d+.jpg$/.test file
      files = files.map (file) -> "/pictures/#{file}"
      socket.emit 'init pictures', files

  capture_timer_id = null
  theta.on 'objectAdded', (object_id) ->
    debug "objectAdded: #{object_id}"

    ## 写真をディスクに保存してSocket.IOで通知する
    theta.getPicture object_id, (err, picture) ->
      return debug err if err
      fname = "#{Date.now()}.jpg"
      dest = path.resolve "public/pictures", fname
      fs.writeFile dest, picture, (err) ->
        debug "saved => #{dest}"
        io.sockets.emit 'new picture',
          url: "/pictures/#{fname}"
          date: Date.now()

        ## 30秒後にまた撮影する
        clearTimeout capture_timer_id
        capture_timer_id = setTimeout ->
          theta.capture (err) ->
            debug err if err
        , 30 * 1000
