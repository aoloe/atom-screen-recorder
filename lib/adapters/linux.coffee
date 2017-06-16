{CompositeDisposable} = require 'atom'

module.exports =
  isSupported: ->
    true

  setupFfmpegCmd: (ffmpegCmd, dimensions) ->
    ffmpegCmd
      .input ":0.0+#{dimensions.x},#{dimensions.y}"
      .inputOptions [
        '-f x11grab',
        "-video_size #{dimensions.w}x#{dimensions.h}"
      ]

  handleDimensions: (x, y, w, h) ->
    menubar = atom.getSize().height - document.documentElement.offsetHeight
    aP = atom.getPosition()

    # scale all coordinates with pixel ratio
    x = Math.floor(window.devicePixelRatio * x)
    y = Math.floor(window.devicePixelRatio * y)
    w = Math.floor(window.devicePixelRatio * w)
    h = Math.floor(window.devicePixelRatio * h)
    menubar = Math.floor(window.devicePixelRatio * menubar)
    aP.x = Math.floor(window.devicePixelRatio * aP.x)
    aP.y = Math.floor(window.devicePixelRatio * aP.y)

    {x: x + aP.x, y: y + aP.y + menubar, w: w, h: h}
