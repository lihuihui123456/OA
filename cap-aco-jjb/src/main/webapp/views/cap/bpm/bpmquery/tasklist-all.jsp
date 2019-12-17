<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>所有事项</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">
<script src="${ctx}/views/cap/bpm/bpmquery/js/tasklist-all.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css"
	rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="panel-body"
		style="padding-top:0;padding-bottom:0px;border:0;">
		<!-- 搜索框 -->
		<div style="padding: 5px 0px;width: 300px;float: right;">
			<div class="input-group">
				<input type="text" id="input-word"
					class="validate[required] form-control input-sm" value="请输入标题查询"
					onFocus="if (value =='请输入标题查询'){value=''}"
					onBlur="if (value ==''){value='请输入标题查询'}"> <span
					class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm"
						style="margin-right: 0px" onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button type="button" class="btn btn-primary btn-sm"
						style="margin-right: 0px;margin-left:2px;" onclick="advSearchModal()">
						<i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
		</div>

		<!-- table工具栏 -->
		<div style="padding: 5px 0px;">
			<!-- <button id="zyxw_btn" type="button" class="btn btn-default btn-sm">
			 <span class="fa fa-eye" aria-hidden="true"></span>查看
		</button> -->
			<!-- <button id="fordetails" type="button" class="btn btn-default btn-sm">
			<span class="fa fa-list" aria-hidden="true"></span>办理详情
		</button> -->
			<!--  
		<button id="grgd" type="button" class="btn btn-default btn-sm">
			<span class="fa  fa-folder" aria-hidden="true"></span>归档
		</button>-->
		</div>
		
		<!-- 高级查询 -->
		<div id="searchDiv" class="search-high-grade" style="display:none;margin-top:30px;">
			<form id="ff" enctype="multipart/form-data" 
				class="form-horizontal " target="_top" method="post" action="">
				<div class="form-group" id="dialog-message">
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">标题</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input id="BIZ_TITLE_" name="BIZ_TITLE_" type="text" class="form-control input-sm" >
					</div>
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">紧急程度</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<select  id="URGENCY_" name="URGENCY_" class="form-control input-sm" size="1" >
							<option value="">请选择</option>
							<option value="1">平件</option>
							<option value="2">急件</option>
							<option value="3">特急</option>
						</select>
					</div>
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">办理状态</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<select  id="STATE_" name="STATE_" class="validate[required] form-control input-sm" size="1" >
			    				<option value="">不限</option>
						<option value="0">待发</option>
						<option value="1">在办</option>
						<option value="2">办结</option>
						<option value="4">挂起</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="dialog-message">
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">拟稿人</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input id="USER_NAME" name="USER_NAME" type="text" class="form-control input-sm" placeholder="请输入标题">
					</div>
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">拟稿日期</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input type="text" id="CREATE_TIME_START_"  name="CREATE_TIME_START_" class="form-control input-sm"  
						onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: false})"/>
					</div>
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">到</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input type="text" id="CREATE_TIME_END_" name="CREATE_TIME_END_" class="form-control input-sm" 
						onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: false})"/>
					</div>
				</div>	
				<div class="form-group" id="dialog-message">
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">送交时间</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input type="text" id="END_TIME_START_"  name="END_TIME_START_" class="form-control input-sm"  
						onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: false})"/>
					</div>
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">到</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input type="text" id="END_TIME_END_" name="END_TIME_END_" class="form-control input-sm" 
						onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: false})"/>
					</div>
				</div>	
			</form>
			<div style="padding-bottom: 10px;" id="btnDiv" align="center">
				<button type="button" class="btn btn-primary btn-sm" id="advSearch">查询</button>
				<button type="button" class="btn btn-primary btn-sm"
					id="advSearchCalendar">重置</button>
				<button type="button" id="modal_close" class="btn btn-primary btn-sm"
					data-dismiss="modal">取消</button>
			</div>
		</div>
		
		<table id="tb_departments" data-toggle="table" date-striped="true"
			data-click-to-select="true"></table>
	</div>
	<!-- 模态框（Modal） -->
	<!-- <div class="modal fade" id="advSearchModal" aria-hidden="true">
		<div class="modal-dialog" style="width: 600px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">高级搜索</h4>
				</div>
				<div class="modal-body">
					<form id="ff" enctype="multipart/form-data"
						class="form-horizontal " target="_top" method="post" action="">
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">标题</label>
							<div class="col-md-10">
								<input id="BIZ_TITLE_" name="BIZ_TITLE_" type="text" class="form-control"
									placeholder="请输入标题">
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">紧急程度</label>
							<div class="col-sm-4">
								<select id="URGENCY_" name="URGENCY_" class="form-control" size="1">
									<option value="">不限</option>
									<option value="1">平件</option>
									<option value="2">急件</option>
									<option value="3">特急</option>
								</select>
							</div>
							<label class="col-sm-2 control-label"
								style="text-align: left;padding-left: 32px">状态</label>
							<div class="col-sm-4">
								<select id="STATE_" name="STATE_"
									class="validate[required] form-control" size="1">
									<option value="">不限</option>
									<option value="0">待发</option>
									<option value="1">在办</option>
									<option value="2">办结</option>
									<option value="4">挂起</option>
								</select>
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">拟稿人</label>
							<div class="col-md-10">
								<input id="USER_NAME" name="USER_NAME" type="text"
									class="form-control" placeholder="请输入拟稿人">
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">拟稿日期</label>
							<div class="col-sm-4">
								<input type="text" id="CREATE_TIME_START_" name="CREATE_TIME_START_"
									class="form-control select"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD',isclear: true})" />
							</div>
							<label class="col-sm-2 control-label"
								style="text-align: left;padding-left: 32px">到</label>
							<div class="col-sm-4">
								<input type="text" id="CREATE_TIME_END_" name="CREATE_TIME_END_"
									class="form-control select"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD',isclear: true})" />
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">送交时间</label>
							<div class="col-sm-4">
								<input type="text" id="END_TIME_START_" name="END_TIME_START_"
									class="form-control select"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss',isclear: true})" />
							</div>
							<label class="col-sm-2 control-label"
								style="text-align: left;padding-left: 32px">到</label>
							<div class="col-sm-4">
								<input type="text" id="END_TIME_END_" name="END_TIME_END_"
									class="form-control select"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss',isclear: true})" />
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
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="swiper-slide mask_layer"></div>
		</div>
	</div>
