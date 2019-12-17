<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>套红模板</title>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.edatagrid.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript">
	$(function(){
		getdicdata();
	})

	/** 初始化datagrid数据 **/
	function getdicdata() {
		$('#dtlist').datagrid({
			url : '${ctx}/bizSolMgr/findRedTempList',
			method : 'POST',
			idField : 'id_',
			striped : true,
			fit:true,
			fitColumns : true,
			singleSelect : false,
			rownumbers : true,
			pagination : true,
			nowrap : false,
			toolbar : '#toolbar',
			pageSize : 5,
			pageList : [ 5,10, 20, 50, 100, 150, 200 ],
			showFooter : true,
			singleSelect:true,
			columns : [ [ {
				field : 'ck',
				checkbox : true
			}, {
				field : 'name_',
				title : '模板名称',
				width : 20,
				align : 'center'
			}, {
				field : 'remark_',
				title : '说明',
				width : 20,
				align : 'center'
			}, {
				field : 'recordId_',
				title : 'word文件名',
				width : 20,
				align : 'center'
			}] ],
			onClickCell : function(rowIndex, field, value) {

			}
		});
	}
	
	function makesureTemp(){
		var node = $('#dtlist').datagrid('getChecked');
		if(node.length>1 || node.length==0){
			$.messager.alert('提示', '请选择模板！', 'info');
			return ;
		}else{
			return node[0].recordId_+'.doc';
		}
	}
	</script>
	<script type="text/javascript" src="${ctx}/static/cap/js/common.js"></script>
<body >
<div class="easyui-layout" style="padding:10px" data-options="fit:true">
	<table class="easyui-datagrid" id="dtlist"></table>
	
</div>	
</body>
</html>