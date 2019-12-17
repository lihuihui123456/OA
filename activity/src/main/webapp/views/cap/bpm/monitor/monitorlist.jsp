<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>事项监控</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script src="${ctx}/views/cap/bpm/monitor/js/monitorlist.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
$(function(){
	//修改审批意见
	$("#change_advice_btn").click(function(){
		var bizid="";
		bizid=getselectbizid();
		if(bizid==""){
			layerAlert("请选择一条数据");
		}else{
			var obj =$('#tb_departments').bootstrapTable('getSelections');
			if(obj[0].state_=='2'){
				layerAlert("办理完结，无法修改意见!");
				return;
			}else{
				 var options={
						"text":"修改意见",
						"id":"bizinfocom"+bizid,
						"href":"bpmMonitor/toMonitorAdviceList?bizid="+bizid,
						"pid":window,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":true
				};
				window.parent.createTab(options); 
			}
		}
	})
	//查看原文
	$("#view_btn").click(function(){
		var obj =$('#tb_departments').bootstrapTable('getSelections');
		if (obj.length>1||obj.length=='') {
			layerAlert("请选择一条数据");
			return false;
		}else{
			var bizid=obj[0].bizid;
			var solId=obj[0].solId;
			var timestamp=new Date().getTime();
			var operateUrl = "bizRunController/getBizOperate?status=4&solId="+ solId + "&bizId=" + bizid;
			var options={
					"text":"查看",
					"id":"bizinfoview"+bizid+timestamp,
					"href": operateUrl,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options); 
			
		}
	})
	//办理详情 
	$("#fordetails_btn").click(function(){
		var bizid="";
		bizid=getselectbizid();
		if(bizid==""){
			layerAlert("请选择一条数据");
		}else{
			 var options={
					"text":"办理详情",
					"id":"bizinfodetail"+bizid,
					"href":"${ctx}/bpmRuBizInfoController/toSxjkDealDetialPage?bizId="+ bizid,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options); 
		}
	});
	
	//跟踪事项
	$("#zyxw_btn_trace").click(function() {
		/* getselectoption(); */
		var obj = $('#tb_departments').bootstrapTable('getSelections');
		if (obj.length == '' || obj.length < 1) {
			layerAlert("请选择一条数据");
			return false;
		}else{
			for(var i=0;i<obj.length;i++){
				if(obj[i].state_=='2'){
					layerAlert("有信息办理完结,无法进行跟踪");
					return false;
				}
			}
		}
		var pids = "";
		for (var i = 0; i < obj.length; i++) {
			if (pids.length > 0) {
				pids += ("," + obj[i].proc_inst_id_);
			} else {
				pids += obj[i].proc_inst_id_;
			}
		}
		$.ajax({
			type : "POST",
			url : "${ctx}/bpmTrace/doSaveTrace",
			data : {
				pids : pids
			},
			success : function(msg) {
				if (!!msg) {
					if ('true' == $.trim(msg)) {
						layerAlert("已加入跟踪事项.");
					} else {
						layerAlert("操作失败！");
					}
				}else {
					layerAlert("操作异常！");
				}
			}
		});
	});
	
	
	//显示在办数据
	$("#dwfw_btn_on").click(function() {
		state_="1";
		$("#tb_departments").bootstrapTable('refresh');
		var txt = $(this).text();
		$(this).parent().prev().html(txt + ' <span class="caret"></span>');
	});
	
	//显示全部数据
	$("#dwfw_btn_all").click(function() {
		state_="0";
		$("#tb_departments").bootstrapTable('refresh');
		var txt = $(this).text();
		$(this).parent().prev().html(txt + ' <span class="caret"></span>');
	});
	
	//显示办结数据
	$("#dwfw_btn_over").click(function() {
		state_="2";
		$("#tb_departments").bootstrapTable('refresh');
		var txt = $(this).text();
		$(this).parent().prev().html(txt + ' <span class="caret"></span>');
	});
	
	$('.dropdown-toggle').dropdown();
});

//获取选中信息业务id
function getselectbizid(){
	var bizid="";
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
	}else{
		bizid=obj[0].bizid;
	}
	return bizid;
}

