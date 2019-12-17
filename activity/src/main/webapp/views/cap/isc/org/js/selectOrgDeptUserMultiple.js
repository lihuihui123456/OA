$(function() {
	InitTreeData();
	
	findUserListByOrgId("111","0","1");
	
});

var sel_userId = "";
/**
 * 初始化加载左侧树
 */
function InitTreeData() {
	$('#org_dept_tree').tree({
		url : 'orgController/findUnsealedChildOrgDeptTreeAsync',
		animate : true,
		checkbox : false,
		onlyLeafCheck : true,
		onClick : function(node) {
			//展开点击选中的节点
			$('#org_dept_tree').tree('expand', node.target)
			
			if (node.id == '1001') {
				return;
			}
			var dtype = node.dtype;
			var deptCode = "";
			if (dtype == "1") {
				deptCode = node.attributes.deptCode
			} else {
				deptCode = node.attributes.orgCode
			}
			$('#userList').datagrid('loadData', { total: 0, rows: [] });
			reload(node.attributes.orgId,node.dtype,deptCode);
		}
	});
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#org_dept_tree").tree('search',searchValue);
}

/**
 * 按组织机构，查询条件加载用户列表信息
 * 
 * @param orgId 组织机构id
 */
function findUserListByOrgId(orgId,dtype,deptCode) {
	var url = "authSetController/findUserListByOrgId";
	
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
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams : {
			orgId : orgId,
			dtype : dtype,
			deptCode : deptCode
		},
		columns : [ [ 
		    { field : 'ck', checkbox : true }, 
 		    { field : 'userId', title : 'userId', hidden : true }, 
 		    { field : 'acctLogin', title : '登录账号', width : 150, align : 'left' }, 
 		    { field : 'userName', title : '真实姓名', width : 150, align : 'left' } 
 		] ]
	});
}

function findByCondition() {
	var node = $('#org_dept_tree').tree('getSelected');
	var orgId = node.id;
	var dtype = node.dtype;
	
	var deptCode = "";
	if (dtype == "1") {
		deptCode = node.attributes.deptCode
	} else {
		deptCode = node.attributes.orgCode
	}
	var url = "authSetController/findUserListByOrgId";
	$('#userList').datagrid({
		url : url,
		queryParams : {
			orgId : orgId,
			dtype : dtype,
			deptCode : deptCode,
			searchValue : $("#search").searchbox('getValue')
		},
	});
}

/**
 * 重新加载列表
 */
function reload(orgId,dtype,deptCode) {
	
	$('#userList').datagrid('load', {
		orgId : orgId,
		dtype : dtype,
		deptCode : deptCode,
		searchValue : $("#search").searchbox('getValue')
	});
}

function clearSearchBox(){
	 $("#search").searchbox("setValue","");
	 $("#org_search").searchbox("setValue","");
}

function doSaveMessage(){
	var selecteds = $('#userList').datagrid('getChecked');
	
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

	var arr=new Array();
	arr[0]=ids;
	arr[1]=names;
	return arr;
}

function doSaveData(){
	var selecteds = $('#userList').datagrid('getChecked');
	
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

	var arr=new Array();
	arr[0]=ids;
	arr[1]=names;
	return arr;
}