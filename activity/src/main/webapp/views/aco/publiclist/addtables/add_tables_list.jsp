<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>公共列表</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-fd-table.css">
<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-resizable.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/colResizable-1.5.source.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script type="text/javascript">
var id = '${id}';
var columnJsonStr = '${columnJsonStr}';
var jsonData = '${jsonData}';
</script> 
<script src="${ctx}/views/aco/publiclist/js/add_tables_list.js"></script>

<style>

	.fd_input{
		width: 100%;
		background-color: transparent;
		border:none;
	}
</style>

</head>

<body style="background-color: white;">
	<table id="${id}">
	</table>
</body>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>