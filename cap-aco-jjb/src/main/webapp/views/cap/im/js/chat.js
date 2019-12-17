//*********************************************************************
//系统名称：nxtbgms1.0
//Branch. All rights reserved.
//版本信息：nxtbgms2.0-V1.000-002
//Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
//#作者：zhangdyd
//SVN版本号日期作者变更记录
//------------------01      2016/05/   zhangdyd　新建
//------------------02      2016/06/27   联系人分组重命名，可以不做重命名保存。
//*********************************************************************
//不断更新信息，每60秒轮询一次
//window.setInterval("starRecMsg()", 60000);
var searchTreeResId="search_contacts_tree";
var groupTreeId="contacts_tree";
var rMenu;
var groupTree;
var chatGlobal;


$(function () {
	//auto load the groups
	getGroups();
	rMenu=$('#rMenu');
	
	// 添加联系人按钮
	$("#addnewfriend").click(function() {
		$('#myModalLabel1').text('添加联系人');
		$('#modal_form1_label1').html('添加联系人');
		$('#modal_form1_input1').attr("placeholder","请输入联系人登录名");
		$('#modal_form1_input1').val('');
		$('#back_infor').text('');
		$('#modal_form1_submit').attr("onclick","addnewfriend()");
		//initialize the create time
		$('#myModal1').modal({
			backdrop : 'static',
			keyboard : false
		});
	});
	//添加联系人分组按钮
	$("#addnewgroup").click(function() {
		$('#myModalLabel1').text('添加联系人分组');
		$('#modal_form1_label1').html('联系人分组');
		$('#modal_form1_input1').attr("placeholder","请输入分组名称");
		$('#modal_form1_input1').val('');
		$('#back_infor').text('');
		$('#modal_form1_submit').attr("onclick","createNewGroup2()");
		//initialize the create time
		$('#myModal1').modal({
			backdrop : 'static',
			keyboard : false
		});
	});
	
	
});

function clickmessage(user, messages,show){
	if(checkChatboxByUser(user)){
		//the given user's chatbox already exists
		//get current chatbox
		var obj=getCurrentChatbox();
		//hide the current chat box
		if(show=='1'){
			$(obj).hide();
		}

		//show the chat box of the given user
		showChatboxByUser(user);
		//load the messages
		loadMsgs(messages,user);
	}else{
		var results=getCurrentChatbox();
		//hidde the current chatbox
		if(show=='1'){
			$(results).hide();
		}
		var obj= createChatboxByUser(user,show);
		loadMsgs(messages,user);
	}
}

function getCurrentChatbox(){
	var result=$("div.chatbox:visible");
	if(result.length>1){
		//there are multiple activated chatbox
	}else{
	}
	return result;
	//anthor methode
}

//if one chatbox of the given user created, then return true, otherwise return false
function checkChatboxByUser( user ){
	var obj=null;
	obj=$("#"+user);
	if(obj.length>0){
		return true;
	}else{
		return false;
	}
}
//hidde the chatbox of the given user
function hideChatboxByUser( user ){
	$("#"+user).hide();
}

//show the chatbox of the given user
function showChatboxByUser( user ){
	$("#"+user).show();
}

function closeChatBox() {
	var result=$("div.chatbox:visible");
	$(result).hide();
}

//TODO add the additonal information to the chat box, e.g. user and department
function createChatboxByUser(user,show){
	if(checkChatboxByUser(user)){
		//the given user's chatbox already exists
		//get current chatbox
		var obj=getCurrentChatbox();
		//hide the current chat box
		$(obj).hide();
	}
	var chatbox=$("#default_chatbox").clone();
	//set the user property
	chatbox.attr("id", user);
	//show the block
	if(show=='1'){
		chatbox.show();
	}
	//set the talkbox id
	$(chatbox).children(".talkbox").attr("id","message_container_"+user);
	//set the information of the chat box, e.g. user and department
	$(chatbox).find("#username").text("和 "+user+" 的聊天框");
	$(chatbox).find("#department").text(user);
	//append to the root
	chatbox.appendTo("#chat-boxes");
}

