
/**
 * 按组织机构，查询条件加载用户列表信息
 * 
 * @param orgId 组织机构id
 */
function findUserListByOrgId() {
	var url = "roleUserController/findByCondition";
	$('#userList').datagrid({
		url : url,
		method : 'POST',
		idField : 'userId',
		toolbar : '#toolBar1',
		striped : true,
		fitColumns : true,
		selectOnCheck : true,
		checkOnSelect : true,
		fit : true,
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		pageSize : 10,
		showFooter : true,
		queryParams : {
			orgId : orgId,
			roleId : roleId
		},
		columns : [ [ 
 		    { field : 'ck', checkbox : true }, 
 		    { field : 'userId', title : 'userId', hidden : true }, 
 		    { field : 'acctLogin', title : '登录账号', width : 150, align : 'left' }, 
 		    { field : 'userName', title : '真实姓名', width : 150, align : 'left' }, 
 		    { field : 'deptName', title : '所属部门', width : 150, align : 'left' } 
 		] ],
		onBeforeLoad : function(param) {
		},
		onLoadSuccess : function(data) {
			if (data!=null&&data.rows[0] != null) {
				for(var i=0;i<data.rows.length;i++){
					if(data.rows[i].checked==true){
						 $('#userList').datagrid('selectRow',i);
					}
				}
            }
		},
		onLoadError : function() {

		},
		onClickCell : function(rowIndex, field, value) {

		},
		onCheck : function(index, row) {
			insertSelectData(row);
		},
		onUncheck : function(index, row) {
			var userId = row.userId;
			removeUser(userId);
		},
		onCheckAll : function(rows) {
			$(rows).each(function(index,row){
				insertSelectData(row);
			});
		},
		onUncheckAll : function(rows) {
			$(rows).each(function(index,row){
				removeUser(row.userId);
			});
		}
	});
}

var ids = [];
var cks = [];
function insertSelectData(row){
	var userId = row.userId;
	if (isCon(ids,userId)) {
		updateData(userId,"true");
	} else {
		ids.push(row.userId);
		cks.push("true");
	}
}

function removeUser(userId){
	if (isCon(ids,userId)) {
		updateData(userId,"false");
	} else {
		ids.push(userId);
		cks.push("false");
	}
}

function updateData(userId,type){
	for (var i = 0; i < ids.length; i++) {
        if (ids[i] == userId) {    
        	cks[i] = type;
            break;    
        }
    }
}

function findByCondition1() {
	//var url = "roleUserController/findByCondition";
	
	reloadRoleUser();
	/*$('#userList').datagrid({
		url : url,
		queryParams : {
			orgId : orgId,
			roleId : roleId,
			searchValue : $("#search1").searchbox('getValue')
		},
	});*/
}

function doSaveRoleUser(){
	window.frames["commonAddFrame"].doSaveRoleUser();
}

function clearSearchBox1(){
	 $("#search1").searchbox("setValue","");
}

/**
 * 重新加载列表
 */
function reloadRoleUser() {
	
	$('#userList').datagrid('load', {
		orgId : orgId,
		roleId : roleId,
		searchValue : $("#search1").searchbox('getValue')
	});
}

function isCon(arr, val) {
	for (var i = 0; i < arr.length; i++) {
		if (arr[i] == val)
			return true;
	}
	return false;
}