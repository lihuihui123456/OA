$(function() {
	// 初始化单位树
	initDeptTree();
	$('#dtlist').datagrid({
		onClickRow: function(index,row){
			//cancel all
			$('#dtlist').datagrid("clearChecked");
			//check the select row
			$('#dtlist').datagrid("selectRow", index);
		}
	});
});

var nodeid = "";
/**
 * 初始化加载左侧单位树（单位+部门+表单）
 * 
 * @param 无
 * @return 无
 */
function initDeptTree() {
	$('#doc_num_tree').tree({
		url : "docNumMgrController/findAllDocType",
		animate : true,//开启折叠动画
		checkbox : false,
		onlyLeafCheck : true,
		//树加载成功后回调函数（用于初始化列表）
		onClick : function(node) {
			//展开点击选中的节点
			$('#doc_num_tree').tree('expand', node.target)
			// 点击单位节点时，加载单位下的所有部门
			var node = $('#doc_num_tree').tree('getSelected');
			findByDeptId(node.id);
		}
	});
}

function findByDeptId(dept_id) {
	$('#dtlist').datagrid({
		url : 'docNumMgrController/findAllDocList',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		method : 'POST',
		idField : 'serial_id',
		treeField : 'serial_id',
		striped : true,
		fitColumns : true,
		singleSelect : true,
		rownumbers : true,
		pagination : true,
		fit : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		queryParams:{
			dept_id:dept_id
		},
		columns : [ [ 
		    { field : 'ck', checkbox : true }, 
		    { field : 'serial_id', title : 'serial_id', hidden : true },
		    { field : 'dept_id', title : 'dept_id', hidden : true },
		    { field : 'serial_number_name', title : '文号名称', width : 200, align : 'left'},
		    { field : 'preview_effect', title : '预览效果', width : 200, align : 'left'},
		    { field : 'enable', title : '是否启用', width : 100, align : 'center',
		    	formatter : function(value, row) {
					if (value == 0)
						return '启用';
					if (value == 1)
						return "<span style=\'color:red\'>禁用</span>";
				}
             }
          ] ]
	});
	$('#dtlist').datagrid('load');
	$('#dtlist').datagrid('clearSelections'); // 清空选中的行
}

/**
 * 重新加载接口类型树
 */
function reloadbytype(dept_id) {
	$('#dtlist').datagrid({
		url : 'docNumMgrController/findAllDocList',
		queryParams: {
			'dept_id': dept_id
		}
	});
}
/**
 * 字典数据条件查询
 */
function searchList() {
	var doc_name = $("#doc_name").textbox('getValue');
	var node = $('#doc_num_tree').tree('getSelected');
	if(node==null){
		$.messager.alert('提示', '请选择所属单位！', 'info');
		return ;
	}
	$('#dtlist').datagrid({
		url : "docNumMgrController/findAllDocList",
		queryParams : {
			dept_id : node.id,
			doc_name : doc_name
		}
	});
}

function doSaveSelect(){
	var arr = new Array();
	var data = $('#dtlist').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择数据！');
		return;
	}
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '请选择数据！');
			return;
		}
		arr[0] = data[0].serial_id;
		arr[1] = data[0].serial_number_name;
		}
	return arr;
}