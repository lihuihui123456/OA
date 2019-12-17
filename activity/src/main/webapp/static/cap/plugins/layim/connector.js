
//global java script variable for instantmessage
var intantMsgListId = 'capAcoWebIM';
var globalConnection =null;



$(document).ready(function () {
	try{
		//find the global Openfire connection
		//if there no such connection, then create a new connection
		if(!globalMsgPushConnection){
			alert('excute the im, create a new connection!');
			var debug = false;
			var userInforIM = {
					username : globalLoginName,
					domain : globalMsgPushUserDomain,
					resource : globalMsgPushUserResource,
					pass : '1234'
			};
			var serverAddrIM = globalMsgPushServerAddr;
			
			var callbackFunctionsIM = {
					showMessage : showMessage,
					showNotice : showNotice,
					queryResult : {
						getunread: showNotice,
						ignoreall: myIgnoreAll,
						getnoticelist : myGetNoticeList,
						setRead : mySetRead,
						getRoster : myGetRoster
					}
			};
			
			var connectionFunsIM = {
					disConnecting : myDisConnecting,
					onDisconnect : myOnDisconnect,
					connecting : myConnecting,
					onConnect : myOnConnect
			};
			notice = new Notice(userInforIM,serverAddrIM,connectionFunsIM,callbackFunctionsIM,debugIM);
			notice._start();//启动连接
			globalConnection = notice;
		}else{
			globalConnection = globalMsgPushConnection;
		}
	}catch(err){
		//alert(123);
	}
	
});

function IMRenameFreind(){
	if($('#im_freind_rename').find('#im_rename_form').validationEngine('validate')){
		var oldName = $('#orignal_name').val()+'@'+globalMsgPushUserDomain;
		var newName = $('#new_name').val();
		var group = $('#im_rename_group').val();
		globalConnection._renameFreind(oldName,newName,group);
		//refresh the roster list
		globalConnection._getRoster();
		$('#im_freind_rename').modal('hide');
	}else{
		
	}
	
}

function IMRenameGroup(){
	if($('#im_group_rename').find('#im_rename_form').validationEngine('validate')){
		var modal = $('#im_group_rename');
		var oldName = modal.find('#orignal_name').val();
		var newName = modal.find('#new_name').val();
		
		//find all the friends under the old group name
		var myf = layIMobj.node.list.eq(0);
		var friendName;
		var friendNick;
		var group = $(myf).find('.xxim_parentnode[data-id="'+oldName+'"]');
		var friendsList = $(group).find('.xxim_childnode');
		for(var i=0;i<friendsList.length;i++){
			friendName = $(friendsList[i]).attr('data-id');
			friendNick = $(friendsList[i]).find('.xxim_onename').text();
			//send request
			globalConnection._renameFreind(friendName+'@'+globalMsgPushUserDomain,friendNick,newName);
		}
		//refresh the roster list
		globalConnection._getRoster();
		$('#im_group_rename').modal('hide');
	}else{
		
	}
}

connector.confirmAdd=function(oldName,newName,group){
	globalConnection._confirmAdd(oldName,newName,group);
};
/*
 * 删除好友
 */
connector.delFreind=function(freindName){
	globalConnection._sendDelFreind(freindName+'@'+globalMsgPushUserDomain);
	//refresh the roster list
	globalConnection._getRoster();
};

/*
 * 发送消息
 */
connector.sendIMMessage = function(msg){
	globalConnection._sendIMMsg(msg);
};
/*
 * 发送用户在线请求
 * @userStatus： 1：offline 2 在线
 */
connector.sendPresence = function(userStatus){
	globalConnection._sendPresence(userStatus);
};

/*
 * 获取添加联系人请求
 */
/*connector.myGetRosterRequ = function(iq){
	var item = iq.getElementsByTagName('item');
	var from = item.getAttribute('jid').split('@')[0];
	var subscription = item.getAttribute('subscription');
	if(subscription=='from'){
		alert(from);
	}
	
};*/

/*
 * 自定义接收用户在线信息
 */
connector.myGetPresence= function(presence){
	var preFrom = presence.getAttribute('from');
	if(preFrom){
		var type = presence.getAttribute('type')
		switch(type){
		//订阅请求
		case 'subscribe':
			//layerAlert(preFrom.split('@')[0]+'请求添加你为联系人！');
/*			var modal = $('#im_add_freind_request');
			modal.modal('show');
			modal.find('#requ_sender').val(preFrom);
			modal.find('#nick_name').val('');
			modal.find('#freind_group').val('');*/
			//TODO 可以将添加好友的请求缓存起来，以便用户一一处理。
			layIMobj.freindReq.push(preFrom);
			layIMobj.node.addReq.find('.requeNum')[0].innerText=layIMobj.freindReq.length;
			break;
		case 'unavailable':
			layIMobj.setPresence(preFrom.split('@')[0],0);
			break;
		case '':
			layIMobj.setPresence(preFrom.split('@')[0],1);
			break;
		default:
			layIMobj.setPresence(preFrom.split('@')[0],1);
		}
	}else{
		if(!presence.getAttribute('type')){
			//主动状态
			alert(123);
		}
	}
};

connector.showMessage= function(msg){
	//show the im-message
	var msgObj = new Object();
	//set from
	var from = msg.getAttribute('from');
	if(from!=null){
		from = from.split("@")[0];
	}
	msgObj.from = from;
	
	//set the content
	var bodies = msg.getElementsByTagName('body');
	if(bodies!=null&&bodies.length>0){
		var body=bodies[0];
		var bodytext = Strophe.getText(body);
		msgObj.bodytext = bodytext;
		layIMobj.messageRec(msgObj);
		//get thread
		//var thread = msg.getElementsByTagName('thread');
		//var threadText = Strophe.getText(thread[0]);
		//layerAlert(threadText);
	}else{
		msgObj.bodytext = '';
	}
};

connector.myGetRoster=function(iq){
	//调用插件layim里的接口
	var items = iq.getElementsByTagName('item');
	var data=new Array();
	for(var i=0;i<items.length;i++){
		var groupName = _getText(items[i]);
		//归组
		var addPersondone = false;
		for(var j = 0;j<data.length;j++){
			if(data[j].name==groupName){
				//group num ++
				data[j].num ++;
				var person = new Object();
				person.name = items[i].getAttribute('name')
				person.id = items[i].getAttribute('jid').split('@')[0];
				person.jid = items[i].getAttribute('jid');
				data[j].item.push(person);
				addPersondone=true;
				break;
			}
		}
		if(!addPersondone){
			var group = new Object();
			group.name = groupName;
			group.num = 1;
			group.id = groupName;
			var person = new Object();
			person.name = items[i].getAttribute('name')
			person.id = items[i].getAttribute('jid').split('@')[0];
			person.jid = items[i].getAttribute('jid');
			group.item = new Array();
			group.item.push(person);
			data.push(group);
		}

	}
	layIMobj.setDatas(data);
};

/*
 * 格式化时间工具
 */
Date.prototype.format = function(format){
	var o = {
		"M+" : this.getMonth()+1, //month
		"d+" : this.getDate(), //day
		"h+" : this.getHours(), //hour
		"m+" : this.getMinutes(), //minute
		"s+" : this.getSeconds(), //second
		"q+" : Math.floor((this.getMonth()+3)/3), //quarter
		"S" : this.getMilliseconds() //millisecond
	}

	if(/(y+)/.test(format)) {
		format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
	}

	for(var k in o) {
		if(new RegExp("("+ k +")").test(format)) {
			format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
		}
	}
	return format;
}

function _getText( element ){
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