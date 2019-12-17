$(function() {
	var id=$("#typeId").val();
	var pId=$("#pId").val();
	laydate.skin('dahong');
	if(pId==0){
	pId=id;
	}
    findArcTypeInfoById(pId,"arcType");
	$('input,select,textarea',$('form[name="pubInfoFormView"]')).prop('disabled',true);
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

//验证表单必填项
function validateForm(){
	return $('#pubInfoFormView').validationEngine('validate');
}
