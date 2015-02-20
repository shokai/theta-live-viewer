socket = io.connect "#{location.protocol}//#{location.host}"
window.viewer = null

socket.on 'connect', ->
  console.log 'socket.io connect!!'

socket.on 'new picture', (picture) ->
  console.log picture
  viewer.images = [picture.url]
  viewer.load()

$ ->
  console.log 'start!!'
  window.viewer = new ThetaViewer document.getElementById 'viewer'
  #  window.viewer.images = [ '/picture.jpg' ]
  # window.viewer.load()

