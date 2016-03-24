basicAutoPlay = ->
  setInterval((->
    select = $('.prt-deck-slider:visible')
    toMyId =
      1: 0
      2: 1
      3: 3
      4: 2
      5: 5
      6: 4
    if select.length > 0
      select.flexslider toMyId[parseInt($('[class*=icon-supporter-type].selected').not('.unselected').data('type'))]
      go = $('.pop-deck .btn-usual-ok')
      if localStorage.autoMulti == 'true' and go.length > 0
        go.trigger 'tap'
    return
  ), 100)

  iid2 = setInterval((->
    go = $('.btn-supporter:visible')
    if localStorage.autoMulti == 'true' and go.length > 0
      clearInterval iid2
      # すぐやると属性の石がえらばれない場合がある
      setTimeout (->
        $(go[0]).trigger 'tap'
        return
      ), 500
    return
  ), 100)

  iid3 = setInterval((->
    button = $('.btn-command-forward:visible:not(.disable)')
    q = undefined
    if button.length > 0
      setTimeout (->
        $('.btn-command-forward:visible:not(.disable)').trigger 'tap'
        return
      ), 1000
    if location.href.includes('result_multi/') and localStorage.autoMulti == 'true'
      location.href = 'http://gbf.game.mbga.jp/#quest/assist/event'
      clearInterval iid3
      location.reload()
      return
    q = '[data-location-href="quest"]:visible:not(.disable)'
    if location.href.match('result_multi/empty') and $(q).length > 0
      setTimeout (->
        $(q).trigger 'tap'
        return
      ), 1000
    button = $('.btn-control[data-location-href="quest"]:visible:not(.disable)')
    if button.length > 0
      setTimeout (->
        button.trigger 'tap'
        return
      ), 1000
    button = $('.pop-continue-quest-comfirm .btn-usual-ok:visible:not(.disable)')
    if button.length > 0
      button.trigger 'tap'
    if $('.txt-popup-body').text().match('通信エラー') or
        $('.txt-popup-body').text() == '既にバトルは終了しました。未確認バトルをご確認ください。' or
        $('.txt-popup-header').text().match('新アイテム入手') or
        $('.prt-popup-header:visible').text() == '獲得経験値'
      tap '.btn-usual-ok'
    if $('.prt-popup-header:visible').text() == 'デイリーミッション'
      tap '.btn-usual-close'

    if $('[class*=multi] .ico-receive-reward').length > 0 or $('.prt-btn-unclaimed .ico-receive-reward:visible').length > 0
      location.href = 'http://gbf.game.mbga.jp/#quest/assist/unclaimed'
      setTimeout ->
        tap('.btn-multi-battle')
        wait '.btn-multi-raid', (e) ->
          e.trigger('tap')
          setTimeout ->
            iv = setInterval ->
              if location.href.match('result_multi')
                tap('.btn-usual-ok')
                tap('[data-buton-name="イベントTOPへ"]:visible:not(.disable)')
              else
                clearInterval(iv)
            , 100
          , 1000
      , 1000

    tap '[data-buton-name="クエストリストへ"]'
    tap '[data-buton-name="イベントTOPへ"]'
  ), 500)

  cooldown = (new Date).getTime()
  iid4 = setInterval((->
    button = $('.cnt-quest-scene > .btn-skip')
    if button.length > 0 and cooldown < (new Date).getTime()
      button.trigger 'tap'
      cooldown = (new Date).getTime() + 10000
      setTimeout (->
        elm = undefined
        if location.href.indexOf('quest/scene') > 0 and (elm = $('.btn-usual-ok:visible,.btn-usual-close:visible')).length > 0 and elm.parents('.pop-result-use-potion').length == 0
          elm.trigger 'tap'
        return
      ), 200
    return
  ), 500)

  setInterval (->
    if location.href.match(/gbf.game.mbga.jp.*#event\/(treasureraid|teamraid)\d\d\d\/gacha\/result/) and $('.btn-reset').length == 0
      $('.txt-available-times10').trigger 'tap'
    return
  ), 500


if location.href.match(/gbf.game.mbga.jp/)
  setTimeout (->
    attachJs basicAutoPlay
    return
  ), 1000

  s = document.createElement('style')
  s.innerText = """
html { zoom: 75% !important; cursor: default !important; }
#loading { bottom: auto !important; }
"""
  document.documentElement.appendChild s
