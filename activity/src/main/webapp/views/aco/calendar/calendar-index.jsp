<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@ include file="/views/aco/common/head.jsp"%>
<link href='${ctx}/static/cap/plugins/bootstrap/css/style.min.css' rel='stylesheet' />
<link href='${ctx}/views/aco/calendar/fullcalendar/lib/fullcalendar.css' rel='stylesheet' />
<link href='${ctx}/views/aco/calendar/fullcalendar/lib/cupertino/jquery-ui.min.css' rel='stylesheet' />
<link href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/demo.css" />
<link href='${ctx}/views/aco/calendar/fullcalendar/lib/fullcalendar.print.css' rel='stylesheet' media='print' />
<script src='${ctx}/views/aco/calendar/fullcalendar/lib/moment.min.js'></script>
<script src='${ctx}/views/aco/calendar/fullcalendar/fullcalendar.js'></script>
<script src='${ctx}/views/aco/calendar/fullcalendar/lib/jquery-ui.js'></script>
<script src='${ctx}/views/aco/calendar/fullcalendar/lib/jquery-ui.custom.min.js'></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script src="${ctx}/views/aco/docmgt/js/TreeRightClick.js"></script>
<script src="${ctx}/static/cap/plugins/timepicker/js/jquery-ui-timepicker-addon.js"></script> 

