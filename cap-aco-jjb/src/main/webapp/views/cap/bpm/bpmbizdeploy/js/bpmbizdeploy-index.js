/**
 * 页面初始化时加载相关函数
 */
$(function() {
	initSysRegTree();
	initModuleTreeGrid("0");
	disableAddUrl();
	disableModUrl();
});

/** 全局变量：
 *  系统ID ：sysRegId
 *  链  接 ：moduleUrl
 *  移动的模块ID ：moveModId
 * */
var sysRegId = "";
var moduleUrl = "";
var moveModId = "0";
/**
 * 初始化加载左侧系统注册树
 * 
 * @param 无
 * @returns 无
 */
function initSysRegTree() {
	$('#sys_reg_tree').tree({
		url : '../sysRegController/findAllSysReg',
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
			//清除模块选中状态
			$('#module_treegrid').treegrid('clearChecked');
		}
	});
}

/**
 * 初始化模块列表树
 * 
 * @param sysRegId 注册系统ID
 * @param 无
 */
function initModuleTreeGrid(sysRegId) {
	$('#module_treegrid').treegrid({
		url : '../bpmBizDeployController/findBySysRegId',
		queryParams:{
			sysRegId:sysRegId
		},
		method : 'POST',
		idField : 'id',
		treeField : 'text',
		striped : true,
		fitColumns : true,
		singleSelect : true,
		selectOnCheck : true,
		checkOnSelect : true,
		rownumbers : true,
		pagination : false,
		nowrap : false,
		columns : [[ 
			{ field : 'ck',checkbox : true}, 
			{ field : 'id',  title : '模块ID',hidden : true}, 
			{ field : 'parent_id',  title : '父模块ID',hidden : true},
			{ field : 'iconCls',  title : '图标',hidden : true},
			{ field : 'text',title : '模块名称', width : 180,align : 'left'},
			{ field : 'url',title : '模块链接', width : 260,align : 'left'},
			{ field : 'isVrtlNode', title : '虚拟节点',  width : 80, align : 'left', formatter : formatIsVrtlNode },
			{ field : 'isAudi', title : '审计', width : 80, align : 'left', formatter : formatIsAudi },
			{ field : 'isContr', title : '监控性能', width : 80, align : 'left', formatter : formatIsContr },
			{ field : 'operate', title : '操作', width : 100, align : 'center', formatter : formatOperate }
		] ],
		onClickRow : function(row){
			$('#module_treegrid').treegrid('expand',row.id);
			var data = $('#module_treegrid').datagrid('getSelections');
			if (data) {
				if (data.length > 1 || data.length == 0) {
					$('#resc_datagrid').datagrid('loadData', { total: 0, rows: [] });
				} else {
					/*如果是虚拟节点，不刷新资源列表*/
					if (data[0].isVrtlNode == "Y") {
						$('#resc_datagrid').datagrid('loadData', { total: 0, rows: [] });
						return;
					}
					//全局变量，模块ID，在resource.js中定义
					moduleId = data[0].id;
					//清除资源选中状态
					$('#resc_datagrid').datagrid('clearChecked');
					reloadResourceList();
				}
			}
		},
		onLoadSuccess: function (row,data) {
			$('#module_treegrid').treegrid('collapseAll');
			$('#module_treegrid').treegrid('expand',moveModId);
			moveModId = "0";
		}
	});
}

/**
 * 重新加载模块树
 * @param sysRegId 系统ID
 * @param modId 当前操作的模块
 */
