<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>会议室预定申请</title>
<%@ include file="/views/aco/common/head.jsp"%>
 <link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<!-- 引入 jQuery-Validation-Engine css -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/jquery/jQuery-Validation-Engine-2.6.2/css/validationEngine.jquery.css">
<!-- end -->
<link rel="stylesheet" type="text/css" href="${ctx}/views/aco/meetingroom/css/meetingroomboard.css">
<script type="text/javascript" src="${ctx}/static/cap/plugins/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${ctx}/views/aco/meetingroom/js/meetingroomboard.js"></script>
<!-- 引入jQuery-Validation-Engine js -->
<script type="text/javascript" src="${ctx}/static/cap/plugins/jquery/jQuery-Validation-Engine-2.6.2/js/jquery.validationEngine.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/jquery/jQuery-Validation-Engine-2.6.2/js/jquery.validationEngine-zh_CN.js"></script>
<!-- end -->
<script src="${ctx}/static/cap/plugins/bootstrap/js/bootstrap.min.js"></script>
<!-- 日期日历 -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<title>会议室预定</title>
<body>
<div class="panel-body" style="padding:10px;">
	<div class="date_set">
		<button class="btn btn-default" onClick="change('last')" ><i class="fa fa-caret-left"></i> 上一周</button>
		<div class="input-group date date-choose">
			<input type="text" id="sunday"  value="${sunday }" class="form-control" onclick="laydate({istime: true, format: 'YYYY-MM-DD'})">
		</div>  
		<span class="zhi">至</span>
		<div class="date-choose">
			<input type="text" id="saturday" readonly="readonly" value="${saturday }" onmousedown="return false"; class="form-control" >
		</div>
		<button class="btn btn-default" onClick="change('next')" style="margin-left:10px">下一周 <i class="fa fa-caret-right"></i></button>
		<button class="btn btn-default" onClick="roomRefresh();" style="margin-left:10px"><i class="fa fa-refresh"></i>刷新 </button>
	</div>
	<div class="rom_state">
		<span>日期已过：灰色</span>
		<span>可申请：白色</span>
		<span>已占用：<img src="${ctx}/views/aco/meetingroom/images/zy2.png" class='trigger' /></span>
		<span>审核中：<img src="${ctx}/views/aco/meetingroom/images/ch.png" class='trigger' /></span>
	</div>

