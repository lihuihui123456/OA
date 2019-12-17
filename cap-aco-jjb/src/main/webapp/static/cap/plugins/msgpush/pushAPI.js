/**
 * @param userInfor 用户信息，包括
 * 			username 用户名 
 * 			domain 登录域名 
 * 			resource 用户的资源名 
 * 			resource 用户的资源名 
 * 			pass 用户密码
 * @param serverAddr openfire服务器ip地址，必须包括端口号
 * @param connectionFuns 消息推送的连接函数，包括
 * 				onDisconnect : 当连接断开时，回调的函数
 * 				disConnecting : 当连接断开中，回调的函数
 * 				connecting : 当连接建立中，回调的函数
 * 				onConnect : 当连接建立后，回调的函数
 * @param callbackFunctions 接口回调函数，包括
 * 				showMessage: 即时通讯消息展示
 * 				showNotice： 推送消息展示
 * 				queryResult： 消息推送，消息请求的回调函数，包括
 * 					getunread: 获取所有未读信息，回调的函数
 * 					ignoreall: 忽略所有未读信息，回调的函数
 * 					getnoticelist : 获取所有信息，回调的函数
 * 					setRead : 设置信息已读，回调的函数
 * 					getRoster: 从openfire中读取Roster时的回调函数。
 * 					getPresence： 从openfire获取在线信息的回调函数。
 */
