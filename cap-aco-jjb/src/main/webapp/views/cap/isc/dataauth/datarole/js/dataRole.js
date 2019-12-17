$(function() {
	initOrgTree();
	initRoleList();
	//initUserListByOrgId();
});

var orgId = '';
var orgName = '';
var roleId = '';
/**
 * 初始化加载左侧树
 */
function initOrgTree() {
	$('#org_tree').tree({
		url : "orgController/findUnSealedChildrenNodesByIdUnderUserId",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		onClick : function(node) {
			orgId = node.id;
			orgName = node.text;
			// 点击某一注册系统时，加载对应系统下的模块
			$('#org_tree').tree('expand', node.target);
			$('#roleList').datagrid('clearChecked');
			//initRoleList();
			reload();
		}
		/*,
		onLoadSuccess : function (){
			$('#org_tree').tree('expandAll');
		}*/
	});
}

/**
 * 加载角色列表
 */
function initRoleList() {
	$('#roleList').datagrid({
		method : 'POST',
		idField : 'roleId',
		striped : true,
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams:{
			orgId : orgId
		},
		fitColumns : true,
		fit: true,
		singleSelect : true,
		selectOnCheck : true,
		checkOnSelect : true,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', checkbox : true }, 
		   { field : 'roleId', title : 'roleId', hidden : true }, 
		   { field : 'orgId',  title : 'orgId', hidden : true }, 
		   { field : 'roleName', title : '角色名称', width : 100, align : 'left' },
		   { field : 'roleDesc', title : '角色描述', width : 150, align : 'left'}
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#roleList').datagrid("clearChecked");
			//check the select row
			$('#roleList').datagrid("selectRow", index);
		}
	});
}

/**
 * 保存
 */
function doSaveRole() {
	var roleId = $("#roleId").val();
	if(!$('#roleForm').form('validate')){
		return;
	}
	
	var url = "";
	if (roleId == undefined || roleId == '') {
		url = "dataRoleController/doSaveDataRole";
	} else {
		url = "dataRoleController/doUpdateDataRole";
	}

	$("#orgId").val(orgId);
	$("#orgName").textbox("enable");
	$.ajax({
		url : url,
		type : "post",
		async : false,
		data : $('#roleForm').serialize(),
		success : function(data) {
			$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
			$('#roleDialog').dialog('close');
			reload();
			initdldata();
		}
	});
}

/**
 * 新增
 */
function openForm() {
	if (orgId == "") {
		//$.messager.alert('提示', '请选择单位！');
		layer.tips('请选择单位', '#btn_add', { tips: 3 });
		return;
	}
	initdldata();
	$('#roleDialog').dialog({
		title : '新增数据角色信息'
	});
	changeDesc();
	$('#roleDialog').dialog('open');
}

/**
 * 修改
 */
function openUpdateForm() {
	var data = $('#roleList').datagrid('getSelections');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！','info');
		layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行进行修改！','info');
			layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
			return;
		}
		var role = data[0];
		$("#roleId").val(role.roleId);
		$("#roleName").textbox('setValue',role.roleName);
		$("#roleDesc").textbox('setValue',role.roleDesc);
		$("#orgId").val(role.orgId);
		$("#orgName").textbox('setValue',orgName);
		$("#orgName").textbox("disable");

		$('#roleDialog').dialog({
			title : '修改数据角色信息'
		});
		changeDesc();
		$('#roleDialog').dialog("open");
	}
}

/**
 * 删除
 */
function doDeleteRole() {
	var selecteds = $('#roleList').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择操作项！','info');
		layer.tips('请选择操作项', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除角色', '确定删除吗?', function(r) {
		if (r) {
			var id = selecteds[0].roleId;
			$.ajax({
				url : 'dataRoleController/doDeleteDataRole',
				dataType : 'json',
				async : false,
				data : {id : id},
				success : function(result) {
					if (result.status == '200') {
						$.messager.show({ title:'提示', msg:result.msg, showType:'slide' });
						reload();
						$('#roleList').datagrid('clearSelections'); // 清空选中的行
					} else {
						$.messager.show({ title:'提示', msg:result.msg, showType:'slide' });
					}
				},
				error : function(result) {
					$.messager.alert('提示', "删除失败！",'error');
				}
			});
		}
	});
}

/**
 * 重新加载列表
 */
function reload() {
	var url = 'dataRoleController/findByCondition';
	$('#roleList').datagrid({
		url : url,
		queryParams:{
			orgId : orgId
		}
	});
}

/**
 * 初始化dialog清空数据
 */
function initdldata() {
	$("#roleId").val("");
	$("#roleName").textbox('setValue',"");
	$("#roleDesc").textbox('setValue',"");
	$("#orgId").val(orgId);
	$("#orgName").textbox('setValue',orgName);
	$("#orgName").textbox("disable");
}

/**
 * 条件查询
 */
function findByCondition(){
	var roleName = $("#search").searchbox('getValue');
	$('#roleList').datagrid({
        url:"dataRoleController/findByCondition",
        queryParams:{
        	orgId : orgId,
        	roleName : roleName
        }
    });
}

function clearSearchBox(){
	$("#search").searchbox("setValue","");
	$("#org_search").searchbox("setValue","");
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#org_tree").tree('search',searchValue);
}

/**
 * 打开数据规则列表弹出框
 */
function openRuleListDl(){
	var data = $('#roleList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择角色！','info');
		layer.tips('请选择角色', '#btn_rule', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行进行规则定义！','info');
			layer.tips('请选择一行进行规则定义', '#btn_rule', { tips: 3 });
			return;
		}
		var role = data[0];
		roleId = data[0].roleId;
		initRuleList();
		$('#ruleListDialog').dialog("open");
	}
}

/**
 * 初始化规则列表
 */
function initRuleList(){
	$('#ruleList').datagrid({
		method : 'POST',
		url : 'dataRuleController/findByCondition',
		idField : 'ruleId',
		striped : true,
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams:{
			roleId : roleId
		},
		fitColumns : true,
		fit: true,
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#ruleToolBar',
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', checkbox : true }, 
		   { field : 'ruleId', title : 'ruleId', hidden : true }, 
		   { field : 'roleId', title : 'roleId', hidden : true }, 
		   { field : 'ruleName', title : '规则名称', width : 100, align : 'left' },
		   { field : 'ruleCode', title : '规则编码', width : 150, align : 'left'},
		   { field : 'resName',  title : '资源名称', width : 150, align : 'left'},
		   { field : 'resCode',  title : '资源编码', width : 150, align : 'left'}
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#ruleList').datagrid("clearChecked");
			//check the select row
			$('#ruleList').datagrid("selectRow", index);
		}
	});
}

/**
 * 监控名称的改变，描述跟着改变
 */
function changeDesc(){
    $('#roleName').textbox({
        onChange: function(value){ 
            var roleName = $("#roleName").textbox("getValue");
            $("#roleDesc").textbox("setValue",roleName);
        }
      });  
}