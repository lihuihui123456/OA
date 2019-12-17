/************* 页面初始化 start  **************************************************/
/**加载表单数据*/
function initFormData(){
	if(map != null && map.length > 0) {
		var obj;
		for (var i = 0; i < map.length; i++) {
			obj = map[i];
	        /**遍历map实现表单回显*/
	        for ( var key in obj ) {
	        	var checkboxs = $('input:checkbox[name=' + key + ']');
	        	var radios = $('input:radio[name=' + key + ']');
	        	if (checkboxs.length != 0) {//对复选框的处理
	        		var values = obj[key].split(",");
	        		for ( var i = 0; i < checkboxs.length; i++) {
	        			//获取所有复选框对象的value属性，然后，用checkArray[i]和他们匹配，如果有，则说明他应被选中
	        			$.each(checkboxs, function(j, checkbox) {
	        				//获取复选框的value属性
	        				var checkValue = $(checkbox).val();
	        				if (values[i] == checkValue) {
	        					$(checkbox).attr("checked", checked);
	        				}
	        			});
	        		}
	        	} else if(radios.length != 0) {//对单选框的处理
	        		for ( var i = 0; i < radios.length; i++) {
	        			//获取所有复选框对象的value属性，然后，用checkArray[i]和他们匹配，如果有，则说明他应被选中
	        			$.each(radios, function(j, radio) {
	        				//获取复选框的value属性
	        				var radioValue = $(radio).val();
	        				if (obj[key] == radioValue) {
	        					$(radio).attr("checked", true);
	        				}
	        			});
	        		}
	        	}else {//其他输入框的处理
	        		$('#' + key).val(obj[key]);
	        	}
	        }
	    }
	}

}

/**加载表单样式*/
function initFormStyle(){
	/**
	 * style表示当前表单以什么方式打开  deal:办理  view：查看  draft:拟稿  update:修改
	 * 通过自定义的class属性来控制表单读写权限
	 * input 表示输入控件  comment 表示意见框  select表示通过选择方式来实现录入的控件
	 */
	if(style == "deal") {
		$('.input').attr("readonly","readonly");
		$('.select').attr("disabled","disabled");
	}
	if(style == "view") {
		$('.input').attr("readonly","readonly");
		$('.select').attr("disabled","disabled");
	}
}

$(function() {
	laydate.skin('dahong');
	$('#myFm').validationEngine({}); 
	
	//填充表单数据
	initFormData();
	
	//设置表单样式
	initFormStyle();
});
/************* 页面初始化 end  **************************************************/

/******  父页面调用方法 start ********************************************************/
//获取标题
function getTitle() {
	return $("#title_").val();
}

//获取文字意见
function getComment(commentColumn){
	return $("#"+commentColumn).val();
}

//获取紧急程度
function getUrgencyLevel() {
	return $("#urgencyLevel_").val();
}

//获取手写前签批内容
function getSignature() {
	var signatureImg = "";
	if(signatureMap != undefined && signatureMap[commentColumn] != undefined) {
		signatureImg = signatureMap[commentColumn];
	}
	return signatureImg;
}

//验证表单必填项
function validateForm(){
	return $('#myFm').validationEngine('validate');
}

/**
 * 拟稿页面保存表单
 * @param bizId
 * @returns {String}
 */
function doSaveForm(bizId, action, operate) {
	$('#bizId_').val(bizId);
	var flag = "N"
	$.ajax({
		url : 'bpmRuFormInfoController/doSaveBizForm?bizId='+bizId+'&tableName='+tableName+'&action='+action+'&operate='+operate,
		type : 'post',
		dataType : 'text',
		async : false,
		data : $('#myFm').serialize(),
		success : function(data) {
			flag = data;
		}
	});
	return flag;
}

/**
 * 编辑页面保存表单
 * @param bizId
 * @returns {String}
 */                  
function doUpdateForm(bizId) {
	$('#bizId_').val(bizId);
	var flag = "N"
	$.ajax({
		url : 'bpmRuFormInfoController/doUpdateBpmDuForm/'+bizId+'/'+tableName,
		type : 'post',
		dataType : 'text',
		async : false,
		data : $('#myFm').serialize(),
		success : function(data) {
			flag = data;
		}
	});
	return flag;
}

/**
 * 办理界面保存表单
 * @param bizId
 * @returns {String}
 */
function doDealForm(bizId) {
	$('#bizId_').val(bizId);
	var flag = "N";
	$.ajax({
		url : 'bpmRuFormInfoController/doDealBpmDuForm/'+bizId+'/'+tableName,
		type : 'post',
		dataType : 'text',
		async : false,
		data : $('#myFm').serialize(),
		success : function(data) {
			flag = data;
		}
	});
	return flag;
}



/******  父页面调用方法 end ********************************************************/