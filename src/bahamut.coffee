bahaAttackHelp = ->
  window.tapEvent = 'click'

  setInterval ->
    tap('img[src*="btn_call_1.png"]')
    tap('.ev-btn-rescue')
    tap('a:contains("モンスター一覧"):first')
    if (e = $('a:contains("モンスター一覧"):visible:first')).length > 0
      location.href = e.prop('href')
    e = $('.jsbtn.btnMain.attack:visible')
    if e.length > 0 and localStorage.attacked.indexOf(location.href.toString()) == -1
      e.trigger 'click'
      localStorage.attacked += ',' + location.href.toString()
  , 1000

if location.href.match('sp.pf.mbga.jp/12007160')
  attachJs bahaAttackHelp
