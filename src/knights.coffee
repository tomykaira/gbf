ngAuto = ->
  window.tapEvent = 'raw'

  delete console
  unless localStorage.todayCount
    localStorage.todayCount = '0'
  iid = setInterval((->
    if location.href.includes('%2Fgame%2Fmission%2Fresult_lite%2F')
      if tap('#raid-boss-button')
        clearInterval iid
      else if $('#attack_next:visible').length > 0
        location.href = 'http://g12013914.sp.pf.mbga.jp/?url=http%3A%2F%2F125.6.161.10%2Fgame%2Fmission'
        localStorage.autoSelectFirstQuest = 'true'
        return clearInterval iid
      else if (e = $('#attack_area_boss:visible')).length > 0
        location.href = e.prop('href')
        return clearInterval iid
      else if $('#attack:visible').length > 0
        MenuView::attack()
    if location.href.includes('2Fgame%2Fboss%2Fprepare%2F')
      tap '#js-boss-button .red-button-area'
    if location.href.includes('2Fgame%2Fboss%2Fwin%2F')
      if tap '.boss-button-area .orange-button-area'
        clearInterval iid
    if location.href.match(/%2Fgame%2Fmission(%2F)?$/) and
       localStorage.autoSelectFirstQuest == 'true' and
       (execBtn = $('.exec-btn:visible:first a')).length > 0
      localStorage.autoSelectFirstQuest = 'false'
      location.href = execBtn.prop('href')
      return clearInterval iid
    if location.href.includes('%2Fgame%2Fraid%2Fbattle%2Fescape%2F')
      location.href = 'http://g12013914.sp.pf.mbga.jp/?url=http%3A%2F%2F125.6.161.10%2Fgame%2Fmission%2F'
      localStorage.autoSelectFirstQuest = 'true'
      return clearInterval iid
    if location.href.match(/raid.*battle.*boss/)
      if (e = $('.escape-popup_btn:visible')).length > 0
        e.click()
        log $('a[href*="2Fgame%2Fraid%2Fbattle%2Fescape%2F"]')
        wait 'a[href*="2Fgame%2Fraid%2Fbattle%2Fescape%2F"]', (x) ->
          location.href = x.prop('href')
        return clearInterval(iid)
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
      button = if localStorage.isStrongPlayer == 'true' then '#js-bp1-attack' else '#js-bp3-attack'
      if $(button + '-btn-off').length > 0
        location.href = 'http://g12013914.sp.pf.mbga.jp/?url=http%3A%2F%2F125.6.161.10%2Fgame%2Fmission'
        localStorage.autoSelectFirstQuest = 'true'
        return clearInterval(iid);
      if tap(button)
        localStorage.returningFromFlash = 'true'
        return clearInterval(iid);
    if location.href.match(/flash.*pex/)
      if localStorage.returningFromFlash == 'true'
        history.back()
        clearInterval iid
      else
        clickCanvas()
    tap ->
      b = $('a.btn-text')
      if b.text() == 'クエストで魔獣を探す' then b else null
  ), 100)

if location.href.match('g12013914.sp.pf.mbga.jp')
  setTimeout (->
    attachJs ngAuto
  ), 1000
