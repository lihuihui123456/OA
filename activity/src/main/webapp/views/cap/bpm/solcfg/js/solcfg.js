/**
 * 页面初始化时加载相关函数
 */
$(function() {
	initBpmSysTree();
	initModuleTreeGrid("0");
});

/** 全局变量，系统ID */
var sysRegId = "";
/** 全局变量，流程模块绑定ID */
var procdsgnCtlgId = '';

/**
 * 初始化加载左侧系统注册树
 * 
 */
function initBpmSysTree() {
	$('#bpm_sys_tree').tree({
		url : '../solutionCfgController/findAllBpmSys',
		animate : true,
		checkbox : false,
		onlyLeafCheck : true,
		onClick : function(node) {
			sysRegId = node.id;
			if (sysRegId == "999") {
				return;
			}
			// 点击某一注册系统时，加载对应系统下的模块
			initModuleTreeGrid(sysRegId);
			//清空资源列表
			$('#resc_datagrid').datagrid('loadData', { total: 0, rows: [] });
		}
	});
}
/**
 * 初始化模块列表树
 * 
 * @param sysRegId 注册系统ID
 * @param 无
 */
function initModuleTreeGrid() {
	$('#module_treegrid').treegrid({
		url : '../solutionCfgController/findBySysRegId',
		queryParams:{
			sysRegId:sysRegId
		},
		method : 'POST',
		idField : 'id',
		treeField : 'text',
		striped : true,
		fitColumns : true,
		singleSelect : true,
		selectOnCheck : false,
		checkOnSelect : false,
		rownumbers : true,
		pagination : false,
		nowrap : false,
		columns : [[ 
			{ field : 'ck',checkbox : true}, 
			{ field : 'id',  title : '模块ID',hidden : true}, 
			{ field : 'parent_id',  title : '父模块ID',hidden : true},
			{ field : 'iconCls',  title : '图标',hidden : true},
			{ field : 'id_',  title : '操作', width : 40,formatter: formatterOpert},
			{ field : 'text',title : '模块名称', width : 180,align : 'left'},
			{ field : 'url',title : '模块链接', width : 180,align : 'left'},
			{ field : 'solName',title : '流程解决方案名称', width : 260,align : 'left'},
			{ field : 'isVrtlNode', title : '虚拟节点',  width : 80, align : 'left',
				formatter : function(value) {
					if (value == "Y") {
						return "是";
					} else {
						return "否";
					}
				},hidden:true
			}
		] ],
		onClickRow : function(row){
			var data = $('#module_treegrid').datagrid('getSelections');
			if (data) {
				if (data.length > 1 || data.length == 0) {
					$('#resc_datagrid').datagrid('loadData', { total: 0, rows: [] });
				} else {
					/*如果是虚拟节点，不刷新资源列表*/
					if (data[0].isVrtlNode == "Y") {
						return;
					}
					//全局变量，模块ID，在resource.js中定义
					moduleId = data[0].id;
					reloadResourceList();
				}
			}
		}
	});
}



/**
 * 打开添加模块窗口
 */
function addModule() {
	if (sysRegId == "") {
		$.messager.alert('提示', '请选择注册系统！', 'info');
	} else {
		$("#addForm").form("clear");
		$("#isVrtlNodeN").prop("checked","checked");
		$("#isAudiY").prop("checked","checked");
		$("#isContrY").prop("checked","checked");
		/*判断原来是否为虚拟节点，如果是则链接不可编辑*/
		if ($("#isVrtlNodeY").is(":checked")) {
			$("#modurl").textbox({"readonly" : true});
		} else {
			$("#modurl").textbox({"readonly" : false});
		}
		disableAddUrl();
		$('#addDialog').dialog('open');
		$("#sys_id").val(sysRegId);
		createParentData(0);
	}
}

/**
 * 加载父级节点数据
 * 
 * @param 新增：0
 *        修改：1
 */
function createParentData(type) {
	$.ajax({
		type : "post",
		url : "../moduleController/findBySysRegId",
		data : {
			sysRegId : sysRegId
		},
		async : false,
		dataType : "json",
		success : function(data) {
			if (type == 0) {
				$("#addCombobox").combotree("loadData", data);
			} else {
				$("#modCombobox").combotree("loadData", data);
			}
		}
	});
}

/**
 * 绑定添加模块窗口中模块链接是否可编辑，是否虚拟：是（不可编辑），否（可编辑）
 * */
function disableAddUrl(){
	$("#isVrtlNodeY").click(function(){
		$("#modurl").textbox("setValue","------");
		$("#modurl").textbox({"readonly" : true});
		$("#isAudiN").prop("checked","checked");
		$("#isContrN").prop("checked","checked");
	});
	$("#isVrtlNodeN").click(function(){
		$("#modurl").textbox("setValue","");
		$("#modurl").textbox({"readonly" : false});
		$("#isAudiY").prop("checked","checked");
		$("#isContrY").prop("checked","checked");
	});
}

/**
 * 保存模块
 */
function doSave(){
	if (!$("#addForm").form('validate')) {
		return;
	}
	$.ajax({
		url : '../moduleController/doSaveModule',
		type : 'post',
		data : $("#addForm").serialize(),
		success : function(data){
			$.messager.show({ title:'提示', msg:'保存成功', showType:'slide' });
			$('#addDialog').dialog('close');
			reload(sysRegId);
		}
	});
}

/**
 * 重新加载模块树
 */
function reload() {
	$('#module_treegrid').treegrid('reload', {
		"sysRegId" : sysRegId
	});
}

/**
 * treegrid操作按钮
 */
function formatterOpert (val, row, index){
	return '<table border="0" width="100%"><tr>'
			+'<td><img src="views/cap/bpm/bizsolmgr/img/edit.png" title="编辑" onclick="imgClick(\''+index+'\',\'update\')"/></td>'
			+'<td><img src="views/cap/bpm/bizsolmgr/img/remove.png" title="删除" onclick="imgClick(\''+index+'\',\'delete\')"/></td>'
			+'</tr></table>';
}

/**
 * 操作单元格图标点击事件
 * @param index 所点击的图标所在行索引
 * @param action 动作标识 detial： 打开明细弹窗 update:打开修改弹窗 
 * 				 	   delete：执行删除操作
 */
function imgClick(index, action){
	$('#bizSolInfoList').datagrid('clearSelections'); //清空选中的行
	$('#bizSolInfoList').datagrid('selectRow', index); //根据行索引选中一行
	
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	if(action == 'update'){
		update();
	}else if(action == 'delete'){
		delele();
	}
}

/**
 * 打开流程定义基本信息修改弹窗
 */
function selectBizSol(){
	var data = $('#module_treegrid').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('提示', '请选择单行记录修改！','info');
			return;
		}
		var modelId = data[0].id;
		var src = 'solutionCfgController/selectBizSol?modelId='+modelId;
		$('#iframe').attr('src', src);
		$('#bizSolDlg').dialog({    
		    title: '选择应用模型',
		    width: 800,
		    height: 500,
		    cache: false,
		    closed : false
		}); 
	}
}