function reload(sysRegId) {
	$('#module_treegrid').treegrid('reload', {
		"sysRegId" : sysRegId
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
		if ($("#isVrtlNodeN").is(":checked")) {
			$("input",$("#modurl").next("span")).attr("onclick","selectBizSol('modurl');");
		} 
		$('#addDialog').dialog('open');
		$("#sys_id").val(sysRegId);
		createParentData(0);
		//选中仅一个模块时，将该模块带入添加弹出框中的父节点中
		var data = $('#module_treegrid').datagrid('getChecked');
		if (data != null && data.length == 1) {
			if ("Y" == data[0].isVrtlNode) {
				var id = data[0].id;
				$("#addCombobox").combotree("setValue",id);
				var t = $("#addCombobox").combotree("tree");
				var node = t.tree("getSelected");
				//此节点到根节点全部展开
				t.tree("expandTo",node.target);
			}
		}
	}
}

/**
 * 保存模块
 */
function doSave(){
	if (!$("#addForm").form('validate')) {
		return;
	}
	$.ajax({
		url : '../bpmBizDeployController/doSaveModule',
		type : 'post',
		dataType : 'text',
		data : $("#addForm").serialize(),
		success : function(data){
			if(data == 'Y') {
				$.messager.show({ title:'提示', msg:'保存成功', showType:'slide' });
				$('#addDialog').dialog('close');
				reload(sysRegId);
			} else {
				$.messager.show({ title:'提示', msg:'保存失败', showType:'slide' });
			}
		}
	});
}

/**
 * 删除功能
 */
function delModule() {
	var selecteds = $('#module_treegrid').treegrid('getChecked');
	if (selecteds == null || selecteds.length == 0) {
		$.messager.alert('提示', '请选择操作项！', 'info');
		return;
	}
	for ( var i = 0; i < selecteds.length; i++) {
		var isVrtlNode = selecteds[0].isVrtlNode;
		if (isVrtlNode == "Y") {
			var children = $('#module_treegrid').treegrid("getChildren",selecteds[0].id);
			if (children != null && children.length > 0) {
				$.messager.alert('提示', '请先删除子节点！', 'info');
				return;
			}
		}
	}
	$.messager.confirm('删除接口数据', '确定删除吗?', function(r) {
		if (r) {
			var ids = [];
			$(selecteds).each(function(index) {
				ids[index] = selecteds[index].id;
			});

			$.ajax({
				url : '../bpmBizDeployController/doDeleteModuleEntitys',
				dataType : 'text',
				data : {ids : ids},
				success : function(data) {
					if(data == 'Y') {
						$.messager.show({ title:'提示', msg:'删除成功了', showType:'slide' });
						$('#module_treegrid').datagrid('clearChecked');
						reload(sysRegId);
					} else {
						$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
					}
				},
				error : function(data) {
					$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 打开修改模块窗口
 */
function modModule(){
	var data = $('#module_treegrid').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行修改！', 'info');
		return;
	}
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '请选择一行进行修改！', 'info');
			return;
		}
		$("#modifyForm").form("clear");
		createParentData(1);
		$('#modifyDialog').dialog('open');
		$("#isVrtlNode0N").prop("disabled",false);
		var module = data[0];
		$("#mod_id").val(module.id);
		$("#mod_name").textbox('setValue',module.text);
		$("#mod_url").textbox('setValue',module.url);
		$("#mod_icon").textbox("setValue",module.iconCls);
		$("#modCombobox").combotree("setValue", module.parent_id);
		$("#isVrtlNode0"+module.isVrtlNode).prop("checked","checked");
		$("#isAudi0"+module.isAudi).prop("checked","checked");
		$("#isContr0"+module.isContr).prop("checked","checked");
		/*判断原来是否为虚拟节点，如果是则链接不可编辑*/
		if ($("#isVrtlNode0Y").is(":checked")) {
			$("input",$("#mod_url").next("span")).attr("onclick","");
			//如果节点下有子节点，则不能修改‘是否虚拟节点’
			var children = $('#module_treegrid').treegrid("getChildren",module.id);
			if (children != null && children.length > 0) {
				$("#isVrtlNode0N").prop("disabled",true);
			}
		} else {
			$("input",$("#mod_url").next("span")).attr("onclick","selectBizSol('mod_url');");
		}
	}
}

/**
 * 修改模块
 */
function doModify(){
	if (!$("#modifyForm").form('validate')) {
		return;
	}
	$.ajax({
		url : '../bpmBizDeployController/doUpdateModuleEntity',
		type : 'post',
		dataType : 'text',
		data : $("#modifyForm").serialize(),
		success : function(data){
			if(data == 'Y') {
				$.messager.show({ title:'提示', msg:'修改成功', showType:'slide' });
				$('#modifyDialog').dialog('close');
				reload(sysRegId);
			} else {
				$.messager.show({ title:'提示', msg:'修改失败', showType:'slide' });
			}
		}
	});
}

/**
 * 加载父级节点数据
 * 
 * @param 新增：0
 *            修改：1
 */
function createParentData(type) {
	$("#addCombobox").combotree("loadData","");
	$.ajax({
		type : "post",
		url : "../moduleController/findVrtlNodeBySysRegId",
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
		moduleUrl = $("#modurl").textbox("getValue");
		$("#modurl").textbox("setValue","/");
		$("input",$("#modurl").next("span")).removeAttr("onclick");
		$("#isAudiN").prop("checked","checked");
		$("#isContrN").prop("checked","checked");
	});
	$("#isVrtlNodeN").click(function(){
		$("#modurl").textbox("setValue",moduleUrl);
		$("input",$("#modurl").next("span")).attr("onclick","selectBizSol('modurl');")
		$("#isAudiY").prop("checked","checked");
		$("#isContrY").prop("checked","checked");
	});
}

/**
 * 绑定修改模块窗口中模块链接是否可编辑，是否虚拟：是（不可编辑），否（可编辑）
 * */
function disableModUrl(){
	$("#isVrtlNode0Y").click(function(){
		moduleUrl = $("#mod_url").textbox("getValue");
		$("#mod_url").textbox("setValue","/");
		$("input",$("#mod_url").next("span")).removeAttr("onclick");
		$("#isAudi0N").prop("checked","checked");
		$("#isContr0N").prop("checked","checked");
	});
	$("#isVrtlNode0N").click(function(){
		$("#mod_url").textbox("setValue",moduleUrl);
		$("input",$("#mod_url").next("span")).attr("onclick","selectBizSol('mod_url');");
		$("#isAudi0Y").prop("checked","checked");
		$("#isContr0Y").prop("checked","checked");
	});
}

/**
 * 上移
 * @author 王建坤
 * @param modId 模块ID
 * @param parentId 父节点ID
 */
function doUpSort(modId,parentId){
	$.ajax({
		type : 'post',
		url : '../moduleController/doUpSort',
		data : {
			modId : modId,
			parentId : parentId,
			sysRegId : sysRegId
		},
		dataType : 'json',
		success : function(data) {
			if (data.success) {
				$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
				reload(sysRegId);
				var modId = data.modId;
				var parentNode = $('#module_treegrid').treegrid('getParent',modId);
				moveModId = parentNode.id;
			}
		}
	});
}

/**
 * 下移
 * @author 王建坤
 * @param modId 模块ID
 * @param parentId 父节点ID
 */
function doDownSort(modId,parentId){
	$.ajax({
		type : 'post',
		url : '../moduleController/doDownSort',
		data : {
			modId : modId,
			parentId : parentId,
			sysRegId : sysRegId
		},
		dataType : 'json',
		success : function(data) {
			reload(sysRegId);
			var modId = data.modId;
			var parentNode = $('#module_treegrid').treegrid('getParent',modId);
			moveModId = parentNode.id;
		}
	});
}

/**
 * 查询条件
 * */
function findByModuleName() {
	var url = "";
	var moduleName = $("#search").searchbox('getValue');
	if ($.trim(moduleName) == '') {
		url = "../bpmBizDeployController/findBySysRegId";
		$('#module_treegrid').treegrid({
			url : url,
			queryParams : {
				sysRegId : sysRegId,
			},
			columns : [[ 
			            { field : 'ck',checkbox : true}, 
			            { field : 'id',  title : '模块ID',hidden : true}, 
			            { field : 'parent_id',  title : '父模块ID',hidden : true},
			            { field : 'iconCls',  title : '图标',hidden : true},
			            { field : 'text',title : '模块名称', width : 180,align : 'left'},
			            { field : 'url',title : '模块链接', width : 260,align : 'left'},
			            { field : 'isVrtlNode', title : '虚拟节点',  width : 80, align : 'left', formatter : formatIsVrtlNode },
			            { field : 'isAudi', title : '审计', width : 80, align : 'left', formatter : formatIsAudi },
			            { field : 'isContr', title : '监控性能', width : 80, align : 'left', formatter : formatIsContr },
						{ field : 'operate', title : '操作', width : 100, align : 'center', formatter : formatOperate }
			            ] ]
		});
	} else {
		url = "../bpmBizDeployController/findBySysRegId";
		moduleName = window.encodeURI(window.encodeURI(moduleName));
		$('#module_treegrid').treegrid({
			url : url,
			queryParams : {
				sysRegId : sysRegId,
				moduleName : moduleName
			},
			columns : [[ 
			            { field : 'ck',checkbox : true}, 
			            { field : 'id',  title : '模块ID',hidden : true}, 
			            { field : 'parent_id',  title : '父模块ID',hidden : true},
			            { field : 'iconCls',  title : '图标',hidden : true},
			            { field : 'text',title : '模块名称', width : 180,align : 'left'},
			            { field : 'url',title : '模块链接', width : 260,align : 'left'},
			            { field : 'isVrtlNode', title : '虚拟节点',  width : 80, align : 'left', formatter : formatIsVrtlNode },
			            { field : 'isAudi', title : '审计', width : 80, align : 'left', formatter : formatIsAudi },
			            { field : 'isContr', title : '监控性能', width : 80, align : 'left', formatter : formatIsContr }
			            ] ]
		});
	}
}

/**
 * 打开流程定义基本信息修改弹窗
 */
function selectBizSol(inputId){
	var src = '../bpmBizDeployController/selectBizSol?inputId='+inputId;
	$('#iframe').attr('src', src);
	$('#bizSolDlg').dialog({    
	    title: '选择应用模型',
	    width: 800,
	    height: 500,
	    cache: false,
	    closed : false
	}); 
}

function setUrl(url,inputId) {
	$('#' + inputId).textbox("setValue", url);
}

/*************************** 格式化字段值 ***************************/
/**
 * 格式化是否虚拟节点
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatIsVrtlNode(val, row) {
	if (val == "Y") {
		return "是";
	} else {
		return "否";
	}
}

/**
 * 格式化是否审计
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatIsAudi(val, row) {
	if (val == "Y") {
		return "是";
	} else {
		return "否";
	}
}

/**
 * 格式化是否监控性能
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatIsContr(val, row) {
	if (val == "Y") {
		return "是";
	} else {
		return "否";
	}
}

/**
 * 格式化上移下级操作
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatOperate(val, row) {
	var id = row.id;
	var parentId = row.parent_id;
	return '<img style="cursor:pointer" src="../static/cap/plugins/easyui/themes/icons/up.png" onclick="doUpSort(\''+id+'\',\''+parentId+'\')"/>'
		  +'&nbsp;&nbsp;<img style="cursor:pointer" src="../static/cap/plugins/easyui/themes/icons/down.png" onclick="doDownSort(\''+id+'\',\''+parentId+'\')" />';
}

/*************************** 公共函数 *****************************/
/**
 * 清空查询框值
 * 
 * @param 无
 * @returns 无
 */
function clearSearchBox(){
	 $("#search").searchbox("setValue","");
}