
$(function() {
	//组织机构树
	initOrgTree();
	$("#deptId").combotree({
		onSelect : function(n, o) {
			setPostData(n.id);
		}
	});
	refuseBackspace('deptId');
	initRoleList();
	initDeptList();
	initUserGroupList();	
});
/**
 * 初始化加载左侧树
 */
function initOrgTree() {
	$('#org_tree').tree({
		url : "orgController/findUnsealedChildOrgDeptTreeAsync",
		animate : true,
		checkbox : false,
		//formatter : formaterNodeCount,
		onlyLeafCheck : false,
		onClick : orgTreeOnClickHandler
		/*onLoadSuccess : function (){
			$('#org_tree').tree('expandAll');
		}*/
	});
}
function orgTreeOnClickHandler(){
	var node = $('#org_tree').tree('getSelected');
	$('#org_tree').tree('expand', node.target);
	if (node.id == '1001') {
		return;
	}
	findUserListByOrgId('org');

	$('#role_list').datagrid('loadData',[]); 
	$('#user_group_list').datagrid('loadData',[]); 
	$('#dept_list').datagrid('loadData',[]); 
}

var uuid = null;
/**
 * 初始化用户信息编辑对话框 初始化面板 初始化数据
 */
function initUserDlg(title) {
	$('#userDlg').dialog({
		title : title
	});
	
	$('#userDlg').dialog("open");
	$('#userForm').form('clear');
	$('#deptId').combotree('loadData',[]); 
	$('#postId').combobox('loadData',[]);
	var node = $('#org_tree').tree('getSelected');

	// 初始化性别、身份类型下拉框，从数据字典中取值
	initDict({
		"user_sex":"sex"
	},'false');
	
	initDict({
		"user_cert_type":"zjlx"
	},'true');

	initDict({
		"userDutyTyp":"pylx"
	},'true');
	
	initDict({
		"userEducation":"xl"
	},'true');
	
	initDict({
		"userDegree":"xw"
	},'true');
	
	initDict({
		"userPoliceType":"zzmm"
	},'true');

	if(title.indexOf("新增")!=-1){
		$("#acct_login").removeAttr("disabled");
		$("#acct_pwd").removeAttr("disabled");
		$("#acctStat").switchbutton("check");
		$("#allowMobileLogin").switchbutton("check");
		$("#allowPcLogin").switchbutton("check");
		//$("input[name=acctStat]").eq(0).attr("checked",true);//默认启用
		$("#acct_ip_segment").hide().val("").parent().prev().html("");
		/*$("#isAdmin1N").attr("checked",'checked');//默认未知*/
		$("#isAdmin").switchbutton("uncheck");
		$("#deptLeader").switchbutton("uncheck");
		var dtype = node.dtype;
		if (dtype == '1') {
			getOrgId(node);
			/* var father = $('#org_tree').tree("getParent",node.target);
			 $('#org_id').val(father.id);*/
		} else {
			$('#org_id').val(node.id);
			$("#org_name").val(node.text);
			$("#orgName").val(node.text);
		}
		$('#orgCode').val(node.attributes.orgCode);
		$("#user_sex").combobox("setValue", "2");
		$("#userDutyTyp").combobox("setValue", "0");
		
		//生成uuid用户上传头像
		$.ajax({
			url : "userController/createUserId",
			type : "post",
			async : false,
			data : {},
			success : function(data) {
				uuid = data;
			}
		});
		$("#userpic").attr("src","uploader/uploadfile?pic=");
		//部门岗位下拉
		initDeptTree();
	}
	
	//ipContrlHandler();
}
function ipContrlHandler(){
	$("#acct_ip_contrl").click(function(){
		if($(this).is(":checked")){
			$("#acct_ip_segment").show().val("").parent().prev().html("IP段限制");
		}else{
			$("#acct_ip_segment").hide().val("").parent().prev().html("");
		}
	});
}
function closeUserDlg() {
	$('#userForm').form('clear');
	$('#userDlg').dialog("close");
}
/**
 * 新增用户对话框弹出
 */
