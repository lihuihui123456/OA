
$(function(){
	//initStyle();
	//LoadSignature();
	initCommentScopeStyle();
})


/**加载表单手写签批和文字签批的意见域显示以及审批权限*/
function initCommentScopeStyle(){
	/*
	 * style表示当前表单以什么方式打开  deal:办理  view：查看  draft:拟稿  update:修改
	 * 通过自定义的class属性来控制表单读写权限
	 * input 表示输入控件  
	 * comment 表示意见框  
	 * select表示通过选择方式来实现录入的控件
	 */
	var fieldName;
	if(style == "deal" || style == "view") {
		//审批或者查看的时候 输入框和下拉选框禁止编辑
		$('.input').attr("readonly","readonly");
		$('.select').attr("disabled","disabled");
		var $tableObjs = $(".commentTable")
		if($tableObjs != null) {
			//var $tableObj, id, fieldName;
			$tableObjs.each(function(index) {
				var $tableObj = $(this);
				var id = $tableObj.attr("id");
				fieldName = id.substring(0, id.indexOf("table")); 
				loadSignature(fieldName);
				if(fieldName == commentColumn) {
					style1($tableObj, fieldName, true);
				}else {
					style1($tableObj, fieldName, false);
				}
			})
			
		}
	}else if(style == "draft" || style == "update") {
		if(commentColumn != null && commentColumn != ""){
			loadSignature(fieldName);
			//显示当前有权限编辑的意见框并聚焦 
			var tableId = commentColumn+"table";
			var $tableObj = $("#"+tableId);
			style1($tableObj, fieldName, true)
			/*$tableObj.find('tr.commentEditBtnGroup').show();
			$tableObj.find('tr.wz').show();
			$('#'+commentColumn).css({"display" : "block"}).focus();*/
		}
	}
	
}

function style1($tableObj, fieldName, isEdit) {
	var $commmentDiv, $picDiv, $btnTr;
	$commmentDiv = $("#"+fieldName+"comment");
	$picDiv = $("#"+fieldName+"signature");
	if(isEdit == true) {
		//当前为有编辑权限的意见域
		var $commentInput = $("#"+fieldName);
		$commentInput.css({"display" :"block"});
		$btnTr = $tableObj.find('tr.commentEditBtnGroup');
		$btnTr.css({'display' : "table-row"});
		if(!$.trim($commmentDiv.html()) && $commentInput.val() == "" && $.trim($picDiv.html())) {
			//只有手写签批有内容
			$tableObj.find('tr.sx').css({'display' : "table-row"});
			//TODO a sx高亮
			$btnTr.find('td a:last').addClass("open-page");
		}else {
			$tableObj.find('tr.wz').css({'display' : "table-row"});
			//TODO a wz高亮
			$btnTr.find('td a:first').addClass("open-page");
			
			$commentInput.focus();
		}
		
	}else{
		//没有编辑权限的意见域
		$btnTr = $tableObj.find('tr.commentViewBtnGroup');
		if($.trim($commmentDiv.html()) && $.trim($picDiv.html())){//文字签批和手写签批都有内容
			$btnTr.css({'display' : "table-row"});
			$tableObj.find('tr.wz').css({'display' : "table-row"});
			//TODO a wz高亮
			$btnTr.find('td a:first').addClass("open-page");
			
		}else if($.trim($commmentDiv.html()) && !$.trim($picDiv.html())){
			//只有文字签批有内容
			$tableObj.find('tr.wz').css({'display' : "table-row"});
		}else if(!$.trim($commmentDiv.html()) && $.trim($picDiv.html())){
			//只有手写签批有内容
			$tableObj.find('tr.sx').css({'display' : "table-row"});
			//TODO a sx高亮
			$btnTr.find('td a:last').addClass("open-page");
		}
	}
}

/**加载各个意见域的手写签批内容*/
function loadSignature(fieldName) {
	$.ajax({
		url : 'signatureController/loadSignature',
		type : 'post',
		data : {
			bizId : bizId,
			fieldName : fieldName
			
		},
		dataType : 'json',
		async : false,
		success : function(datas){
			if(datas!=null){
				var filedName;
				var filedHeader;
				var filedValue;
				$(datas).each(function(index){
					setCommentPic(datas[index]);
				})
			}
		}
	});
}

