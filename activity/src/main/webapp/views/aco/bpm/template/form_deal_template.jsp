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
<title>业务拟稿公共页面</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/views/aco/bpm/template/css/navla.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/jquery.dataTables.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/SmoothScroll.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body id="conBody" style="overflow-y:hidden;">
	<!-- 按钮栏开始 -->
	<div class="panel-body">
		<div class="btn-group" role="group" style="padding: 5px 0px">
			<button id="btn_send" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-sign-in" aria-hidden="true"></span> 送交
			</button>
			<button id="btn_back" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-sign-in" aria-hidden="true"></span> 退回
			</button>
			<button id="btn_save" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-save" aria-hidden="true"></span> 暂存
			</button>
			<!-- <button id="btn_swTurnToFw" type="button" class="btn btn-default btn-sm" style="display: none">
				<span class="fa fa-plus" aria-hidden="true"></span>收文转发文
			</button> -->
			<button id="btn_viewFlow" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-sitemap" aria-hidden="true"></span> 查看流程
			</button>
			<button id="fordetails" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-list" aria-hidden="true"></span> 办理详情
			</button>
			<button id="btn_circulation" type="button"  class="btn btn-default btn-sm">
				<span class="fa fa-file-text" aria-hidden="true"></span> 传阅
			</button>
			<button id="btn_export" type="button"  class="btn btn-default btn-sm">
				<span class="fa fa-cloud-download" aria-hidden="true"></span> 导出
			</button>
			<button id="btn_print" type="button"  class="btn btn-default btn-sm">
				<span class="fa fa-print" aria-hidden="true"></span> 打印
			</button>
			<button id="btn_draft" type="button"  class="btn btn-default btn-sm">
				<span class="fa fa-pencil" aria-hidden="true"></span> 另拟新文
			</button>
<!-- 			<button id="scan" type="button" style="display: none" class="btn btn-default btn-sm" onclick="scan()">
				<span class="fa fa-camera-retro" aria-hidden="true"></span> 文字识别
			</button> -->
			<!-- <button id="btn_rollback" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-reply" aria-hidden="true"></span>退回
			</button> -->
			<button id="btn_close" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-reply" aria-hidden="true"></span> 返回
			</button>
		</div>
		
		<div id="tabsH">
			<!-- 页签头 -->
			<ul id="myTabs" class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active"><a href="#bizform"
					role="tab" data-toggle="tab">${formName }</a></li>
				<c:choose>
					<c:when test="${isMainBody== '1' }">
						<li role="presentation" targetsrc="${mainBodySRC}"><a
							href="#mainBody" role="tab"
							onclick='showPage("mainBody","${mainBodySRC}")'
							data-toggle="tab">正文  ( <span id="word" title="Word文档" alt="Word文档" >Word</span> | <span id="pdf" title="PDF文档" alt="PDF文档">PDF</span> )</a></li>
					</c:when>
				</c:choose>
				<c:choose>
					<c:when test="${isAttachment== '1' }">
						<li role="presentation" targetsrc="${attachmentSRC}"><a
							id="glwd" href="#attachment"
							onclick='showPage("attachment","${attachmentSRC}")' role="tab"
							data-toggle="tab">关联文档(0)</a></li>
					</c:when>
				</c:choose>
			</ul>
			<!-- 页签头结束 -->
			<!-- tab页签内容 -->
			<div class="tab-content" id="panel_box">
				<div role="tabpanel" class="tab-pane fade in active" id="bizform">
					<iframe src="${formsrc}" id="form_iframe" runat="server"  
						width="100%" height="100%" frameborder="no" border="0" scrolling="yes"></iframe>
				</div>
				<c:choose>
					<c:when test="${isMainBody== '1' }">
						<div role="tabpanel" class="tab-pane fade in" id="mainBody">
							<!--<div style="padding-left: 20px;background-color: white;">
								<c:if test="${isphone=='0'}">
									<a href="javascript:void(0);"><img id="wordImg" title="Word文档" alt="Word文档" src="" /></a>
									&nbsp;
									<a href="javascript:void(0);"><img id="pdfImg" title="PDF文档" alt="PDF文档" src="" /></a>
								</c:if>

								 <input type="radio" name="zw" id="word" />Word文档&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="zw" id="pdf" />PDF文档 
							</div>-->
							<div style="height:100%;overflow:hidden;">
								<iframe id="mainBody_iframe" class="iframe_common" src=""  width="100%"  frameborder="no" border="0" marginwidth="0"
									marginheight="0" scrolling="yes"></iframe>
								<iframe id="mainBody_pdf_iframe" class="iframe_common" src=""  width="100%"  frameborder="no" border="0" marginwidth="0"
									marginheight="0" scrolling="yes"></iframe>
							</div>
						</div>
					</c:when>
				</c:choose>
				<c:choose>
					<c:when test="${isAttachment== '1' }">
						<div role="tabpanel" class="tab-pane fade in" id="attachment">
							<iframe id="attachment_iframe" runat="server" src="" width="100%"
						 frameborder="no" border="0" scrolling="yes"></iframe>
						</div>
					</c:when>
				</c:choose>
			</div>
			<!-- tab页签内容结束 -->
		</div>
	</div>
	<!-- 引入公共模态框 -->
	<%@ include file="/views/aco/bpm/template/form_modal_commom.jsp"%>
	
	<!-- 办理时传阅选人界面弹出模态框 -->
	<div class="modal fade" id="circulationDiv" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
	  <div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="gridSystemModalLabel">人员选择</h4>
	      </div> 
	      <div class="modal-body" style="text-align: center;">
	      	<iframe id="circulation_iframe" src=""  width="100%" height="450" frameborder="no" border="0" marginwidth="0"
				marginheight="0" scrolling="yes" style=""></iframe>
	      </div>
	      <div class="modal-footer" style="text-align: center;margin-top:0;">
	        <button type="button" class="btn btn-primary" onclick="circulation()">确认</button>
	        <button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
	<!-- 查看流程图 -->
	<div class="modal fade" id="viewFlowPicture" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
	  <div id="viewFlowDiv" class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
	       <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="gridSystemModalLabel">流程图</h4>
	      </div>
	      <div class="modal-body" style="text-align: center; overflow:auto ">
	      	<iframe id="flowPicture" src=""  width="100%" height="300px" frameborder="no" border="0" marginwidth="0"
				marginheight="0" scrolling="yes" style=""></iframe>
	      </div>
	      <div class="modal-footer" style="text-align: center;">
	        <button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	

	
	<!-- 收文转发文 -->
	<div class="modal fade" id="swTurnToFwDiv" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
	  <div class="modal-dialog modal-sm" style="width: 400px;" role="document">
	    <div class="modal-content">
	       <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="gridSystemModalLabel">选择发文类型</h4>
	      </div>
	      <div class="modal-body">
	     	 <iframe id="swTurnToFw_iframe" src="" frameborder="no" border="0" style="width: 100%;height: 80px"></iframe>
	      </div>
	      <div class="modal-footer" style="text-align: center;">
	        <button type="button" class="btn btn-primary" onclick="turn()">确认</button>
	        <button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
