<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<title>${APP_NAME}</title>
	<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
	<link href="${ctx}/static/cap/plugins/bootstrap/css/add-ons.min.css" rel="stylesheet" />
	<link href="${ctx}/static/cap/plugins/bootstrap/plugins/fullcalendar/css/fullcalendar.css" rel="stylesheet" />
	<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<link href="${ctx}/views/cap/isc/theme/common/css/pages.css" rel="stylesheet">
	<link href="${ctx}/views/cap/isc/theme/common/css/skin-red.css" rel="stylesheet">
	<link href="${ctx}/static/cap/plugins/msgpush/notice.css" rel="stylesheet">
	<link id="indexPage" href="${ctx}/views/cap/isc/theme/common/css/index-page.css" rel="stylesheet">
	<!-- 消息推送加载jsp -->
	<%@ include file="/views/cap/isc/theme/common/im-page-header.jsp"%>
	<!--rhzm start  -->
	<link rel="stylesheet" type="text/css" href="${ctx}/views/cap/isc/theme/fusion/css/carousel.css" media="screen" alt=""/>
	<link rel="stylesheet" type="text/css" href="${ctx}/views/cap/isc/theme/fusion/css/style.css" media="screen" alt=""/>
	<link rel="stylesheet" type="text/css" href="${ctx}/views/cap/isc/theme/fusion/css/circle.css" media="screen" alt=""/>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/fusion/js/jquery.touchSwipe.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/fusion/js/jquery.carousel.min.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/fusion/js/jquery.mousewheel.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/fusion/js/fusion.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/fusion/js/jquery.circle.min.js"></script>

	<!-- 消息推送JS -->
	<shiro:hasPermission name="on:msgpushController:msgpush">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/msgpush/notice.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/msgpush/pushAPI.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/msgpush/strophe.js"></script>
	</shiro:hasPermission>
	
	<!--搜索自动补全 start  -->
	<link rel="stylesheet" href="${ctx}/views/cap/sys/lucene/css/jquery-ui.css">
	<script type="text/javascript" src="${ctx}/views/cap/sys/lucene/js/jquery-ui.js"></script>
	<!--搜索自动补全 start  -->
	
	<script type="text/javascript" src="${ctx}/static/cap/plugins/jquery/jquery.cookie.js"></script>
	<style type="text/css">
		html, head, body { height: 100%; border:0; padding:0; margin:0; }
	</style>
	<script type="text/javascript">
		// 系统全局变量-系统是否在线
  		var IS_SYS_ON_LINE = true;

		// IE 6 7 8 支持[attachEvent]， IE9以上和其他浏览器支持[addEventListener]
		if (typeof window.addEventListener != "undefined") {
			/** 监听系统是否离线 */
			window.addEventListener("offline", function(e) {
	  			IS_SYS_ON_LINE = false;

				// 提示用户网络连接异常
	  			layerAlert("当前系统处于断网状态，请连接网络后重试!");

	  			// 设置主页右下角网络连接图标隐藏并显示网络连接异常
	  			$("#onlineTxt").text("网络连接异常");
	  			$("#onlineImg").css("display", "none");
  			});

			/** 监听系统是否在线 */
  			window.addEventListener("online", function(e) {
				IS_SYS_ON_LINE = true;

				// 关闭弹出的网络连接异常alert
				layer.closeAll();

				// 设置主页右下角网络连接图标显示并清空网络连接异常
				$("#onlineTxt").text("");
				$("#onlineImg").css("display", "block");
			});
		} else {
			/** 监听系统是否离线 */
			window.attachEvent("offline", function(e) {
	  			IS_SYS_ON_LINE = false;

				// 提示用户网络连接异常
	  			layerAlert("当前系统处于断网状态，请连接网络后重试!");

	  			// 设置主页右下角网络连接图标隐藏并显示网络连接异常
	  			$("#onlineTxt").text("网络连接异常");
	  			$("#onlineImg").css("display", "none");
  			});

			/** 监听系统是否在线 */
  			window.attachEvent("online", function(e) {
				IS_SYS_ON_LINE = true;

				// 关闭弹出的网络连接异常alert
				layer.closeAll();

				// 设置主页右下角网络连接图标显示并清空网络连接异常
				$("#onlineTxt").text("");
				$("#onlineImg").css("display", "block");
			});
		}

		/**
		 * 重新登录系统
		 */
		function logout(){
			layer.confirm('确定重新登录系统吗？', {
				btn : [ '是', '否' ]
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

		/**
		 * 处理键盘事件 禁止后退键（Backspace）密码或单行、多行文本框除外
		 */
		function banBackSpace(e) {
			var ev = e || window.event;// 获取event对象
			var obj = ev.target || ev.srcElement;// 获取事件源
		
			var t = obj.type || obj.getAttribute('type');// 获取事件源类型
		
			// 获取作为判断条件的事件类型
			var vReadOnly = obj.getAttribute('readonly');
			var vEnabled = obj.getAttribute('enabled');
			// 处理null值情况
			vReadOnly = (vReadOnly == null) ? false : vReadOnly;
			vEnabled = (vEnabled == null) ? true : vEnabled;
		
			// 当敲Backspace键时，事件源类型为密码或单行、多行文本的，
			// 并且readonly属性为true或enabled属性为false的，则退格键失效
			var flag1 = (ev.keyCode == 8
					&& (t == "password" || t == "text" || t == "textarea") && (vReadOnly == true || vEnabled != true)) ? true
					: false;
		
			// 当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效
			var flag2 = (ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea") ? true
					: false;
		
			// 判断
			if (flag2) {
				return false;
			}
			if (flag1) {
				return false;
			}
		}
	
		//禁止后退键 作用于Firefox、Opera 
		//document.onkeypress=banBackSpace;
		//禁止后退键 作用于IE、Chrome 
		//document.onkeydown=banBackSpace;
	
		//防止页面后退, 此函数IE不支持
		if (window.navigator.userAgent.toString().toLowerCase().indexOf("msie") == -1) {
			history.pushState(null, null, document.URL);
			window.addEventListener('popstate', function() {
				history.pushState(null, null, document.URL);
			});
		}

	</script>
	<link href="${ctx}/views/cap/isc/theme/common/css/sys-set.css" rel="stylesheet">
	<%@ include file="/views/cap/common/theme.jsp"%>
	<link id="indexColor" href="${ctx}/views/cap/isc/theme/common/css/index-page-color.css" rel="stylesheet">
</head>
<body id="mainbody" >
    <%@ include file="/views/cap/isc/theme/common/page-header.jsp"%>
	<div class="container-fluid content">

		<div class="row">
			<!-- start: Main Menu -->
			<div class="sidebar" onselectstart="return false;" style="-moz-user-select:none;">
				<div class="sidebar-collapse">
					<div id="sidebar-menu" class="sidebar-menu">
						<div id="treeview12" class="treeview12"></div>
					</div>
				</div>
			</div>
			<!-- end: Main Menu -->
			<!-- start: Content -->
			<div class="main" id="main">
				<div class="row" id="row">
					<div id="natheight" class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style="background-color:#fff;padding-left:0;z-index: 3;">
						<div class="btn_control">
							<i class="iconfont icon-max font22" onclick="btnClick();"></i>
							<!-- <img src="static/aco/images/max.png" onclick="btnClick();"> -->
						</div>
						<ul id="myTab" class="nav nav-tabs my_tabs">
						</ul>
						<div class="loading"></div>
					</div>
				</div>
                <div class="row">
					<div id="myTabContent" class="tab-content">
						<div id="home" class="tab-pane fade active in">
							<ul  id="carousel"></ul>
							<div id="foot1">
								<div id="icon_wrap">
									<ul id="icon_wrap_ul" class="test  clearfix-foot-ul"></ul>
								</div>
							</div>
							<!-- 垃圾桶-begin -->
							<div id="trash"></div>
							<!-- 垃圾桶-end -->
							<!-- 垃圾桶-begin -->
							<div id="trash1"></div>
							<!-- 垃圾桶-end -->
						</div>
					</div>
				</div>
			</div>
			<!-- end: Content -->
		</div>
		<!--/container-->
	</div>
	<div class="clearfix"></div>
	<div id="footer" class="footer">
		<p>
			${APP_COPYRIGHT}
			<span style="float: right;padding-right: 10px; vertical-align: middle;">
				<span id="onlineTxt"></span>
				<img id="onlineImg" src="${ctx}/views/cap/isc/theme/common/images/net-online.png" />
			</span>
		</p>
	</div>
	<!-- 即时通讯加载jsp -->
	<%@ include file="/views/cap/isc/theme/common/im-page-footer.jsp"%>
</body>

<!-- 引入JS文件 -->
<script src="${ctx}/static/cap/plugins/bootstrap/js/createtab.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/treeview/js/bootstrap-treeview.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/jquery.mmenu.min.js"></script>

<script src="${ctx}/views/cap/isc/theme/common/js/index.js"></script>

<script src="${ctx}/views/cap/isc/theme/common/js/jquery.nicescroll.js"></script>
<script src="${ctx}/views/cap/isc/theme/common/js/pages.js"></script>
<script src="${ctx}/views/cap/isc/theme/fusion/js/zoomButton.js"></script>
<script>

	$(".sidebar").niceScroll({
		cursorcolor : "#000",
		cursoropacitymax : 0.6,
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

</script>
</html>