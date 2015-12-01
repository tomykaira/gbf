ngAuto = ->
  window.tapEvent = 'raw'
  wait = (selector, cont, counter) ->
    if typeof counter == 'undefined'
      counter = 500
    if counter <= 0
      console.log 'wait() timed out', selector, cont
      return
    elm = undefined
    found = undefined
    if typeof selector == 'function'
      elm = selector()
      found = elm
    else
      elm = $(selector + ':visible:not(.disable)')
      found = elm.length > 0
    if found and cont
      cont elm
    else
      setTimeout (->
        wait selector, cont, counter - 1
      ), 20


  delete console
  iid = setInterval((->
    if location.href.match(/game.*mission.*result_lite/)
      if tap('#raid-boss-button')
        clearInterval iid
      else
        MenuView::attack()
    if location.href.match(/raid.*battle.*boss/)
      if (e = $('.escape-popup_btn')).length > 0
        e.click()
        clearInterval(iid)
      tap '#popup-bg-area a[href*="escape"]'
      if tap('.raid-appear-btn a[href*="mission"]')
        wait '.exec-btn a[href*="mission"]', (e) ->
          e[0].click()
        return clearInterval(iid)
      if localStorage.returningFromFlash == 'true'
        localStorage.returningFromFlash = 'false'
        location.reload()
        return clearInterval(iid)
      tap('#js-bp1-attack');
      return clearInterval(iid);
    else
    if location.href.match(/flash.*pex/)
      localStorage.returningFromFlash = 'true'
      history.back()
      clearInterval iid
    tap ->
      b = $('a.btn-text')
      if b.text() == 'クエストで魔獣を探す' then b else null
  ), 1000)

if location.href.match('g12013914.sp.pf.mbga.jp')
  setTimeout (->
    attachJs ngAuto
  ), 1000
