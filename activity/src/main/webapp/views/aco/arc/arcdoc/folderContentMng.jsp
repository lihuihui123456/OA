<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<html>
<head>
<title>个人文件夹</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<%-- <link href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet">
 --%><link href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/views/aco/arc/arcdoc/css/zTreeRightClick.css" />
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.exedit-3.5.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.js"></script>
<script src="${ctx}/views/aco/arc/arcdoc/js/zTreeRightClick.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>

<script type="text/javascript">
var setting = {
	data: {
		simpleData: {
			enable: true,
			idKey: "id",
			pIdKey: "pId",
			rootPId: 0
		}
	},
	callback:{
		onClick:zTreeOnClick,
	}
};

function zTreeOnClick(event,treeId,treeNode){
	if(treeNode.href!='null'&&treeNode.href!=''){
		//$("#listResult").load("${ctx}"+treeNode.href+"?id="+treeNode.id+"&pId="+treeNode.pId);
		window.frames['main_iframe'].location.href = "${ctx}"+treeNode.href+"?id="+treeNode.id+"&pId="+treeNode.pId;
	}
}


var zTree;
$(document).ready(function() {
	var defaultUrl = "${ctx}/arcBidController/goToMain?id=402881eb59211d4a0159213dfb270008&pId=0";
	//档案登记默认打开招投标
	window.frames['main_iframe'].location.href = defaultUrl;
	//ztree初始化
	$.fn.zTree.init($("#folderTree"), setting,${treeList});
	zTree = $.fn.zTree.getZTreeObj("folderTree");	
	zTree.expandAll(true);
	//bootstrapTable初始化
	//$("#listResult").load("${ctx}/arcMtgSumm/index");
});
function publicAlert(param){
	layerAlert(param);
}
function publicConfirm(param,arcId){
	layer.confirm('确定删除吗？', {
		btn : [ '是', '否' ]
	},function(){
		$("#main_iframe")[0].contentWindow.deleteData(arcId);
	});
	 
}
</script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<style type="text/css">
body {
     overflow-y : hidden;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="background:#f2f4f8;">
<input type="hidden" id="privateVal"/>
	<div class="container-fluid content">
		<!-- start: Main Menu -->
		<div class="sidebar " >
			<div class="sidebar-collapse" style="height:100%">
				<div id="sidebar-menu" class="sidebar-menu" style="height:100%;overflow:auto;" >
					<ul id="folderTree" class="ztree"></ul>
				</div>
			</div>
		</div>
		<!-- end: Main Menu -->
		<!-- start: Content -->
		<div role="tabpanel"  class="main" id="listResult">
			<iframe id="main_iframe" name="main_iframe" runat="server" src="" width=100%
			height="470px;" frameborder="no" border="0" scrolling="yes"></iframe>
		</div>
		<!-- end: Content -->
		<!--/container-->
	</div>
<!-- 	<div class="clearfix"></div>
 --></body>
<style type="text/css">
.sidebar {
	position: fixed;
	z-index: 11;
	top: 10px;
	width: 200px;
	background-color: #fff;
	border: 1px solid #ddd;
	padding-bottom: 10px;
}

.sidebar .sidebar-menu {
	width: 200px;
}

.main {
	padding: 0;
	padding-left: 200px;
}

.dept_post_tree {
	font-size: 14px;
	overflow-y: auto;
}

.dept_post_tree a {
	font-size: 14px;
	padding-left: 5px;
}

.dept_post_tree li:hover {
	background-color: #fcf1f1 !important;
	color: #576069 !important;
}

.dept_post_tree li.node-selected {
	background-color: #fcf1f1 !important;
	color: #576069 !important;
}

.node-dept_post_tree {
	border-width: 0 !important;
	background-color: #fff !important;
	color: #576069 !important;
}

.list-group-item {
	padding: 10px;
}

.tablepic td {
	border: 1px #becedb solid;
	padding: 5px;
}

.tablepic th {
	background: #eff0f5;
	border: 1px #becedb solid;
}

.bmw {
	background: #f8f9fd;
}
</style>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>