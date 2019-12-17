$(function() {
	if (nameStr != null && nameStr != '') {
		var nameArr = nameStr.split(",");
		var idArr = idStr.split(",");
		var userId = "";
		var userName = "";
		for (var j = 0;j < idArr.length;j++) {
			userId = idArr[j];
			userName = nameArr[j];
			if (userId == '') {
				continue;
			}
			$("#content").append('<a id="'+userId+'">'+userName+'<span class="close_man" onclick="removeUser(\''+userId+'\',\''+userName+'\')">×</span></a>');
			ids += userId + ",";
			names += userName + ",";
		}
	}
	InitTreeData();
	findUserListByOrgId("111","0","1");
	
});

var sel_userId = "";
/**
 * 初始化加载左侧树
 */
function InitTreeData() {
	$('#org_dept_tree').tree({
		url : 'orgController/findUserOrgDeptTree?orgId='+orgId,
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
 		] ],
		 onCheck : function(index, row) {
				insertSelectData(row);
		},
		onUncheck : function(index, row) {
			var userId = row.userId;
			var userName = row.userName;
			removeUser(userId,userName);
		},
		onCheckAll : function(rows) {
			$(rows).each(function(index,row){
					insertSelectData(row);
			});
		},
		onUncheckAll : function(rows) {
			$(rows).each(function(index,row){
				removeUser(row.userId,row.userName);
				});
		},
		onLoadSuccess : function(data) {
			if (data!=null&&data.rows[0] != null) {
				if (idStr != null && idStr != '') {
					var idAttr = idStr.split(",");
					for(var i=0;i<data.rows.length;i++){
						for (var j = 0;j < idAttr.length;j++) {
							if(data.rows[i].userId == idAttr[j]){
								$('#userList').datagrid('selectRow',i);
							}
						}
					}
				}
            }
		},
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

var ids = '';
var names = '';
var cks = [];
var userIds = [];
function insertSelectData(row){
	var userId = row.userId;
	var userName = row.userName;
	if (ids.indexOf(userId) != -1) {
		return;
	}
	$("#content").append('<a id="'+userId+'">'+row.userName+'<span class="close_man" onclick="removeUser(\''+userId+'\',\''+userName+'\')">×</span></a>');
	ids += row.userId + ",";
	names += row.userName + ",";
	
	idStr += row.userId + ",";
	nameStr += row.userName + ",";
	
	if (isCon(userIds,userId)) {
		updateData(userId,"true");
	} else {
		userIds.push(row.userId);
		cks.push("true");
	}
}

function removeUser(userId,userName){
	if (ids.indexOf(userId) == -1) {
		return;
	}
	$("#"+userId).remove();
	

	ids = ids.replace(userId+",", "");
	names = names.replace(userName+",", "");

	idStr = idStr.replace(userId+",", "");
	nameStr = nameStr.replace(userName+",", "");
	
	var rows = $("#userList").datagrid('getData').rows;
    for (var i = 0; i < rows.length; i++) {    
        if (rows[i].userId == userId) {    
            $('#userList').datagrid('unselectRow',i);
            break;    
        }    
    }  
    
    if (isCon(userIds,userId)) {
		updateData(userId,"false");
	} else {
		userIds.push(userId);
		cks.push("false");
	}
}

function updateData(userId,type){
	for (var i = 0; i < userIds.length; i++) {
        if (userIds[i] == userId) {    
        	cks[i] = type;
            break;    
        }
    }
}

function doSaveData(){
	if (singleSelect) {
		return doSaveSingleData();
	} else {
		var arr = new Array();
		arr[0] = ids.substring(0,ids.length-1);
		arr[1] = names.substring(0,names.length-1);
		return arr;
	}
}

function doSaveUser(){
	$.ajax({
		url : 'userRefGroupController/doSaveUser',
		dataType : 'json',
		async : false,
		type : "POST",
		data : {userIds : userIds.toString(),cks : cks.toString(),userGroupId : userGroupId},
		success : function(result) {
			ids = [];
			cks = [];
			userIds = [];
			window.parent.closeUserDialog();
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});
}

function isCon(arr, val) {
	for (var i = 0; i < arr.length; i++) {
		if (arr[i] == val)
			return true;
	}
	return false;
}