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
<title>电子档案业务操作公共页面</title>
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
			<c:if test="${bean.isProcess_== '1' }">
				<%@include file="/views/aco/biz/commons/biz_bpm_btn.jsp"%>
			</c:if>
			<c:if test="${operateState !='view'}">
				<button id="btn_save" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-save" aria-hidden="true"></span> 暂存
				</button>
			</c:if>
			<button id="btn_export" type="button" class="btn btn-default btn-sm" onclick="export_btn()">
				<span class="fa fa-cloud-download" aria-hidden="true"></span> 导出
			</button>
			<button id="btn_print" type="button" class="btn btn-default btn-sm" onclick="print_btn()">
				<span class="fa fa-print" aria-hidden="true"></span> 打印
			</button>
	<!-- 		<button id="scan" type="button" style="display: none" class="btn btn-default btn-sm" onclick="scan()">
				<span class="fa fa-camera-retro" aria-hidden="true"></span> 文字识别
			</button> -->
			<button id="btn_close" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-reply" aria-hidden="true"></span> 返回
			</button>
		</div>
		<div id="tabsH">
			<!-- 页签头 -->
			<ul id="myTabs" class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active">
					<a href="#bizform" role="tab" data-toggle="tab">${bean.formName}</a>
				</li>
				<c:if test="${bean.isMainBody== '1' }">
					<li role="presentation">
						<a href="#mainBody" role="tab" onclick='showPagel("mainBody")' data-toggle="tab">正文  ( 
							<span id="word" title="Word文档" alt="Word文档" >Word</span> | <span id="pdf" title="PDF文档" alt="PDF文档">PDF</span> )
						</a>
					</li>
				</c:if>
				<c:if test="${bean.isAttachment== '1' }">
					<li role="presentation">
						<a id="glwd" href="#attachment" onclick='showPagel("attachment")' role="tab" data-toggle="tab">关联文档(0)</a>
					</li>
				</c:if>
			</ul>
			<!-- 页签头结束 -->
			<!-- tab页签内容 -->
			<div class="tab-content" id="panel_box">
				<div role="tabpanel" class="tab-pane fade in active" id="bizform">
					<iframe src="${ctx}/views/${bean.formUrl}" id="form_iframe" runat="server"  
						width="100%" frameborder="no" border="0" scrolling="yes"></iframe>
				</div>
				<c:if test="${bean.isMainBody== '1' }">
					<div role="tabpanel" class="tab-pane fade in" id="mainBody">
						<div style="height:100%;overflow:hidden;">
							<iframe id="mainBody_iframe" class="iframe_common" src=""  width="100%" frameborder="no" border="0" marginwidth="0"
								marginheight="0" scrolling="yes"></iframe>
							<iframe id="mainBody_pdf_iframe" class="iframe_common" src=""  width="100%"  frameborder="no" border="0" marginwidth="0"
								marginheight="0" scrolling="yes"></iframe>
						</div>
					</div>
				</c:if>
				<c:if test="${bean.isAttachment== '1' }">
					<div role="tabpanel" class="tab-pane fade in" id="attachment">
						<iframe id="attachment_iframe" runat="server" src="" width="100%"
					 frameborder="no" border="0" scrolling="yes"></iframe>
					</div>
				</c:if>
			</div>
			<!-- tab页签内容结束 -->
		</div>
	</div>
	<!-- 引入公共模态框 -->
	<%@ include file="/views/aco/bpm/template/form_modal_commom.jsp"%>
