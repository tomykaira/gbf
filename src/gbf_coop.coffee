f = ->
  setInterval ->
    if localStorage.autoCoop == 'false'
      return
    tap '[data-buton-name="ルームへ"]'
    tap '.pop-friend-request.pop-show .btn-usual-cancel'
    tap '.btn-execute-ready'
    tap '.btn-quest-start'

    if location.href.match(/coopraid\/offer/)
      tap '.pop-usual.common-pop-error.pop-show .btn-usual-ok'

    if location.href.match(/coopraid/)
      tap '.pop-usual.pop-notice.pop-show .btn-usual-ok'

    if tap '.btn-make-ready-large.not-ready'
      wait '.icon-supporter-type-5', (e) ->
        e.trigger 'tap'
        wait '.prt-supporter-attribute:not(.disableView) .btn-supporter:first-child', (e) ->
          e.trigger 'tap'
          setTimeout (->
            wait '.btn-usual-ok:visible', (e) ->
              e.trigger 'tap'
          ), 1000
      return

    if $('.prt-popup-header').text() == '退室確認'
      tap '.btn-leave'

    if $('.prt-popup-header').text() == '退室完了'
      tap '.btn-usual-close'
  , 100

  setInterval ->
    if location.href.match(/gbf.game.mbga.jp.*#coopraid\/offer/)
      tap('.btn-usual-join')
  , 100

if location.href.match(/gbf.game.mbga.jp/)
  setTimeout (->
    attachJs f
    return
  ), 1000