//function Notice(username,domain,resource,pass, ip,showMessage,showNotice,queryResult){
function Notice(userInfor,serverAddr,connectionFuns,callbackFuntions,mode){
	this._user = userInfor.username;
	this._domain = userInfor.domain;
	this._resource = userInfor.resource;
	this._pass = userInfor.pass;
	this._ip = serverAddr;
	this._connFuns = connectionFuns;
	this._showMessage =callbackFuntions.showMessage;
	this._showNotice = callbackFuntions.showNotice;
	this._queryResult = callbackFuntions.queryResult;
	var self = this;
	
	var BOSH_SERVICE = '';
	var connection = null;
	var userJID = '';
	var connState= '';
	var debug=mode;
	/**
	 * 启动openfire连接
	 */
	this._start = function _start(){

		//判断浏览器是否支持websocket，不支持则使用long polling	
		//TODO 验证所有的浏览器
		if(typeof(window.WebSocket)=="function"||window.WebSocket){
			BOSH_SERVICE = 'ws://'+self._ip+'/ws/server';
		}else{
			BOSH_SERVICE = 'http://'+self._ip+'/http-bind/';
		}
		userJID = self._user+'@'+self._domain+'/'+self._resource;
		connection = new Strophe.Connection(BOSH_SERVICE);
		connection.connect(userJID,self._pass,onConnect);
	}
	
	/**
	 * 当有连接时调用此函数
	 */
	var onConnect = function onConnect(status){
		if (status == Strophe.Status.CONNECTING) {
			if(debug){
				layerAlert("Strophe is connecting.");
			}
		} else if (status == Strophe.Status.CONNFAIL) {
			connState = 'off';
			if(debug){
				layerAlert("Strophe failed to connect.");
			}
			//$('#connect').get(0).value = 'connect';
		} else if (status == Strophe.Status.DISCONNECTING) {
			connState = 'off';
			if(debug){
				layerAlert("Strophe is disconnecting.");
			}
			self._connFuns.disConnecting();
		} else if (status == Strophe.Status.DISCONNECTED) {
			connState = 'off';
			if(debug){
				layerAlert("Strophe is disconnected.");
			}
			self._connFuns.onDisconnect();
			//$('#connect').get(0).value = 'connect';
		} else if (status == Strophe.Status.CONNECTED) {
			connState = 'on';
			if(debug){
				layerAlert("Strophe is connected.");
			}
			self._connFuns.onConnect();
		//创建了连接，则添加处理消息的接口和发送用户上线通知
		connection.addHandler(onMessage, null, 'message', null, null,  null); 
		connection.send($pres().tree());
		
		//add the iq handler
		connection.addHandler(onIQ, null, 'iq', null, null,  null);
		var getRoster = $iq({ type: 'get'}).c('query', {xmlns: 'jabber:iq:roster'});
		connection.send(getRoster.tree());
		
		//add the presence handler
		connection.addHandler(onPresence, null, 'presence', null, null,  null);
		}
	}
	/**
	 * disconnect the connection
	 */
	this._disconnect = function _disconnect(){
		connection.disconnect()
	}
	
	/**
	 * get all the notice of the current user
	 */
	this._getNoticesList = function _getNoticesList(pageNum,pageSize){
		var query = $msg({from: userJID, type: 'chat'}).c('notice','',null).c('operation',{action:'getnoticelist'},null).c('para','',pageNum).c('para','',pageSize);
		connection.send(query.tree());
	}
	/**
	 * get all unread notices
	 */
	this._getUnreadNotice = function getUnreadNotice(){
		var query = $msg({from: userJID, type: 'chat'}).c('notice','',null).c('operation',{action:'getunread'},'');
		connection.send(query.tree());
	}
	/**
	 * set the notice read
	 */	
	this._setRead = function _setRead(syscode,sysnoticeid){
		if(connState=='on'){
			var query = $msg({from: userJID, type: 'chat'}).c('notice','',null).c('operation',{action:'setread'},null ).c('para','',syscode).c('para','',sysnoticeid);
			connection.send(query.tree());
		}
	}
	
	/**
	 * ignore all the unread notice
	 */
	this._ignoreAll = function _ignoreAll(){
		var query = $msg({from: userJID, type: 'chat'}).c('notice','',null).c('operation',{action:'ignoreall'},'');
		connection.send(query.tree());
	}
	
	/**
	 * get the text in a element by element's name
	 * @param rootEle: father element
	 * @param eleName: the element's name
	 * @return the text or null
	 */
	this._getTextInElement = function getTextInElement(rootEle, eleName){
		var temp = rootEle.getElementsByTagName(eleName);
		if(temp!=null&&temp.length==1){
			return self._getText(temp[0]);
		}
		return null;
	}
	/*
	 * 发送用户在线请求
	 * @userStatus： 1：offline 2 在线
	 */
	this._sendPresence = function _sendPresence(userStatus){
		var msg=null;
		switch(userStatus){
		case 1:
			msg = $pres({ type: 'unavailable'}).c('status',null,'Offline').c('priority',null,0);
			break;
		case 2:
			msg=$pres();
			break;
			default: ;
		}
		if(msg!=null){
			connection.send(msg.tree());
		}
	} 
	/**
	 * send the rename friend request
	 */
	this._renameFreind = function _renameFreind(oldName,newName,group){
		var rename = $iq({ type: 'set',xmlns:null}).c('query', {xmlns: 'jabber:iq:roster'}).c('item',{jid:oldName,name:newName,subscription:'both'},null)
		.c('group',null,group);
		connection.send(rename.tree());
	}
	/**
	 * send the confirm add friend request
	 */
	this._confirmAdd = function _confirmAdd(oldName,newName,group){
		var rename = $iq({ type: 'set',xmlns:null}).c('query', {xmlns: 'jabber:iq:roster'}).c('item',{jid:oldName,name:newName,subscription:'from'},null)
		.c('group',null,group);
		connection.send(rename.tree());
	}
	/**
	 * send the get friends request
	 */
	this._getRoster = function _getRoster(){
		var getRoster = $iq({ type: 'get'}).c('query', {xmlns: 'jabber:iq:roster'});
		connection.send(getRoster.tree());
	}
	
	/**
	 * get the text of element
	 */
	this._getText = function getText( element ){
			var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
			var isFirefox = userAgent.indexOf("Firefox") > -1;
			var isChrome = userAgent.indexOf("Chrome") > -1;
			if(isFirefox||isChrome){
				if(element!=null){
					return element.textContent;
				}else{
					return null;
				}
			}else{
				//check the ie version 
				//IE 8 text IE 11 textContent
				if(navigator.appVersion.match(/11./i)=="11."){
					return element.textContent;
				}else{
					if(element!=null){
						return element.text;
					}else{
						return null;
					}
				}
			}
	}
	
	/**
	 * process the notice 
	 */
	var processNotice = function processNotice(notice){
			
			/*var noticeID = notice.getElementsByTagName("noticeID")[0];
			var noticeid =self._getText(noticeID); */
		
			var sysCodeEle = notice.getElementsByTagName("systemcode")[0];
			var sysCode =self._getText(sysCodeEle);//get system code
			
			var sysNoticeIdEle = notice.getElementsByTagName("systemnoticeID")[0];
			var sysNoticeId = self._getText(sysNoticeIdEle);//get system notice id
			
			var realSenderEle = notice.getElementsByTagName("noticefrom")[0];
			var realSender = self._getText(realSenderEle);//get notice from
			
			var realReceiverEle = notice.getElementsByTagName("noticeto")[0];
			var realReceiver = self._getText(realReceiverEle);//get notice to
			
			var priorityEle = notice.getElementsByTagName("priority")[0];
			var priority = self._getText(priorityEle);//get priority
			
			var noticeContentEle = notice.getElementsByTagName("content")[0];
			var content = self._getText(noticeContentEle);//get notice content

			var json = eval('('+content+')');//convert the content to JSON
			self._showNotice(json,sysCode,sysNoticeId,realSender,realReceiver, priority);
			//log('ECHOBOT: I receive a notice ' + from + ': ' +  'subject:'+json.subject+'    '+'content:'+noticeContent);
	}
	/**处理请求返回的结果，按照action的不同名字，调用不同的处理方法
	 * @param result: result of the query
	 */
	var processQueryResult = function processQueryResult(result){
		var action = result.getElementsByTagName('action');
		if(action!=null&&action.length==1){
			switch(self._getText(action[0])){
			case 'setread':
				//TODO add process the set read result
				var actionresultEle = result.getElementsByTagName('actionresult');
				if(actionresultEle!=null&&actionresultEle.length==1){
					var failtext = self._getText(actionresultEle[0]);
					var failReason = '';
					var reasonEle = result.getElementsByTagName('reason');
					if(reasonEle!=null&&reasonEle.length==1){
						failReason = self._getText(reasonEle[0]);
					}
					var sysCode = self._getTextInElement(result,'systemcode');
					var noticeId = self._getTextInElement(result,'noticeID');
					if(typeof (self._queryResult.setRead)!='undefined'){
						self._queryResult.setRead(sysCode,noticeId,failtext,failReason);
					}
				}				
				break;
			case 'getunread': 
				var notices = result.getElementsByTagName('notice');
				for(var i=0;i<notices.length;i++){
					var noticeContentEle = notices[i].getElementsByTagName("content")[0];
					var sysCodeEle = notices[i].getElementsByTagName("systemcode")[0];
					var sysCode = self._getText(sysCodeEle);
					var sysNoticeIdEle = notices[i].getElementsByTagName("systemnoticeID")[0];
					var sysNoticeId = self._getText(sysNoticeIdEle);
					var content = self._getText(noticeContentEle);
					var json = eval('('+content+')');
					
					self._queryResult.getunread(json,sysCode,sysNoticeId)
				}
				break;
			case 'ignoreall':
				var actionresultEle = result.getElementsByTagName('actionresult');
				if(actionresultEle!=null&&actionresultEle.length==1){
					var failtext = self._getText(actionresultEle[0]);
					var failReason = '';
					var reasonEle = result.getElementsByTagName('reason');
					if(reasonEle!=null&&reasonEle.length==1){
						failReason = self._getText(reasonEle[0]);
					}
					if(typeof (self._queryResult.ignoreall)!='undefined'){
						self._queryResult.ignoreall(failtext,failReason);
					}
				}
				break;
			case 'getnoticelist':
				//var json = xmlToJson(result);
				var jsonString;
				var textContent = self._getText(result);
				var jsonArray = textContent.split('###');
				var xmlString='<result>';
				for(var i=1; i<jsonArray.length;i=i+2){
					xmlString= xmlString + jsonArray[i];
				}
				xmlString= xmlString + '</result>';
				
				var xmldoc = loadXML(xmlString);
				var josnobj = xmlToJson(xmldoc);
				
				var jsonString = '[';
				if(josnobj.result.notice!=null){
					if(josnobj.result.notice.length==null){
						var noticeItem = josnobj.result.notice;
						jsonString = jsonString + '{'+ '"systemcode":' +'"'+noticeItem.systemcode+'"'+','+
						'"systemnoticeID":' +'"'+noticeItem.systemnoticeID+'"'+','+
						'"noticefrom":' +'"'+noticeItem.noticefrom+'"'+','+
						'"content":' + noticeItem.content +','+
						'"sendtime":' +'"'+noticeItem.sendtime+'"'+','+
						'"read":' +'"'+noticeItem.read+'"'+
						'}'+',';
					}else{
						for(var i=0; i<josnobj.result.notice.length;i++){
							var noticeItem = josnobj.result.notice[i];
							jsonString = jsonString + '{'+ '"systemcode":' +'"'+noticeItem.systemcode+'"'+','+
							'"systemnoticeID":' +'"'+noticeItem.systemnoticeID+'"'+','+
							'"noticefrom":' +'"'+noticeItem.noticefrom+'"'+','+
							'"content":' + noticeItem.content +','+
							'"sendtime":' +'"'+noticeItem.sendtime+'"'+','+
							'"read":' +'"'+noticeItem.read+'"'+
							'}'+',';
						}
					}
				}
				jsonString = jsonString.substring(0,jsonString.length-1);
				jsonString = jsonString + ']';
				
				//var bsJSONString = '{'+'"total": 80'+','+'"rows":'+jsonString+'}';
				self._queryResult.getnoticelist(jsonString);
				break;
				default: ;
			}
			
		}
	}
	
	//将 IXMLDOMDocument2 转换为JSON，参数为IXMLDOMDocument2对象　　  
	var xmlToJson =  function xmlToJson(obj) {  
	    if (this == null) return null;  
	    var retObj = new Object;  
	    buildObjectNode(retObj,  
	    /*jQuery*/  
	    obj);  
	    return retObj;  
	    function buildObjectNode(cycleOBJ,  
	    /*Element*/  
	    elNode) {  
	        /*NamedNodeMap*/  
	        var nodeAttr = elNode.attributes;  
	        if (nodeAttr != null) {  
	            if (nodeAttr.length && cycleOBJ == null) cycleOBJ = new Object;  
	            for (var i = 0; i < nodeAttr.length; i++) {  
	                cycleOBJ[nodeAttr[i].name] = nodeAttr[i].value;  
	            }  
	        }  
	        var nodeText = "text";  
	        if (elNode.text == null) nodeText = "textContent";  
	        /*NodeList*/  
	        var nodeChilds = elNode.childNodes;  
	        if (nodeChilds != null) {  
	            if (nodeChilds.length && cycleOBJ == null) cycleOBJ = new Object;  
	            for (var i = 0; i < nodeChilds.length; i++) {  
	                if (nodeChilds[i].tagName != null) {  
	                    if (nodeChilds[i].childNodes[0] != null && nodeChilds[i].childNodes.length <= 1 && (nodeChilds[i].childNodes[0].nodeType == 3 || nodeChilds[i].childNodes[0].nodeType == 4)) {  
	                        if (cycleOBJ[nodeChilds[i].tagName] == null) {  
	                            cycleOBJ[nodeChilds[i].tagName] = nodeChilds[i][nodeText];  
	                        } else {  
	                            if (typeof(cycleOBJ[nodeChilds[i].tagName]) == "object" && cycleOBJ[nodeChilds[i].tagName].length) {  
	                                cycleOBJ[nodeChilds[i].tagName][cycleOBJ[nodeChilds[i].tagName].length] = nodeChilds[i][nodeText];  
	                            } else {  
	                                cycleOBJ[nodeChilds[i].tagName] = [cycleOBJ[nodeChilds[i].tagName]];  
	                                cycleOBJ[nodeChilds[i].tagName][1] = nodeChilds[i][nodeText];  
	                            }  
	                        }  
	                    } else {  
	                        if (nodeChilds[i].childNodes.length) {  
	                            if (cycleOBJ[nodeChilds[i].tagName] == null) {  
	                                cycleOBJ[nodeChilds[i].tagName] = new Object;  
	                                buildObjectNode(cycleOBJ[nodeChilds[i].tagName], nodeChilds[i]);  
	                            } else {  
	                                if (cycleOBJ[nodeChilds[i].tagName].length) {  
	                                    cycleOBJ[nodeChilds[i].tagName][cycleOBJ[nodeChilds[i].tagName].length] = new Object;  
	                                    buildObjectNode(cycleOBJ[nodeChilds[i].tagName][cycleOBJ[nodeChilds[i].tagName].length - 1], nodeChilds[i]);  
	                                } else {  
	                                    cycleOBJ[nodeChilds[i].tagName] = [cycleOBJ[nodeChilds[i].tagName]];  
	                                    cycleOBJ[nodeChilds[i].tagName][1] = new Object;  
	                                    buildObjectNode(cycleOBJ[nodeChilds[i].tagName][1], nodeChilds[i]);  
	                                }  
	                            }  
	                        } else {  
	                            cycleOBJ[nodeChilds[i].tagName] = nodeChilds[i][nodeText];  
	                        }  
	                    }  
	                }  
	            }  
	        }  
	    }  
	}
	/*
	 * load the XML 
	 * @para xmlString xml string
	 * */
	var loadXML = function loadXML(xmlString){
        var xmlDoc=null;
        //判断浏览器的类型
        //支持IE浏览器 
        if(!window.DOMParser && window.ActiveXObject){   //window.DOMParser 判断是否是非ie浏览器
            var xmlDomVersions = ['MSXML.2.DOMDocument.6.0','MSXML.2.DOMDocument.3.0','Microsoft.XMLDOM'];
            for(var i=0;i<xmlDomVersions.length;i++){
                try{
                    xmlDoc = new ActiveXObject(xmlDomVersions[i]);
                    xmlDoc.async = false;
                    xmlDoc.loadXML(xmlString); //loadXML方法载入xml字符串
                    break;
                }catch(e){
                }
            }
        }
        //支持Mozilla浏览器
        else if(window.DOMParser && document.implementation && document.implementation.createDocument){
            try{
                /* DOMParser 对象解析 XML 文本并返回一个 XML Document 对象。
                 * 要使用 DOMParser，使用不带参数的构造函数来实例化它，然后调用其 parseFromString() 方法
                 * parseFromString(text, contentType) 参数text:要解析的 XML 标记 参数contentType文本的内容类型
                 * 可能是 "text/xml" 、"application/xml" 或 "application/xhtml+xml" 中的一个。注意，不支持 "text/html"。
                 */
                domParser = new  DOMParser();
                xmlDoc = domParser.parseFromString(xmlString, 'text/xml');
            }catch(e){
            }
        }
        else{
            return null;
        }
        return xmlDoc;
    }
	/*
	 * 当信息为presence是调用此函数
	 */
	var onPresence = function onPresence(presence){
		if(typeof (self._queryResult.getPresence)!='undefined'){
			self._queryResult.getPresence(presence);
		}
		return true;
	}
	
	/*
	 * 当有iq信息是设置此回调函数
	 */
	var onIQ = function onIQ(iq){
		var type = iq.getAttribute('type');
		//TODO extend to deal more function
		if(type == 'result'){
			var query = iq.getElementsByTagName('query');
			if(query!=null &&query.length>0){
				var namespace = query[0].getAttribute('xmlns');
				switch(namespace){
				case 'jabber:iq:roster':
					if(typeof (self._queryResult.getRoster)!='undefined'){
						self._queryResult.getRoster(iq);
					}
					break;
				case '':
					break;
				default:;
						
				
				}
			}
//			if(true){
//				
//			}
//			var items = iq.getAttribute('item');
//			//format the data
//			if(self._queryResult.getRoster){
//				self._queryResult.getRoster(iq);
//			}
		}else if(type == 'set'){
			var query = iq.getElementsByTagName('query');
			if(query!=null &&query.length>0){
				var namespace = query[0].getAttribute('xmlns');
				switch(namespace){
				case 'jabber:iq:roster':
/*					if(typeof (self._queryResult.getRoster)!='undefined'){
						self._queryResult.getRosterRequ(iq);
					}*/
					break;
				case '':
					break;
				default:;
						
				
				}
			}
			
		}
		return true;
	}
	/*
	 * send the message
	 */
	this._sendIMMsg = function _sendIMMsg(msg){
		var query = $msg({to: msg.to, type: msg.type}).c('body','',msg.content).c('active',{
			xmlns:'http://jabber.org/protocol/chatstates'
		},null);
		connection.send(query.tree());
		//alert(connection.getUniqueId('abd'));
	}
	/*
	 * send the delete freind request
	 */
	this._sendDelFreind = function _sendDelFreind(freindName){
		var delFreind = $iq({ type: 'set',xmlns:null}).c('query', {xmlns: 'jabber:iq:roster'}).c('item',{jid:freindName,subscription:'remove'},null);
		connection.send(delFreind.tree());
	}
	
	/**
	 * 当有消息是调用此函数
	 */
	var onMessage = function onMessage(msg) {
		var to = msg.getAttribute('to');
		var from = msg.getAttribute('from');
		var type = msg.getAttribute('type');

		if (type == "chat") {
			var queryResults = msg.getElementsByTagName('result');
			//check the result element
			if(queryResults!=null && queryResults[0]!=null){
				processQueryResult(queryResults[0]);
			}else {
				//check the notice element 
				var notices = msg.getElementsByTagName('notice');
				if(notices!=null && notices[0]!=null){
					processNotice(notices[0]);
				}else{
					//the message is a normal im-message
					if(typeof (self._showMessage)!='undefined'){
						//TODO matain the talk message
						self._showMessage(msg);
					}
				}
			}
		}
		// we must return true to keep the handler alive.  
		// returning false would remove it after it finishes.
		return true;
	}
	
//	this._setGetRosterCallBack = function(getRoster){
//		self._queryResult.getRoster=getRoster;
//	}
}