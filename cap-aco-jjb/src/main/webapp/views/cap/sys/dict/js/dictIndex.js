/**
 * 初始化函数
 */
$(function() {
	InitTreeData();
	findListDataById("0");
});


var typeid = "";

/**
 * 初始化加载左侧树
 */
function InitTreeData() {
	$('#tree').tree({
		url : 'dictTypeController/findAllDictType',
		animate : true,
		checkbox : false,
		onlyLeafCheck : true,
		onClick : function(node) {
			$('#tree').tree('expand', node.target);
			typeid = node.id;
			reload(typeid);
		},
		onContextMenu : function(e, node) {
			e.preventDefault();
			$('#tree').tree('select', node.target);
			$('#mm').menu('show', {
				left : e.pageX,
				top : e.pageY
			});
		}
	});
}

/**
 * 增加数据字典数节点
 */
function addNote() {

	$("#dictTypeFlag").textbox('setValue', "");
	$("#dictTypeName").textbox('setValue', "");
	$("#dictTypeDesc").textbox('setValue', "");

	nodeid = '';
	$('#dictTypeDialog').dialog('open');
}

/**
 * 删除数据字典数节点
 */
function delNote() {
	var nodes = $('#tree').tree('getSelected', 'info');
	
	var ids = '';
	if (nodes == null) {
		$.messager.alert('提示', '请选择操作项！', 'info');
		return;
	} else if (nodes.id == '0') {
		$.messager.alert('提示', '父级节点不可删除！', 'info');
		return;
	} else if(!$('#tree').tree('isLeaf',nodes.target)){
		$.messager.alert('提示', '父级节点不可删除！', 'info');
		return;
	}else {
		$.messager.confirm('删除字典类型', '确定删除吗?', function(r) {
			if (r) {
				ids = nodes.id;

				$.post("dictController/findListDataById", {
					"typeid" : ids
				}, function(data) {
					if (data == null || data.total != '0') {
						$.messager.alert('删除接口类型', '此类型下包含接口数据,不可删除')
						return;
					} else {
						$.post("dictTypeController/doDeleteDictType", {
							"ids" : ids
						}, function(data) {
							InitTreeData();
						});
					}
				});
			}
		});
	}
}

var nodeid = "";
/**
 * 修改数据字典数节点
 */
function modNote() {
	var node = $('#tree').tree('getSelected');
	if (node) {
		nodeid = node.id;

		if (nodeid == '0') {
			$.messager.alert('提示', '父级节点不可修改！', 'info');
			return;
		}
		$("#dictTypeFlag").textbox('setValue', node.attributes.dictTypeFlag);
		$("#dictTypeName").textbox('setValue', node.text);
		$("#dictTypeDesc").textbox('setValue', node.attributes.dictTypeDesc);
		$('#dictTypeDialog').dialog({ title : "修改字典类型" });
		$('#dictTypeDialog').dialog('open');
	}
}

/**
 * 保存数据字典数节点
 */
function savetype() {

	if (!$('#typeForm').form('validate')) {
		return;
	}
	var dictTypeFlag = $("#dictTypeFlag").textbox('getValue');
	var dictTypeName = $("#dictTypeName").textbox('getValue');
	var dictTypeDesc = $("#dictTypeDesc").textbox('getValue');
	var url = "";
	if (nodeid == '') {
		url = "dictTypeController/doSaveDictType";
	} else {
		url = "dictTypeController/doUpdateDictType";
	}
	var parentTypeId = null;
	var node = $('#tree').tree('getSelected');
	if (node) {
		parentTypeId = node.id;
	}

	var dicType = {
		dictTypeId : nodeid,
		dictTypeFlag : dictTypeFlag,
		dictTypeName : dictTypeName,
		dictTypeDesc : dictTypeDesc,
		parentTypeId : parentTypeId
	};

	$.ajax({
		url : url,
		type : "POST",
		async : false,
		data : dicType,
		success : function(data) {
			if (data == '1') {
				$.messager.alert('提示', '字典类型名称已存在', 'info');
				$("#dictTypeName").textbox('setValue', '');
				return;
			} else if (data == '2') {
				$.messager.alert('提示', '字典类型标识已存在', 'info');
				$("#dictTypeFlag").textbox('setValue', '');
				return;
			} else {
				$.messager.alert('提示', '保存成功', 'info');
				$('#dictTypeDialog').dialog('close');
				InitTreeData();
			}
		}
	});
}

/**
 * 根据字典类型获取字典数据
 */
function findListDataById(id) {
	$('#dictList').datagrid({
		url : 'dictController/findListDataById',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		method : 'POST',
		idField : 'dictId',
		treeField : 'dictId',
		striped : true,
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		fit : true,
		nowrap : false,
		toolbar : '#toolbar1',
		pageSize : 10,
		showFooter : true,
		columns : [ [ {
			field : 'ck',
			checkbox : true
		}, {
			field : 'dictId',
			title : 'dictId',
			hidden : true
		}, {
			field : 'dictVal',
			title : '数据字典值',
			width : 100,
			align : 'left'
		}, {
			field : 'dictCode',
			title : '数据字典编码',
			width : 120,
			align : 'left'
		} , {
			field : 'dictName',
			title : '数据字典简拼',
			width : 120,
			align : 'left'
		} ] ],
		onClickRow: function(index,row){
			//cancel all select
			$('#dictList').datagrid("clearChecked");
			//check the select row
			$('#dictList').datagrid("selectRow", index);
		}
	});
}

/**
 * 重新加载字典类型树
 */