</body>
<script type="text/javascript">
	var bizId = '${bizId}'; //业务流程Id
	var taskId = '${taskId}'; //当前任务Id
	var isFreeSelect = '${isFreeSelect}';//是否允许自由跳转   0：不允许    1：允许
	var commentColumn = '${commentColumn}';
	//收文转发文按钮是否显示
	
	var formType =  "${formType}";
	var sfwType="${sfwType}";
	var mainBodySRC = "${mainBodySRC}";
	var isMainBody = "${isMainBody}";
	var procInstId = '${procInstId}'; //流程实例Id
	//导出按钮事件
	$('#btn_export').click(function() {
		if(formType && formType == "1") {
			location.href="${ctx}/wordController/exportWord?bizId="+bizId;
		}else {
			document.getElementById("form_iframe").contentWindow.exportdoc();
		}
	});
	
	
	//打印按钮事件
	$("#btn_print").click(function() {
		if(formType && formType == "1") {
			printForm(bizId);
		}else {
			document.getElementById("form_iframe").contentWindow.printPage();
		}
	});
	
	//查看流程按图钮事件
	$('#btn_viewFlow').click(function() {
		//window.open("${ctx}/bpmRuBizInfoController/toFlowChart?bizid=" +bizId);
		var  options={
				"text":"查看流程图",
				"id":"cklct"+bizId,
				"href":"bpmRuBizInfoController/toFlowChart?bizid=" +bizId,
				"pid":window,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":true
		};
	 	window.parent.createTab(options);
		/*changeIndex();
		var src = 'bpmRuBizInfoController/toFlowChart?bizid=' +bizId;
		//$("#viewFlowDiv").width(document.body.clientWidth+"px");
		$("#flowPicture").attr("src",src);
		$('#viewFlowPicture').modal('show');
		document.getElementById("flowPicture").contentWindow.chart();*/
	});
	//查看办理详情
	$('#fordetails').click(function() {
		var options={
				"text":"办理详情",
				"id":"bizinfodetail"+bizId,
				"href":"${ctx}/bpmRuBizInfoController/toDealDetialPage?procInstId="+procInstId,
				"pid":window,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":true
		};
		window.parent.createTab(options);
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
		$("li a[href='#mainBody']").children("span").css("cursor","pointer");
		$("#pdf").addClass("close-page");
		$("#word").addClass("close-page");
		$("li a[href='#mainBody']").children("span").click(function(){
			var $span = $(this);
			var url;
			var $iframeObj;
			var id = $span.attr("id");
			if(!$span.hasClass("open-page")) {
				$span.addClass("open-page").siblings().removeClass("open-page");
			}
			if(id == "word") {
				$("#scan").show();
				$iframeObj = $("#mainBody_iframe");
				url = mainBodySRC;
			}else{
				$iframeObj = $("#mainBody_pdf_iframe");
				url = "iWebPdf/toPdfDeitPage?bizId=" + bizId + "&style=edit";
				$("#scan").hide();
			}
			if ($iframeObj.attr("src") == "") {
				$iframeObj.attr('src', url);
			}
			$iframeObj.addClass("iframe_show").siblings().removeClass("iframe_show");
		});
		if(window.parent.setReadNotice){
			window.parent.setReadNotice("cap-aco",bizId);	
		}
		if('${isAttachment}'== '1'){
			findattachFile();
		}
	});
	function changeTitle(title){
		$("#glwd").text("关联文档("+title+")")
		}
		//查询平台内的关联文件
	function findattachFile(){
		$.ajax({
			type: "post",  
	        url: "${ctx}/media/findattachFile",
	        dataType: 'json',
	        data: {
	        	bizid:bizId
	        },
	        success: function(data) {
	            if(data!=null){
	             changeTitle(data.length);
	            }
		       
	        }
		});
		
	}
</script>
<script src="${ctx}/views/aco/bpm/template/js/form_common.js"></script>
<script src="${ctx}/views/aco/bpm/template/js/form_deal.js"></script>
</html>