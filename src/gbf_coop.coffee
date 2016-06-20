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
      cont = ->
        wait '.prt-supporter-attribute:not(.disableView) .prt-button-cover', (e) ->
          $(e[0]).trigger 'tap'
          setTimeout (->
            wait '.btn-usual-ok:visible', (e) ->
              e.trigger 'tap'
          ), 2000
      setTimeout cont, 1000
      # type = (if localStorage.isStrongPlayer == 'true' then '.icon-supporter-type-3' else '.icon-supporter-type-1')
      # lp = ->
      #   if $("#{type}.selected").length > 0
      #     cont()
      #   else
      #     wait type, (e) ->
      #       e.trigger 'tap'
      #       setTimeout(lp, 100)
      # lp()
      return

    if $('.prt-popup-header').text() == '退室確認'
      tap '.btn-leave'

    if $('.prt-popup-header').text() == '解散確認'
      tap '.btn-close'

    if $('.prt-popup-header').text() == '退室完了'
      tap '.btn-usual-close'

    if location.href.match(/gbf.game.mbga.jp.*#coopraid\/offer/)
      # 1: だれでも, 2: friend, 3: guild, 4: pandemo, 5: drop, 6: daily
      preferredTypes = [4]
      # preferredTypes = [5, 6]
      preferredComment = ['コロ', 'サジ', '匙', 'EX', 'ex', 'パンデモ', 'ゼプ', 'アグ', '階層', 'E3', 'e3', 'E4', 'e4']
      # preferredComment = ['H1', 'ハード', 'hard']
      ownerLevelCap = 90
      ngWords = ['順', '巡', '貼り合い', 'スライム', 'スラ爆', '募集']
      iid = setInterval ->
        if $('#loading:visible').length == 0
          clearInterval(iid)
          clearInterval(iid0)
          list = []
          _.each(Game.view.wanted_list_model.attributes.list, (r) ->
            return unless r.can_join &&
              r.member.length < 3 &&
              (localStorage.isStrongPlayer == 'true' and parseInt(r.rank, 10) >= ownerLevelCap or
                localStorage.isStrongPlayer != 'true' and parseInt(r.rank) <= 60) &&
              ['1', '4', '6', '5'].indexOf(r.invite_type) != -1 &&
              !_.some ngWords, (ng) -> r.short_comment.includes(ng)
            if preferredTypes.indexOf(r.invite_type) != -1 || r.short_comment.includes(preferredComment)
              list.unshift(r)
            else
              list.push(r)
          )
          if list.length > 0
            room = list[0]
            $('.frm-room-key').val(room.room_key)
            $('.btn-post-key').trigger('tap')
          setTimeout ->
            window.location.reload()
          , 2000
      , 100
  , 300

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
    , 1000


if location.href.match(/gbf.game.mbga.jp/)
  setTimeout (->
    attachJs f
    return
  ), 1000
