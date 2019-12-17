var editIndex = undefined;
var thistab = undefined;

// 结束当前行编辑
function endEditing(tabid) {
	var editIndex = undefined;
	var row = tabid.datagrid('getSelected');
	editIndex = tabid.datagrid('getRowIndex', row);
	if (editIndex == undefined) {
		return true
	}
	if (tabid.datagrid('validateRow', editIndex)) {
		tabid.datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

// 点击单元格事件
function onClickCell(index, field) {
	thistab = $(this);
	window.event.cancelBubble = true; // 阻止冒泡事件 （行点击事件）
	if (endEditing($(this))) {
		$(this).datagrid('selectRow', index).datagrid('editCell', {
			index : index,
			field : field
		});
		editIndex = index;
	}
}

// 单元格编辑结束事件
function onEndEdit(index, row) {
	var ed = $(this).datagrid('getEditor', {
		index : index,
		field : 'rule_type'
	});
}
// 数据表格行添加事件
function append(ruleid,colid, tableid,serveid,servetype) {
	var procdefid = tableid;
	var sol_id_ = colid;
	if (endEditing($('#'+ruleid))) {
		$('#'+ruleid).datagrid('appendRow', {
			table_id : procdefid,
			column_id : sol_id_,
			serve_id:serveid,
			serve_type:servetype
		});
		editIndex = $('#'+ruleid).datagrid('getRows').length - 1;
		$('#'+ruleid).datagrid('selectRow', editIndex).datagrid('editCell',
				editIndex);
	}
}

// 数据表格行移除事件
function removeit(ruleid) {
	var row = $('#'+ruleid).datagrid('getSelected');
	var editIndex = $('#'+ruleid).datagrid('getRowIndex', row);
	if (row) {
		$.messager.confirm('提示', '确定删除选中行数据吗?', function(r) {
		if (r) {
			if (editIndex == undefined) {
				return
			}
			if (row.id != '' && row.id != undefined) {
				$.ajax({
					url : "../formServeUserRuleController/delUserRule",
					type : 'POST',
					dataType : 'json',
					data:{id:row.id},
					success : function(result) {
						if (result == true) {
							$.messager.alert('成功', '删除成功！');
							$('#'+ruleid).datagrid('reload');
						}else{
							$.messager.alert('异常', '删除异常！');
						}
					}
				});
			}else{
				$('#'+ruleid).datagrid('reload');
			}
			editIndex = undefined;
		}
		});
	} else {
		$.messager.alert('警告', '选择一条数据');
	}
}

function saveassessofc(ruleid,colid,tableid) {
	if (endEditing($('#'+ruleid))) {
		var effectRow = new Object();
		var key="rulelist";
		effectRow["rulelist"] = JSON.stringify($('#'+ruleid).datagrid('getData'));
		effectRow["key"]=key;
		$.ajax({
			url : '../formServeUserRuleController/saveRuleCol',
			type : 'POST',
			dataType : 'json',
			data : effectRow,
			success : function(result) {
				if (result==true) {
					$.messager.alert('成功', '保存成功！');
					$('#'+ruleid).datagrid('reload');
				}else{
					$.messager.alert('异常', '保存异常');
				}
			}
		});
	}
}

// 取消行编辑事件
function cancelEdit() {
	$("table[name='asstable']").each(function() {
		var id = $(this).attr("id");
		var row = $('#' + id).datagrid('getSelected');
		var thisindex = $('#' + id).datagrid('getRowIndex', row);
		$("#" + id).datagrid('endEdit', thisindex);
		editIndex = undefined;
	});
}

// 单元格编辑前触发事件
function onBeforeEdit(index, row) {
	if (row != null) {
		if (row.rule_type == '1') {
			row.rule_id_val = '发起人';
			row.rule_id='1';

		}
	}
}

// 用户选择图标点击事件
function onClickIcon() {
	var row = thistab.datagrid('getSelected');
	if (row.rule_type != '1') {
		for(var i=0;i<temp.length;i++){
			if(row.rule_type==temp[i].dictCode){
				$("#choose_user").attr("src",temp[i].dictName);
			}
		}
		$('#chooseper').dialog({
			title : '用户选择',
			width : 620,
			height : 400,
			closed : false,
			cache : false,
			modal : true,
			onResize : function() {
				$(this).dialog('center');
			}
		});
	}
}

// 人员选择确定事件
function makesure() {
	var arr = document.getElementById("choose_user").contentWindow
			.doSaveMessage();
	var row = thistab.datagrid('getSelected');
	index = thistab.datagrid('getRowIndex', row);
	var ed = thistab.datagrid('getEditor', {
		index : index,
		field : 'rule_id_val'
	});
	ed.target.textbox("setValue", arr[1]);
	row.rule_id = arr[0];
	$('#chooseper').dialog('close');
}
var temp="";
/** 查询字段信息 * */
function initDict(dicttype){	
	$.ajax({
	url:"../dictController/findDictByTypeCode",
	type:"get",
	async:false,
	dataType:"json",
	data:{"dictTypeCode":dicttype},
	success:function(data){
		temp = data;
	}
	});
	return temp;
}
// 扩展方法，点击事件触发一个单元格的编辑
$.extend($.fn.datagrid.methods, {
	
	editCell : function(jq, param) {
		return jq.each(function() {
			var opts = $(this).datagrid('options');
			var fields = $(this).datagrid('getColumnFields', true).concat(
					$(this).datagrid('getColumnFields'));
			for (var i = 0; i < fields.length; i++) {
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				if (fields[i] != param.field) {
					col.editor = null;
				}
			}
			$(this).datagrid('beginEdit', param.index);
			for (var i = 0; i < fields.length; i++) {
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	}
});