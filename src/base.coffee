window.attachJs = (func) ->
  str = '!(' + func + ')();'
  s = document.createElement('script')
  s.type = 'text/javascript'
  s.innerHTML = str
  document.documentElement.appendChild s

loader = ->
  window.log = ->
    console.__proto__.log.apply console, arguments
    return

  window.tap = (selector) ->
    elm = undefined
    found = undefined
    if typeof selector == 'function'
      elm = selector()
      found = elm
    else
      elm = $(selector + ':visible:not(.disable)')
      found = elm.length > 0
    if found
      switch window.tapEvent
        when 'raw'
          if elm[0] and elm[0].click
            elm[0].click()
          if elm.click
            elm.click()
        when 'click'
          elm.trigger('click')
        else
          elm.trigger('tap')
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


attachJs(loader)
