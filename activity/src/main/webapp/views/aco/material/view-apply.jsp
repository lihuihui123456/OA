<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>办公系统</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/views/aco/common/head.jsp"%>
<!-- 引入bootstrap-table-css -->
<link href="/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/editable/css/bootstrap-editable.css"">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<!-- end -->
<script src="${ctx}/views/aco/material/js/view-material-apply.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<!-- bootStrop 可编辑表格js -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/editable/js/bootstrap-table-editable.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/editable/js/bootstrap-editable.min.js"></script>
<!-- 本地化 -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- end -->
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="background-color:#f2f4f8;">
<div  style="background-color:#fff; border:1px solid #ddd; margin-left:5px;">
	<p class="tablestyle_title" style="font-size:25px;padding-top: 10px; text-align:center;">物品领用单</p>
	<div class="panel-body">
		<div class="container-fluid content">
			<div class="main" style="padding-left: 20px;padding-top: 20px;background-color:#fff;">
				<form id="ff" action="" method="post" enctype="multipart/form-data"
					class="form-horizontal " target="_top">
					<input type="hidden" id="id" name="id_" value="${data.id }">
					<input type="hidden" name="registertime_" value="${data.registerTime_ }">
					<input type="hidden" name="userid_" value="${data.userId_ }">
					<input type="hidden" name="userorgid_" value="${data.userorgId_ }">
					<div class="form-group">
						<label class="col-sm-1 control-label" for="user"
							style="text-align: left ;">领用人</label>
						<div class="col-sm-5">
							<input type="text" id="user" value="${userName }" class="form-control" disabled>
						</div>
						<label class="col-sm-1 control-label" for="userorg"
							style="text-align: left;">&nbsp;&nbsp;领用部门</label>
						<div class="col-sm-5">
							<input type="text" id="userorg" class="form-control" value = "${orgName }" disabled>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-1 control-label" for="title"
							style="text-align: left;">标题</label>
						<div class="col-sm-11">
							<input type="text" id="title" name="title_" value="${data.title_ }"
								class="form-control" placeholder="" disabled>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-1 control-label" for="reason"
							style="text-align: left;">申请用途</label>
						<div class="col-sm-11">
							<textarea disabled id="reason" name="reason_" rows="4" class="form-control">${data.reason_ }</textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="col-sm-1 control-label" for="remark"
							style="text-align: left;">备注</label>
						<div class="col-sm-11">
							<textarea disabled id="remark" name="remark_" rows="4" class="form-control">${data.remark_ }</textarea>
						</div>
					</div>
				</form>
				<table id="chooseGoodsList" data-toggle="table"></table>
			</div>
		</div>
	</div>
</div>
</body>
</html>