function doAddUserBefore() {
	//判断组织机构id
	var node = $('#org_tree').tree('getSelected');
	if(node==null||node.id==''){
		//$.messager.alert('提示', '请先选择所属单位!');
		layer.tips('请选择所属单位', '#btn_user_add', { tips: 3 });
		return;
	}
	initUserDlg("新增用户信息");
}
/**
 * 添加修改用户保存方法
 */
function doSaveOrUpdateUser() {
	if (!$("#userForm").form('validate')) {
		return;
	}
	var title = $('#userDlg').dialog('options')['title'];
	var userId = $("#user_id").val();
	var url = "";
	if (userId == undefined || userId == '') {
		url = "userController/doSaveUser";
		$("#user_id").val(uuid);
	} else {
		$("#acct_login").removeAttr("disabled");
		url = "userController/doUpdateUser";
	}
	var ip_segment1 = $("#ip_segment1").val();
	var ip_segment2 = $("#ip_segment2").val();
	if(ip_segment1 == '' && ip_segment2 != ''){
		$.messager.alert('提示', 'IP段限制填写不正确!');
		return;
	}
	if(ip_segment2 == '' && ip_segment1 != ''){
		$.messager.alert('提示', 'IP段限制填写不正确!');
		return;
	}
	var ip_segment = null;
	if(ip_segment1 != '' ){
		ip_segment = ip_segment1;
	}
	if(ip_segment2 != '' ){
		ip_segment += "-" +ip_segment2;
	}
	$("#acctIpSegment").val(ip_segment);
	/*var isAdmin = $("*[name='isAdmin1']:checked").val();
	if(isAdmin == undefined){
		isAdmin = "N";
	}
	$("#isAdmin").val(isAdmin);*/
	var adminObj = $("#isAdmin");
	if (adminObj.length == 0) {
		isAdmin = "N";
	}else {
		var isAdmin = adminObj.switchbutton("options").checked;
		if (isAdmin) {
			isAdmin = "Y";
		} else {
			isAdmin = "N";
		}
	}
	var allowMobileLogin = $("#allowMobileLogin").switchbutton("options").checked;
	if (allowMobileLogin) {
		allowMobileLogin = "0";
	} else {
		allowMobileLogin = "1";
	}
	var allowPcLogin = $("#allowPcLogin").switchbutton("options").checked;
	if (allowPcLogin) {
		allowPcLogin = "0";
	} else {
		allowPcLogin = "1";
	}
	var acctStat = $("#acctStat").switchbutton("options").checked;
	if (acctStat) {
		acctStat = "N";
	} else {
		acctStat = "Y";
	}
	
	var deptLeader = $("#deptLeader").switchbutton("options").checked;
	if (deptLeader) {
		deptLeader = "Y";
	} else {
		deptLeader = "N";
	}
	
	var deptName = $("#deptId").combotree("getText");
	$('#deptName').val(deptName);
	$.ajax({
		url : url,
		type : "post",
		async : false,
		dataType:"json",
		data : $('#userForm').serialize()+'&acctStat='+acctStat+'&isAdmin='+isAdmin+'&deptLeader='+deptLeader+'&allowMobileLogin='+allowMobileLogin+'&allowPcLogin='+allowPcLogin,
		beforeSend : function() {
			//$('input.easyui-validatebox').validatebox('enableValidation');
			//return $('#userForm').form('validate');
		},
		success : function(data) {
			
			if(!!data.rezult){
				$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
				$('#userDlg').dialog('close');
			}else{
				$.messager.show({ title:'提示', msg:'保存成功', showType:'slide' });
				$('#userDlg').dialog('close');
				findUserListByOrgId();
				
				/*if (userId != undefined && userId != '') {
					reloadDeptList(userId);//刷新部门列表
				}*/
				$('#userList').datagrid('clearSelections'); // 清空选中的行
			}
		}
	});
}
/**
 * 修改对话框弹出
 */
