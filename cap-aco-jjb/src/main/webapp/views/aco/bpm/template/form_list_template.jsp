<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<style type="text/css">
html, body {
	height: 100%;
	padding: 0px 4px;
}
</style>
<title>业务公共列表</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<!-- bootstrop 样式 -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<script type="text/javascript">
</script>
<body style="overflow:hidden; ">
	<iframe scrolling="yes" src="${src}" id="win" frameborder="0" style="width:100%;height: 100%"></iframe>
</body>
</html>