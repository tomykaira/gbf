showFuda = ->
  delete console

  makeCard = (num, tag) ->
    img = $("#huda_#{num}").clone()
    img.css
      position: 'absolute'
      display: 'inline'
      zoom: '50%'
    img.addClass(tag)
    $('body').append(img)
    img

  setInterval ->
    data = game_center_obj.api.getVariables('/')
    $('.rival-hand').remove()
    offset = 0
    for i in [1..8]
      v = data["data_rival_hand#{i}"]
      if v == 0 || v == '0'
        continue
      c = makeCard(v, 'rival-hand')
      c.css(top: '20px', left: "#{20 + offset * 110}px")
      offset += 1

    offset = 0
    $('.deck').remove()
    for i in [(game_center_obj.api.getVariables('/').deck_count)..48]
      v = data["data_deck#{i}"]
      c = makeCard(v, 'deck')
      c.css(bottom: '10px', left: "#{20 + offset * 110}px")
      offset += 1

  , 500


if location.href.match(/sp.pf.mbga.jp\/12008305.*convert_game_center%2Fhanafuda%3Fl_frm%3DGame_center_1/)
  setTimeout (->
    body = document.querySelector('body')
    for i in [1..48]
      img = document.createElement('img')
      img.setAttribute('id', "huda_#{i}")
      img.setAttribute('src', chrome.extension.getURL("imas_images/#{i}.jpg"))
      img.style.display = 'none'
      body.appendChild(img)
    attachJs showFuda
  ), 1000