function doUpdateUserBefore() {
	var node = $('#org_tree').tree('getSelected');
	if(node==null||node.id==''){
		//$.messager.alert('提示', '请先选择所属单位!');
		layer.tips('请先选择所属单位', '#btn_user_edit', { tips: 3 });
		return;
	}
	var data = $('#userList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		layer.tips('请选择一行进行修改', '#btn_user_edit', { tips: 3 });
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示', '请选择一行进行修改！', 'info');
		return;
	}
	var userId = data[0].userId;
	//var deptId = data[0].deptId;
	//var postId = data[0].postId;
	
	$.ajax({
		url : 'userController/findUserById',
		dataType : 'json',
		async : false,
		data : {
			id : userId
		},
		success : function(user) {
			if (user != null) {
				initUserDlg("修改用户信息");
				
				$(":hidden[name=userId]").val(user.userId);
				$("#acct_login").val(user.acctLogin);
				if("Y"==user.acctIsOpert){
					$("#acct_is_opert").attr("checked",true);
				}
				
				//$("#userSex"+user.userSex).attr("checked",true);
				$("#user_sex").combobox("setValue", user.userSex);
				//$("#isAdmin1"+user.isAdmin).attr("checked",true);
				
				if ("Y" == user.isAdmin) {
					$("#isAdmin").switchbutton("check"); 
				} else {
					$("#isAdmin").switchbutton("uncheck"); 
				}
				
				if ("Y" == user.deptLeader) {
					$("#deptLeader").switchbutton("check"); 
				} else {
					$("#deptLeader").switchbutton("uncheck"); 
				}
				
				$('#org_id').val(user.orgId);
				var orgCode = user.orgCode;
				if (orgCode == '' || orgCode == null) {
					orgCode = node.attributes.orgCode;
				}
				$('#orgCode').val(orgCode);
				$("#org_name").val(user.orgName);
				$("#orgName").val(user.orgName);
				$('#picUrl').val(user.picUrl);
				
				//部门岗位下拉
				initDeptTree();
				
				/*if("Y"==user.acctStat){
					$("input[name=acctStat]").eq(1).attr("checked",true);
				}else{
					$("input[name=acctStat]").eq(0).attr("checked",true);
				}*/
				if ("Y" == user.acctStat) {
					$("#acctStat").switchbutton("uncheck"); 
				} else {
					$("#acctStat").switchbutton("check"); 
				}
				
				if ("1" == user.allowMobileLogin) {
					$("#allowMobileLogin").switchbutton("uncheck"); 
				} else {
					$("#allowMobileLogin").switchbutton("check"); 
				}
				if ("1" == user.allowPcLogin) {
					$("#allowPcLogin").switchbutton("uncheck"); 
				} else {
					$("#allowPcLogin").switchbutton("check"); 
				}
				
				$("#userPoliceType").combobox("setValue", user.userPoliceType);
				$("#userDutyTyp").combobox("setValue", user.userDutyTyp);
				
				$("#deptId").combotree("setValue", user.deptId);
				setPostData(user.deptId);
				$("#postId").combobox("setValue", user.postId);
				
				$("#acct_pwd_expr_time").datebox('setValue',user.acctPwdExprTime);
				$("#acct_pwd").val(user.acctPwd);
				if("Y"==user.acctIpContrl){
					$("#acct_ip_contrl").attr("checked",true);
					$("#acct_ip_segment").hide().parent().prev().html("");
				}
				$("#user_name").val(user.userName);
				$("#user_bitrth").datebox('setValue', user.userBitrth);
				$("#user_police_type").combobox("setValue", user.userPoliceType);
				$("#user_cert_type").combobox("setValue", user.userCertType);
				$("#user_cert_code").val(user.userCertCode);
				$("#user_mobile").val(user.userMobile);
				$("#user_email").val(user.userEmail);
				
				$("#userNativePlace").val(user.userNativePlace);
				//$("#userEducation").val(user.userEducation);
				//$("#userDegree").val(user.userDegree);
				
				$("#userEducation").combobox("setValue", user.userEducation);
				$("#userDegree").combobox("setValue", user.userDegree);
				$("#userSeniority").val(user.userSeniority);
				$("#remark").val(user.remark);
				
				$("#dutyPost").val(user.dutyPost);
				$("#joinTime").datebox('setValue', user.joinTime);
				$("#workTime").datebox('setValue', user.workTime);
				$("#entryTime").datebox('setValue', user.entryTime);
				
				$("#userTelephone").val(user.userTelephone);
				
				var acctIpSegment = user.acctIpSegment;
				if(acctIpSegment != null && acctIpSegment.indexOf("-") != -1){
					$("#ip_segment1").val(acctIpSegment.split("-")[0]);
					$("#ip_segment2").val(acctIpSegment.split("-")[1]);
				}else{
					$("#ip_segment1").val(acctIpSegment);
				}
				
				$("#userpic").attr("src","uploader/uploadfile?pic="+user.picUrl);
				
				$("#userForm").form('validate');
				$("#acct_login").attr("disabled","disabled");
				$("#acct_pwd").attr("disabled","disabled");
			}
			$('#userList').datagrid('clearSelections'); // 清空选中的行
		},
		error : function(result) {
			$.messager.show({ title:'提示', msg:'修改失败', showType:'slide' });
		}
	});
}
/**
 * 删除用户
 */
