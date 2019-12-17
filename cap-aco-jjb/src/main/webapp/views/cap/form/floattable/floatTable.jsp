<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>下拉框数据</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/form/floattable/js/floatTable.js"></script>
	<script type="text/javascript">
		var isAdd = '${isAdd}';
		var columsJsonArray = '${columsJsonArray}';
		var tableCode = '${tableCode}';
		var id = '${id}';
		var formId = '${formId}';
		var tableName = '${tableName}';
	</script>
</head>
<body onclick="cancelEdit()"> 
	<div>
		<span>浮动表：</span>
		<select class="easyui-combobox" id="floatTalbeBox" style="width:380px;" data-options="valueField:'tableCode', textField:'tableName'"></select>
	</div>
	<br/> 
	<div>
		<span>名 &nbsp;称<span style="color:red;vertical-align:middle;">*</span>：</span>
		<input class="easyui-textbox" type="text" id="tableName" style="width:380px;" />
	</div>
	<br/>
	<table id="floatTableColList" class="easyui-datagrid" data-options="
		rownumbers:true,
		selectOnCheck : true,
		checkOnSelect : false,
		method: 'post',onClickCell: onClickCell">
		<thead>
			<tr>
				<th data-options="field:'id',hidden:true">id</th>
				<th data-options="field:'ck', checkbox:true"></th>
				<th data-options="field:'enName',width:400,align:'left'">英文名称</th>
				<th data-options="field:'cnName',width:500,align:'left',editor:'textbox'">中文名称(双击可编辑中文名称)</th>
			</tr>
		</thead>
	</table>
<script type="text/javascript">
	//扩展方法，点击事件触发一个单元格的编辑
	$.extend($.fn.datagrid.methods, {
		editCell: function(jq,param){
			return jq.each(function(){
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor1 = col.editor;
					if (fields[i] != param.field){
						col.editor = null;
					}
				}
				$(this).datagrid('beginEdit', param.index);
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor = col.editor1;
				}
			});
		}
	});
</script>
</body>
</html>