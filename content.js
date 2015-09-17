var f = function(){
    var old_navi = window.navigator;
    var new_navi = new function(){};
    var x   = null;
    for( x in navigator ){
        new_navi[x] = typeof navigator[x] == 'function'
            ? function(){ return old_navi[x]() }
        : navigator.x
        ;
    }

    var createEvent = function(e,name){
        var ev=document.createEvent('Event');
        ev.initEvent(name,true,true);

        ev.altkey=false;
        ev.bubbles=true;
        ev.cancelBubble=false;
        ev.cancelable=true;
        ev.charCode=0;
        ev.clientX=e.clientX;
        ev.clientY=e.clientY;
        ev.ctrlKey=false;
        ev.currentTarget=ev.currentTarget;
        ev.keyCode=0;
        ev.metaKey=false;
        ev.offsetX=e.offsetX;
        ev.offsetY=e.offsetY;
        ev.pageX=e.pageX;
        ev.pageY=e.pageY;
        ev.returnValue=e.returnValue;
        ev.screenX=e.screenX;
        ev.screenY=e.screenY;
        ev.shiftKey=false;
        ev.srcElement=e.srcElement;
        ev.target=e.target;
        ev.timeStamp=e.timeStamp;
        ev.view=e.view;
        ev.rotation=0.0;
        ev.scale=1.0;

        ev.touches=[];
        ev.touches[0] = {
            clientX: e.clientX,
            clientY: e.clientY,
            force: 1.0,
            pageX: e.pageX,
            pageY: e.pageY,
            screenX: e.screenX,
            screenY: e.screenY,
            target: e.target
        };

        ev.changedTouches = ev.touches;
        return ev;
    };
    var fireEvent = function(e,name){
        var ev = createEvent(e,name);
        e.stopPropagation();
        e.target.dispatchEvent(ev);
        return false;
    };

    new_navi.userAgent   = 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25';
    new_navi.appCodeName  = 'Mozilla';
    new_navi.appVersion   = '5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3';
    new_navi.Vendor    = 'Apple Computer, Inc.';
    new_navi.platform   = 'iPhone';
    new_navi.plugins   = PluginArray.prototype;
    window.navigator   = new_navi;

    window.ondragstart   = function(){return false;};
    window.orientation   = 0;
    window.ondeviceorientation = null;
    window.ondevicemotion  = null;
    window.onorientationchange = null;

    document.createTouch  = function createTouch(){'[native code]'};
    document.createTouchList = function createTouchList(){'[native code]'};
    document.ondragstart  = function(){return false;};

    window.innerWidth = 480;
};

