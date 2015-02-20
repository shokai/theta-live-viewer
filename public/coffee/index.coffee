socket = io.connect "#{location.protocol}//#{location.host}"
window.viewer = null

socket.on 'connect', ->
  console.log 'socket.io connect!!'

socket.on 'init pictures', (pictures) ->
  return unless pictures instanceof Array
  viewer.images = pictures
  viewer.load()

socket.on 'new picture', (picture) ->
  console.log picture
  viewer.images.push picture.url
  viewer.load()

$ ->
  console.log 'start!!'
  window.viewer = new ThetaViewer document.getElementById 'viewer'
  viewer.interval = 1200
  viewer.autoRotate = true

