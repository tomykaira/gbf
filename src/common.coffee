f = ->
  old_navi = window.navigator
  new_navi = new (->)
  x = null
  for x of navigator
    `x = x`
    new_navi[x] = if typeof navigator[x] == 'function' then (->
      old_navi[x]()
    ) else navigator.x

  createEvent = (e, name) ->
    ev = document.createEvent('Event')
    ev.initEvent name, true, true
    ev.altkey = false
    ev.bubbles = true
    ev.cancelBubble = false
    ev.cancelable = true
    ev.charCode = 0
    ev.clientX = e.clientX
    ev.clientY = e.clientY
    ev.ctrlKey = false
    ev.currentTarget = ev.currentTarget
    ev.keyCode = 0
    ev.metaKey = false
    ev.offsetX = e.offsetX
    ev.offsetY = e.offsetY
    ev.pageX = e.pageX
    ev.pageY = e.pageY
    ev.returnValue = e.returnValue
    ev.screenX = e.screenX
    ev.screenY = e.screenY
    ev.shiftKey = false
    ev.srcElement = e.srcElement
    ev.target = e.target
    ev.timeStamp = e.timeStamp
    ev.view = e.view
    ev.rotation = 0.0
    ev.scale = 1.0
    ev.touches = []
    ev.touches[0] =
      clientX: e.clientX
      clientY: e.clientY
      force: 1.0
      pageX: e.pageX
      pageY: e.pageY
      screenX: e.screenX
      screenY: e.screenY
      target: e.target
    ev.changedTouches = ev.touches
    ev

  fireEvent = (e, name) ->
    ev = createEvent(e, name)
    e.stopPropagation()
    e.target.dispatchEvent ev
    false

  new_navi.userAgent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25'
  new_navi.appCodeName = 'Mozilla'
  new_navi.appVersion = '5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'
  new_navi.Vendor = 'Apple Computer, Inc.'
  new_navi.platform = 'iPhone'
  new_navi.plugins = PluginArray.prototype
  window.navigator = new_navi

  window.ondragstart = ->
    false

  window.orientation = 0
  window.ondeviceorientation = null
  window.ondevicemotion = null
  window.onorientationchange = null

  document.createTouch = ->
    '[native code]'
    return

  document.createTouchList = ->
    '[native code]'
    return

  document.ondragstart = ->
    false

  if location.href.includes('http://sp.pf.mbga.jp/12007160')
    window.ontouchstart			= (e) -> fireEvent(e, 'touchstart')
    window.ontouchmove			= null;
    window.ontouchend			= (e) -> fireEvent(e, 'touchend')

  window.innerWidth = 480
  delete console # enable console.log

  if window.Game?.reportError?
    window.Game.reportError = ->

if location.href.match('sp.pf.mbga.jp')
  attachJs f
  if !location.href.match('convert_game_center.*hanafuda')
    document.getElementsByTagName('html')[0].style.zoom = '80%'
