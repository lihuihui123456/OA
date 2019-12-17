var LEFT;// X轴坐标
var TOP;// Y轴坐标
// 判断是第几列，算出坐标
function getIE(e, colIndex, cul, num, purpose, startTime, endTime,
		applyuserName, status) {
	var statuss;
	if (status == 0) {
		statuss = "已占用";
	} else if (status == 1) {
		statuss = "审批中";
	} else if (status == 2) {
		statuss = "已审批";
	}else{
		statuss = "已停用";
	}
	if (cul - 1 == num) {
		TOP = 40;
	} else {
		TOP = 130;
	}
	if (colIndex == 0) {
		left = 180;
	} else if (colIndex == 1) {
		left = 150;
	} else if (colIndex == 2|| colIndex == 3 ||colIndex == 4) {
		left = 100;
	} else if (colIndex == 9||colIndex == 10|| colIndex == 11) {
		left = -100;
	}else if (colIndex == 13) {
		left = -105;
	} else if (colIndex == 12) {
		left = -105;
	} else {
		left = 0;
	}
	changInnerHTML(purpose, startTime, endTime, applyuserName, statuss);
	
}

function changInnerHTML(purpose, startTime, endTime, applyuserName, status) {

	$('td[name="purpose"]').each(function(n) {
		this.innerHTML = purpose;
	});
	$('td[name="startTime"]').each(function(n) {
		this.innerHTML = startTime;
	});
	$('td[name="endTime"]').each(function(n) {
		this.innerHTML = endTime;
	});
	$('td[name="applyuserName"]').each(function(n) {
		this.innerHTML = applyuserName;
	});
	$('td[name="status"]').each(function(n) {
		this.innerHTML = status;
	});
}

function addpage() {
	/*$('#sunday').datetimepicker().on('changeDate', function(ev){
	  alert(ev);
	});*/
	// 正常申请的会议室弹出内容
	$("td[name='pass']")
			.append(
					function(n) {
						return "<table style='margin-left:20px;' id='dpop' class='popup' width='700px;'>"
								+ "<tbody>"
								+ "<tr>"
								+ "<td class='left'></td>"
								+ "<td><table class='popup-contents' border='0' cellspacing='1'cellpadding='0' style='width: 100%'>"
								+ "<tbody>" + "<tr>" + "<th>会议标题</th>"
								+ "<th>审批状态</th>" + "<th>开始时间</th>"
								+ "<th>结束时间</th>" + "<th>申请人</th>" + "</tr>"
								+ "<tr>" + "<td name='purpose'></td>"
								+ "<td name='status'></td>"
								+ "<td name='startTime'></td>"
								+ "<td name='endTime'></td>"
								+ "<td name='applyuserName'></td>" + "</tr>"
								+ "</tbody>" + "</table></td>"
								+ "<td class='right'></td>" + "</tr>"
								+ "</tbody>" + "</table>";
					});
	// 会议室被提前预定时弹出框内容
	$("td[name='disable']")
			.append(
					function(n) {
						return "<table id='dpop' class='popup' width='500px'>"
								+ "<tbody>"
								+ "<tr>"
								+ "<td class='left'></td>"
								+ "<td><table class='popup-contents' border='0' cellspacing='1'cellpadding='0' style='width: 100%'>"
								+ "<tbody>" + "<tr>" + "<th>会议室状态</th>"
								+ "<th>停用开始时间</th>" + "<th>停用结束时间</th>"
								+ "</tr>" + "<tr>" + "<td name='status'></td>"
								+ "<td name='startTime'></td>"
								+ "<td name='endTime'></td>" + "</tr>"
								+ "</tbody>" + "</table></td>"
								+ "<td class='right'></td>" + "</tr>"
								+ "</tbody>" + "</table>";
					});

}

function change(action) {
	var sunday = document.getElementById("sunday").value;
	var url = 'roomUsed/findRoomBoard?sunday=' + sunday + '&action=' + action;
	$('#myff').attr("action", url).submit();
}

//会议室申请
function applyRoom(roomid, roomname, date, isAmOrPm) {
	var starttime;
	var endtime;
	if (isAmOrPm == '0') {
		starttime = date + " 09:00:00";
		endtime = date + " 11:30:00";
	} else {
		starttime = date + " 14:00:00";
		endtime = date + " 16:30:00";
	}
	$('#roomid').val(roomid);
	$('#roomname').val(roomname);
	$('#starttime').val(starttime);
	$('#endtime').val(endtime);
	$('#myModal').modal({
		backdrop : 'static',
		keyboard : false
	});
}

