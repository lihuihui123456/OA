var divId="bizform";



/*页面初始化事件*/
function init(){
	/*var fdStart = sfwType.indexOf("sfw_sw");
	if(fdStart == 0){
		$("#btn_swTurnToFw").show();
	}*/
}

//收文转发文确定按钮
function turn(){
	var data = document.getElementById("swTurnToFw_iframe").contentWindow.selectFwType();
	if(data != null){
		$('#swTurnToFwDiv').modal('hide');
		var options = {
			"text" : "发文拟稿",
			"id" : bizId,
			"href" : "bpmRunController/draft?bizId=" + data.bizId +"&solId=" + data.solId,
			"pid" : window.parent
		};
		window.parent.parent.createTab(options);
	}else{
		layerAlert("请选择发文类别！")
	}
}

//页签时切换加载对应的iframe
function showPage(tabId, url){
	if ($('#' + tabId + '_iframe').attr("src") == "") {
		if (tabId != "mainBody") {
			$('#' + tabId + '_iframe').attr('src', url);
		}else {
			if( !$("#word").hasClass("open-page") && !$("#pdf").hasClass("open-page")){
				$("#word").addClass("close-page").addClass("open-page");
				$("#pdf").addClass("close-page");
				$("#scan").show();
				$("#mainBody_iframe").addClass("iframe_show").attr('src', url);
			}
		}
	}
}



function openImgDiv() {
	$('#viewFlowPicture').modal('show');
}

//业务数据暂存
function btnSave(action) {
	var flag = "0";
	var data;
	if(action == "send"){
		data = document.getElementById('form_iframe').contentWindow.doDealForm(bizId);//保存业务表单
	}else {
		data = document.getElementById('form_iframe').contentWindow.doUpdateForm(bizId);//保存业务表单
	}
	if(data == "Y"){
		saveMainBody(isMainBody);
		if(action == "save"){
			window.parent.parent.closePage(window,true,true,true);
		}
	}else{
		flag = "1";
	}
	return flag;
}

//送交提交方法
function btnSubmit() {
	//验证表单必填项
	if(document.getElementById("send_iframe").contentWindow.validateForm()){
		//启动流程
		var flag = document.getElementById('send_iframe').contentWindow.startProcess();
		if(flag == "1"){
			window.parent.parent.closePage(window,true,true,true);	
			/*if(window.parent.parent.$('#framehome')[0]){
				var todoFrame=window.parent.parent.$('#framehome')[0].contentWindow.$('#todo_iframe');
				if(todoFrame!=null){
					todoFrame[0].contentWindow.init();
				}
			}*/
					
		}else{
			layerAlert("送交失败！");
		}
	}
}

//传阅确定按钮
function circulation() {
	var users = document.getElementById("circulation_iframe").contentWindow.doSaveSelectUser();
	var viewUserIds = users[0];
	$.ajax({
		type: 'post',  
        url: 'bpmRuBizInfoController/doSaveBizGwCircularsEntitys',
        dataType: 'json',
        data: {
        	'bizId' : bizId,
        	'viewUserIds' : viewUserIds
        },
        success: function(data) {
        	if(data){
	        	layerAlert("传阅成功！");
	        	$('#circulationDiv').modal('hide');
        	}else {
	        	layerAlert("传阅失败！");
        	}
        }
	});
}

//给送交页面赋值
function setValue() {
	var title = $("#form_iframe")[0].contentWindow.getTitle();
	$("#send_iframe")[0].contentWindow.setTitle(title);
	if(commentColumn != null && commentColumn != ""){
		var comment = $("#form_iframe")[0].contentWindow.getComment(commentColumn);
		//var comment = $("#form_iframe")[0].contents().find('#'+commentColumn).val();
		$("#send_iframe")[0].contentWindow.setComment(comment);
		var signature = $("#form_iframe")[0].contentWindow.getSignature();
		$("#send_iframe")[0].contentWindow.setSignature(signature);
	}
}

