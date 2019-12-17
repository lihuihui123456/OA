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
	<link href="${ctx}/views/cap/isc/theme/common/css/index-page.css" rel="stylesheet">
	<link href="${ctx}/views/cap/isc/theme/shortcut/css/shortcut.css" rel="stylesheet">
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
	  			noticOnNetworkInterrupt();
				// 提示用户网络连接异常
	  			layerAlert("当前系统处于断网状态，请连接网络后重试!");

	  			// 设置主页右下角网络连接图标为网络在线
	  			$("#onlineTxt").text("网络连接异常");
	  			$("#onlineImg").css("display", "none");
  			});

			// 监听系统是否在线
  			window.addEventListener("online", function(e) {
				IS_SYS_ON_LINE = true;
				
				//当在线时，启动消息推送
				noticeOnNetworkResume();
				// 关闭弹出的网络连接异常alert
				layer.closeAll();

				// 设置主页右下角网络连接图标为网络离线
				$("#onlineTxt").text("");
				$("#onlineImg").css("display", "block");
			});
		} else {
			// 监听系统是否离线
			window.attachEvent("offline", function(e) {
	  			IS_SYS_ON_LINE = false;

	  			//变换消息推送状态
	  			noticOnNetworkInterrupt();
				// 提示用户网络连接异常
	  			layerAlert("当前系统处于断网状态，请连接网络后重试!");

	  			// 设置主页右下角网络连接图标为网络在线
	  			$("#onlineTxt").text("网络连接异常");
	  			$("#onlineImg").css("display", "none");
  			});

			// 监听系统是否在线
  			window.attachEvent("online", function(e) {
				IS_SYS_ON_LINE = true;

				// 关闭弹出的网络连接异常alert
				layer.closeAll();

				// 设置主页右下角网络连接图标为网络离线
				$("#onlineTxt").text("");
				$("#onlineImg").css("display", "block");
			});
		}

		/**
		 * 重新登录系统
		 */
		function logout(){
			/* if (confirm('确定重新登录系统吗？')) {
				$.cookie("autoSubmit", "0", {
					expires : 30,
					path : "/"
				});
				window.location.href = "${ctx}/logout";
			} */

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

		//搜索输入框自动补全
		$(function() {
			var cache = {};
            $("#input-word").autocomplete(
            {
                source: function(request, response) {
                    var term = request.term;
                    if (term in cache) {
                        data = cache[term];
                        response($.map(data, function(item) {
                            return { label: item.keyWord, value: item.keyWord }
                        }));
                        return { label: "", value: "" };
                    } else {
                        $.ajax({
                            url: "luceneController/autocomplete",
                            dataType: "json",
                            data: {
                                top: 10,
                                key: term
                            },
                            success: function(data) {
                                if (data.length) 
                                    cache[term] = data;
                               	response($.map(data, function(item) {
                                       return { label: item.keyWord, value: item.keyWord }
                                   }));
								return { label: "", value: "" };
                            }
                        });
                    }
                },
                select: function(event, ui) {
                	//提交搜索...
                    if (ui != '') {
                    	$("#search-input > input").val(ui.item.label);
                    	btnSearch();
                    }
                },
                minLength: 1,
                matchContains: true,        //只要包含输入字符就会显示提示
                autoFill: true,            //自动填充输入框
                mustMatch: true            //与否必须与自动完成提示匹配
            });
		 });
	</script>
	<link href="${ctx}/views/cap/isc/theme/common/css/sys-set.css" rel="stylesheet">
	<%@ include file="/views/cap/common/theme.jsp"%>
	
</head>
<body onload="rload()" id="mainbody" style="overflow:hidden;">
	<%@ include file="/views/cap/isc/theme/common/page-header.jsp"%>
	<div class="container-fluid content">
		<div class="row">
			<!-- start: left -->
			<div class="sidebar">
				<div class="box" style="height: 35%;">
					<div class="carousel">
				 		<iframe id="newsPicsFrame" src="${ctx}/sysNewsPicController/doGetCarouselSysNewsPic" width="330" height="190"  frameborder=0 scrolling=no></iframe> 
					</div>
				</div>
				<div class="box" style="height: 52%;">
					<iframe id="notice_iframe" src="${ctx}/views/cap/isc/theme/leader/noticelist-desk-lead.jsp" width="100%"  frameborder=0 scrolling=no></iframe>
				</div>
			</div>
			<!-- end: left -->
			<!-- start: Content -->
			<div class="main" id="main">
				<div class="row" id="row" style="margin-left:0">
					<div id="natheight" class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style="background-color:#fff;padding-left:0;z-index: 3;">
						<div class="btn_control">
							<i class="iconfont icon-max font22" onclick="btnClick();"></i>
							<!-- <img src="static/aco/images/max.png">  -->
						</div>
						<ul id="myTab" class="nav nav-tabs my_tabs">
						</ul>
						<div class="loading"></div>
					</div>
				</div>
                <div class="row" style="margin-left:0">
					<div id="myTabContent" class="tab-content"></div>
				</div>
			</div>
			<!-- end: Content -->
		</div>
		<!--/container-->
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
								class="${list.skinCode }" onclick="setSkin(this)"></span>
						</c:forEach> </a></li>
				<c:if test="${themeCode != 'leader' && themeCode != 'shortcut'}">
					<li class="skin"><a><i class="iconfont icon-huanfu1"></i>左侧换肤
							<span title="浅灰色" class="white" onclick="setLeftColor(this)"></span>
							<span title="深灰色" class="gray" onclick="setLeftColor(this)"></span>
					</a></li>
				</c:if>
				<!-- 控制消息中心滑动按钮 -->
				<li class="divider"></li>
				<li><a onclick="logout()"><i class="iconfont icon-tuichu"></i>重新登录</a></li>
				<li onclick="showAbout()"><a><i
						class="iconfont icon-guanyu"></i>关于我们</a></li>
			</ul>
		</div>
		<p>
			${APP_COPYRIGHT}
			
		</p>
	</div>
</body>

<!-- 引入JS文件 -->
<script src="${ctx}/static/cap/plugins/bootstrap/js/createtab.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/treeview/js/bootstrap-treeview.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/jquery.mmenu.min.js"></script>
<script src="${ctx}/views/cap/isc/theme/common/js/index.js"></script>
<script src="${ctx}/views/cap/isc/theme/common/js/jquery.nicescroll.js"></script>
<script src="${ctx}/views/cap/isc/theme/common/js/pages.js"></script>
<script src="${ctx}/views/cap/isc/theme/shortcut/js/zoomButton.js"></script>
<script>
	/**
	 * 设置皮肤
	 */
	function setSkin(obj){
		var code = $(obj).attr("class");
		var id = $(obj).attr("id");

		$.ajax({
			type : "POST",
			url : "skinController/doSaveUserSkin",
			async: false,
			data : {id : id,code : code},
			dataType : "json",
			success : function(data) {
				window.location.reload();
			}
		});
	}

	function rload() {
		var options={
				"text":"快捷桌面",
				"id": "home",
				"href":"${ctx}/themeController/shortcutDesk",
			    "pid":window,
			    "modIcon" : "fa fa-home"
		};
		window.createTab(options);
	}

	/**
	 * 设置主题
	 */
	function setTheme(){
		$('#theme').modal('show');
		$('#themeFrame').attr('src','${ctx}/themeController/toSelectTheme');
	}
	
	/**
	 * 关于
	 */
	function showAbout() {
		$('#aboutModal').modal('show');
		$('#aboutFrame').attr('src','indexController/toAbout');
	}
</script>
</html>