<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>${APP_NAME}</title> 
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/static/cap/plugins/bootstrap/css/add-ons.min.css" rel="stylesheet" />
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/fullcalendar/css/fullcalendar.css" rel="stylesheet" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/views/aco/main/css/pages.css" rel="stylesheet">
<link href="${ctx}/views/aco/main/css/skin-red.css" rel="stylesheet">
<%-- <script type="text/javascript" src="${ctx}/static/aco/js/instantmessage/msgRem.js"></script> --%>
<script src="${ctx}/views/aco/userinfo/js/profile.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/jquery/jquery.cookie.js"></script>
<style type="text/css">
.treeview12 {
	font-size: 18px;
	overflow-y: auto;
}

.treeview12 a {
	font-size: 14px;
	padding-left: 10px;
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
<script type="text/javascript">
function logout(){
	layer.confirm('确定重新登录系统吗？', {
		btn : [ '是', '否' ]
	// 按钮
	}, function() {
		$.cookie("autoSubmit", "0", {
			expires : 30,
			path : "/"
		});
		window.location.href = "${ctx}/logout";
	}, function() {
		return;
	});
}


</script>
</head>
<body onload="rload()" id="mainbody" >
	<!-- start: Header -->
	<div id="top-header">
	<div
		style="height:60px; width:453px; position:fixed; top:0; left:0;z-index:100; padding:10px 0 0 20px;">
		<img src="${ctx}/static/aco/images/logo1.png" />
	</div>
	<div class="navbar" id="navbar" role="navigation">
		<div class="container-fluid ">
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown visible-md visible-lg">
					<ul class="nav navbar-nav navbar-actions navbar-right">
						<li class="visible-xs visible-sm"><a href="index.jsp"
							id="sidebar-menu"><i class="fa fa-navicon"></i> </a></li>
					</ul>
				</li>
				<li><a class="search"><i class="fa fa-search"></i> </a>
					<input type="text" placeholder="请输入搜索内容" id="search-input">
				</li>
				<!-- <li id="instantmessage" class="dropdown visible-md visible-lg">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown">
						<i class="fa fa-bell-o"></i><span class="badge" style="display: none;" >0</span> 
					</a>
					<ul id="msgs_display_board" class="dropdown-menu" style="height:450px;"></ul>
				</li> -->
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown"> 
						<img class="user-avatar" id="nav_tx" src="${ctx}/uploader/uploadfile?pic=<shiro:principal property="picture" />" alt="user-mail">
						<label id="user"><shiro:principal property="name" /> </label>
					</a>
					<ul class="dropdown-menu" style="min-width:100%">
						<li class="dropdown-menu-header"><strong>账户信息</strong>
						</li>
						<li onclick="profile()"><a><i 
						        class="fa fa-user"></i>用户中心</a></li>
						 <!-- <li><a data-toggle="modal" data-target="#sz"><i
								class="fa fa-wrench"></i>模版设置</a></li>
						<li><a data-toggle="modal" data-target="#theme"><i
								class="fa fa-file"></i>主题设置</a></li> -->
						<!--  <li><a href="page-invoice.html"><i class="fa fa-usd"></i> Payments <span class="label label-default">10</span></a></li>
							<li><a href="gallery.html"><i class="fa fa-file"></i> File <span class="label label-primary">27</span></a></li> -->
						<li class="divider"></li>
						<li><a onclick="logout()"><i class="fa fa-power-off"></i>重新登录</a></li>
					</ul>
				</li>
				<li><a onclick="logout()"><i class="fa fa-power-off"></i> </a></li>
			</ul>
		</div>
	</div>
	</div>
	<!-- end: Header -->
	<div class="container-fluid content">

		<div class="row">
			<!-- start: Main Menu -->
			<div class="sidebar ">
						<!-- <div id="treeview12" class="treeview12"></div> -->
						<iframe id="menuTree" width="100%" height="100%" frameborder=0 scrolling=auto src="${ctx}/themeController/menuTree">
					</iframe> 
			</div>
			<!-- end: Main Menu -->
			<!-- start: Content -->
			<div class="main" id="main">
				<div class="row" id="row">
					<div id="natheight" class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style="background-color:#fff;padding-left:0;z-index: 3;">
						<div class="btn_control">
							<!-- <i class="fa fa-arrows-alt font16"></i> -->
							<img src="static/aco/images/max.png">
						</div>
						<ul id="myTab" class="nav nav-tabs my_tabs">
						</ul>
						<div class="loading"></div>
					</div>
				</div>
                <div class="row">
					<div id="myTabContent" class="tab-content"></div>
				</div>
			</div>
			<!-- end: Content -->
		</div>
		<!--/container-->
	</div>
	<div class="clearfix"></div>
	<div id="footer" class="footer">
		<p>${APP_COPYRIGHT}</p>
	</div>
	<!-- 设置modal -->
	<div class="modal fade" id="sz">
		<div class="modal-dialog">
			<iframe src="${ctx}/views/aco/home/template/template-choose.jsp"
				height="860" width="600" frameborder=0 scrolling=no
				allowTransparency="true"> </iframe>
		</div>
	</div>
	<!-- 设置/.modal -->
	
	<!-- 设置主题modal -->
	<div class="modal fade" id="theme" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">
					选择主题
					</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<iframe id="themeFrame" name="themeFrame" src=""
							height="260" width="570" frameborder=0 scrolling=auto
							allowTransparency="true"> </iframe>
					</div>
					<div>
						<button class="btn btn-primary" onClick="saveTheme();">选择</button>
						<button class="btn btn-primary" onClick="closeThemeDialog();">关闭</button>
					</div>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- 设置主题/.modal -->
	
</body>

<!-- 引入JS文件 -->
<script src="${ctx}/static/cap/plugins/bootstrap/js/createtab.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/treeview/js/bootstrap-treeview.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/jquery.mmenu.min.js"></script>

<script src="${ctx}/views/aco/main/js/jquery.nicescroll.js"></script>
<script src="${ctx}/views/aco/main/js/pages.js"></script>
<script src="${ctx}/views/aco/main/js/zoomButton.js"></script>
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

	function rload() {
		var themeId = '${themeId}';
		var options={
				"text":"个人桌面",
				"id": "home",
				"href":"${ctx}/themeController/homeView?themeId="+themeId,
			    "pid":window,
			    "icon" : "fa fa-home"
			    
		};
		window.createTab(options);

		var list = '${list}';
		list = eval("("+list+")");
		 jQuery.each(list, function(i,item){  
			 if ("menuTree" == item.pageId) {
				 $("#menuTree").attr("src",'${ctx}'+item.modUrl);
		     }
	     });
	}
</script>
</html>