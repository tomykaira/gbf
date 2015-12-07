selectMultiBattle = ->
  if window.localStorage.autoMulti != 'true'
    return
  isAuto = false
  hasPotion = true
  interestedEnemies = [
    'アグニス討伐戦'
    'Lv40 ゲイザー'
    'Lv30 スカジ'
    'Lv30 ヒドラ'
    'Lv40 パンプキンヘッド'
    'Lv30 闘虫禍草'
    'Lv40 ヨグ＝ソトース'
    'Lv50  幽世より至りし者'
  ]
  setTimeout (->
    try
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
        return location.reload()
    catch e
      log 'Exception', e
    return
  ), 5000   # wait until page is fully rendered

if location.href.match(/gbf.game.mbga.jp.*#quest\/assist/)
  setTimeout (->
    attachJs selectMultiBattle
    return
  ), 2000
