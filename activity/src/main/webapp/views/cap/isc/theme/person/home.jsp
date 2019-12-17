<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html lang="zh-CN">
	<head>
	    <title>办公系统</title>		
		<%@ include file="/views/aco/common/head.jsp"%>
		<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<!--[if IE]>
	<script src="${ctx}/static/cap/plugins/bootstrap/js/html5shiv.js"></script>
	<script src="${ctx}/static/cap/plugins/bootstrap/js/respond.min.js"></script>
	<![endif]-->
		<style type="text/css">
			html, head ,body { height: 100%; border:0; padding:0; margin:0; } 
			body{ overflow:auto;} 
			.row{margin-bottom:5px;}
		</style>
	<%@ include file="/views/cap/common/theme.jsp"%>
	</head>
	<body style="padding:10px 10px 5px 0px;" id="allArea">
		<c:choose>
			<c:when test="${not empty content}">
				${content }
			</c:when>
			<c:otherwise>
				<div class="container-fluid ">
			        <div class="row">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" style="margin-bottom: 5px;">
							<!-- 通知公告 -->
							<iframe id="notice_iframe" width="100%" frameborder=0 scrolling=no style="border:1px solid #ddd;">
							</iframe> 
							<!-- 通知公告 end-->
						</div><!--/col-->
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
							<div class="panel panel-other " id="calendarPanel">	
								<!--<div id="calendar"></div>-->
								<iframe id="calendar_iframe" width="100%" frameborder=0 scrolling=no  style="border:1px solid #ddd;padding-right:1px;">
								</iframe>
							</div>
						</div>
					</div>	
					<div class="row">	
						<div class=" col-lg-6 col-md-6 col-sm-6 col-xs-12" style="margin-bottom: 5px;">
							<!-- 待办事项-->
							<iframe id="todo_iframe" width="100%" frameborder=0 scrolling=no style="border:1px solid #ddd;">
							</iframe>
							<!-- 待办事项 end-->
						</div><!--/.col-->	
						<div class="col-lg-6 col-md-6  col-sm-6 col-xs-12">
							<!-- 事项跟踪 -->
							<iframe id="trace_iframe" width="100%" frameborder=0 scrolling=no style="border:1px solid #ddd;padding-right:1px;">
							</iframe>
							<!-- end事项跟踪 -->
						</div><!--/col-->
					</div>
				</div>
			</c:otherwise>
		</c:choose>
	</body>
  	<script type="text/javascript">
	  	/**
		 * 初始化加载监听窗口改变事件
		 */
		$(window).resizeEnd(function() {
			onWinResize();
		});

		/**
		 * 初始化加载设置Iframe高度
		 */
		$(document).ready(function(){
			
			//var perRowNum = $("#allArea .container-fluid").children('.row').length;
			//var perConH = perRowNum *251 + perRowNum*10;
			//var perH = $("#allArea").height();
			
			var mainbody_h = $("#mainbody" , parent.document).height();
			var navbar_h = $("#navbar", parent.document).height();
			var footer_h = $("#footer", parent.document).height();
			var h = mainbody_h - navbar_h - footer_h -45;
			// 动态设置个人桌面的body高度，并赋值给body
			var body_height = document.documentElement.clientHeight || document.body.clientHeight;
			var isMin = $(".btn_control > i", parent.document).attr("class");
			if (isMin.indexOf("icon-min") > 1) {
				$(".window-frame" , parent.document).height(h + 60);
				$('#allArea').css("height", (body_height) + "px");
			} else {
				$(".window-frame" , parent.document).height(h);
				$('#allArea').css("height", body_height + "px");
			}

			//Iframe内部记录条数和高度
			var iframeH = liCounts() * 42 + 39;
			
			$("#calendarPanel").height(iframeH);
			$("iframe").height(iframeH) ;
			
			// 定时刷新页面
			$("#todo_iframe").attr("src","${ctx}/views/cap/isc/theme/person/todo/todolist.jsp");//待办事项
			$("#calendar_iframe").attr("src","${ctx}/views/cap/isc/theme/person/calendar/calendar.jsp");//日历
			$("#notice_iframe").attr("src","${ctx}/views/cap/isc/theme/person/notice/noticelist-desk.jsp");//通知公告
			$("#trace_iframe").attr("src","${ctx}/views/cap/isc/theme/person/trace/tracelist.jsp");//跟踪事项

			//当主页显示一列时
			if(document.body.offsetWidth < 768){
				var iframeH = liCounts() * 42 + 39;
				//$("#allArea").height( iframeH * 4 + 40);
				$("#allArea").css("overflow-y","auto");
			}
		});

		/**
		 * 页面加载时或改变框口大小时，根据电脑分辨率设置个人桌面body的宽度 
		 * 包括：设置个人桌面上下左右边距、设置滚动条自适应
		 */
		function onWinResize() {
			var mainbody_h = $("#mainbody" , parent.document).height();
			var navbar_h = $("#navbar", parent.document).height();
			var footer_h = $("#footer", parent.document).height();
			var h = mainbody_h - navbar_h - footer_h -45;
			// 动态设置个人桌面的body高度，并赋值给body
			var body_height = document.documentElement.clientHeight || document.body.clientHeight;
			var isMin = $(".btn_control > i", parent.document).attr("class");
			if (isMin.indexOf("icon-min") > 1) {
				$(".window-frame" , parent.document).height(h + 60);
				$('#allArea').css("height", (body_height) + "px");
			} else {
				$(".window-frame" , parent.document).height(h);
				$('#allArea').css("height", body_height + "px");
			}
			//Iframe内部记录条数和高度
			var iframeH = liCounts() * 42 + 39;
			$("#calendarPanel").height(iframeH);
			$("iframe").height(iframeH) ;
		}

		/**
		 * 获取Iframe窗口显示记录行数
		 */
		function liCounts(){
			
			var perRowNum = $("#allArea .container-fluid").children('.row').length;
			
			var mainH= $("#myTabContent",window.parent.document).height()-25;
			var titleH = 39 ; // Iframe标题高度
			var rowCounts = Math.floor((mainH / perRowNum - titleH) / 42);
			if(rowCounts < 5){
				rowCounts = 5 ;
			}

			return rowCounts;
		}
	</script>
</html>