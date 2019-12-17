<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>办公系统</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<link href="${ctx}/static/aco/images/favicon.ico" rel="SHORTCUT ICON" />
<link href="${ctx}/static/aco/images/favicon.ico" rel="BOOKMARK" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/add-ons.min.css" rel="stylesheet" />
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/fullcalendar/css/fullcalendar.css" rel="stylesheet" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<style type="text/css">
.sidebar{
	position:fixed;
	z-index:11;
	top:0px;
	width:200px;
	background-color: #fff;
	border:1px solid #ddd;
}
.sidebar .sidebar-menu{
	width:200px;
}
.main{
	padding:0;
	padding-left:200px;
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
	background-color:#fcf1f1!important;
	color:#576069!important;
}
.dept_post_tree li.node-selected{
	background-color:#fcf1f1!important;
	color:#576069!important;
}
.node-dept_post_tree{
	border-width:0!important;
	background-color:#fff!important;
	color:#576069!important;
}
.list-group-item {
	padding:10px;
}
</style>
</head>
<body style="overflow-x:hidden;overflow-y:hidden;">
	<div class="container-fluid content">

			<!-- start: Main Menu -->
			<div class="sidebar ">
				<div class="sidebar-collapse">
					<div id="sidebar-menu" class="sidebar-menu">
						<div id="dept_post_tree" class="dept_post_tree"></div>
					</div>
				</div>
			</div>
			<!-- end: Main Menu -->
			<!-- start: Content -->
			<div class="main" id="main">
			
				<div id="search_div" style="width: 300px; float: right; padding-top: 10px;padding-right: 0px;display:none">
					<div class="input-group">
						<input type="text" id="input-word" class="form-control"
							value="输入登录帐号或真实姓名" onFocus="if (value =='输入登录帐号或真实姓名'){value=''}"
							onBlur="if (value ==''){value='输入登录帐号或真实姓名'}"> 
						<span class="input-group-btn">
							<button type="button" class="btn btn-primary" style="margin-right: 0px"
								onclick="search()">
								<i class="fa fa-search"></i> 查询
							</button>
						</span>
					</div>
				</div>
				<table id="userList"></table>
			</div>
			<!-- end: Content -->
		<!--/container-->
	</div>
	<div class="clearfix"></div>
</body>

<!-- 引入JS文件 -->
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/treeview/js/bootstrap-treeview.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/jquery.mmenu.min.js"></script>
<!--引入俩个 core.min.js 
<script src="${ctx}/static/cap/plugins/bootstrap/js/core.min.js"></script>-->
<script type="text/javascript" src="${ctx}/views/cap/isc/org/js/selectOrgDeptUser-bootstrap.js"></script>
<script src="${ctx}/views/aco/main/js/jquery.nicescroll.js"></script>
<script src="${ctx}/views/aco/main/js/pages.js"></script>
<script>
	$(".sidebar").niceScroll({
		cursorcolor : "#fff",
		cursoropacitymax : 0.5,
		touchbehavior : false,
		cursorwidth : "8px",
		cursorborder : "0",
		cursorborderradius : "8px"
	});
	
	$("#msgs_display_board").niceScroll({
		cursorcolor : "#000",
		cursoropacitymax : 0.3,
		touchbehavior : false,
		cursorwidth : "8px",
		cursorborder : "0",
		cursorborderradius : "8px"
	});

	function close() {
		$("#sz").modal("hide");
	}
</script>
</html>