/**
 * 初始化
 * */
$(function(){
    var dg = $("#dataTableColList").datagrid({
				data : eval(columsJsonArray)
			});
    setChecked(iframeId);
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
	if ($('#dataTableColList').datagrid('validateRow', editIndex)){
		$('#dataTableColList').datagrid('endEdit', editIndex);
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
		$('#dataTableColList').datagrid('selectRow', index).datagrid('editCell', {index:index,field:field});
		editIndex = index;
	}
}

/**
 * 取消行编辑事件
 * */
function cancelEdit(){
	if (endEditing()) {
		$('#dataTableColList').datagrid('endEdit', editIndex);
	}
}

/**
 * 设置列表行选中状态
 * 
 * @author 王建坤
 * @param iframeId Iframe的ID
 * */
function setChecked(iframeId){
	var rows = $("#dataTableColList").datagrid("getRows");
	var columnsRefUser = window.parent.window.frames[iframeId].columnsRefUser;
	var jsonArrt = eval(""+columnsRefUser+"");
	if (jsonArrt != null && jsonArrt.length > 0) {
		if (rows != null && rows.length > 0) {
			$(rows).each(function(index){
				for ( var i = 0; i < jsonArrt.length; i++) {
					if (rows[index].enName == jsonArrt[i].enName) {
						$("#dataTableColList").datagrid("checkRow",index);
					}
				}
			});
		}
	}
}

/**
 * 关闭窗口
 * */
function closeDlg(){
	window.parent.window.frames[iframeId].closeDlg();
}

/**
 * 保存
 * */
function doUseDataRuleCol(){
	/** 取消还在编辑状态的单元格的编辑状态*/
	if (endEditing()) {
		$('#dataTableColList').datagrid('endEdit', editIndex);
	}
	var jsonStr = "";
	var jsonArr = [];
	var selecteds = $("#dataTableColList").datagrid("getChecked");
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
	$.ajax({
		url : "dataRuleController/doUseDataRuleCol",
		type : "post",
		async : false,
		data : {
			tableName : tableName,
			columnsStr : jsonStr
		},
		success : function(data) {
			if (data.success == 'true') {
				var boxData = eval("("+data.columnsStr+")");
				window.parent.window.frames[iframeId].columnsAll = boxData;
				window.parent.window.frames[iframeId].columnsRefUser = data.columnsRefUser;
				window.parent.window.frames[iframeId].comboboxDom = data.comboboxDom;
				window.parent.$('#tableColDialog').dialog("close");

				window.top.msgTip("添加成功!");
			} else {
				window.top.msgTip("添加失败!");
			}
		}
	});
	return iframeId;
}