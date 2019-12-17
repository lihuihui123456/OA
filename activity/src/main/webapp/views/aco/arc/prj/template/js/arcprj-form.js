$(function() {
	var id = window.parent.$('#typeId').val();
	$('#arcPrjForm').validationEngine({}); 
	laydate.skin('dahong');
	$.ajax({
		type : "POST",
		url : "actTypeController/findArcTypeInfoById",
		data : {"Id":id},
		success : function(data) {
			var select = document.getElementById("arcType");
			select.options.length=0; //把select对象的所有option清除掉
			for (var i = 0; i < data.length; i++) {
				var op = document.createElement("option"); // 新建OPTION (op)
				op.setAttribute("value", data[i].id); // 设置OPTION的 VALUE
				op.setAttribute("selected", true);
				op.appendChild(document.createTextNode(data[i].typeName)); // 设置OPTION的text
				select.appendChild(op); // 为SELECT 新建一 OPTION(op)
				$('#arcType').selectpicker('refresh');
				// select.options.remove(i); //把select对象的第i个option清除掉
			}
		},
		error : function(data) {
			layerAlert("error:" + data.responseText);
		}
	});
	$('#guidangDiv').find('input').attr('readonly',true).attr('disabled',true);
	
});

function doSaveForm(arcId) {
	$('#arcId').val(arcId);
	var flag = "N"
	if ($('#arcPrjForm').validationEngine('validate')) {
		$.ajax({
			type : "POST",
			url : "arcPrjController/doAddarcprjInfo",
			data : $('#arcPrjForm').serialize(),
			success : function(data) {
			},
			error : function(data) {
				layerAlert("error:" + data.responseText);
			}
		});
		return flag;
	}else{
		flag="Y";
		return flag;
	}
}

function doUpdateSaveForm(arcId) {
	var flag = "N"
	if ($('#arcPrjForm').validationEngine('validate')) {
		$.ajax({
			type : "POST",
			url : "arcPrjController/doUpdateSaveArcPrjInfo",
			data : $('#arcPrjForm').serialize(),
			success : function(data) {
			},
			error : function(data) {
				layerAlert("error:" + data.responseText);
			}
		});
		return flag;
	}else{
		flag = "Y";
		return flag;
	}
}

//验证表单必填项
function validateForm(){
	return $('#arcPrjForm').validationEngine('validate');
}

function clearCUserForm(){
	  document.getElementById("arcPrjForm").reset();
	  $("select.selectpicker").each(function(){ 
	      $(this).selectpicker('val',$(this).find('option').eq(1).val());    //重置bootstrap-select显示 
	      $(this).find("option").attr("selected", false);                    //重置原生select的值 
	      $(this).find("option").eq(1).attr("selected", true); 
	  });
	var date = getNowFormatDate();
	$('#regTime').val(date);
	$("#arcName").val('');
	$("#prjName").val('');
	$("#prjAdd").val('');
	$("#prjNbr").val('');
	$("#prjUser").val('');
	$("#keyWord").val('');
	$("#remarks").val('');
	$("#depPos").val('');
}
function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    var hour = date.getHours();
    var min = date.getMinutes();
    var sec = date.getSeconds();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    if (hour >= 0 && hour <= 9) {
        hour = "0" + hour;
    }
    if (min >= 0 && min <= 9) {
        min = "0" + min;
    }
    if (sec >= 0 && sec <= 9) {
        sec = "0" + sec;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + hour + seperator2 + min
            + seperator2 + sec;
    return currentdate;
}