var casino = function(){
    function log() {
        console.__proto__.log.apply(console, arguments);
    }

    function wait(selector, cont, counter) {
        if (typeof counter === "undefined")
            counter = 500;
        if (counter <= 0) {
            log("wait() timed out", selector, cont);
            if ($('.prt-popup-body').text().match('直前のゲームを処理中です')) {
                $('.btn-usual-ok').trigger('tap');
                setTimeout(function () {
                    if ($('.prt-popup-body').text() == '') {
                        log("Error is cleared. Retry");
                        wait(selector, cont, 500);
                    }
                }, 500);
            }
            return;
        }
        if (typeof selector === "function") {
            var ret = selector();
            if (ret)
                cont(ret);
            else
                setTimeout(function () { wait(selector, cont, counter - 1); }, 20);
        } else {
            var match = $(selector);
            if (match.length > 0)
                cont(match);
            else
                setTimeout(function () { wait(selector, cont, counter - 1); }, 20);
        }
    }

    function humanTap(button, nextAction) {
        var nextInvert = _.invert(nextButton);
        setTimeout(function () {
            button.trigger('tap');
            wait(nextInvert[nextAction], nextAction);
        }, 500);
    }

    function getCurrentBet() {
        var str = '';
        $('.prt-bet').find('[class*=num-gold2]').each(function (i,elm) {
            str += elm.getAttribute('class').slice(-1);
        });
        return parseInt(str);
    }

    function start(button) {
        log("Auto play " + Game.view.medal);
        setTimeout(function () {
            humanTap(button, selectHolds);
        }, 500);
    }

    function selectHolds(okButton) {
        // 1-indexed
        cards = _.map(window.cards_1_Array, function(c, idx) {
            var pair = c.split("_");
            return { idx: idx + 1, suit: pair[0], number: pair[1], hold: false };
        })

        // joker
        doHold(_.filter(cards, function (card) { return card.suit == "99"; }));
        var flush = _.find(_.groupBy(cards, 'suit'), function (group) { return group.length >= 4 });
        if (flush) {
            doHold(flush);
        } else {
            _.each(_.groupBy(cards, 'number'), function (group) {
                if (group.length >= 2) {
                    doHold(group);
                }
            })
                }

        $.each(cards, function (idx, elm) {
            if (!elm.hold) return;
            var id = elm.idx;
            Game.view.holdCard({type: [new String(id)]});
            exportRoot["card_" + id + "_select"] = 1;
        });

        humanTap(okButton, doubleUpOrNext);
    }

    function doHold(cards) {
        _.each(cards, function(card) { card.hold = true; });
    }

    // TODO: bet 金額のチェックと No の選択
    function doubleUpOrNext(button) {
        if (button.hasClass('prt-yes')) {
            if (window.doubleUp_card_2 !== undefined) {
                var bet = getCurrentBet();
                var number = parseInt(doubleUp_card_2.split('_')[1]);
                if (number == 8
                    || bet > 5000 && number >= 7 && number <= 9
                    || bet > 10000 && number >= 5 && number <= 11) {
                    log("Stopping at " + number + ", " + bet);
                    window.doubleUp_card_2 = undefined;
                    humanTap($('.prt-no'), start);
                    return
                }
            }
            humanTap(button, doubleUpSelect);
        } else {
            setTimeout(function () {
                start(button);
            }, 500);
        }
    }

    function doubleUpSelect(buttons) {
        var number = parseInt(doubleUp_card_1.split('_')[1]);
        if (number == 1 || number >= 9) {
            humanTap(buttons.filter('[select="low"]'), doubleUpOrNext);
        } else {
            humanTap(buttons.filter('[select="high"]'), doubleUpOrNext);
        }
    }

    var nextButton = {
        '.prt-start:visible': start,
        '.prt-ok:visible': selectHolds,
        '.prt-yes:visible,.prt-start:visible': doubleUpOrNext,
        '.prt-double-select:visible': doubleUpSelect,
    };

    function selectNext() {
        var done = false;
        _.each(nextButton, function (fn, sel) {
            var elm = $(sel);
            if (!done && elm.length > 0) {
                fn(elm);
                done = true;
            }
        });
    }

    var autoButton = window.$('<button style="position: fixed; top: 10px; left: 10px; background-color: white; z-index: 9999;">AUTO</button>');
    autoButton.on('click', selectNext);
    $('body').append(autoButton);
    window.Game.reportError = function() {};
}

