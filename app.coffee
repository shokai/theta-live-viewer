'use strict'

process.env.THETA_ADDR  ||= '192.168.1.1'

path     = require 'path'
debug    = require('debug')('theta-live-viewer:app')
express  = require 'express'

## config ##
config  = require path.resolve 'config.json'
pkg     = require path.resolve 'package.json'
process.env.PORT ||= 3000


## server setup ##
module.exports = app = express()
app.disable 'x-powered-by'
app.set 'view engine', 'jade'
app.use express.static path.resolve 'public'

http = require('http').Server(app)
io = require('socket.io')(http)
app.set 'socket.io', io
app.set 'config', config
app.set 'package', pkg


## load controllers, models, socket.io ##
components =
  controllers: [ 'main' ]
  models:      [ ]
  sockets:     [ 'theta' ]

for type, items of components
  for item in items
    debug "load #{type}/#{item}"
    require(path.resolve type, item)(app)

## start server ##
http.listen process.env.PORT, ->
  (if debug.enabled then debug else console.log) "server start - port:#{process.env.PORT}"