//通过判断是否存在在DB中存在bizId,没有插入并更新标记dbbizId
function changeIseb() {
	return;
}

$(function() {
	/*页面初始化*/
	init();
	
	/*送交按钮事件*/
	$('#btn_send').click(function() {
		changeIndex();
		 var flag = btnSave("send");
		if(flag == "0") {//暂存成功
			var src = "bpmRunController/runProcessSendPage?bizId="+bizId
					+"&isFreeSelect="+isFreeSelect+"&taskId="+taskId+"&fieldName="+commentColumn;
			$('#send_iframe').attr('src', src);
			$("#sendDivLabel").html("送交选项");
			$('#sendDiv').modal('show');
		}else if(flag == "1") {
			layerAlert("表单信息保存出错！");
		}
	});
	
	//退回按钮事件
	$("#btn_back").click(function() {
		changeIndex();
        var flag = btnSave("send");
		if(flag == "0") {//暂存成功
			var src = "bpmRunController/runProcessBackPage?bizId="+bizId+"&taskId="+taskId+"&fieldName="+commentColumn;
			$('#send_iframe').attr('src', src);
			$("#sendDivLabel").html("退回选项");
			$('#sendDiv').modal('show');
		}else if(flag == "1") {
			layerAlert("表单信息保存出错！");
		}
	});
	
	/*收文转发文*/
	$("#btn_swTurnToFw").click(function(){
		changeIndex();
		var src = "bizController/toSwTurnToFw?bizId=" + bizId;
		$('#swTurnToFw_iframe').attr('src', src);
		$('#swTurnToFwDiv').modal('show');
	});
	
	/*暂存按钮事件*/
	$('#btn_save').click(function() {
		changeIndex();
		var flag = btnSave("save");
		if(flag == "0") {
			layerAlert("暂存成功！");
		}else if(flag == "1") {
			layerAlert("表单信息保存出错，暂存失败！");
		}
	});
	
	//传阅按钮事件
	$('#btn_circulation').click(function() {
		changeIndex();
		$("#circulation_iframe").attr("src",'treeController/zMultiPurposeContacts?state=1');
		$("#circulationDiv").modal('show');
	});
	
	//针对此文拟草新文按钮事件
	$('#btn_draft').click(function() {
		var options = {
			"text" : "拟稿-起草新文",
			"id" : "draft"+bizId,
			"href" : 'bpmRunController/doDraftNewTextForThisArticle?bizId='+ bizId,
			"pid" : window,
			"isDelete" : true,
			"isReturn" : true,
			"isRefresh" : false
		};
		window.parent.createTab(options);
	});
	
	/*退回功能*/
	$("#btn_rollback").click(function(){
		layer.confirm('确定退回吗？', {
			btn : [ '确定', '取消' ]
			// 按钮
			}, function(index) {
				var comment = $('#form_iframe').contents().find('#'+commentColumn).val();
				$.ajax({
				    url:"bpm/doRollBackTask",
					type:"post",
					data:{
						"action" : "draftTaskNode",
						"taskId" : taskId,
						"message": comment,
						"fieldName" : commentColumn
					},
					dataType:"json",
					success:function(data) {
						if(data.resultType == "success"){
							//alert(data.resultMsg);
							window.parent.parent.closePage(window,true,true,true);
						}else{
							layerAlert(data.resultMsg);
						}
					}
				});
				layer.close(index);
			}, function() {
				return;
		});
		
	});
	
	//返回按钮事件
	$('#btn_close').click(function() {
		window.parent.parent.closePage(window,true,true,true);
	});
	
	$('#myTabs a').click(function (e) {
		e.preventDefault();
		divId = $(this).attr('href').replace("#","");
		if(divId != "mainBody") {
			$("#scan").hide();
		}else {
			if($("#mainBody_iframe").hasClass("iframe_show")){
				$("#scan").show();
			}
		}
	});

});