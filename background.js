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
			      "*://*.mbga.jp/*",
		    ]
	  },
	  //extraInfoSpec
	  ["blocking", "requestHeaders"]
);
