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
<script type="text/javascript">
	var solId = "${solId}";        //业务解决方案Id
	var bizId = "${bizId}";        //业务Id
	var procdefId = "${procdefId}";//流程定义Id
	var tableName = "${tableName}";//业务表单对应的业务表名
	var sfwType = "${sfwType}";    // 收发文类别
	var isFreeSelect = "${isFreeSelect}";//是否允许自由跳转   0：不允许    1：允许
	var commentColumn = '${commentColumn}';
	/*页面展示参数*/
	var isMainBody = "${isMainBody}";  //是有有正文页签  0：否,  1：是
	var mainBodySRC = "${mainBodySRC}";//正文iframe访问地址
	var formType = "${formType}";
	
	//拟稿生成uuid
	function generateUUID() {
		var temp;
		if(bizId == null || bizId == ""){
			var d = new Date().getTime(); 
			var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, 
			function(c) {   
				var r = (d + Math.random()*16)%16 | 0;   d = Math.floor(d/16);   
				return (c=='x' ? r : (r&0x3|0x8)).toString(16); 
			});
			temp = uuid;
			bizId = temp;
		}else{
			temp = bizId;
		}
		return temp;
	}
</script>
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
		<!-- 	<button id="scan" type="button" style="display: none" class="btn btn-default btn-sm">
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
							<div style="height:100%;overflow:hidden;">
								<iframe id="mainBody_iframe" class="iframe_common" src=""  width="100%" frameborder="no" border="0" marginwidth="0"
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
<script src="${ctx}/views/aco/bpm/template/js/form_template.js"></script>
<script type="text/javascript">
/**
 * 当前展示页签标记
 * bizform ：业务表单页签
 * mainBody : 正文页签
 * attachment ：附件页签
 */
var divId = "bizform";

/**
 * 业务基本信息保存标记
 * N : 未保存
 * Y : 已保存
 */
var iseb = "N";
//判断业务基本信息是否已经保存
function changeIseb() {
	/* var operate = "${operate}";
	checkBizInfo("", operate); */
}

/**
 * 初始化加载监听窗口改变事件
 */
$(window).resizeEnd(function() {
	winH();
});

/*页面初始化事件*/
function init(){
	winH();

	$("li a[href='#mainBody']").children("span").css("cursor","pointer");
	$("#pdf").addClass("close-page");
	$("#word").addClass("close-page");

	if("${isAttachment}" == '1'){
		findattachFile();
	}
}

/**
 * 初始化加载设置Iframe高度
 */
$(function(){
	/*页面初始化*/
	init();
	
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
	
	//表单、正文、附件页签切换事件
	$("#myTabs a").click(function (e) {
		e.preventDefault();
		divId = $(this).attr('href').replace("#","");
		if(divId != "mainBody") {
			$("#scan").hide();
		}else {
			if($("#mainBody_iframe").hasClass("iframe_show")){
				$("#scan").show();
			}else {
				if( !$("#word").hasClass("open-page") && !$("#pdf").hasClass("open-page")){
					$("#word").addClass("close-page").addClass("open-page");
					$("#pdf").addClass("close-page");
					$("#scan").show();
					$("#mainBody_iframe").addClass("iframe_show").attr('src', url);
				}
			}
		}
	});
});
</script>
<script type="text/javascript">
/**
 * 保存业务基本信息
 * @param (String) operate 操作  draft : 拟稿; update : 编辑
 */
function doSaveBpmRuBizInfo(operate) {
	//获取标题
	var title = getBizTitle();
	//获取紧急程度
	var urgency = getUrgencyLevel();
	var params = {
		'bizId' : bizId,
		'solId' : solId,
		'tableName' : tableName,
		'procdefId' : procdefId,
		'title' : title,
		'urgency' : urgency,
		'sfwType' : sfwType
	};
	
	var flag = "N";
	$.ajax({
		url : "bpmRuBizInfoController/doSaveBpmRuBizInfoEntity",
		type : "POST",
		dataType : "text",
		data : params,
		async : false,
		success : function(data) {
			flag = data;
		}
	});
	return flag;
}

//页签时切换加载对应的iframe
 function showPage(tabId, url){
 	if ($('#' + tabId + '_iframe').attr("src") == "") {
 		// 切换到正文时，默认选中word文档
 		url = url + '&bizId=' + bizId;
 		if (tabId != "mainBody") {
 			$('#' + tabId + '_iframe').attr('src', url);
 		}else {
 			//if(!$("#word").hasClass("open-page") && !$("#pdf").hasClass("open-page")){
 				$("#word").addClass("close-page").addClass("open-page");
 				$("#pdf").addClass("close-page");
 				$("#scan").show();
 				$("#mainBody_iframe").addClass("iframe_show").attr('src', url);
 			//}
 		}
 	}
 }
 
 /**注册按钮事件*/
$(function() {
	//送交按钮事件
	$("#btn_send").click(function() {
		changeIndex();
		if($("#form_iframe")[0].contentWindow.validateForm()){
			if(btnSave("${bizId}", "send", "${operate}")){
				//保存正文
				saveMainBody(isMainBody);
				//弹出送交选项窗口
				var src = "bpmRunController/startProcessSendPage?solId=" 
					+solId +"&bizId="+bizId+"&isFreeSelect="+isFreeSelect+"&procdefId="+procdefId+"&fieldName="+commentColumn;
				$("#send_iframe").attr("src", src);
				$("#sendDiv").modal('show');
			}
		}
	});
	
	//暂存按钮事件
	$("#btn_save").click(function() {
		changeIndex();
		if(btnSave("${bizId}", "save", "${operate}")){
			//保存正文
			saveMainBody(isMainBody);
			//关闭当前页面
			closeWindow(true);
		}
	});
	
	//导出按钮事件
	$("#btn_export").click(function() {
		changeIndex();
		if(btnSave("${bizId}", "save", "${operate}")){
			if(formType && formType == "1") {
				location.href="${ctx}/wordController/exportWord?bizId="+bizId;
			}else {
				document.getElementById("form_iframe").contentWindow.exportdoc();
			}
		}
	});
	
	//打印按钮事件
	$("#btn_print").click(function() {
		changeIndex();
		if(btnSave("${bizId}", "save", "${operate}")){
			if(formType && formType == "1") {
				printForm(bizId);
			}else {
				document.getElementById("form_iframe").contentWindow.printPage();
			}
		}
	});
	
	//图片识别
	$("#scan").click(function() {
		scan("${bizId}")
	});
	
	//返回按钮事件
	$("#btn_close").click(function() {
		closeWindow(true);
	});
});
</script>
</html>