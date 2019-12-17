$(function() {
	initTree();
	getListdata();
});

/**
 * 初始化加载左侧树
 */
function initTree() {
	$('#dataSource').tree({
		url : "luceneRoleController/findDataSourceIndexTree",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		onClick : function(node) {
			// 点击某一注册系统时，加载对应系统下的模块
			$('#dataSource').tree('expand', node.target);
			sid = node.id;
			reload(node.id);
			//$('#roleList').datagrid('clearChecked');
		}
	});
}

function getListdata() {
	$('#tb1').datagrid({
		//url : 'luceneRoleController/getrolelistbysid?sid=' + sid,
		method : 'POST',
		idField : 'id',
		striped : true,
		fit : true,
		fitColumns : true,
		singleSelect : true,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolbar1',
		showFooter : true,
		columns : [ [ {
			field : 'ck',
			checkbox : true
		}, {
			field : 'id',
			title : 'id',
			hidden : true
		}, {
			field : 'sel_id',
			title : '数据库id',
			hidden : true
		}, {
			field : 'role_user_id',
			title : '用户id字段',
			width : 80,
			align : 'center'
		}, {
			field : 'role_user_code',
			title : '用户编码字段',
			width : 80,
			align : 'center'
		}, {
			field : 'role_condition',
			title : '查询条件字段',
			width : 80,
			align : 'center'
		}, {
			field : 'role_sql',
			title : '查询语句',
			width : 80,
			align : 'center'
		} ] ]
	});
}
var temp = "";

/**
 * 重新加载接口类型树
 */
function reload(sid) {
	$('#tb1').datagrid({
		url : 'luceneRoleController/getrolelistbysid',
		queryParams : {
			'sid' : sid
		}
	});
	$('#tb1').datagrid('clearSelections'); // 清空选中的行
	$('#tb1').datagrid('clearChecked'); // 清空选中的行
}

/**
 * 弹出新增sql信息页面
 */
function savesqls() {
	var node = $('#dataSource').tree('getSelected');
	if (node == null || node.id == '' || node.dtype != '2') {
		//$.messager.alert('提示', '请选择索引类型！');
		layer.tips('请选择索引类型', '#btn_add', { tips: 3 });
		return;
	}
	clearData();
	$('#add_sql_dialog').dialog({
		title : "添加sql语句"
	});
	$('#add_sql_dialog').dialog("open");
	id = "";
}
/**
 * 弹出修改sql信息页面
 */
var id = "";
function updatesql() {
	var data = $('#tb1').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('修改接口数据', '请选择一行进行修改！');
		layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('修改接口数据', '请选择一行进行修改！');
			layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
			return;
		}
		id = data[0].id;
		var userid = data[0].role_user_id;
		var usercode = data[0].role_user_code;
		var condition = data[0].role_condition;
		var sql = data[0].role_sql;
		$('#add_sqls_form').form('clear');
		$("#userid").textbox('setValue', userid);
		$("#usercode").textbox('setValue', usercode);
		$("#condition").textbox('setValue', condition);
		$("#sql").textbox('setValue', sql);
		$('#add_sql_dialog').dialog({
			title : "修改sql语句"
		});
		$('#add_sql_dialog').dialog("open");
	}
}

/**
 * 删除接口信息
 */
function deleteInfo() {
	var selecteds = $('#tb1').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('删除数据库数据', '请选择操作项！');
		layer.tips('请选择操作项', '#btn_edit', { tips: 3 });
		return;
	}
	$.messager.confirm('删除数据库数据', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].id + ",";
			});
			ids = ids.substring(0, ids.length - 1);
			$.ajax({
				url : 'luceneRoleController/delRoleById',
				type : "POST",
				data : {
					id : ids
				},
				success : function(result) {
					var msg = result;
					$.messager.show({
						title : '提示',
						msg : '删除成功',
						showType : 'slide'
					});
					reload(sid);
				},
				error : function(result) {
					$.messager.show({
						title : '提示',
						msg : '删除失败',
						showType : 'slide'
					});
				}
			});
		}
	});
}
function clearData() {
	$("#userid").textbox('setValue', "");
	$("#usercode").textbox('setValue', "");
	$("#condition").textbox('setValue', "");
	$("#sql").textbox('setValue', "");
}
/**
 * 保存修改sql 语句
 * 
 * @returns
 */
function doSaveSqlInfo() {
	if (!$('#add_sqls_form').form('validate')) {
		return;
	}
	if (!checkForm()){
		return;
	}
	var userid = $("#userid").textbox('getValue');
	var usercode = $("#usercode").textbox('getValue');
	var condition = $("#condition").textbox('getValue');
	var sql = $("#sql").textbox('getValue');
	AjaxURL = "luceneRoleController/saveRole";
	$.ajax({
		type : "POST",
		url : AjaxURL,
		async : false,
		data : {
			id : id,
			selid : sid,
			role_userid : userid,
			role_usercode : usercode,
			role_condition : condition,
			role_sql : sql
		},
		success : function(data) {
			$.messager.show({
				title : '提示',
				msg : '保存成功',
				showType : 'slide'
			});
			$('#add_sql_dialog').dialog('close');
			reload(sid);
		},
		error : function(data) {
			$.messager.show({
				title : '提示',
				msg : '保存失败',
				showType : 'slide'
			});
		}
	});
}
function CheckSql() {
	var sql = $("#sql").textbox('getValue');
	
	if(sql.search("where") != -1){
		var index = sql.indexOf("where");
		sql = sql.substring(0,index-1);
	}
	$.ajax({
		type : "POST",
		url : "luceneRoleController/checkSql",
		async : false,
		data : {
			selid : sid,
			role_sql : sql
		},
		success: function (data) {
		     if(data=='测试成功'){
		     $.messager.alert('检查sql', "sql语句正确！");
		     }else{
		     $.messager.alert('检查sql', "sql语句错误！");
		     }
		}
	});
}
$.extend($.fn.textbox.defaults.rules, {
	checkUrl : {
		validator : function(value) {
			var falg = 1;
			for (var i = 0; i < value.length; i++) {
				if (value.charCodeAt(i) > 255) {
					falg = 0;
				}
			}
			if (falg == 0) {
				return false;
			} else {
				return true;
			}
		},
		message : 'URL格式不正确'
	},
	checkName : {
		validator : function(value) {
			var reg = /^\w+$/;
			if (reg.test(value)) {
				return true;
			} else {
				return false;
			}
		},
		message : '非法字符输入'
	}
});
function checkForm(){
	var sql = $("#sql").textbox('getValue');
	if(sql==""){
		$.messager.alert('添加索引', '输入完整sql语句');
		$("#sql").focus();
		return false;
	}else{
		var userid = $("#userid").textbox('getValue');
		if(sql.indexOf(userid)<0){
			$.messager.alert('添加索引', '用户id错误');
				$("#userid").focus();
				return false;
		}
		var usercode = $("#usercode").textbox('getValue');
		if(sql.indexOf(usercode)<0){
			$.messager.alert('添加索引', '用户编码错误');
				$("#usercode").focus();
				return false;
		}
		return true;
	}
}