function getSelectProInst(){
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
		return "";
	}else{
		return obj[0].proc_inst_id_;
	}
}

//获取选中信息taskid
function getselecttaskid(){
	var taskid="";
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
	}else{
		taskid=obj[0].taskid;
	}
	return taskid;
}

function getSelectProcInst(){
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
		return "";
	}else{
		return obj[0].proc_inst_id_;
	}
}

function rollback() {
	if ($("#message").val().replace(/\s/g, "") == "" || $("#message").val().replace(/\s/g, "") == null) {
		layerAlert("撤销原因不能为空");
	} else {
		layer.confirm('是否确定撤销流程', {
			btn: ['是', '否']
		}, function () {
			$.ajax({
				type: "post",
				url: "${ctx}/bpm/doUndone",
				dataType: 'json',
				data: $("#removeProcessFm").serialize(),
				success: function (data) {
					if (data == "1") {
						$('#removeProcessmodel').modal('hide');
						$("#tb_departments").bootstrapTable('refresh');
						layerAlert("撤销成功");
						//撤销流程后需要恢复请假和调休的天数
						var bizid="";
						bizid=getselectbizid();
						$.ajax({
							type: "post",
							url: "${ctx}/leaveManager/resetLeaveInfo",
							dataType: 'json',
							data: {'bizId':bizid},
							success: function (data) {}
						});
					} else {
						layerAlert("撤销失败");
						$('#removeProcessmodel').modal('hide');
					}
				}
			});
		}, function () {});
	}
}


function showRemovePromodel(){
	var obj = $('#tb_departments').bootstrapTable('getSelections');
	if(obj.length < 1) {
		layerAlert("请选择要撤销的数据！");
		return;
	}
	//撤销流程
	/* var bizid="";
	bizid = getselectbizid();
	if(bizid==""){
		layerAlert("请选择一条数据");
		return;
	}
	
	if(obj[0].state_ == "2"){
		layerAlert("已办结事项不能撤销");
		return;
	} */
	var procInstIds = [];
	$(obj).each(function(index){
		procInstIds[index] = this.proc_inst_id_;
	});
	$("#procInstId").val(procInstIds.toString());
    $('#message').val("");
	$('#removeProcessmodel').modal('show');
}
</script>
</head>
<body>
	<div class="panel-body" style="padding-top:0;padding-bottom:0px;border:0;">
		<!-- 搜索框 -->
		<div style="padding: 5px 0px;width: 300px;float: right;">
			<div class="input-group">
				<input type="text" id="input-word" class="validate[required] form-control input-sm" value="请输入标题查询" 
					onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button type="button" id="advSearchModal"
						class="btn btn-primary btn-sm" style="margin-left:2px; margin-right: 0px;">
						<i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
		</div>
		
		<!-- table工具栏 -->
		<div style="padding: 5px 0px;">
		<!-- 	<button id="change_advice_btn" class="btn btn-default btn-sm">
				 <span class="fa fa-file-text" aria-hidden="true"></span>修改意见
			</button> -->
	<!-- 		<button id="view_btn" class="btn btn-default btn-sm">
				 <span class="fa fa-eye" aria-hidden="true"></span>查看
			</button> -->
		<!-- 	<button id="fordetails_btn" class="btn btn-default btn-sm">
				 <span class="fa fa-list" aria-hidden="true"></span>办理详情
			</button> -->
			<button id="rollback_btn" class="btn btn-default btn-sm" onclick="showRemovePromodel()">
				 <span class="fa fa-times" aria-hidden="true"></span>撤销流程
			</button>
			<button id="zyxw_btn_trace" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-flag" aria-hidden="true"></span>跟踪事项
			</button>
			<!-- <button type="button" class="btn btn-default dropdown-toggle btn-sm">
				<span id="manastate">办理状态</span>&nbsp;<span class="caret"></span>
			</button> -->
