$(function() {
	initOrgTree();
	initRoleList();
	//initUserListByOrgId();
});

var orgId = '';
var orgName = '';
var roleId = '';
/**
 * 初始化加载左侧树
 */
function initOrgTree() {
	$('#org_tree').tree({
		url : "orgController/findUnSealedChildrenNodesByIdUnderUserId",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		onClick : function(node) {
			orgId = node.id;
			orgName = node.text;
			// 点击某一注册系统时，加载对应系统下的模块
			$('#org_tree').tree('expand', node.target);
			$('#roleList').datagrid('clearChecked');
			//initRoleList();
			reload();
		}
		/*,
		onLoadSuccess : function (){
			$('#org_tree').tree('expandAll');
		}*/
	});
}

/**
 * 加载角色列表
 */
function initRoleList() {
	$('#roleList').datagrid({
		method : 'POST',
		idField : 'roleId',
		striped : true,
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams:{
			orgId : orgId
		},
		fitColumns : true,
		fit: true,
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', checkbox : true }, 
		   { field : 'roleId', title : 'roleId', hidden : true }, 
		   { field : 'roleName', title : '角色名称', width : 100, align : 'left' },
		   { field : 'roleEname', title : '角色英文名', width : 100, align : 'left' },
		   { field : 'roleCode', title : '角色编码', width : 80, align : 'left' },
		   { field : 'createTime', title : '创建时间', width : 120, align : 'left' },
		   { field : 'roleDesc', title : '角色描述', width : 150, align : 'left'}
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#roleList').datagrid("clearChecked");
			//check the select row
			$('#roleList').datagrid("selectRow", index);
		}
	});
}

/**
 * 重新加载列表
 */
function reload() {
	var url = 'roleController/findByCondition';
	$('#roleList').datagrid({
		url : url,
		queryParams:{
			orgId : orgId
		}
	});
}

/**
 * 条件查询
 */
function findByCondition(){
	var roleName = $("#search").searchbox('getValue');
	$('#roleList').datagrid({
        url:"roleController/findByCondition",
        queryParams:{
        	orgId : orgId,
        	roleName : roleName,
        	date:new Date()
        }
    });
}

function clearSearchBox(){
	$("#search").searchbox("setValue","");
	$("#org_search").searchbox("setValue","");
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#org_tree").tree('search',searchValue);
}

function doSaveMessage(){
	var selecteds = $('#roleList').datagrid('getSelections');
	
	var ids = '';
	var names = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].roleId + ",";
		names = names + selecteds[index].roleName + ",";
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
	var selecteds = $('#roleList').datagrid('getSelections');
	
	var ids = '';
	var names = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].roleId + ",";
		names = names + selecteds[index].roleName + ",";
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