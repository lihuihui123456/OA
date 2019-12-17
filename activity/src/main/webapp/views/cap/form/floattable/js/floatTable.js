/**
 * 初始化
 * */
$(function(){
	createSelectData();
	if ("Y" == isAdd) {
		
	} else {
		$("#floatTalbeBox").combobox('setValue',tableCode);
		$("#tableName").textbox("setValue",tableName);
		$.ajax({
			type : 'post',
			url : 'formFloatTableController/getColumnJsonArra',
			data : {
				tableCode : tableCode
			},
			dataType : 'json',
			success : function(result){
				$("#floatTableColList").datagrid({
					data : eval(result)
				});
				setChecked();
			}
		});
	}
});
/**
 * 全局变量
 * */
var editIndex = undefined;//当前编辑的索引

/**
 * 结束编辑状态
 * */
function endEditing(){
	if (editIndex == undefined){return true}
	if ($('#floatTableColList').datagrid('validateRow', editIndex)){
		$('#floatTableColList').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

/**
 * 点击单元格事件
 * */
function onClickCell(index, field){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	if (endEditing()){
		$('#floatTableColList').datagrid('selectRow', index).datagrid('editCell', {index:index,field:field});
		editIndex = index;
	}
}

/**
 * 取消行编辑事件
 * */
function cancelEdit(){
	if (endEditing()) {
		$('#floatTableColList').datagrid('endEdit', editIndex);
	}
}

/**
 * 设置列表行选中状态
 * 
 * @author 王建坤
 * @since 2017-06-30
 * */
function setChecked(){
	var rows = $("#floatTableColList").datagrid("getRows");
	var jsonArrt = eval(""+columsJsonArray+"");
	if (jsonArrt != null && jsonArrt.length > 0) {
		if (rows != null && rows.length > 0) {
			$(rows).each(function(index){
				for ( var i = 0; i < jsonArrt.length; i++) {
					if (rows[index].enName == jsonArrt[i].enName) {
						$('#floatTableColList').datagrid('updateRow', {
			                index: index,
			                row: {
			                	cnName : jsonArrt[i].cnName
			                }
			            });
						$('#floatTableColList').datagrid('refreshRow', index);
						$("#floatTableColList").datagrid("checkRow",index);
					}
				}
			});
		}
	}
}

/**
 * 加载浮动表下拉数据
 * @author 王建坤
 * @param 
 */
function createSelectData() {
	$("#floatTalbeBox").combobox({
		url : "formFloatTableController/getComboData",
		onSelect : function(record) {
			tableCode = record.tableCode;
			if (tableCode == '') {
				$.messager.show({
					title : '提示',
					msg : '此浮动表不存在，请重新选择',
					showType : 'slide'
				});
				return;
			}
			$.ajax({
				type : 'post',
				url : 'formFloatTableController/getColumnJsonArra',
				data : {
					tableCode : tableCode
				},
				dataType : 'json',
				success : function(result){
					$("#floatTableColList").datagrid({
						data : eval(result)
					});
				}
			});
		}
	});
}

/**
 * 保存
 * 
 * @author wangjiankun
 * @since 2017-06-30
 */
function doSaveFormFloat(){
	if ($("#floatTalbeBox").combobox("getValue") == '') {
		$.messager.show({
			title : '提示',
			msg : '请选择浮动表！',
			showType : 'slide'
		});
		return;
	}
	if ($("#tableName").textbox("getValue") == '') {
		$.messager.show({
			title : '提示',
			msg : '名称不能为空！',
			showType : 'slide'
		});
		return;
	}
	/** 取消还在编辑状态的单元格的编辑状态*/
	if (endEditing()) {
		$('#floatTableColList').datagrid('endEdit', editIndex);
	}
	var jsonStr = "";
	var jsonArr = [];
	var selecteds = $("#floatTableColList").datagrid("getChecked");
	if (selecteds == null || selecteds == undefined || selecteds.length == 0) {
		$.messager.show({
			title : '提示',
			msg : '请选择列！',
			showType : 'slide'
		});
		return;
	}
	if (selecteds != null || selecteds.length > 0) {
		$(selecteds).each(function(index) {
			var dataRuleCol = {};
			dataRuleCol.enName = selecteds[index].enName;
			if (selecteds[index].cnName == '') {
				dataRuleCol.cnName = selecteds[index].enName;
			} else {
				dataRuleCol.cnName = selecteds[index].cnName;
			}
			jsonArr[index] = dataRuleCol;
		});
		jsonStr = JSON.stringify(jsonArr);
	}
	
	var url = "";
	if (id == "") {
		url = "formFloatTableController/doSaveFormFloat";
	} else {
		url = "formFloatTableController/doUpdateFormFloat";
	}
	var data = {
			id : id,
			formId : formId,
			tableCode : tableCode,
			tableName : $("#tableName").textbox("getValue"),
			columnDef : jsonStr
	};
	$.ajax({
		type : 'post',
		url : url,
		data : data,
		dataType : 'json',
		success : function(data){
			if (data.code == "200") {
				window.parent.$('#tableAddDialog').dialog("close");
				window.parent.$('#floatTable').datagrid('reload');
				window.top.msgTip("保存成功!");
			} else {
				window.top.msgTip("保存失败!");
			}
		}
	});
}