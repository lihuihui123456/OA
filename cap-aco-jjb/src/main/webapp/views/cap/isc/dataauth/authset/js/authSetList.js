$(function() {
	InitTreeData();
	
	findUserListByOrgId();
	
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
			}  else {
				deptCode = node.attributes.orgCode
			}
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
function findUserListByOrgId() {
	//var node = $('#org_dept_tree').tree('getSelected');
	//var orgId = node.id;
	//var dtype = node.dtype;
	//var url = "authSetController/findUserListByOrgId?flag=1";
	
	$('#userList').datagrid({
		//url : url,
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
		columns : [ [ 
		    { field : 'ck', checkbox : true }, 
 		    { field : 'userId', title : 'userId', hidden : true }, 
 		    { field : 'acctLogin', title : '登录账号', width : 150, align : 'left' }, 
 		    { field : 'userName', title : '真实姓名', width : 150, align : 'left' } ,
 		    { field : 'deptNamePart', title : '所属部门', width : 120, align : 'left' } ,
 		    { field : 'dataRoleId', title : '数据角色', width : 200, align : 'left',formatter:fmtRoles } 
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
	var url = "authSetController/findUserListByOrgId?flag=1";
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

function clearSearchBox(){
	 $("#search").searchbox("setValue","");
}

/**
 * 重新加载列表
 */
function reload(orgId,dtype,deptCode) {
	
	var url = "authSetController/findUserListByOrgId?flag=1";
	$('#userList').datagrid({
		url : url,
		queryParams : {
			orgId : orgId,
			dtype : dtype,
			deptCode : deptCode,
			searchValue : $("#search").searchbox('getValue')
		},
	});
	$('#userList').datagrid('clearChecked');
	
	/*$('#userList').datagrid('load', {
		orgId : orgId,
		dtype : dtype,
		deptCode : deptCode,
		searchValue : $("#search").searchbox('getValue')
	});*/
}

/**
 * 打开关联角色窗口
 */
function openRoleDlg(){
	var node = $('#org_dept_tree').tree('getSelected');
	if (node == null) {
		//$.messager.alert('提示', '请选择单位！', 'info');
		layer.tips('请选择单位', '#btn_role', { tips: 3 });
		return;
	}
	var orgId = node.attributes.orgId;
	
	var data = $('#userList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行操作！','info');
		layer.tips('请选择一行进行操作', '#btn_role', { tips: 3 });
		return;
	}
	if (data) {
		
		var ids = '';
		$(data).each(function(index) {
			ids = ids + data[index].userId + ",";
		});
		if(ids != ''){
			ids = ids.substring(0, ids.length - 1);
		}
		
		sel_userId = ids;
		initSelectRole(orgId,ids);
		$('#roleDialog').dialog('open');
	}
}

/**
 * 初始化关联角色窗口信息
 */
function initSelectRole(orgId,userId){
	$.ajax({
		url : 'authSetController/initSelectRole',
		dataType : 'text',
		data : {
			orgId : orgId,
			userId : userId
		},
		success : function(data) {
			var result = eval("("+data+")").rows;
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
			$('#tb1').datagrid('loadData',sel1);
			$('#tb2').datagrid('loadData',sel2);
		},
		error : function(result) {
			$.messager.show({ title:'提示', msg:'执行失败', showType:'slide' });
		}
	});
}

/**
 * 保存用户组角色关联
 * */
function doSaveRole(){
	var rows = $("#tb2").datagrid("getRows");
	var ids = '';
	$(rows).each(function(index) {
		ids = ids + rows[index].roleId + ",";
	});
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	
	var node = $('#org_dept_tree').tree('getSelected');
	
	var orgId = node.attributes.orgId;
	
	$.ajax({
		url : 'authSetController/doSaveSelectRole',
		dataType : 'json',
		async : false,
		data : {roleIds : ids,userId : sel_userId},
		success : function(result) {
			var msg = result;
			if (msg == '2') {
				$.messager.alert('提示', '所选角色有相同模块规则，请重新选择！！', 'info');
				return;
			}
			$('#roleDialog').dialog('close');
			$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
			//reloadRoleList(userId);
			var dtype = node.dtype;
			var deptCode = "";
			if (dtype == "1") {
				deptCode = node.attributes.deptCode
			} else {
				deptCode = node.attributes.orgCode
			}
			reload(orgId,dtype,deptCode);
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});
}

/**
 * 添加角色，右移
 * */
function add(obj) {
	var data = $('#tb1').datagrid('getSelections');
	if (data) {
		$(data).each(function(index) {
			$('#tb2').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
			
			var rowIndex = $('#tb1').datagrid('getRowIndex', data[index]);
	        $('#tb1').datagrid('deleteRow', rowIndex);
		});
	}
}

/**
 * 添加所有，右移
 * @author 王建坤
 * */
function addAll(obj) {
	var data = $('#tb1').datagrid('getRows');
	if (data) {
		$(data).each(function(index) {
			$('#tb2').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
		});
		$('#tb1').datagrid('loadData',[]);
	}
}

/**
 * 删除角色
 * */
function del(obj) {
	var data = $('#tb2').datagrid('getSelections');
	if (data) {
		$(data).each(function(index) {
			$('#tb1').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
			
			var rowIndex = $('#tb2').datagrid('getRowIndex', data[index]);
	        $('#tb2').datagrid('deleteRow', rowIndex);
		});
	}
}

/**
 * 删除全部角色
 * */
function delAll(obj) {
	var data = $('#tb2').datagrid('getRows');
	if (data) {
		$(data).each(function(index) {
			$('#tb1').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
		});
		$('#tb2').datagrid('loadData',[]);
	}
}

function saveUserRoles(){
	
	var node = $('#org_dept_tree').tree('getSelected');
	
	if(node == null){
		$.messager.alert('提示', '请选择所属单位！', 'info');
		return ;
	}
	var orgId = node.attributes.orgId;
	
	var rows = $("#userList").datagrid("getRows");
	var parms = '';
	$(rows).each(function(index) {
		if (parms != '') parms += ',';
		parms += rows[index].userId + "-" + $("input[name='row_"+index+"']:checked").val();
	});
	
	$.ajax({
		url : 'authSetController/doSaveUserRoles',
		dataType : 'json',
		async : false,
		data : {orgId : orgId,parms : parms},
		success : function(result) {
			var msg = result;
			$('#roleDialog').dialog('close');
			$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
			
			var dtype = node.dtype;
			var deptCode = "";
			if (dtype == "1") {
				deptCode = node.attributes.deptCode
			} else {
				deptCode = node.attributes.orgCode
			}
			reload(orgId,dtype,deptCode);
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});
}

function selectAllSelf(obj){
	if ($(obj).is(':checked') == true) {
		$("input[name='titleSet']").removeAttr("checked");
		
		$("input").removeAttr("checked");
		
		$(obj).prop("checked",true);
		
        $("input[class='self']").prop("checked", true);
	}else {
        $("input[class='self']").removeAttr("checked");
    }
}

function selectAllDept(obj){
	if ($(obj).is(':checked') == true) {
		$("input[name='titleSet']").removeAttr("checked");
		
		$("input").removeAttr("checked");
		
		$(obj).prop("checked",true);
		
        $("input[class='dept']").prop("checked", true);
	}else {
        $("input[class='dept']").removeAttr("checked");
    }
}

function selectAllOrg(obj){
	if ($(obj).is(':checked') == true) {
		$("input[name='titleSet']").removeAttr("checked");
		
		$("input").removeAttr("checked");
		
		$(obj).prop("checked",true);
		
        $("input[class='org']").prop("checked", true);
	}else {
        $("input[class='org']").removeAttr("checked");
    }
}

function selectAllNone(obj){
	if ($(obj).is(':checked') == true) {
		$("input[name='titleSet']").removeAttr("checked");
		
		$("input").removeAttr("checked");
		
		$(obj).prop("checked",true);
		
        $("input[class='none']").prop("checked", true);
	}else {
        $("input[class='none']").removeAttr("checked");
    }
}

function selectAllOther(obj){
	if ($(obj).is(':checked') == true) {
		$("input[name='titleSet']").removeAttr("checked");
		
		$("input").removeAttr("checked");
		
		$(obj).prop("checked",true);
		
        $("input[class='other']").prop("checked", true);
	}else {
        $("input[class='other']").removeAttr("checked");
    }
}

function setOther(obj){
	var name = $(obj).attr("name");
	if ($(obj).is(':checked') == true) {
		$("input[name='"+name+"']").removeAttr("checked");
		
		$(obj).prop("checked",true);
	}
}

function planUrl(val,row){
 	return '<a href="javascript:void(0)" onclick="updateTb(this)">编辑</a>'
		+ '&nbsp;&nbsp;<a href="javascript:void(0)" onclick="deleteTb(this)">删除</a>';
}

function fmtRoles(val,row){
	if (val != null && val != '' ) {
		var arr = val.split(",");
		var str = "";
		var id = null;
		var name = null;
		for (var i = 0;i < arr.length;i++) {
			id = arr[i].split("-")[0];
			name = arr[i].split("-")[1];
			str += '[<a href="javascript:void(0)" id='+id+' onclick="viewRule(this)">'+name+'</a>] ';
		}
		return str;
	}
}

function viewRule(obj){
	var roleId = $(obj).attr("id"); 
	/*$("#tb").empty();
	$.ajax({
		url : 'authSetController/viewRule',
		async : false,
		data : {roleId : roleId},
		success : function(result) {
			var tr = '';
			var rule = '';
			for(var key in result)  {
			    console.log("属性：" + key + ",值："+ result[key]);
			    
			    tr += '<tr><td style="width:25%;text-align:center;">'+key+'</td><td>'+result[key]+'</td></tr>'
			}
			
			$("#tb").append(tr);
			$("#ruleDialog").dialog('open');
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});*/
	$("#ruleFrame").attr('src','authSetController/viewRule?roleId='+roleId);
	$("#ruleDialog").dialog('open');
}