function doDeleteUser() {
	var selecteds = $('#userList').datagrid('getChecked');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择操作项！', 'info');
		layer.tips('请选择操作项', '#btn_user_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除用户', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].userId + ",";
			});

			ids = ids.substring(0, ids.length - 1);
			$.ajax({
				url : 'userController/doDeleteUser',
				dataType : 'json',
				async : false,
				data : {
					ids : ids
				},
				success : function(result) {
					$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
					findUserListByOrgId();
					//清空信息列表
					$('#role_list').datagrid('loadData',[]); 
					$('#user_group_list').datagrid('loadData',[]); 
					$('#dept_list').datagrid('loadData',[]); 
					
					$('#userList').datagrid('clearSelections'); // 清空选中的行
					$('#userList').datagrid('clearChecked');
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
				}
			});
		}
	});
}
/**
 * 按组织机构，查询条件加载用户列表信息
 * 
 */
function findUserListByOrgId(type) {
	var node = $('#org_tree').tree('getSelected');
	if ("org" == type) {
		$('#userList').datagrid('clearSelections'); // 清空选中的行
		$('#userList').datagrid('clearChecked');
	}
	var dtype = node.dtype;
	var deptCode = "";
	if (dtype == "1") {
		deptCode = node.attributes.deptCode
	} else {
		deptCode = node.attributes.orgCode
	}
	var url = "authSetController/findUserListByOrgId?orgId=" + node.id+"&dtype="+dtype+"&deptCode="+deptCode;
	$('#userList').datagrid('reload',url);
}
/**
 * 条件查询
 */
function findByCondition() {
	var node = $('#org_tree').tree('getSelected');
	if(node==null||node.id==''){
		$.messager.alert('提示', '请先选择所属单位!');
		return;
	}
	
	var dtype = node.dtype;
	var deptCode = "";
	if (dtype == "1") {
		deptCode = node.attributes.deptCode
	} else {
		deptCode = node.attributes.orgCode
	}
	var url = "authSetController/findUserListByOrgId?orgId=" + node.id+"&dtype="+dtype+"&deptCode="+deptCode+"&searchValue="+$("#search").searchbox('getValue');
	$('#userList').datagrid('reload',encodeURI(encodeURI(url, "utf-8"),"utf-8"));
	
	/*$('#userList').datagrid({
		url : "userController/findUsersOfOrg",
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams : {
			orgId : node.id,
			searchValue : $("#search").searchbox('getValue')
		}
	});*/
	$('#userList').datagrid('clearSelections'); // 清空选中的行
}
/**
 * 导入用户列表
 */