/** 为表单意见域填充手写签批*/
function setCommentPic(data) {
	var filedName, filedHeader, filedValue, userName, dateTime;
	filedName= data.fieldName_;
	filedHeader = data.fieldHeader_;
	filedValue = data.fieldValue;
	userName = data.userName_;
	dateTime = data.dateTime_;
	if(filedHeader != "" && filedValue != ""){
		var i = new Image();
		i.onload=function(){
			  this.style.height="100%";
			  this.style.width="100%"; 
		}
		i.src = "data:" + filedHeader + "," + filedValue;
		$("#"+filedName+"signature").empty();
		$("#"+filedName+"signature")[0].appendChild(i);
		if(userName != "" && dateTime !="") {
			$("#"+filedName+"signature_msg")
				.append("&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #888\">"
						+userName+"</span>&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #888\">"
						+dateTime+"</span>");
		}
	}
	
	
}

/**切换审批类型*/
function changeEditType(action, aObj, filedName) {
	$(aObj).addClass("open-page").siblings().removeClass("open-page");
	var $tableObj = $(aObj).parent().parent().parent();
	var sx = $tableObj.find('tr.sx');
	var wz = $tableObj.find('tr.wz');
	if (action == 'wz') {
		sx.css({'display' : "none"});
		wz.css({'display' : "table-row"});
	}
	if (action == 'sx') {
		sx.css({'display' : "table-row"});
		wz.css({'display' : "none"});
		openWindow(filedName);
	}
}

/**切换查看批示类型*/
function changeViewType(action, aObj, filedName) {
	$(aObj).addClass("open-page").siblings().removeClass("open-page");
	var $tableObj = $(aObj).parent().parent().parent();
	var sx = $tableObj.find('tr.sx');
	var wz = $tableObj.find('tr.wz');
	if (action == 'wz') {
		sx.css({'display' : "none"});
		wz.css({'display' : "table-row"});
	}
	if (action == 'sx') {
		sx.css({'display' : "table-row"});
		wz.css({'display' : "none"});
	}
}







/************原来的手写签批方法*****************/


function initStyle(){
	/*
	 * style表示当前表单以什么方式打开  deal:办理  view：查看  draft:拟稿  update:修改
	 * 通过自定义的class属性来控制表单读写权限
	 * input 表示输入控件  comment 表示意见框  select表示通过选择方式来实现录入的控件
	 */
	var tableId = commentColumn+"table";
	$('.commentButton').hide();
	if(style == "deal" || style == "view") {
		$('.commentTable').show();
	}else{
		$('.commentTable').hide();
		$("#"+tableId).show();
	}
	$("#"+tableId).find('a.commentButton').show();
}

function LoadSignature() {
	$.ajax({
		url : 'signatureController/loadSignature',
		type : 'post',
		data : {
			bizId : bizId,
		},
		dataType : 'json',
		async : false,
		success : function(datas){
			var filedName;
			var filedHeader;
			var filedValue;
			if(datas!=null){
				$.each(datas,function(index,data) {
					filedName = data.fieldName_;
					filedHeader = data.fieldHeader_;
					filedValue = data.fieldValue;
					if(filedName != "" && filedHeader != "" && filedValue != ""){
						setPic(filedName, filedHeader, filedValue,data.userName_,data.dateTime_);
						var html = $("#"+filedName+"0").html();
						if(html=="" || html == undefined){
							change2('sx', filedName);
						}
					}
				});
			};
		}
	});
}

function setPic(filedName, filedHeader, filedValue,userName,dateTime){
	var i = new Image();
	i.onload=function(){
		  this.style.height="100%";
		  this.style.width="100%"; 
	}
	i.src = "data:" + filedHeader + "," + filedValue;
	$("#"+filedName+"signature").empty();
	$("#"+filedName+"signature")[0].appendChild(i);
	$("#"+filedName+"signature_msg").append("&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #888\">"+userName+"</span>&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #888\">"+dateTime+"</span>");
}

//切换审批方式
function change(action, aObj, filedName) {
	var tableObj = $(aObj).parent().parent().parent();
	var sx = tableObj.find('tr.sx');
	var wz = tableObj.find('tr.wz');
	if (action == 'wz') {
		sx.css({
			'display' : "none"
		});
		wz.css({
			'display' : "table-row"
		});
	}
	if (action == 'sx') {
		sx.css({
			'display' : "table-row"
		});
		wz.css({
			'display' : "none"
		});
		openWindow(filedName);
	}
}

//切换审批方式
function change2(action, filedName) {
	var tableObj = $("#"+filedName+"table");
	var sx = tableObj.find('tr.sx');
	var wz = tableObj.find('tr.wz');
	if (action == 'wz') {
		sx.css({
			'display' : "none"
		});
		wz.css({
			'display' : "table-row"
		});
	}
	if (action == 'sx') {
		sx.css({
			'display' : "table-row"
		});
		wz.css({
			'display' : "none"
		});
	}
}