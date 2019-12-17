<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>表单信息</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<script type="text/javascript">
$(function(){
	initRoleList();
});

function initRoleList() {
	$('#tablelist').datagrid({
		url : '${ctx}/bizSolMgr/findFreeFormColumns',
		method : 'POST',
		striped : true,
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams:{
			freeFormId : '${freeFormId}'
		},
		fitColumns : true,
		fit: true,
		singleSelect : true,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', checkbox : true }, 
		   { field : 'col_id', hidden:true }, 
		   { field : 'col_code', title : '字段名称', width : 100, align : 'left' },
		   { field : 'col_name', title : '字段描述', width : 100, align : 'left' }
		]],
		onClickRow: function(index,row){
			$('#tablelist').datagrid("clearChecked");
			$('#tablelist').datagrid("selectRow", index);
		}
	});
}

function doSaveMessage(){
	var selecteds = $('#tablelist').datagrid('getSelections');
	
	var ids = '';
	var names = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].col_id + ",";
		names = names + selecteds[index].col_name + ",";
	});
	
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	if(names != ''){
		names = names.substring(0, names.length - 1);
	}

	var arr=new Array();
	arr[0]=ids;
	arr[1]=names;
	return arr;
}
</script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;"> 
	<table class="easyui-datagrid" id="tablelist"></table>
</body>
</html>