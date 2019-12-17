/**
 * 初始化函数
 */
$(function() {
	// 初始化列表
	initTimerList();
});

/**
 * 初始化系统注册列表
 * 
 * @param 无
 * @param 无
 */
function initTimerList() {
	$('#timerList').datagrid({
		url : 'timerController/findListData',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		method : 'POST',
		idField : 'id',
		striped : true,
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		fit: true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', 				checkbox : true }, 
		   { field : 'id', 		  		title : 'id', hidden : true }, 
		   { field : 'timerName', 		title : '定时器名称', 	width : 100, 	align : 'left' },
		   { field : 'timerType', 		title : '定时类别',	width : 60, 	align : 'left',formatter:formatType },
		   { field : 'timerInterval', 	title : '定时时间', width : 100, 	align : 'left' },
		   { field : 'timerUrl', 		title : '定时方法', 	width : 100, 	align : 'left'},
		   { field : 'timerRemark', 	title : '备注',  	width : 130, 	align : 'left'},
		   { field : 'istatus', 		title : '启用标识',	width : 50, 	align : 'left',formatter:formatIstate }
		]],
		onClickRow: function(index,row){
			//, formatter:formatIsDisable 
			//cancel all select
			$('#timerList').datagrid("clearChecked");
			//check the select row
			$('#timerList').datagrid("selectRow", index);
		}
	});
}

/**
 * 保存
 * 
 * @param 无
 * @param 无
 */
function doSaveTimer() {
	if(!$('#timerForm').form('validate')){
		return;
	}

	var url = "";
	if (id == undefined || id == '') {
		url = "timerController/doSaveTimer";
	} else {
		url = "timerController/doUpdateTimer";
	}

	$.ajax({
		url : url,
		type : "post",
		async : false,
		data : $('#timerForm').serialize(),
		success : function(data) {
			$.messager.show({ title:'提示', msg:'保存成功！', showType:'slide' });
			$('#timerDialog').dialog('close');
			reload();
			//initdldata();
		},
		error : function() {
			$.messager.show({ title:'提示', msg:'操作失败！', showType:'slide' });
		}
	});
}

/**
 * 新增
 * 
 * @param 无
 * @param 无
 */
function openForm(title) {
	$('#timerDialog').dialog({
		title : title
	});
	initdldata();
	id = '';
	$('#timerDialog').dialog('open');
}

/**
 * 修改
 * 
 * @param 无
 * @param 无
 */
var id = "";
function openUpdateForm(title) {
	$('#timerDialog').dialog({
		title : title
	});
	initdldata();
	var data = $('#timerList').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行修改！', 'info');
		return;
	}
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '请选择一行进行修改！', 'info');
			return;
		}
		var timer = data[0];
		$("#timerName").textbox('setValue',timer.timerName);
		$("#timerInterval").textbox('setValue',timer.timerInterval);
		$("#timerUrl").textbox('setValue',timer.timerUrl);
		$("#timerRemark").textbox('setValue',timer.timerRemark);
		$("#timerType").combobox('setValue',timer.timerType);
		
		id = data[0].id;
		$("#id").val(id);
		
		$('#timerDialog').dialog('open');
	}
}

/**
 * 删除
 * 
 * @param 无
 * @param 无
 */
function doDeleteTimer() {
	var selecteds = $('#timerList').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		$.messager.alert('提示', '请选择需要删除的记录！', 'info');
		return;
	}
	$.messager.confirm('删除', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].id + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'timerController/doDeleteTimer',
				async : false,
				dataType : 'json',
				data : {ids : ids},
				success : function(result) {
					var msg = result;
					$.messager.show({ title:'提示', msg:'删除成功!', showType:'slide' });
					reload();
					$('#timerList').datagrid('clearChecked'); // 清空选中的行
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败!', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 重新加载列表
 * 
 * @param 无
 * @param 无
 */
function reload() {
	$('#timerList').datagrid('reload', {});
}

/**
 * 初始化dialog清空数据
 * 
 * @param 无
 * @param 无
 */
function initdldata() {
	$("#timerName").textbox('setValue',"");
	$("#timerInterval").textbox('setValue',"");
	$("#timerUrl").textbox('setValue',"");
	$("#timerRemark").textbox('setValue',"");
	$("#timerType").combobox('setValue',"1");
}

/**
 * 启用
 * 
 * @param 无
 * @param 无
 */
function doStartTimer() {

	var data = $('#timerList').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '请选择一行进行操作！', 'info');
			return;
		}
		
		$.ajax({
			url : "timerController/doStartTimer",
			type : "post",
			async : false,
			data : {id  : data[0].id},
			success : function(data) {
				$.messager.show({ title:'提示', msg:'创建索引成功！', showType:'slide' });
				reload();
			},
			error : function() {
				$.messager.show({ title:'提示', msg:'操作失败！', showType:'slide' });
			}
		});
	}
}

/**
 * 禁用
 * 
 * @param 无
 * @param 无
 */
function doStopTimer() {

	var data = $('#timerList').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '请选择一行进行操作！', 'info');
			return;
		}
		
		$.ajax({
			url : "timerController/doStopTimer",
			type : "post",
			async : false,
			data : {id  : data[0].id},
			success : function(data) {
				$.messager.show({ title:'提示', msg:'禁用成功！', showType:'slide' });
				reload();
			},
			error : function() {
				$.messager.show({ title:'提示', msg:'操作失败！', showType:'slide' });
			}
		});
	}
}

/*************************** 格式化字段值 ***************************/
/**
 * 格式化类型字段
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatType(val, row) {
	if(val == null || val == ''){
	   return null;
	}
	if(val == "1") {
		return "每天";
	}
	if(val == "2") {
	   return '每周';
	}
	if(val == "3") {
	   return '每月';
	}
	if(val == "4") {
	   return '自定义间隔';
	}
	return '';
}

/**
 * 格式化状态字段
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatIstate(val, row) {
	if(val == null ){
	   return null;
	}
	if(val == 0) {
	   return '禁用';
	}
	if(val == 1) {
	   return '启用';
	}
	return '';
}