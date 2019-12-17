var saveResult=null;
function doSaveForm(arcId){
	saveDocInforForm();
	return saveResult;
}

function doclearForm(){
	 document.getElementById("docInforForm").reset();
	  $("select.selectpicker").each(function(){ 
	      $(this).selectpicker('val',$(this).find('option').eq(1).val());    //重置bootstrap-select显示 
	      $(this).find("option").attr("selected", false);                    //重置原生select的值 
	      $(this).find("option").eq(1).attr("selected", true); 
	  });
		var date = new Date().format("yyyy-MM-dd hh:mm:ss");
		$('#regTime').val(date);
	//set the default user
	$('#checkUserIdName_').val(globalUserName);
	$('#checkUserId_').val(globalUserid);
	//clear form
	$('#docCo').val('');
	$('#docNBR').val('');
	$('#arcName').val('');
	$('#pageNum').val('');
	$('#dptTime').val('');
	$('#recTime').val('');
	$('#endTime').val('');
	$('#keyWord').val('');
	$('#depPos').val('');
	$('#remarks').val('');
	$('#expiryDate').selectpicker('val','0');
	
	$('#fileType').selectpicker('val',parent.globalfileType);
//	if(parent.globalAction=='read'){
//	}

}

$(function() {
	
	Date.prototype.format = function(format){
		var o = {
			"M+" : this.getMonth()+1, //month
			"d+" : this.getDate(), //day
			"h+" : this.getHours(), //hour
			"m+" : this.getMinutes(), //minute
			"s+" : this.getSeconds(), //second
			"q+" : Math.floor((this.getMonth()+3)/3), //quarter
			"S" : this.getMilliseconds() //millisecond
		}

		if(/(y+)/.test(format)) {
			format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
		}

		for(var k in o) {
			if(new RegExp("("+ k +")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
			}
		}
		return format;
	} 
	
	if(parent.globalAction=='add'){
		laydate.skin('dahong');
		var select = $('#docInforForm').find('#arcType');
//		$(select).find('option[selected="selected"]').removeAttr('selected');
//		var option = $(select).find('option[value="'+parent.golbalArcType+'"]');
//		if(option!=null&&option.length==1){
//			$(option[0]).attr('selected','selected');
//		}
		//$(select).attr('disabled','disabled');
		var select = $('#docInforForm').find('#fileType');
		$(select).find('option[selected="selected"]').removeAttr('selected');
		var option = $(select).find('option[value="'+parent.globalfileType+'"]');
		if(option!=null&&option.length==1){
			$(option[0]).attr('selected','selected');
		}
		
		//initial the reguser
		$('#checkUserIdName_').val(globalUserName);
		$('#checkUserId_').val(globalUserid);
		
		var date = new Date().format("yyyy-MM-dd hh:mm:ss");
		$('#regTime').val(date);
		
		//$('#docInforForm').find('#regTime').attr("readonly","readonly");
		//$('#docInforForm').find('#regDept').attr("readonly","readonly");
		//$('#docInforForm').find('#regDeptId').attr("readonly","readonly");
//		$('#docInforForm').find('#regUser').attr("readonly","readonly");
//		$('#docInforForm').find('#regUserId').attr("readonly","readonly");

	}else if(parent.globalAction=='modify'){
		laydate.skin('dahong');
		var selects = $('#docInforForm').find('select');
		for(var i=0;i<selects.length;i++){
			var selectValue = $(selects[i]).attr('myvalue');
			$(selects[i]).find('option[selected="selected"]').removeAttr('selected');
			var option = $(selects[i]).find('option[value="'+selectValue+'"]');
			if(option!=null&&option.length==1){
				$(option[0]).attr('selected','selected');
			}
		}
		//initial the reguser
		$('#checkUserIdName_').val(globalUserName);
		$('#checkUserId_').val(globalUserid);
		
		$('#docInforForm').find('#arcType').attr('disabled','disabled');
		//$('#docInforForm').find('#regTime').attr("readonly","readonly");
		//$('#docInforForm').find('#regDept').attr("readonly","readonly");
		//$('#docInforForm').find('#regDeptId').attr("readonly","readonly");
//		$('#docInforForm').find('#regUser').attr("readonly","readonly");
//		$('#docInforForm').find('#regUserId').attr("readonly","readonly");
		//fomatt the regtime
		var temp = $('#regTime').val().substring(0,19);
		$('#regTime').val(temp);
		temp = $('#fileTime').val().substring(0,19);
		$('#fileTime').val(temp);
	}else if(parent.globalAction=='read'||parent.globalAction=='zhuijiadangan'){
		var selects = $('#docInforForm').find('select');
		for(var i=0;i<selects.length;i++){
			var selectValue = $(selects[i]).attr('myvalue');
			$(selects[i]).find('option[selected="selected"]').removeAttr('selected');
			var option = $(selects[i]).find('option[value="'+selectValue+'"]');
			if(option!=null&&option.length==1){
				$(option[0]).attr('selected','selected');
			}
			$(selects[i]).attr("disabled",'disabled');
		}
		var inputs = $('#docInforForm').find('input');
		for(var i=0; i<inputs.length; i++){
			$(inputs[i]).attr("readonly","readonly");
			$(inputs[i]).removeAttr('onclick');
		}
		//initial the reguser
		$('#checkUserIdName_').val(globalUserName);
		$('#checkUserId_').val(globalUserid);
		
		//fomatt the regtime
		var temp = $('#regTime').val().substring(0,19);
		$('#regTime').val(temp);
		//fomatt the filetime
		temp = $('#fileTime').val().substring(0,19);
		$('#fileTime').val(temp);
		
	}else if(parent.globalAction=='selectView'){
		var selects = $('#docInforForm').find('select');
		for(var i=0;i<selects.length;i++){
			var selectValue = $(selects[i]).attr('myvalue');
			$(selects[i]).find('option[selected="selected"]').removeAttr('selected');
			var option = $(selects[i]).find('option[value="'+selectValue+'"]');
			if(option!=null&&option.length==1){
				$(option[0]).attr('selected','selected');
			}
			$(selects[i]).attr("disabled",'disabled');
		}
		var inputs = $('#docInforForm').find('input');
		for(var i=0; i<inputs.length; i++){
			$(inputs[i]).attr("readonly","readonly");
			$(inputs[i]).removeAttr('onclick');
		}
		//initial the reguser
		$('#checkUserIdName_').val(globalUserName);
		$('#checkUserId_').val(globalUserid);
		
		//hide the 'cansel' button
		$(window.parent.document).find("#btn_close").hide();
		$(window.parent.document).find("#btn_save").hide();
		//fomatt the regtime
		var temp = $('#regTime').val().substring(0,19);
		$('#regTime').val(temp);
		//fomatt the filetime
		temp = $('#fileTime').val().substring(0,19);
		$('#fileTime').val(temp);
	}
	$('#guidangDiv').find('input').attr('readonly',true);
	$('#guidangDiv').find('input').attr('disabled',true)

	//initial the regTime
//	if($('#regTime').val()==null||$('#regTime').val()==''){
//		var date = getNowFormatDate();
//		$('#regTime').val(date);
//	}
	var tempTime='';
	tempTime = $('#dptTime').val().substring(0,19);
	$('#dptTime').val(tempTime);
	tempTime = $('#recTime').val().substring(0,19);
	$('#recTime').val(tempTime);
	tempTime = $('#endTime').val().substring(0,19);
	$('#endTime').val(tempTime);
});

function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + date.getHours() + seperator2 + date.getMinutes()
            + seperator2 + date.getSeconds();
    return currentdate;
}
function saveDocInforForm(){
	var action = parent.globalAction;
	var url = "";
	if (action == undefined || action == '') {
		return;
	} else if(action=='zhuijiadangan'){
		saveResult = true;
		return;
	}else {
		if(action=='modify'){
			url = "docInforController/doUpdateDocInfor";
		}
		if(action=='add'){
			url = "docInforController/doSaveDocInfor";
		}
	}
	//url = "docInforController/doSaveDocInfor";
	if ($('#docInforForm').validationEngine('validate')){
		var obj = $('#docInforForm').serialize() + '&arcType='+$('#arcType').val();
		var formArcId = $('#docInforId').val();
		if(formArcId==null||formArcId==''){
			obj= obj.replace('arcId=','arcId='+parent.arcId);
		}
		$.ajax({
			type : "POST",
			url : url,
			async : false,
			data : obj,
			success : function(data) {
				if(data.result){
					//window.parent.parent.closePage(window,true,true,true);
					//window.parent.iniTable(window.parent.parent.globalFileType);
					//$(window.parent.document).find("#btn_close")[0].click();
					//window.parent.parent.closePage(window,true,true,false);
					saveResult = true;
				}else{
					saveResult = false;
					layerAlert("保存失败!请关闭页面重新打开页签！");
				}
			},
			complete: function(){
				//window.parent.closePage(window,true,true,true);
			},
			error : function(data) {
				saveResult = false;
				layerAlert("error:" + data.responseText);
			}
		});
	}else{
		//jump the to the dengji page
		$(window.parent.document).find("#dengji_li a")[0].click();
	}
}