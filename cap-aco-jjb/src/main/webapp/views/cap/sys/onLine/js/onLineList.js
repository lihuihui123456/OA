/**
 * 初始化函数
 */
$(function() {
	// 初始化在线用户列表
	initOnLineList();
	// 初始化终端类型下拉框
	initDict({
		"terminalType":"terminalType"
	},'true');
	/*// 初始化是否在线下拉框
	initDict({
		"onlineState":"onlineState"
	},'true');*/
});

/**
 * 初始化系统注册列表
 * 
 * @param 无
 * @param 无
 */
function initOnLineList() {
	$('#onlineList').datagrid({
		url : 'onlineUserController/findByCondition',
		method : 'POST',
		idField : 'sessionId',
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
//		   { field : 'ck',checkbox : true}, 
		   { field : 'sessionId',  title : '会话ID',hidden : true},
		   { field : 'userName', 	title : '用户姓名',      width : 100, align : 'left' },
		   { field : 'acctLogin', 	title : '登陆账号',      width : 100, align : 'left' }, 
		   { field : 'onlineTime',   title : '上线时间', 	width : 180, align : 'left' },
//		   { field : 'offlineTime',   title : '下线时间', 	width : 180, align : 'left' },
		   { field : 'terminalType',   title : '终端', 	width : 100, align : 'left',formatter : formatType },
		   { field : 'ipAddr', 		title : 'IP地址',	width : 100, align : 'left' },
		   { field : 'onlineState',     title : '是否在线',      width : 100, align : 'left',formatter : formatState },
		   { field : 'operator',     title : '操作',      width : 100, align : 'left',formatter : formatOperate }
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#onlineList').datagrid("clearChecked");
			//check the select row
			$('#onlineList').datagrid("selectRow", index);
		}
	});
}

/**
 * 查询
 * @author 王建坤
 * */
function submitForm() {
	var userName = $("#userName").textbox("getValue");
	var acctLogin = $("#acctLogin").textbox("getValue");
	var terminalType = $("#terminalType").combobox("getValue");
//	var onlineState = $("#onlineState").combobox("getValue");
	$('#onlineList').datagrid({
		queryParams : {
			userName : userName,
			acctLogin : acctLogin,
			terminalType : terminalType
//			onlineState : onlineState
		}
	});
}

/**
 * 生成强制退出链接
 * @author 王建坤
 * @param row 行数据
 */
function createLink(value,row) {
	var sessionId = row.sessionId;
	return '<a href="javascript:forceKickOut(\''+sessionId+'\')">下线</a>';
}

/**
 * 强制踢出用户
 * @author 王建坤
 * @param sessionId 会话ID
 */
function forceKickOut(sessionId) {
	$.messager.confirm('终止会话', '确定终止当前用户会话吗?', function(r) {
		if (r) {
			$.ajax({
				url : 'onlineUserController/forceKickOut',
				type : 'post',
				data : {
					sessionId : sessionId
				},
				dataType : 'json',
				success : function(data){
					$.messager.show({ title:'提示', msg:data.message, showType:'slide' });
					initOnLineList();
				},
				error : function(data) {
					$.messager.show({ title:'提示', msg:data.responseText, showType:'slide' });
					initOnLineList();
				}
			});
		}
	});
}

/**
 * 批量踢出用户
 * @author 王建坤
 * @param 
 */
function batchKickOut() {
	var selecteds = $('#onLineList').treegrid('getChecked');
	if (selecteds == null || selecteds.length == 0) {
		$.messager.alert('提示', '请选择操作项！', 'info');
		return;
	}
	$.messager.confirm('终止会话', '确定终止吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].sessionId + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'onLineController/doBatchDelete',
				dataType : 'json',
				data : {ids : ids},
				success : function(result) {
					$.messager.show({ title:'提示', msg:'终止成功', showType:'slide' });
					initOnLineList()
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'终止失败', showType:'slide' });
				}
			});
		}
	});
}
/*************************** 格式化字段值 ***************************/
/**
 * 格式化终端类型
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatType(val, row) {
	if (val == "1") {
		return "移动端";
	} else if (val == '2') {
		return "PC端";
	}
}

/**
 * 格式化是否在线
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatState(val, row) {
	if (val == "Y") {
		return "是";
	} else {
		return "否";
	}
}

/**
 * 格式化踢人操作
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatOperate(val, row) {
	var sessionId = row.sessionId;
	if (row.onlineState == 'Y') {
		return '<img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/icon-sys-zzhy.png" onclick="forceKickOut(\''+sessionId+'\')"/>';
	} else {
		return '<img src="static/cap/plugins/easyui/themes/icons/icon-sys-zzhygray.png" />';
	}
}