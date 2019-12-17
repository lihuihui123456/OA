<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<html>
<head>
	<%@ include file="/views/aco/common/head.jsp"%>
	<script src="${ctx}/views/cap/msgpush/js/msgpushList.js"></script>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<title>推送消息列表</title>
<script type="text/javascript">
var pushMsgListTable = 1;
</script>
</head>
<body>
	<div class="panel-body" style="padding-top:0;padding-bottom:0px;border:0;">
		<table id="msgTableList"></table>
	</div>
</body>
</html>