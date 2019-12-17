<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>传阅事项</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">
<script src="${ctx}/views/cap/bpm/bpmquery/js/tasklist-circulate.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css"
	rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<%@ include file="/views/cap/common/theme.jsp"%>
<style>
.fixed-table-toolbar .bars {
	margin-top: 0px;
	margin-bottom: 0px;
}
</style>
</head>
<body>
	<div class="panel-body"
		style="padding-top:0;padding-bottom:0px;border:0;">
		<div id="toolbar" class="btn-group">
			<!-- 		<button id="btn_open" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-eye" aria-hidden="true"></span>查看
			</button> -->
		</div>
		<!-- 搜索框 -->
		<div
			style="height:40px; padding-top: 5px;padding-bottom: 5px;padding-right: 0px;">
			<div class="input-group" style="width: 300px; float: right;">
				<input type="text" id="input-word"
					class="validate[required] form-control input-sm" value="请输入标题查询"
					onFocus="if (value =='请输入标题查询'){value=''}"
					onBlur="if (value ==''){value='请输入标题查询'}"> <span
					class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm"
						style="margin-right: 0px" onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button type="button" id="advSearchModal"
						class="btn btn-primary btn-sm"
						style="margin-left:2px; margin-right: 0px;">
						<i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
		</div>

		<!-- table工具栏 -->
		<!-- 		<div style="padding: 5px 0px;">
			<button id="zyxw_btn" type="button" class="btn btn-default btn-sm">
				 <span class="fa fa-eye" aria-hidden="true"></span>查看
			</button>
			<button id="fordetails" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-list" aria-hidden="true"></span>办理详情
			</button>
		</div> -->
		<div id="advSearch" class="search-high-grade" style="display: none;">
			<form id="search_form" enctype="multipart/form-data"
				class="form-horizontal " target="_top" method="post" action="">

				<div class="form-group" id="dialog-message">
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">标题</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input id="title" name="title_" type="text"
							class="form-control input-sm">
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
						<select id="isread" name="isread"
							class="validate[required] form-control input-sm" size="1">
							<option value="-1">全部</option>
							<option value="0">未阅读</option>
							<option value="1">已阅读</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="dialog-message">
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">拟稿日期</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input type="text" id="circuStartTime" name="circuStartTime"
							value="" class="form-control input-sm"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
					</div>
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">至</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input type="text" id="circuEndTime" name="circuEndTime" value=""
							class="form-control input-sm"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
					</div>
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">传阅人</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input id="circulationMan" name="circulationMan" type="text"
							class="form-control input-sm">
					</div>
				</div>

				<!-- 				<div class="form-group">
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
				</div>
				<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2"
						style="font-weight: bolder;">办理状态:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<select id="isread" name="isread"
							class="validate[required] form-control" size="1">
							<option value="-1">全部</option>
							<option value="0">未阅读</option>
							<option value="1">已阅读</option>
						</select>
					</div>

					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2"
						style="font-weight: bolder;">传阅人:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input id="circulationMan" name="circulationMan" type="text"
							class="form-control">
					</div>

				</div>
				<div class="form-group">
					<label
						class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">传阅时间:</label>
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
		<table id="tb_departments" data-toggle="table" date-striped="true"
			data-click-to-select="true"></table>
	</div>
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="swiper-slide mask_layer"></div>
		</div>
	</div>
	<!-- 模态框（Modal） -->
	<!-- <div class="modal fade" id="advSearchModal" aria-hidden="true">
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
								<select  id="isread" name="isread" class="validate[required] form-control" size="1" >
					    			    <option value="-1">全部</option>
					    				<option value="0">未阅读</option>
					    				<option value="1">已阅读</option>
								</select>
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">传阅时间</label>
							<div class="col-sm-4">
								<input type="text" id="circuStartTime"  name="circuStartTime" class="form-control"  onclick="laydate({format: 'YYYY-MM-DD',isclear: false})"/>
							</div>
							<label class="col-sm-2 control-label" style="text-align: left;padding-left: 32px">到</label>
							<div class="col-sm-4">
								<input type="text" id="circuEndTime" name="circuEndTime" class="form-control" onclick="laydate({format: 'YYYY-MM-DD',isclear: false})"/>
							</div>
						</div>
						<div class="form-group" id="dialog-message">
						<label class="col-sm-2 control-label" style="text-align: left;">传阅人</label>
							<div class="col-md-10">
								<input id="circulationMan" name="circulationMan" type="text" class="form-control" >
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
	var mySwiper = new Swiper('.swiper-container', {
		loop : true,
		onSlidePrev : function(swiper) {
			$("#tb_departments").bootstrapTable('prevPage');
		},
		onSlideNext : function(swiper) {
			$("#tb_departments").bootstrapTable('nextPage');
		}
	});
	var ButtonInit = function() {
		var oInit = new Object();
		var postdata = {};
		oInit.Init = function() {
			// 初始化页面上面的按钮事件
			$("#zyxw_btn")
					.click(
							function() {
								var obj = $('#tb_departments').bootstrapTable(
										'getSelections');
								if (obj.length > 1 || obj.length == '') {
									layerAlert("请选择一条数据");
									return false;
								} else {
									var bizid = obj[0].bizid;
									var id = obj[0].id;
									var timestamp = new Date().getTime();
									options = {
										"text" : "查看-传阅事项",
										"id" : "cysx_view_" + id + timestamp,
										"href" : "${ctx}/bpmCirculate/findCirculate?bizid="
												+ bizid + "&&id=" + id,
										"pid" : window,
										"isDelete" : true,
										"isReturn" : true,
										"isRefresh" : true
									};
									window.parent.createTab(options);
								}
							})
			//查看单位的办理详情--ok
			$("#fordetails")
					.click(
							function() {
								var bizid = getselectoption();
								if (bizid == "") {
									layerAlert("请选择一条数据");
								} else {
									var options = {
										"text" : "办理详情",
										"id" : "circulate_blxq_" + bizid,
										"href" : "${ctx}/bpmRuBizInfoController/toDealDetialPage?procInstId="
												+ getSelectProcInst(),
										"pid" : window,
										"isDelete" : true,
										"isReturn" : true,
										"isRefresh" : true
									};
									window.parent.createTab(options);
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
</script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>