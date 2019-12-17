<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>下拉框数据</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/dataauth/datarule/js/dataTableColIframe.js"></script>
	<script type="text/javascript">
		var columsJsonArray = '${columsJsonArray}';
		var tableName = '${tableName}';
		var iframeId = '${iframeId}';
	</script>
</head>
<body onclick="cancelEdit()"> 
	<table id="dataTableColList" class="easyui-datagrid" data-options="
		rownumbers:true,
		selectOnCheck : true,
		checkOnSelect : false,
		method: 'post',onClickCell: onClickCell">
		<thead>
			<tr>
				<th data-options="field:'id',hidden:true">id</th>
				<th data-options="field:'ck', checkbox:true"></th>
				<th data-options="field:'enName',width:450,align:'left'">英文名称</th>
				<th data-options="field:'cnName',width:520,align:'left',editor:'textbox'">中文名称(双击可编辑中文名称)</th>
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