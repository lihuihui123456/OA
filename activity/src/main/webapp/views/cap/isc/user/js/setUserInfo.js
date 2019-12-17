/** 分配角色 ****************************************/
//分配角色
function saveRole(){
	var node = $('#org_tree').tree('getSelected');
	
	if(node==null||node.id==''){
		$.messager.alert('提示', '请先选择所属单位!');
		return;
	}
	var data = $('#userList').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	var userId = data[0].userId;
	var orgId = data[0].orgId;
	
	//$('#select_role').datagrid('clearSelections');
	initSelectRole(orgId,userId);
	$('#roleDialog').dialog('open');
}

function initSelectRole(orgId,userId){
	$.ajax({
		url : 'roleController/initSelectRole',
		dataType : 'text',
		data : {
			orgId : orgId,
			userId : userId
		},
		success : function(result) {
			result = eval("("+result+")").rows;
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
			$('#role_tb1').datagrid('loadData',sel1);
			$('#role_tb2').datagrid('loadData',sel2);
		},
		error : function(result) {
			$.messager.show({ title:'提示', msg:'执行失败', showType:'slide' });
		}
	});
}

//保存选择的部门
function doSaveRole(){
	
	var data = $('#userList').datagrid('getChecked');
	var userId = data[0].userId;
	
	var rows = $("#role_tb2").datagrid("getRows");
	var ids = '';
	$(rows).each(function(index) {
		ids = ids + rows[index].roleId + ",";
	});
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	$.ajax({
		url : 'roleUserController/doSaveSelectRole',
		dataType : 'json',
		async : false,
		data : {roleIds : ids,userId : userId},
		success : function(result) {
			$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
			//reloadRoleList(userId);
			$('#roleDialog').dialog('close');
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});
}

function add_role(obj) {
	var data = $('#role_tb1').datagrid('getSelections');
	if (data) {
		$(data).each(function(index) {
			$('#role_tb2').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
			
			var rowIndex = $('#role_tb1').datagrid('getRowIndex', data[index]);
	        $('#role_tb1').datagrid('deleteRow', rowIndex);
		});
	}
}

function addAll_role(obj) {
	var data = $('#role_tb1').datagrid('getRows');
	if (data) {
		$(data).each(function(index) {
			$('#role_tb2').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
		});
		$('#role_tb1').datagrid('loadData',[]);
	}
}

function del_role(obj) {
	var data = $('#role_tb2').datagrid('getSelections');
	if (data) {
		$(data).each(function(index) {
			$('#role_tb1').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
			
			var rowIndex = $('#role_tb2').datagrid('getRowIndex', data[index]);
	        $('#role_tb2').datagrid('deleteRow', rowIndex);
		});
	}
}

function delAll_role(obj) {
	var data = $('#role_tb2').datagrid('getRows');
	if (data) {
		$(data).each(function(index) {
			$('#role_tb1').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
		});
		$('#role_tb2').datagrid('loadData',[]);
	}
}

/** 分配角色END ****************************************/

/** 分配用户组 ****************************************/

function saveUserGroup(){
	var node = $('#org_tree').tree('getSelected');
	
	if(node==null||node.id==''){
		$.messager.alert('提示', '请先选择所属单位!');
		return;
	}
	var data = $('#userList').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	var userId = data[0].userId;
	var orgId = data[0].orgId;
	
	//$('#select_role').datagrid('clearSelections');
	initSelectUserGroup(orgId,userId);
	$('#userGroupDialog').dialog('open');
}

function initSelectUserGroup(orgId,userId){
	$.ajax({
		url : 'userGroupController/initSelectUserGroup',
		dataType : 'text',
		data : {
			orgId : orgId,
			userId : userId
		},
		success : function(result) {
			result = eval("("+result+")").rows;
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
			$('#userGroup_tb1').datagrid('loadData',sel1);
			$('#userGroup_tb2').datagrid('loadData',sel2);
		},
		error : function(result) {
			$.messager.show({ title:'提示', msg:'执行失败', showType:'slide' });
		}
	});
}

//保存选择的部门
function doSaveUserGroup(){
	
	var data = $('#userList').datagrid('getChecked');
	var userId = data[0].userId;
	
	var rows = $("#userGroup_tb2").datagrid("getRows");
	var ids = '';
	$(rows).each(function(index) {
		ids = ids + rows[index].userGroupId + ",";
	});
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	$.ajax({
		url : 'userRefGroupController/doSaveSelectUserGroup',
		dataType : 'json',
		async : false,
		data : {userGroupIds : ids,userId : userId},
		success : function(result) {
			$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
			//reloadUserGroupList(userId);
			$('#userGroupDialog').dialog('close');
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});
}

function add_userGroup(obj) {
	var data = $('#userGroup_tb1').datagrid('getSelections');
	if (data) {
		$(data).each(function(index) {
			$('#userGroup_tb2').datagrid('appendRow', {
				"userGroupId" : data[index].userGroupId,
				"userGroupName" : data[index].userGroupName
			});
			
			var rowIndex = $('#userGroup_tb1').datagrid('getRowIndex', data[index]);
	        $('#userGroup_tb1').datagrid('deleteRow', rowIndex);
		});
	}
}

function addAll_userGroup(obj) {
	var data = $('#userGroup_tb1').datagrid('getRows');
	if (data) {
		$(data).each(function(index) {
			$('#userGroup_tb2').datagrid('appendRow', {
				"userGroupId" : data[index].userGroupId,
				"userGroupName" : data[index].userGroupName
			});
		});
		$('#userGroup_tb1').datagrid('loadData',[]);
	}
}

function del_userGroup(obj) {
	var data = $('#userGroup_tb2').datagrid('getSelections');
	if (data) {
		$(data).each(function(index) {
			$('#userGroup_tb1').datagrid('appendRow', {
				"userGroupId" : data[index].userGroupId,
				"userGroupName" : data[index].userGroupName
			});
			
			var rowIndex = $('#userGroup_tb2').datagrid('getRowIndex', data[index]);
	        $('#userGroup_tb2').datagrid('deleteRow', rowIndex);
		});
	}
}

function delAll_userGroup(obj) {
	var data = $('#userGroup_tb2').datagrid('getRows');
	if (data) {
		$(data).each(function(index) {
			$('#userGroup_tb1').datagrid('appendRow', {
				"userGroupId" : data[index].userGroupId,
				"userGroupName" : data[index].userGroupName
			});
		});
		$('#userGroup_tb2').datagrid('loadData',[]);
	}
}

/** 分配用户组END ****************************************/

/** 分配部门岗位 ****************************************/
//分配部门岗位
function saveDept(){
	var node = $('#org_tree').tree('getSelected');
	
	if(node==null||node.id==''){
		$.messager.alert('提示', '请先选择所属单位!');
		return;
	}
	var data = $('#userList').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	var userId = data[0].userId;
	var orgId = data[0].orgId;
	
	//$('#select_role').datagrid('clearSelections');
	//initSelectDept(orgId,userId);
	//initSelectPost(orgId,userId);
	InitTreeData(orgId,userId);
	$('#deptDialog').dialog('open');
}

/**
 * 初始化加载部门岗位树
 */
var mainDeptId = '';
var mainDeptName = '';
var mainPostId = '';
function InitTreeData(orgId,userId) {
	$('#dept_post_tree').tree({
		url : 'orgController/findDeptPostTreeByUserId?userId='+userId,
		animate : true,
		checkbox : true,
		onlyLeafCheck : false,
		formatter : formaterNodeCount,
		cascadeCheck : false,
		onBeforeLoad: function (node, param) {//onBeforeLoad,在请求载入数据之前触发，返回false将取消载入。
            $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%" }).appendTo("#dept_post_tree");
            $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍待。。。").appendTo("#dept_post_tree").css({ display: "block" });
        },
		onCheck : function(node, checked) {
			if (node.id == orgId || node.url == 'Y') {
        		$('#dept_post_tree').tree('check', node.target);
        		return;
			}
			/*if (checked) {
                var parentNode = $("#dept_post_tree").tree('getParent', node.target);
                if (parentNode != null) {
                    $("#dept_post_tree").tree('check', parentNode.target);
                }
            } else {
                var childNode = $("#dept_post_tree").tree('getChildren', node.target);
                if (childNode.length > 0) {
                    for (var i = 0; i < childNode.length; i++) {
                        $("#dept_post_tree").tree('uncheck', childNode[i].target);
                    }
                }
            }*/
		},
		onLoadSuccess: function (node,data) {
			$('#dept_post_tree').tree('collapseAll');
			
			var node = $('#dept_post_tree').tree('find', orgId);
			$('#dept_post_tree').tree('expand', node.target);
			$('#dept_post_tree').tree('check', node.target);
		}
	});
}

/**
 * 格式化树节点下的子节点总数
 * 
 * @param node 当前树节点
 * @return {String} 返回当前节点下的总数
 */
function formaterNodeCount(node) {
	var s = node.text;
	if (node.dtype == 0) {
		return s;
	}
	var str = '';
	if (node.dtype == 1 && node.url == 'Y') {
		mainDeptId = node.id;
		mainDeptName = node.text;
		str = '<span style=\'color:blue\'>( 主部门  )</span>';
	}
	if (node.dtype == 2 && node.url == 'Y') {
		mainPostId = node.id;
		str = '<span style=\'color:blue\'>( 主岗位  )</span>';
	}
	var ext = node.attributes;
	if(ext == "N"){
		s += '&nbsp;&nbsp;' + str + '&nbsp;&nbsp;<input type="checkbox" id="'+node.id+'" >是否继承角色'
	}else{
		s += '&nbsp;&nbsp;' + str + '&nbsp;&nbsp;<input type="checkbox" id="'+node.id+'" checked >是否继承角色';
	}
	return s;
}

//保存选择的部门岗位
function doSaveSelectDeptPost(){
	var data = $('#userList').datagrid('getChecked');
	var userId = data[0].userId;
	var orgId = data[0].orgId;
	
	var nodes = $('#dept_post_tree').tree('getChecked');
	
	var parms = '';
	var fg = '';
	for(var i = 0; i < nodes.length; i++){
		if (nodes[i].id == orgId) {
			continue;
		}
		if (parms != '') parms += ',';
		
		if ($("#"+nodes[i].id).is(':checked') == true) {
			fg = "Y";
		}else {
			fg = "N";
		}
		parms += nodes[i].id + "-" + nodes[i].dtype + "-" + fg;
	}
	$.ajax({
		url : 'userController/doSaveSelectDeptPost',
		dataType : 'json',
		async : false,
		data : {parms:parms,userId:userId,mainDeptId:mainDeptId,mainPostId:mainPostId,mainDeptName:mainDeptName},
		success : function(result) {
			var msg = result;
			$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
			findUserListByOrgId();
			$('#deptDialog').dialog('close');
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});
}

function deptTreeSearch(){
	var searchValue = $("#dept_search").searchbox('getValue');
	$("#dept_post_tree").tree('search',searchValue);
}

function viewPerm(){
	var node = $('#org_tree').tree('getSelected');
	if(node==null||node.id==''){
		$.messager.alert('提示', '请先选择所属单位!');
		return;
	}
	var data = $('#userList').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	var userId = data[0].userId;
	$('#menu_tree li').remove();
	InitMenuTreeData(userId);
	$('#roleMenuDialog').dialog('open');
}

/**
 * 初始化权限菜单树
 */
function InitMenuTreeData(userId) {
	$('#menu_tree').tree({
		url : 'roleMenuController/findMenuByUserId',
		animate : true,
		checkbox : false,
		queryParams:{
			userId : userId
		},
		onlyLeafCheck : false,
		cascadeCheck : false,
		onBeforeLoad: function (node, param) {//onBeforeLoad,在请求载入数据之前触发，返回false将取消载入。
            $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%" }).appendTo("#menu_tree");
            $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍待。。。").appendTo("#menu_tree").css({ display: "block" });
        },
		onLoadSuccess: function (row,data) {
			//$(".datagrid-mask").css({ display: "none"});
            //$(".datagrid-mask-msg").css({ display: "none" });
			$('#menu_tree').tree('collapseAll');
		},
		onClick : function(node) {
			// 点击展开
			$('#menu_tree').tree('expand', node.target);
		}
	});
}

function copyPerm(){
	var node = $('#org_tree').tree('getSelected');
	if(node==null||node.id==''){
		$.messager.alert('提示', '请先选择所属单位!');
		return;
	}
	var data = $('#userList').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	var userId = data[0].userId;
	var deptId = data[0].deptId;
	$('#copyPermList').datagrid('clearChecked'); // 清空选中的行
	InitCopyPermData(userId,deptId);
	$('#copyPermDialog').dialog('open');
}

/**
 * 按部门，查询条件加载用户列表信息
 * 
 * @param orgId 组织机构id
 */
function InitCopyPermData(userId,deptId) {
	var url = "userController/initCopyPermData";
	
	$('#copyPermList').datagrid({
		url : url,
		method : 'POST',
		idField : 'userId',
		striped : true,
		fitColumns : true,
		fit : true,
		singleSelect : true,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#copyPermToolBar',
		pageSize : 10,
		showFooter : true,
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams : {
			userId : userId,
			deptId : deptId,
			searchValue : $("#copyPermSearch").searchbox('getValue')
		},
		columns : [ [ 
		    { field : 'ck', checkbox : true }, 
 		    { field : 'userId', title : 'userId', hidden : true }, 
 		    { field : 'acctLogin', title : '登录账号', width : 150, align : 'left' }, 
 		    { field : 'userName', title : '真实姓名', width : 150, align : 'left' } 
 		] ],
		onClickRow: function(index,row){
			//cancel all select
		}
	});
}

/**
 * 条件查询
 */
function findByCopyPerm () {
	var node = $('#org_tree').tree('getSelected');
	if(node==null||node.id==''){
		$.messager.alert('提示', '请先选择所属单位!');
		return;
	}
	var data = $('#userList').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	var userId = data[0].userId;
	var deptId = data[0].deptId;
	
	$('#copyPermList').datagrid('load', {
		userId : userId,
		deptId : deptId,
		searchValue : $("#copyPermSearch").searchbox('getValue')
	});
	$('#copyPermList').datagrid('clearSelections'); // 清空选中的行
	$('#copyPermList').datagrid('clearChecked'); // 清空选中的行
}

function doSaveCopyPerm(){
	var data = $('#userList').datagrid('getChecked');
	
	var userId = data[0].userId;
		
	var obj = $('#copyPermList').datagrid('getChecked');
	if (obj == "") {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	if (obj.length > 1) {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	var select_userId = obj[0].userId; 
	
	$.ajax({
		url : 'userController/doSaveCopyPerm',
		dataType : 'json',
		async : false,
		data : {userId:userId,select_userId:select_userId},
		success : function(result) {
			$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
			$('#copyPermDialog').dialog('close');
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});
}

function viewInfo(value, row){
	var userId = row.userId;
	return '<a href="javascript:openInfo(\''+userId+'\')" class="easyui-linkbutton">查看详情</a>';
}

function openInfo(userId){
	$('#userInfoDialog').dialog("open");
	reloadRoleList(userId);
	reloadUserGroupList(userId);
	reloadDeptList(userId);
}

function viewRolePerm(roleId){
	var node = $('#org_tree').tree('getSelected');
	if(node==null||node.id==''){
		$.messager.alert('提示', '请先选择所属单位!');
		return;
	}
	var data = $('#userList').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	var userId = data[0].userId;
	var isAdmin = data[0].isAdmin;
	$('#menu_tree li').remove();
	InitRoleTreeData(isAdmin,roleId);
	$('#roleMenuDialog').dialog('open');
}

/**
 * 初始化权限菜单树
 */
function InitRoleTreeData(isAdmin,roleId) {
	$('#menu_tree').tree({
		url : 'roleMenuController/findRoleTreeData',
		animate : true,
		checkbox : false,
		queryParams:{
			isAdmin : isAdmin,
			roleId : roleId
		},
		onlyLeafCheck : false,
		cascadeCheck : false,
		onBeforeLoad: function (node, param) {//onBeforeLoad,在请求载入数据之前触发，返回false将取消载入。
            $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%" }).appendTo("#menu_tree");
            $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍待。。。").appendTo("#menu_tree").css({ display: "block" });
        },
		onLoadSuccess: function (row,data) {
			//$(".datagrid-mask").css({ display: "none"});
            //$(".datagrid-mask-msg").css({ display: "none" });
			$('#menu_tree').tree('collapseAll');
		},
		onClick : function(node) {
			// 点击展开
			$('#menu_tree').tree('expand', node.target);
		}
	});
}