<script>
	//是否有节假日
	var isHoliDay = true;
	/** 当天信息初始化 **/
	$(document).ready(function() {
	
		var newDate = '${newDate}';
		var nowDate;
		if(newDate==""){
		 	nowDate = new Date();
		}else{
			nowDate =getDate(newDate);
		}
		var d = nowDate.getDate();
		var m = nowDate.getMonth();
		var y = nowDate.getFullYear();
	    $('#startTime').timepicker({
		   hourGrid: 4,
		   minuteGrid: 10
 		});
      	$('#endTime').timepicker({
		   hourGrid: 4,
		   minuteGrid: 10
 		});
		laydate.skin('dahong');
		todayShow(nowDate);
		$('#calendar').fullCalendar({
			theme: true,
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,agendaWeek,agendaDay'
			},
			height:500,
			year:y,
			month:m,
			lang: 'zh-cn',
			selectable: true,
			selectHelper: true,
			timezone:'local',
			select: function(start, end) {
				var title = '';
				var obj = {};
				obj.start_=start;
				obj.end_=end;
				obj.id='';
				openWindow(obj);
			},eventClick: function(eventData) {
				var obj = {};
				obj.id=eventData.id;
				openWindow(obj);
			},
			editable: true,
			eventLimit: true, // allow "more" link when too many events
			events: {
				url:'${ctx}/bizCalendarController/findAllCalendarByUserId',
				error: function() {
					layerAlert("加载失败请联系管理员");
				}
			},
			eventDrop: function(event){
			//日程拖动改变时候触发
				update_date(event);
			},eventResize: function(event,dayDelta,minuteDelta, revertFunc, jsEvent, ui, view ) {
				update_date(event); 
			},dayClick : function(dayDate, allDay, jsEvent, view) { //点击单元格事件	
				todayShow(dayDate);
			}
		});
		
		function update_date(event) {
			var AjaxURL = "${ctx}/bizCalendarController/doDragCalendar";
			$.ajax({
				type : "POST",
				url : AjaxURL,
				data : {id:event.id.toString(),start:event.start.toString(),end:event.end.toString()},
				success : function(data) {
				},
				error : function(data) {
					layerAlert("error:" + data.responseText);
				}
			});
		};


		function todayShow(dayDate){
		var d = $.fullCalendar.formatDate(dayDate,"dddd");
				var m = $.fullCalendar.formatDate(dayDate,"yyyy年MM月dd日");
				var lunarDate = lunar(dayDate);
				$(".alm_date").html(m + "&nbsp;" + d);
				$(".today_date").html(dayDate.getDate());
				$("#alm_cnD").html("农历"+ lunarDate.lMonth + "月" + lunarDate.lDate);
				$("#alm_cnY").html(lunarDate.gzYear+"年&nbsp;"+lunarDate.gzMonth+"月&nbsp;"+lunarDate.gzDate+"日");
				$("#alm_cnA").html("【"+lunarDate.animal+"年】");
				var fes = lunarDate.festival();
				if(fes.length>0){
					$(".alm_lunar_date").html($.trim(lunarDate.festival()[0].desc));
					$(".alm_lunar_date").show();
				}else{
					$(".alm_lunar_date").hide();
				}
				// 当天则显示“当天”标识
				var now = new Date();
				if (now.getDate() == nowDate.getDate() && now.getMonth() == nowDate.getMonth() && now.getFullYear() == nowDate.getFullYear()){
					$(".today_icon").show();
				}else{
					$(".today_icon").hide();
				}
		}
		
	    $('#saveButton').click(function (){
		 if($('#ff').validationEngine('validate')){
			  start=$('#showStarttime').val();
			  end=$('#showEndtime').val();
			  
			  var startTime = $("#startTime").val();
			  var endTime = $("#endTime").val();
			  $('#starttime').val(start+" "+startTime+":00");
			  $('#endtime').val(end+" "+endTime+":00");
			  var newStartDateTime = $('#starttime').val();
			  var newEndDateTime = $('#endtime').val();
			  //验证小时分钟输入是否正确
			  /*  if(/^((20|21|22|23|[0-1]\d)\:[0-5][0-9])?$/.test("18:06") 
			  		&& /^((20|21|22|23|[0-1]\d)\:[0-5][0-9])?$/.test("13:06")){
			  	layerAlert("时间输入不正确,请重新输入!");
			  	return;
			  } */
			  if(newEndDateTime<newStartDateTime){
			  	layerAlert("开始时间不能大于结束时间");
	/* 		  	$('#starttime').val('');
			  	$('#startTime').val('');
			  	$('#endtime').val('');
			  	$('#endTime').val('');
			  	$('#showEndtime').val('');
		  		$('#showStarttime').val(''); */
			  	return;
			  }else if(newEndDateTime==newStartDateTime){
			 	layerAlert("开始时间不能等于结束时间");
		/* 	 	$('#starttime').val('');
			  	$('#startTime').val('');
			  	$('#endtime').val('');
			  	$('#endTime').val('');
			  	$('#showEndtime').val('');
		  		$('#showStarttime').val(''); */
			  	return;
			  }else{
				 var shiroUser = $("#userId").val();
			   	var AjaxURL= "${ctx}/bizCalendarController/doSaveOrUpdateCalendar";    
                $.ajax({
                    type: "POST",
                    url: AjaxURL,
                    data: $('#ff').serialize(),
                    success: function (data) {
                   	$('#modal_close').click();
					if (data) {
						title=$('#title').val();
						var eventData;
							eventData = {
								id:data.id,
								title: title,
								start: newStartDateTime,
								end: newEndDateTime,
								shiroUser:shiroUser,
								appointUserId:data.appoint_user_,
								appointUserName:data.appoint_user_name
							};
							$('#calendar').fullCalendar( 'removeEvents',data.id);
							$('#calendar').fullCalendar('renderEvent', eventData,true); // stick? = true
							location.reload();
						}else{
							$('#calendar').fullCalendar('unselect');
						}
						$('#myModal').find('.modal-body input').val("");
						$('#myModal').find('.modal-body textarea').val("");
                    },
                    error: function(data) {
                        layerAlert("error:"+data.responseText);
                     }
                });
			 }
        }
	 	});
	 	
	 	$('#deleteCalendar').click(function (){
           	var id=$('#id').val();
           	$('#modal_close').click();          	
           	if(id==null||id==""){
               return;
           	}else{
				$.ajax({
				    url:'bizCalendarController/doDeleteCalendarByUserid',
					type:"GET",
					data:{id:id},
					success:function(data) {
						$('#calendar').fullCalendar( 'removeEvents',id);
					},
					 error: function(data) {
                        layerAlert("error:"+data.responseText);
                     }
				});	
           	}
	 	});
	 	var fcsYear = $("#fcs_date_year").val();
		var fcsMonth = $("#fcs_date_month").val();
	 	initCalendarHoliDay(fcsYear,fcsMonth);
	 	$("#fc-dateSelect").delegate("select","change",function(){
			var fcsYear = $("#fcs_date_year").val();
			var fcsMonth = $("#fcs_date_month").val();
			var temper=fcsYear+"-"+(Number(fcsMonth)+1)+"-01  00:00:00";
			var dt = new Date(temper.replace(/-/,"/"))
			todayShow(dt);
			$("#calendar").fullCalendar('gotoDate', fcsYear, fcsMonth);
			initCalendarHoliDay(fcsYear,fcsMonth);
		});
		$(window).resize(function(){
			var bodyWidth = document.documentElement.clientWidth ||document.body.clientWidth;
			 if(bodyWidth < 735){
				  $(".rightSidePanel").css("display","none");
				  $("#calendar").css("width","100%");
			 }else{
				 $(".rightSidePanel").css("display","block");
				 $("#calendar").css("width","75%");
			 }
		});
	});
