$(function() {
	initOrgTree();
	initRoleList();
	findUserListByOrgId();
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
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', checkbox : true }, 
		   { field : 'roleId', title : 'roleId', hidden : true }, 
		   { field : 'roleName', title : '角色名称', width : 100, align : 'left' },
		   { field : 'roleEname', title : '角色英文名', width : 100, align : 'left' },
		   { field : 'roleCode', title : '角色编码', width : 80, align : 'left' },
		   { field : 'createTime', title : '创建时间', width : 120, align : 'left' },
		   { field : 'roleDesc', title : '角色描述', width : 150, align : 'left'},
		   { field : 'operate', title : '操作', width : 70, align : 'center', formatter : formatOperate }
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
 * 格式化上移下级操作
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatOperate(val, row) {
	var id = row.roleId;
	return '<img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/up.png" onclick="doUpSort(\''+id+'\')"/>'
		  +'&nbsp;&nbsp;<img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/down.png" onclick="doDownSort(\''+id+'\')" />';
}

/**
 * 保存
 */
function doSaveRole() {
	
	if(!$('#roleForm').form('validate')){
		return;
	}
	
	var url = "";
	if (roleId == undefined || roleId == '') {
		url = "roleController/doSaveRole";
	} else {
		url = "roleController/doUpdateRole";
	}

	$("#orgId").val(orgId);
	$.ajax({
		url : url,
		type : "post",
		async : false,
		data : $('#roleForm').serialize(),
		success : function(data) {
			/*if (roleId == undefined || roleId == '') {
				$.messager.show({ title:'提示', msg:data, showType:'slide' });
			} else {
				$.messager.show({ title:'提示', msg:data, showType:'slide' });
			}*/
			
			if (data.state == '1') {
				$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
			} else {
				$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
				$('#roleDialog').dialog('close');
				reload();
				initdldata();
			}
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
	roleId = '';
	initdldata();
	changeDesc();
	$('#roleDialog').dialog('open');
}

/**
 * 修改
 */
function openUpdateForm() {
	initdldata();
	var data = $('#roleList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！','info');
		layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '请选择一行进行修改！','info');
			return;
		}
		var role = data[0];
		roleId = data[0].roleId;
		$("#roleName").textbox('setValue',role.roleName);
		$("#roleEname").textbox('setValue',role.roleEname);
		$("#roleCode").textbox('setValue',role.roleCode);
		$("#roleDesc").textbox('setValue',role.roleDesc);
		//$("#orgId").textbox('setValue',role.orgId);
		$("#orgName").textbox('setValue',orgName);
		$("#roleId").val(roleId);
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
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].roleId + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'roleController/doDeleteRole',
				dataType : 'json',
				async : false,
				data : {ids : ids},
				success : function(result) {
					var msg = result;
					$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
					reload();
					$('#roleList').datagrid('clearSelections'); // 清空选中的行
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
	var url = 'roleController/findByCondition';
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
	$("#roleName").textbox('setValue',"");
	$("#roleEname").textbox('setValue',"");
	$("#roleCode").textbox('setValue',"");
	$("#roleDesc").textbox('setValue',"");
	//$("#orgId").textbox('setValue',"");
	$("#orgName").textbox('setValue',orgName);
}

/**
 * 条件查询
 */
function findByCondition(){
	var roleName = $("#search").searchbox('getValue');
	$('#roleList').datagrid({
        url:"roleController/findByCondition",
        queryParams:{
        	orgId : orgId,
        	roleName : roleName,
        	date:new Date()
        }
    });
}

/**
 * 上移操作
 */
function doUpSort(roleId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$.ajax({
		url : 'roleController/doUpSort',
		dataType : 'json',
		async : false,
		data : {id : roleId,orgId : orgId},
		success : function(result) {
			reload();
		},
		error : function(result) {
		}
	});
}

/**
 * 下移操作
 */
function doDownSort(roleId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$.ajax({
		url : 'roleController/doDownSort',
		dataType : 'json',
		async : false,
		data : {id : roleId,orgId : orgId},
		success : function(result) {
			reload();
		},
		error : function(result) {
		}
	});
}

/**
 * 分配用户
 */
function addRoleUser(){
	var data = $('#roleList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一个角色进行添加！','info');
		layer.tips('请选择一个角色进行操作', '#btn_user', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '只能选择单个角色进行操作！','info');
			return;
		}
		roleId = data[0].roleId;
	}
	url = "roleUserController/selectAllOrgDeptUser?roleId="+ roleId+'&orgId='+orgId;

	$('#commonAddFrame').attr('src', url);
	
	$('#userList').datagrid('loadData',{total:0,rows:[]});
	$("#search1").searchbox("setValue","");
	$('#userList').datagrid('clearChecked');
	reloadRoleUser();
	//window.parent.addTab("关联用户","roleUserController/roleUserList?roleId="+v_roleId+"&orgId="+orgId);
	$('#roleUserDialog').dialog('open');
}

function closeUserDialog(){
	$.messager.show({ title:'提示', msg:'保存成功！', showType:'slide' });
	$('#roleUserDialog').dialog('close');
}
/**
 * 角色授权
 */
function addRoleMenu(){
	var data = $('#roleList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一个角色进行添加！','info');
		layer.tips('请选择一个角色进行操作', '#btn_perm', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '只能选择单个角色进行操作！','info');
			return;
		}
		roleId = data[0].roleId;
	}
	
	$('#menu_tree li').remove();
	initSysRegTree();
	$('#roleMenuDialog').dialog('open');
	//window.parent.addTab("角色授权","roleMenuController/roleMenu?roleId="+v_roleId);
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