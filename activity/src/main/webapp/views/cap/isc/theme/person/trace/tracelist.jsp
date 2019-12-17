<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
		<title>个人桌面跟踪事项</title>		
		<%@ include file="/views/aco/common/head.jsp"%>
		<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
		<link href="${ctx}/views/cap/isc/theme/common/css//pages.css" rel="stylesheet">
		<link href="${ctx}/views/cap/isc/theme/common/css//skin-red.css" rel="stylesheet">
		<script type="text/javascript">

			$(function(){
				$("#todoArea").html("");
				var H = $("#notice_iframe",window.parent.document).height();
				$("#tracePanel").height(H-2);
				intervalLoadData();//首次加载
				
				<shiro:lacksPermission  name="on:msgpushController:msgpush">
					setInterval(intervalLoadData,600000);//定时加载
				</shiro:lacksPermission>
				
				
				
			});
		
			function intervalLoadData() {
				var rd = "&random=" + Math.random();  
				if (parent.parent.IS_SYS_ON_LINE) {// 如果系统处于离线状态则不刷新数据
					$("#traceArea").html("");
					//var num = parent.liCounts();
					if (parent.liCounts==undefined) {
						var num = parent.parent.liCounts();
					} else {
						var num = parent.liCounts();
					}
					$.ajax({
						url : '${ctx}/bpmTrace/getDeskListTrace?num='+ num+rd,
						type : 'post',
						dataType : 'json',
						success : function(data) {
			   			var thead="<tr><td style='width:100%;'><span></span><span class='count' style='visibility: hidden;'></span><strong>标题</strong></td><td style='text-align: center;width:90px;'><strong>拟稿人</strong></td><td class='count' style='text-align: left;width:95px;'><strong>拟稿时间</strong></td></tr>";
						$("#traceArea").html(thead+data.result);
						}
					});
				}
			}
		
		

			function opentracetab(bizid, solId, id) {
				var options = {
					"text" : "查看-跟踪事项",
					"id" : "home_trace_" + id,
					"href" : "bpmCirculate/findCirculate?bizid=" + bizid + "&solId=" + solId
							+ "&&id=" + id,
					//"pid" : window.parent.parent,
					"isDelete" : true,
					"isReturn" : true,
					"isRefresh" : true
				};
				window.parent.parent.createTab(options);
			}

			function opentab(title, id, url) {
				var options = {
					"text" : title,
					"id" : id,
					"href" : '${ctx}' + url,
					"pid" : window.parent.parent,
					"isDelete" : true,
					"isReturn" : true,
					"isRefresh" : true
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
			<i class="iconfont icon-genzongshixiang"></i>
			<strong>跟踪事项</strong>
		</h2>
		<div class="refresh">
			<a href="javascript:;" class="fa fa-refresh" onclick="intervalLoadData()"></a>
		</div>
		<div class="more">
			<a href="javascript:;" class="more" onclick="opentab('跟踪事项','8a816d115691473c0156920da4200004','/bpmTrace/toTraceTaskList');">MORE</a>
		</div>
	</div>
    <table class="table table-hover table_td" id="traceArea"></table> 					        
</div>
</body>

</html>