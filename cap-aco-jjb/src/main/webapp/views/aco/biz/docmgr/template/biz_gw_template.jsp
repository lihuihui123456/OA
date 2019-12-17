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
<title>公文管理拟稿公共页面</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/views/aco/bpm/template/css/navla.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/jquery.dataTables.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/SmoothScroll.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
var divId = "";
var commentColumn = "";
var formType = "${formType}";
var formParams = {
	key : "${bizId}",
	taskId : "${taskId}",
	formid : "${bean.formid}",
	formstype : "${operateState}",
	//formstype :  "${firstNode}" == "Y"?"update":"${operateState}",
	bizno : getBizNo()
};

/**获取当前环节要操作的意见域*/
function getProcssCommentFildName() {
	if("${bean.isProcess_}" == "1") {
		var url = "bpmRunController/getProcessCommentFildName";
		var params = {solId : "${bean.solId}", procdefId : "${bean.procdefId}", taskId : "${taskId}"};
		$.ajax({
			url : url,
			type : "post",
			dataType : "text",
			data : params,
			async : false,
			success : function(data) {
				if(data != null) {
					commentColumn = data;
					formParams["commentColumn"] = data;
				}
			}
		});
	}
}

getProcssCommentFildName();
function getBizNo(){
	 var bizno='';//编号
	 $.ajax({
			url : "bizSolMgr/getBizNo",
			type : "POST",
			dataType : "text",
			data : {solId:"${solId}",procdefId:"${bean.procdefId}",bizId:"${bizId}",bizCode:"${bean.bizCode}",taskId:"${taskId}"},
			async : false,
			success : function(data) {
				bizno=data;
			}
		});
	 return bizno;
}

//表单参数
function getFormParam() {
	return formParams;
}
</script>
</head>
<body id="conBody" style="overflow-y:hidden;">
	<!-- 按钮栏开始 -->
	<div class="panel-body">
		<div class="btn-group" role="group" style="padding-top: 5px">
			<c:if test="${bean.isProcess_== '1' }">
		    <%@include file="/views/aco/biz/commons/biz_bpm_btn.jsp"%>
			</c:if>
			<c:if test="${operateState !='view'}">
				<button id="btn_save" type="button" class="btn btn-default btn-sm" style="margin-bottom:5px">
					<span class="fa fa-save" aria-hidden="true"></span>暂存
				</button>
			</c:if>
			<button id="btn_export" type="button" class="btn btn-default btn-sm" onclick="export_btn()" style="margin-bottom:5px">
				<span class="fa fa-cloud-download" aria-hidden="true"></span> 导出
			</button>
			<!-- 根据solId显示打印按钮 -->
	<c:choose>
       <c:when test="${bean.solId=='537ab38e-c696-4b2a-aeb8-72ed3cd1335e' || bean.solId=='697f840c-551c-4a73-bcdc-a57cf5e17641' || bean.solId=='38696e0a-7c80-4035-9606-077cffb44d82' || bean.solId=='75b814c8-c22f-44cb-ad94-2bae5390166b' || bean.solId=='b30874de-f1f7-40cd-9c5b-bcb49aab414e' || bean.solId=='f4f67c8d-a18c-41d1-9dbd-57e462c0df1b'}">
            <button id="btn_print" type="button" class="btn btn-default btn-sm" onclick="print_btn()" style="margin-bottom:5px;">
				<span class="fa fa-print" aria-hidden="true"></span> 打印发文单
			</button>
       </c:when>
       <c:when test="${bean.solId=='e1496f1c-2fc0-49a8-bef2-8d146255c69b' || bean.solId=='d1f01802-f29e-468f-ab32-a66ea157ecd6'}">
            <button id="btn_print" type="button" class="btn btn-default btn-sm" onclick="print_btn()" style="margin-bottom:5px;">
				<span class="fa fa-print" aria-hidden="true"></span> 打印签报单
			</button>
       </c:when>
       <c:when test="${bean.solId=='f6ef1905-d4bc-4f97-a3de-492dae17b7b5'}">
                  <!-- 总局签报不需要打印按钮 -->
       </c:when>
       <c:otherwise>
             <button id="btn_print" type="button" class="btn btn-default btn-sm" onclick="print_btn()" style="margin-bottom:5px;">
				<span class="fa fa-print" aria-hidden="true"></span> 打印
			</button>
       </c:otherwise>
