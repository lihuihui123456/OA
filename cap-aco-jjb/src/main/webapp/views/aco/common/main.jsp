<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<%@ include file="/views/aco/common/head.jsp"%>
	<title>同联Da3系统应用平台</title>
	<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/font/iconfont.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/index.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
	<style type="text/css">
		.panel-icon {
		  left:1px;
		  top:15px;
		  width: 24px;
		  height: 24px;
		}
	</style>
	<script type="text/javascript">
		/**
		 * 初始化页面相关函数
		 */
		$(function() {
			// 绑定Tab页的右键菜单
		    $("#tabs_main").tabs({
		        onContextMenu : function (e, title) {
		            e.preventDefault();
		            $('#tabs_menu').menu('show', {
		                left : e.pageX,
		                top : e.pageY
		            }).data("tabTitle", title);
		        }
		    });

		    // 实例化Tab页右键菜单的onClick事件
		    $("#tabs_menu").menu({
		        onClick : function (item) {
		        	closeTab(this, item.name);
		        }
		    });
		});

		/**
		 * 点击左侧菜单时，内容区域动态添加Tab标签
		 * @param title Tab标签标题
		 * @param href 链接
		 */
		function addTab(title, href) {
			var tt = $('#tabs_main');
			if (tt.tabs('exists', title)) {
				tt.tabs('select', title);
			} else {
				if (href) {
					var content = createFrame(href);
				} else {
					var content = '未实现';
				}
				tt.tabs('add', {
					title : title,
					closable : true,
					content : content
				});
			}
		}

		/**
		 * 右边center区域打开菜单，关闭tab
		 * @param title Tab标签标题
		 * @param href 链接
		 */
		function closeTab(menu, type) {
		    var curTabTitle = $(menu).data("tabTitle");
		    var tabs = $("#tabs_main");
		
		    if (type === "Close") {
		        tabs.tabs("close", curTabTitle);
		        return;
		    }
		
		    var allTabs = tabs.tabs("tabs");
		    var closeTabsTitle = [];
		
		    $.each(allTabs, function () {
		        var opt = $(this).panel("options");
		        if (opt.closable && opt.title != curTabTitle && type === "Other") {
		            closeTabsTitle.push(opt.title);
		        } else if (opt.closable && type === "All") {
		            closeTabsTitle.push(opt.title);
		        }
		    });
		
		    for (var i = 0; i < closeTabsTitle.length; i++) {
		        tabs.tabs("close", closeTabsTitle[i]);
		    }
		}

		/**
		 * 关闭tab，并刷新父tab
		 */
		function closeAndReloadTab(closeText,reloadText) {
			var tabs = $("#tabs_main");
			tabs.tabs("close", closeText);
			//var tab = tabs.tabs("getTab", reloadText);

			var currTab = tabs.tabs('getTab', reloadText);
			var iframe = $(currTab.panel('options').content);
			var src = iframe.attr('src');
			tabs.tabs('update', { tab: currTab, options: { content: createFrame(src)} });
		}

		function createFrame(url) {  
		    var frame = '<iframe id="mainFrame" name="mainFrame" scrolling="yes" frameborder="0"  src="' + url 
		    + '" style=\"width:100%;height:100%;\"></iframe>';  
		    return frame;  
		}
	</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body id="main_content" class="easyui-layout">
	<!-- 主页顶部(North)Logo及工具区域 -->
	<div data-options="region:'north',split:true" border="false" class="l-topmenu">
		<div class="l-topmenu-l">
			<img class="logo" src="${ctx}/static/cap/images/logo.png" alt="系统管理平台" />
		</div>

		<div class="l-topmenu-r">
			<img src="${ctx}/static/cap/images/user_h.png">
			欢迎您：<label id="userid" style="visibility: hidden"><shiro:principal property='id' /></label>
			<label id="user">
				<shiro:principal property="name" />
			</label>
			<a href="${ctx}/logout" class="l-exit"
				onclick="return confirm('是否确定注销？');"><i class="iconfont">&#xe600;</i> 注销</a>
		</div>
	</div>

	<!-- 主页左侧(West)菜单区域 -->
	<div data-options="region:'west',title:'导航菜单',split:true" style="width: 220px;border:0;">
		<!-- 菜单导航 -->
		<div id="accordion_nav" class="easyui-accordion" fit="true" style="height: auto;background: #2c3749;border-top:1px solid #525b6a;">
			<c:forEach var="module" items="${rootList }">
				<c:set var="id" value="${module.modId }"></c:set>
				<div title="${module.modName }" data-options="iconCls:'${module.modIcon}'" class="navbg">
					<c:forEach var="child" items="${moduleMap[id] }">
						<div class="nav-item">
							<a href="javascript:addTab('${child.modName }', '${ctx}${child.modUrl}')">
							   <span style="padding-left: 10px;">${child.modName }</span>
							</a>
						</div>
					</c:forEach>
				</div>
			</c:forEach>
		</div>	
	</div>

	<!-- 主页中心内容区域(Center) -->
	<div data-options="region:'center'" >
		<div id="tabs_main" class="easyui-tabs" fit="true" border="false">
			<div title="首页" class="tabs_body">
				<div class="tabs_con">
					<ul>
						<li>
							<div class="li_icon">
								<i class="iconfont icon_img icon_red">&#xe605;</i>
							</div>
							<div class="txt">个人信息</div>
							<div class="related_link">
								<a href="javascript:;">查看</a>&nbsp;
								<a href="javascript:;">修改个人信息</a>
							</div>
						</li>
						<li>
							<div class="li_icon">
								<i class="iconfont icon_img icon_ginger">&#xe609;</i>
							</div>
							<div class="txt">个人权限</div>
							<div class="related_link">
								<a href="javascript:;">查看我的权限</a>
							</div>
						</li>
						<li>
							<div class="li_icon">
								<i class="iconfont icon_img icon_lgreen">&#xe606;</i>
							</div>
							<div class="txt">密码管理</div>
							<div class="related_link">
								<a href="javascript:;">修改登录密码</a>
							</div>
						</li>
						<li>
							<div class="li_icon">
								<i class="iconfont icon_img icon_pink">&#xe60a;</i>
							</div>
							<div class="txt">组织机构</div>
							<div class="related_link">
								<a href="javascript:;">查看通讯录</a>
							</div>
						</li>
						<li>
							<div class="li_icon">
								<i class="iconfont icon_img icon_mgreen">&#xe607;</i>
							</div>
							<div class="txt">界面设置</div>
							<div class="related_link">
								<a href="javascript:;">更改我的前台页面布局</a>
							</div>
						</li>
						<li>
							<div class="li_icon">
								<i class="iconfont icon_img icon_blue">&#xe608;</i>
							</div>
							<div class="txt">消息管理</div>
							<div class="related_link">
								<a href="javascript:;">修改我的消息提醒</a>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>

	<!-- 主页底部区域(South) -->
	<div data-options="region:'south'" class="layout-footer" >
		<p>${APP_COPYRIGHT}</p>
	</div>
	
	<!-- Tab右键菜单 -->
	<div id="tabs_menu" class="easyui-menu">
		<div name="Close">关闭 close</div>
		<div name="Other">关闭其他 close other</div>
		<div name="All">关闭所有 close all</div>
	</div>
	<%-- <script src="${ctx}/static/js/jquery.nicescroll.js"></script>
	<script>
	$("#accordion_nav").niceScroll({
		cursorcolor : "#fff",
		cursoropacitymax : 0.5,
		touchbehavior : false,
		cursorwidth : "8px",
		cursorborder : "0",
		cursorborderradius : "8px"
	});
	</script> --%>
</body>
</html>