function createChatByUser(user){
	if(checkChatboxByUser(user)){
		//the given user's chatbox already exists
		//get current chatbox
		var obj=getCurrentChatbox();
		//hide the current chat box
		$(obj).hide();
		//show the user chat box
		$('#'+user).show();
		
	}else{
		var results=getCurrentChatbox();
		//hidde the current chatbox
		$(results).hide();
		
		var chatbox=$("#default_chatbox").clone();
		
		//set the user property
		chatbox.attr("id", user);
		//show the block
		chatbox.show();
		
		//set the talkbox id
		$(chatbox).children(".talkbox").attr("id","message_container_"+user);
		
		//set the information of the chat box, e.g. user and department
		$(chatbox).find("#username").text("和 "+user+" 的聊天框");
		$(chatbox).find("#department").text(user);
		
		//append to the root
		chatbox.appendTo("#chat-boxes");
	}
}

function appendUserChatBox( obj ){
	var rootChatbox=document.getElementById("chat-boxes");
	rootChatbox.appendChild(obj);
}

//TODO set the additional information to the talkbox
function loadMsgs( messages, user ){
	for(var item=0 ; item<messages.length; item++){
		if(messages[item].msgTo==currenUser){
			//create the message in block
			var msg_in=$("#default_message_in").clone();
			//show message
			msg_in.attr("style","display:inline-block");
			//set id in the message in block
			msg_in.attr("id", messages[item].msgTime);
			
			$(msg_in).children(".chatuserbr").text(messages[item].msgContent);
			//append to the message container 
			msg_in.appendTo("#message_container_"+user);
			
		}else{
			if(messages[item].msgFrom==currenUser){
				//create the message in block
				var msg_out=$("#default_message_out").clone();
				//show message
				msg_out.attr("style","display:inline-block");
				//set id in the message in block
				msg_out.attr("id", messages[item].msgTime);
				
				$(msg_out).children(".chatuserb").text(messages[item].msgContent);
				//append to the message container 
				msg_out.appendTo("#message_container_"+user);
			}
		}
		//scroll auto locates at the bottom of the talkbox
		$("#message_container_"+user).scrollTop( $("#message_container_"+user)[0].scrollHeight );
	}
}

function recMsgFromUser(chato) {
	$.ajax({
	    url: "instantmsg/getmsgfromuserandmark",    //请求的url地址
	    dataType: "json",   //返回格式为json
	    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
	    data: {touser:chatto },    //参数值
	    type: "POST",   //请求方式
	    beforeSend: function() {
	        //请求前的处理
	    },
	    success: function(res) {
	        //请求成功时处理
	    	if(res!=null||res.size>0){
	    		var messages=[];
	    		//TODO when get some messages but with different from 
	    		for(var item=0 ; item<messages.length; item++){
	    			var temp=new Object();
	    			temp.msgFrom=res[item].msgFrom;
	    			temp.msgTo=res[item].msgTo;
	    			temp.msgTime=res[item].msgTime;
	    			temp.msgContent=res[item].msgContent;
	    			messages.push(temp);
	    			
	    			operateMsg(messages,temp.msgFrom);
	    		}
	    	}
	    },
	    complete: function() {
	        //请求完成的处理
	    },
	    error: function() {
	        //请求出错处理
	    }
	});
	
}

function starRecMsg() {
	$.ajax({
	    url: "instantmsg/getmsgandmark",    //请求的url地址
	    dataType: "json",   //返回格式为json
	    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
	    data: { },    //参数值
	    type: "POST",   //请求方式
	    success: function(res) {
	        //请求成功时处理
	    	if(res!=null&&res.length>0){
	    		for(var item=0; item<res.length; item++){
	    			var messages=[];
	    			var temp=new Object();
	    			temp.msgFrom=res[item].msgFrom;
	    			//temp.msgFromShow=res[item].msgFromShow;
	    			temp.msgTo=res[item].msgTo;
	    			//temp.msgToShow=res[item].msgToShow;
	    			temp.msgTime=res[item].msgTime;
	    			temp.msgContent=res[item].msgContent;
	    			messages.push(temp);
	    			operateMsg(messages,temp.msgFrom);
	    		}
    			//if show with different way
    			//clickmessage(temp.msgFrom,messages);
	    	}
	    }
	});
}

