	var postName ="";
	var workTime = "";
	var already ="";
	var leaveday = "";
	var divId="bizform";
	var style = "";
	var tableName = "";
	var commentColumn = window.parent.commentColumn;
	var operateState=window.parent.operateState;
	var bizId=window.parent.bizId;
$(function() {
	$('#myFm').validationEngine({
		
	 }); 
	/**遍历map实现表单回显拟稿参数*/
	if(operateState=="draft"){
		$.ajax({
			url : 'leaveManager/getParam',
			type : 'post',
			success : function(map) {		
		     	//拟稿需要参数
				$.ajax({
					url : 'leaveManager/getParam',
					type : 'post',
					data:{bizId:bizId},
					success : function(map) {		
						for ( var key in map) {	
							if("postName"==key){
								postName=map[key];
								setPostName(postName);
							}if("workTime"==key){
								workTime=map[key];
								setWorkTime(workTime);
							}if("already_day"==key){
								already=map[key];
								setAlready(already);
							}if("leave_already"==key){
								leaveday=map[key];
								setLeaveday(leaveday);
							}if("style"==key){
								style=map[key];
							}if("tableName"==key){
								tableName=map[key];
							}
							//console.log(key+"    "+map[key]);
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
								if("leave_type"==key){
									var leave_type=map[key];
									//$("#leave_type").selectpicker('val', leave_type);
									$("#leave_type").val(leave_type);
								}	if("leave_capital"==key){
									var leave_capital=map[key];
									//$("#leave_capital").selectpicker('val', leave_capital);
									$("#leave_capital").val(leave_capital);

								}if("leave_country"==key){
									var leave_country=map[key];
									//$("#leave_country").selectpicker('val', leave_country);
									$("#leave_country").val(leave_country);

								}
							};
						};
						//设置参数
						setTotaldays(already,leaveday);
					}
				});
				//$('.comment').css("display","none");
				$('.comment').attr("readonly","readonly");
			}
		});
	}else if(operateState=="update"){
		$.ajax({
			url : 'leaveManager/togetFromParam',
			type : 'post',
			data:{bizId:bizId},
			success : function(map) {		
				for ( var key in map) {	
					if("postName"==key){
						postName=map[key];
						setPostName(postName);
					}if("workTime"==key){
						workTime=map[key];
						setWorkTime(workTime);
					}if("already_day"==key){
						already=map[key];
						setAlready(already);
					}if("leave_already"==key){
						leaveday=map[key];
						setLeaveday(leaveday);
					}if("style"==key){
						style=map[key];
					}if("tableName"==key){
						tableName=map[key];
					}
					//console.log(key+"    "+map[key]);
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
						if("leave_type"==key){
							var leave_type=map[key];
							//$("#leave_type").selectpicker('val', leave_type);
							$("#leave_type").val(leave_type);
						}	if("leave_capital"==key){
							var leave_capital=map[key];
							//$("#leave_capital").selectpicker('val', leave_capital);
							$("#leave_capital").val(leave_capital);

						}if("leave_country"==key){
							var leave_country=map[key];
							//$("#leave_country").selectpicker('val', leave_country);
							$("#leave_country").val(leave_country);

						}
						
					};
				};
				//设置参数
				setTotaldays(already,leaveday);
				//根据请假类型进行赋值
				if($("#leave_type").val()=="休假"){
					var xiujiaStarTime=$("#rest_time").val();
					var xiujiaEndTime=$("#rest_time_end").val();
					var xiujiaDays=$("#xiujia_days").val();
					$("#rest_leave_time").val(xiujiaStarTime);
					$("#rest_leave_time_end").val(xiujiaEndTime);
					$("#rest_leave_days").val(xiujiaDays);
				}else{
					var qjStarTime=$("#leave_time").val();
					var qjEndTime=$("#leave_time_end").val();
					var qjDays=$("#qingjia_days").val();
					$("#rest_leave_time").val(qjStarTime);
					$("#rest_leave_time_end").val(qjEndTime);
					$("#rest_leave_days").val(qjDays);
				}
			}
		});
		//修改设置编辑状态
		//$('.comment').css("display","none");
		$('.comment').attr("readonly","readonly");
	}else if(operateState=="deal"){
		$.ajax({
			url : 'leaveManager/togetFromParam',
			type : 'post',
			data:{bizId:bizId},
			success : function(map) {		
				for ( var key in map) {			
					if("postName"==key){
						postName=map[key];
						setPostName(postName);
					}if("workTime"==key){
						workTime=map[key];
						setWorkTime(workTime);
					}if("already_day"==key){
						already=map[key];
						setAlready(already);
					}if("leave_already"==key){
						leaveday=map[key];
						setLeaveday(leaveday);
					}if("style"==key){
						style=map[key];
					}if("tableName"==key){
						tableName=map[key];
					}
					//console.log(key+"    "+map[key]);
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
						if("leave_type"==key){
							var leave_type=map[key];
							//$("#leave_type").selectpicker('val', leave_type);
							$("#leave_type").val(leave_type);
						}	if("leave_capital"==key){
							var leave_capital=map[key];
							//$("#leave_capital").selectpicker('val', leave_capital);
							$("#leave_capital").val(leave_capital);

						}if("leave_country"==key){
							var leave_country=map[key];
							//$("#leave_country").selectpicker('val', leave_country);
							$("#leave_country").val(leave_country);

						}
					};
				};
				//设置参数
				setTotaldays(already,leaveday);
				//根据请假类型进行赋值
				if($("#leave_type").val()=="休假"){
					var xiujiaStarTime=$("#rest_time").val();
					var xiujiaEndTime=$("#rest_time_end").val();
					var xiujiaDays=$("#xiujia_days").val();
					$("#rest_leave_time").val(xiujiaStarTime);
					$("#rest_leave_time_end").val(xiujiaEndTime);
					$("#rest_leave_days").val(xiujiaDays);
				}else{
					var qjStarTime=$("#leave_time").val();
					var qjEndTime=$("#leave_time_end").val();
					var qjDays=$("#qingjia_days").val();
					$("#rest_leave_time").val(qjStarTime);
					$("#rest_leave_time_end").val(qjEndTime);
					$("#rest_leave_days").val(qjDays);
				}
			}
		});
		//处理设置编辑状态
		$('.input').attr("readonly","readonly");
		$('.select').attr("disabled","disabled");
		//$('.comment').css("display","none");
		$('#'+commentColumn).css({"display" :"block" ,});
		$('#'+commentColumn).focus();
	}else if(operateState=="view"){
		$.ajax({
			url : 'leaveManager/togetFormViewParam',
			type : 'post',
			data:{bizId:bizId},
			success : function(map) {
				for ( var key in map) {			
					if("postName"==key){
						postName=map[key];
						setPostName(postName);
					}if("workTime"==key){
						workTime=map[key];
						setWorkTime(workTime);
					}if("already_day"==key){
						already=map[key];
						setAlready(already);
					}if("leave_already"==key){
						leaveday=map[key];
						setLeaveday(leaveday);
					}if("style"==key){
						style=map[key];
					}if("tableName"==key){
						tableName=map[key];
					}
					//console.log(key+"    "+map[key]);
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
						if("leave_type"==key){
							var leave_type=map[key];
							//$("#leave_type").selectpicker('val', leave_type);
							$("#leave_type").val(leave_type);
						}	if("leave_capital"==key){
							var leave_capital=map[key];
							//$("#leave_capital").selectpicker('val', leave_capital);
							$("#leave_capital").val(leave_capital);

						}if("leave_country"==key){
							var leave_country=map[key];
							//$("#leave_country").selectpicker('val', leave_country);
							$("#leave_country").val(leave_country);

						}
					};
				};
				//设置参数
				setTotaldays(already,leaveday);
				//根据请假类型进行赋值
				if($("#leave_type").val()=="休假"){
					var xiujiaStarTime=$("#rest_time").val();
					var xiujiaEndTime=$("#rest_time_end").val();
					var xiujiaDays=$("#xiujia_days").val();
					$("#rest_leave_time").val(xiujiaStarTime);
					$("#rest_leave_time_end").val(xiujiaEndTime);
					$("#rest_leave_days").val(xiujiaDays);
				}else{
					var qjStarTime=$("#leave_time").val();
					var qjEndTime=$("#leave_time_end").val();
					var qjDays=$("#qingjia_days").val();
					$("#rest_leave_time").val(qjStarTime);
					$("#rest_leave_time_end").val(qjEndTime);
					$("#rest_leave_days").val(qjDays);
				}
			}
		});
		//查看设置编辑状态
		$('.input').attr("readonly","readonly");
		$('.select').attr("disabled","disabled");
		$('.comment').attr("readonly","readonly");
	}


	
	/**
	 * style表示当前表单以什么方式打开  deal:办理  view：查看  draft:拟稿  update:修改
	 * 通过自定义的class属性来控制表单读写权限
	 * input 表示输入控件  comment 表示意见框  select表示通过选择方式来实现录入的控件
	 */