</c:choose>

	<!-- 		<button id="scan" type="button" style="display: none;margin-bottom:5px;" class="btn btn-default btn-sm" onclick="scan()">
				<span class="fa fa-camera-retro" aria-hidden="true"></span> 文字识别
			</button> -->
				<button id="btn_photo" onclick="photo()" type="button" class="btn btn-default btn-sm" style="margin-left: -4px;">
				<span class="fa fa-share-square-o" aria-hidden="true"></span>拍摄
			</button>
			<button id="btn_close" type="button" class="btn btn-default btn-sm" style="margin-bottom:5px">
				<span class="fa fa-reply" aria-hidden="true"></span>返回
			</button>
			
		</div>
		<div id="tabsH">
			<!-- 页签头 -->
			<ul id="myTabs" class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active">
					<a href="#bizform" onclick='showPagel("bizform")' role="tab" data-toggle="tab">${bean.formName}</a>
				</li>
				<c:if test="${bean.isMainBody== '1' }">
				<c:choose> 
				<c:when test="${bean.formName == '收文管理'||bean.formName == '合同处理单' }">
						<li role="presentation">
						<a href="#mainBody" role="tab"  data-toggle="tab"> 
							<span id="pdf" title="PDF文档" alt="PDF文档" onclick='showPagel("pdf")'>正文  ( PDF</span> | <span id="word" title="Word文档" alt="Word文档" onclick='showPagel("word")'>Word</span> )
						</a>
					</li>
				</c:when>
				<c:otherwise>
						<li role="presentation">
						<a href="#mainBody" role="tab"  data-toggle="tab"> 
							<span id="word" title="Word文档" alt="Word文档" onclick='showPagel("word")'>正文  ( Word</span> | <span id="pdf" title="PDF文档" alt="PDF文档" onclick='showPagel("pdf")'>PDF</span> )
						</a>
					</li>
				</c:otherwise>
			</c:choose>
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
					<iframe src="${ctx}/views/${bean.formUrl}?bizId=${bizId}" id="form_iframe" runat="server"  
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
	<input type="hidden" id="bizCode" name="bizCode" value="${bean.bizCode}"/>
	<input type="hidden" id="operateState" name="operateState" value="${operateState}"/>