$("#myModal").on("show.bs.modal", function () {
	//myModal form表单移除提示信息
	$('#ff').find('div .formError').remove();
})
function CurentTime() { 
    var now = new Date();
    
    var year = now.getFullYear();       //年
    var month = now.getMonth() + 1;     //月
    var day = now.getDate();            //日
    
    var hh = now.getHours();            //时
    var mm = now.getMinutes();          //分
    var ss = now.getSeconds();           //秒
    
    var clock = year + "-";
    
    if(month < 10)
        clock += "0";
    
    clock += month + "-";
    
    if(day < 10)
        clock += "0";
        
    clock += day + " ";

    return(clock); 
}
	

/**
 * 初始化节假日
 */
function initCalendarHoliDay(year,fcsMonth){
	$.ajax({
		type : "POST",
		url : "bizCalendarController/findBizCalendarHolidayDataToTable",
		data:{year:year},
		success : function(data) {
			$("#holidyYear").text(year);
			var tableStr = "<table class='table table-hover table-condensed'>";
			tableStr = tableStr + "<thead><tr><td style='width: 30%'>节日</td><td style='width: 50%;text-align:center;'>节假日时间</td><td style='width: 20%;text-align:center;'>天数</td></tr></thead><tbody>";
			if(data.length>0){
				$.each(data, function(idx, obj) {
					var startDate;
					var startShowDate;
					var endDate;
					var dayNum =obj.HOLIDAY_NUM
					if(obj.HOLIDAY_START_DATE!=null && obj.HOLIDAY_START_DATE!=""){
						startDate=obj.HOLIDAY_START_DATE;
						startShowDate=startDate.substring(5,startDate.length);
						startShowDate = startShowDate.replace("-","/");
					}else{
						startDate="";
						startShowDate="";
					}
					if(obj.HOLIDAY_END_DATE!=null && obj.HOLIDAY_END_DATE!=""){
						endDate=obj.HOLIDAY_END_DATE.substring(5,startDate.length);
						endDate=endDate.replace("-","/");
					}else{
						endDate="";
					}
					if(dayNum!=null && "" !=dayNum){
						tableStr = tableStr + "<tr onClick='toHoliDay(\""+startDate+"\")' title="+isNull(obj.HOLIDAY_REMARK)+"><td style='width: 25%;'>"+ isNull(obj.HOLIDAY_NAME) +"</td>"+"<td style='width: 20%;text-align:center;' title="+startShowDate+"~"+endDate+">"+startShowDate+"~"+endDate + "</td>"+"<td style='width: 10%;text-align:center;'>"+isNull(obj.HOLIDAY_NUM) +"</td></tr>";
					}else{
						tableStr = tableStr + "<tr onClick='toHoliDay(\""+startDate+"\")' title="+isNull(obj.HOLIDAY_REMARK)+"><td style='width: 25%;'>"+ isNull(obj.HOLIDAY_NAME) +"</td>"+"<td style='width: 20%;text-align:center;' title="+startShowDate+">"+startShowDate+"</td>"+"<td style='width: 10%;text-align:center;'></td></tr>";
					}	
				});
				tableStr = tableStr + "</table>";
				$("#holiDayTable").html(tableStr);  
			}else{
				$("#holiDayTable").html(""); 
			/* 	var days = getDays(year,fcsMonth);
				noHoliDayData(days,Number(fcsMonth)+1,year); */
			}
		},
		error : function(data) {
			layerAlert("error:" + data.responseText);
		}
	});
}	

function isNull(str){
	if(str==null){
		return "";
	}else{
		return str;
	}
}

function toHoliDay(holiDayDate){
	var dateArry = holiDayDate.split("-");
	$("#calendar").fullCalendar("gotoDate", dateArry[0], (dateArry[1]-1));
}
function getDate(strDate) { 
  var st = strDate; 
  var a = st.split(" "); 
  var b = a[0].split("-"); 
  var c = a[1].split(":"); 
  var date = new Date(b[0], b[1]-1, b[2], c[0], c[1], c[2]);
  return date; 
} 


//获取某年某月有多少天
function getDays(year,mouth){
	mouth = Number(mouth)+1;
	//定义当月的天数；
	var days ;
	//当月份为二月时，根据闰年还是非闰年判断天数
	if(mouth == 2){
	        days= year % 4 == 0 ? 29 : 28;
	    }
	    else if(mouth == 1 || mouth == 3 || mouth == 5 || mouth == 7 || mouth == 8 || mouth == 10 || mouth == 12){
	        //月份为：1,3,5,7,8,10,12 时，为大月.则天数为31；
	        days= 31;
	    }
	    else{
	        //其他月份，天数为：30.
	        days= 30;
	    }
	    //输出天数
  	return days;
}

