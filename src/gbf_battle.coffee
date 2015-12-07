mainBattle = ->
  isAuto = false
  hasPotion = true
  prevHpSum = -1
  hpRecorded = 0
  restartIv = setInterval((->
    if isAuto and stage and stage.gGameStatus and stage.gGameStatus.boss and !stage.gGameStatus.boss.all_dead
      sum = 0
      stage.gGameStatus.boss.param.forEach (elm) ->
        sum += parseInt(elm.hp)
        return
      if sum == 0
        return next()
      if prevHpSum != sum
        prevHpSum = sum
        hpRecorded = (new Date).getTime()
        return
      if (new Date).getTime() - hpRecorded >= 30 * 1000 and isAuto
        log 'Enemy hp does not change', sum, hpRecorded
        window.localStorage.restartAuto = 'true'
        location.reload()
        clearInterval restartIv
  ), 500)
  initIv = setInterval((->
    autoStart = location.hash.indexOf('#raid_multi') == 0 or window.localStorage.restartAuto == 'true'
    window.localStorage.restartAuto = 'false'
    askHelp = memberCount > 1
    memberCount = undefined
    try
      memberCount = parseInt($('.prt-total-human .current.value[class*=num-info]').map(->
        @getAttribute('class').match(/\d/)[0]
      ).toArray().join(''))
      if isNaN(memberCount) or memberCount == 0
        return
      param = stage.gGameStatus.boss.param[0]
      bossName = param.name
      if 'Lv90 アグネア' == bossName and memberCount < 5 or 'Lv60 グガランナ' == bossName and memberCount < 2 or 'Lv75 エメラルドホーン' == bossName and memberCount < 2 or 'Lv60 ジャック・オー・ランタン' == bossName and memberCount < 2 or 'Lv75 パンプキンビースト' == bossName and memberCount < 2 or 'Lv60 マヒシャ' == bossName and memberCount < 2 or 'Lv75 スーペルヒガンテ' == bossName and memberCount < 2
        log 'This enemy is strong. Wait other members.'
        askHelp = true
        setTimeout (-> location.reload()), 30 * 1000
        autoStart = false
      if bossName == 'Lv50  幽世より至りし者'
        askHelp = true
    catch e
      log e
      return
    log 'autostart ' + autoStart
    window.localStorage.autoMulti = 'false'
    if askHelp
      $('.pop-start-assist .btn-usual-text').trigger 'tap'
      # 救援依頼。あれば
    if memberCount == 1 and $('.btn-chat').length > 0
      $($('.btn-chat')[0]).trigger 'tap'
      wait '.lis-stamp[chatid="2"]', (e) ->
        e.trigger 'tap'
        if autoStart
          setAuto()
    else if autoStart
      setAuto()
    clearInterval initIv
  ), 100)

  deadIv = setInterval((->
    tap('.prt-tips-box')
    tap('.pop-cheer .btn-cheer')

  ), 500)

  autoButton = window.$('<input type="checkbox" style="position: fixed; top: 10px; left: 10px; width: 50px; height: 50px; z-index: 9999;" />')

  setAuto = ->
    isAuto = true
    selectAction()

  toggleAuto = ->
    isAuto = !isAuto
    if isAuto
      setAuto()

  window.addEventListener 'unload', ->
    if isAuto
      window.localStorage.restartAuto = 'true'

  hpRatio = (characterNum) ->
    parseInt $('.lis-character' + characterNum + ' .prt-gauge-hp-inner')[0].style.width

  selectAction = ->
    elm = undefined
    if !isAuto
      return
    if (elm = $('.btn-result:visible')).length > 0
      elm.trigger 'tap'
      return setTimeout(selectAction, 2000)
    if (elm = $('.btn-usual-ok:visible,.btn-usual-close:visible')).length > 0 and elm.parents('.pop-result-use-potion').length == 0 and elm.parents('.pop-friend-request').length == 0 and elm.parents('.pop-raid-menu').length == 0 and $('.prt-pop-header').text() != '離脱確認'
      elm.trigger 'tap'
      return next()
    if $('.btn-attack-start.display-on').length == 0
      setTimeout selectAction, 100
      return

    done = false
    # 複数回バトルの最後以外は攻撃のみ
    battleNums = $('.prt-battle-num .txt-info-num').children()
    if battleNums.length > 0 and battleNums[0].className != battleNums[battleNums.length - 1].className
      $('[ability-recast=0]').each ->
        $this = $(this)
        name = $this.attr('ability-name')
        if name == 'フォーカス'
          $this.trigger 'tap'
          done = true
          return false
      if done
        next()
        return
      if $('.prt-battle-num .txt-info-num').children()[0].getAttribute('class') == 'num-info1' && stage.gGameStatus.turn == 1 && $('.btn-command-summon.summon-on').length > 0
        $('.btn-command-summon').trigger 'tap'
        wait '.summon-show .lis-summon.on', (o) ->
          $(o[0]).trigger 'tap'
          wait '.btn-summon-use:visible', (use) ->
            use.trigger 'tap'
            next()
            return
          return
        return
      $('.btn-attack-start').trigger 'tap'
      setTimeout next, 100
      return

    $('[ability-recast=0]').each ->
      if done
        return false
      $this = $(this)
      type = $this.attr('type')
      name = $this.attr('ability-name')
      charaNum = $this.parents('.prt-ability-list').next().attr('pos')
      hpPercent = hpRatio(charaNum)
      specialPercent = $('[pos=' + charaNum + '] .prt-percent:visible .txt-gauge-value').text()
      statuses = _.uniq($('[pos=' + charaNum + '] .img-ico-status-s').map(->
        `var params`
        $(this).attr 'data-status'
      ))
      if statuses.indexOf('1263') >= 0 or statuses.indexOf('1102') >= 0 or statuses.indexOf('1111') >= 0 or statuses.indexOf('1111_1') >= 0
        return true
      if [
          '丹田喝'
          '丹田喝＋'
        ].indexOf(name) >= 0
        if specialPercent >= 10
          $this.trigger 'tap'
          done = true
          return false
      else if [ 'イグニッション' ].indexOf(name) >= 0
        if specialPercent < 50
          $this.trigger 'tap'
          done = true
          return false
      else if [
          '守りは任せるっす！'
          'グロースラウド'
        ].indexOf(name) >= 0
        # ゲージ消費系は避ける
      else if 'フェイント' == name
        if specialPercent >= 10
          $this.trigger 'tap'
          done = true
          return false
      else if [
          '婆娑羅'
          'レーション＋'
        ].indexOf(name) >= 0
        # 対象選択が面倒なのでつかわない
      else if type.indexOf('heal') >= 0 or [].indexOf(name) >= 0
        if hpPercent < 75
          $this.trigger 'tap'
          done = true
          return false
      else if type.indexOf('dodge') >= 0 or type.indexOf('damage_cut') >= 0 or [ 'ライトウェイトII' ].indexOf(name) >= 0
        params = stage.gGameStatus.boss.param
        if parseInt(params[params.length - 1].recast) <= 1
          $this.trigger 'tap'
          done = true
          return false
      else if name.indexOf('ディレイ') >= 0
        params = stage.gGameStatus.boss.param
        if parseInt(params[params.length - 1].recast) < parseInt(params[params.length - 1].recastmax)
          $this.trigger 'tap'
          done = true
          return false
      else
        $this.trigger 'tap'
        done = true
        return false
      return
    if done
      next()
      return
    if $('.btn-command-summon.summon-on').length > 0
      $('.btn-command-summon').trigger 'tap'
      wait '.summon-show .lis-summon.on', (o) ->
        if (supporter = o.filter( -> @getAttribute('summon-id') == 'supporter')).length > 0
          supporter.trigger('tap')
        else
          o.first().trigger 'tap'
        wait '.btn-summon-use:visible', (use) ->
          use.trigger 'tap'
          next()
      done = true
      return
    hasPotion = parseInt(stage.gGameStatus.temporary.large) > 0
    if hasPotion
      deadly = true
      i = 0
      while i < 4
        deadly = deadly and hpRatio(i) > 0 and hpRatio(i) < 50
        i++
      if hpRatio(0) > 0 and hpRatio(0) < 25 or deadly
        log 'using potion'
        $('.btn-temporary').trigger 'tap'
        wait '.item-large img', (e) ->
          if hasPotion
            e.trigger 'tap'
            wait '.btn-usual-use', (e) ->
              e.trigger 'tap'
              setTimeout next, 2000
              # つかいおわるまで待つ
              return
          else
            $('.btn-usual-cancel').trigger 'tap'
            next()
          return
        return
    canChain = true
    less50 = 0
    $('.prt-percent:visible .txt-gauge-value').each (i) ->
      v = parseInt($(this).text())
      canChain = canChain and v >= 100 - (i * 10)
      if v < 50
        less50 += 1
      return
    if canChain or less50 >= 3
      if $('.btn-lock.lock0').length == 0
        $('.btn-lock').trigger 'tap'
        next()
        return
    else
      if $('.btn-lock.lock1').length == 0
        $('.btn-lock').trigger 'tap'
        next()
        return
    assist = $('.btn-assist:visible')
    if assist.length > 0 and !assist.hasClass('disable') and (!hasPotion or stage.gGameStatus.turn >= 10 or stage.gGameStatus.lose)
      $('.btn-assist:visible').trigger 'tap'
      wait '.pop-start-assist .btn-usual-text', (e) ->
        e.trigger 'tap'
        wait '.btn-usual-ok:visible', (e) ->
          e.trigger 'tap'
          next()
          return
        return
      return
    $('.btn-attack-start').trigger 'tap'
    setTimeout next, 100
    return

  next = ->
    setTimeout selectAction, 10
    return

  autoButton.on 'change', toggleAuto
  $('body').append autoButton

if location.href.match(/gbf.game.mbga.jp.*raid/)
  setTimeout (->
    attachJs mainBattle
    return
  ), 2000