function operateMsg(messages,msgFrom) {
	var obj=$("#"+msgFrom);
	var prifix="remind_"
	var fromer=prifix+msgFrom;
	if(obj.length>0){
		if($(obj).is(":hidden")){
			//put infor in the remind list
			//this message not belong to the current chatbox
			var remind=$('#history_message li');
			var containFlag=false;
			for(var i=0, j=remind.length;i<j;i++){
            	//if get the id equal the message fromer, then add the message number.
            	if($(remind[i]).attr("id")==fromer){
            		var num=$(remind[i]).children('.badge');
            		var num1=parseInt(num.text())+1;
            		num.text(num1) ;
            		$(num).show();
            		containFlag=true;
            		//add one to the total unread messages
            		operateTotalNum(0,1);
            	}
			}
			if(!containFlag){
            	//add one <li> to the message remind
				//add onclick event
            	$('<li id="'+fromer+'" class="list-group-item"'+ 'onclick="clickMsgRemind(\''+msgFrom+'\',\''+msgFrom+'\') "' + '>'+
            			'<span >'+msgFrom+'</span><span class="badge" >'+1+'</span>'+'</li>').prependTo('#history_message');
        		//add one to the total unread messages
            	operateTotalNum(0,1);
			}
		}
		loadMsgs(messages,msgFrom);
	}else{
		var currChat=getCurrentChatbox();
		if(currChat.length>0){
			clickmessage(msgFrom,messages,0);
        	//add one <li> to the message remind	
        	$('<li id="'+fromer+'" class="list-group-item"'+ 'onclick="clickMsgRemind(\''+msgFrom+'\',\''+msgFrom+'\') "' + '>'+
        			'<span >'+msgFrom+'</span><span class="badge" >'+1+'</span>'+'</li>').prependTo('#history_message');
    		//add one to the total unread messages
        	operateTotalNum(0,1);
		}else{
			//load the new created chat box to the front
			clickmessage(msgFrom,messages,1);
		}

	}
}
/**
 * @param add : 0 is add, 1 is reduce
 * @param num : the number to operate
 */
function operateTotalNum(add,num){
	var totalObj = $('#msg_total_num');
	var oldTotalNum = totalObj.text();
	var newTotalNum;
	if(add==1){
		newTotalNum = parseInt(oldTotalNum) - parseInt(num);
	}else if(add==0){
		newTotalNum = parseInt(oldTotalNum) + parseInt(num);
	}else{
		return;
	}
	
	totalObj.text(newTotalNum);
	if(newTotalNum>0){
		totalObj.show();
	}else if(newTotalNum==0){
		totalObj.hide();
	}else{
		return;
	}
}

function clickMsgRemind(userId,userNameShow) {
	//TODO use the parameter of userNameShow
	createChatByUser(userId);
	//remove the message number
	var temp='#content_message li[id=\''+'remind_'+userId+'\'] span.badge';
	var numObj=$(temp);
	var oldnum;
	if(numObj.length>0){
		oldnum=$(numObj[0]).text();
		$(numObj[0]).text('0');
		$(numObj[0]).hide();
		//TODO reduce the unread messages total number
		operateTotalNum(1,oldnum);
		
	}
	//remove the remind messages in the $('#content_message');
	//$('#content_message li').remove('li[id=\''+'remind_'+namearray[1]+'\']');
	
}


function sendMsg() {
	var currChat=getCurrentChatbox();
	//get chatbox id, this id is to user
	var toUser=$(currChat).attr("id");
	
	//get the textarea content
	var cont=$(currChat).find("textarea").val();
	$(currChat).find("textarea").val("");
	
	if(cont=='undefined'||cont==''){
		return;
	}
	
	var messages=[];
	var msg=new Object();
	msg.msgContent=cont;
	msg.msgFrom=currenUser;
	msg.msgTo=toUser;
	var mydate = new Date();
	msg.msgTime=mydate.toLocaleString();
	messages.push(msg);
	
	//load the send message in the talkbox
	loadMsgs( messages, toUser );
	
	//send msg using cometd to the server
	try{
		chatGlobal.send(msg);
	}catch (e) {
		// TODO: handle exception
		layerAlert("发送信息发生错误，对方有可能没有收到此条信息，请重新登录系统！");
		return;
	}
	//send msg to the server
	$.ajax({
	    url: "instantmsg/sendmsg",    //请求的url地址
	    dataType: "json",   //返回格式为json
	    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
	    data: {
	    	to:toUser,
	    	cont:cont
	    },    //参数值
	    type: "POST",   //请求方式
	    beforeSend: function() {
	        //请求前的处理
	    },
	    success: function(res) {
	        //请求成功时处理
	    	if(res!=null){
	    	}
	    },
	    complete: function() {
	        //请求完成的处理
	    },
	    error: function() {
	    	layerAlert("同步信息发生错误，对方在其它设备上有可能没有收到此条信息，请重新登录系统！");
	        return;
	    }
	});


}