/*	if(style == "deal") {
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
	}*/
});
function setState(state){
	$('#state').val(state);
}
function doSaveForm(bizId,action) {	
	//待办处理时设置select的编辑按钮，把不可编辑状态改为编辑状态，解决select数据获取不了问题
	$('.select').attr("disabled",false);
	//根据请假类型来判断请休假类型
	var startTime='';
	var endTime='';
	var days='';
	if($("#leave_type").val() == '休假'){
		startTime=$("#rest_leave_time").val();
	    endTime=$("#rest_leave_time_end").val();
	    days=$("#rest_leave_days").val();
		$("#rest_time").val(startTime);
		$("#rest_time_end").val(endTime);
		$("#xiujia_days").val(days);		
	}else{
		startTime=$("#rest_leave_time").val();
	    endTime=$("#rest_leave_time_end").val();
	    days=$("#rest_leave_days").val();
		$("#leave_time").val(startTime);
		$("#leave_time_end").val(endTime);
		$("#qingjia_days").val(days);
	}
	//判断是送交还是暂存
	if(action=="send"){
		//送交事件包含第一次发送和处理两种情况，如果action等于send那么state已经有值，在点击送交时候赋值
	}else if(action=="save"){
		$('#state').val('1');
	}	
	$('#bizId_').val(bizId);
	$('#id').val(bizId);
	var flag = "N"
	$.ajax({
		url : 'leaveManager/doSaveBpmDuForm/',
		type : 'post',
		dataType : 'text',
		async : false,
		data : $('#myFm').serialize(),
		success : function(data) {
			flag = data;
			if(flag == "Y"){
				$('#state').val('');
			}
		}
	});
	return flag;
}

function doUpdateForm(bizId,action) {
	if(action=="send"){
		$('#state').val('0');
	}else if(action=="save"){
		$('#state').val('1');
	}
	$('#bizId_').val(bizId);
	$('#id').val(bizId);
	var flag = "N"
	$.ajax({
		url : 'leaveManager/doUpdateBpmDuForm/',
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

function getTitle() {
	return $("#title_").val();
}

function getUrgencyLevel() {
	return $("#urgencyLevel_").val();
}

//laydate.skin('dahong');
//验证表单必填项
function validateForm(){
	return $('#myFm').validationEngine('validate');
}
function setPostName(postName){
	$('#post_name').val(postName);
}
function setWorkTime(workTime){
	$('#work_time').val(workTime);
}
function setAlready(already){
	$('#already_day').val(already);
}
function setLeaveday(leaveday){
	$('#leave_already').val(leaveday);
}
function setTotaldays(already,leaveday){
	$('#total_days').val((parseInt(already)+parseInt(leaveday)).toString());
}