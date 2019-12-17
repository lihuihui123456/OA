/**
 * 初始化函数
 */
$(function() {
	// 初始化操作日志列表
	initAuditLoginLogList();
});

/**
 * 初始化操作日志列表
 * 
 * @param 无
 * @param 无
 */
function initAuditLoginLogList() {
	$('#operateLogList').datagrid({
		url : 'operateLogController/findByCondition',
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
		   { field : 'ck',checkbox : true}, 
		   { field : 'id',   title : 'id',hidden : true},
		   { field : 'acctLogin', 	title : '登陆账号',   width : 80, align : 'left' }, 
		   { field : 'userName', 	title : '用户姓名',   width : 80, align : 'left' },
		   { field : 'ip', 		    title : 'IP',	    width : 100, align : 'left' },
		   { field : 'url',     title : '访问地址', 	width : 250, align : 'left' },
		   { field : 'operateTime',   title : '操作时间', 	width : 150, align : 'left'},
		   { field : 'timeConsuming',  title : '耗时', 	width : 180, align : 'left' },
		   { field : 'operation', title : '操作描述',   width : 180, align : 'left'}
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#operateLogList').datagrid("clearChecked");
			//check the select row
			$('#operateLogList').datagrid("selectRow", index);
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
	var timeStart = $("#timeStart").textbox("getValue");
	var timeEnd = $("#timeEnd").textbox("getValue");
	$('#operateLogList').datagrid({
		queryParams : {
			userName : userName,
			acctLogin : acctLogin,
			timeStart : timeStart,
			timeEnd : timeEnd
		}
	});
}

/*************************** 格式化字段值 ***************************/
/**
 * 格式化是否封存节点
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function dateFormatter(val, row) {
	if (val != null && val !='') {
		return val.substr(0,val.length-2);
	}
}