$(function() {
	$('#myFm').validationEngine({
	 }); 
	/**遍历map实现表单回显*/
	for ( var key in map) {
		var checkboxs = $('input:checkbox[name=' + key + ']');
		var radios = $('input:radio[name=' + key + ']');
		if (checkboxs.length != 0) {//对复选框的处理
			var values = map[key].split(",");
			for ( var i = 0; i < checkboxs.length; i++) {
				//获取所有复选框对象的value属性，然后，用checkArray[i]和他们匹配，如果有，则说明他应被选中
				$.each(checkboxs, function(j, checkbox) {
					//获取复选框的value属性
					var checkValue = $(checkbox).val();
					if (values[i] == checkValue) {
						$(checkbox).attr("checked", checked);
					};
				});
			};
		} else if(radios.length != 0) {//对单选框的处理
			for ( var i = 0; i < radios.length; i++) {
				//获取所有复选框对象的value属性，然后，用checkArray[i]和他们匹配，如果有，则说明他应被选中
				$.each(radios, function(j, radio) {
					//获取复选框的value属性
					var radioValue = $(radio).val();
					if (map[key] == radioValue) {
						$(radio).attr("checked", true);
					};
				});
			};
		}else {//其他输入框的处理
			$('#' + key).val(map[key]);
		};
	};
	
	/**
	 * style表示当前表单以什么方式打开  deal:办理  view：查看  draft:拟稿  update:修改
	 * 通过自定义的class属性来控制表单读写权限
	 * input 表示输入控件  comment 表示意见框  select表示通过选择方式来实现录入的控件
	 */
	if(style == "deal") {
		$('.input').attr("readonly","readonly");
		$('.select').attr("disabled","disabled");
		$('.comment').css("display","none");
		$('#'+commentColumn).css({"display" :"block" ,});
		$('#'+commentColumn).focus();
	}
	if(style == "draft" || style == "update" ) {
		$('.comment').css("display","none");
	}
	if(style == "view") {
		$('.input').attr("readonly","readonly");
		$('.select').attr("disabled","disabled");
		$('.comment').css("display","none");
	}
});

function doSaveForm(bizId,action) {	
	$('#bizId_').val(bizId);
	$('#id').val(bizId);
	var flag = "N"
	$.ajax({
		url : 'contractMgr/doSaveBpmDuForm/',
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

function doUpdateForm(bizId,action) {
	$('#bizId_').val(bizId);
	$('#id').val(bizId);
	var flag = "N"
	$.ajax({
		url : 'contractMgr/doUpdateBpmDuForm/',
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

//laydate.skin('dahong');
//验证表单必填项
function validateForm(){
	return $('#myFm').validationEngine('validate');
}