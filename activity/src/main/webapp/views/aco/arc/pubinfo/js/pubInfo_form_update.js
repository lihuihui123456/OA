$(function() {
	var id=$("#typeId").val();
	var pId=$("#pId").val();
	if(pId==0){
		pId=id;
	}
	laydate.skin('dahong');
/*    findArcTypeInfoById(id,"amsType");
*/    findArcTypeInfoById(pId,"arcType");
	
	
});
function findArcTypeInfoById(id,type){
		$.ajax({
		type : "POST",
		url : "actTypeController/findArcTypeInfoById",
		data : {"Id":id},
		success : function(data) {
			var select = document.getElementById(type);
			select.options.length=0; //把select对象的所有option清除掉
			for (var i = 0; i < data.length; i++) {
				var op = document.createElement("option"); // 新建OPTION (op)
				op.setAttribute("value", data[i].id); // 设置OPTION的 VALUE
				op.appendChild(document.createTextNode(data[i].typeName)); // 设置OPTION的text
				select.appendChild(op); // 为SELECT 新建一 OPTION(op)
				$('#'+type).selectpicker('refresh');
				// select.options.remove(i); //把select对象的第i个option清除掉
			}
		},
		error : function(data) {
			layerAlert("error:" + data.responseText);
		}
	});
}
function doReset(){
  document.getElementById("pubInfoFormUpdate").reset();
}
function doSaveFormUpdate() {
	var flag = "N"
	if ($('#pubInfoFormUpdate').validationEngine('validate')) {
		$.ajax({
			type : "POST",
			url : "pubInfo/update",
			data : $('#pubInfoFormUpdate').serialize(),
			success : function(data) {
			},
			error : function(data) {
				alert("error:" + data.responseText);
			}
		});
		return flag;
	}else{
		flag="Y";
		return flag;
	}
}
//验证表单必填项
function validateForm(){
	return $('#pubInfoFormUpdate').validationEngine('validate');
}
