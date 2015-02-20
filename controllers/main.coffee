debug = require('debug')('theta-live-viewer:controller:main')

module.exports = (app) ->

  config = app.get 'config'
  pkg    = app.get 'package'

  app.get '/', (req, res) ->

    args =
      title: config.title
      app:
        homepage: pkg.homepage

    return res.render 'index', args