<!-- 			<a href="#" class="btn btn-default dropdown-toggle btn-sm" data-toggle="dropdown">办理状态 <span class="caret"></span></a>
			<ul class="dropdown-menu" style="position:absolute; top:32px; left:365px;">
				<li id="dwfw_btn_all"><a href="javascript:;">全部</a></li>
	            <li id="dwfw_btn_on"><a href="javascript:;">在办</a></li>
	            <li id="dwfw_btn_over"><a href="javascript:;">办结</a></li>
	        </ul> -->
		</div>
				<div id="advSearch" class="search-high-grade"
			style="display: none; padding-top: 10px;">
			<form id="search_form" enctype="multipart/form-data"
				class="form-horizontal " target="_top" method="post" action="">
			
				<div class="form-group" id="dialog-message">
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">标题</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
							<input  id="title" name="title_" type="text" class="form-control input-sm" >
						</div>
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">紧急程度</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<select id="level" name="level_" class="form-control input-sm" size="1">
							<option value="-1">全部</option>
							<option value="1">平件</option>
							<option value="2">急件</option>
							<option value="3">特急</option>
						</select>
						</div>
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">办理状态</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
							<select  id="state" name="state" class="validate[required] form-control input-sm" size="1" >
					    			    <option value="-1">全部</option>
					    				<option value="1">在办</option>
					    				<option value="2">办结</option>
								</select>
						</div>
					</div>
			
					<div class="form-group" id="dialog-message">
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">拟稿人</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input id="userName" name="userName" type="text" class="form-control input-sm">
						</div>
					<!-- 	<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">拟稿部门</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
	                    <input id="draftDepartment" name="draftDepartment" type="text"
							class="form-control input-sm">
						</div> -->
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">办理人</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input id="vuserName" name="vuserName" type="text"
							class="form-control input-sm">
						</div>
					</div>
						<div class="form-group" id="dialog-message">
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">拟稿日期</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input type="text" id="circuStartTime" name="circuStartTime"
							value="" 
							class="form-control input-sm"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />						</div>
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">至</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input type="text" id="circuEndTime" name="circuEndTime" value=""
							class="form-control input-sm"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />						</div>
					</div>	
<!-- 			
				<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2"
						style="font-weight: bolder;">标题:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input id="title" name="title_" type="text"
							class="form-control input-sm" placeholder="请输入标题">
					</div>
					<label
						class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">紧急程度:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
						<select id="level" name="level_" class="form-control" size="1">
							<option value="-1">全部</option>
							<option value="1">平件</option>
							<option value="2">急件</option>
							<option value="3">特急</option>
						</select>
					</div>
				</div> -->
<!-- 				<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2"
						style="font-weight: bolder;">办理状态:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
							<select  id="state" name="state" class="validate[required] form-control" size="1" >
					    			    <option value="-1">全部</option>
					    				<option value="1">在办</option>
					    				<option value="2">办结</option>
								</select>
					</div>

					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2"
						style="font-weight: bolder;">拟稿人:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input id="userName" name="userName" type="text"
							class="form-control">
					</div>

				</div> -->
<!-- 							<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2"
						style="font-weight: bolder;">拟稿部门:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input id="draftDepartment" name="draftDepartment" type="text"
							class="form-control">
					</div>

					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2"
						style="font-weight: bolder;">办理人:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input id="vuserName" name="vuserName" type="text"
							class="form-control">
					</div>

				</div> -->
