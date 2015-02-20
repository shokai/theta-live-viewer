'use strict'

path     = require 'path'
debug    = require('debug')('theta-live-camera:app')
express  = require 'express'

## config ##
config       = require path.resolve 'config.json'
package_json = require path.resolve 'package.json'
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
app.set 'package', package_json


## load controllers, models, socket.io ##
components =
  controllers: [ 'main' ]
  sockets: [ 'theta' ]

for type, items of components
  for item in items
    debug "load #{type}/#{item}"
    require(path.resolve type, item)(app)

## start server ##
http.listen process.env.PORT, ->
  debug "server start - port:#{process.env.PORT}"
