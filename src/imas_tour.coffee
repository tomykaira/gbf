f = ->
  window.tapEvent = 'raw'

  localStorage.EventWorkType = '2'
  localStorage.WorkType = '2'

  attackRival = ->
    check = $('#help_chk:visible')
    if check.length == 0 || check.prop('disabled')
      tap('#itemSelect > div > div:first-child form .submitBt')
      return

    tap(check)
    if $('.burst_appeal .gauge_value').text() == '300%'
      tap('.burst_appeal a')
      wait '#appeal_confirm_box_clone > div > div.frame.t-Cnt > div > p > a', (e) ->
        localStorage.returningFromFlash = true
        tap(e)
      return

    localStorage.returningFromFlash = true
    tap('#live_button_input3')
    return

  tourAuto = ->
    return if localStorage.autoTour != 'true'
    actions = [
      ['%2Fwork%', '#use_item_button8:visible', (e) ->
        Imascg.UserItemModel._useItem(8,1)
        setTimeout ->
          location.reload()
        , 500
      ]
      ['%2Fwork%', '#unit_live_battle:visible', (e) -> tap(e)]
      ['%2Fwork%', '#play_button:not([disabled])', (e) ->
        if $('#title_val:visible').length == 0
          Imascg.QuestModel.play()
          setTimeout ->
            tourAuto()
          , 1000
      ]
      ['%2Fget_raid_boss%', '#raid_boss_info .t-Lft', (e) ->
        if localStorage.returningFromFlash == 'true'
          localStorage.returningFromFlash = 'false'
          location.reload()
          return
        bossName = $(e).text()
        if bossName.includes?('Rank:A') or
            bossName.includes?('Rank:SP') or
            bossName.includes?('(HARD)') or
            bossName.includes?('(VERY HARD)')
          attackRival()
        else
          tap('.home')
      ]
      ['%2Fevent_carnival%2Fraid_win%', '#top > p > a', (e) -> tap(e)]
      ['%2Fevent_carnival%2Fraid_win%', '#top > div.t-Cnt > p > a', (e) -> tap(e)]
      ['', '#top > div.displayBox > div:nth-child(2) > p > a', (e) -> tap(e)]
    ]

    setTimeout ->
      fulfilled = false
      selectors = []
      for item in actions
        [url, selector, callback] = item
        if location.href.includes(url)
          selectors.push([selector, callback])
      wait ->
        for s in selectors
          if $(s[0]).length > 0
            return s
        null
      , (s) ->
        log(s)
        s[1]($(s[0]))
    , 200

  tourAuto()

  setTimeout ->
    addLocalStorageConfig('autoTour')
  , 100

if location.href.includes('%2Fidolmaster%2Fevent_carnival%')
  setTimeout (->
    attachJs f
  ), 1000

skipFlash = ->
  if location.href.includes('event_carnivalSsSsraid_battle_swfSsSs')
    if localStorage.returningFromFlash == 'true'
      return history.back()
    lp = ->
      clickCanvas()
      if $('canvas').length > 0
        setTimeout(lp, 10)
    return lp()

  if location.href.includes('event_carnivalSsSsappear_area_boss_swfSsSs')
    lp = ->
      clickCanvas()
      if $('canvas').length > 0
        setTimeout(lp, 10)
    return lp()

if location.href.includes('%2Fidolmaster%2Fsmart_phone_flash%')
  setTimeout (->
    attachJs skipFlash
  ), 1000
