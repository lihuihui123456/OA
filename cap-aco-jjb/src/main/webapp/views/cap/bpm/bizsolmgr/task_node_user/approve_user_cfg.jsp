<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>审批人员配置</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout">
<div region="west" split="false" title="流程定义节点" style="width:200px;margin-bottom: 20px">
	<ul id="procDefTaskNodes"></ul>
</div>
<div id="content" region="center" title="节点审批人员" style="padding:5px;">

</div>
</body>
<script type="text/javascript">
$(function(){
	initTree();
})
function initTree(){
	$("#procDefTaskNodes").tree({
		url:"${ctx}/bizSolMgr/findProcDefTaskNodeTree?procDefId=${procDefId}",
		method : "get",
		animate : true,
	})
}
</script>
</html>