function doImportUser() {

}
function validAcctLoginExist(){
	var acctLogin = $.trim($("#acct_login").val());
	if(acctLogin==''){
		return;
	}
	$.ajax({
		url : 'userController/findUserByAcctLogin',
		dataType : 'json',
		data : {
			acctLogin : acctLogin
		},
		success : function(result) {
			if(!result){
				$.messager.alert('提示', "登录名称已存在！", 'info');
				$("#acct_login").val("");
				$("#userForm").form('validate');
			}
		},
		error : function(result) {
			$.messager.alert('提示', "登录名称验证失败！", 'info');
		}
	});
}

/*
 * 判断手机号是否存在
 */
function validUserMobileExist(){
	var userMobile = $.trim($("#user_mobile").val());
	if(userMobile==''){
		return;
	}
	var userId = $("#user_id").val();
	$.ajax({
		url : 'userController/findUserMobileByAcctLogin',
		dataType : 'json',
		data : {
			userId : userId,
			userMobile : userMobile
		},
		success : function(result) {
			if(!result){
				$.messager.alert('提示', "手机号已存在！", 'info');
				$("#user_mobile").val("");
				$("#userForm").form('validate');
			}
		},
		error : function(result) {
			$.messager.alert('提示', "登录名称验证失败！", 'info');
		}
	});
}

/*
 * 判断邮箱是否存在
 */
function validUserEmailExist(){
	var userEmail = $.trim($("#user_email").val());
	if(userEmail==''){
		return;
	}
	var userId = $("#user_id").val();
	$.ajax({
		url : 'userController/findUserEmailByAcctLogin',
		dataType : 'json',
		data : {
			userId : userId,
			userEmail : userEmail
		},
		success : function(result) {
			if(!result){
				$.messager.alert('提示', "邮箱已存在！", 'info');
				$("#user_email").val("");
				$("#userForm").form('validate');
			}
		},
		error : function(result) {
			$.messager.alert('提示', "登录名称验证失败！", 'info');
		}
	});
}

/**
 * 同权相赋处理
 */
function doCopy(){
	
}
function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#org_tree").tree('search',searchValue);
}

function getUserInfo(index,obj){
	//cancel all select
	$('#userList').datagrid("clearChecked");
	//check the select row
	$('#userList').datagrid("selectRow", index);
	$('#userList').datagrid("checkRow", index);
}

/**
 * 加载角色列表
 */
function initRoleList() {
	$('#role_list').datagrid({
		method : 'POST',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		idField : 'roleId',
		toolbar : '#role_toolBar',
		striped : true,
		fitColumns : true,
		fit: true,
		singleSelect : false,
		rownumbers : true,
		pagination : false,
		nowrap : false,
		pageSize : 10,
		pageList : [ 10, 20, 50, 100, 150, 200 ],
		showFooter : true,
		columns : [[
		   { field : 'ck', checkbox : false }, 
		   { field : 'roleId', title : 'roleId', hidden : true }, 
		   { field : 'roleName', title : '角色名称', width : 120, align : 'left',formatter:formatRoleName },
		   { field : 'roleEname', title : '角色英文名', width : 120, align : 'left' },
		   { field : 'roleCode', title : '角色编码', width : 80, align : 'left' },
		   { field : 'roleDesc', title : '角色描述', width : 150, align : 'left'},
		   { field : 'roleFrom', title : '角色来源', width : 120, align : 'left' }
		]]
	});
}

/**
 * 重新加载角色列表
 */
