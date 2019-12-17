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
				<span class="fa fa-sign-in" aria-hidden="true"></span>送交
			</button>
			<button id="btn_save" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-save" aria-hidden="true"></span>暂存
			</button>
			<button id="btn_export" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-cloud-download" aria-hidden="true"></span> 导出
			</button>
			<button id="btn_print" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-print" aria-hidden="true"></span> 打印
			</button>
		<!-- 	<button id="scan" type="button" style="display: none" class="btn btn-default btn-sm" onclick="scan()">
				<span class="fa fa-camera-retro" aria-hidden="true"></span> 文字识别
			</button> -->
			<button id="btn_close" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-reply" aria-hidden="true"></span>返回
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
						width="100%" frameborder="no" border="0" scrolling="yes"></iframe>
				</div>
				<c:choose>
					<c:when test="${isMainBody== '1' }">
						<div role="tabpanel" class="tab-pane fade in" id="mainBody">
							<%-- <div style="padding-top: 8px;padding-left: 20px;background-color: white;">
								<c:if test="${isphone=='0'}">
									<a href="javascript:void(0);"><img id="wordImg" title="Word文档" alt="Word文档" src="" /></a>
									&nbsp;
									<a href="javascript:void(0);"><img id="pdfImg" title="PDF文档" alt="PDF文档" src="" /></a>
								</c:if>
								<!-- <input type="radio" name="zw" id="word" />Word文档&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="zw" id="pdf" />PDF文档 -->
							</div> --%>
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
</body>
<script type="text/javascript">
	var solId = '${solId}'; //业务解决方案Id
	var bizId = '${bizId}'; //业务流程Id
	var procdefId = '${procdefId}'; //流程定义Id
	var isFreeSelect = '${isFreeSelect}';//是否允许自由跳转   0：不允许    1：允许
	var isMainBody = "${isMainBody}";
	var mainBodySRC = "${mainBodySRC}";
	var commentColumn = '${commentColumn}';
	var formType = "${formType}";
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
		//导出按钮事件
		$("#btn_export").click(function() {
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
				$iframeObj = $("#mainBody_iframe");
				url = mainBodySRC;
				$("#scan").show();
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
		if('${isAttachment}'== '1'){
			findattachFile();
		}
		/* $("li a[href='#mainBody']").children("span").click(function(){
			if ($('#mainBody_iframe').attr("src") != "") {
				var $span = $(this);
				if(!$span.hasClass("open-page")) {
					$span.addClass("open-page").siblings().removeClass("open-page");
					var id = $(this).attr("id");
					var url;
					if(id == "word") {
						url = mainBodySRC;
					}else{
						url = "iWebPdf/toPdfDeitPage?bizId=" + bizId + "&style=edit";
					}
					$('#mainBody_iframe').attr('src', url);
				}
			}
			
		}); */
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
<script src="${ctx}/views/aco/bpm/template/js/form_update.js"></script>
</html>