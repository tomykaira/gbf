ngAuto = ->
  window.tapEvent = 'raw'

  delete console
  unless localStorage.todayCount
    localStorage.todayCount = '0'
  iid = setInterval((->
    if location.href.match(/game.*mission.*result_lite/)
      if tap('#raid-boss-button')
        clearInterval iid
      else
        MenuView::attack()
    if location.href.match(/raid.*battle.*boss/)
      if tap 'a[href*="2Fgame%2Fraid%2Fbattle%2Fescape%2F"]'
        return clearInterval(iid)
      if (e = $('.escape-popup_btn')).length > 0
        e.click()
        return
      if tap('.raid-appear-btn a[href*="mission"]')
        wait '.exec-btn a[href*="mission"]', (e) ->
          count = parseInt(localStorage.todayCount) + 1
          localStorage.todayCount = count
          console.log("Beat #{count} mobs")
          if count >= 3
            location.href = 'http://g12013914.sp.pf.mbga.jp/?url=http%3A%2F%2F125.6.161.10%2Fgame%2Fcollaborationevent%2Findex%2F27'
          else
            e[0].click()
        return clearInterval(iid)
      if localStorage.returningFromFlash == 'true'
        localStorage.returningFromFlash = 'false'
        location.reload()
        return clearInterval(iid)
      if tap('#js-bp1-attack')
        localStorage.returningFromFlash = 'true'
        return clearInterval(iid);
    if location.href.match(/flash.*pex/) && localStorage.returningFromFlash == 'true'
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
