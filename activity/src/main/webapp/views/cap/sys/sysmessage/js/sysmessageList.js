/**
 * 初始化函数
 */
$(function() {
	// 初始化系统注册列表
	initSysmessageList();
});

/**
 * 初始化系统注册列表
 * 
 * @param 无
 * @param 无
 */
function initSysmessageList() {
	$('#sysmessageList').datagrid({
		url : 'sysMessageController/findByCondition',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		method : 'POST',
		idField : 'messId',
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
		   { field : 'messId', 		  	title : '消息ID', hidden : true }, 
		   { field : 'mesType', 		title : '消息类型', 	width : 60, 	align : 'left', formatter:formatMesType },
		   { field : 'terminalType',    title : '终端类型',	width : 60, 	align : 'left', formatter:formatTermType},
		   { field : 'senderName', 		title : '发送人姓名',  width : 60, 	align : 'left' },
		   { field : 'senTime', 		title : '发送时间', 	width : 100, 	align : 'left' },
		   { field : 'senNum', 		    title : '发送次数', 	width : 60, 	align : 'left' },
		   { field : 'revName', 		title : '接收人姓名',  	width : 60, 	align : 'left' },
		   { field : 'revTime', 		title : '接收时间',	width : 100, 	align : 'left' },
		   { field : 'state', 		    title : '消息发送状态',	width : 60, 	align : 'left', formatter:formatState }
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#sysmessageList').datagrid("clearChecked");
			//check the select row
			$('#sysmessageList').datagrid("selectRow", index);
		}
	});
}


/**
 * 删除
 * 
 * @param 无
 * @param 无
 */
function doDeleteSysMessage() {
	var selecteds = $('#sysmessageList').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择需要删除的记录！', 'info');
		layer.tips('请选择需要删除的记录', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除系统消息', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].messId + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'sysMessageController/doDeleteSysMessage',
				async : false,
				dataType : 'json',
				data : {ids : ids},
				success : function(result) {
					var msg = result;
					$.messager.show({ title:'提示', msg:'删除成功!', showType:'slide' });
					reload();
					$('#sysmessageList').datagrid('clearSelections'); // 清空选中的行
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
	$('#sysmessageList').datagrid('reload', {});
}

/**
 * 初始化dialog清空数据
 * 
 * @param 无
 * @param 无
 */
function initdldata() {
	$("#sysFlag").textbox('setValue',"");
	$("#sysName").textbox('setValue',"");
	$("#sysUrl").textbox('setValue',"");
	$("#sysRegCode").textbox('setValue',"");
	$("#sysDesc").textbox('setValue',"");
	// 是否禁用 Y禁用 N启用
	$("#isDisable").switchbutton("uncheck"); 
	// 是否外系统 Y是 N否
	$("#isOutSys").switchbutton("uncheck"); 
}

/**
 * 条件查询
 * 
 * @param 无
 * @param 无
 */
function findByCondition(){
	var sysFlagAndName = $("#sysFlagAndName").textbox('getValue');
	$('#sysmessageList').datagrid({
        url:"sysMessageController/findByCondition",
        queryParams:{
        	param : sysFlagAndName
        }
    });
}

/*************************** 格式化字段值 ***************************/
/**
 * 格式化消息类型字段
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatMesType(val, row) {
	if(val == null || val == ''){
	   return null;
	}
	if(val == "0") {
		return "邮件";
	}
	if(val == "1") {
	   return 'BPM';
	}
	if(val == "2") {
		return "通知";
	}
	if(val == "3") {
	   return '即时通讯';
	}
	return '';
}

/**
 * 格式化终端类型字段
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatTermType(val, row) {
	if(val == null || val == ''){
	   return null;
	}
	if(val == "0") {
		return "PC端";
	}
	if(val == "1") {
	   return 'WEB端';
	}
	if(val == "2") {
		return "手机端";
	}
	if(val == "3") {
	   return 'PAD端';
	}
	return '';
}

/**
 * 格式化消息状态字段
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatState(val, row) {
	if(val == null || val == ''){
	   return null;
	}
	if(val == "0") {
		return "消息接收成功";
	}
	if(val == "1") {
	   return '消息推送成功，但未查看';
	}
	if(val == "2") {
		return "消息用户查看";
	}
	if(val == "3") {
	   return '消息撤回';
	}
	return '';
}

/*************************** 公共函数 *****************************/
/**
 * 清空查询框值
 * 
 * @param 无
 * @returns 无
 */
function clearSearchBox(){
	 $("#sysFlagAndName").searchbox("setValue", "");
}