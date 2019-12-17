var operatorFlag = 'save';
$(function() {
	initOrgTreeList();
	findUserGroupList();
});

/**
 * 全局变量
 * 用户组ID ：userGroupId
 * */
var userGroupId = "";
var orgId = '111';

/**
 * 初始化加载左侧树
 * @author 王建坤
 */
function initOrgTreeList() {
	$('#org_tree_list').tree({
		url : "orgController/findUnSealedChildrenNodesByIdUnderUserId",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		onClick : function(node) {
			orgId = node.id;
			orgName = node.text;
			// 点击某一注册系统时，加载对应系统下的模块
			$('#org_tree_list').tree('expand', node.target);
			$('#userGroupList').datagrid('clearChecked');
			findUserGroupList();
		}
		/*,
		onLoadSuccess : function (){
			$('#org_tree').tree('expandAll');
		}*/
	});
}

/**
 * 单位查询
 * @author 王建坤
 * */
function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#org_tree_list").tree('search',searchValue);
}

/**
 * 清空单位查询框
 * @author 王建坤
 * */
function clearOrgSearchBox(){
	$("#search").searchbox("setValue","");
	$("#org_search").searchbox("setValue","");
}

/**
 * 初始化用户组信息编辑对话框 初始化面板 初始化数据
 */
function initUserGroupDlg(title) {
	$('#userGroupDlg').dialog({
		title : title
	});
	changeDesc();
	$('#userGroupDlg').dialog("open");
	$('#userGroupForm').form('clear');
	$("#org_id").val(orgId);
	if( operatorFlag == 'save' ) {
//		$(":radio[value=N]").attr("checked","checked");
		$("#user_group_code").removeAttr("disabled");
	}
}
function closeUserGroupDlg() {
	$('#depuserGroupm').form('clear');
	$('#userGroupDlg').dialog("close");
}
/**
 * 添加用户组对话框弹出
 */
function doAddUserGroupBefore() {
	var node = $('#org_tree_list').tree('getSelected');
	if(node == null){
		//$.messager.alert('提示', '请选择所属单位！', 'info');
		layer.tips('请选择所属单位', '#btn_add', { tips: 3 });
		return ;
	}
	operatorFlag = 'save';
	initUserGroupDlg("新增用户组");
}
/**
 * 添加修改用户组保存方法
 */
function doSaveOrUpdateUserGroup() {
	var url = "";
	if (operatorFlag == 'save') {
		url = "userGroupController/doSaveUserGroup";
	} else {
		$("#user_group_code").removeAttr("disabled");
		url = "userGroupController/doUpdateUserGroup";
	}
	$.ajax({
		url : url,
		type : "post",
		async : false,
		data : $('#userGroupForm').serialize(),
		beforeSend : function() {
			$('input.easyui-validatebox').validatebox('enableValidation');
			return $('#userGroupForm').form('validate');
		},
		success : function(data) {
			if (operatorFlag == 'save') {
				if(data){
					$.messager.show({ title:'提示', msg:'添加成功', showType:'slide' });
				}else{
					$.messager.alert('提示', '添加失败','info');
				}
			} else {
				if(data){
					$.messager.show({ title:'提示', msg:'修改成功', showType:'slide' });
				}else{
					$.messager.alert('提示', '修改失败','info');
				}
			}
			$('#userGroupDlg').dialog('close');
			findUserGroupList();
			$('#userGroupList').datagrid('clearSelections'); // 清空选中的行
		}
	});
}
/**
 * 修改对话框弹出
 */
function doUpdateUserGroupBefore() {
	operatorFlag = 'update';
	var data = $('#userGroupList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！','info');
		layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示', '请选择一行进行修改！','info');
		return;
	}
	var userId = data[0].userGroupId;
	$.ajax({
		url : 'userGroupController/findUserGroupById',
		dataType : 'json',
		data : {
			id : userId
		},
		success : function(userGroup) {
			if (userGroup != null) {
				initUserGroupDlg("修改用户组");
				$("#org_id").val(userGroup.orgId);
				$("#user_group_id").val(userGroup.userGroupId);
				$("#user_group_code").val(userGroup.userGroupCode);
				$("#user_group_name").val(userGroup.userGroupName);
//				$(":radio[value=" + userGroup.isSeal + "]").attr("checked","checked");
				$("#user_group_desc").textbox("setValue",userGroup.userGroupDesc);
				$("#userGroupForm").form('validate');
				$("#user_group_code").attr("disabled","disabled");
			}
		},
		error : function(result) {
			$.messager.alert('提示', "修改失败！",'error');
		}
	});
}
/**
 * 删除用户组
 */
