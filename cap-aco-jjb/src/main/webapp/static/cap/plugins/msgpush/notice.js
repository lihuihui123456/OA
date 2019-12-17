/*
 * global variable for remind message
 * */

//the element id of the push-notice on the page
var pageElementId={
		noticeBoard: 'msgs_display_board',
		noticeListId:'instantmessage'
		
}
//the notice connection, this should initialize in the document ready
var notice=null;
//the notice number should keep in the remind message drop menu.
var keepNoticesNum=10;
//keep the notice order
var noticeOrder = 0;
//the notice list frame id, eg:msgpush_list, the id in the 'index.jsp' would be 'msgpush_list'
var noticeListFrameId = 'msgpush_list';
//the frame id prefix in the 'index.jsp'.
var indexFrameIdPrifix = 'frame';
//bell flick flag-variable
var bellFlickFlag = true;
//bell flick stop-variable
var bellFilckStop = false;
//if beyond the number, the notice board can be scrolled
var noticeNumNoScroll = 4;

jQuery.support.cors = true;
$(document).ready(function () {
	setUnreadNoticeNum(0);
	//if true then show the layeralert(xx) remind, then hide
	var debug = false;
	var userInfor = {
			username : globalLoginName,
			domain : globalMsgPushUserDomain,
			resource : globalMsgPushUserResource,
			pass : '123'
	};
	var serverAddr = globalMsgPushServerAddr;
	
	var callbackFunctions = {
			showMessage : connector.showMessage,
			showNotice : showNotice,
			queryResult : {
				getunread: showNotice,
				ignoreall: myIgnoreAll,
				getnoticelist : myGetNoticeList,
				setRead : mySetRead,
				getRoster : connector.myGetRoster,
				getPresence: connector.myGetPresence
			}
	};
	
	var connectionFuns = {
			disConnecting : myDisConnecting,
			onDisconnect : myOnDisconnect,
			connecting : myConnecting,
			onConnect : myOnConnect
	};
	try{
		//alert('excute the notice push, create a new connection!');
		notice = new Notice(userInfor,serverAddr,connectionFuns,callbackFunctions,debug);
		notice._start();//启动连接
	}catch(err){
		//alert(123);
	}
	globalMsgPushConnection = notice;//set the global push message connection.
	//initialize the message remind
	$('#instantmessage a i').bind('click', function() {
		refreshAllTime();
	});
});
	/*
	 * the call back function for the connecting time
	 */
	function myConnecting(){
		bellFlickFlag=false;
		//bellFlick('con');
	}
	
	/*
	 * the call back function for the disconnecting
	 */
	function myDisConnecting(){
		bellFlickFlag=false;
		//bellFlick('disCon');
	}
	
	/*
	 * the notice bell flick function
	 */
	function bellFlick(state){
		bellFilckStop=false;
		var belli = $('#'+pageElementId.noticeListId).find('a i');
		var timer = setInterval(function (){
			if(belli.css('color')=='rgb(153, 153, 153)'){
				belli.css({color:""});
			}else{
				belli.css({color: "#999;"});
			}
			
			if(bellFlickFlag){
				 clearInterval(timer);    //清除定时器
				 bellFilckStop=true;
				 if(state=='disCon'){
					 $('#'+pageElementId.noticeListId).find('a i').css({color:"#999;"});
				 }else{
					 $('#'+pageElementId.noticeListId).find('a i').css({color:""});
				 }
			}
		},500);
	}
	
	/*
	 * 当连接中断调用的回调的函数
	 */
	function myOnDisconnect(){
		//layerAlert("消息推送连接中断，请在闲暇时间重新登录，获取连接！");
		//TODO change the notice bell
		bellFlickFlag=true;
		$('#'+pageElementId.noticeListId).find('a i').css({color: "#999;"});
	}
	/*
	 * 当连接成功后的回调函数
	 */
	function myOnConnect(){
		//change the notice bell
		bellFlickFlag=true;
		$('#'+pageElementId.noticeListId).find('a i').css({color:""});
	}
	/*
	 * 忽略全部消息操作回调函数
	 */
	function mySetRead(sysCode,noticeId,failtext,failReason){
		if(failtext=='1'){
			//layerAlert("忽略所有成功！");
			//find the notice by sysCode and noticeId
			var item = $('#msgs_display_board').find('#'+sysCode+noticeId );
			var flag=false;
			if($(item).css('display')!='none'){
				flag=true;
			}
			//remove the notice
			item.remove();
			var currentNum = getUnreadNoticeNum();
			var newTotal = parseInt(currentNum)-1;
			setUnreadNoticeNum(newTotal);
			if(flag){
				//if the deleted item is not hide
				//show the hide notices
				var hidenotices = $('#msgs_display_board').find('.newTempClass:hidden');
				if(hidenotices!=null){
					//delete the display: listitem elements
					for(var i=0 ; i< hidenotices.length ; i++){
						if($(hidenotices[i]).css('display')!='none'){
							hidenotices.splice(i,1);
							i--;
						}
					}
					var orderlist = getOrderList(hidenotices);
					$('#msgs_display_board').find(' .'+'order' + orderlist[orderlist.length-1]).show();
				}
			}
		}else{
			layerAlert("设置已读不成功！");
		}
	}
	
	/*
	 * 忽略全部消息操作回调函数
	 */
	function myIgnoreAll(failtext,failReason){
		if(failtext=='1'){
			var notices = $('#msgs_display_board').find('.newTempClass');
			if(notices!=null&&notices.length>0){
				$('#msgs_display_board').find('.newTempClass').remove();
				setUnreadNoticeNum(0);
				noticeOrder = 0;
			}
			layerAlert("忽略所有成功！");
		}else{
			layerAlert("忽略所有不成功！");
		}
	}
	/*
	 * 获取消息通知列表回调函数
	 * 调用消息列表页的bootstrap
	 */
	function myGetNoticeList(jsonString){
		var table = document.frames[indexFrameIdPrifix+noticeListFrameId].pushMsgListTable;
		var temp = $.parseJSON(jsonString);
		table.bootstrapTable('load',temp);
	}
	/*
	 * 设置未读消息数目
	 */
	function setUnreadNoticeNum(number){
		if(parseInt(number)>0){
    		var buttn=$('#instantmessage').children('a').find('span');
    		if(buttn.length==1){
    			$(buttn).text(number);
    			$(buttn).show();
    			$('#msgs_display_board').find('.title span').text('您有'+number+'条消息');
    		}
		}else{
    		var buttn=$('#instantmessage').children('a').find('span');
    		if(buttn.length==1){
    			$(buttn[0]).text(0);
    			$(buttn[0]).hide();
    			$('#msgs_display_board').find('.title span').text('您有'+0+'条消息');
    		}
		}
	}
	/*
	 * 获取未读消息数目
	 */
	function getUnreadNoticeNum(){
		var buttn=$('#instantmessage').children('a').find('span');
		if(buttn.length==1){
			var num = $(buttn).text();
			return num;
		}else return 0;
	}
	/*
	 * 展示消息
	 */
	function showNotice(json,sysCode,sysNoticeId){
		//处理cap-aco的发来的消息
		if(sysCode=='cap-aco'){//只处理由‘cap-aco’系统发来的信息
			//add message to the front page
			if(json!=null){
				var sender = json.sender;
				var senderPicUrl = json.senderPicUrl;
				var title = json.title;
				var noticeId = json.noticeId;
				var noticeType = json.type;
				var noticeTime = json.sendTime;
				var tabUrl = json.url;
				var tabText = json.tabTitle;
				var tabid = json.tabId;
				//check the title
				if(title!=null&&title!=''){
					var itemBlock = $('#noticeItem').clone(true);
					itemBlock.attr('id',sysCode+sysNoticeId);
					//add new class name
					var order= 'order' + (noticeOrder++);
					itemBlock.addClass('newTempClass');
					itemBlock.addClass(order);
					itemBlock.find('.name').text(sender);
					itemBlock.find('.con').text(title);
					//1：通知公告  2：传阅件  3：传阅  4：传阅事项  5：收文  6：发文
					switch(noticeType){
					case "1": 
						itemBlock.find('.info .typephoto').attr('src',globalPath+'/static/cap/plugins/msgpush/images/notice.png');
						itemBlock.find('.info .type').text('通知公告');
						//alert('new notice incoming!' +'the frame ready = ' +noticeiFrameReady);
						if(noticeiFrameReady){
							//TODO call the iframe refresh
							//var noticeFrame = document.getElementById('notice_iframe');
							var noticeFrame = $('#framehome')[0].contentWindow.$('#notice_iframe');
							if(noticeFrame!=null){
								noticeFrame[0].contentWindow.Flow.init();
							}
					}
					break;
				case '2': 
					itemBlock.find('.info .typephoto').attr('src',globalPath+'/static/cap/plugins/msgpush/images/circulationfile.png');
					itemBlock.find('.info .type').text('传阅件');
					break;
				case '3':
					itemBlock.find('.info .typephoto').attr('src',globalPath+'/static/cap/plugins/msgpush/images/circulation.png');
					itemBlock.find('.info .type').text('传阅 ');
					if(todoiFrameReady){
						//TODO call the iframe refresh
						//var noticeFrame = document.getElementById('notice_iframe');
						var todoFrame = $('#framehome')[0].contentWindow.$('#todo_iframe');
						if(todoFrame!=null){
							todoFrame[0].contentWindow.init();
						}
					}
					break;
				case '4':
					itemBlock.find('.info .typephoto').attr('src',globalPath+'/static/cap/plugins/msgpush/images/circulationevent.png');
					itemBlock.find('.info .type').text('传阅事项');
					break;
				case '5':
					itemBlock.find('.info .typephoto').attr('src',globalPath+'/static/cap/plugins/msgpush/images/recfile.png');
					itemBlock.find('.info .type').text('收文 ');
					break;
				case '6':
					itemBlock.find('.info .typephoto').attr('src',globalPath+'/static/cap/plugins/msgpush/images/sendfile.png');
					itemBlock.find('.info .type').text('发文 ');
					if(todoiFrameReady){
						//TODO call the iframe refresh
						//var noticeFrame = document.getElementById('notice_iframe');
						var todoFrame = $('#framehome')[0].contentWindow.$('#todo_iframe');
						if(todoFrame!=null){
							todoFrame[0].contentWindow.init();
						}
					}
					break;
				default: ;
				}
				//用户头像 /cap-aco/uploader/uploadfile?pic=
				if(senderPicUrl!=''){
					itemBlock.find('#senderPicImg').attr('src',globalPath+'/uploader/uploadfile?pic='+senderPicUrl);
				}else{
					//itemBlock.find('#senderPicImg').attr('src','');					
				}
				itemBlock.find('.info .realtime').text(noticeTime);
					//ignore the notice
					itemBlock.find('.operation').click(function(){
						notice._setRead(sysCode,sysNoticeId);
						/*					itemBlock.remove();
					var currentNum = getUnreadNoticeNum();
					var newTotal = parseInt(currentNum)-1;
					setUnreadNoticeNum(newTotal);
					//show the hide notices
					var hidenotices = $('#msgs_display_board').find('.newTempClass:hidden');
					if(hidenotices!=null){
						var orderlist = getOrderList(hidenotices);
						$('#msgs_display_board').find(' .'+'order' + orderlist[orderlist.length-1]).show();
					}*/
					});
					//double click to show the new tab
					//at the same time set the notice read
					itemBlock.find('.box-con').dblclick(function(item){
						notice._setRead(sysCode,sysNoticeId);
						/*					itemBlock.remove();
					var currentNum = getUnreadNoticeNum();
					var newTotal = parseInt(currentNum)-1;
					setUnreadNoticeNum(newTotal);
					//show the hide notices
					var hidenotices = $('#msgs_display_board').find('.newTempClass:hidden');
					if(hidenotices!=null){
						var orderlist = getOrderList(hidenotices);
						$('#msgs_display_board').find(' .'+'order' + orderlist[orderlist.length-1]).show();
					}*/
						//create a new tab
						var options={
								"text":tabText,
								"id": tabid,
								"href":tabUrl,
								"pid":window
						};
						window.parent.createTab(options);
						$('#instantmessage a i').click();
					});
					
					itemBlock.show();
					var num = getUnreadNoticeNum();
					var total = parseInt(num)+1;
					setUnreadNoticeNum(total);
					itemBlock.insertAfter('#msgs_display_board_title');
					//check if the Notices in the list larger than 'keepNoticesNum',then hide the 10th notice;
					var noticesList = $('#msgs_display_board').find('.newTempClass');
					if(noticesList!=null&&noticesList.length>keepNoticesNum){
						//get the order list class
						var orderList = getOrderList(noticesList);
						$('#msgs_display_board').find(' .'+'order' + orderList[orderList.length-keepNoticesNum-1]).hide();
						/*				for(var i=0; i< orderList.length-keepNoticesNum; i++ ){
					var hideclass = 'order' + orderList[i];
					//alert(hideclass + '   hide!');
					$('#msgs_display_board').find(' .'+hideclass).hide();
				}*/
					}
					//refresh the time of all notice
					refreshAllTime();
					//set the height of the notice board
					setNoticeBoardHeight();
					
				}
			}
		}
	}
	function setNoticeBoardHeight(){
		var abd = $('#instantmessage');
		var num = getUnreadNoticeNum();
		var num1 = $('#msgs_display_board').css('height');
		if(num<=noticeNumNoScroll){
			var boardHeight = (60+100*num + 50)+'px';
			$('#msgs_display_board').css('height',boardHeight);
		}
	}
	/*
	 * empty all the notices on the page
	 */
	function emptyAllNotice(id){
		$('#'+id).find('.newTempClass').remove();
		noticeOrder = 0;
		setUnreadNoticeNum(0);
	}
	/*
	 * 设置某条消息已读，
	 * 先在消息中搜索消息，如果有就发送已读请求到消息推送平台
	 */
	function setReadNotice(sysCode,sysNoticeId){
		//find the notice
		var item = $('#msgs_display_board').find('#'+sysCode+sysNoticeId );
		if(item.length==1){
			//the select notice has been not ignored
			notice._setRead(sysCode,sysNoticeId);
		}
	}
	
	/*
	 * refresh the notice time
	 * */
	function refreshAllTime(){
		var noticesTime = $('#msgs_display_board .newTempClass .info ');
		var noticeTime='';
		var currTimeNum = new Date().getTime();
		for(var i=0; i<noticesTime.length; i++){
			noticeTime = noticesTime[i];
			var time = $(noticeTime).find('.realtime').text();
			$(noticeTime).find('.showtime').text(formatTime(time,currTimeNum));
		}
	}
	/*
	 * 格式化时间
	 */
	function formatTime(noticeTime, currTimeNum){
		//alert(noticeTime);
		var endTime =  noticeTime.replace(/-/g,"/");
		var endTimeNum = new Date(endTime).getTime();
		var seconds = parseInt((currTimeNum - endTimeNum)/1000);
		if(seconds<60){
			return seconds + '秒前';
		}else {
			var minutes = seconds/60;
			if(minutes<60){
				return parseInt(minutes) + '分钟前';
			}else{
				var hour = minutes/60;
				if(hour<24){
					return parseInt(hour) + '小时前';
				}else{
					var days = hour/24;
					return parseInt(days) + '天前';
				}
			}
		}
	}
	/*
	 * 获取顺序列表
	 */
	function getOrderList(noticesList){
		var orderList = [];
		for(var i=0; i< noticesList.length; i++ ){
			var orderclass = $(noticesList[i]).attr('class');
			var temp = orderclass.substring(orderclass.length-1);
			orderList.push(parseInt(temp));
		}
		orderList.sort(function(a,b){
			return a-b;
		});
		return orderList;
	} 
	
	/**
	 * ignore all notices 
	 */
	function ignoreAllNotice(){
		var notices = $('#msgs_display_board').find('.newTempClass');
		if(notices!=null&&notices.length>0){
			notice._ignoreAll();
		}
	}
	/*
	 * 创建消息推送标签页
	 */
	function createMsgPushTab(){
		var options={
				"text":"推送消息",
				"id": noticeListFrameId,
				"href":"msgpush/toMsgList",
			    "pid":window
		};
		window.parent.createTab(options);
		//click the bell to up the drop msg menu
		$('#instantmessage').click();
	}
	/*
	 * 连接中断调用的方法
	 * */
	function noticOnNetworkInterrupt(){
		myOnDisconnect();
	}
	/*
	 * 连接恢复调用的方法
	 * */
	function noticeOnNetworkResume(){
		//first, check the notice switch button
		var switchBtn = $('#noticeSwitchBtn');
		if(switchBtn!=null&&switchBtn.length==1){
			if($('#noticeSwitchBtn').attr('myValue')=='on'){
				emptyAllNotice(pageElementId.noticeBoard);
				notice._start();
			}
		}
	}
	
	/**
	 * show the instant messages
	 */
	function showMessage(msg){
		//log('ECHOBOT: I got a message from ' + "luss"+ ': ' + msg);

	}