var mainBattle = function() {
    var isAuto = false;
    var hasPotion = true;

    function log() {
        console.__proto__.log.apply(console, arguments);
    }

    function wait(selector, cont, counter) {
        if (typeof counter === "undefined")
            counter = 500;
        if (counter <= 0) {
            log("wait() timed out", selector, cont);
            var button = $('.btn-usual-ok,.btn-usual-close');
            if (button.length > 0) {
                button.trigger('tap');
                setTimeout(function () {
                    if ($('.prt-popup-body').text() == '') {
                        log("Error is cleared. Retry");
                        wait(selector, cont, 500);
                    }
                }, 500);
            }
            selectAction();
            return;
        }
        if (typeof selector === "function") {
            var ret = selector();
            if (ret)
                cont(ret);
            else
                setTimeout(function () { wait(selector, cont, counter - 1); }, 20);
        } else {
            var match = $(selector);
            if (match.length > 0)
                cont(match);
            else
                setTimeout(function () { wait(selector, cont, counter - 1); }, 20);
        }
    }

    function setAuto() {
        isAuto = true;
        hasPotion = true;
        selectAction();
    }

    function toggleAuto() {
        isAuto = !isAuto;
        if (isAuto) {
            setAuto();
        }
    }

    function hpRatio(characterNum) {
        return parseInt($('.lis-character' + characterNum + ' .prt-gauge-hp-inner')[0].style.width);
    }

    function selectAction() {
        if (!isAuto) {
            return;
        }
        if ($('.btn-attack-start.display-on').length == 0) {
            setTimeout(selectAction, 100);
            return;
        }
        var done = false;
        $('[ability-recast=0]').each(function () {
            if (done)
                return false;
            var $this = $(this);
            var type = $this.attr('type');
            var name = $this.attr('ability-name');
            var charaNum = $this.parents('.prt-ability-list').next().attr('pos');
            var hpPercent = hpRatio(charaNum);
            var specialPercent = $('[pos=' + charaNum + '] .prt-percent:visible .txt-gauge-value').text();
            var statuses = _.uniq($('[pos=' + charaNum + '] .img-ico-status-s').map(function() { return $(this).attr('data-status') }));
            if (statuses.indexOf('1263') >= 0 // 睡眠
                || statuses.indexOf('1102') >= 0 // 麻痺
                || statuses.indexOf('1111') >= 0
                || statuses.indexOf('1111_1') >= 0) // 封印
                return true;
            if (['丹田喝', '丹田喝＋'].indexOf(name) >= 0) {
                if (specialPercent >= 10) {
                    $this.trigger('tap');
                    done = true;
                    return false;
                }
            } else if (['イグニッション'].indexOf(name) >= 0) {
                if (specialPercent < 50) {
                    $this.trigger('tap');
                    done = true;
                    return false;
                }
            } else if ('グロースラウド' == name) {
                if (specialPercent >= 50) {
                    $this.trigger('tap');
                    done = true;
                    return false;
                }
            } else if (['婆娑羅', 'レーション＋'].indexOf(name) >= 0) {
                // 対象選択が面倒なのでつかわない
            } else if (type.indexOf('heal') >= 0 || [].indexOf(name) >= 0) {
                if (hpPercent < 75) {
                    $this.trigger('tap');
                    done = true;
                    return false;
                }
            } else if (type.indexOf('dodge') >= 0 || ['ライトウェイトII'].indexOf(name) >= 0) {
                var params = stage.gGameStatus.boss.param;
                if (params[params.length - 1].recast == 0) {
                    $this.trigger('tap');
                    done = true;
                    return false;
                }
            } else {
                $this.trigger('tap');
                done = true;
                return false;
            }
        });
        if (done) {
            next();
            return;
        }
        if ($('.btn-command-summon.summon-on').length > 0) {
            $('.btn-command-summon').trigger('tap');
            wait('.summon-show .lis-summon.on', function(on) {
                $(on[0]).trigger('tap');
                wait('.btn-summon-use:visible', function(use) {
                    use.trigger('tap');
                    next();
                })
            });
            done = true;
            return;
        }
        if (hasPotion) {
            var deadly = true;
            for (var i = 0; i < 4; i++) {
                deadly = deadly && hpRatio(i) > 0 && hpRatio(i) < 50;
            }
            if ((hpRatio(0) > 0 && hpRatio(0) < 25) || deadly) {
                log("using potion");
                $('.btn-temporary').trigger('tap');
                wait('.item-large img', function(e) {
                    hasPotion = parseInt($('.item-large .having-num').text()) > 0;
                    if (hasPotion) {
                        e.trigger('tap');
                        wait('.btn-usual-use',function(e) {
                            e.trigger('tap');
                            setTimeout(next, 2000); // つかいおわるまで待つ
                        });
                    } else {
                        $('.btn-usual-cancel').trigger('tap');
                        next();
                    }
                });
                return;
            }
        }
        var canChain = true, less50 = 0;
        $('.prt-percent:visible .txt-gauge-value').each(function (i) {
            var v = parseInt($(this).text());
            canChain = canChain && v >= 100 - i * 10;
            if (v < 50) less50 += 1;
        });
        if (canChain || less50 >= 3) {
            if ($('.btn-lock.lock0').length == 0) {
                $('.btn-lock').trigger('tap');
                next();
                return;
            }
        } else {
            if ($('.btn-lock.lock1').length == 0) {
                $('.btn-lock').trigger('tap');
                next();
                return;
            }
        }
        $('.btn-attack-start').trigger('tap');
        setTimeout(next, 100);
    }

    var invocations = [];
    function next() {
        invocations.push(new Date().getTime());
        // too many calls, stacking
        if (invocations.length >= 10 && invocations[invocations.length - 10] > new Date().getTime() - 1000) {
            log('Too many next() calls. Suspect stacking');
            location.reload();
        }
        setTimeout(selectAction, 10);
    }

    var initIv = setInterval(function() {
        var autoStart = false;
        try {
            var count = parseInt($('.prt-total-human .current.value[class*=num-info]').map(function(){return this.getAttribute('class').match(/\d/)[0]}).toArray().join(''));
            if (isNaN(count) || count == 0)
                return;
            autoStart = count > 1;

            // auto restart after too many next() reload
            $.each(stage.gGameStatus.boss.param, function () {
                autoStart = autoStart || this.hp < this.hpmax - 300000;
            })
        } catch(e) {
            log(e);
            return;
        }

        log('autostart', autostart);
        if (autoStart) {
            $('.btn-usual-text').trigger('tap'); // 救援依頼。あれば
            setAuto();
        }

        clearInterval(initIv);
    }, 100);
    var autoButton = window.$('<input type="checkbox" style="position: fixed; top: 10px; left: 10px; width: 50px; height: 50px; z-index: 9999;" />');
    autoButton.on('change', toggleAuto);
    $('body').append(autoButton);
    window.Game.reportError = function() {};
}