function reloadRoleList(userId) {
	var url = 'roleController/findRoleListByUserId';
	$('#role_list').datagrid({
		url : url,
		queryParams:{
			userId : userId
		}
	});
}

function formatRoleName(value,row){
	return '<a href="javascript:viewRolePerm(\''+row.roleId+'\')" class="easyui-linkbutton">'+value+'</a>';
}

/**
 * 加载用户组列表
 * 
 */
function initUserGroupList() {
	//var url = "userGroupController/findUserGroupListByUserId";
	$('#user_group_list').datagrid({
		method : 'POST',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		idField : 'userGroupId',
		toolbar : '#userGroup_toolBar',
		striped : true,
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		fit: true,
		pagination : false,
		nowrap : false,
		pageSize : 10,
		pageList : [ 10, 20, 50, 100, 150, 200 ],
		showFooter : true,
		columns : [ [ 
 		    { field : 'ck', checkbox : false }, 
 		    { field : 'userGroupName', title : '用户组名称', width : 150, align : 'left' }, 
 		    { field : 'userGroupCode', title : '用户组编码', width : 150, align : 'left' }, 
 		    { field : 'userGroupDesc', title : '用户组描述', width : 150, align : 'left' }
 		] ]
	});
}

/**
 * 重新加载用户组列表
 */
function reloadUserGroupList(userId) {
	var url = "userGroupController/findUserGroupListByUserId";
	$('#user_group_list').datagrid({
		url : url,
		queryParams:{
			userId : userId
		}
	});
}

/**
 * 加载用户组列表
 * 
 */
function initDeptList() {
	//var url = "deptController/findDeptListByUserId";
	$('#dept_list').datagrid({
		method : 'POST',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		idField : 'deptId',
		toolbar : '#dept_toolBar',
		striped : true,
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		fit: true,
		pagination : false,
		nowrap : false,
		pageSize : 10,
		pageList : [ 10, 20, 50, 100, 150, 200 ],
		showFooter : true,
		columns : [ [ 
 		    { field : 'ck', checkbox : false }, 
 		    { field : 'deptName', title : '部门名称', width : 150, align : 'left' }, 
 		    { field : 'deptCode', title : '部门编码', width : 150, align : 'left' },
 		    { field : 'deptDesc', title : '部门描述', width : 150, align : 'left' }
 		] ]
	});
}

/**
 * 重新加载部门列表
 */
function reloadDeptList(userId) {
	var url = "deptController/findDeptListByUserId";
	$('#dept_list').datagrid({
		url : url,
		queryParams:{
			userId : userId
		}
	});
}

function clearSearchBox(){
	 $("#search").searchbox("setValue","");
	 $("#org_search").searchbox("setValue","");
}

/**
 * 加载部门树（添加部门）
 */
function initDeptTree(){
	var node = $('#org_tree').tree('getSelected');
	$("#deptId").combotree({
		url:'deptController/findUnSealDeptTree',
		queryParams:{
			orgId : $("#org_id").val()
		},
		onlyLeafCheck : false,
		cascadeCheck : false
		/*onCheck : function(node, checked) {
			setPostData();
		}*/
	});
	refuseBackspace('deptId');
}

function setPostData(deptId){
	//var deptIds = $("#deptId").combotree("getValues");
	$('#postId').combobox({
		url: "postController/findByDeptId?id=" + deptId,
        valueField:'id',
        textField:'text'
    });
	refuseBackspace('postId');
}

function setAdmin(){
	var selecteds = $('#userList').datagrid('getChecked');
	if (selecteds == null || selecteds.length == 0) {
		$.messager.alert('提示', '请选择操作项！', 'info');
		return;
	}
	var ids = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].userId + ",";
	});

	ids = ids.substring(0, ids.length - 1);
	$.ajax({
		url : 'userController/doSetAdmin',
		dataType : 'json',
		data : {
			ids : ids
		},
		success : function(result) {
			$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
			findUserListByOrgId();
			$('#userList').datagrid('clearSelections'); // 清空选中的行
		},
		error : function(result) {
			$.messager.show({ title:'提示', msg:'操作失败', showType:'slide' });
		}
	});
}

