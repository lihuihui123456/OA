<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html lang="zh-CN">
<head>
<title>文件交互</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/static/cap/plugins/bootstrap/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">
<link rel="stylesheet" href="${ctx}/views/cap/mail/css/mail.css">
<!-- 引用 ueditor -->
<script type="text/javascript" charset="utf-8"
	src="${ctx}/static/cap/plugins/UEditor1.4.4.3/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8"
	src="${ctx}/static/cap/plugins/UEditor1.4.4.3/ueditor.all.js"> </script>
<script type="text/javascript" charset="utf-8"
	src="${ctx}/static/cap/plugins/UEditor1.4.4.3/lang/zh-cn/zh-cn.js"></script>
</head>
<body>
	<c:choose>
		<c:when test="${state=='1' }">
			<div>
				<span>${errorMsg}</span>
			</div>
		</c:when>
		<c:otherwise>
			<div class="container-fluid">
				<%@ include file="mail-folder.jsp"%>
				<div class="panel-body mail_main">
					<%@ include file="mail-list.jsp"%>
					<%@ include file="mail-write.jsp"%>
				</div>
			</div>
			<script
				src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
			<script
				src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
			<script type="text/javascript">
					var rootPath = "${ctx}";
					var refreshTime=Number('${refreshInterval}');
					var mailDomain = '${maildomain}';
					var currentEmail = '${currUser}${maildomain}';
				</script>
			<script src="${ctx}/views/cap/mail/js/mail.js"></script>
		</c:otherwise>
	</c:choose>
</body>
</html>