$(function() {
	var id=$("#typeId").val();
	var pId=$("#pId").val();
	if(pId==0){
	pId=id;
	}
	laydate.skin('dahong');
   /* findArcTypeInfoById(id,"amsType");*/
    findArcTypeInfoById(pId,"arcType");
	 var nowtime=CurentTime();
	/* $("#regTime").val(nowtime);*/
	
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
				op.setAttribute("selected", true);
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
function doSaveForm(arcId) {
	$('#arcId').val(arcId);
	var flag = "N"
	if ($('#pubInfoForm').validationEngine('validate')) {
		$.ajax({
			type : "POST",
			url : "pubInfo/add",
			data : $('#pubInfoForm').serialize(),
			success : function(data) {
				layerAlert("保存成功!");
				$('input,select,textarea',$('form[name="pubInfoForm"]')).prop('disabled',true);
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
function doReset(){
  document.getElementById("pubInfoForm").reset();
  $("select.selectpicker").each(function(){ 
      $(this).selectpicker('val',$(this).find('option').eq(1).val());    //重置bootstrap-select显示 
      $(this).find("option").attr("selected", false);                    //重置原生select的值 
      $(this).find("option").eq(1).attr("selected", true); 
  });
}
function doUpdateForm(bizId) {
	$('#arcId').val(bizId);
	var flag = "N"
	$.ajax({
		url : 'bpmRuFormInfoController/doUpdateBpmDuForm/'+bizId+'/'+tableName,
		type : 'post',
		dataType : 'text',
		async : false,
		data : $('#pubInfoForm').serialize(),
		success : function(data) {
			flag = data;
		}
	});
	return flag;
}


//验证表单必填项
function validateForm(){
	return $('#pubInfoForm').validationEngine('validate');
}
function CurentTime()
    { 
        var now = new Date();
        
        var year = now.getFullYear();       //年
        var month = now.getMonth() + 1;     //月
        var day = now.getDate();            //日
        
        var hh = now.getHours();            //时
        var mm = now.getMinutes();          //分
        var ss = now.getSeconds();           //秒
        
        var clock = year + "-";
        
        if(month < 10)
            clock += "0";
        
        clock += month + "-";
        
        if(day < 10)
            clock += "0";
            
        clock += day + " ";
        
        if(hh < 10)
            clock += "0";
            
        clock += hh + ":";
        if (mm < 10) clock += '0'; 
        clock += mm + ":"; 
         
        if (ss < 10) clock += '0'; 
        clock += ss; 
        return(clock); 
}
