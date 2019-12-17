/**
 * 页面初始化时加载相关函数
 */
$(function() {
	// 初始化单位树
	initDeptTree();
});

function doSaveMessage(){
	var node = $('#org_dept_tree').tree('getSelected');
	if(node.dtype=='0'){
		$.messager.alert('提示', '请选择部门！', 'info');
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
	$('#org_dept_tree').tree({
		url : "orgController/findUnsealedChildOrgDeptTreeAsync",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		//formatter : formaterNodeCount,
		onClick : function(node) {
			//展开点击选中的节点
			$('#org_dept_tree').tree('expand', node.target);
			// 点击单位节点时，加载单位下的所有部门
//			var node = $('#org_dept_tree').tree('getSelected');
//			if(node.dtype == null || node.dtype != '1'){
//				return ;
//			}
			//findByDeptId(node.id);
		}
	});
}