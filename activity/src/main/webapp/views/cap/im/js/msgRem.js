	getUnreadCount(); 
	getAllUnreadMsgs();
//不断更新信息，每180秒更新一次
window.setInterval("updateMsgs()", 180000);

function updateMsgs() {
	getUnreadCount(); 
	getAllUnreadMsgs();
	
}
function getUnreadCount() {
	//get the number of unread messages
	$.ajax({
//	    url: "instantmsg/getunreadcount",    //请求即时通讯的url地址
	    url: "msgRemind/countUnread",	//请求消息提醒的url地址
	    dataType: "json",   //返回格式为json
	    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
	    data: { },    //参数值
	    type: "POST",   //请求方式
	    beforeSend: function() {
	        //请求前的处理
	    },
	    success: function(number) {
	        //请求成功时处理
	    	if(number!=null){
	    		if(number=="fatal_erro"){
	    			//TODO show the error message
	    			//server error or connection error
	    		}else {
		    		//找到消息提醒按钮，并把未读信息量更新
	    			if(parseInt(number)>0){
			    		var buttn=$('#instantmessage').children('a').find('span');
			    		if(buttn.length==1){
			    			$(buttn).text(number);
			    			$(buttn).show();
	    			}

		    			
		    		}
	    		}
	    	}
	    },
	    complete: function() {
	        //请求完成的处理
	    },
	    error: function() {
	        //TODO 请求出错处理
	    	//alert("error");
	    }
	});
	
}

function getAllUnreadMsgs(){
	$.ajax({
	    url: "msgRemind/msgs",    //请求的url地址
	    dataType: "json",   //返回格式为json
	    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
	    data: { },    //参数值
	    type: "POST",   //请求方式
	    beforeSend: function() {
	        //请求前的处理
	    },
	    success: function(msgs) {
	        //请求成功时处理
    		$('#msgs_display_board').empty();
			
			$('<li class="dropdown-menu-header"><strong>消息提醒</strong></li>').appendTo('#msgs_display_board')
	    	if(msgs!=null&&msgs.length>0){

	    		
	    		//$('#msgs_display_board').attr('style','overflow:auto')
	    		//TODO add messages in the button
	    		var msgId='msgNum';
	    		for(var item=0, j=msgs.length; item<j ;  item++){
	    			var temp=new Object();
	    			//alert(item);
	    			temp=msgs[item];
	    			//列表开始
	    			var parent123=$('<li id="'+temp.id+'" style="padding:10px; line-height:30px;"></li>');
	    			//var p
	    			//$('<i></i>').appendTo(parent123);
	    			//$('<div style="display:none;"></div>').text(temp.id).appendTo(parent);
	    			var subject="主题： "+temp.subject+"  ";
	    			$('<i class="fa fa-comment"><span onclick="showTab(\''+temp.callback_url+'\',\''+temp.callback_tab_text+'\',\''+temp.callback_tab_id+'\''+','+'\''+temp.id+'\''+')" style="font-weight:bold; color:#333;">'+subject+'</span></i>').appendTo(parent123);
	    			var contentToshow="内容： "+temp.contentToshow+"  ";
	    			//$('<i></i>').appendTo(parent123);
	    			//$('<div style="display:none;"></div>').text(temp.id).appendTo(parent);
	    			$('<div style="padding-left:24px;"><span style="width:300px; word-break:break-all; display:inline-block; ">'+contentToshow+'</span></div>').appendTo(parent123);
	    			//$('<i><span ></span></i>').attr('class','notification-action').text(contentToshow).appendTo(parent123);
	    			var fromer="&nbsp;&nbsp;&nbsp;发布人： "+ temp.publisher_name+"      ";
	    			var typeToShow="类型： "+temp.typeToShow+"     ";
	    			//show the message type and publisher
	    			$('<div style="padding-left:24px; padding-bottom:5px; border-bottom:1px #ccc dashed;">'+'<span style="color:#888;">'+typeToShow+'</span>'+'<span style="color:#888;">'+fromer+'</span>'+'</div>').appendTo(parent123);
	    			//show the message function
	    			$('<div style="padding-left:24px;">'+'<a style="margin-right:0;" onclick="deleteMsg(\''+temp.id+'\')">'+"删除   "+'</a>'+'<a onclick="markMsg(\''+temp.id+'\')">'+"忽略    "+'</a>'+'</div>').appendTo(parent123);
	    			parent123.appendTo('#msgs_display_board');
	    		}
	    	}
	    },
	    complete: function() {
	        //请求完成的处理
	    },
	    error: function() {
	        //TODO 请求出错处理
	    	//alert("error");
	    }
	});
	
}

function markMsg(msgId) {
	//TODO
	//hide the message
	$('#'+msgId).hide();
	modifyMsgNum("del");
	//send message to the server
	$.ajax({
	    url: "msgRemind/markMsg",   
	    dataType: "json",   
	    async: true, 
	    data: {ids:msgId },    
	    type: "POST",   
	    success: function(data) {
	    	if(data==false){
	    		//recover the message
	    		$('#'+msgId).show();
	    		modifyMsgNum("add");
	    	}
	    },
	    complete: function() {
	    },
	    error: function() {
	    	$('#'+msgId).show();
	    }
	});
}

function deleteMsg(msgId) {
	//TODO confirm remind
	
//	// 询问框
//	layer.confirm('确定删除吗？', {
//		btn : [ '是', '否' ]
//	// 按钮
//	}, function() {
//		layer.msg('你点击了是', {
//			icon : YES_ICON
//		});
//	}, function() {
//		layer.msg('你点击了否', {
//			icon : NO_ICON
//		});
//	});
	
	
	
	//send message to the server
	//hide the message
	$('#'+msgId).hide();
	
	modifyMsgNum("del");
	
	$.ajax({
	    url: "msgRemind/deleteMsg",    
	    dataType: "json",   
	    async: true, 
	    data: {ids:msgId },    
	    type: "POST",   
	    beforeSend: function() {
	    },
	    success: function(data) {
	    	if(data==false){
	    		$('#'+msgId).show();
	    		modifyMsgNum("add");
	    	}
	    },
	    complete: function() {
	    },
	    error: function() {
	    	//alert("error");
	    }
	});
	
}
function modifyMsgNum(add) {
	if(add=="add"){
		var buttn=$('#instantmessage').children('a').find('span');
		if(buttn.length==1){
			var oldnumber=$(buttn).text();
			$(buttn).text(parseInt(oldnumber, 10)+1);
			
		}
	}else if (add=="del") {
		var buttn=$('#instantmessage').children('a').find('span');
		if(buttn.length==1){
			var oldnumber=$(buttn).text();
			var num = parseInt(oldnumber, 10)-1;
			$(buttn).text(num);
			if(num<1){
				$(buttn).hide();
			}
		}
	}
}

function showTab(url,text,id,msgId) {
	markMsg(msgId); 
	var options = {
			"href" : url,
			"text": text,
			"id":"jstx"+id,
			"pid":window
		};
	//重新打开一个聊天页
	window.createTab(options);
}