<form id="myff" target="_self" method="post">
	<div style="width: 100%; overflow: hidden">
		<div align="center">
			<table id="table_hy" cellpadding="0" cellspacing="1" align="center">
				<tr>
					<td rowspan="3" class="td1">会议室/时间</td> 
					<td id="nowTime0" colspan="2" class="td1"></td>
					<td id="nowTime1" colspan="2" class="td1"></td>
					<td id="nowTime2" colspan="2" class="td1"></td>
					<td id="nowTime3" colspan="2" class="td1"></td>
					<td id="nowTime4" colspan="2" class="td1"></td>
					<td id="nowTime5" colspan="2" class="td1"></td>
					<td id="nowTime6" colspan="2" class="td1"></td>
				</tr> 
				<tr>
					<td colspan="2" class="td1" id="day1">星期日</td>
					<td colspan="2" class="td1" id="day2">星期一</td>
					<td colspan="2" class="td1" id="day3">星期二</td>
					<td colspan="2" class="td1" id="day4">星期三</td>
					<td colspan="2" class="td1" id="day5">星期四</td>
					<td colspan="2" class="td1" id="day6">星期五</td>
					<td colspan="2" class="td1" id="day7">星期六</td>
				</tr>
			
				<tr>
					<td class="td2">上午</td>
					<td class="td2">下午</td>
					<td class="td2">上午</td>
					<td class="td2">下午</td>
					<td class="td2">上午</td>
					<td class="td2">下午</td>
					<td class="td2">上午</td>
					<td class="td2">下午</td>
					<td class="td2">上午</td>
					<td class="td2">下午</td>
					<td class="td2">上午</td>
					<td class="td2">下午</td>
					<td class="td2">上午</td>
					<td class="td2">下午</td>
				</tr>
				<c:forEach items="${map }" var="map" varStatus="dt">
					<tr>
						<td style='background: #FFFFFF;' align="right">${map.key }</td>
						<c:forEach items="${map.value }" var="map1" varStatus="dt1">
							<c:set value="${roomList }" var="roomList" />
							<c:set value="${roomList.get(dt.index).getId() }" var="roomid" />
							<c:set value="${time }" var="time" />
							<c:set value="${time[dt1.index]}" var="time1" />
							<c:set value="${dt1.index % 2}" var="isAmOrPm"></c:set>
							<c:set value="${nowTime }" var="nowTime"></c:set>
							<c:set value="${nowTime.substring(0,10) }" var="todayDate"></c:set>
							<c:set value="${nowTime.substring(11,19) }" var="nowtime"></c:set>
							<c:if test="${map1 != null}">
								<c:forEach items="${map1}" var="list">
									<c:set value="${list.purpose}" var="purpose"></c:set>
									<c:set value="${list.meeting_name }" var="meetingname"></c:set>
									<c:set value="${list.start_time }" var="startTime"></c:set>
									<c:set value="${list.end_time }" var="endTime"></c:set>
									<c:set value="${list.apply_user }" var="applyuserName"></c:set>
									<c:set value="${list.status}" var="status"></c:set>
									<c:choose>
										<c:when test="${time1.substring(0,10)<todayDate }">
											<td style='background: #F1F1F1;' onmouseover="title='日期已过'"></td>
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${status == '1' }">
													<td class='bubbleInfo' style="cursor: pointer;" name="pass" title="点击删除申请会议！" onclick="delRoomUsingById('${list.roomapply_id}');"><img
														src="${ctx}/views/aco/meetingroom/images/ch.png" class='trigger'
														onmouseover="getIE(this,'${dt1.index}','${roomList.size() }','${dt.index }','${meetingname }','${startTime }','${endTime }','${applyuserName }','${status }')" /></td>
												</c:when>
												<c:otherwise>
													<td class='bubbleInfo' name="pass"><img
														src="${ctx}/views/aco/meetingroom/images/zy2.png" class='trigger'
														onmouseover="getIE(this,'${dt1.index}','${roomList.size() }','${dt.index }','${meetingname }','${startTime }','${endTime }','${applyuserName }','${status }')" /></td>
												</c:otherwise>
											</c:choose>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</c:if>
							<c:if test="${map1 == null }">
								<c:if test="${time1.substring(0,10)<todayDate }">
									<td style='background: #F1F1F1;' onmouseover="title='日期已过'"></td>
								</c:if>
								<c:if test="${time1.substring(0,10)==todayDate }">
									<c:if test="${nowtime<='11:59:59' }">
										<td style='background: #FFFFFF;' onmouseover="title='点击申请会议室'"
											onclick="applyRoom('${roomid}','${map.key}','${time1.substring(0,10)}','${isAmOrPm }')"></td>
									</c:if>
									<c:if test="${nowtime>='12:00:00' }">
										<c:if test="${isAmOrPm == '0' }">
											<td style='background: #f2f4f8;' onmouseover="title='日期已过'"></td>
										</c:if>
										<c:if test="${isAmOrPm == '1' }">
											<td style='background: #FFFFFF;'
												onmouseover="title='点击申请会议室'"
												onclick="applyRoom('${roomid}','${map.key}','${time1.substring(0,10)}','${isAmOrPm }')"></td>
										</c:if>
									</c:if>
								</c:if>
								<c:if test="${time1.substring(0,10)>todayDate }">
									<td style='background: #FFFFFF;' onmouseover="title='点击申请会议室'"
										onclick="applyRoom('${roomid}','${map.key}','${time1.substring(0,10)}','${isAmOrPm }')"></td>
								</c:if>
							</c:if>
						</c:forEach>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
	</form>
