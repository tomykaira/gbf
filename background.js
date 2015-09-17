var userAgent	= "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25";
var version		= "1.8";
var manifest	= chrome.runtime.getManifest();
/* *******************************************************************
 * モバゲー
 * ******************************************************************* */
chrome.webRequest.onBeforeSendHeaders.addListener(
	  function(info) {
		    var $len = info.requestHeaders.length;
		    for(var $i = 0; $i < $len ; $i++){
			      if(info.requestHeaders[$i].name === 'User-Agent'){
				        info.requestHeaders[$i].value = userAgent;
				        break;
			      }
		    }
		    return {requestHeaders: info.requestHeaders};
	  },
	  //filters
	  {
		    urls: [
			      "*://sp.pf.mbga.jp/*",
		    ]
	  },
	  //extraInfoSpec
	  ["blocking", "requestHeaders"]
);

// グランブルー
chrome.webRequest.onCompleted.addListener(
	  function(details) {
		    var $len = info.requestHeaders.length;
		    for(var $i = 0; $i < $len ; $i++){
			      if(info.requestHeaders[$i].name === 'User-Agent'){
				        info.requestHeaders[$i].value = userAgent;
				        break;
			      }
		    }
		    return {requestHeaders: info.requestHeaders};
	  },
	  //filters
	  {
		    urls: [
			      "*://gbf.game.mbga.jp/*/normal_attack_result.json",
		    ]
	  }
);

chrome.runtime.onConnect.addListener(function(port) {
    switch (port.name) {
    case 'gb_battle':

        break;
    }
    console.assert(port.name == "knockknock");
    port.onMessage.addListener(function(msg) {
        if (msg.joke == "Knock knock")
            port.postMessage({question: "Who's there?"});
        else if (msg.answer == "Madame")
            port.postMessage({question: "Madame who?"});
        else if (msg.answer == "Madame... Bovary")
            port.postMessage({question: "I don't get it."});
    });
});

// function installCompleteListener() {
//     chrome.webRequest.onCompleted.addListener(
// 	      function (details) {
// 		        var $len = info.requestHeaders.length;
// 		        for(var $i = 0; $i < $len ; $i++){
// 			          if(info.requestHeaders[$i].name === 'User-Agent'){
// 				            info.requestHeaders[$i].value = userAgent;
// 				            break;
// 			          }
// 		        }
// 		        return {requestHeaders: info.requestHeaders};
// 	      }
//     );
// }

// chrome.extension.onMessage.addListener(function (request, sender, sendResponse) {
//     switch (request.type) {
//     case 'casino-start':
//         installCompleteListener()
//         break;
//     }
// })