/*************************** 格式化字段值 ***************************/

/**
 * 格式化树节点下的子节点总数
 * 
 * @param node 当前树节点
 * @return {String} 返回当前节点下的总数
 */
function formaterNodeCount(node) {
	var s = node.text;
	if (node.children) {
		s += '&nbsp;<span style=\'color:#9a9a9a\'>('+ node.children.length + ')</span>';
	} else {
		s += '&nbsp;<span style=\'color:#9a9a9a\'>(0)</span>';
	}

	return s;
}

function changePic(){
	var userId = $("#user_id").val();
	if (userId == undefined || userId == '') {
		userId = uuid;
	}
	$("#picFrame").attr("src","userController/toChangePic?userId="+userId);
	$('#pic_dialog').dialog("open");
}

function closePicDialog(){
	$('#pic_dialog').dialog("close");
}

function savePic(){
	window.frames["picFrame"].doSavePic();
}

function getOrgId(node){
	var father = $('#org_tree').tree("getParent",node.target);
	if (father.dtype != '0') {
		getOrgId(father);
	} else {
		$('#org_id').val(father.id);
		$("#org_name").val(father.text);
		$("#orgName").val(father.text);
	}
}

/**
 * 用户排序
 */
function sortUser(){
	var node = $('#org_tree').tree('getSelected');
	if (node == null) {
		$.messager.alert('提示', '请选择所属单位！', 'info');
		return;
	} 
	
	var dtype = node.dtype;
	var deptCode = "";
	if (dtype == "1") {
		deptCode = node.attributes.deptCode
	} else {
		$.messager.alert('提示', '请选择部门进行排序！', 'info');
		return;
	}
	var url = "authSetController/findUserListByOrgId?orgId=" + node.id+"&dtype="+dtype+"&deptCode="+deptCode;
	$('#userSortGrid').datagrid('load',url);

	$('#sortDialog').dialog('open');
}

/**
 * 保存
 * */
function doSaveSort(){
	/** 取消还在编辑状态的单元格的编辑状态*/
	if (endEditing()) {
		getSortData(editId,deptId);
		editId = undefined;
		deptId = undefined;
	}
	
	var jsonStr = JSON.stringify(jsonArr);
	if (!jsonStr) {
		return;
	}
	$.ajax({
		url : "userController/doSaveSort",
		type : "post",
		async : false,
		data : {
			jsonStr : jsonStr
		},
		success : function(data) {
			jsonArr = [];
			editId = undefined;
			if (data.success == 'true') {
				
				$('#userSortGrid').datagrid('load');
				window.top.msgTip("保存成功!");
			} else {
				window.top.msgTip("保存失败!");
			}
		}
	});
}

function fetch(page,row){
	if (row == '') {
		return;
	}
	if (editId != undefined) {
		getSortData(editId,deptId);
		editId = undefined;
		deptId = undefined;
	}
}

var editId = undefined;//当前编辑的索引
var deptId = undefined;
var jsonArr = [];
/**
 * 点击单元格事件
 * */
function onClickRow(index, row){
//	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	if (endEditing()){
		$('#userSortGrid').datagrid('selectRow', index);
		//alert(index);
		editId = row.userId;
		deptId = row.deptIdPart;
	}
}

/**
 * 结束编辑状态
 * */
function endEditing(){
	if (editId == undefined){return true};
	getSortData(editId,deptId);
	editId = undefined;
	deptId = undefined;
	return true;
}

/**
 * 取消行编辑事件
 * */
function cancelEdit(){
	if (endEditing()) {
		getSortData(editId,deptId);
		editId = undefined;
		deptId = undefined;
	}
}

