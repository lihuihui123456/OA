<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <title>办公系统</title>
	<%@ include file="/views/aco/common/head.jsp"%>
	<link href="${ctx}/static/aco/images/favicon.ico" rel="SHORTCUT ICON" />
	<link href="${ctx}/static/aco/images/favicon.ico" rel="BOOKMARK" />
	<link rel="stylesheet" href="${ctx}/views/cap/isc/theme/person/calendar/assets/css/style.css">
    <script src="${ctx}/views/cap/isc/theme/person/calendar/assets/js/jquery-latest.min.js" type="text/javascript"></script>
    <script src="${ctx}/views/cap/isc/theme/person/calendar/data/events.js" type="text/javascript"></script>
    <script src="${ctx}/views/cap/isc/theme/person/calendar/assets/js/simplecalendar.js" type="text/javascript"></script>
    <%@ include file="/views/cap/common/theme.jsp"%>
  </head>
  <body>
	<div class="container" style="width:100%">
		<div class="row">
			<div class="calendar hidden-print">
				<header>
					<h2 class="month"></h2>
					<a class="btn-prev" href="javascript:;">
						<i class="fa fa-angle-left"></i>
					</a>
					<a class="btn-next" href="javascript:;">
						<i class="fa fa-angle-right"></i>
					</a>
				</header>
				<table>
					<thead class="event-days">
						<tr></tr>
					</thead>
					<tbody class="event-calendar">
						<tr class="1"></tr>
						<tr class="2"></tr>
						<tr class="3"></tr>
						<tr class="4"></tr>
						<tr class="5"></tr>
						<tr class="6"></tr>
					</tbody>
				</table>
			</div>
			<div class="list"></div>
		</div>
	</div>
	<script src="${ctx}/views/cap/isc/theme/common/js/jquery.nicescroll.js"></script>
	<script>
		/**
		 * 初始化加载监听窗口改变事件
		 */
		$(window).resize(function() {
			onCalendarResize();
		});
		/**
		 * 初始化加载设置日历行间距
		 */
		$(document).ready(function() {
			onCalendarResize();
		});
		
		/**
		 * 当浏览器窗口改变时，自动计算日历行间距
		 */
		function onCalendarResize() {
			if (parent.liCounts==undefined) {
				var num = parent.parent.liCounts();
			} else {
				var num = parent.liCounts();
			}
			
			var tdH = 0;
			var rowCounts = CALENDAR_ROW_COUNTS;
			/*if (num > 5) {
				tdH = Math.floor((num - 5) * 42 / 10)-1;
			}*/
			//日历内容部分高度（num *42 + 39为日历框的高度，59为日历控件的头部）
			var conH = num *42 + 39 - 59 ;
			if(rowCounts == 5){
				tdH = Math.floor((conH - rowCounts*30) / 10)-1;
			}
			if(rowCounts == 6){
				tdH = Math.floor((conH - rowCounts*30) / 12)-1;
			}
			
			$(".calendar tbody td").css({
				"margin-top" : tdH,
				"margin-bottom" : tdH
			});
			$(".list").height(conH+59);
		}
		
		$(document).ready(function() {
			calendar.init('calendar/getUserCalendarByToDay');
			<shiro:lacksPermission  name="on:msgpushController:msgpush">
				setInterval(intervalLoadData,600000);
			</shiro:lacksPermission>
		});
	</script>
</body>
</html>