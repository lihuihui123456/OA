/**
 * 页面初始化时加载相关函数
 */
$(function() {
	// 初始化单位树
	initDeptTree();
});

function doSaveMessage(){
	var node = $('#dept_post_tree').tree('getSelected');
	if(node.dtype != '2'){
		$.messager.alert('提示', '请选择岗位！', 'info');
		return ;
	}else{
		var arr=new Array();
		arr[0]=node.id;
		arr[1]=node.text;
		return arr;
	}
}

function doSaveData(){
	var node = $('#dept_post_tree').tree('getSelected');
	if(node.dtype != '2'){
		$.messager.alert('提示', '请选择岗位！', 'info');
		return ;
	}else{
		var arr=new Array();
		arr[0]=node.id;
		arr[1]=node.text;
		return arr;
	}
}

/**
 * 初始化加载左侧单位树（单位+部门）
 * 
 * @param 无
 * @return 无
 */
function initDeptTree() {
	$('#dept_post_tree').tree({
		url : "orgController/findUnsealedChildOrgDeptPostTreeAsync",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		//formatter : formaterNodeCount,
		onClick : function(node) {
			//展开点击选中的节点
			$('#dept_post_tree').tree('expand', node.target)
		}
	});
}