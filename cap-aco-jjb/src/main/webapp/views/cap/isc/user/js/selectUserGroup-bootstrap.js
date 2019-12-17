$(function() {
	findUserGroupList();
});

/**
 * 查询用户组列表
 * 
 */
function findUserGroupList() {
	var url = "userGroupController/findByCondition-bootstrap";
	$('#userGroupList').datagrid({
		url : url,
		method : 'POST',
		idField : 'userGroupId',
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
		columns : [ [ 
 		    { field : 'ck', checkbox : true }, 
 		    { field : 'userGroupCode', title : '用户组编码', width : 150, align : 'left' }, 
 		    { field : 'userGroupName', title : '用户组名称', width : 150, align : 'left' }, 
 		    { field : 'userGroupDesc', title : '用户组描述', width : 150, align : 'left' },
 		    { field : 'createTime', title : '创建时间', width : 150, align : 'left' ,
 		    	formatter:function(value,row){
 		    		return value.substring(0,19);
 		    	}
 		    }
 		] ]
	});
}

function findByCondition() {
	var url = "userGroupController/findByCondition-bootstrap";
	$('#userGroupList').datagrid({
		url : url,
		queryParams : {
			searchValue : $("#search").searchbox('getValue')
		},
	});
}

function clearSearchBox(){
	 $("#search").searchbox("setValue","");
}

function doSaveRoleUser(){
	var selecteds = $('#userGroupList').datagrid('getSelections');
	
	var ids = '';
	var names = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].userGroupId + ",";
		names = names + selecteds[index].userGroupName + ",";
	});
	
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	if(names != ''){
		names = names.substring(0, names.length - 1);
	}

	var arr=[];
	arr[0]=ids;
	arr[1]=names;
	return arr;
}
function doSaveData(){
	var selecteds = $('#userGroupList').datagrid('getSelections');
	
	var ids = '';
	var names = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].userGroupId + ",";
		names = names + selecteds[index].userGroupName + ",";
	});
	
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	if(names != ''){
		names = names.substring(0, names.length - 1);
	}

	var arr=[];
	arr[0]=ids;
	arr[1]=names;
	return arr;
}