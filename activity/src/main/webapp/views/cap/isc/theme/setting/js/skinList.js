/**
 * 初始化函数
 */
$(function() {
	initSkinList();
});

var skinId = '';
/**
 * 初始化系统主题列表
 * 
 * @param 无
 * @param 无
 */
function initSkinList() {
	$('#skinList').datagrid({
		url : 'skinController/findByCondition',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		method : 'POST',
		idField : 'skinId',
		striped : true,
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		fit: true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', 			width : 50	,		checkbox : true }, 
		   { field : 'skinId', 	title : '皮肤ID', 	hidden : true }, 
		   { field : 'skinName', 	title : '皮肤名称', 	width : 100, 	align : 'left'},
		   { field : 'skinCode',   title : '皮肤编码',	width : 100, 	align : 'left'},
		   { field : 'isValid',     title : '状态',	    width : 100, 	align : 'left',
			    formatter : function(value, row) {
				if (value == 'Y') {
					return '启用';
				}   
				return '禁用';
		   }},
		   { field : 'isDefault',   title : '是否默认',	width : 100, 	align : 'left',
			   formatter : function(value, row) {
				if (value == 'Y') {
					return '是';
				}   
				return '否';
			}}
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#skinList').datagrid("clearChecked");
			//check the select row
			$('#skinList').datagrid("selectRow", index);
		}
	});
}

/**
 * 保存
 */
function doSaveSkin() {
	
	if(!$('#skinForm').form('validate')){
		return;
	}
	
	/*var data = $('#skinList').datagrid('getChecked');
	if (data != '' && data != undefined) {
		skinId = data[0].skinId;
	}*/
	var url = "";
	if (skinId == undefined || skinId == '') {
		url = "skinController/doSaveSkin";
	} else {
		url = "skinController/doUpdateSkin";
	}
	
	var isValid = $("#is_valid").switchbutton("options").checked;
	if (isValid) {
		isValid = "Y";
	} else {
		isValid = "N";
	}
	var isDefault = $("#isDefault").switchbutton("options").checked;
	if (isDefault) {
		isDefault = "Y";
		
		$.messager.confirm('保存', '确定将当前皮肤设为默认吗?', function(r) {
			if (r) {
				$.ajax({
					url : url,
					type : "post",
					async : false,
					data : $('#skinForm').serialize()+"&isValid="+isValid+"&isDefault="+isDefault,
					success : function(data) {
						
						if (data.state == '1') {
							$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
						} else {
							$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
							$('#skinDialog').dialog('close');
							reload();
							initdldata();
						}
					}
				});
			}
		});
	} else {
		isDefault = "N";
		
		$.ajax({
			url : url,
			type : "post",
			async : false,
			data : $('#skinForm').serialize()+"&isValid="+isValid+"&isDefault="+isDefault,
			success : function(data) {
				
				if (data.state == '1') {
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
				} else {
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
					$('#skinDialog').dialog('close');
					reload();
					initdldata();
				}
			}
		});
	}
}

/**
 * 新增
 * 
 * @param 无
 * @param 无
 */
function openForm(title) {
	$('#skinDialog').dialog({
		title : title
	});
	skinId = "";
	initdldata();
	
	$('#skinDialog').dialog('open');
}

/**
 * 修改
 * 
 * @param 无
 * @param 无
 */
function openUpdateForm(title) {
	$('#skinDialog').dialog({
		title : title
	});
	initdldata();
	var data = $('#skinList').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行修改！', 'info');
		return;
	}
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '请选择一行进行修改！', 'info');
			return;
		}
		var skin = data[0];
		skinId = skin.skinId;
		$("#skinName").textbox('setValue',skin.skinName);
		$("#skinCode").textbox('setValue',skin.skinCode);
		
		var isValid = skin.isValid;
		if (isValid == "Y") {
			$("#is_valid").switchbutton("check"); 
		} else {
			$("#is_valid").switchbutton("uncheck"); 
		}
		var isDefault = skin.isDefault;
		if (isDefault == "Y") {
			$("#isDefault").switchbutton("check"); 
		} else {
			$("#isDefault").switchbutton("uncheck"); 
		}
		
		$("#skinId").val(skinId);
		
		$('#skinDialog').dialog('open');
	}
}

/**
 * 删除
 * @param 无
 */
function doDeleteSkin() {
	var selecteds = $('#skinList').datagrid('getChecked');
	if (selecteds == null || selecteds.length == 0) {
		$.messager.alert('提示', '请选择需要删除的记录！', 'info');
		return;
	}
	$.messager.confirm('删除系统皮肤', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].skinId + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'skinController/doDeleteSkin',
				async : false,
				dataType : 'json',
				data : {ids : ids},
				success : function(result) {
					var msg = result;
					$.messager.show({ title:'提示', msg:'删除成功!', showType:'slide' });
					reload();
					$('#skinList').datagrid('clearSelections'); // 清空选中的行
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败!', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 重新加载列表
 * 
 * @param 无
 * @param 无
 */
function reload() {
	$('#skinList').datagrid('clearChecked');
	$('#skinList').datagrid('reload');
}

/**
 * 初始化dialog清空数据
 * 
 * @param 无
 * @param 无
 */
function initdldata() {
	$("#skinName").textbox('setValue',"");
	$("#skinCode").textbox('setValue',"");
	
	$("#is_valid").switchbutton("check");
	$("#isDefault").switchbutton("uncheck");
	
}

function clearSearchBox(){
	$("#search").searchbox("setValue","");
	$("#skin_name").searchbox("setValue","");
}

/**
 * 重新加载列表
 * 
 * @param 无
 * @param 无
 */
function searchList() {
	$('#skinList').datagrid('clearChecked');
	$('#skinList').datagrid('reload', {
		"skin_name" : $("#skin_name").textbox('getValue')
	});
}