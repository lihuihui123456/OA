$(function() {});

/**
 * <p>绑定用户组树查询
 * <p>add by 王建坤，2016-07-27
 * */
function bindLeftSearch(){
	$('#roleGroupSearch').searchbox({
	    searcher:function(value){
	    	var nodes = $("#userGroupTree").tree("getRoots");
	    	for ( var i = 0; i < nodes.length; i++) {
	    		if(value==nodes[i].text){
	    			var node = $('#userGroupTree').tree('find', nodes[i].id);
	    			roleScrollTo(node);
	    		}
			}
	    },
	    prompt: "请输入用户组名称"
	});
}

/**
 * <p>加载用户组树
 * <p>add by 王建坤，2016-07-27
 * */
function initUserGroups(){
	$("#userGroupTree").tree({
		url : 'userGroupController/findAllUserGroup',
		animate : true,
		checkbox : false,
		onlyLeafCheck : true,
		onLoadSuccess : function(){
			var node = $('#userGroupTree').tree('find', userGroupId);
			$('#userGroupTree').tree('select', node.target);
			roleScrollTo(node);
		},
		onClick : function(node) {
			userGroupId = node.id;
			$("#is_res_role").attr("checked",true);
			$('#roleList').datagrid("load",{
				"userGroupId":userGroupId,
				"isResRole":$("#is_res_role").is(":checked")?"Y":"N"
			});
		},
		onContextMenu : function(e, node) {
			e.preventDefault();
		}
	});
}

/**
 * <p>加载用户列表
 * add by 王建坤，2016-07-27
 * */
function loadRoleList(){
	$("#is_res_role").attr("checked",true);
	var url = "roleController/findRoleByUserGroupId";
	$('#roleList').datagrid({
		url : url,
		queryParams: {
			userGroupId: userGroupId,
			isResRole: $("#is_res_role").is(":checked")?"Y":"N"
		},
		method : 'POST',
		fit : true,
		idField : 'userId',
		striped : true,
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#roleGroupToolBar',
		pageSize : 10,
		showFooter : true,
		columns : [ [ 
 		    { field : 'ck', checkbox : true }, 
 		    { field : 'roleId', title : 'roleId', hidden : true }, 
		    { field : 'roleName', title : '角色名称', width : 120, align : 'left' },
		    { field : 'roleEname', title : '角色英文名', width : 100, align : 'left' },
		    { field : 'roleCode', title : '角色编码', width : 100, align : 'left' },
		    //{ field : 'createTime', title : '创建时间', width : 120, align : 'left' },
		    { field : 'roleDesc', title : '角色描述', width : 150, align : 'left'}
 		] ],
		onBeforeLoad : function(param) {
		},
		onLoadSuccess : function(data) {

		},
		onLoadError : function() {

		},
		onClickCell : function(rowIndex, field, value) {

		}
	});
}

/**
 * 条件查询
 */
function findByRoleCondition() {
	var isResRole = $("#is_res_role").is(":checked")?"Y":"N", 
	roleCode = $.trim($("#role_code_q").textbox("getValue")), 
	roleName = $.trim($("#role_name_q").textbox("getValue"));
	$('#roleList').datagrid({
		url : "roleController/findRoleByUserGroupId",
		queryParams : {
			userGroupId: userGroupId,
			isResRole : isResRole,
			roleCode : roleCode,
			roleName : roleName
		}
	});
	$('#roleList').datagrid('clearSelections'); // 清空选中的行
}
/**
 * 添加用户组关联角色
 */
function doAddRefRole(){
	if(!$("#is_res_role").is(":checked")){//刷新列表
		var selecteds = $('#roleList').datagrid('getSelections');
		if (selecteds == null || selecteds.length == 0) {
			$.messager.alert('添加用户组关联角色', '请选择操作项！');
			return;
		}
		var ids = '';
		$(selecteds).each(function(index) {
			ids = ids + selecteds[index].roleId + ",";
		});

		ids = ids.substring(0, ids.length - 1);
		$.ajax({
			url : 'userGroupRefRoleController/doSaveUserGroupRefRole',
			dataType : 'json',
			data : {
				ids : ids,
				userGroupId : userGroupId
			},
			success : function(result) {
				$.messager.alert('添加用户组关联角色', "添加成功！");
				$('#roleList').datagrid("load",{
					"userGroupId":userGroupId,
					"isResRole":$("#is_res_role").is(":checked")?"Y":"N"
				});
				$('#roleList').datagrid('clearSelections'); // 清空选中的行
			},
			error : function(result) {
				$.messager.alert('添加用户组关联角色', "添加失败！");
			}
		});
	}else{
		$("#is_res_role").attr("checked",false);
		findByRoleCondition();
	}
}
/**
 * 删除用户组关联角色
 */
function doDeleteRefRole(){
	if($("#is_res_role").is(":checked")){//刷新列表
		var selecteds = $('#roleList').datagrid('getSelections');
		if (selecteds == null || selecteds.length == 0) {
			$.messager.alert('删除用户组关联角色', '请选择操作项！');
			return;
		}
		$.messager.confirm('删除用户组关联角色', '确定删除吗?', function(r) {
			if (r) {
				var ids = '';
				$(selecteds).each(function(index) {
					ids = ids + selecteds[index].roleId + ",";
				});

				ids = ids.substring(0, ids.length - 1);
				$.ajax({
					url : 'userGroupRefRoleController/doDeleteUserGroupRefRole',
					dataType : 'json',
					async : false,
					data : {
						ids : ids,
						userGroupId : userGroupId
					},
					success : function(result) {
						$.messager.alert('删除用户组关联角色', "删除成功！");
						$('#roleList').datagrid("load",{
							"userGroupId":userGroupId,
							"isResRole":$("#is_res_role").is(":checked")?"Y":"N"
						});
						$('#roleList').datagrid('clearSelections'); // 清空选中的行
					},
					error : function(result) {
						$.messager.alert('删除用户组关联角色', "删除失败！");
					}
				});
			}
		});
	}else{
		$("#is_res_role").attr("checked",true);
		findByRoleCondition();
	}
}
/**
 * 滚动至左侧用户组树选中节点
 */
function roleScrollTo(node){
	$('#userGroupTree').tree('select', node.target);
	var $targetNode = $(node.target);
	var container = $('#userGroupTree').parent();
	var containerH = container.height();
	var nodeOffsetHeight = $targetNode.offset().top - container.offset().top;
	if (nodeOffsetHeight > (containerH - 30)) {
		var scrollHeight = container.scrollTop() + nodeOffsetHeight - containerH + 30;
		container.scrollTop(scrollHeight);
	}
}