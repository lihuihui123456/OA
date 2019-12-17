<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
	<title>${APP_NAME}</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no"/>
	<%@ include file="/views/aco/common/head.jsp"%>
	<link rel="stylesheet" href="${ctx}/views/cap/login/css/login.css" id="cssfile">
	<link href="${ctx}/views/cap/login/css/skitter.styles.css" type="text/css" media="all" rel="stylesheet" />
	<link rel="stylesheet" href="${ctx}/views/cap/login/css/drag.css">
	<script type="text/javascript" language="javascript" src="${ctx}/views/cap/login/js/jquery.easing.1.3.js"></script>
	<script type="text/javascript" language="javascript" src="${ctx}/views/cap/login/js/jquery.skitter.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/jquery/jquery.cookie.js"></script>
	<script src="${ctx}/views/cap/login/js/login.js"></script>
	<script src="${ctx}/views/cap/login/js/base64.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/login/js/drag.js"></script>
	<script type="text/javascript">
		var win_width = screen.width;
		var win_height = screen.height;

		/**
		 * 页面初始化
		 */
		 //查询logo
		$(document).ready(function(){
			
			$.ajax({
				url : 'downloadFile/getLogoPath',
				type : "post",
				data : {
					type : "dl_logo",
				},
				success : function(data) {
					if (data != "") {
						if (data.logoPath != "") {
							$("#logoPath").attr("src", "downloadFile/doDownLoadPicFile?picPath=" + data.logoPath + "&r=" + new Date());
						}
						if (data.key != "") {
							if(data.key == "false"){
								$(".login-switch").hide();
							}
						}
					}
				},
				error : function(data) {
					alert("服务器出错");
				}
			});
			
			// 初始化图片轮播
			$('.box_skitter_large').css({width: 850, height: 450}).skitter({label: false, numbers: false, theme: 'square'});
			$('.box_skitter_small').css({width: 435, height: 300}).skitter({label: false, numbers: false, interval: 1000, theme: 'clean'});
			$('.box_skitter_medium').css({width: 500, height: 200}).skitter({show_randomly: true, dots: true, interval: 4000, numbers_align: 'center', theme: 'round'});
			$('.box_skitter_normal').css({width: 535, height: 450}).skitter({animation: 'blind', interval: 2000, hideTools: true, theme: 'minimalist'});

			// 重置登录框口
			resizelogin();
		});

		/**
		 * 监听窗口大小改变事件
		 */
		$(window).resizeEnd(function() {
			var win_new_width = screen.width;
			var win_new_height = screen.height;

			if (win_new_width == win_height && win_new_height == win_width) {
				window.top.location = "<%=request.getContextPath()%>/login"

				// 重新赋值
				win_width = win_new_width;
				win_height = win_new_height;
			} else {
				// 重置登录框口
				resizelogin();
			}
		});

		/**
		 * 判断当前窗口是否有顶级窗口，如果有就让当前的窗口的地址栏发生变化
		 */
		function loadTopWindow() {
			if (window.top != null && window.top.document.URL != document.URL) {
				window.top.location = document.URL; //这样就可以让登陆窗口显示在整个窗口了 
			}
		}

		/**
		 * 重置登录框口
		 */
		function resizelogin() {
			// 获取浏览器可用宽、高
			var bodyWidth = document.documentElement.clientWidth || document.body.clientWidth;
			var bodyHeight = document.documentElement.clientHeight || document.body.clientHeight;

			//$("#wh").html("[宽]" + bodyWidth + "     [高]" + bodyHeight);
			
			document.body.scrollLeft = 0;

			//轮播图片位置始终和红色背景位置（上）一致
			$("#box_images").css("top", bodyHeight / 2 - 225);

			// 说明当浏览器可用高度小于600时
			if (bodyHeight < 600) {
				$("body").css("overflow-y", "auto").css("height", bodyHeight + "px");
				$(".login_middle").css({ "top":"100px", "margin-top":"0px" });
				$("#box_images").css("top", "100px");
				$(".login_bottom p").css("top", "580px");
			} else {
				$("body").css("overflow-y", "hidden").css("height", bodyHeight + "px");
				$(".login_middle").css({ "top":"50%", "margin-top":"-225px" });
				$(".login_bottom p").css({"top":"95%"});
			}

			if (bodyWidth >= 1345) {
				//当浏览器可用宽度大于1366时，样式更改
				funLarge();
			} else if (bodyWidth >= 1003 && bodyWidth < 1345 ) {
				//当浏览器可用宽度在1024-1366时，样式更改
				funA();
			} else if (bodyWidth >= 779 && bodyWidth < 1003 ) {
				if(bodyHeight < 600){
					$("#box_images").css("top", "100px");
				}else{
					$("#box_images").css("top", "100px");
				}
				//当浏览器可用宽度在800-1024时，样式更改
				funB();
			}else if(bodyWidth >= 580 && bodyWidth < 779 ){
				//当浏览器可用宽度在580-800时，样式更改，背景和图片隐藏
				funC();
			}else{
				//当浏览器可用宽度小与580时，样式更改
				funSmall();
			}
		}

		//背景和图片显示
		function bgImgShow(){
			$("#box_images").css("display", "block");
			$(".login_middle").css("background", "#d52845");
		}
		
		//当浏览器可用宽度大于1366时，样式更改
		function funLarge(){
			//当浏览器可用宽度大于1366时，后缀名为_1366的一组图片显示，其余隐藏
			$(".box_skitter_large").css("display", "block").siblings().css("display", "none");
			$("#cssfile").attr("href", "${ctx}/views/cap/login/css/login.css");
			$(".login_box").css({ "left":"auto", "right":"-145px" });
			$("body").css("overflow-x", "hidden");
			bgImgShow();
		} 
		
		//当浏览器可用宽度在1024-1366时，样式更改
		function funA(){
			//当浏览器可用宽度在1024-1366之间时，后缀名为_1024的一组图片显示，其余隐藏
			$(".box_skitter_normal").css("display","block").siblings().css("display", "none");
			$("#cssfile").attr("href", "${ctx}/views/cap/login/css/login.css");
			if (isIE8()) {
				$(".login_box").css({ "left":"500px", "right":0 });
			} else {
				$(".login_box").css({ "left":"530px", "right":0 });
			}
			$("body").css("overflow-x","hidden");
			bgImgShow();
		}
		
		//当浏览器可用宽度在800-1024时，样式更改
		function funB(){
			//当浏览器可用宽度在800-1024之间时，后缀名为_800的一组图片显示，其余隐藏
			$(".box_skitter_small").css("display","block").siblings().css("display","none");
			$("#cssfile").attr("href","${ctx}/views/cap/login/css/login-800.css");
			$(".login_middle").css({ "top":0, "margin-top":0 });
			$(".login_box").css({ "left":"auto", "right":"3%" });
			$("body").css({ "width":"100%", "overflow-x":"hidden" });
			bgImgShow();
		}
		
		//当浏览器可用宽度在580-800时，样式更改，背景和图片隐藏
		 function funC(){
			$("#cssfile").attr("href","${ctx}/views/cap/login/css/login.css");
			$("body").css({ "width":"100%", "overflow-x":"hidden" });
			$("#box_images").css("display", "none");
			$(".login_middle").css("background", "#f6f6f6");
			$(".login_box").css({ "left":"280px", "right":0 });
		}
		
		//当浏览器可用宽度小与580时，样式更改
		function funSmall(){
			$("#cssfile").attr("href","${ctx}/views/cap/login/css/login.css");
			$("body").css({ "width":"580px", "overflow-x":"auto" });
			$("#box_images").css("display", "none");
			$(".login_middle").css("background", "#f6f6f6");
			$(".login_box").css({ "left":"270px", "right":0 });
		}

		/**
		 * 插件下载
		 */
		function downPlugins() {
			var feature = 'FullScreen=yes,scrollbars=yes,menubar=no,resizable=yes,location=no,status=no,toolbar=no';  
			var win = window.open("${ctx}/views/cap/login/downplugs/downplugs.jsp", 'EIS', feature);  
			win.resizeTo(screen.width, screen.height);  
			//win.moveTo(0,0);  
		}

		// 错误消息全局变量
		var username = '${userName}';
		
		function loginSwitch(){
			if($(".login-switch").css("background-image").indexOf("2.png")>0){
				$(".login-switch").css("background-image","url(${ctx}/views/cap/login/images/1.png)");
				$("#key-login").css("display","block");
				$("#password-login").css("display","none");
			}else{
				$(".login-switch").css("background-image","url(${ctx}/views/cap/login/images/2.png)");
				$("#key-login").css("display","none");
				$("#password-login").css("display","block");
			}
		}

		/**
		 * 是否IE8浏览器
		 */
		function isIE8() {
			var browser=navigator.appName 
			var b_version=navigator.appVersion 
			var version=b_version.split(";"); 
			var trim_Version=version[1].replace(/[ ]/g,""); 
			if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE8.0") { 
				return true;
			} else {
				return false;
			}
		}
	</script>
	</head>
	<body onload="loadTopWindow()">
		<div class="content">
			<!-- 登录页顶部logo -->
			<div class="login_top">
				<img id="logoPath" src="${ctx}/views/cap/login/images/login_logo.png" />
			</div>

			<!-- 登录页登录框 -->
			<div class="login_middle">
				<div class="login_main">
					<div class="login_box">
						<div class="login-switch" onclick="loginSwitch();"></div>
						<div id="key-login" style="display:none;">
							<h2>CA认证登录</h2>
							<div class="ca-bg"></div>
							<div id="drag" class="drag"></div>
						</div>
						<div id="password-login" style="display:block;">
							<!--  <span id="wh"></span>-->
							<h2>用户登录</h2>
							<form id="loginfrm">
								<p>
									<i class="fa fa-user"></i>
									<input type="text" maxlength="30" id="username" name="username" style="ime-mode:disabled" value="请输入用户名//邮箱//手机" />
									<i class="fa fa-remove" id="removeName" style="display:none;"></i>
								</p>
								<p>
									<i class="fa fa-lock"></i>
									<input type="text" id="password0" value="请输入密码" />
									<input type="text" maxlength="255" id="password" name="password" style="display:none;" />
									<i class="fa fa-remove" id="removePwd" style="display:none;"></i>
								</p>
								<p style="border-bottom: none">
									<img src="${ctx}/views/cap/login/images/no_remember.png" id="remember_btn" />
									<input id="rememberme" type="hidden" />
									<span>记住密码</span>
									<img src="${ctx}/views/cap/login/images/no_remember.png" id="autosubmit_btn" class="img_ml" />
									<input id="autoSubmit" type="hidden" />
									<span>自动登录</span>
								</p>
							</form>
	
							<div class="login_btn" id="login_btn">
								<a id="loginbtn" href="javascript:login();">登&nbsp;&nbsp;录</a>
								<%
									String error = (String) request.getAttribute("error");
									String userName = (String) request.getAttribute("userName"); 
									if (error != null) {
									%>
										<span id="errorspan"><i id="errorMsg" class="fa fa-minus-circle"> <%=error %></i> </span>
									<%
									}
								%>
							</div>
	
							<a class="downplugs" id="downBtn" href="javascript:void(0);" onclick="downPlugins();">插件下载</a>
						</div>
					</div>
				</div>
			</div>

			<!-- 登录页轮播图片 -->
			<div style="margin:0 auto; position:absolute;left:0;z-index:1" id="box_images">
				<div class="box_skitter box_skitter_large">
					<ul>
						<li><img style="cursor: default;" src="${ctx}/views/cap/login/images/1_1366.png" class="directionTop" /></li>
						<li><img style="cursor: default;" src="${ctx}/views/cap/login/images/2_1366.png" class="horizontal" /></li>
						<li><img style="cursor: default;" src="${ctx}/views/cap/login/images/3_1366.png" class="cubeStop" /></li>
					</ul>
				</div>
				<div class="box_skitter box_skitter_normal">
					<ul>
						<li><img style="cursor: default;" src="${ctx}/views/cap/login/images/1_1024.png" class="directionTop" /></li>
						<li><img style="cursor: default;" src="${ctx}/views/cap/login/images/2_1024.png" class="horizontal" /></li>
						<li><img style="cursor: default;" src="${ctx}/views/cap/login/images/3_1024.png" class="cubeStop" /></li>
					</ul>
				</div>
				<div class="box_skitter box_skitter_small">
					<ul>
						<li><img style="cursor: default;" src="${ctx}/views/cap/login/images/1-800.png" class="directionTop" /></li>
						<li><img style="cursor: default;" src="${ctx}/views/cap/login/images/2-800.png" class="horizontal" /></li>
						<li><img style="cursor: default;" src="${ctx}/views/cap/login/images/3-800.png" class="cubeStop" /></li>
					</ul>
				</div>
			</div>

			<!-- 登录页版权信息 -->
			<div class="login_bottom">
				<p>${APP_COPYRIGHT }</p>
			</div>
		</div>

		<div class="clearfix"></div>
		<script type="text/javascript">
			$('#drag').drag();

		</script>
	</body>
</html>