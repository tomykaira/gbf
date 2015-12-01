f = ->
  tapImpl = (selector, cont, allowNotFound) ->
    waitCount = if allowNotFound then 100 else 1000
    evt = document.createEvent('UIEvent')

    find = ->
      waitCount -= 1
      elem = document.querySelector(selector)
      if elem != null
        elem.dispatchEvent evt
        setTimeout cont, 1000
      else if waitCount <= 0
        log 'Could not find selector ' + selector
        if allowNotFound
          setTimeout cont, 1000
      else
        setTimeout find, 10
      return

    evt.initUIEvent 'tap', true, true
    evt.window = window
    find()
    return

  tap = (selector, cont) ->
    tapImpl selector, cont, false
    return

  tapOptional = (selector, cont) ->
    tapImpl selector, cont, true
    return

  window.casinoSlot = ->
    tap '.prt-bet-one', ->
      tap '.prt-start', ->
        setTimeout casinoSlot, 5000 * (1 + Math.random())

  window.enhanceWeapon = (id) ->
    tap '.btn-head-pop', ->
      tap '.txt-global-present', ->
        tap '.btn-tabs.termed', ->
          tap '#prt-present-limit .btn-get-all', ->
            tap '.prt-popup-footer .btn-usual-ok', ->
              tap '.prt-relation-button[data-key="1"]', ->
                tap '.btn-enhancement-weapon', ->
                  tap '.btn-weapon[data-weapon-id="' + id + '"]', ->
                    tap '.btn-recommend', ->
                      tap '.btn-synthesis', ->
                        tapOptional '.prt-popup-footer .btn-usual-ok', ->
                          enhanceWeapon id

  window.enhanceSummon = (id) ->
    tap '.btn-head-pop', ->
      tap '.txt-global-present', ->
        tap '.btn-tabs.termed', ->
          tap '#prt-present-limit .btn-get-all', ->
            tap '.prt-popup-footer .btn-usual-ok', ->
              tap '.prt-relation-button[data-key="2"]', ->
                tap '.btn-enhancement-summon', ->
                  tap '.btn-summon[data-summon-id="' + id + '"]', ->
                    tap '.btn-recommend', ->
                      tap '.btn-synthesis', ->
                        tapOptional '.prt-popup-footer .btn-usual-ok', ->
                          enhanceSummon id

if location.href.match(/gbf.game.mbga.jp/)
  setTimeout (->
    attachJs f
    return
  ), 1000
