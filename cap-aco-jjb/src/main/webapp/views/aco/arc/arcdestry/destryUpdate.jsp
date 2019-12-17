<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<style type="text/css">
html, body {
	height: 100%;
	overflow: auto;
}
</style>
<title>档案销毁修改页面</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/views/aco/arc/arcbid/css/navla.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/jquery.dataTables.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/SmoothScroll.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body id="conBody" style="overflow:hidden;">
	<!-- 按钮栏开始 -->
	<div class="panel-body">
		<div class="btn-group" role="group" style="padding: 5px 0px">
			<button id="btn_save_update" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-save" aria-hidden="true"></span>保存
			</button>
		<!-- 		<button id="btn_reset"  type="button" class="btn btn-default btn-sm" >
				<span class="fa fa-refresh" aria-hidden="true"></span>重置
			</button> -->
			<button id="btn_close" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-reply" aria-hidden="true"></span>取消
			</button>
		</div>
		<div id="tabsH">
			<!-- 页签头 -->
<!-- 			<ul id="myTabs" class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active">
					<a href="#destryformUpdate" role="tab" data-toggle="tab">登记信息</a>
				</li>
				<li role="presentation" targetsrc="">
					<a href="#attachment" role="tab" data-toggle="tab">附件</a>
				</li>
			</ul> -->
			<!-- 页签头结束 -->
			<!-- tab页签内容 -->
			<div class="tab-content" id="panel_box">
				<div role="tabpanel" class="tab-pane active" id="destryformUpdate">
					<iframe src="${ctx}/arcDestry/goToFormUpdate?id=${id}" id="form_iframe" runat="server"  
						width="100%" frameborder="no" border="0" scrolling="yes"></iframe>
				</div>
	<%-- 		<div role="tabpanel" class="tab-pane" id="attachment">
				<iframe id="attachment_iframe" runat="server" src="${ctx}/media/bpmaccessory?tableId="+arcId+"&docTyoe=2&showType=form" width="100%"
				height="100%" frameborder="no" border="0" scrolling="yes"></iframe>
			</div> --%>
			</div>
			<!-- tab页签内容结束 -->
		</div>
	</div>
</body>
<script src="${ctx}/views/aco/arc/arcdestry/js/destryUpdate.js"></script>
<script>
/**
 * 初始化加载监听窗口改变事件
 */
$(window).resizeEnd(function() {
	winH();
});
/**
 * 初始化加载设置Iframe高度
 */
$(function(){
	winH();
});
function winH(){
	var bodyHeight = $("#conBody").height();
	var tabsH = bodyHeight-$(".btn-group").height();
	$("#tabsH").height(tabsH);
	$("#form_iframe").height(tabsH);
}
</script>
</html>