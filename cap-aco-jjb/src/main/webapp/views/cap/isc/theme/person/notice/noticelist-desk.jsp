<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<title>个人桌面通知公告</title>		
	<%@ include file="/views/aco/common/head.jsp"%>
	<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<link href="${ctx}/views/cap/isc/theme/common/css/pages.css" rel="stylesheet">
	<link href="${ctx}/views/cap/isc/theme/common/css/skin-red.css" rel="stylesheet">
	<script type="text/javascript">
		$(function(){
			var H = $("#trace_iframe",window.parent.document).height();
			$("#noticePanel").height(H-2);
			loadFlow();//首次加载
			<shiro:lacksPermission  name="on:msgpushController:msgpush">
				setInterval(loadFlow,600000);//定时加载
			</shiro:lacksPermission>
		});
		/** 通知公告查看 **/
		function addTab(id){
	    	var options={
					"text":"通知公告-查看",
					"id":"home_tzgg_"+id,
					"href":"notice/findJsNoticeById?id="+id+"&type=open",
					//"pid":window.parent.parent,
					"isDelete" : true,
					"isReturn" : true,
					"isRefresh" : true
			};
			window.parent.parent.createTab(options);
			if(window.parent.parent.setReadNotice){
				window.parent.parent.setReadNotice("cap-aco",id);
			}		
	    }
		
		/** 列出所有接收通知的信息 **/
		function showList(){
			var options={
					"text":"通知公告栏",
					"id":"8a81610c564e5bb201564e5f79530002",
					"href":"notice/addToJsNoticeList",
					//"pid":window
			};
			window.parent.parent.createTab(options);
		}
		function loadFlow(){
			if(parent.parent.IS_SYS_ON_LINE) {
	 			//清空通知公告
				$("#notice").html("");
				//重新初始化数据
				 Flow.init(); 
			}
		}
		
		function refreshUl(){
			if(parent.parent.IS_SYS_ON_LINE) {
	 			//清空通知公告
				$("#notice").html("");
				setTimeout(Flow.init, 100); 
			}
		}

		/* // 定时执行
 		setInterval(function() {
			// 如果系统处于离线状态则不刷新
			if (parent.parent.IS_SYS_ON_LINE) {
				loadFlow();
			}
		}, 60000);  */
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
             .todolist{
				left:30px;
             }
             .panel .panel-heading > h2 > i {
             	top:5px;
             }
		</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="panel panel-other" id="noticePanel">
		<div class="panel-heading">
			<h2>
				<!-- <img src="${ctx}/static/aco/images/title_2.png"> -->
				<i class="iconfont icon-tongzhigonggao"></i>
				<strong>通知公告</strong>
			</h2>
			<div class="refresh">
			<a href="javascript:;" class="fa fa-refresh" onclick="refreshUl()"></a>
		</div>
			<div class="more">
				<a onclick="showList()">MORE</a>
			</div>
		</div>
			<ul class="list-group" id="notice">
	      	</ul>
	</div>
	<script src="${ctx}/views/cap/isc/theme/common/js/sprintf.js"></script> 
	<script src="${ctx}/views/cap/isc/theme/common/js/dataSources.js"></script>
</body>

</html>