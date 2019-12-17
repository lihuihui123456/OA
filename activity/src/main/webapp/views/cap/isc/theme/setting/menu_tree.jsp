<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>部门岗位人员选择树</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<link href="${ctx}/static/aco/images/favicon.ico" rel="SHORTCUT ICON" />
<link href="${ctx}/static/aco/images/favicon.ico" rel="BOOKMARK" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/add-ons.min.css" rel="stylesheet" />
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/fullcalendar/css/fullcalendar.css" rel="stylesheet" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<style type="text/css">
.sidebar{
	position:fixed;
	z-index:11;
	top:0px;
	background-color: #fff;
	border:1px solid #ddd;
}

.main{
	padding:0;
	padding-left:200px;
}

/*20160516新增*/
.treeview12 li{
	border-left:5px solid transparent ;
}
.treeview12 li:hover {
	/*background: url(${ctx}/static/aco/images/menu_left_bg.jpg) no-repeat;*/
	background-color:#3f454c;
	border-left:5px solid #d33237 ;
}
.treeview12 li.node-selected{
	background-color:#3f454c;
	border-left:5px solid #d33237 ;
}
.sidebar {
	background-color: #576069;
	padding-bottom:60px;
}

.table {
	font-size: 14px;
}
.footer{
  color: #fff;
  position: fixed;
  bottom: 0px;
  left: 0;
  background-color:#d33237;
  height:20px;
  line-height:20px;
  width:100%;
  z-index:16;
  text-align:center;
  font-size:12px;
}
.treeview span.indent{
	margin-left:15px!important;
	margin-right:10px;
}
.btn_control  img{
	position:relative;
	z-index:20;
	cursor:pointer;
}
.navbar-nav.navbar-right:last-child {
  margin-right: -15px;
}
.navbar-right {
  float: right !important;
}
.navbar-nav>li {
  float: left;
}
html, head ,body {
   height: 100%;
   border:0;
   padding:0;
   margin:0;
}
.list-group {
  margin-bottom: 100px;
}
</style>
</head>
<body style="overflow-x:hidden;overflow-y:hidden;">
	<div class="container-fluid content">

			<!-- start: Main Menu -->
			<div class="sidebar ">
				<div class="sidebar-collapse">
					<div id="sidebar-menu" class="sidebar-menu">
						<div id="treeview12" class="treeview12"></div>
					</div>
				</div>
			</div>
			<!-- end: Main Menu -->
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
<script type="text/javascript" src="${ctx}/views/cap/sys/theme/setting/js/menu_tree.js"></script>
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