function getSortData(editId,deptId){
	if (editId == undefined) {
		return;
	}
	var val = $("#"+editId).val();
	if (isNaN(val)){
		$.messager.alert('提示', '排序号请输入数字！','info');
		$("#"+editId).val("");
		return;
	}
	var val_weight = $("#"+editId+"_weight").val();
	if (isNaN(val_weight)){
		$.messager.alert('提示', '权重值请输入数字！','info');
		$("#"+editId+"_weight").val("");
		return;
	}
	var flag = false; 
	if (jsonArr != '') {
		for (var i = 0;i < jsonArr.length;i++){
			if(editId == jsonArr[i].userId){
				jsonArr[i].sort = val;
				jsonArr[i].weight = val_weight;
				flag = true;
				break;
			}
		}
	}
	if (!flag) {
		var data = {};
		data.userId = editId;
		data.sort = val;
		data.deptId = deptId;
		data.weight = val_weight;
		jsonArr.push(data);
	}
}

function formaterUserSort(val, row){
	if (jsonArr != '') {
		for (var i = 0;i < jsonArr.length;i++){
			if(row.userId == jsonArr[i].userId){
				val = jsonArr[i].sort;
				break
			}
		}
	}
	if(val == null) val="";
	return '<input type="text" onChange="changeSort(\''+row.userId+'\',\''+row.deptIdPart+'\')" id='+row.userId+' value=\''+val+'\' class="datagrid-editable-input numberbox-f" style="margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 30px; line-height: 30px;width:99%">'
}

function formaterUserWeight(val, row){
	if (jsonArr != '') {
		for (var i = 0;i < jsonArr.length;i++){
			if(row.userId == jsonArr[i].userId){
				val = jsonArr[i].weight;
				break
			}
		}
	}
	if(val == null) val="";
	return '<input type="text" onChange="changeSort(\''+row.userId+'\',\''+row.deptIdPart+'\')" id='+row.userId+'_weight value=\''+val+'\' class="datagrid-editable-input numberbox-f" style="margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 30px; line-height: 30px;width:99%">'
}

function changeSort(userId,deptId){
	getSortData(userId,deptId);
	editId = undefined;
	deptId = undefined;
}

/**
 * 打开导入用户信息弹出框
 * 
 * @author 王建坤
 * @since 2017-03-09
 * @param 无
 * @return 无
 */
function openUserImportDlg(){
	$("#file").filebox("setValue","");
	$('#userInfoImportDlg').dialog('open');
}

/**
 * 导入用户信息
 * 
 * @author 王建坤
 * @since 2017-03-09
 * @param 无
 * @return 无
 */
function importUserInfo(){
	//限制文件为excel文件
	var picSrc = $('#file').filebox('getValue');
	if (picSrc.indexOf(".xls") < 0) {
		$.messager.alert('提示', '仅支持xls格式，请重新选择！', 'info');
		return;
	}
	
	$('#importFileForm').form('submit', {
		url : 'excelController/importUserInfo',
	    success:function(data){
	    	var result = eval("("+data+")");
	    	$('#userInfoImportDlg').dialog('close');
	    	if (result.status == "0") {
	    		$.messager.show({ title:'提示', msg:result.data, showType:'slide' });
			} else if (result.status == "1") {
				$("#errorList").datagrid('loadData',result.data);
				$('#errorInfoDialog').dialog('open');
			}
	    },
	    error:function(data){
	    	alert("执行出现异常");
	    }
	});
}

function resetPwd(){
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
	$.messager.confirm('提示', '确定重置吗?', function(r) {
		if (r) {
			$.ajax({
				url : 'userController/resetPwd',
				dataType : 'json',
				data : {
					userId : userId,
					pwd : '123'
				},
				success : function(result) {
					$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
					findUserListByOrgId();
					$('#userList').datagrid('clearSelections'); // 清空选中的行
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'操作失败', showType:'slide' });
				}
			});
		}
	});
}