var autoSelectParty = function() {
    function log() {
        console.__proto__.log.apply(console, arguments);
    }

    var intervalId = setInterval(function () {
        var select = $('.prt-deck-select:visible');
        var toMyId = {
            1: 0,
            2: 1,
            3: 3,
            4: 2,
            5: 5,
            6: 4,
        };
        if (select.length > 0) {
            select.flexslider(toMyId[parseInt($('[class*=icon-supporter-type].selected').not('.unselected').data('type'))]);
            clearInterval(intervalId);
        }
    }, 100);
    window.Game.reportError = function() {};
}

function attachJs(func) {
    var str = "!("+func+")();";

    var s = document.createElement('script');
    s.type = 'text/javascript';
    s.innerHTML = str;
    document.documentElement.appendChild(s);
}

if (location.href.match("sp.pf.mbga.jp")) {
    attachJs(f);
    document.getElementsByTagName('html')[0].style.zoom = "80%";
}

if (location.href.match(/gbf.game.mbga.jp.*casino\/game\/poker\//)) {
    setTimeout(function () {
        attachJs(casino);
    }, 1000);
}

if (location.href.match(/gbf.game.mbga.jp.*raid/)) {
    setTimeout(function () {
        attachJs(mainBattle);
    }, 2000);
}

if (location.href.match(/gbf.game.mbga.jp/)) {
    setTimeout(function () {
        attachJs(autoSelectParty);
    }, 1000);
}

// デマ対策
// if (location.href.match("gbf.game.mbga.jp")) {
//   var s = document.createElement('style');
//   s.innerText = '.prt-start-direction, #opaque-mask { display: none !important; }';
//   document.documentElement.appendChild(s);
// }
