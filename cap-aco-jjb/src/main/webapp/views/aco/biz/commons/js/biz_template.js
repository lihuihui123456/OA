/**
 * 计算页面高度
 */
function winH(){
	var bodyHeight = $("#conBody").height();
	var tabsH = bodyHeight-$(".btn-group").height();
	$("#tabsH").height(tabsH);
	var iframeH = bodyHeight -$(".btn-group").height()-$("#myTabs").height()-10;
	
	$("#form_iframe").height(iframeH);
	$("#attachment_iframe").height(iframeH);
	$("#mainBody_iframe").height(iframeH);
	$("#mainBody_pdf_iframe").height(iframeH);
	$("#earc_iframe").height(iframeH);
}

//打印
/*function printForm(bizId) {
	var url = "wordController/printWord";
	var params = {"bizId" : bizId};
	$.post(url, params, function(data) {
		var mFileName;
		if(data && data.filename !=null){
			mFileName = data.filename;
		}else {
			mFileName = new Date();
		}
		print(bizId, mFileName);
	}, "json");
}*/
//打印
function printForm(bizId,formType,solId) {
	var url = "wordController/printWord";
	var params = {"bizId" : bizId,"formType" : formType,"solId":solId};
	$.post(url, params, function(data) {
		var mFileName;
		if(data && data.filename !=null){
			mFileName = data.filename;
		}else {
			mFileName = new Date();
		}
		print(bizId, mFileName);
	}, "json");
}
//打印表单
function print(bizId, fileName) {
	var url = "wordController/openWord?encryption=0&fileType=.doc&&mFileName="+fileName;
	var options = {
		"text" : "打印",
		"id" : "printWord"+bizId,
		"href" :url,
		"pid" : window,
		"isDelete" : true,
		"isReturn" : true,
		"isRefresh" : false
	};
	window.parent.createTab(options);
}

// 切换到表单所在的页签
function changeIndex() {
	$("#scan").hide();
	$('#myTabs li:eq(0)').addClass("in active");
	$('#myTabs li:eq(1)').removeClass("in active");
	$('#myTabs li:eq(2)').removeClass("in active");
	if(divId == "mainBody") {
		$('#mainBody').removeClass("in active");
		$('#bizform').addClass("in active");
	}else if(divId == "attachment") {
		$('#attachment').removeClass("in active");
		$('#bizform').addClass("in active");
	}
	divId = "";
}

/**
 * 保存word和pdf
 * state 1: 有正文  0：无正文
 */
function saveMainBody(state) {
	if(state == "1") {
		if($('#mainBody_iframe').attr("src") != "") {
			document.getElementById('mainBody_iframe').contentWindow.SaveDocument();//保存正文
		}
		if($('#mainBody_pdf_iframe').attr("src") != "") {
			document.getElementById('mainBody_pdf_iframe').contentWindow.SaveDocument();//保存正文
		}
	}
}

//弹出选择办理人窗口
function choseUser(chooseUserUrl) {
	$("#chooseUser_iframe").attr("src", chooseUserUrl);
	$('#chooseUserDiv').modal('show');
}

//选人确定按钮
function makesure() {
	var arr = $("#chooseUser_iframe")[0].contentWindow.doSaveSelectUser();
	var userName = arr[1];
	var userId = arr[0];
	document.getElementById("send_iframe").contentWindow.document
			.getElementById("userName").value = userName;
	document.getElementById("send_iframe").contentWindow.document
			.getElementById("userId").value = userId;
	document.getElementById("send_iframe").contentWindow.validateForm();
	$('#chooseUserDiv').modal('hide');
}

/*
//保存业务操作信息
function doSaveBizRuAction() {
	$.ajax({
		url : "bizController/doUpdateBizRuAction",
		type : 'post',
		dataType : 'text',
		data : {
			"bizId" : bizId,
			"bodyType" : bodyType
		},
		success : function(data) {
		}
	});
}

//获取业务最后一次操作信息
function dofindBizRuAction() {
	var temp = "0";
	$.ajax({
		url : "bizController/findBizRuActionByBizId",
		type : 'post',
		dataType : 'json',
		async : false,
		data : {
			"bizId" : bizId
		},
		success : function(data) {
			if(data){
				temp = data.bodyType_;
			}
		}
	});
	return temp;
}
*/

/*********** 图片识别功能js函数 start**************************/
//弹出识别图片模态框
function scan(bizId){
	$("#scanFrame").attr("src",'bpmRuBizInfoController/ocrIndex?bizId='+bizId);
	if(changeToZw()){
		$('#mainBody_iframe').hide();
		$('#scanFrameDiv').modal('show');
	}
}