function reloadbytype(typeid) {
	$('#dictList').datagrid('reload', {
		"typeid" : typeid
	});
}

/**
 * 增加字典数据
 */
function addData() {
	id = '';
	if (typeid == "") {
		//$.messager.alert('提示', '请选字典类型！', 'info');
		layer.tips('请选字典类型', '#btn_add', { tips: 3 });
	} else {
		var node = $('#tree').tree('getSelected');
		if (node) {
			if(!$('#tree').tree('isLeaf',node.target)){
				$.messager.alert('提示', '请选择子节点增加！', 'info');
				return;
			}
		}
		
		$("#dictCode").textbox('setValue', "");
		$("#dictName").textbox('setValue', "");
		$("#dictVal").textbox('setValue', "");
		$('#dictDialog').dialog('open');
	}
}

/**
 * 删除字典数据
 */
function delData() {
	var selecteds = $('#dictList').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择操作项！', 'info');
		layer.tips('请选择操作项', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除接口数据', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].dictId + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'dictController/doDeleteDict',
				dataType : 'json',
				data : {
					ids : ids
				},
				success : function(result) {
					var msg = result;
					$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
					reloadbytype(typeid);
					$('#dictList').datagrid('clearSelections'); // 清空选中的行
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
				}
			});
		}
	});
}

var id = '';
var sort = '';
/**
 * 修改字典数据
 */
function modData() {
	var data = $('#dictList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行进行修改！', 'info');
			layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
			return;
		}
		id = data[0].dictId;
		sort = data[0].sort;
		$("#dictCode").textbox('setValue', data[0].dictCode);
		$("#dictName").textbox('setValue', data[0].dictName);
		$("#dictVal").textbox('setValue', data[0].dictVal);
		$('#dictDialog').dialog({ title : "修改字典" });
		$('#dictDialog').dialog('open');
	}
}

/**
 * 保存字典数据
 */
function saveData() {

	if (!$('#dictForm').form('validate')) {
		return;
	}
	var dictCode = $("#dictCode").textbox('getValue');
	var dictName = $("#dictName").textbox('getValue');
	var dictVal = $("#dictVal").textbox('getValue');

	var url = "";
	if (id == '') {
		url = "dictController/doSaveDict";
	} else {
		url = "dictController/doUpdateDict";
	}
	var dicInfo = {
		dictId : id,
		sort : sort,
		dictCode : dictCode,
		dictName : dictName,
		dictVal : dictVal,
		dictTypeId : typeid
	};
	$.ajax({
		url : url,
		type : "post",
		data : dicInfo,
		success : function(data) {
			if (data == '1') {
				$.messager.alert('提示', '数据字典值已存在', 'info');
				$("#dictVal").textbox('setValue', '');
				return;
			} else if (data == '2') {
				$.messager.alert('提示', '数据字典编码已存在', 'info');
				$("#dictCode").textbox('setValue', '');
				return;
			} else {
				$.messager.show({ title:'提示', msg:'保存成功', showType:'slide' });
				$('#dictDialog').dialog('close');
				reload(typeid);
			}
		}
	});
}

/**
 * 字典数据条件查询
 */
function searchList() {
	var dict_name = $("#dict_name").textbox('getValue');
	$('#dictList').datagrid({
		url : "dictController/findListDataById",
		queryParams : {
			dict_name : dict_name,
			typeid : typeid,
			date : new Date()
		}
	});
}

/**
 * 重新加载字典数据列表
 */
function reload() {
	$('#dictList').datagrid('clearChecked');
	$('#dictList').datagrid('reload', {
		"typeid" : typeid
	});
}

/**
 * 上移操作
 */
function doUpSort() {
	var id = 0;
	var data = $('#dictList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行记录上移！', 'info');
		layer.tips('请选择一行记录上移', '#upsort', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行记录上移！', 'info');
			layer.tips('请选择一行记录上移', '#upsort', { tips: 3 });
			return;
		}
		id = data[0].dictId;
		$.ajax({
			url : 'dictController/doUpSort',
			dataType : 'json',
			data : {
				id : id,
				typeid : typeid
			},
			success : function(result) {
				reload(typeid);
			},
			error : function(result) {
			}
		});
	}
}

/**
 * 下移操作
 */
function doDownSort() {
	var data = $('#dictList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行记录下移！', 'info');
		layer.tips('请选择一行记录下移', '#downsort', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行记录下移！', 'info');
			layer.tips('请选择一行记录下移', '#downsort', { tips: 3 });
			return;
		}
		id = data[0].dictId;
		$.ajax({
			url : 'dictController/doDownSort',
			dataType : 'json',
			data : {
				id : id,
				typeid : typeid
			},
			success : function(result) {
				reload(typeid);
			},
			error : function(result) {
			}
		});
	}
}

/**
 * 验证字典code是否存在
 * 
 * function validCodeExist(){ var dictCode = $("#dictCode").textbox('getValue');
 * if(dictCode==''){ return false; } $.ajax({ url :
 * 'dictController/getDictByCode', dataType : 'json', data : { dictCode :
 * dictCode }, success : function(result) {
 * 
 * alert(result); if(result == 1){ $.messager.alert('添加字典', "字典编码已存在！");
 * $("#dictCode").textbox('setValue',''); ret = '1';
 * //$("#dictForm").form('validate'); }else{ ret = '0'; } }, error :
 * function(result) { $.messager.alert('添加字典', "字典编码验证失败！"); } }); }
 */

function clearSearchBox(){
	$("#dict_name").searchbox("setValue","");
	$("#org_search").searchbox("setValue","");
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#tree").tree('search',searchValue);
}