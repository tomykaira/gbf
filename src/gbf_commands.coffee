f = ->
  tapImpl = (selector, cont, allowNotFound) ->
    waitCount = if allowNotFound then 100 else 300

    find = ->
      waitCount -= 1
      elem = $(selector + ':visible')
      log(elem)
      if elem.length > 0
        elem.trigger('tap')
        cont()
      else if waitCount <= 0
        log 'Could not find selector ' + selector
        if allowNotFound
          cont()
      else
        setTimeout find, 10

    find()

  tapM = (selector, cont) ->
    tapImpl selector, cont, false
    return

  tapOptional = (selector, cont) ->
    tapImpl selector, cont, true
    return

  window.casinoSlot = ->
    tapM '.prt-bet-one', ->
      tapM '.prt-start', ->
        setTimeout casinoSlot, 5000 * (1 + Math.random())

  window.Enhancer = (name, dataKey) ->
    receive = (id, cb) ->
      tapM '.btn-head-pop', ->
        tapM '.txt-global-present', ->
          tapM '.btn-tabs.termed', ->
            tapM '#prt-present-limit .btn-get-all', ->
              tapM '.prt-popup-footer .btn-usual-ok', ->
                tapM '.prt-relation-button[data-key="' + dataKey + '"]', ->
                  tapM ".btn-enhancement-#{name}", ->
                    tapM '.btn-' + name + '[data-' + name + '-id="' + id + '"]', cb
    applyRecommend = (cb) ->
      tapM '.btn-recommend', ->
        tapM '.btn-synthesis', ->
          tapOptional '.prt-popup-footer .btn-usual-ok', ->
            setTimeout cb, 1000
    enhance = (id, startFromEnhance) ->
      log(arguments)
      if startFromEnhance
        applyRecommend ->
          enhance id, false
      else
        receive id, ->
          enhance id, true
    @enhance = enhance
    @

  weaponEnhancer = new Enhancer('weapon', '1')
  summonEnhancer = new Enhancer('summon', '2')

  button = $('<a>強化する</a>').on 'click', ->
    isFull = $('.prt-list-count').text().includes('50 / 50')
    if location.href.includes('enhancement/weapon/base')
      alert('強化する武器を選んでください')
      $('.btn-weapon.lis-weapon').on 'click', (e) ->
        weaponEnhancer.enhance($(this).data('weapon-id'), isFull)
    if location.href.includes('enhancement/summon/base')
      alert('強化する石を選んでください')
      $('.btn-summon.lis-summon').on 'click', (e) ->
        summonEnhancer.enhance($(this).data('summon-id'), isFull)
  $('#my-panel').append(button)

if location.href.match(/gbf.game.mbga.jp/)
  setTimeout (->
    attachJs f
    return
  ), 1000
