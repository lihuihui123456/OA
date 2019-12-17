var iseb = "N";  //N:数据库中没有bizId Y：数据库存在bizId
var divId="bizform";
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
//暂存业务数据
/*function btnSave(action) {
	var data = "N";
	var flag = "0";
	//是否生成业务数据处理
	if(iseb == "N"){
		data = doSaveBpmRuBizInfo();
	}else {
		data = doUpdateBpmRuBizInfo();
	}
	if(data == "Y") {
		data = $("#form_iframe")[0].contentWindow.doSaveForm(bizId);//保存业务表单
		if(data == "Y"){
			saveMainBody(isMainBody);
		}else{
			flag = "1";
		}
	}else {
		flag = "2";
	}
	return flag;
}*/
//提交方法
function btnSubmit() {
	if($("#send_iframe")[0].contentWindow.validateForm()){
		var flag = $("#send_iframe")[0].contentWindow.startProcess();
		if(flag == "1") {
			window.parent.parent.closePage(window,true,true,true);
		}else{
			layerAlert("送交失败！");
		}
	}
}

//新增业务信息
function doSaveBpmRuBizInfo() {
	var flag;
	var title = $("#form_iframe")[0].contentWindow.getTitle();
	var urgency = $("#form_iframe")[0].contentWindow.getUrgencyLevel();//选中的文本
	$.ajax({
		url : 'bpmRuBizInfoController/doSaveBpmRuBizInfoEntity',
		type : 'post',
		dataType : 'text',
		async : false,
		data : {
			'bizId' : bizId,
			'solId' : solId,
			'tableName' : tableName,
			'procdefId' : procdefId,
			'title' : title,
			'urgency' : urgency,
			'sfwType' : sfwType
		},
		success : function(data) {
			iseb = data;
			flag = data;
		}
	});
	return flag;
}

//修改业务信息
function doUpdateBpmRuBizInfo() {
	var flag;
	var title = $("#form_iframe")[0].contentWindow.getTitle();
	var urgency = $("#form_iframe")[0].contentWindow.getUrgencyLevel();//选中的文本
	$.ajax({
		url : 'bpmRuBizInfoController/doUpdateBpmRuBizInfoEntity',
		type : 'post',
		dataType : 'text',
		async : false,
		data : {
			'bizId' : bizId,
			'title' : title,
			'urgency' :urgency
		},
		success : function(data) {
			flag = data;
		}
	});
	return flag;
}

//给送交页面赋值
function setValue() {
	var title = $("#form_iframe")[0].contentWindow.getTitle();
	$("#send_iframe")[0].contentWindow.setTitle(title);
	if(commentColumn != null && commentColumn != ""){
		var comment = $("#form_iframe")[0].contentWindow.getComment(commentColumn);
		$("#send_iframe")[0].contentWindow.setComment(comment);
		var signature = $("#form_iframe")[0].contentWindow.getSignature();
		$("#send_iframe")[0].contentWindow.setSignature(signature);
	}
}

// 通过判断是否存在在DB中存在bizId,没有插入并更新标记dbbizId(未保存表单的时候操作正文或者附件时被调用)
function changeIseb() {
	// 是否生成业务数据处理
	if(iseb == "N"){
		doSaveBpmRuBizInfo();
	}
}

$(function() {
	//送交按钮事件
	$("#btn_send").click(function() {
		changeIndex();
		if($("#form_iframe")[0].contentWindow.validateForm()){
			var flag = btnSave("send");
			if(flag == "0") {//暂存成功
				var src = "bpmRunController/startProcessSendPage?solId="+solId +"&bizId="+bizId+"&procdefId="+procdefId+"&fieldName="+commentColumn;
				$('#send_iframe').attr('src', src);
				$('#sendDiv').modal('show');
			}else if(flag == "1") {
				layerAlert("表单信息保存出错！");
			}else if (flag == "2") {
				layerAlert("业务信息保存出错！");
			}
		}
	});
	
	//暂存按钮事件
	/*$("#btn_save").click(function() {
		changeIndex();
		var flag = btnSave("save");
		if(flag == "0") {
			window.parent.parent.closePage(window,true,true,true);
		}else if(flag == "1") {
			layerAlert("表单信息保存出错，暂存失败！");
		}else if (flag == "2") {
			layerAlert("业务信息保存出错，暂存失败！");
		}
	});*/
	
	//返回按钮事件
	$("#btn_close").click(function() {
		window.parent.parent.closePage(window,true,true,false);
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