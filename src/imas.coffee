imasAuto = ->
  window.tapEvent = 'raw'

  delete console
  localStorage.EventWorkType = '2'
  localStorage.WorkType = '2'
  iid = setInterval ->
    if location.href.includes('quests%2Fwork') && $('#title_val').length == 0
      Imascg.QuestModel.play()
  , 1000

  if location.href.includes('%2Fprofile%2Fshow%2') && document.referrer == 'http://dojo.sekai.in/'
    wait '.m-Btm10.t-Cnt table:nth(0) tr:nth(0) td:nth(1) a', (e) ->
      location.href = e.prop('href')
  if location.href.includes('%2Fbattles%2Fbattle_check')
    wait('input[value="LIVEバトル開始"]:first', (x) -> x.click())
  if location.href.includes('idolmaster%2Fbonus_point')
    $('#add_hp option').prop('selected', false)
    $('#add_hp option:last-child').prop('selected', true)
    # $('.submit_btn').click()
    wait '.popup_check_area', ->
      $('input[value="追加"]').click()
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