function sendfile() {
	//send msg to the server
	
	$.ajax({
	    url: "instantmsg/sendfile",    //请求的url地址
	    dataType: "json",   //返回格式为json
	    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
	    data: { },    //参数值
	    type: "POST",   //请求方式
	    beforeSend: function() {
	        //请求前的处理
	    },
	    success: function(res) {
	        //请求成功时处理
	    	if(res!=null){
	    	}
	    },
	    complete: function() {
	        //请求完成的处理
	    },
	    error: function() {
	        //请求出错处理
	    }
	});
	
}

//global ztree setting
var setting = {
		async: {
			enable: true,
			type: "post",
			dataType: "json",
			//get the groupers
			url:"roaster/getGroupers",
			autoParam:["id"],
			idKey: "id",
			pIdKey: "pId"
			
		},
		edit: {
			drag:{
				autoExpandTrigger: true,
				isCopy: false,
				isMove: true,
				prev: false,
				next: false,
				inner: true,
				borderMax: 10,
				borderMin: -5,
				
			},
			enable: true,
			showRenameBtn: showRenameBtn,
			showRemoveBtn: showRemoveBtn
		},
		callback: {
			onClick: zTreeOnClick,
			//call before rename
			beforeRename: zTreeBeforeRename,
			//if rename return true, call onRename
			onRename: zTreeOnRename,
			//call before remove the tree node
			beforeRemove:zTreeBeforeRemove,
			//if zTreeBeforeRemove return true, then call
			onRemove:zTreeOnRemove,
			
			beforeDrag: zTreeBeforeDrag,
			onDrag: zTreeOnDrag,
			beforeDragOpen: zTreeBeforeDragOpen,
			
			beforeDrop: zTreeBeforeDrop,
			onDragMove: zTreeOnDragMove,
			onDrop: zTreeOnDrop,
			
//			beforeRightClick:zTreeBeforeRightClick,
//			onRightClick:zTreeOnRightClick,
			
			//double click function
			onDblClick: zTreeOnDblClick
			
		},
		view:{
		 showLine: false,//显示连接线  
         showIcon: true,//显示节点图片  
         fontCss: {color:"#000"}  
		}
	};
//the search result will be a static ztree
var searchTreesetting = {
		async: {
			enable: true,
			type: "post",
			dataType: "json",
			autoParam:["id"],
			idKey: "id",
			pIdKey: "pId"
			
		},
		callback: {
			//double click function
			onDblClick: zTreeOnDblClick
		},
		view:{
		 showLine: false,//显示连接线  
         showIcon: true,//显示节点图片  
         fontCss: {color:"#000"}  
		}
	};

// load the groups
function getGroups() {
	$.ajax({
	    url: "roaster/getTreenode",   //请求的url地址
	    dataType: "json",   //返回格式为json
	    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
	    data: { },    //参数值
	    type: "POST",   //请求方式
	    beforeSend: function() {
	        //请求前的处理
	    },
	    success: function(res) {
	        //请求成功时处理
	    	if(res!=null){
	    		var obj=$.fn.zTree.init($("#contacts_tree"),setting,res);
	    	}
	    },
	    complete: function() {
	        //请求完成的处理
	    },
	    error: function() {
	        //请求出错处理
	    }
	});
	
} 

function zTreeOnClick(event,id,treeNode){
	 //判断是否是父节点如果是父节点点击加载子节点
	 if(treeNode.isParent) {
		 //父节点 asychron load
		 var obj= $.fn.zTree.getZTreeObj(id);
		 if(treeNode.open){
			 obj.expandNode(treeNode,false,false,false);
		 }else{
			 obj.reAsyncChildNodes(treeNode, "refresh");
		 }
		 
	
	 }
}

