<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>iCAP协同应用支撑平台</title>
	<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	<link rel="shortcut icon" href="${ctx}/static/cap/plugins/bootstrap/ico/${APP_LOGO_NAME}.ico" type="image/x-icon" />
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/font/iconfont.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/index.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/jquery/jquery.cookie.js"></script>
	<!-- 悬浮导航CSS、JS文件引入 -->
	<%-- <link href="${ctx}/static/cap/plugins/jqueryFixed/css/style.css" type="text/css" rel="stylesheet">
	<script src="${ctx}/static/cap/plugins/jqueryFixed/js/script.js" type="text/javascript"></script> --%>
	
	<script type="text/javascript" src="${ctx}/views/cap/common/main.js"></script>
	<style type="text/css">
		.panel-icon {
		  left:1px;
		  top:15px;
		  width: 24px;
		  height: 24px;
		}
	</style>
	<script type="text/javascript">
		var path = '${ctx}';
		/** 注销 */
		function logout() {
			$.messager.confirm('重新登录', '确定重新登录系统吗?', function(r) {
				if (r) {
					$.cookie("autoSubmit", "0", {
						expires : 30,
						path : "/"
					});

					window.location.href='${ctx}/logout';
				}
			});
		}
		// 处理键盘事件 禁止后退键（Backspace）密码或单行、多行文本框除外
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
		/**解决IE11 回退问题*/
		$(window).unload(function(){
			window.location.reload();
		});

		/**
		 * 顶层Alert弹框
		 * 调用方式：window.top.msgAlert("消息");
		 */
		function msgAlert(msg) {
			$.messager.alert('提示', msg, 'info');
		}

		/**
		 * 顶层Tip弹框
		 * 调用方式：window.top.msgTip("消息");
		 */
		function msgTip(msg) {
			$.messager.show({ title:'提示', msg: msg, showType:'slide' });
		}
		 
		function closes() {
				$("#Loading").fadeOut("normal", function() {
					$(this).remove();
				});
		}

		var pc;
		$.parser.onComplete = function() {
			if (pc)
				clearTimeout(pc);
			pc = setTimeout(closes, 1000);
		}
	</script>
