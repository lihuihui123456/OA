<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
		<title>个人桌面财务事项</title>		
		<%@ include file="/views/aco/common/head.jsp"%>
		<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
		<link href="${ctx}/views/cap/isc/theme/common/css/pages.css" rel="stylesheet">
		<link href="${ctx}/views/cap/isc/theme/common/css/skin-red.css" rel="stylesheet">
		<script type="text/javascript">

			$(function(){
				var H = $("#notice_iframe",window.parent.document).height();
				$("#tracePanel").height(H-2);
				intervalLoadData();//首次加载
				
				<shiro:lacksPermission  name="on:msgpushController:msgpush">
					setInterval(intervalLoadData,60000);//定时加载
				</shiro:lacksPermission>
				
			});
		
			function intervalLoadData() {
				if (parent.parent.IS_SYS_ON_LINE) {// 如果系统处于离线状态则不刷新数据
					$("#todoTable").html("");
					//var num = parent.liCounts();
					if (parent.liCounts==undefined) {
						var num = parent.parent.liCounts();
					} else {
						var num = parent.liCounts();
					}
					$.ajax({
						url : '${ctx}/intfcController/getDeskListFinance?num='+ num,
						type : 'post',
						dataType : 'json',
						success : function(data) {
							$("#todoTable").html(data.result);
						}
					});
				}
			}
		
			function openWindow(bizid, url) {
				window.open(url);
			}
		</script>
		<style type="text/css">
			body{
				 background-color:#FFF;
			}
			.panel-other{
				border:1px solid transparent;
			}
			.refresh{
				position:absolute;
				top:2px;
				right:80px;
             }
		</style>
	<%@ include file="/views/cap/common/theme.jsp"%>
	</head>
<body>
<div class="panel panel-other" id="tracePanel">
	<div class="panel-heading">
		<h2>
			<!--  <img src="${ctx}/static/aco/images/title_3.png">-->
			<i class="iconfont icon-genzongshixiang1"></i>
			<strong>财务事项</strong>
		</h2>
		<div class="refresh">
			<a href="javascript:;" class="fa fa-refresh" onclick="intervalLoadData()"></a>
		</div>
	</div>
    <table class="table table-hover table_td" id="todoTable"></table> 					        
</div>
</body>

</html>