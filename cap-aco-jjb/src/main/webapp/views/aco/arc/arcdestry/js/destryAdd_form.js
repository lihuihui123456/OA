$(function() {
	laydate.skin('dahong');	
	$("#expiryDate").attr("readonly",true);
});

//保存表单
function doSaveForm() {
	var flag = "N"
	if ($('#destryForm').validationEngine('validate')) {
		var expiryDate=$("#expiryDate").val();
		if(expiryDate=="永久有效"){
			expiryDate="0"
		}else if(expiryDate=="10年"){
			expiryDate="10"
		}else if(expiryDate=="30年"){
			expiryDate="30"
		}
		$("#expiryDate").val(expiryDate);
		$.ajax({
			type : "post",
			url : "arcDestry/add",
			dataType : 'text',
			data : $('#destryForm').serialize(),
			success : function(data) {
				if(data=='true'){
					layerAlert("保存成功");
				}
			},
			error : function(data) {
				layerAlert("error:" + data.responseText);
			}
		});
		return flag;
	}else{
		flag ="Y";
		return flag;
	}
}

//重置
function doReset() {
  document.getElementById("destryForm").reset();
  $("#arcExpiryDate").val(0);
  $("#remarks").text("");
  $("#arcId").val("");
}

//修改表单
function doUpdateForm(bizId) {
	$('#arcId').val(bizId);
	var flag = "N"
	$.ajax({
		url : 'bpmRuFormInfoController/doUpdateBpmDuForm/'+bizId+'/'+tableName,
		type : 'post',
		dataType : 'text',
		async : false,
		data : $('#destryForm').serialize(),
		success : function(data) {
			flag = data;
		}
	});
	return flag;
}

//验证表单必填项
function validateForm() {
	return $('#destryForm').validationEngine('validate');
}

//查看档案
function viewArc() {
	var arcName = $('#arcName').val();
	var arcId = $('#arcId').val();
	var arcType = $('#arcType').val();
	date = new Date().getTime();
	if (arcId==""||arcType=="") {
		layerAlert("请选择销毁档案！");
	}else {
		$.ajax({
			type : "POST",
			url : "arcPubInfo/getArcTypeUrl",
			async : false,
			dataType : 'text',
			data : {
				"id" : arcType
			},
			success : function(data) {	
				if (data != "") {
					var hrefPath=getRootPath()+data+"arcId="+arcId+"&type=selectView&fileStart=1";
					var options = {
							"text" : "档案管理-查看",
							"id" : date,
							"href" :hrefPath,
							"pid" : window.parent
					};
					window.parent.parent.createTab(options);
				}
			},
			error : function(data) {
			}
		});
	}
}


//文件选择
function attachFile() {
	$('#myModal').modal('show');
	$('#group').attr("src","arcDestry/selectArc");
}

//保存选择文档信息
function saveAttach() {
	document.getElementById("group").contentWindow.saveAttach();
	$('#myModal').modal('hide');
	
}
//设置选择文档
function setArcInfo(arcId,arcName,arcType,expiryDate) {
	$("#arcName").val(arcName);
	$("#arcId").val(arcId);
	$("#arcType").val(arcType);
	if(expiryDate=="0"){
		expiryDate="永久有效"
	}else if(expiryDate=="10"){
		expiryDate="10年"
	}else if(expiryDate=="30"){
		expiryDate="30年"
	}
	$("#expiryDate").val(expiryDate);
}

function getRootPath() {  
    //获取当前网址，如： http://localhost:8083/uimcardprj/share/meun.jsp  
    var curWwwPath=window.document.location.href;  
    //获取主机地址之后的目录，如： uimcardprj/share/meun.jsp  
    var pathName=window.document.location.pathname;  
    var pos=curWwwPath.indexOf(pathName);  
    //获取主机地址，如： http://localhost:8083  
    var localhostPaht=curWwwPath.substring(0,pos);  
    //获取带"/"的项目名，如：/uimcardprj  
    var projectName=pathName.substring(0,pathName.substr(1).indexOf('/')+1);  
    return(localhostPaht+projectName);  
} 