</head>
<body id="main_content" class="easyui-layout">
	<!-- 主页顶部(North)Logo及工具区域 -->
	<div data-options="region:'north',split:true" border="false" class="l-topmenu">
		<div class="l-topmenu-l">
			<c:choose>
				<c:when test="${not empty logoPath}">
					<img class="logo" src="${ctx}/sysLogoController/doDownLoadPicFile?picPath=${logoPath}" alt="系统管理平台" />
				</c:when>
				<c:otherwise>
					<img class="logo" src="${ctx}/static/cap/images/logo2.png" alt="系统管理平台" />
				</c:otherwise>
			</c:choose>
		</div>

		<div class="l-topmenu-r">
			<img src="${ctx}/static/cap/images/user_h.png">
			<input id="userid" type="hidden" value="<shiro:principal property='id' />"/>
			<label id="user">
				<shiro:principal property="name" />
			</label>
			<a href="javascript:void(0);" class="l-exit"
				onclick="logout();"><i class="iconfont icon-tuichu"></i></a>
		</div>
	</div>

	<!-- 主页左侧(West)菜单区域 -->
	<div data-options="region:'west',title:'导航菜单',split:true" style="width: 200px;border:0;">
		<!-- 菜单导航 -->
		<div id="accordion_nav" class="easyui-accordion" fit="true" style="height: auto;background: #2c3749;border-top:1px solid #525b6a;">
			<c:forEach var="module" items="${rootList }">
				<c:set var="id" value="${module.modId }"></c:set>
				<div title="${module.modName }" data-options="iconCls:'${module.modIcon}'" class="navbg">
					<c:forEach var="child" items="${moduleMap[id] }">
						<div class="nav-item">
							<c:choose>
								<c:when test="${child.modName == '调度管理' || child.modName == '调度日志' || child.modName == '执行器管理'}">
									<a href="javascript:addTab('${child.modName }', '${child.modUrl}?acctLogin=<shiro:principal property='loginName' />&acctPwd=<shiro:principal property='acctPwd' />')">
										<span style="font-size: 18px;" class="${child.modIcon}"></span>
										<span>${child.modName }</span>
									</a>
								</c:when>
								<c:otherwise>
									<a href="javascript:addTab('${child.modName }', '${ctx}${child.modUrl}')">
									   <span style="font-size: 18px;" class="${child.modIcon}"></span>
									   <span>${child.modName }</span>
									</a>
								</c:otherwise>
							</c:choose>
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
						<shiro:hasPermission name="userController:userList">
							<li>
								<img src="${ctx}/static/cap/images/backstage_bg1.png" style="width:100%">
								<div class="li_icon" onclick="addTab('用户管理', '${ctx}/userController/userList')">
									<i class="iconfont icon-geren icon_img"></i>
									<div class="txt">用户管理</div>
								</div>
							</li>
						</shiro:hasPermission>
						<shiro:hasPermission name="roleMenuController:allRoleMenu">
							<li>
								<img src="${ctx}/static/cap/images/backstage_bg2.png" style="width:100%">
								<div class="li_icon" onclick="addTab('功能角色授权', '${ctx}/roleMenuController/allRoleMenu')">
									<i class="iconfont icon-shouquan icon_img"></i>
									<div class="txt">功能角色授权</div>
								</div>
							</li>
						</shiro:hasPermission>
						<shiro:hasPermission name="authSetController:authSetList">
							<li>
								<img src="${ctx}/static/cap/images/backstage_bg3.png" style="width:100%">
								<div class="li_icon" onclick="addTab('数据角色授权', '${ctx}/authSetController/authSetList')">
									<i class="iconfont icon-jiaose icon_img"></i>
									<div class="txt">数据角色授权</div>
								</div>
							</li>
						</shiro:hasPermission>
						<shiro:hasPermission name="operateLogController:operateLogList">
							<li>
								<img src="${ctx}/static/cap/images/backstage_bg4.png" style="width:100%">
								<div class="li_icon" onclick="addTab('操作日志', '${ctx}/operateLogController/operateLogList')">
									<i class="iconfont icon-xitongrizhi icon_img"></i>
									<div class="txt">操作日志</div>
								</div>
							</li>
						</shiro:hasPermission>
						<shiro:hasPermission name="procInst:toListProc">
							<li>
								<img src="${ctx}/static/cap/images/backstage_bg5.png" style="width:100%">
								<div class="li_icon" onclick="addTab('工作流监控', '${ctx}/procInst/toListProc')">
									<i class="iconfont icon-xingnengfenxi icon_img"></i>
									<div class="txt">工作流监控</div>
								</div>
							</li>
						</shiro:hasPermission>
						<shiro:hasPermission name="onlineUserController:onlineUserList">
							<li>
								<img src="${ctx}/static/cap/images/backstage_bg6.png" style="width:100%">
								<div class="li_icon" onclick="addTab('在线用户监控', '${ctx}/onlineUserController/onlineUserList')">
									<i class="iconfont icon-kehujiankong icon_img"></i>
									<div class="txt">在线用户监控</div>
								</div>
							</li>
						</shiro:hasPermission>
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
		<div name="Close">关闭</div>
		<div name="Other">关闭其他 </div>
		<div name="All">关闭所有</div>
	</div>

	<!-- 悬浮导航菜单 -->
	<!-- <div class="menu_nav" id="fd">
		<div class="box" style="display:none;">
			<a class="t1" href="javascript:void(0)" onclick=""></a>
			<a class="t2" href="javascript:void(0)" onclick=""></a>
			<a class="t3" href="javascript:void(0)" onclick="openPwdForm()"></a>
			<a class="t4" href="javascript:void(0)" onclick=""></a>
			<a class="t5" href="javascript:void(0)" onclick=""></a>
			<a class="t6" href="javascript:void(0)" onclick=""></a>
		</div>
	</div> -->
	
	<!-- 修改密码Form表单 -->
	<div id="pwdDialog" class="easyui-dialog"  closed="true" title="修改密码" data-options="modal:true" style="width:460px;height:245px;padding:10px" buttons="#dlg-buttons">
		<form id="pwdForm" method="post">
			<input type="hidden" id="roleId" name="roleId" />
			<table cellpadding="3">
	    		<tr>
	    			<td >原密码<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td >
	    				<input type="password" id="password" name="password"
									class="form-control" placeholder="" onchange="validPWd()" style="width:300px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>新密码<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td>
	    				<input type="password" id="newPassword" name="newPassword"
									class="form-control" placeholder="" onchange="validNewPWd()" style="width:300px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<td >确认密码<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td>
	    				<input type="password" id="conPassword" name="conPassword"
									class="form-control" placeholder="" style="width:300px;">
	    			</td>
	    		</tr>
	    	</table>
		</form>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitForm()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#pwdDialog').dialog('close')" plain="true">取消</a>
	</div>
	<!-- 修改密码Form表单 END -->

	<!--  
	 <script src="${ctx}/static/cap/js/jquery.nicescroll.js"></script>
	<script>
	$(".accordion .accordion-body").niceScroll({
		cursorcolor : "#fff",
		cursoropacitymax : 0.5,
		touchbehavior : false,
		cursorwidth : "8px",
		cursorborder : "0",
		cursorborderradius : "8px"
	});
	</script> -->
	
	<div id='Loading' style="position:absolute;z-index:1000;top:0px;left:0px;width:100%;height:100%;background:#DDDDDB;text-align:center;padding-top: 20%;overflow: hidden;">
	<h5>
		<image src='${ctx}/static/cap/plugins/easyui/themes/cap/images/loading.gif' />
		<font color="#15428B">正在初始化...</font>
	</h5>
</div>
</body>
</html>