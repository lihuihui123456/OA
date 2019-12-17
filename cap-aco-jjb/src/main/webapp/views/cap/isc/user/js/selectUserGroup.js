$(function() {
	initOrgTreeList();
	findUserGroupList();
});

/**
 * 全局变量
 * 用户组ID ：userGroupId
 * */
var userGroupId = "";
var orgId = '111';

/**
 * 初始化加载左侧树
 * @author 王建坤
 */
function initOrgTreeList() {
	$('#org_tree_list').tree({
		url : "orgController/findUnSealedChildrenNodesByIdUnderUserId",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		onClick : function(node) {
			orgId = node.id;
			orgName = node.text;
			// 点击某一注册系统时，加载对应系统下的模块
			$('#org_tree_list').tree('expand', node.target);
			$('#userGroupList').datagrid('clearChecked');
			findUserGroupList();
		}
		/*,
		onLoadSuccess : function (){
			$('#org_tree').tree('expandAll');
		}*/
	});
}

/**
 * 单位查询
 * @author 王建坤
 * */
function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#org_tree_list").tree('search',searchValue);
}

/**
 * 清空单位查询框
 * @author 王建坤
 * */
function clearOrgSearchBox(){
	$("#search").searchbox("setValue","");
	$("#org_search").searchbox("setValue","");
}

/**
 * 查询用户组列表
 * 
 */
function findUserGroupList() {
	var url = "userGroupController/findByCondition";
	$('#userGroupList').datagrid({
		url : url,
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		method : 'POST',
		idField : 'userGroupId',
		striped : true,
		queryParams:{
			orgId : orgId
		},
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
 		    { field : 'userGroupId', title : '用户组ID', hidden:true }, 
 		    { field : 'userGroupName', title : '用户组名称', width : 150, align : 'left' }, 
 		    { field : 'userGroupCode', title : '用户组编码', width : 150, align : 'left' }, 
 		    { field : 'userGroupDesc', title : '用户组描述', width : 150, align : 'left' },
 		    { field : 'createTime', title : '创建时间', width : 150, align : 'left' ,
 		    	formatter:function(value,row){
 		    		return value.substring(0,19);
 		    	}
 		    }
 		] ],
		onClickRow: function(index,row){
			//cancel all select
			$('#userGroupList').datagrid("clearChecked");
			//check the select row
			$('#userGroupList').datagrid("checkRow", index);
		}
	});
}
/**
 * 条件查询
 */
function findByCondition() {
	$('#userGroupList').datagrid({
		url : "userGroupController/findByCondition",
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams : {
			searchValue : $("#search").searchbox('getValue'),
			orgId : orgId
		}
	});
	$('#userGroupList').datagrid('clearSelections'); // 清空选中的行
}

function doSaveMessage(){
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

	var arr=new Array();
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

	var arr=new Array();
	arr[0]=ids;
	arr[1]=names;
	return arr;
}