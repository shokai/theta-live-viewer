debug = require('debug')('theta-live-viewer:controller:main')

module.exports = (app) ->

  config       = app.get 'config'
  package_json = app.get 'package'

  app.get '/', (req, res) ->

    args =
      title: config.title
      app:
        homepage: package_json.homepage

    return res.render 'index', args
