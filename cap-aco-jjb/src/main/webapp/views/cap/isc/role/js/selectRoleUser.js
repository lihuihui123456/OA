$(function() {
	InitTreeData();
});

/**
 * 初始化加载左侧树
 */
var roleId = "";
function InitTreeData() {
	$('#role_tree').tree({
		url : 'roleController/findRoleListByLoginId',
		animate : true,
		checkbox : false,
		onlyLeafCheck : true,
		onClick : function(node) {
			roleId = node.id;
			if(roleId == "0"){
				return;
			}
			findUserListByRoleId();
		}
	});
}

/**
 * 按组织机构，查询条件加载用户列表信息
 * 
 * @param orgId 组织机构id
 */
function findUserListByRoleId() {
	var url = "roleUserController/findUserListByRoleId";
	$('#userList').datagrid({
		url : url,
		method : 'POST',
		idField : 'userId',
		striped : true,
		fitColumns : true,
		fit : true,
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		queryParams : {
			roleId : roleId
		},
		columns : [ [ 
 		    { field : 'ck', checkbox : true }, 
 		    { field : 'userId', title : 'userId', hidden : true }, 
 		    { field : 'acctLogin', title : '登录账号', width : 150, align : 'left' }, 
 		    { field : 'userName', title : '真实姓名', width : 150, align : 'left' }, 
 		    { field : 'userMobile', title : '手机', width : 150, align : 'left' } 
 		] ]
	});
}

function findByCondition() {
	var url = "roleUserController/findUserListByRoleId";
	$('#userList').datagrid({
		url : url,
		queryParams : {
			roleId : roleId,
			searchValue : $("#search").searchbox('getValue')
		},
	});
}

function clearSearchBox(){
	 $("#search").searchbox("setValue","");
}

function doSaveRoleUser(){
	var selecteds = $('#userList').datagrid('getSelections');
	
	var ids = '';
	var names = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].userId + ",";
		names = names + selecteds[index].userName + ",";
	});
	
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	if(names != ''){
		names = names.substring(0, names.length - 1);
	}
	var arr = [];
	arr[0]=ids;
	arr[1]=names;
	return arr;
}
function doSaveData(){
	var selecteds = $('#userList').datagrid('getSelections');
	
	var ids = '';
	var names = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].userId + ",";
		names = names + selecteds[index].userName + ",";
	});
	
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	if(names != ''){
		names = names.substring(0, names.length - 1);
	}
	var arr = [];
	arr[0]=ids;
	arr[1]=names;
	return arr;
}