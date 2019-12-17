<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>工程基建档案附件</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link href="${ctx}/views/aco/arc/mtgsumm/css/navla.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<script src="${ctx}/views/aco/arc/prj/prjatt/js/prjatt.js"></script>
<script type="text/javascript">
window.onload=function() {
	var type = '${type}';
	btnDisabled(type);
};
</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="paper-outer">
	<div class="paper-inner">
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th>图纸</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=tz&showType=form&tableId=${arcId}"   id="form_iframe1" runat="server"  
						width="100%" height="50%" frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
							
				</tr>
				<tr>
					<th>竣工验收单</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=jgysd&showType=form&tableId=${arcId}"   id="form_iframe2" runat="server"  
						width="100%" height="50%" frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
				</tr>	
				<tr>
					<th>其他附件</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=qtfj&showType=form&tableId=${arcId}"   id="form_iframe3" runat="server"  
						width="100%" height="50%" frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
				</tr>		
			</table>
	</div>
</body>
</html>