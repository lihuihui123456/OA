$(function() {
	InitTreeData();
	
	findUserListByOrgId("111","0","1");
});

/**
 * 初始化加载左侧树
 */
function InitTreeData() {
	$('#org_dept_post_tree').tree({
		url : 'orgController/findUnsealedChildOrgDeptPostTreeAsync',
		animate : true,
		checkbox : false,
		onlyLeafCheck : true,
		onClick : function(node) {
			
			findUserListByOrgId();
		}
	});
}

/**
 * 按组织机构，查询条件加载用户列表信息
 * 
 * @param orgId 组织机构id
 */
function findUserListByOrgId() {
	var node = $('#org_dept_post_tree').tree('getSelected');
	var orgId = node.id;
	var dtype = node.dtype;
	var	url = "orgController/findUserListByOrgId";
	
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
			orgId : orgId,
			dtype : dtype
		},
		columns : [ [ 
 		    { field : 'ck', checkbox : true }, 
 		    { field : 'userId', title : 'userId', hidden : true }, 
 		    { field : 'acctLogin', title : '登录账号', width : 150, align : 'left' }, 
 		    { field : 'userName', title : '真实姓名', width : 150, align : 'left' } 
 		    /*{ field : 'userMobile', title : '手机', width : 150, align : 'left' } */
 		] ]
	});
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#org_dept_post_tree").tree('search',searchValue);
}

function findByCondition() {
	var node = $('#org_dept_post_tree').tree('getSelected');
	var orgId = node.id;
	var dtype = node.dtype;
	var url = "orgController/findUserListByOrgId";
	$('#userList').datagrid({
		url : url,
		queryParams : {
			orgId : orgId,
			dtype : dtype,
			searchValue : $("#search").searchbox('getValue')
		},
	});
}

function clearSearchBox(){
	 $("#search").searchbox("setValue","");
}

function doSaveSelectUser(){
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

	alert(ids);
	alert(names);
}