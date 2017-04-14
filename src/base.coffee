window.attachJs = (func) ->
  str = '!(' + func + ')();'
  s = document.createElement('script')
  s.type = 'text/javascript'
  s.innerHTML = str
  document.documentElement.appendChild s

loader = ->
  window.log = ->
    xhr = new XMLHttpRequest()
    xhr.open('GET', 'http://example.com/?' + Array.prototype.slice.call(arguments).join(","));
    xhr.send(null)
    return

  window.tap = (selector) ->
    elm = undefined
    found = undefined
    if typeof selector == 'function'
      elm = selector()
      found = elm
    else if selector instanceof jQuery
      elm = selector
      found = true
    else if selector instanceof HTMLElement
      elm = $(selector)
      found = true
    else
      elm = $(selector + ':visible:not(.disable)')
      found = elm.length > 0
    if found
      if elm.prop('href')?.includes('sp.pf.mbga.jp')
        if elm[0] and elm[0].click
          elm[0].click()
        if elm.click
          elm.click()
      else if location.href.includes('gbf.game.mbga.jp')
        elm.trigger('tap')
      else
        elm.trigger('click')
      return true
    false

  window.wait = (selector, cont, counter) ->
    if typeof counter == 'undefined'
      counter = 500

    if counter <= 0
      log 'wait() timed out', selector, cont
      if $('.prt-popup-body').text().match('直前のゲームを処理中です')
        $('.btn-usual-ok').trigger 'tap'
        setTimeout (->
          if $('.prt-popup-body').text() == ''
            log 'Error is cleared. Retry'
            wait selector, cont, 500
          return
        ), 500
        return

      button = $('.btn-usual-ok,.btn-usual-close')
      if button.length > 0
        button.trigger 'tap'
        setTimeout (->
          if $('.prt-popup-body').text() == ''
            log 'Error is cleared. Retry'
            wait selector, cont, 500
          return
        ), 500
        return selectAction()

      return location.reload()

    if typeof selector == 'function'
      ret = selector()
      if ret
        cont ret
      else
        setTimeout (->
          wait selector, cont, counter - 1
          return
        ), 20
    else
      match = $(selector)
      if match.length > 0
        cont match
      else
        setTimeout (->
          wait selector, cont, counter - 1
          return
        ), 20
    return

  window.clickCanvas = (x, y) ->
    if x?
      x = x/2
    else
      x = window.innerWidth / 2
    if y?
      y = y/2
    else
      y = window.innerHeight / 2
    createTouchEvent = (type) ->
      evt = document.createEvent('UIEvent')
      evt.initUIEvent type, true, true
      evt.view = window
      evt.altKey = false
      evt.ctrlKey = false
      evt.shiftKey = false
      evt.metaKey = false
      evt.touches = [ {
        x: x
        y: y
        pageX: x
        pageY: y
      } ]
      evt

    if canvas = document.querySelector('canvas')
      canvas.dispatchEvent(createTouchEvent('touchstart'))
      canvas.dispatchEvent(createTouchEvent('touchend'))

  window.addLocalStorageConfig = (key) ->
    panel = $('#my-panel')
    dom = $('<div><label class="local-storage-status"><input type="checkbox" />' + key + '</label></div>')
    dom.find('input[type=checkbox]').on 'change', (e) ->
      $target = $(e.currentTarget)
      active = $target.prop('checked')
      localStorage[key] = if active then 'true' else 'false'
      if active
        $target.parent().addClass('active')
      else
        $target.parent().removeClass('active')
    .prop('checked', localStorage[key] == 'true').trigger('change')
    panel.append(dom)

attachJs(loader)
