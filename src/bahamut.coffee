bahaAttackHelp = ->
  window.tapEvent = 'click'
  window.eventType = 'ap1'

  # usual quest
  setTimeout ->
    if location.href.includes('%2Fquest_boss%2F') || location.href.includes('%2Fquest%2F')
      tap('#shortcut_link_show')
  , 300
  setInterval ->
    if location.href.includes('%2Fbahamut%2Fsmart_phone_flash%2Fquest_boss%2F')
      clickCanvas()
  , 1000

  # event
  switch window.eventType
    when 'ap0'
      setInterval ->
        tap('img[src*="btn_call_1.png"]')
        tap('.ev-btn-rescue')
        tap('a:contains("モンスター一覧"):first')
        if (e = $('a:contains("モンスター一覧"):visible:first')).length > 0
          location.href = e.prop('href')
        e = $('.jsbtn.btnMain.attack:visible')
        if e.length > 0 and localStorage.attacked.indexOf(location.href.toString()) == -1
          e.trigger 'click'
          localStorage.attacked += ',' + location.href.toString()
      , 1000
    when 'ap1'
      unless localStorage.todayCount
        localStorage.todayCount = '0'
      setInterval ->
        if parseInt(localStorage.todayCount) >= 5
          return
        # continue quest
        tap('a[href*="quest%2Fdo_mission"]')

        # select action according to monster level
        if (e = $('#pics > span')).length > 0 && (m = e.text().match(/(.*)が出現!/))
          if (m2 = m[0].match(/Lv.(\d+)/)) && parseInt(m2[1]) <= 30
            $('input[type=submit]:last').click()
          else
            $('input[type=submit]:first').click()

        # go to next stage
        if $('img[src*="ui_quest_clear_anime.gif"]').length > 0
          $('input[type=submit]:first').click()

        # boss
        tap('input[value="ボスと戦う"]')
        if location.href.includes('bahamut%2Fsmart_phone_flash%2Fconvert%2FeventsSsSsevent')
          clickCanvas()

        # beat monster
        tap('#attack_normal_use_ap')
        tap('.jsbtn.attack.btn-attack_ap1_item.btnMain')
        if $('h1.ev-subitem-headline').text() == 'バトル結果'
          count = parseInt(localStorage.todayCount) + 1
          localStorage.todayCount = count
          console.log("Beat #{count} mobs")
          tap('input[value="敵を探す"]')

      , 1000

if location.href.match('sp.pf.mbga.jp/12007160')
  attachJs bahaAttackHelp
