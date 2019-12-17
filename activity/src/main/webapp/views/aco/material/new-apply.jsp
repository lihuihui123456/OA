<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>办公系统</title>
<%@ include file="/views/aco/common/head.jsp"%>
<!-- 引入bootstrap-table-css -->

<link href="/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/editable/css/bootstrap-editable.css"">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<!-- end -->

<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script src="${ctx}/views/aco/material/js/new-material-apply.js"></script>
<!-- 引入bootstrap-table-js -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<!-- bootStrop 可编辑表格js -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/editable/js/bootstrap-table-editable.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/editable/js/bootstrap-editable.min.js"></script>
<!-- 本地化 -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- end -->
<style>
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="background-color:#f2f4f8;height:600px;">
<div  style="background-color:#fff; border:1px solid #ddd; margin-left:5px;">
	<p class="tablestyle_title" style="font-size:25px;padding-top: 10px; text-align:center;">物品领用单</p>
	<div class="panel-body" >
		<div class="container-fluid content">
			<div class="main" style="padding-left: 20px;padding-top: 20px;background-color:#fff;">
				<form id="ff" action="" method="post" enctype="multipart/form-data"
					class="form-horizontal " target="_top">
					<input type="hidden" name="registerTime_" value="${time }">
					<input type="hidden" name="userId_" value="${userId }">
					<input type="hidden" name="userorgId_" value="${orgId }">
					<div class="form-group">
						<label class="col-sm-1 control-label" for="user"
							style="text-align: left ;">领用人<span style="color:red">*</span></label>
						<div class="col-sm-5">
							<input type="text" id="user" value="${userName }" class="form-control ">
						</div>
						<label class="col-sm-1 control-label" for="userorg"
							style="text-align: left;">领用部门<span style="color:red">*</span></label>
						<div class="col-sm-5">
							<input type="text" id="userorg" class="form-control " value = "${orgName }">
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-1 control-label" for="title"
							style="text-align: left;">标题 <span style="color:red">*</span></label>
						<div class="col-sm-11">
							<input type="text" id="title" name="title_"
								class="form-control" placeholder="">
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-1 control-label" for="reason"
							style="text-align: left;">申请用途</label>
						<div class="col-sm-11">
							<textarea id="reason" name="reason_" rows="4" class="form-control"></textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-1 control-label" for="remark"
							style="text-align: left;">备注</label>
						<div class="col-sm-11">
							<textarea id="remark" name="remark_" rows="4" class="form-control"></textarea>
						</div>
					</div>
				</form>
				<div id="toolbar" class="btn-group">
					<button id="mt_btn_openDialog" type="button" class="btn btn-default btn-sm">
						<span class="fa fa-plus" aria-hidden="true"></span>选择物品
					</button>
				</div>
				<table id="chooseGoodsList" data-toggle="table"></table>
				<!-- <div align="center" style="margin-top: 20px">
					<button id="send" type="button" class="btn btn-primary">送交</button>
					<button id="save" type="button" class="btn btn-primary">暂存</button>
				</div> -->
			</div>
		</div>
	</div>
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true" backdrop="true">
		<div class="modal-dialog" style="width: 600px;">
			<div class="modal-content">
				<div class="modal-body">
					<div style="width: 300px;">
						<div class="input-group">
							<input type="text" id="input-word" class="form-control"
								placeholder="输入物品名称查询"> <span class="input-group-btn">
								<button id="searchData" type="button" class="btn btn-primary">查询</button>
							</span>
						</div>
					</div>
					<table id="dtlist" data-toggle="table"></table>
				</div>
				<div class="form-group" align="center">
					<button id="submitList" type="button" class="btn btn-primary">确定</button>
					<button type="button" class="btn btn-primary"" data-dismiss="modal">关闭
					</button>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>