</body>
<!-- 公共按钮操作 begin-->
<script src="${ctx}/views/aco/biz/commons/js/biz_template.js"></script>
<!-- 公共按钮操作 end-->
<script type="text/javascript">
    //收文转发文按钮是否显示
	//获取收发文类别
	var bizCode="${bean.bizCode}";
	var operateState= "${operateState}";
	//打印按钮事件
	function print_btn(){
		printForm("${bizId}",formType,"${bean.solId}");
	/* 	if(formType && formType == "1") {
			printForm(bizId);
		}else {
			document.getElementById("form_iframe").contentWindow.printPage();
		} */
	}
	
	//导出按钮事件
	function export_btn(){
		if(formType && formType == "1") {
			location.href="${ctx}/wordController/exportWord?bizId="+bizId;
		}else {
			document.getElementById("form_iframe").contentWindow.exportdoc();
		}
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
		
		//表单、正文、附件页签切换事件
		$("#myTabs a").click(function (e) {
			e.preventDefault();
			divId = $(this).attr('href').replace("#","");
		});
		
		//页面加载时初始化关联平台文件数量
		if("${bean.isAttachment}"=="1") {
			findattachFile("${bizId}");
		}
		//暂存按钮事件
		$("#btn_save").click(function() {
			changeIndex();
			//保存业务基本信息和表单数据
			if(btnSave("${bizId}","save","${operateState}")) {
				//保存正文
				saveMainBody("${bean.isMainBody}");
				//关闭当前页面并刷新父页面
				closeWindow(true);
			}
		});
	});
	function changeTitle(title){
		$("#glwd").text("关联文档("+title+")")
	}
	
	var _type="";
	var bizId = "${bizId}";
	//跳转正文，附件
	function showPagel(typel) {
		_type = typel;
		if(typel=="attachment") {//attachment
			var attachmentURL = "media/toDocMgrAtch?bizId="+"${bizId}";
			if("${operateState}"=="view") {
				attachmentURL = attachmentURL + "&view=1";
			}
			$("#attachment_iframe").attr('src', attachmentURL);
			$("#word").removeClass("open-page");
			$("#pdf").removeClass("open-page");
		}else if(typel=="bizform"){
			$("#word").removeClass("open-page");
			$("#pdf").removeClass("open-page");
		}else {
			
			//modify by hegd 06-12
			var span_ = $("#"+typel);
			if(!span_.hasClass("open-page")) {
				span_.addClass("open-page").siblings().removeClass("open-page");
			}
			if(typel =="pdf"){
				onLoadPdf();
			}else if (typel=="word"){
				onLoadWord();
			}
			/* $("li a[href='#mainBody']").children("span").click(function(){
				if(id == "word") {
					$.ajax({
						url : "bpmRunController/getWordTemplate",
						type : "POST",
						dataType : "text",
						data : {solId:"${bean.solId}",procdefId:"${bean.procdefId}",taskId:"${taskId}"},
						async : false,
						success : function(data) {
							$iframeObj = $("#mainBody_iframe");
							var docURL = "${ctx}/iweboffice/toDocumentEdit?bizId=" + "${bizId}" +"&fileType=.doc&docType="+"${bean.bizCode}"+"&template="+data;
							url = docURL;
							$("#scan").show();
							if ($iframeObj.attr("src") == "") {
								$iframeObj.attr('src', url);
							}
							$iframeObj.addClass("iframe_show").siblings().removeClass("iframe_show");
						}
					});
					
				}else{
					$iframeObj = $("#mainBody_pdf_iframe");
					url = "iWebPdf/toPdfDeitPage?bizId=" + "${bizId}" + "&style=edit";
					$("#scan").hide();
					if ($iframeObj.attr("src") == "") {
						$iframeObj.attr('src', url);
					}
					$iframeObj.addClass("iframe_show").siblings().removeClass("iframe_show");
				}				
			}); */
		}
	}
	
	//加载word正文
	function onLoadWord(){
		var $iframeObj = $("#mainBody_iframe");
		$.ajax({
			url : "bpmRunController/getWordTemplate",
			type : "POST",
			dataType : "text",
			data : {solId:"${bean.solId}",procdefId:"${bean.procdefId}",taskId:"${taskId}"},
			async : false,
			success : function(data) {
				$iframeObj = $("#mainBody_iframe");
				var docURL = "${ctx}/iweboffice/toDocumentEdit?bizId=" + "${bizId}" +"&fileType=.doc&docType="+"${bean.bizCode}"+"&template="+data;
				if("${operateState}"=="view") {
					docURL = docURL + "&editType=0";
				}
				url = docURL;
				$("#scan").show();
				if ($iframeObj.attr("src") == "") {
					$iframeObj.attr('src', url);
				}
				$iframeObj.addClass("iframe_show").siblings().removeClass("iframe_show");
			}
		});
	}
	//加载pdf正文
	function onLoadPdf(){
		$iframeObj = $("#mainBody_pdf_iframe");
		url = "iWebPdf/toPdfDeitPage?bizId=" + "${bizId}" + "&style=edit";
		$("#scan").hide();
		if ($iframeObj.attr("src") == "") {
			$iframeObj.attr('src', url);
		}
		$iframeObj.addClass("iframe_show").siblings().removeClass("iframe_show");
	}
	
	/**
	 * 保存业务基本信息
	 * @param (String) operate 操作  draft : 拟稿; update : 编辑
	 */
	function doSaveBpmRuBizInfo(operate) {
		//获取标题
		var title = getBizTitle();
		var createrId = $("#form_iframe")[0].contentWindow.getFieldVal('ngr_');
		var swsj = $("#form_iframe")[0].contentWindow.getFieldVal('swsj');
		if(swsj==undefined||swsj==null){
			swsj='';
		}
		var lwdw = $("#form_iframe")[0].contentWindow.getFieldVal('lwdw');
		if(lwdw==undefined||lwdw==null){
			lwdw='';
		}
		var lwwh = $("#form_iframe")[0].contentWindow.getFieldVal('number');
		if(lwwh==undefined||lwwh==null){
			lwwh='';
		}
		//获取紧急程度
		var urgency = getUrgencyLevel();
		var params = {
			'bizId' : "${bizId}",
			'solId' : "${solId}",
			'tableName' : "${bean.tableName}",
			'procdefId' : "${bean.procdefId}",
			'title' : title,
			'urgency' : urgency,
			'sfwType' : "${bean.bizCode}",
			'createrId' : createrId,
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
		if(swsj!=null&&swsj!=undefined&&swsj!=''){
			$.ajax({
				url : "bpmRuBizInfoController/updateBpmRuBizInfo",
				type : "POST",
				dataType : "text",
				data : {"bizId":"${bizId}","swsj":swsj,'lwdw':lwdw,'lwwh':lwwh},
				async : false,
				success : function(data) {
				}
			});
		}

		return flag;
	}
	
		//拍摄
	function photo(){
		if (_type != "pdf") {
			return;
		}
		var url = ctx+"/views/aco/pdf/WebCapture-Server-PDF.jsp";
		window.open(url);
	}
</script>
</html>