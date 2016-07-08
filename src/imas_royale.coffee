f = ->
  window.tapEvent = 'raw'

  setMember = ->
    log('set member', localStorage.setMember, localStorage.setMemberIndex)
    return if localStorage.setMember != 'true'
    return if localStorage.setMemberIndex == undefined
    actions = [
      ['%2Fdeck_index', () -> $('input[value="一括オススメ編成"]').click() ]
      ['%2Fdeck_recommend_all', () -> $('input[value="編成する"]').click() ]
      ['%2Fdeck_index', () -> $('a:contains("編成").grayButton140')[0].click() ]
      ['%2Fevent_deck_edit%3Fdeck%3D1', () ->
        $('a:contains("入れ替え編成")')[0].click()
        $('#change_info_clone img[src*="5caedbb13727f0afdd234d8e73a40a32.jpg"]').click()
        $('#change_info_clone img[src*="a445a50c0d5fb02ff4f82c959384d750.jpg"]').click()
      ]
      ['%2Fevent_deck_edit', () -> $('a div:contains("ロワイヤル攻編成")')[0].click() ]
      ['%2Fevent_deck_edit%3Fdeck%3D2', () -> # 攻編成
        $('a:contains("入れ替え編成")')[0].click()
        $('#change_info_clone img[src*="5caedbb13727f0afdd234d8e73a40a32.jpg"]').click()
        $('#change_info_clone img[src*="2b87ffadfcb99c1f9e6a8b0d13ce2827.jpg"]').click()
      ]
      ['%2Fevent_deck_edit%3Fdeck%3D2', () ->
        $('a:contains("入れ替え編成")')[0].click()
        $('#change_info_clone img[src*="bec7aaa5a179f7543cd32b81ee1791b1.jpg"]').click()
        $('#change_info_clone img[src*="a2014a0c6b69ec002f9f8795e01be8fc.jpg"]').click()
      ]
      ['%2Fevent_deck_edit%3Fdeck%3D2', () ->
        $('a:contains("入れ替え編成")')[0].click()
        $('#change_info_clone img[src*="00bea124dc35973d55b52fa765ad9668.jpg"]').click()
        $('#change_info_clone img[src*="33c1f059acc1311a5f74820b875be8ba.jpg"]').click()
      ]
      ['%2Fevent_deck_edit%3Fdeck%3D2', () ->
        $('#event_logo')[0].click()
      ]
    ]

    index = parseInt(localStorage.setMemberIndex)
    localStorage.setMemberIndex = index + 1
    if index > actions.length - 1
      localStorage.setMember = 'false'
      return
    [url, func] = actions[index]
    if location.href.includes(url)
      func()

  setMemberAuto = ->
    return if localStorage.setMemberAuto != 'true'
    if location.href.includes('%2Fdeck_index')
      return if $('table:first td').length > 1
      log('setting')
      localStorage.setMember = 'true'
      localStorage.setMemberIndex = 0

  setMemberAuto()
  setMember()

  setTimeout ->
    addLocalStorageConfig('setMemberAuto')
  , 100

if location.href.includes('%2Fidolmaster%2Fevent_royale')
  setTimeout (->
    attachJs f
  ), 1000
