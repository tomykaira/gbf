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

var bahaAttackHelp = function() {
    function log() {
        console.__proto__.log.apply(console, arguments);
    }

    setInterval(function() {
        var e;
        e = $('img[src*="btn_call_1.png"]:visible');
        if (e.length > 0) {
            e.trigger('click');
            return;
        }
        e = $('.ev-btn-rescue:visible');
        if (e.length > 0) {
            e.trigger('click');
            return;
        }
        e = $('a:contains("モンスター一覧"):visible:first');
        if (e.length > 0) {
            location.href = $('a:contains("モンスター一覧"):visible:first').prop('href');
            return;
        }
        e = $('.jsbtn.btnMain.attack:visible');
        if (e.length > 0 && localStorage.attacked.indexOf(location.href.toString()) == -1) {
            e.trigger('click');
            localStorage.attacked += ',' + location.href.toString();
            return;
        }
    }, 1000);
}

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
            return location.reload();
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
        var elm;
        if (!isAuto) {
            return;
        }
        if ((elm = $('.btn-result:visible')).length > 0) {
            elm.trigger('tap');
            return setTimeout(selectAction, 2000);
        }
        if ((elm = $('.btn-usual-ok:visible,.btn-usual-close:visible')).length > 0
            && elm.parents('.pop-result-use-potion').length == 0
            && elm.parents('.pop-friend-request').length == 0) {
            elm.trigger('tap');
            return next();
        }
        if ($('.btn-attack-start.display-on').length == 0) {
            setTimeout(selectAction, 100);
            return;
        }
        var done = false;
        // 複数回バトルの最後以外は攻撃のみ
        var battleNums = $('.prt-battle-num .txt-info-num').children()
        if (battleNums.length > 0 && battleNums[0].className != battleNums[battleNums.length - 1].className) {
            $('.btn-attack-start').trigger('tap');
            setTimeout(next, 100);
            return;
        }
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
            } else if (['守りは任せるっす！', 'グロースラウド'].indexOf(name) >= 0) {
                // ゲージ消費系は避ける
            } else if ('フェイント' == name) {
                if (specialPercent >= 10) {
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
            } else if (type.indexOf('dodge') >= 0 || type.indexOf('damage_cut') >= 0 || ['ライトウェイトII'].indexOf(name) >= 0) {
                var params = stage.gGameStatus.boss.param;
                if (parseInt(params[params.length - 1].recast) <= 1) {
                    $this.trigger('tap');
                    done = true;
                    return false;
                }
            } else if ('ディレイ'.indexOf(name) >= 0) {
                var params = stage.gGameStatus.boss.param;
                if (parseInt(params[params.length - 1].recast) < parseInt(params[params.length - 1].recastmax)) {
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
        hasPotion = parseInt(stage.gGameStatus.temporary.large) > 0;
        if (hasPotion) {
            var deadly = true;
            for (var i = 0; i < 4; i++) {
                deadly = deadly && hpRatio(i) > 0 && hpRatio(i) < 50;
            }
            if ((hpRatio(0) > 0 && hpRatio(0) < 25) || deadly) {
                log("using potion");
                $('.btn-temporary').trigger('tap');
                wait('.item-large img', function(e) {
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
        var assist = $('.btn-assist:visible');
        if (assist.length > 0 && !assist.hasClass('disable') && (!hasPotion || stage.gGameStatus.turn >= 10 || stage.gGameStatus.lose)) {
            $('.btn-assist:visible').trigger('tap');
            wait('.pop-start-assist .btn-usual-text', function(e) {
                e.trigger('tap');
                wait('.btn-usual-ok:visible', function(e) {
                    e.trigger('tap');
                    next();
                })
            });
            return;
        }
        $('.btn-attack-start').trigger('tap');
        setTimeout(next, 100);
    }

    function next() {
        setTimeout(selectAction, 10);
    }

    var prevHpSum = - 1;
    var hpRecorded = 0;
    var restartIv = setInterval(function () {
        if (stage && stage.gGameStatus && stage.gGameStatus.boss && !stage.gGameStatus.boss.all_dead) {
            var sum = 0;
            stage.gGameStatus.boss.param.forEach(function (elm) {
                sum += parseInt(elm.hp);
            });
            if (sum == 0) {
                next();
                return;
            }
            if (prevHpSum != sum) {
                prevHpSum = sum;
                hpRecorded = new Date().getTime();
                return;
            }
            if ((new Date().getTime() - hpRecorded) >= 30 * 1000) {
                log("Enemy hp does not change", sum, hpRecorded);
                window.localStorage.restartAuto = isAuto ? 'true' : 'false';
                location.reload();
                clearInterval(restartIv);
            }
        }
    }, 500);

    var initIv = setInterval(function() {
        var autoStart = location.hash.indexOf('#raid_multi') == 0 || window.localStorage.restartAuto == 'true';
        window.localStorage.restartAuto = 'false';
        var askHelp = memberCount > 1;
        var memberCount;
        try {
            memberCount = parseInt($('.prt-total-human .current.value[class*=num-info]').map(function(){return this.getAttribute('class').match(/\d/)[0]}).toArray().join(''));
            if (isNaN(memberCount) || memberCount == 0)
                return;

            var param = stage.gGameStatus.boss.param[0];
            var bossName = param.name;
            if (('Lv90 アグネア' == bossName && memberCount < 5)
                || ('Lv60 グガランナ' == bossName && memberCount < 2)
                || ('Lv75 エメラルドホーン' == bossName && memberCount < 2)
                || ('Lv60 ジャック・オー・ランタン' == bossName && memberCount < 2)
                || ('Lv75 パンプキンビースト' == bossName && memberCount < 2)) {
                log('This enemy is strong. Wait other members.');
                askHelp = true;
                setTimeout(function () {location.reload();}, 30 * 1000);
                autoStart = false;
            }
        } catch(e) {
            log(e);
            return;
        }

        log('autostart ' + autoStart);
        window.localStorage.autoMulti = 'false';
        if (askHelp) {
            $('.pop-start-assist .btn-usual-text').trigger('tap'); // 救援依頼。あれば
        }
        if (memberCount == 1 && $('.btn-chat').length > 0) {
            $($('.btn-chat')[0]).trigger('tap');
            wait('.lis-stamp[chatid="2"]',function(e) {
                e.trigger('tap');
                if (autoStart) {
                    setAuto();
                }
            });
        } else if (autoStart) {
            setAuto();
        }

        clearInterval(initIv);
    }, 100);
    var autoButton = window.$('<input type="checkbox" style="position: fixed; top: 10px; left: 10px; width: 50px; height: 50px; z-index: 9999;" />');
    autoButton.on('change', toggleAuto);
    $('body').append(autoButton);
    window.Game.reportError = function() {};
}

var selectMultiBattle = function() {
    if (window.localStorage.autoMulti !== 'true')
        return;
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
                return selectAction();
            } else {
                return location.reload();
            }
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

    var interestedEnemies = ['アグニス討伐戦', 'Lv40 ゲイザー', 'Lv30 スカジ', 'Lv30 ヒドラ', 'Lv40 パンプキンヘッド', 'Lv30 闘虫禍草'];
    setTimeout(function() {
        try {
            var myBP = parseInt($('.prt-user-bp-value').prop('title'));
            if (isNaN(myBP)) {
                log("my BP is NaN");
                return location.reload();
            }
            var selected = false;
            $('.prt-raid-info').each(function() {
                var $this = $(this);
                var name = $this.find('.txt-raid-name').text();
                var required = parseInt($this.find('.prt-use-ap').data('ap'));
                if (interestedEnemies.indexOf(name) != -1 && required <= myBP) {
                    $this.trigger('tap');
                    selected = true;
                    return false;
                }
            });
            if (!selected)
                return location.reload();
        } catch (e) {
            log("Exception", e);
        }
    }, 5000); // wait until page is fully rendered
}

var basicAutoPlay = function() {
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
                return selectAction();
            } else {
                return location.reload();
            }
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

    var iid1 = setInterval(function () {
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

            var go = $('.pop-deck .btn-usual-ok');
            if (localStorage.autoMulti === 'true' && go.length > 0) {
                go.trigger('tap');
            }
        }
    }, 100);

    var iid2 = setInterval(function () {
        var go = $('.btn-supporter:visible');
        if (localStorage.autoMulti === 'true' && go.length > 0) {
            clearInterval(iid2);
            // すぐやると属性の石がえらばれない場合がある
            setTimeout(function () {
                $(go[0]).trigger('tap');
            }, 500);
        }
    }, 100);

    var iid3 = setInterval(function () {
        var button = $('.btn-command-forward:visible:not(.disable)');
        if (button.length > 0) {
            setTimeout(function() {button.trigger('tap');}, 100);
        }
        button = $('[data-buton-name=" イベントTOPへ"]:visible:not(.disable)');
        if (button.length > 0) {
            setTimeout(function() {button.trigger('tap');}, 1000);
        }
        button = $('.btn-control[data-location-href="quest"]:visible:not(.disable)');
        if (button.length > 0) {
            setTimeout(function() {button.trigger('tap');}, 1000);
        }
    }, 500);

    var cooldown = new Date().getTime();
    var iid4 = setInterval(function() {
        var button = $('.cnt-quest-scene > .btn-skip');
        if (button.length > 0 && cooldown < new Date().getTime()) {
            button.trigger('tap');
            cooldown = new Date().getTime() + 10000;
            setTimeout(function() {
                var elm;
                if (location.href.indexOf('quest/scene') > 0 && (elm = $('.btn-usual-ok:visible,.btn-usual-close:visible')).length > 0 && elm.parents('.pop-result-use-potion').length == 0) {
                    elm.trigger('tap');
                }
            }, 200);
        }
    }, 500);
    setInterval(function() {
        if (location.href.match(/gbf.game.mbga.jp.*#event\/(treasureraid|teamraid)\d\d\d\/gacha\/result/) && $('.btn-reset').length == 0) {
            $('.txt-available-times10').trigger('tap');
        }
    }, 500);

    setInterval(function () {
        var button = $('.btn-usual-join:visible:not(.disable)');
        if (location.href.match(/gbf.game.mbga.jp.*#coopraid\/offer/) && button.length > 0) {
            button.trigger('tap');
        }
    }, 100);

    setInterval(function () {
        var button = $('.btn-usual-join:visible:not(.disable)');
        if (location.href.match(/gbf.game.mbga.jp.*#coopraid\/offer/) && button.length > 0) {
            button.trigger('tap');
        }
    }, 100);

    setInterval(function () {
        if (localStorage.autoCoop == 'true') {
            var button;
            button = $('[data-buton-name="ルームへ"]:visible:not(.disable)');
            if (button.length > 0) {
                button.trigger('tap');
            }
            button = $('.pop-friend-request.pop-show .btn-usual-cancel:visible:not(.disable)');
            if (button.length > 0) {
                button.trigger('tap');
            }
            button = $('.btn-execute-ready:visible:not(.disable)');
            if (button.length > 0) {
                button.trigger('tap');
            }
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

if (location.href.match('sp.pf.mbga.jp/12007160')) {
    setTimeout(function () {
        attachJs(bahaAttackHelp);
    }, 1000);
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

if (location.href.match(/gbf.game.mbga.jp.*#quest\/assist/)) {
    setTimeout(function () {
        attachJs(selectMultiBattle);
    }, 2000);
}

if (location.href.match(/gbf.game.mbga.jp/)) {
    setTimeout(function () {
        attachJs(basicAutoPlay);
    }, 1000);
}

// デマ対策
// if (location.href.match("gbf.game.mbga.jp")) {
//   var s = document.createElement('style');
//   s.innerText = '.prt-start-direction, #opaque-mask { display: none !important; }';
//   document.documentElement.appendChild(s);
// }
