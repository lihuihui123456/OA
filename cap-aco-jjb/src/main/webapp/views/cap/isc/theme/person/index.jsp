<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<title>${APP_NAME}</title>
	<%@ include file="/views/aco/common/head.jsp"%>
	<link href="${ctx}/static/cap/plugins/bootstrap/css/add-ons.min.css" rel="stylesheet" />
	<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<link href="${ctx}/views/cap/isc/theme/common/css/pages.css" rel="stylesheet">
	<link href="${ctx}/views/cap/isc/theme/common/css/skin-red.css" rel="stylesheet">
	<link href="${ctx}/static/cap/plugins/msgpush/notice.css" rel="stylesheet">
	<link id="indexPage" href="${ctx}/views/cap/isc/theme/common/css/index-page.css" rel="stylesheet">
	<!-- 消息推送加载jsp -->
	<%@ include file="/views/cap/isc/theme/common/im-page-header.jsp"%>
	<!--搜索自动补全 start  -->
	<link rel="stylesheet" href="${ctx}/views/cap/sys/lucene/css/jquery-ui.css">
	<script type="text/javascript" src="${ctx}/views/cap/sys/lucene/js/jquery-ui.js"></script>
	<!--搜索自动补全 start  -->
	<script type="text/javascript" src="${ctx}/static/cap/plugins/jquery/jquery.cookie.js"></script>
	<style type="text/css">
		html, head, body { height: 100%; border:0; padding:0; margin:0; }
	</style>
	<script type="text/javascript">
		//用户被踢，转到登陆
		window.setInterval(checkSession, 10000); 

		function checkSession(){
			$.ajax({
				url : "validateSession/checkSession",
				type : "post",
				success : function(data) {
					if (data == null || data == undefined || data == '') {
						window.location.href = "${ctx}/login";
					}
				},
			    error: function(XMLHttpRequest, textStatus, errorThrown) {
					 
   				}
			})
		}

		// 系统全局变量-系统是否在线
  		var IS_SYS_ON_LINE = true;
		if (typeof window.addEventListener != "undefined") {
			// 监听系统是否离线
			window.addEventListener("offline", function(e) {
	  			IS_SYS_ON_LINE = false;

	  			//变换消息推送状态
	  			//noticOnNetworkInterrupt();

				// 提示用户网络连接异常
	  			layerAlert("当前系统处于断网状态，请连接网络后重试!");

	  			// 设置主页右下角提示信息为，网络连接异常（此时为离线文字）
	  			$("#onlineTxt").text("网络连接异常");
	  			$("#onlineImg").css("display", "none");
  			});

			// 监听系统是否在线
  			window.addEventListener("online", function(e) {
				IS_SYS_ON_LINE = true;

				//当在线时，启动消息推送
				//noticeOnNetworkResume();

				// 关闭弹出的网络连接异常alert
				layer.closeAll();

				// 设置主页右下角网络连接图标为网络在线（此时为在线图标）
				$("#onlineTxt").text("");
				$("#onlineImg").css("display", "block");
			});
		} else {
			// 监听系统是否离线
			window.attachEvent("offline", function(e) {
	  			IS_SYS_ON_LINE = false;

	  			//变换消息推送状态
	  			//noticOnNetworkInterrupt();

				// 提示用户网络连接异常
	  			layerAlert("当前系统处于断网状态，请连接网络后重试!");

	  			// 设置主页右下角提示信息为，网络连接异常（此时为离线文字）
	  			$("#onlineTxt").text("网络连接异常");
	  			$("#onlineImg").css("display", "none");
  			});

			// 监听系统是否在线
  			window.attachEvent("online", function(e) {
				IS_SYS_ON_LINE = true;

				// 关闭弹出的网络连接异常alert
				layer.closeAll();

				// 设置主页右下角网络连接图标为网络在线（此时为在线图标）
				$("#onlineTxt").text("");
				$("#onlineImg").css("display", "block");
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
			var flag1 = (ev.keyCode == 8 && (t == "password" || t == "text" || t == "textarea") && (vReadOnly == true || vEnabled != true)) ? true : false;
			// 当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效
			var flag2 = (ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea") ? true : false;
			// 判断
			if (flag2) {
				return false;
			}
			if (flag1) {
				return false;
			}
		}

		//禁止后退键 作用于Firefox、Opera 
		document.onkeypress=banBackSpace;
		//禁止后退键 作用于IE、Chrome 
		document.onkeydown=banBackSpace;

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
<body onload="rload()" id="mainbody" style="overflow:hidden;">
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
					<div id="natheight" class="col-lg-12 col-md-12 col-sm-12 col-xs-12 content-tabs" style="margin-left:-5px;background-color:#fff;padding-left:0px;padding-right:0;z-index: 3;border-bottom: 1px solid #DDD;">
						<div class="btn_control">
							<i class="iconfont icon-max font22" onclick="btnClick();"></i>
							<!-- <img src="static/aco/images/max.png">  -->
						</div>
						<div class="roll-nav tab-left"><i class="fa fa-backward"></i></div>
						<div class="blank-white"></div>
						<div class="page-tabs">
						<ul id="myTab" class="nav nav-tabs my_tabs page-tabs-content">
						</ul>
						</div>
						<div class="roll-nav tab-right"><i class="fa fa-forward"></i></div>
		                <div class="roll-right">
		                    <div class="dropdown tab-close" data-toggle="dropdown">关闭<span class="caret"></span></div>
		                    <ul role="menu" class="dropdown-menu dropdown-menu-right" id="tab-close-list">
		                        <%--<li class="tabShowActive"><a>定位当前</a></li>
		                        <li class="divider"></li>--%>
		                        <li class="tabCloseActive"><a>关闭当前标签页</a></li>
		                        <li class="tabCloseOther"><a>关闭其他标签页</a></li>
		                        <li class="tabCloseAll"><a>关闭所有标签页</a></li>
		                    </ul>
		                </div>
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
<script src="${ctx}/views/cap/isc/theme/person/js/zoomButton.js"></script>

<script>
	$(".sidebar").niceScroll({
		cursorcolor : "#000",
		cursoropacitymax : 0.6,
		touchbehavior : false,
		cursorwidth : "8px",
		cursorborder : "0",
		cursorborderradius : "8px"
	});

	$("#noticeItem").niceScroll({
		cursorcolor : "#000",
		cursoropacitymax : 0.3,
		touchbehavior : false,
		cursorwidth : "8px",
		cursorborder : "0",
		cursorborderradius : "8px"
	});

	function rload() {
		var options={
				"text":"个人桌面",
				"id": "home",
				//"href":"${ctx}/views/cap/isc/theme/person/home.jsp",
				"href":"${ctx}/themeController/home",
			    //"pid":window,
			    "modIcon" : "fa fa-home"
		};
		window.createTab(options);
	}
</script>
</html>