//没有录入节假日显示当月所有节日
function noHoliDayData(days,month,year){
	var html="<table><thead><tr><td style='width: 23%;padding-left:5px;'>节日</td><td style='width: 25%;text-align:center;'>节假日时间</td></tr></thead>";
	for(var i=0;i<days;i++){
		var date = new Date(year,month,i);
		var temper=year+"-"+month+"-"+i+" 00:00:00";
		var dt = new Date(temper.replace(/-/,"/"))
		var fes = lunar(dt).festival();
		var day;
		if(i<10){
			day = "0"+i
		}else{
			day = i+"";
		}
		var newMonth;
		if(month<10){
			newMonth = "0"+month;
		}else{
			newMonth = month+"";
		}
		if(fes && fes.length>0){
			html += "<tr><td style='padding-left:5px; text-align:lect;'>"+$.trim(fes[0].desc)+"</td><td style='text-align:center;'>"+year+"-"+newMonth+"-"+day+"</td></tr>";
		}
	}
	html += "</table>";
	$("#holiDayTable").html(html); 
}
</script>
<style>

	body {
		margin: 10px 10px;
		padding: 0;
		font-family:'Microsoft yahei';
		font-size: 14px;
		color:#5c5c5c;
		/*font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;*/
	}
.calendarWrapper {
	/*width: 1090px;*/
	width:100%;
	margin: 0 auto 15px;
	/*boder:1px solid;*/
}
#calendar {
	/*width: 785px;
	background: #fff;
	padding: 15px 10px;*/
	width:75%;
	padding-right:10px;
}
.calendarWrapper .rightSidePanel {
	/*width: 240px;
	padding: 0px 15px;*/
	width:25%;
}
.dib{display: inline-block;}
.fr{float: right;}
.modal-open{
    overflow: hidden ;
}

.ui-timepicker-div .ui-widget-header { margin-bottom: 8px; } 
.ui-timepicker-div dl { text-align: left; } 
.ui-timepicker-div dl dt { height: 25px; margin-bottom: -25px; } 
.ui-timepicker-div dl dd { margin: 0 10px 10px 65px; } 
.ui-timepicker-div td { font-size: 90%; } 
.ui-tpicker-grid-label { background: none; border: none; margin: 0; padding: 0; } 
.ui_tpicker_hour_label,.ui_tpicker_minute_label,.ui_tpicker_second_label, 
.ui_tpicker_millisec_label,.ui_tpicker_time_label{padding-left:20px} 

