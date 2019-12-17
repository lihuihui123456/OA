/** 手写签批对象 */
var signatureMap = {};
//默认图片宽度
var imgWidth = 300;
var projectRootPath = "";
function getRootPath() {
	if (projectRootPath == null || projectRootPath == "") {
		// 获取当前网址
		var curWwwPath = window.document.location.href;
		// 获取主机地址之后的目录
		var pathName = window.document.location.pathname;
		var pos = curWwwPath.indexOf(pathName);
		// 获取主机地址
		var localhostPaht = curWwwPath.substring(0, pos);
		// 获取带"/"的项目名，如：/uimcardprj
		var projectName = pathName.substring(0,
				pathName.substr(1).indexOf('/') + 1);
		projectRootPath = localhostPaht + projectName;
	}
	return projectRootPath;
}  

/* 打开手写签批窗口 */
function openWindow(filedName) { 
	if(filedName != null && filedName != undefined && filedName != "") {
		$("#" + filedName).removeAttr("disabled");
		var bizId = getFormParamByKey("key");
		var taskId = getFormParamByKey("taskId");
		var path = getRootPath();
		var width = $("#"+filedName+"signature").width();
		var height = getImgHeight(filedName);
		if(width != imgWidth) {
			height = (imgWidth/width) * height;
			width = imgWidth;
		}
		var url = path + "/signatureController/openSignature?" + "bizId="
				+ bizId + "&filedName=" + filedName + "&taskId=" + taskId +"&height=" +height+ "&width=" + width;//转向网页的地址; 
		var name="手写签批窗口"; //网页名称，可为空; 
		var iWidth = width + 5; //弹出窗口的宽度; 
		var iHeight = height + 50;//弹出窗口的高度; 
		//获得窗口的垂直位置 
		var iTop = (window.screen.availHeight - 30 - iHeight) / 2; 
		//获得窗口的水平位置 
		var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; 
		window.open(
			url,
			name,
			"height=" + iHeight+ "px," +
			"width=" + iWidth + "px," +
			"top=" + iTop + "," +
			"left=" + iLeft + "," +
			"status=no," +
			"toolbar=no," +
			"menubar=no," +
			"location=no," +
			"resizable=no," +
			"scrollbars=0," +
			"titlebar=no"
		); 
	} 
}

/**为表单手写签批插入签批生成的图片*/
function setParentWindowPic(filedName, datapair){
	if(datapair == null) {
		return;
	}
	var $signature = $("#"+filedName+"signature");
	if($signature){
		if(datapair[1] != "") {
			var data = "data:" + datapair.toString();
			signatureMap[filedName] = data;
			var width = $("#"+filedName+"signature").width();
			if(width > imgWidth) {
				width = imgWidth;
			}
			var i = new Image();
			i.onload = function(){
			  this.style.width= width; 
			}
			i.src = data;
			
			$signature.empty();
			$signature[0].appendChild(i); 
		}else {
			signatureMap[filedName] = "";
			$signature.empty();
		}
	}
}


/**加载意见输入输入域手写签批*/
function initSignatureComment(){
	var commentColumn = getFormParamByKey("commentColumn");
	if(commentColumn == undefined) {
		return;
	}
	loadSignature(commentColumn);
	$('#'+commentColumn+'editDiv').show();
	//$('#'+commentColumn).focus();
}


/**加载手写签批内容*/
function loadSignature(fieldName) {
	var taskId = getFormParamByKey("taskId");
	if(taskId == undefined || taskId == null || taskId == "") {
		return;
	}
	$.ajax({
		url : 'signatureController/loadSignatureByTask',
		type : 'post',
		data : {
			taskId : taskId,
			fieldName : fieldName
		},
		dataType : 'json',
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
	if(filedHeader != "" && filedValue != ""){
		signatureMap[filedName] = "data:" + filedHeader + "," + filedValue;
		var width = $("#"+filedName+"signature").width();
		if(width > imgWidth) {
			width = imgWidth;
		}
		var i = new Image();
		i.onload=function(){
			  this.style.width=width; 
		}
		i.src = "data:" + filedHeader + "," + filedValue;
		$("#"+filedName+"signature").empty();
		$("#"+filedName+"signature")[0].appendChild(i);
	}
}

//计算图片高度
function getImgHeight(filedName) {
	if(filedName == undefined) {
		return "100%";
	}
	var parentDivHeight = $("#"+filedName+"signature").parent().height();
	var prevDivHeight = $("#"+filedName+"signature").prev().height();
	var height = parentDivHeight - prevDivHeight;
	return height;
}

/**保存手写签批意见到意见表*/
function doSaveSignature() {
	if(commentColumn != null && commentColumn != "") {
		var signature = signatureMap[commentColumn];
		if(signature != null && signature !="") {
			$.ajax({
				url : "bpm/doSaveSignature",
				type : "post",
				dataType : "text",
				data : {
					fieldName : commentColumn,
					fileValue : signature,
					procInstId : procInstId,
					taskId : taskId
				},
				success : function(data) {
				}
			})
		}
	}
}

/**
 * 加载历史环节意见
 */
function initComment() {
	var bizId = getFormParamByKey("key");
	if(bizId == null || bizId == undefined) {
		return;
	}
	$.ajax({
		url : "bpmRuFormInfoController/showProcessComment",
		type : "post",
		dataType :"json",
		data:{
			bizId : bizId
		},
		success:function(datas) {
			if(datas != null) {
				$(datas).each(function(index) {
					var str = "";
					if(this.message_ != null && this.message_ != "") {
						str = str + "<label style='color: #2a2a2a; margin-top: 8px; padding-left: 13px;'>"+this.message_.replace(new RegExp("\n", 'g'),"<br>")+"</label><br>";
					}
					if(this.signature != null && this.signature != "") {
						var width = $("#"+this.fieldName_+"showDiv").width();
						if(width > imgWidth) {
							width = imgWidth;
						}
						str = str + "<img style='width:"+width+";' src='"+this.signature+"'><br>";
					}
					if(str != "") {
						str = str + "<label style='color: #888; padding-left: 13px; margin-top: 5px; margin-bottom: 5px;'>"
							//+ "&nbsp;&nbsp;"+this.userName_+"&nbsp;&nbsp;"+this.dtime+"</label><br><hr>";
							+ this.userName_+"&nbsp;&nbsp;"+this.dtime+"</label><br>";
						$("#"+this.fieldName_+"showDiv").append(str);
					}
				})
			}
		}
	});
}
//获取手写前签批内容
function getSignature() {
	var signatureImg = "";
	if(signatureMap != undefined && signatureMap[commentColumn] != undefined) {
		signatureImg = signatureMap[commentColumn];
	}
	return signatureImg;
}

$(function(){
	//加载意见输入输入域手写签批
	initSignatureComment();
	
	//加载意见展示域审批意见
	initComment();
})
