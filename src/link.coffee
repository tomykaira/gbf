links =
  '共闘': 'http://gbf.game.mbga.jp/#coopraid'
  'マルチ': 'http://gbf.game.mbga.jp/#quest/assist'
  'ポーカー': 'http://gbf.game.mbga.jp/#casino/game/poker/200030'
  'ナイツ': 'http://g12013914.sp.pf.mbga.jp/?url=http%3A%2F%2F125.6.161.10%2Fgame%2Fuser%2Fmypage'
  'バハ': 'http://sp.pf.mbga.jp/12007160/?guid=ON&url=http%3A%2F%2F203.131.198.133%2Fbahamut%2Fmypage'
  'モバマス': 'http://sp.pf.mbga.jp/12008305/?guid=ON&url=http%3A%2F%2F125.6.169.35%2Fidolmaster%2Fmypage%3Fl_frm%3DTop_2'

commands =
  '地図': ->
    html = $('html')
    html.attr('style', html.attr('style').replace(';', ' !important;'))

root = document.createElement('div')
for label, addr of links
  link = document.createElement('a')
  link.setAttribute('href', addr)
  link.innerHTML = label
  link.style.color = 'white'
  link.style.backgroundColor = 'black'
  root.appendChild(link)
  root.appendChild(document.createElement('br'))
for label, script of commands
  link = document.createElement('a')
  link.addEventListener 'click', ->
    attachJs script
  link.innerHTML = label
  link.style.color = 'white'
  link.style.backgroundColor = 'black'
  root.appendChild(link)
  root.appendChild(document.createElement('br'))

root.style.position = 'fixed'
root.style.top = '20px'
root.style.right = '10px'

window.addEventListener 'DOMContentLoaded', ->
  document.querySelector('body').appendChild(root)