function doDeleteUserGroup() {
	var selecteds = $('#userGroupList').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择操作项！','info');
		layer.tips('请选择操作项', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除用户组', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].userGroupId + ",";
			});

			ids = ids.substring(0, ids.length - 1);
			$.ajax({
				url : 'userGroupController/doDeleteUserGroup',
				dataType : 'json',
				async : false,
				data : {
					ids : ids
				},
				success : function(result) {
					$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
					findUserGroupList();
					$('#userGroupList').datagrid('clearSelections'); // 清空选中的行
				},
				error : function(result) {
					$.messager.alert('提示', "删除失败！",'info');
				}
			});
		}
	});
}
/**
 * 查询用户组列表
 * 
 */
function findUserGroupList() {
	var url = "userGroupController/findByCondition";
	$('#userGroupList').datagrid({
		url : url,
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		method : 'POST',
		idField : 'userGroupId',
		striped : true,
		queryParams:{
			orgId : orgId
		},
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		fit: true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		columns : [ [ 
 		    { field : 'ck', checkbox : true }, 
 		    { field : 'userGroupId', title : '用户组ID', hidden:true }, 
 		    { field : 'userGroupName', title : '用户组名称', width : 150, align : 'left' }, 
 		    { field : 'userGroupCode', title : '用户组编码', width : 150, align : 'left' }, 
 		    { field : 'userGroupDesc', title : '用户组描述', width : 150, align : 'left' },
// 		    { field : 'isSeal', title : '是否封存', width : 150, align : 'left',
// 		    	formatter:function(value,row){
// 		    		if(value == 'Y'){
// 		    			return "是";
// 		    		}else{
// 		    			return "否";
// 		    		}
// 		    	}
// 		    },
 		    { field : 'createTime', title : '创建时间', width : 150, align : 'left' ,
 		    	formatter:function(value,row){
 		    		return value.substring(0,19);
 		    	}
 		    }
 		] ],
		onBeforeLoad : function(param) {
		},
		onClickRow: function(index,row){
			//cancel all select
			$('#userGroupList').datagrid("clearChecked");
			//check the select row
			$('#userGroupList').datagrid("checkRow", index);
		}
	});
}

function closeUserDialog(){
	$.messager.show({ title:'提示', msg:'保存成功！', showType:'slide' });
	$('#userGroupDialog').dialog('close');
}

/**
 * 条件查询
 */
function findByCondition() {
	$('#userGroupList').datagrid({
		url : "userGroupController/findByCondition",
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams : {
			searchValue : $("#search").searchbox('getValue'),
			orgId : orgId
		}
	});
	$('#userGroupList').datagrid('clearSelections'); // 清空选中的行
}
function validExist(){
	var userGroupCode = $.trim($("#user_group_code").val());
	if(userGroupCode==''){
		return;
	}
	$.ajax({
		url : 'userGroupController/findUserGroupByCode',
		dataType : 'json',
		data : {
			code : userGroupCode
		},
		success : function(result) {
			if(result){
				if(result.userGroupId && result.userGroupId!=''){
					$.messager.alert('提示', "用户组代码已存在！",'info');
					$("#user_group_code").val("");
					$("#userGroupForm").form('validate');
				}
			}
		},
		error : function(result) {
			$.messager.alert('提示', "用户组代码验证失败！",'error');
		}
	});
}
/**
 * 用户组关联用户
 */
function doUserGroupResUser(){
	var data = $('#userGroupList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行操作！','info');
		layer.tips('请选择操作项', '#btn_user', { tips: 3 });
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示', '请选择一行进行操作！','info');
		return;
	}
	userGroupId = data[0].userGroupId;
	
	var url = "userGroupController/selectAllOrgDeptUser?userGroupId="+ userGroupId+'&orgId='+orgId;
	$('#commonAddFrame').attr('src', url);
	
	userGroupId = data[0].userGroupId;
	$("#userGroupSearch").searchbox("setValue","");
	$("#userGroupDialog").dialog('open');
	//清空用户列表
	clearUserList();
	//组织机构树
	findUserListByOrgId();
	//parent.addTab('用户组关联用户','userRefGroupController/userRefGroupList?userGroupId='+data[0].userGroupId);
}
/**
 * 用户组关联角色
 */
