<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>申报课题档案附件</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<script src="${ctx}/views//aco/arc/arcdclr/dclratt/js/dclratt.js"></script>
<script type="text/javascript">
window.onload = function(){
	var type = '${type}';
	btnDisabled(type);
}
</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="paper-outer">
	<div class="paper-inner">
		<iframe src="${ctx}/media/bpmaccessory?docType=sbkt&showType=form&tableId=${arcId}"   id="form_iframe1" runat="server"  
			width="100%" height="100%" frameborder="no" border="0" scrolling="yes"></iframe>
	</div>
</body>
</html>