body.modal-open {
/*页面有滚动条时margin-right:27px;没有滚动条时margin-right:10px;*/
  margin-right:10px;
}
#showEndtime{
	cursor:pointer;
}
#showStarttime{
	cursor:pointer;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body id="body">
	<div id="msgTopTipWrapper" style="display:none">
		<div id="msgTopTip">
			<span><i class="iconTip"></i>正在载入日历数据...</span>
		</div>
	</div>
	<div class="calendarWrapper">
		<div class="rightSidePanel mb50 fr">
			<div id="div_day_detail" class="h_calendar_alm">
				<div class="alm_date"></div>
				<div class="alm_content nofestival">
					<div class="today_icon"></div>
					<div class="today_date"></div>
					<p id="alm_cnD"></p>
					<p id="alm_cnY"></p>
					<p id="alm_cnA"></p>
					<div class="alm_lunar_date"></div>
				</div>
			</div>
			<div class="h_calendar_alm mt10">
				<div class="alm_list"><span id="holidyYear"></span>年度节假日安排</div>
				<div class="alm_list_content" id="holiDayTable">
				</div>
			</div>
		</div>
		<div id="calendar" class="dib"></div>
	</div>
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="myModal"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style="width: 600px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >日程管理</h4>
					<strong>&nbsp;&nbsp;创建人：<input  id="showName" readonly="readonly" type="text" class="calendar-name" style="border: 0px;" value="<shiro:principal property='name'/>"/></strong>
				</div>
				<input id="userName"  type="hidden" value="<shiro:principal property='name'/>" />
				<input id="userId"  type="hidden" value="<shiro:principal property='id'/>" />
				<div class="modal-body">
					<form id="ff" enctype="multipart/form-data" class="form-horizontal "
						target="_top" method="post" action="${ctx}/bizCalendarController/doSaveOrUpdateCalendar">
						<input type="hidden" id="id" name="id"/>
						<input type="hidden" id="createUserId_" name="userId_"/>
						<input type="hidden" id="createUserIdName_" name="userName_"/>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 col-xs-2 control-label" id="ssr" style="text-align: right;display: block;">至</label>
							<label class="col-sm-2 col-xs-2 control-label" id="syr" style="text-align: right;display: none;">使用人</label>
							<div class="col-sm-4 col-xs-4">
								<input id="draftUserId_" class="form-control select" name="appoint_user_"
									type="hidden" style="width: 100%; height: 29; border: 0;" />
								<input id="draftUserIdName_" class="form-control select" name="draftUserIdName_"
									 onclick="peopleTree(1,'draftUserId_')"; 
									 type="text" />
							</div>
							<label class="col-sm-2 col-xs-2 control-label" style="text-align: right;padding-left: 32px">地点</label>
							<div class="col-sm-4 col-xs-4">
								<input id="address" name="address_" type="text" class="form-control" placeholder="请输入地点">
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 col-xs-2 control-label" style="text-align: right;">主题</label>
							<div class="col-sm-10 col-xs-10">
								<input id="title" name="title_" type="text" class="form-control" placeholder="请输入标题">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 col-xs-2 control-label" style="text-align: right;">开始日期</label>
							<div class="col-sm-5 col-xs-5" style="width: 44.33333%">
								<div class="input-group date starttime">
									<input type="hidden" id="starttime" name="startTime_" />
									<input type="text" id="showStarttime" style="width:100px;padding-left:5px;background-color: #fff;"  name="showStarttime" readonly="readonly" class="validate[required] form-control"= onclick="laydate({format: 'YYYY-MM-DD',isclear: false})"/>
									<i class="fa fa-clock-o fa-lg" style="float:left;margin-top:10px;padding-left: 5px;padding-right: 5px;"></i>
									<input type="text" class="validate[required]" style="height: 34px; width:50px; padding-top:5px;border:1px solid #ddd;border-radius:2px;" name="startTime" id="startTime" onchange="timeInputChang();"/>
									<span style="display:block;float:right; margin-right:-75px;margin-top:10px;font-weight: 700;">到</span>
								</div>
							</div>
							<div class="col-sm-5 col-xs-5" style="width: 39%">
								<div class="input-group date endtime" style="float: right;">
									<input type="hidden" id="endtime" name="endTime_" />
									<input type="text" id="showEndtime" style="width:100px;padding-left:5px;background-color: #fff;" name="showEndtime" readonly="readonly" class="validate[required] form-control" onclick="laydate({format: 'YYYY-MM-DD',isclear: false})"/>
									<i class="fa fa-clock-o fa-lg" style="float:left;margin-top:10px;padding-left: 5px;padding-right: 5px;"></i>
									<input type="text" class="validate[required]" style="height: 34px; width:50px; padding-top:5px;border:1px solid #ddd;border-radius:2px;" name="endTime" id="endTime"/> 
								</div>
							</div>
						</div>
						
						<div class="form-group">
							<label class="col-sm-2 col-xs-2 control-label" style="text-align: right;">重要性</label>
							<div class="col-sm-4 col-xs-4">
								<select  id="level" name="level_" class="form-control" size="1" >
										<option value="1">低</option>
					    				<option value="2">中</option>
					    				<option value="3">高</option>
								</select>
							</div>
							<label class="col-sm-2 col-xs-2 control-label" style="text-align: right;padding-left: 32px">提醒</label>
							<div class="col-sm-4 col-xs-4">
								<select  id="remindtime" name="remindTime_" class="validate[required] form-control" size="1" >
					    				<option value="10">10分钟</option>
					    				<option value="15">15分钟</option>
					    				<option value="30">30分钟</option>
					    				<option value="60">60分钟</option>
					    				<option value="90">90分钟</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 col-xs-2 control-label" style="text-align: right;">内容</label>
							<div class="col-sm-10 col-xs-10">
								<textarea id="content" name="content_" style="resize: none;"  rows="4"
									class="form-control"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer" id="btnDiv" align="center">
					<button type="button" class="btn btn-primary btn-sm" id="saveButton">保存</button>
					<button type="button" class="btn btn-primary btn-sm" id="deleteCalendar">删除</button>
					<button type="button" id="modal_close" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
	
<%@ include file="/views/aco/common/selectionPeople_tree.jsp"%>
</body>
</html>
