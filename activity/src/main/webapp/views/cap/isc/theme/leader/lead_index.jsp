<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<title>${APP_NAME}</title> 
	<%@ include file="/views/aco/common/head.jsp"%>
	<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<link href="${ctx}/views/cap/isc/theme/common/css/pages.css" rel="stylesheet">
	<link href="${ctx}/views/cap/isc/theme/common/css/skin-red.css" rel="stylesheet">
	<link href="${ctx}/views/cap/isc/theme/common/css/index-page.css" rel="stylesheet">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/jquery/jquery.cookie.js"></script>

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
	<link href="${ctx}/views/cap/isc/theme/common/css/sys-set.css" rel="stylesheet">
	<%@ include file="/views/cap/common/theme.jsp"%>
	<style type="text/css">
		html, head, body { height: 100%; border:0; padding:0;  margin:0; overflow:hidden; } 
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

	</script>
</head>
<body id="mainbody" >
 	<%@ include file="/views/cap/isc/theme/common/page-header.jsp"%>
	<div class="content">

		<iframe id="lead_home" name="lead_home" src="${ctx}/views/cap/isc/theme/leader/lead_home.jsp"
				width="100%" height="100%" frameborder=0 scrolling=no
				allowTransparency="true" class="window-frame" id="lead-home"> </iframe>
		
	</div>
	<div class="clearfix"></div>
	<div id="footer" class="footer">
		<span style="float: right;padding-right: 10px; vertical-align: middle;">
			<span id="onlineTxt"></span>
			<img id="onlineImg" src="${ctx}/views/cap/isc/theme/common/images/net-online.png" />
		</span>
		<div id="dropup" class="btn-group dropup"
			style="float:right;margin-right:10px;cursor: pointer;">
			<span class="dropdown-toggle" data-toggle="dropdown"
				aria-haspopup="true" aria-expanded="false"><i class="fa fa-gear"></i>系统设置</span>
			<ul class="dropdown-menu sys-set" style="left:-152px">
				<li class="dropdown-menu-header" style="color:#f5f5f5;height:25px;">
				</li>
				<li onclick="profile()" class="info-bom"><a><i
						class="iconfont icon-yonghuzhongxin"></i>用户中心</a></li>
				<c:if test="${themeNum > 1}">
					<li><a data-toggle="modal" onclick="setTheme()"><i
							class="iconfont icon-zhuti"></i>主题门户</a></li>
				</c:if>
				<c:if test="${themeCode == 'person'}">
					<li><a onclick="setLayout()"><i
							class="iconfont icon-desk-layout"></i>桌面布局</a></li>
				</c:if>
				<li class="divider"></li>
				<li class="skin"><a><i class="iconfont icon-huanfu"></i>主题换肤
						<c:forEach items="${skinList }" var="list">
							<span id="${list.skinId }" title="${list.skinName }"
								class="${list.skinCode }" code="${list.skinCode }" onclick="setSkin(this)"></span>
						</c:forEach> </a></li>
				<c:if test="${themeCode != 'leader' && themeCode != 'shortcut'}">
					<li class="skin"><a><i class="iconfont icon-huanfu1"></i>左侧换肤
							<span title="浅灰色" class="white" code="white" onclick="setLeftColor(this)"></span>
							<span title="深灰色" class="gray" code="gray" onclick="setLeftColor(this)"></span>
					</a></li>
				</c:if>
				<!-- 控制消息中心滑动按钮 -->
				<li class="divider"></li>
				<li><a onclick="logout()"><i class="iconfont icon-tuichu"></i>重新登录</a></li>
				<li onclick="showAbout()"><a><i
						class="iconfont icon-guanyu"></i>关于我们</a></li>
			</ul>
		</div>
		
		<p>${APP_COPYRIGHT}</p>
		
	</div>
	
</body>

<!-- 引入JS文件 -->
<script src="${ctx}/views/cap/isc/theme/common/js/pages.js"></script>
<script>
	
	/**
	 * 初始化加载监听窗口改变事件
	 */
	$(window).resizeEnd(function() {
		onWinResize();
	});
	/**
	 * 初始化加载领导桌面内容部分高度
	 */
	$(document).ready(function() {
		onWinResize();
	});
	//计算页面高度
	function onWinResize(){
		var winH = $("#mainbody").height();
		$(".window-frame").height(winH - 60);
	}
	
</script>
</html>