<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>招投标档案附件</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link href="${ctx}/views/aco/arc/mtgsumm/css/navla.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<script src="${ctx}/views/aco/arc/arcbid/bidatt/js/bidatt.js"></script>
<script type="text/javascript">
window.onload = function(){
	var type = '${type}';
	btnDisabled(type);
}
function isNull(){
	return document.getElementById("form_iframe1").contentWindow.isNull();
}
$(function(){});
</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="paper-outer">
	<div class="paper-inner">
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th>会议纪要<span class="star">*</span></th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=hyjy&showType=form&tableId=${arcId}"   id="form_iframe1" runat="server"  
						width="100%" frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
							
				</tr>
				<tr>
					<th>其他附件</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=qtfj&showType=form&tableId=${arcId}"   id="form_iframe2" runat="server"  
						width="100%" frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
				</tr>	
			</table>
	</div>
</body>
</html>