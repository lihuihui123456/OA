<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>请加管理</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script
	src="${ctx}/views/aco/biz/leavemgr/list/js/leave-list.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
	var solId = '${solId}';
</script>
</head>
<body>
	<div id="search_div"
		style="width: 300px; float: right; padding-bottom: 10px;padding-top: 10px;">
		<div class="input-group">
			<input type="text" id="input-word" class="form-control input-sm"
				value="请输入姓名查询" onFocus="if (value =='请输入姓名查询'){value=''}"
				onBlur="if (value ==''){value='请输入姓名查询'}"> <span
				class="input-group-btn">
				<button type="button" class="btn btn-primary btn-sm"
					style="margin-right: 0px" onclick="search()">
					<i class="fa fa-search"></i> 查询
				</button>
				<button type="button" class="btn btn-primary btn-sm"
					style="margin-left: 2px; margin-right: 0px;"
					onclick="showOrHide();">
					<i class="fa fa-search-plus"></i> 高级
				</button>
			</span>
		</div>
	</div>
	<div style="padding-top: 10px;padding-bottom:0px;border:0;">
		<div id="toolbar" class="btn-group">
			<%@ include file="/views/aco/biz/earcmgr/biz_btn_list_do.jsp"%>
			<button id="btn_delete_pers" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-remove" aria-hidden="true"> 删除</span>
			</button>
		</div>
		<!-- 模态框（Modal） -->
		<div id="advSearchModal" class="search-high-grade"
			style="display: none; margin-top: 15px;">
			<form id="ff" enctype="multipart/form-data" class="form-horizontal "
				target="_top" method="post" action="">
				<div class="form-group" id="dialog-message">
					<label class="col-sm-1 control-label">姓名</label>
					<div class="col-sm-3">
						<input id="USER_NAME" name="USER_NAME" type="text"
							class="form-control">
					</div>
					<label class="col-sm-1 control-label">部门</label>
					<div class="col-sm-3">
						<input id="DEPT_NAME" name="DEPT_NAME" type="text"
							class="form-control">
					</div>
					<label class="col-sm-1 control-label">职务</label>
					<div class="col-sm-3">
						<input id="POST_NAME" name="POST_NAME" type="text"
							class="form-control">
					</div>
				</div>
				<div class="form-group" id="dialog-message">
					<label class="col-sm-1 control-label">状态</label>
					<div class="col-sm-3">
						<select id="STATE" name="STATE"
							class="form-control" size="1">
							<option value="">请选择</option>
							<option value="0">待提交</option>
							<option value="1">审批中</option>
							<option value="2">通过</option>
							<option value="3">未通过</option>
						</select>
					</div>
					<label class="col-sm-1 control-label">请假类型</label>
					<div class="col-sm-3">
						<select id="LEAVE_TYPE" name="LEAVE_TYPE"
							class="form-control" size="1">
							<option value="">请选择</option>
							<option value="bj">病假</option>
							<option value="xj">休假</option>
							<option value="sj">事假</option>
						</select>
					</div>
					<label class="col-sm-1 control-label">请假天数</label>
					<div class="col-sm-3">
						<input id="LEAVE_DAYS" name="LEAVE_DAYS" type="text"
							class="form-control">
					</div>
				</div>
				<div class="form-group" id="dialog-message">
					<label class="col-sm-1 control-label">请假时间</label>
					<div class="col-sm-3">
						<!-- <div class="input-group date"> -->
						<input type="text" id="advStartDate" name="START_TIME"
							class="form-control select"
							onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})" />
						<!-- </div> -->
					</div>
					<label class="col-sm-1 control-label">到</label>
					<div class="col-sm-3">
						<!-- <div class="input-group date"> -->
						<input type="text" id="advEndDate" name="END_TIME"
							class="form-control select"
							onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})" />
						<!-- </div> -->
					</div>
					<label class="col-sm-1 control-label">是否出京</label>
					<div class="col-sm-3">
						<select id="IS_BJ" name="IS_BJ"
							class="form-control" size="1">
							<option value="">请选择</option>
							<option value="s">是</option>
							<option value="f">否</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="dialog-message">
					<label class="col-sm-1 control-label">提交时间</label>
					<div class="col-sm-3">
						<!-- <div class="input-group date"> -->
						<input type="text" id="advSendStartDate" name="SEND_TIME_START"
							class="form-control select"
							onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})" />
						<!-- </div> -->
					</div>
					<label class="col-sm-1 control-label">到</label>
					<div class="col-sm-3">
						<!-- <div class="input-group date"> -->
						<input type="text" id="advSendEndDate" name="SEND_TIME_END"
							class="form-control select"
							onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})" />
						<!-- </div> -->
					</div>
					<label class="col-sm-1 control-label">是否出境</label>
					<div class="col-sm-3">
						<select id="IS_EXIT" name="IS_EXIT"
							class="form-control" size="1">
							<option value="">请选择</option>
							<option value="s">是</option>
							<option value="f">否</option>
						</select>
					</div>
				</div>
			</form>
			<div id="btnDiv" align="center"
				style="width:100%; margin-bottom: 10px">
				<button type="button" class="btn btn-primary btn-sm" id="advSearch">查询</button>
				<button type="button" class="btn btn-primary btn-sm"
					id="advSearchCalendar">重置</button>
				<button type="button" id="modal_close"
					class="btn btn-primary btn-sm" onclick="qxButton();">取消</button>
			</div>
		</div>
		<table id="leaveTable">
		</table>
	</div>
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="swiper-slide mask_layer"></div>
		</div>
	</div>
	<%@ include file="/views/aco/common/selectionPeople_tree.jsp"%>
</body>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>