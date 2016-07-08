imasAuto = ->
  window.tapEvent = 'raw'

  localStorage.EventWorkType = '2'
  localStorage.WorkType = '2'
  iid = setInterval ->
    if location.href.includes('quests%2Fwork') && $('#title_val:visible').length == 0
      Imascg.QuestModel.play()
  , 1000

  if location.href.includes('%2Fprofile%2Fshow%2') && document.referrer == 'http://dojo.sekai.in/'
    wait '.m-Btm10.t-Cnt table:nth(0) tr:nth(0) td:nth(1) a', (e) ->
      location.href = e.prop('href')
  if location.href.includes('%2Fbattles%2Fbattle_check')
    wait('input[value="LIVEバトル開始"]:first', (x) -> x.click())
  # if location.href.includes('idolmaster%2Fbonus_point')
  #   $('#add_hp option').prop('selected', false)
  #   $('#add_hp option:last-child').prop('selected', true)
  #   # $('.submit_btn').click()
  #   wait '.popup_check_area', ->
  #     $('input[value="追加"]').click()
  if location.href.includes('%2Fidolmaster%2Fbonus_point%2Fadd_check')
    $('#confirm').prop('checked', true)
    $('input[type=submit]').click()

if location.href.includes('sp.pf.mbga.jp/12008305')
  setTimeout (->
    attachJs imasAuto
  ), 1000


showFuda = ->
  delete console

  makeCard = (num, tag) ->
    img = $("#huda_#{num}").clone()
    img.css
      position: 'absolute'
      display: 'inline'
      zoom: '50%'
      zIndex: -1
    img.addClass(tag)
    $('body').append(img)
    img

  setInterval ->
    data = game_center_obj.api.getVariables('/')
    $('.rival-hand').remove()
    offset = 0
    for i in [1..8]
      v = data["data_rival_hand#{i}"]
      if v == 0 || v == '0'
        continue
      c = makeCard(v, 'rival-hand')
      c.css(top: '20px', left: "#{20 + offset * 110}px")
      offset += 1

    offset = 0
    $('.deck').remove()
    for i in [(game_center_obj.api.getVariables('/').deck_count)..48]
      v = data["data_deck#{i}"]
      c = makeCard(v, 'deck')
      c.css(bottom: '10px', left: "#{20 + offset * 110}px")
      offset += 1

  , 500

if location.href.match(/sp.pf.mbga.jp\/12008305.*convert_game_center%2Fhanafuda%3Fl_frm%3DGame_center_1/)
  setTimeout (->
    body = document.querySelector('body')
    for i in [1..48]
      img = document.createElement('img')
      img.setAttribute('id', "huda_#{i}")
      img.setAttribute('src', chrome.extension.getURL("imas_images/#{i}.jpg"))
      img.style.display = 'none'
      body.appendChild(img)
    attachJs showFuda
  ), 1000

surviveCommon = ->
  window.clickAt = (x, y) ->
    clickCanvas(x, y + $('canvas').offset().top)

  window.clickIfShowing = (mc, x, y) ->
    if game_center_obj.api.getMovieClipNamesAtPoint(x, y).includes(mc)
      clickAt(x, y)
      return true
    return false

  window.wait = (cond, maxTrial = 1000) ->
    stack = new Error().stack
    new Promise (resolve, reject) ->
      lp = (times) ->
        if cond()
          resolve()
        else if times >= maxTrial
          log("Not resolved in 1000 trials", stack)
          err = new Error("Not resolved in 1000 trials")
          err.stack = stack
          reject(err)
        else
          setTimeout(lp.bind(null, times + 1), 10)
      lp(0)

  window.waitMc = (mc, x, y) ->
    wait ->
      mcs = game_center_obj.api.getMovieClipNamesAtPoint(x, y)
      unless mcs.includes(mc)
        return false
      cur = ''
      for part in mc.split('/')
        cur = (if cur == '/' then '/' else cur + '/') + part
        unless game_center_obj.api.getVisible(cur)
          return false
      return true
    .then -> return mc

  window.waitAndClick = (mc, x, y) ->
    waitMc(mc, x, y)
    .then -> Promise.delay(100)
    .then -> log('wait click', mc, clickAt(x, y))

  window.waitCssAndClick = (selector) ->
    wait( -> $(selector).length > 0).then -> tap(selector)

  window.Promise.delay = (ms) ->
    new Promise (resolve, reject) ->
      setTimeout(resolve, ms)

  window.Promise.any = (args) ->
    new Promise (resolve, reject) ->
      for arg in args
        arg.then(resolve, reject)

  wait( -> window.jQuery).then ->
    addLocalStorageConfig('autoSurvive')

surviveMain = ->
  return unless localStorage.autoSurvive == 'true'
  waitCssAndClick('canvas')
  .then ->
    game_center_obj.api.setFPS(120)
    waitAndClick('/title', 480, 788)
  .then -> waitAndClick('/sum/ch2/party_member_base', 480, 788)
  .then -> waitAndClick('/sum/ch2/party_member_base', 480, 788)
  .then -> waitMc('/ch1/abl/instance3/instance1', 55, 1020)
  .then -> waitMc('/nav_retry/btn_dice_reroll', 245,755)
  .then -> waitAndClick('/ch1/abl/instance3/instance1', 55, 1020)
  .then -> waitAndClick('/abl_panel/btn_skill_confirm', 630, 681)
  .then ->
    new Promise (resolve, reject) ->
      lp = ->
        Promise.any([
          waitMc('/nav_retry/btn_dice_reroll', 245,755),
          waitMc('/tw', 480, 1000)
        ]).then (mc) ->
          log(mc)
          if mc == '/tw'
            resolve()
          else
            # select stock
            stk1 = game_center_obj.api.getVariables('stk1').s
            stk2 = game_center_obj.api.getVariables('stk2').s
            stk3 = game_center_obj.api.getVariables('stk3').s
            pr = null
            if stk1 >= stk2 && stk1 >= stk3
              pr = waitAndClick('/stk1/s', 684, 789)
            else if stk2 >= stk1 && stk2 >= stk3
              pr = waitAndClick('/stk2/s', 790, 789)
            else if stk3 >= stk1 && stk3 >= stk2
              pr = waitAndClick('/stk3/s', 880, 789)
            pr.then -> setTimeout(lp, 500)
      lp()
  .then -> waitAndClick('/tw', 480, 1000)
  .then -> waitAndClick('/btn_end_game', 288, 769)
  .then -> waitAndClick('/btn_end_game', 288, 769)
  .then ->
    game_center_obj.api.setFPS(12)
    waitAndClick('/ending', 480, 1148)

surviveStart = ->
  wait( -> window.jQuery).then ->
    if localStorage.autoSurvive == 'true'
      waitCssAndClick('.button_start_100')


if location.href.match(/sp.pf.mbga.jp\/12008305.*%2Fgame_center%2Fdice_de_survival%3F/)
  setTimeout (->
    attachJs surviveCommon
    attachJs surviveStart
    return
  ), 1000

if location.href.match(/sp.pf.mbga.jp\/12008305\/.*%2Fidolmaster%2Fsmart_phone_flash%2Fconvert_game_center%2Fdice_de_survival%3F/)
  setTimeout (->
    attachJs surviveCommon
    attachJs surviveMain
    return
  ), 1000