//是否显示编辑按钮
function  showRenameBtn(treeId, treeNode){
	//获取节点所配置的noEditBtn属性值
	if(treeNode.noEditBtn != undefined && treeNode.noEditBtn ){
		return false;
	}
	if(treeNode.name=="好友"){
		return false;
	}
	if(!treeNode.isParent){
		return false;
	}
	return true;
}

//是否显示删除按钮
function showRemoveBtn(treeId, treeNode){
	//获取节点所配置的noRemoveBtn属性值
	if(treeNode.noRemoveBtn != undefined && treeNode.noRemoveBtn ){
		return false;
	}
	if(treeNode.name=="好友"){
		return false;
	}
	return true;
}

function zTreeBeforeRemove(id,treeNode){
	//if conditions satisfied, then return true and call zTreeOnRemove, otherwise the "remove" operation fails
} 

function zTreeOnRemove(event,id,treeNode) {
	var urlpath;
	if(treeNode.isParent){
		urlpath="roaster/delgroup";
		$.ajax({
		    url: urlpath,    //请求的url地址
		    dataType: "json",   //返回格式为json
		    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
		    data: {
		    	groupId:treeNode.id
		    	},    //参数值
		    type: "POST",   //请求方式
		    beforeSend: function() {
		        //请求前的处理
		    },
		    success: function(res) {
		    	getGroups();
		    },
		    complete: function() {
		        //请求完成的处理
		    },
		    error: function() {
		        //请求出错处理
		    }
		});
	}else{
		urlpath="roaster/delgrouper";
		$.ajax({
		    url: urlpath,    //请求的url地址
		    dataType: "json",   //返回格式为json
		    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
		    data: {
		    	//grouper id
		    	grouperId:treeNode.id,
		    	//group id
		    	groupId:treeNode.groupId
		    	},    //参数值
		    type: "POST",   //请求方式
		    beforeSend: function() {
		        //请求前的处理
		    },
		    success: function(res) {
		    	getGroups();
		    },
		    complete: function() {
		        //请求完成的处理
		    },
		    error: function() {
		        //请求出错处理
		    }
		});
	}
}
//global variable, store the old group name
var old_groupName="";
function zTreeBeforeRename(id,treeNode,newname) {
	//initialize the global variable
	old_groupName="";
	//allready show the input 
	//if return false, then the selected node can no be renamed
	//return false;
	if(newname==""){
		layerAlert("新建分组名不能为空");
		return false;
	}
	if(treeNode.name==newname){
		old_groupName =treeNode.name;
		return true;//did not rename the group
	}
	if(!checkRepeatName(id,newname)){
		return true;
	}else{
		layerAlert("新建组名和已有分组名重复");
		return false;
	}
}

function zTreeOnRename(event,id,treeNode) {
	//if did not rename the node, then do nothing
	if(old_groupName==treeNode.name){
		return;
	}
	//"id" is the id of the tree obj
	var urlpath;
	if(treeNode.isParent){
			$.ajax({
			    url: "roaster/renamegroup",    //请求的url地址
			    dataType: "json",   //返回格式为json
			    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
			    data: {newName: treeNode.name,
			    	groupId:treeNode.id
			    	},    //参数值
			    type: "POST",   //请求方式
			    beforeSend: function() {
			        //请求前的处理
			    },
			    success: function(res) {
			        //请求成功时处理
			    	if(res==true){
			    		getGroups() ;
			    	}
			    },
			    complete: function() {
			        //请求完成的处理
			    },
			    error: function() {
			        //请求出错处理
			    }
			});

	}else{
		getGroups();
	}
	
}

function checkRepeatName(id,newName) {
	//check if repeat the group name
	var tree=$.fn.zTree.getZTreeObj(id);
	var groupNames=tree.getNodesByFilter(checkRepeatNameFilter);
	for(var i=0, len=groupNames.length;i<len;i++){
		if(groupNames[i].groupname==newName){
			return true;
		}
	}
	return false;
}

function checkRepeatNameFilter(node) {
	return (node.isParent>-1);
};

