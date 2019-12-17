<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<title>领导桌面通知公告</title>		
	<%@ include file="/views/aco/common/head.jsp"%>
	<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<link href="${ctx}/views/cap/isc/theme/common/css/pages.css" rel="stylesheet">
	<link href="${ctx}/views/cap/isc/theme/common/css/skin-red.css" rel="stylesheet">
	<script type="text/javascript">
	/*$(function(){
			var H = $("#trace_iframe",window.parent.document).height();
			$("#noticePanel").height(H-2);
		});*/
		$(function(){
			<shiro:lacksPermission  name="on:msgpushController:msgpush">
				setInterval(loadFlow,600000);//定时加载
			</shiro:lacksPermission>
		})
		/** 通知公告查看 **/
		function addTab(id){
			//window.open("${ctx}/notice/findJsNoticeById?id="+id+"&type=open");
			var params={
					"id":"noticeList"+id,
					"href":"${ctx}/notice/findJsNoticeById?id="+id+"&type=open",
					"text":"通知公告"
			};
			window.parent.createTab(params,"noticeLeader");
			refreshUl();
	    }
		
		/** 列出所有接收通知的信息 **/
		function showList(){
			//window.open("${ctx}/notice/toJsNoticeList");
			var params={
					"id":"noticeList",
					"href":'${ctx}/notice/addToJsNoticeList',
					"text":"通知公告"
			};
			window.parent.createTab(params,"noticeLeader");
		}
		
		function refreshUl(){
			if(parent.parent.IS_SYS_ON_LINE) {
	 			//清空通知公告
				$("#notice").html("");
				setTimeout(Flow.init, 100); 
			}
		}
		
		function loadFlow(){
			if(parent.parent.IS_SYS_ON_LINE) {
	 			//清空通知公告
				$("#notice").html("");
				//重新初始化数据
				 Flow.init(); 
			}
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
			/*.panel-other li.list-group-item > .con{
				width:60%;
			}*/
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
	<script src="${ctx}/views/cap/isc/theme/leader/js/dataSources.js"></script>
</body>

</html>