casino = ->
  loadedAt = new Date().getTime()

  humanTap = (button, nextAction) ->
    setTimeout (->
      button.trigger 'tap'
      wait nextInvert[nextAction], nextAction
      return
    ), 500

  getCurrentBet = ->
    str = ''
    $('.prt-bet').find('[class*=num-gold2]').each (i, elm) ->
      str += elm.getAttribute('class').slice(-1)
      return
    parseInt str

  start = (button) ->
    if ((new Date().getTime() - loadedAt) > 30 * 60 * 1000)
      alert('Auto stop');
      return
    log('now on start ',
      localStorage.autoMulti == 'true',
      localStorage.lastCheckedAt?,
      parseInt(localStorage.lastCheckedAt),
      parseInt(localStorage.lastCheckedAt) < new Date().getTime() - 60 * 1000)
    if localStorage.autoMulti == 'true' and
        localStorage.lastCheckedAt? and parseInt(localStorage.lastCheckedAt) < new Date().getTime() - 60 * 1000
      location.href = 'http://gbf.game.mbga.jp/#quest/assist'
      return
    setTimeout (->
      humanTap button, selectHolds
      return
    ), 500

  selectHolds = (okButton) ->
    # 1-indexed
    cards = _.map(window.cards_1_Array, (c, idx) ->
      pair = c.split('_')
      {
        idx: idx + 1
        suit: pair[0]
        number: pair[1]
        hold: false
      }
    )
    # joker
    doHold _.filter(cards, (card) ->
      card.suit == '99'
    )
    flush = _.find(_.groupBy(cards, 'suit'), (group) ->
      group.length >= 4
    )
    if flush
      doHold flush
    else
      _.each _.groupBy(cards, 'number'), (group) ->
        if group.length >= 2
          doHold group
        return
    $.each cards, (idx, elm) ->
      if !elm.hold
        return
      id = elm.idx
      Game.view.holdCard type: [ new String(id) ]
      exportRoot['card_' + id + '_select'] = 1
      return
    humanTap okButton, doubleUpOrNext
    return

  doHold = (cards) ->
    _.each cards, (card) ->
      card.hold = true
      return
    return

  # TODO: bet 金額のチェックと No の選択

  doubleUpOrNext = (button) ->
    if button.hasClass('prt-yes')
      if window.doubleUp_card_2 != undefined
        bet = getCurrentBet()
        number = parseInt(doubleUp_card_2.split('_')[1])
        if number == 8 or bet > 5000 and number >= 7 and number <= 9 or bet > 10000 and number >= 5 and number <= 11
          log 'Stopping at ' + number + ', ' + bet
          window.doubleUp_card_2 = undefined
          humanTap $('.prt-no'), start
          return
      humanTap button, doubleUpSelect
    else
      setTimeout (->
        start button
        return
      ), 500
    return

  doubleUpSelect = (buttons) ->
    number = parseInt(doubleUp_card_1.split('_')[1])
    if number == 1 or number >= 9
      humanTap buttons.filter('[select="low"]'), doubleUpOrNext
    else
      humanTap buttons.filter('[select="high"]'), doubleUpOrNext
    return

  # define after functions
  nextButton =
    '.prt-start:visible': start
    '.prt-ok:visible': selectHolds
    '.prt-yes:visible,.prt-start:visible': doubleUpOrNext
    '.prt-double-select:visible': doubleUpSelect
  nextInvert = _.invert(nextButton)

  setTimeout ->
    done = false
    _.each nextButton, (fn, sel) ->
      elm = $(sel)
      if !done and elm.length > 0
        fn elm
        done = true
        return false
      return true
  , 2000

if location.href.match(/gbf.game.mbga.jp.*casino\/game\/poker\//)
  setTimeout (->
    attachJs casino
  ), 1000