function createNewGroup() {
	$('#div_addnewgroup').show();
}
function createNewGroup2() {
//	$('#div_addnewgroup').hide();
	var name=$('#modal_form1_input1').val();
	$('#back_infor').text('');
//	$('#addnewgroup').val('');
	if(checkRepeatName(groupTreeId,name)){
		$('#back_infor').text('输入分组名重复');
		return;
	}
	$.ajax({
	    url: "roaster/creategroup",    //请求的url地址
	    dataType: "json",   //返回格式为json
	    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
	    data: {createName: name },    //参数值
	    type: "POST",   //请求方式
	    beforeSend: function() {
	        //请求前的处理
	    },
	    success: function(res) {
	        //请求成功时处理
	    	if(res==true){
	    		$('#back_infor').text("添加联系人分组成功！");
	    		setTimeout(modelhide,1000);
	    		getGroups();
	    	}
	    },
	    complete: function() {
	    },
	    error: function() {
	    	$('#back_infor').text("添加联系人分组失败！");
	    }
	});
}

function modelhide(){
	$('#myModal1').modal('hide');
}

//add grouper
function addnewfriend() {
	var name = $('#modal_form1_input1').val();
	$('#back_infor').text('');
	$.ajax({
	    url: "roaster/addfriend",    //请求的url地址
	    dataType: "text",   //返回格式为json
	    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
	    data: {name: name },    //参数值
	    type: "POST",   //请求方式
	    beforeSend: function() {
	        //请求前的处理
	    },
	    success: function(res) {
	        //请求成功时处理
	    	if(res=="true"){
	    		$('#back_infor').text("已经成功添加到“好友”组！");
/*	    		//clear the add new contact input
	    		$('#modal_form1_input1').val("");*/
	    		setTimeout(modelhide,1000)
	    		getGroups() ;
	    	}else if(res=="exists"){
	    		$('#back_infor').text("您已经添加了这个联系人！");
	    	}else{
	    		$('#back_infor').text("输入的联系人登录码不存在！");
	    	}
	    	
	    },
	    complete: function() {
	        //请求完成的处理
	    },
	    error: function() {
	    	$('#back_infor').text("添加联系人失败！");
	    }
	});
}

function zTreeBeforeDrag(id,treeNodes) {
	//apendding on the results, start the drag-operation
	//only the leves can be dragt, the parent node(groups) can not be dragt.
	//treenode is an array
	for(var i=0, len=treeNodes.length;i<len;i++){
		if(treeNodes[i].isParent||treeNodes[i].getParentNode()==null){
			treeNodes[i].isParent=true;
			layerAlert("这个分组不能被移动");
			return false;
		}
	}
	return true;
}

function zTreeOnDrag(event,id,treeNode) {
	var treeObj = $.fn.zTree.getZTreeObj("contacts_tree"); 
}
var sourceParent=null;
function zTreeBeforeDrop(id,treeNodes,targetInfo, dropType,isCopy) {
	if(targetInfo.groupname!=null){
		targetInfo.isParent=true;
	}
	var temp=treeNodes[0].getParentNode();
	sourceParent=temp;
	if(temp==null){
		treeNodes[0].isParent=true;
		return false;
	}
	if(targetInfo.isParent){
		return true;
	}else{
		return false;
	}
}

function zTreeOnDrop(event,id,treeNodes,targetInfo, dropType,isCopy) {
	if(targetInfo!=null&&treeNodes.length>0){
		for(var i=0,len=treeNodes.length;i<len;i++){
			var oldgroupId=treeNodes[i].groupId;
			var newgroupId=targetInfo.id;
			$.ajax({
			    url: "roaster/movegrouper",    //请求的url地址
			    dataType: "json",   //返回格式为json
			    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
			    data: {oldgroupId: oldgroupId,
			    	newgroupId: newgroupId,
			    	grouperId:treeNodes[i].id },    //参数值
			    type: "POST",   //请求方式
			    beforeSend: function() {
			        //请求前的处理
			    },
			    success: function(res) {
			        //请求成功时处理
			    	if(res!=true){
			    		layerAlert("操作失败");
			    	}else if(res==true) {

			    	}
			    },
			    complete: function() {
			        //请求完成的处理
			    },
			    error: function() {
			    	layerAlert("操作失败");
			    }
			});
		}
		//fresh the ztree, prevent the parent node without
		getGroups();
//		var obj= $.fn.zTree.getZTreeObj(id);
//		obj.reAsyncChildNodes(targetInfo, "");
//		obj.expandNode(targetInfo,false,false,false);
////		 var parentnode = obj.getNodeByTId(oldgroupTId);
//		if(sourceParent!=null){
//			obj.reAsyncChildNodes(sourceParent, "refresh");
//		}

	}
}

