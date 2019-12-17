
/**
 * 按组织机构，查询条件加载用户列表信息
 * 
 */
function findUserListByOrgId() {
	$('#userList').datagrid('load', {
		userGroupId : userGroupId,
		orgId : orgId
	});
}

/**
 * 添加用户组用户
 */
function doSaveUser(){
	window.frames["commonAddFrame"].doSaveUser();
}

/**
 * 删除用户组用户
 */
function doDeleteRefUser(){
	var selecteds = $('#userList').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		$.messager.alert('提示', '请选择操作项！', 'info');
		return;
	}
	$.messager.confirm('删除用户组用户', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].userId + ",";
			});

			ids = ids.substring(0, ids.length - 1);
			$.ajax({
				url : 'userRefGroupController/doDeleteUserRefGroup',
				dataType : 'json',
				data : {
					ids : ids,
					userGroupId : userGroupId
				},
				success : function(result) {
					$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
					setTimeout(function(){
					    $(".messager-body").window('close');    
					},1500);
					$('#userList').datagrid("load",{"userGroupId":userGroupId});
					$('#userList').datagrid('clearSelections'); // 清空选中的行
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
				}
			});
		}
	});
}
/**
 * 滚动至左侧用户组树选中节点
 */
function scrollTo(node){
	$('#org_dept_post_tree').tree('select', node.target);
	var $targetNode = $(node.target);
	var container = $('#org_dept_post_tree').parent();
	var containerH = container.height();
	var nodeOffsetHeight = $targetNode.offset().top - container.offset().top;
	if (nodeOffsetHeight > (containerH - 30)) {
		var scrollHeight = container.scrollTop() + nodeOffsetHeight - containerH + 30;
		container.scrollTop(scrollHeight);
	}
}

/**
 * 条件查询
 */
function findByGroupCondition() {
	
	$('#userList').datagrid('load', {
		userGroupId : userGroupId,
		orgId : orgId,
		searchValue : $("#userGroupSearch").searchbox('getValue')
	});
	
	/*$('#userList').datagrid({
		url : "userRefGroupController/findByCondition",
		queryParams : {
			orgId : orgId,
			userGroupId : userGroupId,
			searchValue : $("#userGroupSearch").searchbox('getValue')
		}
	});*/
}

function getChecked(data){
	if (data!=null && data.rows[0] != null) {
		for(var i=0;i<data.rows.length;i++){
			if(data.rows[i].checked==true){
				 $('#userList').datagrid('selectRow',i);
			}
		}
    }
}

/**
 * <p>清空用户列表
 * <p>add by 王建坤，2016-07-27
 */
function clearUserList(){
	$('#userList').datagrid('loadData',{total:0,rows:[]});
	$('#userList').datagrid('clearSelections'); // 清空选中的行
	$('#userList').datagrid('clearChecked');
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

function isCon(arr, val) {
	for (var i = 0; i < arr.length; i++) {
		if (arr[i] == val)
			return true;
	}
	return false;
}