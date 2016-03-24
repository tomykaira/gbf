var userAgent	= 'Mozilla/5.0 (iPad; CPU OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53';
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
