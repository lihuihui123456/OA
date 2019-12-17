<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>项目投资档案附件</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link href="${ctx}/views/aco/arc/mtgsumm/css/navla.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<script src="${ctx}/views/aco/arc/inv/invatt/js/invatt.js"></script>
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
					<th>可行性报告</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=kxxbg&showType=form&tableId=${arcId}"   id="form_iframe1" runat="server"  
						width="100%"  frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
							
				</tr>
				<tr>
					<th>审计报告</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=sjbg&showType=form&tableId=${arcId}"   id="form_iframe2" runat="server"  
						width="100%"  frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
				</tr>	
				<tr>
					<th>资产评估报告</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=zcpgbg&showType=form&tableId=${arcId}"   id="form_iframe3" runat="server"  
						width="100%"  frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
				</tr>		
				<tr>
					<th>总经理会议纪要</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=zjlhyjy&showType=form&tableId=${arcId}"   id="form_iframe4" runat="server"  
						width="100%" frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
				</tr>		
				<tr>
					<th>董事会议纪要</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=dshyjy&showType=form&tableId=${arcId}"   id="form_iframe5" runat="server"  
						width="100%"  frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
				</tr>	
				<tr>
					<th>党委会议纪要</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=dwhyjy&showType=form&tableId=${arcId}"   id="form_iframe6" runat="server"  
						width="100%"  frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
				</tr>
				<tr>
					<th>投资协议</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=tzxy&showType=form&tableId=${arcId}"   id="form_iframe7" runat="server"  
						width="100%"  frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
				</tr>
				<tr>
					<th>营业执照</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=yyzz&showType=form&tableId=${arcId}"   id="form_iframe8" runat="server"  
						width="100%"  frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
				</tr>
				<tr>
					<th>章程或章程修正案</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=zc&showType=form&tableId=${arcId}"   id="form_iframe9" runat="server"  
						width="100%"  frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
				</tr>	
				<tr>
					<th>其他附件</th>
					<td>
					<iframe src="${ctx}/media/bpmaccessory?docType=qtfj&showType=form&tableId=${arcId}"   id="form_iframe10" runat="server"  
						width="100%"  frameborder="no" border="0" scrolling="yes"></iframe>
					</td>
				</tr>		
			</table>
	</div>
</body>
</html>