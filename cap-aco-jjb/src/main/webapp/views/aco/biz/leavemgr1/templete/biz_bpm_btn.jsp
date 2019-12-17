<%@ page contentType="text/html;charset=UTF-8"%>
<!--关于工作流处理的按钮栏 -->
<c:if test="${operateState !='view'}">
	<button id="btn_send" type="button" class="btn btn-default btn-sm" style="margin-bottom:5px">
		<span class="fa fa-sign-in" aria-hidden="true"></span> 送交
	</button>
</c:if>
<c:if test="${operateState == 'view' || operateState == 'deal'}"> 
	<button id="btn_viewFlow" type="button" class="btn btn-default btn-sm" style="margin-bottom:5px">
		<span class="fa fa-sitemap" aria-hidden="true"></span> 查看流程图
	</button>
</c:if>
		<button id="btn_swTurnToFw" type="button" class="btn btn-default btn-sm" style="margin-bottom:5px;display: none">
				<span class="fa fa-plus" aria-hidden="true"></span>收文转发文
			</button>
<c:if test="${not empty taskId}">
	<button id="btn_back" type="button" class="btn btn-default btn-sm" style="margin-bottom:5px">
		<span class="fa fa-sign-in" aria-hidden="true"></span> 退回
	</button>
<!-- 	<button id="btn_circulation" type="button"  class="btn btn-default btn-sm" style="margin-bottom:5px">
		<span class="fa fa-file-text" aria-hidden="true"></span> 传阅
	</button> -->
</c:if>
<c:if test="${operateState == 'view' || operateState == 'deal'}">
	<button id="fordetails" type="button" class="btn btn-default btn-sm" style="margin-bottom:5px">
		<span class="fa fa-list" aria-hidden="true"></span> 办理详情
	</button>
</c:if>
<c:if test="${not empty taskId}">
	<button id="btn_draft" type="button"  class="btn btn-default btn-sm" style="margin-bottom:5px">
		<span class="fa fa-pencil" aria-hidden="true"></span> 另拟新文
	</button>
</c:if>
<script type="text/javascript">
$(function() {
	init();
	if('${firstNode}' == 'Y') {
		$("#btn_back").hide();
	}
	
	//送交按钮事件
	$("#btn_send").click(function() {
		
	
		changeIndex();
		if($("#form_iframe")[0].contentWindow.validateForm()){
			if("${operateState}"=="deal"){
				//请假管理只有处理和结束节点，因此只有结束处理时候请假逻辑不用加
				if("${endTask}"=="Y"){
					$("#form_iframe")[0].contentWindow.setState("2");					
				}else{
					$("#form_iframe")[0].contentWindow.setState("3");					
				}			
			}else{
				$("#form_iframe")[0].contentWindow.setState("3");					
			}
			//撤回后表单信息不需要重新保存end
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
				$("#sendDivLabel").html("送交选项");
				$("#sendDiv").modal('show');
			}
		}
	});
	//查看流程按图钮事件
	$('#btn_viewFlow').click(function() {
		var  options={
				"text":"查看流程图",
				"id":"cklct"+"${bizId}",
				"href":"${ctx}/bpmRuBizInfoController/toFlowChart?bizid=" +"${bizId}",
				"pid":window,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":false
		};
	 	window.parent.createTab(options);
	});
	//退回按钮事件
	$("#btn_back").click(function() {
		changeIndex();
		$.ajax({
			url : "${ctx}/bpmRunController/checkProcessBack",
			type : "post",
			data : {"taskId" : "${taskId}"},
			dataType : "json",
			async : false,
			success : function(data) {
				if(data != null && data.flag == "Y") {
					//撤回后表单信息不需要重新保存start
					
					//撤回后表单信息不需要重新保存end
				if(true){
					//if(btnSave("${bizId}", "send", "${operateState}")){
			        	//保存正文
						saveMainBody("${bean.isMainBody}");
			        	
			        	var src = "${ctx}/bpmRunController/runProcessBackPage?bizId="+"${bizId}"+"&taskId="+"${taskId}";
						$('#send_iframe').attr('src', src);
						$("#sendDivLabel").html("退回选项");
						$('#sendDiv').modal('show');
			        }
				}else {
					layerAlert(data.msg + "环节不可退回！");
				}
			}
		});
	});
	//查看办理详情
	$('#fordetails').click(function() {
		var options={
				"text":"办理详情",
				"id":"bizinfodetail"+"${bizId}",
				"href":"${ctx}/bpmRuBizInfoController/toDealDetialPage?bizId="+"${bizId}",
				"pid":window,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":false
		};
		window.parent.createTab(options);
	});
	$("#btn_circulation").click(function() {
		changeIndex();
		$("#circulation_iframe").attr("src","treeController/zMultiPurposeContacts?state=1");
		$("#circulationDiv").modal('show');
	});
	//针对此文拟草新文按钮事件
	$('#btn_draft').click(function() {
		var options = {
			"text" : "另拟新文",
			"id" : "draft"+"${bizId}",
			"href" : 'bpmRunController/doDraftNewTextForThisArticle?bizId='+ "${bizId}",
			"pid" : window,
			"isDelete" : true,
			"isReturn" : true,
			"isRefresh" : false 
		};
		window.parent.createTab(options);
	});
	/*收文转发文*/
	$("#btn_swTurnToFw").click(function(){
		changeIndex();
		$("#swTurnToFw_iframe").attr("src", "bpmRunController/toSwTurnToFw?bizId=" + "${bizId}");
		$("#swTurnToFwDiv").modal('show');
	});

	//返回按钮事件
	$("#btn_close").click(function() {
		closeWindow(true);
	});
});
	//收文转发文确定按钮
function turn(){
	var data = document.getElementById("swTurnToFw_iframe").contentWindow.selectFwType();
	if(data != null){
	var operateUrl = "${ctx}/bizRunController/getBizOperate?status=1&solId="+data.solId+"&bizId=" + data.bizId;
	if(operateUrl!=null) {
		var btnName = "发文拟稿";
		date = new Date().getTime();
		var options = {
			"text" : btnName,
			"id" : date,
			"href" : operateUrl,
			"pid" : window,
			"isDelete":true,
			"isReturn":true,
			"isRefresh": true
		};
		window.parent.createTab(options);
	}}
/* 	
	
	
	
	
	
	
	
	
	
	
	
	
	
	if(data != null){
		$('#swTurnToFwDiv').modal('hide');
		var options = {
			"text" : "发文拟稿",
			"id" : "${bizId}",
			"href" : "bpmRunController/draft?bizId=" + data.bizId +"&solId=" + data.solId,
			"pid" : window.parent
		};
		window.parent.parent.createTab(options);
	}else{
		layerAlert("请选择发文类别！")
	} */
}
/*页面初始化事件*/
function init() {
	var fdStart = bizCode.indexOf("10011002");
	if (fdStart == 0&&operateState == 'deal') {
		$("#btn_swTurnToFw").show();
	}
}
</script>