</body>
<!-- 公共按钮操作 begin-->
<script src="${ctx}/views/aco/biz/commons/js/biz_template.js"></script>
<!-- 公共按钮操作 end-->
<script type="text/javascript">
	var divId = "";
	var commentColumn = "";
	
	$(function() {
		if("${bean.isProcess_}" == "1") {
			var url = "bpmRunController/getProcessCommentFildName";
			var params = {solId : "${bean.solId}", procdefId : "${bean.procdefId}"};
			$.post(url, params, function(data) {
				if(data != null) {
					commentColumn = data;
				}
			}, "text");
		}
	});
	//表单参数
	function getFormParam() {
		var params = {
			key : "${bizId}",
			taskId : "${taskId}",
			formid : "${bean.formid}",
			formstype : "${operateState}",
			commentColumn : commentColumn
		};
		return params;
	}
	
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
				$iframeObj = $("#mainBody_iframe");
				url = mainBodySRC;
				$("#scan").show();
			}else{
				$iframeObj = $("#mainBody_pdf_iframe");
				url = "iWebPdf/toPdfDeitPage?bizId=" + "${bizId}" + "&style=edit";
				$("#scan").hide();
			}
			if ($iframeObj.attr("src") == "") {
				$iframeObj.attr('src', url);
			}
			$iframeObj.addClass("iframe_show").siblings().removeClass("iframe_show");
		});
		//页面加载时初始化关联平台文件数量
		if("{bean.isAttachment}"=="1") {
			findattachFile();
		}
		//暂存按钮事件
		$("#btn_save").click(function() {
			changeIndex();
			//保存业务基本信息和表单数据
			if(btnSave("${bizId}","save","${operateState}")) {
				//保存正文
				saveMainBody("${bean.isMainBody}");
				//保存电子档案业务信息保存
				btn_save_earc_biz("${bizId}","${bean.bizCode}",null,null);
				//关闭当前页面并刷新父页面
				closeWindow(true);
			}
		});
		
		
		//送交按钮事件
		$("#btn_send").click(function() {
			changeIndex();
			if($("#form_iframe")[0].contentWindow.validateForm()){
				if(btnSave("${bizId}", "send", "${operateState}")){
					//保存正文
					saveMainBody("${bean.isMainBody}");
					//弹出送交选项窗口
					var src = "";
					if("${operateState}"=="deal") {
						//如果是办理，启动办理方法
						src = "bpmRunController/dealProcess?taskId="+"${taskId}" +"&bizId="+"${bizId}";
					}else {
						src = "bpmRunController/startProcess?solId="+"${bean.solId}" +"&bizId="+"${bizId}";
					}
					$("#send_iframe").attr("src", src);
					$("#sendDiv").modal('show');
				}
			}
		});

	});
	function changeTitle(title){
		$("#glwd").text("关联文档("+title+")")
	}
	//跳转正文，附件
	function showPagel(typel) {
		if(typel=="mainBody") {//mainBody
			var docURL = "${ctx}/iweboffice/toDocumentEdit?fileType=.doc&docType="+"${bean.bizCode}"+"&template=0";
			showPage(typel,docURL);
		}else if(typel=="attachment") {
			var attachmentURL = "media/toDocMgrAtch?bizId="+"${bizId}";
			showPage(typel,attachmentURL);
		}
	}
	
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
			'bizId' : "${bizId}",
			'solId' : "${solId}",
			'tableName' : "${bean.tableName}",
			'procdefId' : "${bean.procdefId}",
			'title' : title,
			'urgency' : urgency,
			'sfwType' : "${bean.bizCode}"
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
	 
	 
	 /**
	* 
	* add by hegd 
	* 电子档案业务信息保存
	* earcId:电子档案Id (必须)  
	* earcType:档案类型   (必须)
	* earcTerm:档案保管期限 (可选)
	* securityLevel:档案密级 (可选)
	*
	*/
	function btn_save_earc_biz(earcId,earcType,earcTerm,securityLevel){
		$.ajax({
			type : "POST",
			url : "earcController/doSaveEarcState",
			data:{
				"earcId":earcId,
				"earcType":earcType,
				"term":earcTerm,
				"securityLevel":securityLevel,
				"earcCtlgId":""
			},
			success : function(data) {
				if(data=="true"){
					//成功
				}else{
					//失败
				}
			},
			error : function(data) {
				layerAlert("error:" + data.responseText);
			}
		});
	}
	
	var formType = "${formType}";
	
	//导出按钮事件
	function export_btn(){
		if(formType && formType == "1") {
			location.href="${ctx}/wordController/exportWord?bizId="+bizId;
		}else {
			document.getElementById("form_iframe").contentWindow.exportdoc();
		}
	}
	
	//打印按钮事件
	function print_btn(){
		if(formType && formType == "1") {
			printForm(bizId);
		}else {
			document.getElementById("form_iframe").contentWindow.printPage();
		}
	}
		
	/**
	* 
	* add by hegd 
	* 电子档案调阅信息保存
	* earcId:电子档案Id (必须)  
	* receiveUser:接收人 (必须)
	* sendUser:发送人 (必须)
	* startDate:开始时间 (必须)
	* endDate:结束时间(必须)
	* 
	*/
	function btn_save_earc_seddRead(earcId,receiveUser,sendUser,startDate,endDate){
		$.ajax({
			type : "POST",
			url : "earcSeddRedController/doSaveSeddRedInfo",
			data:{
				"earcId":earcId,
				"receiveUser":receiveUser,
				"sendUser":sendUser,
				"startDate":startDate,
				"endDate":"endDate"
			},
			success : function(data) {
				if(data=="true"){
					//成功
				}else{
					//失败
				}
			},
			error : function(data) {
				layerAlert("error:" + data.responseText);
			}
		});
	}
	 
</script>
</html>