</body>
<script type="text/javascript">
	var mySwiper = new Swiper('.swiper-container', {
		loop : true,
		onSlidePrev : function(swiper) {
			$("#tb_departments").bootstrapTable('prevPage');
		},
		onSlideNext : function(swiper) {
			$("#tb_departments").bootstrapTable('nextPage');
		}
	});
	$(function() {
		//回车查询
		$('#input-word').keydown(function(event) {
			if (event.keyCode == 13) {
				search();
			}
		});
	});
	var ButtonInit = function() {
		var oInit = new Object();
		oInit.Init = function() {
			// 初始化页面上面的按钮事件
			$("#zyxw_btn").click(
					function() {
						var obj = $('#tb_departments').bootstrapTable(
								'getSelections');
						if (obj.length > 1 || obj.length == '') {
							layerAlert("请选择一条数据");
							return false;
						} else {
							var bizid = obj[0].bizid;
							var solId=obj[0].solId;
							alert(solId);
							var timestamp = new Date().getTime();
							var operateUrl = "${ctx}/bizRunController/getBizOperate?status=4&solId="+solId+ "&bizId=" + bizId;
							var options = {
								"text" : "查看-所有事项",
								"id" : "bizinfoview" + bizid + timestamp,
								"href" : operateUrl,
								"pid" : window,
								"isDelete" : true,
								"isReturn" : true,
								"isRefresh" : true
							};
							window.parent.createTab(options);
						}
					});
			//查看单位的办理详情
			$("#fordetails")
					.click(
							function() {
								var bizid = getselectoption();
								var procInstId = getSelectProcInst();
								if (bizid == "") {
									layerAlert("请选择一条数据");
								} else {
									var options = {
										"text" : "办理详情",
										"id" : "bizinfodetail" + bizid,
										"href" : "${ctx}/bpmRuBizInfoController/toDealDetialPage?bizId="+ bizid,
										"pid" : window,
										"isDelete" : true,
										"isReturn" : true,
										"isRefresh" : true
									};
									window.parent.createTab(options);
								}
							});
			$("#grgd").click(
					function() {
						var bizid = getselectoption();
						if (bizid == "") {
							layerAlert("请选择一条数据");
						} else {
							$('#myModal').modal('show');
							$('#group').attr("src",
									"docmgt/toSelectFolder?folderType=1");
						}
					})
		};
		return oInit;
	};
	function getselectoption() {
		var obj = $('#tb_departments').bootstrapTable('getSelections');
		if (obj.length > 1 || obj.length == '') {
			return "";
		} else {
			return obj[0].bizid;
		}
	}

	function getSelectProcInst() {
		var obj = $('#tb_departments').bootstrapTable('getSelections');
		if (obj.length > 1 || obj.length == '') {
			return "";
		} else {
			return obj[0].proc_inst_id_;
		}
	}
	laydate.skin('dahong');
</script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>