//跳转到正文
function changeToZw(){
	if(divId == "bizform"||divId == "attachment") {
		layerAlert("请切换到正文使用！");
		return false;
	}else{
		return true;
	}
}

//将识别出的字保存到正文
function writeToZw(){
	var value = document.getElementById("scanFrame").contentWindow.getValue();
	$('#scanFrameDiv').modal('hide');
	$('#mainBody_iframe').show();
	document.getElementById("mainBody_iframe").contentWindow.WebSetWordContent(value);
}

//扫描图片关闭
function cancelScan(){
	$('#scanFrameDiv').modal('hide');
}

$(function(){
	$('#scanFrameDiv').on('hidden.bs.modal', function (e) {
		$('#mainBody_iframe').show();
	})
})
/*********** 图片识别功能js函数 end**************************/

/**
 * 查询关联文档文件数目
 */
function findattachFile(bizId){
	$.ajax({
		type: "post",  
        url: "media/findattachFile",
        dataType: 'json',
        data: {
        	"bizid": bizId
        },
        success: function(data) {
            if(data!=null){
            	var title = "关联文档("+data.length+")";
            	changeAttachmentTitle(title);
            }
        }
	});
}

/**
 * 修改关联文档页签名称
 * @param title
 */
function changeAttachmentTitle(title){
	$("#glwd").text(title)
}

/**
 * 关闭当前页面
 * @Param (boolean)isReflush 是否刷新父窗口
 */
function closeWindow(isReflush) {
	//window.parent.parent.closePage(window,true,true,isReflush);
	if(typeof window.parent.parent.closePage== 'function'){
		window.parent.parent.closePage(window,true,true,isReflush);
	}else{
        //领导桌面使用
		window.parent.closePage(window,true,true,isReflush);
	}
}

//获取业务标题
function getBizTitle() {
	return $("#form_iframe")[0].contentWindow.getTitle();
	
}

//获取业务紧急程度
function getUrgencyLevel() {
	return $("#form_iframe")[0].contentWindow.getUrgencyLevel()
}

//给送交页面赋值
function setValue() {
	var title = getBizTitle();
	$("#send_iframe")[0].contentWindow.setTitle(title);
	if(commentColumn != null && commentColumn != ""){
		var comment = $("#form_iframe")[0].contentWindow.getComment(commentColumn);
		$("#send_iframe")[0].contentWindow.setComment(comment);
		var signature = $("#form_iframe")[0].contentWindow.getSignature();
		$("#send_iframe")[0].contentWindow.setSignature(signature);
	}
}

/**
 * 保存业务数据
 * @param (String) bizId 业务Id
 * @param (String) action 动作  save : 暂存; send : 送交
 * @param (String) operate 操作 draft : 拟稿; update : 编辑
 * @return (boolean) true : 成功 ; false : 失败
 */
function btnSave(bizId,action,operate) {
	//保存业务基本信息
	var data = doSaveBpmRuBizInfo(operate);
	if(data != "Y") {
		layerAlert("业务基本信息保存出错！");
		return false;
	}
	//保存业务表单信息
	var result = $("#form_iframe")[0].contentWindow.doSaveForm(bizId, action, operate);
	if(result != "Y"){
		layerAlert("业务信息保存出错！");
		return false;
	}
	return true;
}

/**
 * 送交选项窗口提交方法
 */
function btnSubmit() {
	if($("#send_iframe")[0].contentWindow.validateForm()){
		var flag = $("#send_iframe")[0].contentWindow.startProcess();
		if(flag == "1") {
			//送交过后取消特急提示
			window.parent.getTaskToDo();
			closeWindow(true);
		}else{
			layerAlert("送交失败！");
		}
	}
}

//收文转发文
function swTurnToFw(bizId){
	var data = document.getElementById("swTurnToFw_iframe").contentWindow.selectFwType();
	if(data != null){
		$("#swTurnToFwDiv").modal('hide');
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

//传阅确定按钮
function circulation(bizId) {
	var users = document.getElementById("circulation_iframe").contentWindow.doSaveSelectUser();
	var viewUserIds = users[0];
	var url = "bpmRuBizInfoController/doSaveBizGwCircularsEntitys";
	var params = {
		"bizId" : bizId,
        "viewUserIds" : viewUserIds
	};
	$.post(url, params, function(data) {
		if(data){
        	layerAlert("传阅成功！");
        	$('#circulationDiv').modal('hide');
    	}else {
        	layerAlert("传阅失败！");
    	}
	}, "json");
}

function openImgDiv() {
	$('#viewFlowPicture').modal('show');
}