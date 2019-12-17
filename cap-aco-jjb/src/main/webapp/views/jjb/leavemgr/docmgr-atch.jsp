<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>业务拟稿公共页面-附件</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/jquery-ui/css/jquery-ui-1.10.4.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/add-ons.min.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/jquery-ui/js/jquery-ui-1.10.4.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/jquery.dataTables.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/SmoothScroll.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/createtab.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<style>
.form-control {
	border: 1px #fff solid;
}
.form-group{
	margin-bottom:0;
}
.treeDiv {
	height: 152px;
	overflow-x: hidden;
	overflow: auto;
	text-align: center;
	margin-top: 20px;
	display: none;
	position: absolute;
	margin-top: -160px;
	background-image: url('${ctx}/static/cap/images/treeImg.png');
	background-color: black;
}
.paper-outer{
	background-color: #bebebe; 
	padding:3% 5% 3% 5%;
}
.paper-inner{
	background-color: white;
	padding:3% 5% 3% 5%;
}
.tablestyle th{
	text-align:center;
	vertical-align:middle;
}
</style>
<script type="text/javascript">
$(function(){
	var view='${view}';
	if(view=='1'){
		onlyRead();
	}
});
//查看页面
function onlyRead(){
    var buttons=document.getElementsByTagName("button");
    for(var i=0;i<buttons.length;i++){
    	if(buttons[i].getAttribute("id")!="open" && buttons[i].getAttribute("id")!="resave"){
	    	buttons[i].setAttribute("disabled","disabled");
    	}
    }
}
</script>
</head>

<body class="paper-outer" style="margin-top:-15px\9">
	<div class="paper-inner">
	<table class="tablestyle" width="100%" border="0" cellspacing="0">
		<tr>
			<th height="490">附 件</th>
			<td valign="top">
				<jsp:include page="/media/bpmaccessory?tableId=${bizid}"></jsp:include></td>
		</tr>
	</table>
	</div>
</body>
</html>