function submitForm(form, valid){
	var startTime = $("#starttime").val();
	var endTime = $("#endtime").val();
	var meetingname = $("#meetingname").val();
	if(valid){
		if(startTime > endTime){
			layerAlert("开始时间不能大于结束时间！");
			return;
		}else{
			var model = '送交';
			var url = "roomApply/doSaveRoomApply/"+model;
			$.ajax({
				type : 'post',
				url : url,
				data : $('#ff').serialize(),
				async: false,
				beforeSend:function(){
					$("#savebutton").attr("disabled","disabled");
				},
				success : function(data) {
					if(data == 'true'){
						var path = 'roomUsed/findRoomBoard';
						$('#myff').attr("action", path).submit();
					}else{
						layerAlert("数据保存失败！");
					}
				},
				complete: function(){
					$("#savebutton").removeAttr("disabled");
				}
			});
		}
	}
	$("#savebutton").removeAttr("disabled");
}

function roomRefresh(){
	/*location.reload();  */
	window.location.href=window.location.href
}

function showDate(date){
	var url = 'roomUsed/findRoomBoard?sunday=' + date;
	$('#myff').attr("action", url).submit();
}

$(function() {
	laydate.skin('dahong');
	//模态框关闭移除提示信息
	$("#myModal").on("show.bs.modal", function () {
		$('#ff').find('div .formError').remove();
	})
	$('#sunday').bind('input propertychange', function() { 
		var date = $("#sunday").val();
		showDate(date);
	}); 
	
	addpage();
	$('.bubbleInfo').each(function() {
		var distance = 10;
		var time = 250;
		var hideDelay = 10;
		var hideDelayTimer = null;
		var beingShown = false;
		var shown = false;
		var trigger = $('.trigger', this);
		var info = $('.popup', this).css('opacity', 0);
		var bubble_top = this.offsetTop;
		var bubble_left = this.offsetLeft;
		$([ trigger.get(0), info.get(0) ]).mouseover(function() {

			if (hideDelayTimer)
				clearTimeout(hideDelayTimer);
			if (beingShown || shown) {
				return;
			} else {
				beingShown = true;
				var bubble_left1 = bubble_left - info.width() / 2;
				var all_width = document.body.clientWidth;
				if (bubble_left1 > all_width - info.width())
					bubble_left1 = all_width - info.width();
				info.css({
					top : bubble_top + TOP - info.height(),
					left : bubble_left1 + left,
					display : 'block'
				}).animate({
					top : '-=' + distance + 'px',
					opacity : 1
				}, time, 'swing', function() {
					beingShown = false;
					shown = true;
				});
			}
			return false;
		}).mouseout(function() {
			if (hideDelayTimer)
				clearTimeout(hideDelayTimer);
			hideDelayTimer = setTimeout(function() {
				hideDelayTimer = null;
				info.animate({
					top : '-=' + distance + 'px',
					opacity : 0
				}, time, 'swing', function() {
					shown = false;
					info.css('display', 'none');
				});

			}, hideDelay);
			return false;
		});
	});
	
	//开启表单验证引擎(修改部分参数默认属性)
	$('#ff').validationEngine({
		promptPosition:'topRight', //提示框的位置 
		autoHidePrompt:true, //是否自动隐藏提示信息 默认为false
		autoHideDelay:100000, //自动隐藏提示信息的延迟时间 (ms)
		maxErrorsPerField:false,//单个元素显示错误提示的最大数量，值设为数值。默认 false 表示不限制。
		showOneMessage:false, //是否只显示一个提示信息
		onValidationComplete:submitForm,//表单提交验证完成时的回调函数 function(form, valid){}，参数：form：表单元素 valid：验证结果（ture or false）使用此方法后，表单即使验证通过也不会进行提交，交给定义的回调函数进行操作。
	});
});

function delRoomUsingById(roomApplyId){
	layer.alert('确认删除会议吗？', {
		  closeBtn: 1  // 是否显示关闭按钮
		  ,anim: 1 //动画类型
		  ,btn: ['是','否'] //按钮
		  ,icon: 2  // icon
		  ,yes:function(){
				$.ajax({
					type : "POST",
					url : "roomUsed/delRoomUsingById",
					async:false,
					dataType:'text',
					data:{
						"roomApplyId":roomApplyId
					},
					success : function(data) {
						if(data=="0"){
							window.location.reload();
						}else{
							layerAlert("删除失败!");
						}
					},
					error : function(data) {
					}
				});
		  }
		  ,btn2:function(){
		   
		  }
	  });
}