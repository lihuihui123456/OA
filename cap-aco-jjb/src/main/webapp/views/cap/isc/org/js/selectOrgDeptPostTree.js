/**
 * 页面初始化时加载相关函数
 */
$(function() {
	// 初始化单位树
	initDeptTree();
});

function getTreeNode(){
	var node = $('#org_dept_post_tree').tree('getSelected');
	
	return node.id + "," +node.text;
}

/**
 * 初始化加载左侧单位树（单位+部门）
 * 
 * @param 无
 * @return 无
 */
function initDeptTree() {
	$('#org_dept_post_tree').tree({
		url : "orgController/findUnsealedChildOrgDeptPostTreeAsync",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		//formatter : formaterNodeCount,
		onClick : function(node) {
			//展开点击选中的节点
			$('#org_dept_post_tree').tree('expand', node.target)
		}
	});
}