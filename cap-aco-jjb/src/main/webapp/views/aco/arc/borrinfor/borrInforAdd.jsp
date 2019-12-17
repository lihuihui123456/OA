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
<title>借阅管理添加页面</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/views/aco/arc/arcbid/css/navla.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/jquery.dataTables.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/SmoothScroll.js"></script>
<script type="text/javascript">
</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body id="conBody" style="overflow:hidden;">
	<!-- 按钮栏开始 -->
	<div class="panel-body">
		<div class="btn-group" role="group" style="padding: 5px 0px">
			<button id="btn_save" type="button" class="btn btn-default btn-sm" style="display:${saveButton};">
				<span class="fa fa-save" aria-hidden="true"></span>保存
			</button>
			<button type="button" id="btn_reset" class="btn btn-default btn-sm" style="display:${resetButton}">
				<span class="fa fa-retweet" aria-hidden="true"></span>重置
			</button>
			<button id="btn_close" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-reply" aria-hidden="true"></span>取消
			</button>
<!-- 			<button type="button" id="btn_export" class="btn btn-default btn-sm">
				<span class="fa fa-retweet" aria-hidden="true"></span>导出
			</button> -->
			<button type="button" id="btn_print" class="btn btn-default btn-sm" style="display:${printButton}">
				<span class="fa fa-retweet" aria-hidden="true"></span>打印
			</button>
		</div>
		<div id="tabsH">
			<div class="tab-content" id="panel_box">
				<div role="tabpanel" class="tab-pane active" id="docinforform">
					<iframe src="${ctx}/borrInforController/${iframePath}?id=${borrInforId}" id="form_iframe" name="form_iframe" runat="server"  
						width="100%" height="100%" frameborder="no" border="0" scrolling="yes"></iframe>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="${ctx}/views/aco/arc/borrinfor/js/borrInforAdd.js"></script>
<script type="text/javascript">
$(function(){
	$("#btn_export").click(function(){
		//导出按钮事件
		location.href="${ctx}/arcWordController/exportWord?template=借阅登记单.ftl&id=${borrInforId}";
	});
	//打印按钮事件
	$("#btn_print").click(function() {
		var id = "${borrInforId}";
		$.ajax({
		    url:"arcWordController/printWord",
			type:"post",
			dataType:"json",
			data : {
				id:id,
				template : "借阅登记单.ftl"
			},
			success:function(data) {
				if(data.filename !=null){
					var url = "${ctx}/arcWordController/openWord?encryption=0&fileType=.doc&&mFileName="+data.filename;
					var options = {
						"text" : "借阅管理-打印",
						"id" : "printWord"+ id,
						"href" :url,
						"pid" : window,
						"isDelete" : true,
						"isReturn" : true,
						"isRefresh" : false
					};
					window.parent.createTab(options);
				}
			}
		}); 
	});
});
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