selectMultiBattle = ->
  interestedEnemies = [
    'アグニス討伐戦'
    'Lv40 ゲイザー'
    'Lv30 スカジ'
    'Lv30 ヒドラ'
    'Lv40 パンプキンヘッド'
    'Lv30 闘虫禍草'
    'Lv40 ヨグ＝ソトース'
    'Lv50  幽世より至りし者'
    'ネプチューン討伐戦'
    'Lv40 スノウマン'
    'ブッチャギー討伐戦'
    ''
  ]
  iid = setInterval ->
    unless location.href.includes('quest/assist') and $('.prt-raid-info').length != 0
      return
    if location.href.includes('quest/assist/unclaimed')
      return
    if window.localStorage.autoMulti != 'true'
      return
    try
      if $('.prt-btn-unclaimed .ico-receive-reward:visible').length > 0
        return

      myBP = parseInt($('.prt-user-bp-value').prop('title'))
      if isNaN(myBP)
        log 'my BP is NaN'
        return location.reload()
      selected = false
      $('.prt-raid-info').each ->
        $this = $(this)
        name = $this.find('.txt-raid-name').text()
        required = parseInt($this.find('.prt-use-ap').data('ap'))
        if interestedEnemies.indexOf(name) != -1 and required <= myBP
          $this.trigger 'tap'
          selected = true
          return false
        return
      if !selected
        clearInterval(iid)
        if myBP < 5
          location.href = 'http://gbf.game.mbga.jp/#casino/game/poker/200030'
          localStorage.lastCheckedAt = new Date().getTime()
          setTimeout ->
            location.reload()
          , 1000
          return
        setTimeout ->
          location.reload()
        , 5000
    catch e
      log 'Exception', e
    return
  , 100

if location.href.includes('gbf.game.mbga.jp')
  setTimeout (->
    attachJs selectMultiBattle
    return
  ), 2000
