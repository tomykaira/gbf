f = ->
  iid0 = setInterval ->
    if localStorage.autoCoop == 'false'
      return
    tap '[data-buton-name="ルームへ"]'
    tap '.pop-friend-request.pop-show .btn-usual-cancel'
    tap '.btn-execute-ready'
    if (c = Game?.view?.member_count) && c == 4
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

    if $('.prt-popup-header').text() == '解散確認'
      tap '.btn-close'

    if $('.prt-popup-header').text() == '退室完了'
      tap '.btn-usual-close'

    if location.href.match(/gbf.game.mbga.jp.*#coopraid\/offer/)
      ngWords = ['パンデ', 'サジ', '匙', 'さじ', 'コロゥ', 'ダークマター', '順', 'EX', 'ex', 'E1', 'E2', 'E3', 'E4', 'E5']
      iid = setInterval ->
        if $('#loading:visible').length == 0
          clearInterval(iid)
          clearInterval(iid0)
          if room = _.find(Game.view.wanted_list_model.attributes.list, (r) ->
              r.can_join &&
                r.member.length < 3 &&
                ['1', '6', '5'].indexOf(r.invite_type) != -1 &&
                !_.some ngWords, (ng) -> r.short_comment.includes(ng)
              )
            $('.frm-room-key').val(room.room_key)
            $('.btn-post-key').trigger('tap')
          setTimeout ->
            window.location.reload()
          , 2000

      , 100
  , 100

  if location.href.include('#coopraid/room/')
    maxCount = 0
    iid = setInterval ->
      count = Game.view?.member_count
      unless count
        return
      if maxCount < count
        maxCount = count
      if count <= 2 && maxCount > 2
        tap('.btn-leave-room')
        clearInterval(iid)


if location.href.match(/gbf.game.mbga.jp/)
  setTimeout (->
    attachJs f
    return
  ), 1000
