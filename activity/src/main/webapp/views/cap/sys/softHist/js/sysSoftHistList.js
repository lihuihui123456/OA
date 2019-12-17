/**
 * 初始化函数
 */
$(function() {
	// 初始化公司简史列表
	initSysHistoryList();
});

/**
 * 全局变量
 * */
var flag = 0;//新增修改标识   0：新增  1：修改

/**
 * 初始化公司简史列表
 * 
 * @param 无
 * @param 无
 */
function initSysHistoryList() {
	$('#historyList').datagrid({
		url : 'historyController/findByCondition',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		method : 'POST',
		idField : 'histId',
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
		   { field : 'ck', checkbox : true }, 
		   { field : 'histId', 		  	title : 'histId', hidden : true },
		   { field : 'histSkin', 		  	title : 'histSkin', hidden : true },  
		   { field : 'histName', 	title : '事件名称',  align : 'left', width : 200 }, 
		   { field : 'histDesc', 		title : '事件简述',  align : 'left', width : 250 }, 
		   { field : 'histDate', 	title : '事件日期', align : 'left', width : 150 }
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#historyList').datagrid("clearChecked");
			//check the select row
			$('#historyList').datagrid("selectRow", index);
		}
	});
}

/**
 * 保存
 * 
 * @param 无
 * @param 无
 */
function doSaveSysHistory() {
	if(!$('#historyForm').form('validate')){
		return;
	}

	var url = "";
	if (flag == 0) {
		url = "historyController/doSaveSysSoftHist";
	} else {
		url = "historyController/doUpdateSysSoftHist";
	}

	$.ajax({
		url : url,
		type : "post",
		async : false,
		data : $("#historyForm").serialize(),
		success : function(data) {
			$.messager.show({ title:'提示', msg:data.message, showType:'slide' });
			flag = 0;
			$('#historyDialog').dialog('close');
			reload();
			initdldata();
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
	$('#historyDialog').dialog({
		title : title
	});
	flag = 0;
	initdldata();
	$('#historyDialog').dialog('open');
}

/**
 * 修改
 * 
 * @param 无
 * @param 无
 */
function openUpdateForm(title) {
	$('#historyDialog').dialog({
		title : title
	});
	initdldata();
	var data = $('#historyList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行进行修改！', 'info');
			layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
			return;
		}
		var history = data[0];
		$("#histId").val(history.histId);
		$("#hisSkin").combobox('setValue',history.histSkin);
		$("#histName").textbox('setValue',history.histName);
		$("#histDate").textbox('setValue',history.histDate);
		$("#histDesc").textbox('setValue',history.histDesc);
		flag = 1;
		$('#historyDialog').dialog('open');
	}
}

/**
 * 删除
 * 
 * @param 无
 * @param 无
 */
function doDeleteHistory() {
	var selecteds = $('#historyList').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择需要删除的记录！', 'info');
		layer.tips('请选择需要删除的记录', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除公司简史', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].histId + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'historyController/doDeleteSysSoftHist',
				async : false,
				dataType : 'json',
				data : {ids : ids},
				success : function(result) {
					var message = result.message;
					$.messager.show({ title:'提示', msg:message, showType:'slide' });
					reload();
					$('#historyList').datagrid('clearSelections'); // 清空选中的行
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:result.message, showType:'slide' });
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
	$('#historyList').datagrid('reload', {});
}

/**
 * 初始化dialog清空数据
 * 
 * @param 无
 * @param 无
 */
function initdldata() {
	$("#histSkin").combobox('setValue',"");
	$("#histDate").textbox('setValue',"");
	$("#histName").textbox('setValue',"");
	$("#histDesc").textbox('setValue',"");
}

/**
 * 条件查询
 * 
 * @param 无
 * @param 无
 */
function findByCondition(){
	var histName = $("#name").textbox('getValue');
	$('#historyList').datagrid({
        queryParams:{
        	histName : histName
        }
    });
}

/*************************** 公共函数 *****************************/
/**
 * 清空查询框值
 * 
 * @param 无
 * @returns 无
 */
function clearSearchBox(){
	 $("#name").searchbox("setValue", "");
}