</div>
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style="width: 750px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" style="text-align:left;">会议室申请</h4>
				</div>
				<div class="modal-body">
						<form id="ff" action="" method="post"
							enctype="multipart/form-data" class="form-horizontal "
							target="_top">
							<input type="hidden" id="roomid" name="room_id">
							<div class="row">
								<div class="form-group has-feedback col-sm-12">
									<label style="text-align: right;" class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label " for="meetingname"><span class="red">*</span>会议标题 </label>
									<div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
										<input type="text" id="meetingname" name="meeting_name"
											class="form-control validate[required]">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="form-group col-sm-12">
									<label style="text-align: right;" class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label" for="">会议室名称</label>
									<div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
										<input type="text" id="roomname" readonly="readonly" class="form-control">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="form-group has-feedback col-sm-12">
									<label style="text-align: right;" class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label" for="starttime"><span class="red">*</span>开始时间 </label>
									<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 starttime">
										<input type="text" id="starttime" name="starttime"
											class="form-control validate[required]" style="padding:6px 10px">
									</div>
									<label style="text-align: center;" class="col-lg-3 col-md-3 col-sm-3 col-xs-3 control-label" for="endtime"><span class="red">*</span>结束时间 </label>
									<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 endtime">
										<input type="text" id="endtime" name="endtime"
											class="form-control validate[required]" style="padding:6px 10px">
									</div>
									<script>
										var starttime = {
										  elem: '#starttime',
										  format: 'YYYY-MM-DD hh:mm:ss',
										  min: laydate.now(), //设定最小日期为当前日期
										  max: '2099-06-16 23:59:59', //最大日期
										  istime: true,
										  istoday: false,
										  choose: function(datas){
											  endtime.min = datas; //开始日选好后，重置结束日的最小日期
											  endtime.start = datas //将结束日的初始值设定为开始日
										  }
										};
										var endtime = {
										  elem: '#endtime',
										  format: 'YYYY-MM-DD hh:mm:ss',
										  min: laydate.now(),
										  max: '2099-06-16 23:59:59',
										  istime: true,
										  istoday: false,
										  choose: function(datas){
											  starttime.max = datas; //结束日选好后，重置开始日的最大日期
										  }
										};
										laydate(starttime);
										laydate(endtime);
									</script>
								</div>
							</div>
							<div class="row">
								<div class="form-group has-feedback col-sm-12">
									<label style="text-align: right;" class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label" for="purpose">申请用途</label>
									<div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
										<textarea id="purpose" name="purpose" rows="2" class="form-control"></textarea>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="form-group has-feedback col-sm-12">
									<label style="text-align: right;" class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label" for="resource">所需资源</label>
									<div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
										<textarea id="resource" name="resource" rows="3" class="form-control"></textarea>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="form-group has-feedback col-sm-12">
									<label style="text-align: right;" class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label" for="remark">备注</label>
									<div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
										<textarea id="remark" name="remark" rows="3" class="form-control"></textarea>
									</div>
								</div>
							</div>						
						</form>
					</div>
					<div class="modal-footer" id="btnDiv" align="center">
						<button type="button" id="savebutton"
							class="btn btn-primary btn-sm" onclick="$('#ff').submit()">保存</button>
						<button type="button" class="btn btn-primary btn-sm"
							data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>
</body>
<script type="text/javascript"> 
var sunday = "${sunday }";
/* str1 = sunday.substring(0,10);
var arr1 = sunday.split("-");   
var date1 = new Date(arr1[0],parseInt(arr1[1])-1,arr1[2]);  */
for(var i=0;i<7;i++){
	$("#nowTime"+i).html(GetDateStr(i));
}

function formatStrToDate(str){
	var arrayDate = str.split("-");   
	var date = new Date(arrayDate[0],parseInt(arrayDate[1])-1,arrayDate[2]);
	return date;
}
function GetDateStr(day) { 
	var nowDate = formatStrToDate(sunday);
	nowDate.setDate(nowDate.getDate()+day);//获取AddDayCount天后的日期 
	return nowDate.getFullYear()+"-"+formatZero((nowDate.getMonth()+1))+"-"+formatZero(nowDate.getDate()); 
}
function formatZero(val){
	 if(parseInt(val) < 10){
		val="0"+val;
	} 
	return val;
}
</script>  
</html>