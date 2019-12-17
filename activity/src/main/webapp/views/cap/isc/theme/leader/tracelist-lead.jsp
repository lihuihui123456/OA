<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
		<title>领导桌面跟踪事项</title>		
		<%@ include file="/views/aco/common/head.jsp"%>
		<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
		<link href="${ctx}/views/cap/isc/theme/common/css/pages.css" rel="stylesheet">
		<link href="${ctx}/views/cap/isc/theme/common/css/skin-red.css" rel="stylesheet">
		<script type="text/javascript">
			$(function(){
				$("#todoArea").html("");
				var H = $("#notice_iframe",window.parent.document).height();
				$("#tracePanel").height(H-2);
			});
			$(document).ready(function() {
				intervalLoadData();
				setInterval("intervalLoadData()",60000);
			});
			function intervalLoadData(){
				var num = parent.liCounts();
				$.ajax({
				    url:'${ctx}/bpmTrace/getDeskListTrace?num='+num,
					type:'post',
					dataType:'json',
					success:function(data) {
						$("#traceArea").html(data.result);
					}
				});
			}
			function opentracetab(bizid,id){
				var options={
						"text":"跟踪事项",
						"id":id,
						"href":"${ctx}/bpmCirculate/findCirculate?bizid="+bizid+"&&id="+id,
						"pid":window.parent.parent,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":true
				};
				window.parent.parent.createTab(options);
			}
			
			function opentab(title,id,url) {
				var options={
						"text":title,
						"id":id,
						"href":'${ctx}'+url,
						"pid":window.parent.parent,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":true
				};
				window.parent.parent.createTab(options);
			}
		</script>
		<style type="text/css">
			body{
				 background-color:#FFF;
			}
			.panel-other{
				border:1px solid transparent;
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
			<strong>跟踪事项</strong>
			</h2>
		<div class="more">
			<a href="javascript:;" class="more" onclick="opentab('跟踪事项','8a816d115691473c0156920da4200004','/bpmTrace/toTraceTaskList');">MORE</a>
		</div>
	</div>
    <table class="table table-hover table_td" id="traceArea"></table> 					        
</div>
</body>

</html>