function doUserGroupResRole(){
	var data = $('#userGroupList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行操作！','info');
		layer.tips('请选择操作项', '#btn_role', { tips: 3 });
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示', '请选择一行进行操作！','info');
		return;
	}
	userGroupId = data[0].userGroupId;
	bindLeftSearch();
	initUserGroups();
	loadRoleList();
	$("#roleGroupDialog").dialog('open');
	//parent.addTab('用户组关联角色','userGroupRefRoleController/userGroupRefRoleList?userGroupId='+data[0].userGroupId);
}
function clearSearchBox(){
	 $("#search").searchbox("setValue","");
	 $("#userGroupSearch").searchbox("setValue","");
}

/**
 * 打开关联角色窗口
 * 
 * @author 王建坤
 * @param
 * @return
 * */
function openCroupResRoleDlg(){
	var node = $('#org_tree_list').tree('getSelected');
	if(node == null){
		//$.messager.alert('提示', '请选择所属单位！', 'info');
		layer.tips('请选择所属单位', '#btn_role', { tips: 3 });
		return ;
	}
	orgId = node.id;
	var nodes = $('#userGroupList').treegrid('getChecked');
	if(nodes == null||nodes.length != 1){
		//$.messager.alert('提示', '请选择一行进行操作！', 'info');
		layer.tips('请选择一行进行操作', '#btn_role', { tips: 3 });
		return;
	}
	userGroupId = nodes[0].userGroupId;
	
	initSelectRole(orgId,userGroupId);
	$('#roleDialog').dialog('open');
}

/**
 * 初始化关联角色窗口信息
 * 
 * @author 王建坤
 * @param orgId 单位ID
 * @param userGroupId 用户组ID
 * */
function initSelectRole(orgId,userGroupId){
	$.ajax({
		url : 'userGroupController/initSelectRole',
		dataType : 'text',
		data : {
			orgId : orgId,
			userGroupId : userGroupId
		},
		success : function(data) {
			var result = eval("("+data+")").rows;
			//$('#tb1').datagrid('loadData',result);
			var sel1 = [];//未选择角色数组
			var sel2 = [];//已选择角色数组
			var i = 0;
			var j = 0;
			$.each(result, function(index, item) {
				if(result[index].checked){
					sel2[i] = result[index];
					i++;
				}else{
					sel1[j] = result[index];
					j++;
				}
				//option = "<option value='"+result[index].roleId+"'>"+result[index].roleName+"</option>";
			});
			$('#tb1').datagrid('loadData',sel1);
			$('#tb2').datagrid('loadData',sel2);
		},
		error : function(result) {
			$.messager.show({ title:'提示', msg:'执行失败', showType:'slide' });
		}
	});
}

/**
 * 保存用户组角色关联
 * @author 王建坤
 * */
function doSaveRole(){
	var rows = $("#tb2").datagrid("getRows");
	var ids = '';
	$(rows).each(function(index) {
		ids = ids + rows[index].roleId + ",";
	});
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	
	$.ajax({
		url : 'userGroupController/doSaveSelectRole',
		dataType : 'json',
		async : false,
		data : {roleIds : ids,userGroupId : userGroupId},
		success : function(result) {
			var msg = result;
			$('#roleDialog').dialog('close');
			$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
			//reloadRoleList(userId);
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});
}

/**
 * 添加角色，右移
 * */
function add(obj) {
	var data = $('#tb1').datagrid('getSelections');
	if (data) {
		$(data).each(function(index) {
			$('#tb2').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
			
			var rowIndex = $('#tb1').datagrid('getRowIndex', data[index]);
	        $('#tb1').datagrid('deleteRow', rowIndex);
		});
	}
}

/**
 * 添加所有，右移
 * @author 王建坤
 * */
function addAll(obj) {
	var data = $('#tb1').datagrid('getRows');
	if (data) {
		$(data).each(function(index) {
			$('#tb2').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
		});
		$('#tb1').datagrid('loadData',[]);
	}
}

/**
 * 删除角色
 * */
function del(obj) {
	var data = $('#tb2').datagrid('getSelections');
	if (data) {
		$(data).each(function(index) {
			$('#tb1').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
			
			var rowIndex = $('#tb2').datagrid('getRowIndex', data[index]);
	        $('#tb2').datagrid('deleteRow', rowIndex);
		});
	}
}

/**
 * 删除全部角色
 * */
function delAll(obj) {
	var data = $('#tb2').datagrid('getRows');
	if (data) {
		$(data).each(function(index) {
			$('#tb1').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
		});
		$('#tb2').datagrid('loadData',[]);
	}
}

/**
 * 监控名称的改变，描述跟着改变
 */
function changeDesc(){
    $('#user_group_name').textbox({
        onChange: function(value){ 
            var user_group_name = $("#user_group_name").textbox("getValue");
            $("#user_group_desc").textbox("setValue",user_group_name);
        }
      });  
}