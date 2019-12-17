/*

 @Name: layui WebIM 1.0.0
 @Author：贤心
 @Date: 2014-04-25
 @Blog: http://sentsin.com
 
 */
 
;!function(win, undefined){
	//alert(123);

var config = {
    msgurl: 'mailbox.html?msg=',
    chatlogurl: 'mailbox.html?user=',
    aniTime: 200,
    right: -232,
    api: {
        friend: 'http://localhost:8080/cap-aco/views/aco/im/js/layim/data/friend.json', //好友列表接口
        group: 'http://localhost:8080/cap-aco/views/aco/im/js/layim/data/group.json', //群组列表接口 
        chatlog: 'http://localhost:8080/cap-aco/views/aco/im/js/layim/data/chatlog.json', //聊天记录接口
        groups: 'http://localhost:8080/cap-aco/views/aco/im/js/layim/data/groups.json', //群组成员接口
        sendurl: '' //发送消息接口
    },
    user: { //当前用户信息
        name: '卢昭伟',
        face: '/cap-aco/uploader/uploadfile?pic=8542b9ff73a148eba484b4d3508b16db.png'
    },
    
    //自动回复内置文案，也可动态读取数据库配置
    autoReplay: [
        '您好，我现在有事不在，一会再和您联系。', 
        '你没发错吧？',
        '洗澡中，请勿打扰，偷窥请购票，个体四十，团体八折，订票电话：一般人我不告诉他！',
        '你好，我是主人的美女秘书，有什么事就跟我说吧，等他回来我会转告他的。',
        '我正在拉磨，没法招呼您，因为我们家毛驴去动物保护协会把我告了，说我剥夺它休产假的权利。',
        '<（@￣︶￣@）>',
        '你要和我说话？你真的要和我说话？你确定自己想说吗？你一定非说不可吗？那你说吧，这是自动回复。',
        '主人正在开机自检，键盘鼠标看好机会出去凉快去了，我是他的电冰箱，我打字比较慢，你慢慢说，别急……',
        '(*^__^*) 嘻嘻，是贤心吗？'
    ],
    
    //当前打开的聊天窗口队列
    chating: {},
    hosts: (function(){
        var dk = location.href.match(/\:\d+/);
        //alert(dk);
        dk = dk ? dk[0] : '';
        return 'http://' + document.domain + dk + '/';
    })(),
    //从服务器获取数据
    json: function(url, data, callback, error){
        return $.ajax({
            type: 'POST',
            url: url,
            data: data,
            dataType: 'json',
            success: callback,
            error: error
        });
    },
    stopMP: function(e){
        e ? e.stopPropagation() : e.cancelBubble = true;
    }
}, dom = [$(window), $(document), $('html'), $('#capAcoWebIMDiv')], xxim = {},preCached=[];
xxim.freindReq = [];
xxim.tempMsg=[];
//主界面tab
xxim.tabs = function(index){
    var node = xxim.node;
    node.tabs.eq(index).addClass('xxim_tabnow').siblings().removeClass('xxim_tabnow');
    node.list.eq(index).show().siblings('.xxim_list').hide();
    if(node.list.eq(index).find('li').length === 0){
        xxim.getDates(index);
    }
};
//各个节点，可以点击或者事件
//节点
xxim.renode = function(){
    var node = xxim.node = {
        tabs: $('#xxim_tabs>span'),
        //即时通讯内部的列表，如：好友列表
        list: $('.xxim_list'),
        //在线功能的节点
        online: $('.xxim_online'),
        //设置online
        setonline: $('.xxim_setonline'),
        //点击 在线状态的文字
        onlinetex: $('#xxim_onlinetex'),
        //及时通讯展开
        xximon: $('#xxim_on'),
        layimFooter: $('#xxim_bottom'),
        //即时通讯收起
        xximHide: $('#xxim_hide'),
        //搜索功能
        xximSearch: $('#xxim_searchkey'),
        //搜索结果展示
        searchMian: $('#xxim_searchmain'),
        //关闭搜索
        closeSearch: $('#xxim_closesearch'),
        //未知
        layimMin: $('#layim_min'),
        //查看添加好友请求按钮
        addReq: $('.addReq')
    }; 
};

//主界面缩放
xxim.expend = function(){
    var node = xxim.node;
    if(xxim.layimNode.attr('state') !== '1'){
        xxim.layimNode.stop().animate({right: config.right}, config.aniTime, function(){
            node.xximon.addClass('xxim_off');
            try{
                localStorage.layimState = 1;
            }catch(e){}
            xxim.layimNode.attr({state: 1});
            node.layimFooter.addClass('xxim_expend').stop().animate({marginLeft: config.right}, config.aniTime/2);
            node.xximHide.addClass('xxim_show');
        });
    } else {
        xxim.layimNode.stop().animate({right: 1}, config.aniTime, function(){
            node.xximon.removeClass('xxim_off');
            try{
                localStorage.layimState = 2;
            }catch(e){}
            xxim.layimNode.removeAttr('state');
            node.layimFooter.removeClass('xxim_expend');
            node.xximHide.removeClass('xxim_show');
        });
        node.layimFooter.stop().animate({marginLeft: 0}, config.aniTime);
    }
};

//初始化窗口格局
xxim.layinit = function(){
    var node = xxim.node;
    
    //主界面
    try{
        /*
        if(!localStorage.layimState){       
            config.aniTime = 0;
            localStorage.layimState = 1;
        }
        */
        if(localStorage.layimState === '1'){
            xxim.layimNode.attr({state: 1}).css({right: config.right});
            node.xximon.addClass('xxim_off');
            node.layimFooter.addClass('xxim_expend').css({marginLeft: config.right});
            node.xximHide.addClass('xxim_show');
        }
    }catch(e){
        //layer.msg(e.message, 5, -1);
    }
};

//聊天窗口
xxim.popchat = function(param){
	
    var node = xxim.node, log = {};
    
    //clear the unread msg number in childnode
	var freind= $(node.list.eq(0)).find('.xxim_childnode[data-id="'+param.id+'"]');
	var numEle = freind.find('span.unReadMsgNum')[0];
	numEle.innerHTML='';

	log.success = function(layero){
        //layer.setMove();
     
        xxim.chatbox = layero.find('#layim_chatbox');
        log.chatlist = xxim.chatbox.find('.layim_chatmore>ul');
        //first pop chat box
        log.chatlist.html('<li data-id="'+ param.id +'" type="'+ param.type +'"  id="layim_user'+ param.type + param.id +'"><span class="firstSpan">'+ param.name +'</span><span></span><em>×</em></li>')
        xxim.tabchat(param, xxim.chatbox);
        
        //最小化聊天窗
        xxim.chatbox.find('.layer_setmin').on('click', function(){
            var indexs = layero.attr('times');
            layero.hide();
            node.layimMin.text(xxim.nowchat.name).show();
        });
        
        //关闭窗口
        xxim.chatbox.find('.layim_close').on('click', function(){
            var indexs = layero.attr('times');
            layer.close(indexs);
            xxim.chatbox = null;
            config.chating = {};
            config.chatings = 0;
            //set the now chat is null
            xxim.nowchat = null;
        });
        
        //关闭某个聊天
        log.chatlist.on('mouseenter', 'li', function(){
            $(this).find('em').show();
        }).on('mouseleave', 'li', function(){
            $(this).find('em').hide();
        });
        log.chatlist.on('click', 'li em', function(e){
            var parents = $(this).parent(), dataType = parents.attr('type');
            var dataId = parents.attr('data-id'), index = parents.index();
            var chatlist = log.chatlist.find('li'), indexs;
            
            config.stopMP(e);
            
            delete config.chating[dataType + dataId];
            config.chatings--;
            
            parents.remove();
            $('#layim_area'+ dataType + dataId).remove();
            if(dataType === 'group'){
                $('#layim_group'+ dataType + dataId).remove();
            }
            
            if(parents.hasClass('layim_chatnow')){
                if(index === config.chatings){
                    indexs = index - 1;
                } else {
                    indexs = index + 1;
                }
                xxim.tabchat(config.chating[chatlist.eq(indexs).attr('type') + chatlist.eq(indexs).attr('data-id')]);
            }
            
            if(log.chatlist.find('li').length === 1){
                log.chatlist.parent().hide();
            } 
        });
        
        //聊天选项卡
        log.chatlist.on('click', 'li', function(){
            var othis = $(this), dataType = othis.attr('type'), dataId = othis.attr('data-id');
            xxim.tabchat(config.chating[dataType + dataId]);
        });
        
        //发送热键切换
        log.sendType = $('#layim_sendtype'), log.sendTypes = log.sendType.find('span');
        $('#layim_enter').on('click', function(e){
            config.stopMP(e);
            log.sendType.show();
        });
        log.sendTypes.on('click', function(){
            log.sendTypes.find('i').text('')
            $(this).find('i').text('√');
        });
        
        //TODO set send "Shortcut key"
        //set the send shortcut key= 1;
        xxim.transmit();
    };
    
    log.html = '<div class="layim_chatbox" id="layim_chatbox">'
            +'<h6>'
            +'<span class="layim_move"></span>'
      //    +'    <a href="'+ param.url +'" class="layim_face" target="_blank"><img src="'+ param.face +'" ></a>'
            +'    <a href="'+ param.url +'" class="layim_face" target="_blank"><img src="/cap-aco/uploader/uploadfile?pic=8542b9ff73a148eba484b4d3508b16db.png" ></a>'
            +'    <a href="'+ param.url +'" class="layim_names" target="_blank">'+ param.name +'</a>'
            +'    <span class="layim_rightbtn">'
            +'        <i class="layer_setmin">—</i>'
            +'        <i class="layim_close">&times;</i>'
            +'    </span>'
            +'</h6>'
            +'<div class="layim_chatmore" id="layim_chatmore">'
            +'    <ul class="layim_chatlist"></ul>'
            +'</div>'
            +'<div class="layim_groups" id="layim_groups"></div>'
            +'<div class="layim_chat">'
            +'    <div class="layim_chatarea" id="layim_chatarea">'
            +'        <ul class="layim_chatview layim_chatthis"  id="layim_area'+ param.type + param.id +'"></ul>'
            +'    </div>'
            +'    <div class="layim_tool">'
            +'        <i class="layim_addface fa fa-meh-o" title="发送表情"></i>'
            +'        <a href="javascript:;"><i class="layim_addimage fa fa-picture-o" title="上传图片"></i></a>'
            +'        <a href="javascript:;"><i class="layim_addfile fa fa-paperclip" title="上传附件"></i></a>'
            +'        <a href="" target="_blank" class="layim_seechatlog"><i class="fa fa-comment-o"></i>聊天记录</a>'
            +'    </div>'
            +'    <textarea class="layim_write" id="layim_write"></textarea>'
            +'    <div class="layim_send">'
            +'        <div class="layim_sendbtn" id="layim_sendbtn">发送<span class="layim_enter" id="layim_enter"><em class="layim_zero"></em></span></div>'
            +'        <div class="layim_sendtype" id="layim_sendtype">'
            +'            <span><i>√</i>按Enter键发送</span>'
            +'            <span><i></i>按Ctrl+Enter键发送</span>'
            +'        </div>'
            +'    </div>'
            +'</div>'
            +'</div>';
    //add by zhangduoyi
    var logArray = new Array();
    logArray[0]=log.html;
    
    if(config.chatings < 1){
        layer.open({
            type: 5,
            border: 0,
            title: "123123131",
            shade: 0,
            area: ['620px', '493px'],
            move: '.layim_chatbox .layim_move',
            moveType: 1,
            closeBtn: false,
            offset: [(($(window).height() - 493)/2)+'px', ''],
            content: logArray, success: function(layero){
                log.success(layero);
            }
        })
    } else {
        log.chatmore = xxim.chatbox.find('#layim_chatmore');
        log.chatarea = xxim.chatbox.find('#layim_chatarea');
        
        log.chatmore.show();
        
        log.chatmore.find('ul>li').removeClass('layim_chatnow');
        //after first pop chat box
        log.chatmore.find('ul').append('<li data-id="'+ param.id +'" type="'+ param.type +'" id="layim_user'+ param.type + param.id +'" class="layim_chatnow"><span class="firstSpan">'+ param.name +'</span><span></span><em>×</em></li>');
        
        log.chatarea.find('.layim_chatview').removeClass('layim_chatthis');
        log.chatarea.append('<ul class="layim_chatview layim_chatthis" id="layim_area'+ param.type + param.id +'"></ul>');
        
        xxim.tabchat(param);
    }
    
    //群组
    log.chatgroup = xxim.chatbox.find('#layim_groups');
    if(param.type === 'group'){
        log.chatgroup.find('ul').removeClass('layim_groupthis');
        log.chatgroup.append('<ul class="layim_groupthis" id="layim_group'+ param.type + param.id +'"></ul>');
        xxim.getGroups(param);
    }
    //点击群员切换聊天窗
    log.chatgroup.on('click', 'ul>li', function(){
        xxim.popchatbox($(this));
    });
};

//定位到某个聊天队列
xxim.tabchat = function(param){
    var node = xxim.node, log = {}, keys = param.type + param.id;
    xxim.nowchat = param;
    
    xxim.chatbox.find('#layim_user'+ keys).find('span:eq(1)')[0].innerHTML='';
    xxim.chatbox.find('#layim_user'+ keys).addClass('layim_chatnow').siblings().removeClass('layim_chatnow');
    xxim.chatbox.find('#layim_area'+ keys).addClass('layim_chatthis').siblings().removeClass('layim_chatthis');
    xxim.chatbox.find('#layim_group'+ keys).addClass('layim_groupthis').siblings().removeClass('layim_groupthis');
    
    xxim.chatbox.find('.layim_face>img').attr('src', param.face);
    xxim.chatbox.find('.layim_face, .layim_names').attr('href', param.href);
    xxim.chatbox.find('.layim_names').text(param.name);
    
    xxim.chatbox.find('.layim_seechatlog').attr('href', config.chatlogurl + param.id);
   
    log.groups = xxim.chatbox.find('.layim_groups');
    if(param.type === 'group'){
        log.groups.show();
    } else {
        log.groups.hide();
    }
    
    $('#layim_write').focus();
    
};

//双击好友是调用
//弹出聊天窗
xxim.popchatbox = function(othis){
    var node = xxim.node, dataId = othis.attr('data-id'), param = {
        id: dataId, //用户ID
        type: othis.attr('type'),
        name: othis.find('.xxim_onename').text(),  //用户名
        face: othis.find('.xxim_oneface').attr('/cap-aco/uploader/uploadfile?pic=8542b9ff73a148eba484b4d3508b16db.png'),  //用户头像
        href: 'profile.html?user=' + dataId //用户主页
    }, key = param.type + dataId;
    if(!config.chating[key]){
        xxim.popchat(param);
        config.chatings++;
        //get the message from local variable
        for(var i=0;i<xxim.tempMsg.length;i++){
        	if(xxim.tempMsg[i].from==dataId){
        		for(var j=0;j<xxim.tempMsg[i].msg.length;j++){
        			xxim.messageRec(xxim.tempMsg[i].msg[j])
        		}
        		xxim.tempMsg[i].msg=[];
        	}
        }
    } else {
        xxim.tabchat(param);
        //get the message from local variable
        for(var i=0;i<xxim.tempMsg.length;i++){
        	if(xxim.tempMsg[i].from==dataId){
        		for(var j=0;j<xxim.tempMsg[i].msg.length;j++){
        			xxim.messageRec(xxim.tempMsg[i].msg[j])
        		}
        		xxim.tempMsg[i].msg=[];
        	}
        }
    }
    config.chating[key] = param;
    
    var chatbox = $('#layim_chatbox');
    if(chatbox[0]){
        node.layimMin.hide();
        chatbox.parents('.xubox_layer').show();
    }

};

//请求群员
xxim.getGroups = function(param){
    var keys = param.type + param.id, str = '',
    groupss = xxim.chatbox.find('#layim_group'+ keys);
    groupss.addClass('loading');
    //获取组员数据
    config.json(config.api.groups, {}, function(datas){
        if(datas.status === 1){
            var ii = 0, lens = datas.data.length;
            if(lens > 0){
                for(; ii < lens; ii++){
                    str += '<li data-id="'+ datas.data[ii].id +'" type="one"><img src="'+ datas.data[ii].face +'" class="xxim_oneface"><span class="xxim_onename">'+ datas.data[ii].name +'</span></li>';
                }
            } else {
                str = '<li class="layim_errors">没有群员</li>';
            }
            
        } else {
            str = '<li class="layim_errors">'+ datas.msg +'</li>';
        }
        groupss.removeClass('loading');
        groupss.html(str);
    }, function(){
        groupss.removeClass('loading');
        groupss.html('<li class="layim_errors">请求异常</li>');
    });
};

/*
 * 接收消息并显示接口
 */
xxim.messageRec = function(msgObj){
	var node = xxim.node, chatter = {},keys,from=msgObj.from;
	if(xxim.nowchat){
		
		var data = {
				content: msgObj.bodytext,
				from:msgObj.from,
				id: xxim.nowchat.id,
				sign_key: '', //密匙
				_: +new Date//TODO
		};
		//此处皆为模拟
		keys = xxim.nowchat.type + msgObj.from;
	    //聊天模版
	    chatter.html = function(param, type){
	        return '<li class="'+ (type === 'me' ? 'layim_chateme' : '') +'">'
	            +'<div class="layim_chatuser">'
	                + function(){
	                    if(type === 'me'){
	                        return '<span class="layim_chattime">'+ varDate(param.time) +'</span>'
	                               +'<span class="layim_chatname">'+ param.name +'</span>'
	                               +'<img src="'+ param.face +'" >';
	                        
	                    } else {
	                        return '<img src="'+ param.face +'" >'
	                               +'<span class="layim_chatname">'+ param.name +'</span>'
	                               +'<span class="layim_chattime">'+ varDate(param.time) +'</span>';      
	                    }
	                }()
	            +'</div>'
	            +'<div class="layim_chatsay">'+ param.content +'<em class="layim_zero"></em></div>'
	        +'</li>';
	    };
	    
	    chatter.imarea = xxim.chatbox.find('#layim_area'+ keys);
	    //if the message belongs to one of the opened chat boxes
	    if(chatter.imarea.length==1){
	    	//append the message to the chatbox(no matter if the message belongs to the now chat user! )
	    	chatter.imarea.append(chatter.html({
	    		time: data._,
	    		name: data.from,
	    		face: config.user.face,
	    		content: data.content
	    	}));
	    	//the message not belongs the current chat box
	    	if(msgObj.from!=xxim.nowchat.id){
	    		//add the unread message number
	    			//get the number
	    		var chatUser= xxim.chatbox.find('.layim_chatlist [data-id="'+msgObj.from+'"]');
	    				//find the senconde span which contains the unread number
	    		var num = $(chatUser).find('span:eq(1)')[0];
	    			//set the number
	    		if(num.innerText==''){
	    			num.innerText = parseInt(1);
	    		}else{
	    			num.innerText = parseInt(num.innerText)+1;
	    		}
	    		var abd=123;
	    	}
	    }else{
	    	//store the message
	    	var tempUserMsg = xxim.tempMsg;
	    	var containFlag = false;
	    	
	    	for(var i=0; i<tempUserMsg.length;i++){
	    		if(tempUserMsg[i].from==from){
	    			tempUserMsg[i].msg.push(msgObj);
	    			containFlag = true;
	    		}
	    	}
	    	if(!containFlag){
    			var userMsgObj={};
    			userMsgObj.from = from;
    			userMsgObj.msg = [];
    			userMsgObj.msg.push(msgObj);
	    		tempUserMsg.push(userMsgObj);
	    	}
	    	//add the msg number in the freinds list
	    	var freind= $(node.list.eq(0)).find('.xxim_childnode[data-id="'+from+'"]');
	    	//get number
	    	var numEle = freind.find('span.unReadMsgNum')[0];
	    	//set number
	    	if(numEle.innerText==''){
	    		numEle.innerText = 1;
	    	}else{
	    		numEle.innerText = parseInt(numEle.innerText)+1;
	    	}
	    }
	    
	}else{
    	//store the message
    	var tempUserMsg = xxim.tempMsg;
    	var containFlag = false;
    	
    	for(var i=0; i<tempUserMsg.length;i++){
    		if(tempUserMsg[i].from==from){
    			tempUserMsg[i].msg.push(msgObj);
    			containFlag = true;
    		}
    	}
    	if(!containFlag){
			var userMsgObj={};
			userMsgObj.from = from;
			userMsgObj.msg = [];
			userMsgObj.msg.push(msgObj);
    		tempUserMsg.push(userMsgObj);
    	}
    	//add the msg number in the freinds list
    	//TODO
    	var freind= $(node.list.eq(0)).find('.xxim_childnode[data-id="'+from+'"]');
    	//get number
    	var numEle = freind.find('span.unReadMsgNum')[0];
    	//set number
    	if(numEle.innerText==''){
    		numEle.innerText = 1;
    	}else{
    		numEle.innerText = parseInt(numEle.innerText)+1;
    	}
		
	}

}

//消息传输
xxim.transmit = function(){
    var node = xxim.node, log = {};
    node.sendbtn = $('#layim_sendbtn');
    node.imwrite = $('#layim_write');
    
    //发送
    log.send = function(){
        var data = {
            content: node.imwrite.val(),
            id: xxim.nowchat.id,
            sign_key: '', //密匙
            _: +new Date
        };

        if(data.content.replace(/\s/g, '') === ''){
            layer.tips('说点啥呗！', '#layim_write', 2);
            node.imwrite.focus();
        } else {
            //此处皆为模拟
            var keys = xxim.nowchat.type + xxim.nowchat.id;
            
            //聊天模版
            log.html = function(param, type){
                return '<li class="'+ (type === 'me' ? 'layim_chateme' : '') +'">'
                    +'<div class="layim_chatuser">'
                        + function(){
                            if(type === 'me'){
                                return '<span class="layim_chattime">'+varDate(param.time)+'</span>'
                                       +'<span class="layim_chatname">'+ param.name +'</span>'
                                       +'<img src="'+ param.face +'" >';
                            } else {
                                return '<img src="'+ param.face +'" >'
                                       +'<span class="layim_chatname">'+ param.name +'</span>'
                                       +'<span class="layim_chattime">'+ varDate(param.time) +'</span>';      
                            }
                        }()
                    +'</div>'
                    +'<div class="layim_chatsay">'+ param.content +'<em class="layim_zero"></em></div>'
                +'</li>';
            };
            
            log.imarea = xxim.chatbox.find('#layim_area'+ keys);
            
            log.imarea.append(log.html({
                time: data._,
                name: config.user.name,
                face: config.user.face,
                content: data.content
            }, 'me'));
            node.imwrite.val('').focus();
            log.imarea.scrollTop(log.imarea[0].scrollHeight);
            
            //send the message web端发送openfire
            connector.sendIMMessage({to:data.id+'@'+globalMsgPushUserDomain,type: 'chat',content:data.content});
            //TODO extend the message
            
//            setTimeout(function(){
//                log.imarea.append(log.html({
//                    time: '2014-04-26 0:38',
//                    name: xxim.nowchat.name,
//                    face: xxim.nowchat.face,
//                    content: config.autoReplay[(Math.random()*config.autoReplay.length) | 0]
//                }));
//                log.imarea.scrollTop(log.imarea[0].scrollHeight);
//            }, 500);
            
            /*
            that.json(config.api.sendurl, data, function(datas){
            
            });
            */
        }
       
    };
 
   
    //发送的事件
    node.sendbtn.on('click', log.send);
    
    node.imwrite.keyup(function(e){
        if(e.keyCode === 13){
            log.send();
        }
    });
};
/*
 * 好友重命名接口
 * @oldName 旧的名字
 * @newName 新的名字
 * @add by zhangdyd
 */
/*xxim.renameFreind =function(oldName,newName){
	
}*/

//事件
xxim.event = function(){
    var node = xxim.node;
    
    //主界面tab
    node.tabs.eq(0).addClass('xxim_tabnow');
    node.tabs.on('click', function(){
        var othis = $(this), index = othis.index();
        xxim.tabs(index);
    });
    
    //列表展收
    node.list.on('click', 'h5', function(){
        var othis = $(this), chat = othis.siblings('.xxim_chatlist'), parentss = othis.find("i");
        if(parentss.hasClass('fa-caret-down')){
            chat.hide();
            parentss.attr('class','fa fa-caret-right');
        } else {
            chat.show();
            parentss.attr('class','fa fa-caret-down');
        }
    });
    
    //设置在线隐身
    node.online.on('click', function(e){
        config.stopMP(e);
        node.setonline.show();
    });
    node.setonline.find('span').on('click', function(e){
        var index = $(this).index();
        config.stopMP(e);
        if(index === 0){
            node.onlinetex.html('在线');
            node.online.removeClass('xxim_offline');
            //TODO send online presence
            connector.sendPresence(2);
        } else if(index === 1) {
            node.onlinetex.html('隐身');
            node.online.addClass('xxim_offline');
            //TODO send offline presence
            connector.sendPresence(1);
        }
        node.setonline.hide();
    });
    
    node.xximon.on('click', xxim.expend);
    node.xximHide.on('click', xxim.expend);
    
    //搜索
    node.xximSearch.keyup(function(){
        var val = $(this).val().replace(/\s/g, '');
        if(val !== ''){
            node.searchMian.show();
            node.closeSearch.show();
            //此处的搜索ajax参考xxim.getDates
            node.list.eq(3).html('<li class="xxim_errormsg">没有符合条件的结果</li>');
        } else {
            node.searchMian.hide();
            node.closeSearch.hide();
        }
    });
    node.closeSearch.on('click', function(){
        $(this).hide();
        node.searchMian.hide();
        node.xximSearch.val('').focus();
    });
    
    //弹出聊天窗
    config.chatings = 0;
    node.list.on('click', '.xxim_childnode', function(e){
		var othis = $(this);
		xxim.popchatbox(othis);
    });
    
    node.addReq.on('click','span:eq(0)',function(e){
    	//show the message
    	var html='<tr>'
    				+'<td>'+'发送者'+'</td>'
    				+'<td>'+'昵称'+'</td>'
    				+'<td>'+'是否同意'+'</td>'
    			+'</tr>';
    	for(var i=0;i<xxim.freindReq.length;i++){
    		html += '<tr>'
				+'<td class="fromTD">'+xxim.freindReq[i]+'</td>'
				+'<td class="nickTD">'+'<input type="text" class="'+xxim.freindReq[i]+'nick'+'">'+'</td>'
				+'<td>'+'<button type="button" class="agree">是</button>'+'<button type="button" class="disagree">否</button>'+'</td>'
			+'</tr>';
    	}
    	var modal = $('#im_add_freind_request');
    	modal.find('#req_list_table')[0].innerHTML=html;
    	modal.modal('show');
    	modal.find('#req_list_table').find('.agree').bind('click',function(){
    		var from = $(this).parent().siblings('.fromTD')[0].innerText;
    		var nick = $(this).parent().siblings('.nickTD').find('input').val();
    		connector.confirmAdd(from,nick,'defaultgroup12');
    	});
    	modal.find('#req_list_table').find('.disagree').click(function(){
    		//var abc=123;
    	});
    	
    });
    
    /*
     * 常用联系人删除事件
     */
    node.list.on('click', '.xxim_childnode_del', function(e){
    	//open a rename modal
    	var clickedNode = e.target;
    	var parentName = $(clickedNode).parent().attr('data-id');
    	connector.delFreind(parentName);
    	config.stopMP(e);
    });    
    
    /*
     * 用户组重命名事件
     */
    node.list.on('click', '.xxim_childnode_group_rename', function(e){
    	config.stopMP(e);
    	//open a group rename modal
    	var clickedNode = e.target;
    	var parentName = $(clickedNode).parent().parent().attr('data-id');
    	$('#im_group_rename').modal('show');
    	var modal = $('#im_group_rename');
    	modal.find('#orignal_name').val(parentName);
    	modal.find('#new_name').val('');
    	
    });
    /*
     * 常用联系人重命名事件
     */
    node.list.on('click', '.xxim_childnode_rename', function(e){
    	config.stopMP(e);
    	//open a rename modal
    	$('#im_freind_rename').modal('show');
    	var clickedNode = e.target;
    	var parentName = $(clickedNode).parent().attr('data-id');
    	//set the value
    	$('#im_freind_rename').find('#orignal_name').val(parentName);
    	var groupName = $(clickedNode).parent().parent().parent().attr('data-id');
    	$('#im_freind_rename').find('#new_name').val('');
    	//set group value
    	$('#im_freind_rename').find('#im_rename_group').val(groupName);
    });
    
    
    //点击最小化栏
    node.layimMin.on('click', function(){
        $(this).hide();
        $('#layim_chatbox').parents('.xubox_layer').show();
    });
    
    
    //document事件
    dom[1].on('click', function(){
        node.setonline.hide();
        $('#layim_sendtype').hide();
    });
};

xxim.setFreids = function(data){
	for(var i=0;i<data.length;i++){
		
	}
}

//设置列表数据
/*
 * add by zhangdyd
 */
xxim.setDatas = function(data){
	var index=0;
	var i = 0, str = '', node = xxim.node, myf = node.list.eq(0);
	myf.addClass('loading');
    for(; i < data.length; i++){
        str += '<li data-id="'+ data[i].id +'" class="xxim_parentnode">'
       //     +'<h5><i class="fa fa-caret-right"></i><span class="xxim_parentname">'+ data[i].name +'</span> <span class="xxim_childnode_group_rename">rename</span> <em class="xxim_nums">('+ data[i].num +')</em></h5>'
            +'<h5><i class="fa fa-caret-right"></i><span class="xxim_parentname">'+ data[i].name +'</span><em class="xxim_nums">('+ data[i].num +')</em></h5>'
            +'<ul class="xxim_chatlist">';
        var item = data[i].item;
        for(var j = 0; j < item.length; j++){
          //str += '<li data-id="'+ item[j].id +'" class="xxim_childnode" type="'+ (index === 0 ? 'one' : 'group') +'"><img src="'+ item[j].face +'" class="xxim_oneface"><span class="xxim_onename" ';
        	str += '<li data-id="'+ item[j].id +'" class="xxim_childnode" type="'+ (index === 0 ? 'one' : 'group') +'"><img src="/cap-aco/uploader/uploadfile?pic=8542b9ff73a148eba484b4d3508b16db.png" class="xxim_oneface"><span class="xxim_onename" ';
        	//add by zhangdyd
        	//deal with the pre-cached presence
        	for(var k=0;k<preCached.length;k++){
        		if(preCached[k]==item[j].name){
        			str += 'style="color:red;"';
        			preCached.splice(k,1);
        		}
        	}
          //str += '>'+ item[j].name +'</span><span class="unReadMsgNum"></span><span class="xxim_childnode_rename">rename</span><span class="xxim_childnode_del">del</span></li>';
        	str += '>'+ item[j].name +'</span><span class="unReadMsgNum"></span></li>';
        }
        str += '</ul></li>';
    }
    myf.html(str);
    myf.removeClass('loading');
}

/*
 * add zhangdyd
 * @userName 好友的唯一标识， 本系统用login name来做唯一标识
 * @add 1是添加好友在线的状态，0是去除好友在线的状态
 */
xxim.setPresence = function(userName,add){
	var i = 0, str = '', node = xxim.node, myf = node.list.eq(0);
	var freind;
	var chatbox;
	//TODO
	if(add=='1'){
		//find the item in the freinds list by user Name
		freind= $(myf).find('.xxim_childnode[data-id="'+userName+'"]');
		//change the status
		if(freind.length>0){
			$(freind).find('span').css('color','red');
		}else{
			preCached.push(userName);
		}
		//find the chatbox
		//there is multi chatbox
		if(config.chatings > 0){
			chatbox= xxim.chatbox.find('.layim_chatlist [data-id="'+userName+'"]');
			if(chatbox.length>0){
				//change the status
				$(chatbox).find('span').css('color','red');
			}
		}
	}else if(add=='0'){
		freind= $(myf).find('.xxim_childnode[data-id="'+userName+'"]');
		//change the status
		if(freind.length>0){
			$(freind).find('span').removeAttr('style');
		}
		//find the chatbox
		//there is multi chatbox
		if(config.chatings > 0){
			chatbox= xxim.chatbox.find('.layim_chatlist [data-id="'+userName+'"]');
			if(chatbox.length>0){
				//change the status
				$(chatbox).find('span').removeAttr('style');
			}
		}
	}
}


//请求列表数据
xxim.getDates = function(index){
    var api = [config.api.friend, config.api.group, config.api.chatlog],
        node = xxim.node, myf = node.list.eq(index);
    myf.addClass('loading');
    //获取列表数据
    config.json(api[index], {}, function(datas){
        if(datas.status === 1){
            var i = 0, myflen = datas.data.length, str = '', item;
            if(myflen > 1){
                if(index !== 2){
                    for(; i < myflen; i++){
                        str += '<li data-id="'+ datas.data[i].id +'" class="xxim_parentnode">'
                            +'<h5><i class="fa fa-caret-right"></i><span class="xxim_parentname">'+ datas.data[i].name +'</span><em class="xxim_nums">（'+ datas.data[i].nums +'）</em></h5>'
                            +'<ul class="xxim_chatlist">';
                        item = datas.data[i].item;
                        for(var j = 0; j < item.length; j++){
                            str += '<li data-id="'+ item[j].id +'" class="xxim_childnode" type="'+ (index === 0 ? 'one' : 'group') +'"><img src="/cap-aco/uploader/uploadfile?pic=8542b9ff73a148eba484b4d3508b16db.png" class="xxim_oneface"><span class="xxim_onename">'+ item[j].name +'</span></li>';
                        }
                        str += '</ul></li>';
                    }
                } else {
                    str += '<li class="xxim_liston">'
                        +'<ul class="xxim_chatlist">';
                    for(; i < myflen; i++){
                        str += '<li data-id="'+ datas.data[i].id +'" class="xxim_childnode" type="one"><img src="'+ datas.data[i].face +'"  class="xxim_oneface"><span  class="xxim_onename">'+ datas.data[i].name +'</span><em class="xxim_time">'+ datas.data[i].time +'</em></li>'; 
                    }
                    str += '</ul></li>';
                }
                myf.html(str);
            } else {
                myf.html('<li class="xxim_errormsg">没有任何数据</li>');
            }
            myf.removeClass('loading');
        } else {
            myf.html('<li class="xxim_errormsg">'+ datas.msg +'</li>');
        }
    }, function(){
        myf.html('<li class="xxim_errormsg">请求失败</li>');
        myf.removeClass('loading');
    });
};

//渲染骨架
xxim.view = (function(){
    var xximNode = xxim.layimNode = $('<div id="xximmm" class="xxim_main">'
            +'<div class="xxim_top" id="xxim_top">'
            +'  <div class="xxim_search"><i class="fa fa-search"></i><input id="xxim_searchkey" /><span id="xxim_closesearch">×</span></div>'
            +'  <div class="xxim_tabs" id="xxim_tabs"><span class="xxim_tabfriend" title="好友"><i class="fa fa-user"></i></span>'
/*            +										'<span class="xxim_tabgroup" title="群组"><i class="fa fa-users"></i></span>'
            +										'<span class="xxim_latechat"  title="最近聊天"><i class="fa fa-clock-o"></i></span>'*/
            +	'</div>'
            +'  <ul class="xxim_list" style="display:block"></ul>'
            +'  <ul class="xxim_list"></ul>'
            +'  <ul class="xxim_list"></ul>'
            +'  <ul class="xxim_list xxim_searchmain" id="xxim_searchmain"></ul>'
            +'</div>'
            +'<ul class="xxim_bottom" id="xxim_bottom">'
	            +'<li class="xxim_online" id="xxim_online">'
	                +'<i class="xxim_nowstate fa fa-check-circle"></i><span id="xxim_onlinetex">在线</span>'
	                +'<div class="xxim_setonline">'
	                    +'<span><i class="fa fa-check-circle"></i>在线</span>'
	                    +'<span class="xxim_setoffline"><i class="fa fa-check-circle"></i>隐身</span>'
	                +'</div>'
	            +'</li>'
	            /* +'<li class="xxim_mymsg" id="xxim_mymsg" title="我的私信"><i class="fa fa-comment"></i><a href="'+ config.msgurl +'" target="_blank"></a></li>'*/
	           /* +'<li class="addReq"><span>请求</span><span class="requeNum"></span></li>'*/
	           /* +'<li class="xxim_seter" id="xxim_seter" title="设置">'
	                +'<i class="fa fa-gear"></i>'
	                +'<div>'
		                +'<span><i class="fa fa-check-circle"></i>在线</span>'
		                +'<span class="xxim_setoffline"><i class="fa fa-check-circle"></i>隐身</span>'
	                +'</div>'
	            +'</li>'*/
	            +'<li class="xxim_hide" id="xxim_hide"><i class="fa fa-exchange"></i></li>'
	            +'<li id="xxim_on" class="xxim_icon xxim_on fa fa-ellipsis-v"></li>'
	            +'<div class="layim_min" id="layim_min"></div>'
            +'</ul>'
         +'</div>');
   dom[3].append(xximNode);
    xxim.renode();
    //xxim.getDates(0);//初始化好友列表
    xxim.event();
    xxim.layinit();
}());
layIMobj = xxim;

function varDate(time){
    var da = time;
	  da = new Date(da);
	 var year = da.getFullYear()+'年';
	 var month = da.getMonth()+1+'月';
	 var date = da.getDate()+'日';
	 var hours = da.getHours()+'时';
	 var minutes = da.getMinutes()+'分';
	 var seconds = da.getSeconds()+'秒';
	 return  year+month+date+hours+minutes+seconds;
  }
}(window);