<!-- 				<div class="form-group">
					<label
						class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">拟稿日期:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<input type="text" id="circuStartTime" name="circuStartTime"
							value="" style="width:45%; float:left"
							class="form-control select input-sm"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" /> <span
							style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
						<input type="text" id="circuEndTime" name="circuEndTime" value=""
							style="width:45%; float:left"
							class="form-control select input-sm"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />

					</div>
				</div> -->
			</form>
			<div class="" id="btnDiv" align="center"
				style="width:100%; margin-bottom: 10px">
				<button type="button" class="btn btn-primary btn-sm" id="advSearch"
					onclick="submitForm()">查询</button>
				<button type="button" class="btn btn-primary btn-sm" id="advReset"
					onclick="clearForm()">重置</button>
				<button type="button" id="modal_close"
					class="btn btn-primary btn-sm">取消</button>
			</div>
		</div>
		<table  id="tb_departments" data-toggle="table" date-striped="true" data-click-to-select="true" ></table>
	</div>
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
	<!-- 撤销流程  模态框 -->
	<div class="modal fade" id="removeProcessmodel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<h4 class="modal-title">
						撤销原因
					</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<form id="removeProcessFm">
						<input type="hidden" name="procInstId" id="procInstId" />
						<textarea class="form-control" id="message" name="deleteReason" rows="6"></textarea>
					</form>
				</div>
				<div class="modal-footer" style="text-align:center">
		            <button type="button" class="btn btn-primary" onclick="rollback()">保存</button>
		            <button type="button" class="btn btn-default" data-dismiss="modal">关闭 </button>
		         </div>
			</div>
		</div>
	</div>
			<!-- 模态框（Modal） -->
<!-- 	<div class="modal fade" id="advSearchModal" aria-hidden="true">
		<div class="modal-dialog" style="width: 700px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >高级搜索</h4>
				</div>
				<div class="modal-body">
					<form id="search_form" enctype="multipart/form-data" class="form-horizontal "
						target="_top" method="post" action="">
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">标题</label>
							<div class="col-md-10">
								<input id="title" name="title_" type="text" class="form-control" placeholder="请输入标题">
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">紧急程度</label>
							<div class="col-sm-4">
								<select  id="level" name="level_" class="form-control" size="1" >
									<option value="-1">全部</option>
									<option value="1">平件</option>
									<option value="2">急件</option>
									<option value="3">特急</option>
								</select>
							</div>
							<label class="col-sm-2 control-label" style="text-align: left;padding-left: 32px">办理状态</label>
							<div class="col-sm-4">
								<select  id="state" name="state" class="validate[required] form-control" size="1" >
					    			    <option value="-1">全部</option>
					    				<option value="1">在办</option>
					    				<option value="2">办结</option>
								</select>
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">拟稿日期</label>
							<div class="col-sm-4">
								<input type="text" id="circuStartTime"  name="circuStartTime" class="form-control"  onclick="laydate({format: 'YYYY-MM-DD',isclear: false})"/>
							</div>
							<label class="col-sm-2 control-label" style="text-align: left;padding-left: 32px">到</label>
							<div class="col-sm-4">
								<input type="text" id="circuEndTime" name="circuEndTime" class="form-control" onclick="laydate({format: 'YYYY-MM-DD',isclear: false})"/>
							</div>
						</div>
						<div class="form-group" id="dialog-message">
						<label class="col-sm-2 control-label" style="text-align: left;">拟稿人</label>
							<div class="col-sm-4">
								<input id="userName" name="userName" type="text" class="form-control" >
							</div>
						<label class="col-sm-2 control-label" style="text-align: left;padding-left: 32px">拟稿部门</label>
							<div class="col-sm-4">
								<input id="draftDepartment" name="draftDepartment" type="text" class="form-control" >
							</div>
						</div>
							<div class="form-group" id="dialog-message">
						<label class="col-sm-2 control-label" style="text-align: left;">办理人</label>
							<div class="col-sm-4">
								<input id="vuserName" name="vuserName" type="text" class="form-control" >
							</div>
						</div>						
					</form>
				</div>
				<div class="modal-footer" id="btnDiv" align="center">
					<button type="button" class="btn btn-primary btn-sm" id="advSearch">查询</button>
					<button type="button" class="btn btn-primary btn-sm"
						id="advSearchCalendar">重置</button>
					<button type="button" id="modal_close" class="btn btn-primary btn-sm"
						data-dismiss="modal">取消</button>
				</div>
			</div>
		</div>
	</div> -->
</body>
<script type="text/javascript">
var mySwiper = new Swiper('.swiper-container',{
    loop:true,
	onSlidePrev: function(swiper){
	$("#tb_departments").bootstrapTable('prevPage');
	  },
	onSlideNext: function(swiper){
	$("#tb_departments").bootstrapTable('nextPage');
	}
});
</script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>