function zTreeBeforeDragOpen(event,id,treeNode) {
}

function zTreeOnDragMove(event,id,treeNode) {
}

//show the chatbox of tree node
function zTreeOnDblClick(event, treeId, treeNode) {
	if(!treeNode.isParent){
		var namearray=treeNode.name.split('-');
		createChatByUser(namearray[1]);
		
		//remove the message number
		var temp='#content_message li[id=\''+'remind_'+namearray[1]+'\'] span.badge';
		var numObj=$(temp);
		var oldnum;
		if(numObj.length>0){
			
			oldnum=$(numObj[0]).text();
			$(numObj[0]).text('0');
			$(numObj[0]).hide();
			//TODO reduce the unread messages total number
			operateTotalNum(1,oldnum);
		}
		//remove the remind messages in the $('#content_message');
		//$('#content_message li').remove('li[id=\''+'remind_'+namearray[1]+'\']');
	}
};

function searchGrouper(){
	var searchName=$('#input1-group2').val();
	
	if(searchName==null){
		layerAlert("输入的搜索名字为空");
		return;
	}
	var treeObj = $.fn.zTree.getZTreeObj("contacts_tree"); 
	//query the server
	$.ajax({
	    url: "roaster/searchgrouper",    //请求的url地址
	    dataType: "json",   //返回格式为json
	    async: true, //请求是否异步，默认为异步，这也是ajax重要特性
	    data: {groupername: searchName },    //参数值
	    type: "POST",   //请求方式
	    beforeSend: function() {
	        //请求前的处理
	    },
	    success: function(res) {
	        //请求成功时处理
	    	if(res!=null){
	    		var obj=$.fn.zTree.init($("#"+searchTreeResId),searchTreesetting,res);
	    		//switch hide and show
	    		$("#"+searchTreeResId).parent().show();
	    		$("#"+groupTreeId).parent().hide();
	    		
	    	}else{
	    		layerAlert("操作失败");
	    	}
	    },
	    complete: function() {
	        //请求完成的处理
	    },
	    error: function() {
	    	layerAlert("操作失败");
	    }
	});
	
}

function searchGrouperfilter(node) {
    var isCheck = node.checked;  
    var isDisabled = node.chkDisabled;  
    return (!node.isParent) && (isCheck || isDisabled);  
}

function switchShow(closeId, showId) {
	$('#input1-group2').val("");
	$('#'+closeId).hide();
	$('#'+showId).show();
}

function zTreeBeforeRightClick(treeId,treeNode) {
	if(treeNode==null){
		return true;
	}
	return false;
}

function zTreeOnRightClick(event,treeId,treeNode) {
	if(treeNode==null){
		showRMenu("root", event.clientX, event.clientY);
	}else if (!treeNode && event.target.tagName.toLowerCase() != "button" && $(event.target).parents("a").length == 0) {
		zTree.cancelSelectedNode();
		showRMenu("root", event.clientX, event.clientY);
	} else if (treeNode && !treeNode.noR) {
		zTree.selectNode(treeNode);
		showRMenu("node", event.clientX, event.clientY);
	}
}
function hideRMenu() {
	if (rMenu) rMenu.css({"visibility": "hidden"});
	$("body").unbind("mousedown", onBodyMouseDown);
}
function showRMenu(type, x, y) {
	$("#rMenu ul").show();
	if (type=="root") {
		$("#m_del").hide();
		$("#m_check").hide();
		$("#m_unCheck").hide();
	} else {
		$("#m_del").show();
		$("#m_check").show();
		$("#m_unCheck").show();
	}
	rMenu.css({"top":y+"px", "left":x+"px", "visibility":"visible"});
	$("body").bind("mousedown", onBodyMouseDown);
}

function onBodyMouseDown(event){
	if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length>0)) {
		rMenu.css({"visibility" : "hidden"});
	}
}

function clearSearchInput(){
	//clear the search input
	$("#input1-group2").val("");
}




