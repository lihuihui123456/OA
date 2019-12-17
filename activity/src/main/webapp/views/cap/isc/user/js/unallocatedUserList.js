$(function() {
	findUserList();
});

/**
 * 加载未分配用户列表信息
 * 
 */
function findUserList() {
	var url = "UnallocatedUserController/findUserList";
	$('#userList').datagrid('reload',url);
}

/**
 * 分配用户
 */
function doAssignedUser() {
	var selecteds = $('#userList').datagrid('getChecked');
	if (selecteds == null || selecteds.length == 0) {
		layer.tips('请选择操作项', '#btn_user_assigned', { tips: 1 });
		return;
	}
	$('#orgName').combotree('loadData',[]);
	$('#deptName').combotree('loadData',[]);
	$('#postName').combobox('loadData',[]);
	$('#userDialog').dialog("open");
	$('#userForm').form('clear');
	
	var ids = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].userId + ",";
	});
	ids = ids.substring(0, ids.length - 1);
	$('#ids').val(ids);
	
	//部门岗位下拉
	initOrgTree();
}

/**
 * 加载单位树
 */
function initOrgTree(){
	$("#orgName").combotree({
		url:'UnallocatedUserController/findOrgTree',
		onlyLeafCheck : false,
		cascadeCheck : false,
		onSelect:function(node) {
			$('#orgCode').val(node.attributes.orgCode);
			$('#postName').combobox('setValue',"");
			initDeptTree(node.id);
		}
	});
	refuseBackspace('orgName');
}

/**
 * 加载部门树
 * 
 */
function initDeptTree(id){
	$("#deptName").combotree({
		url:'UnallocatedUserController/findDeptTree',
		queryParams:{
			orgId : id
		},
		onSelect : function(node) {
			$('#deptCode').val(node.attributes.deptCode);
			setPostData(node.id);
		}
	});
	refuseBackspace('deptName');
}

/**
 * 加载岗位
 * 
 */
function setPostData(id){
	$('#postName').combobox({
		url: "UnallocatedUserController/findBydeptId?id=" + id,
        valueField:'id',
        textField:'text',
        onSelect : function(node) {
			$('#postCode').val(node.attributes.postCode);
		}
    });
	refuseBackspace('postName');
}

/**
 * 保存操作
 * 
 */
function doSaveUnallocatedUser(){
	if (!$("#userForm").form('validate')) {
		return;
	}
	var ids = $('#ids').val();
	var orgId = $('#orgName').combobox('getValue');
	var orgName = $('#orgName').combobox('getText');
	var orgCode = $('#orgCode').val();
	var deptId = $('#deptName').combobox('getValue');
	var deptName = $('#deptName').combobox('getText');
	var deptCode = $('#deptCode').val();
	var postId = $('#postName').combobox('getValue');
	var postName = $('#postName').combobox('getText');
	var postCode = $('#postCode').val();

	$.ajax({
		url : "UnallocatedUserController/doSaveUnallocatedUser",
		type : "post",
		async : false,
		data : {
			ids : ids,
			orgId : orgId,
			orgName : orgName,
			orgCode : orgCode,
			deptId : deptId,
			deptName : deptName,
			deptCode : deptCode,
			postId : postId,
			postName : postName,
			postCode : postCode
		},
		success : function(data) {
			if(data="true"){
				$('#userDialog').dialog('close');
				$.messager.show({ title:'提示', msg:'保存成功！', showType:'slide' });
				$('#userList').datagrid('load');
				$('#userList').datagrid('clearSelections'); // 清空选中的行
			}else{
				$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
			}
		}
	});
	
}

function clearSearchBox() {
	$("#search").searchbox("setValue","");
	 findByCondition();
}

/*
 * 解决IE8不支持trim函数去除空格的问题
 */
String.prototype.trim = function() {
	return this.replace(/(^\s*)|(\s*$)/g, "");
}

/**
* 查询操作
*/
function findByCondition() {
	var searchValue = $("#search").val().trim();
	if(searchValue == null){
		return;
	}
	var url = "UnallocatedUserController/findByCondition?searchValue="+searchValue;
	$('#userList').datagrid('reload',url);
}