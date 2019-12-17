<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>文号管理</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	<script type="text/javascript" src="${ctx}/views/cap/sys/docmgr/js/docList.js"></script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
<!-- 页面布局 -->
		<div data-options="region:'west',split:true,collapsible:false" style="width: 25%;" class="page_menu">
			<!-- 部门机构树 -->
			<div class="search-tree">
				<ul class="easyui-tree" id="doc_num_tree" />
			</div>
		</div>
		<!-- 右键菜单 -->
	<div id="mm" class="easyui-menu" style="width: 60px;">
		<div id="addMenu" onclick="addNote()" data-options="iconCls:'icon-add'">新增节点</div>
		<div id="editMenu" onclick="modNote()" data-options="iconCls:'icon-edit'">修改节点</div>
		<div id="delMenu" onclick="delNote()" data-options="iconCls:'icon-remove'">删除节点</div>
	</div>
	<div data-options="region:'center'" class="content">
		<!-- 列表 -->
		<div id="toolBar" class="clearfix">
			<div class="search-input">
				<input id="doc_name" class="easyui-searchbox" data-options="searcher:searchList,prompt:'输入文号名称'" />
			</div>
		</div>
		<table class="easyui-datagrid" id="dtlist" data-options="
				idField:'serial_id',treeField : 'serial_id', method:'post', striped : true,fitColumns : true,singleSelect : true,rownumbers : true,
				pagination : true,fit : true,nowrap : false,toolbar : '#toolBar',pageSize : 10,showFooter : true">
			<thead>
					<tr>
						<th data-options="field:'ck', checkbox:true"></th>
						<th data-options="field:'serial_id', hidden:true">文号ID</th>
						<th data-options="field:'dept_id', hidden:true">单位、部门ID</th>
						<th data-options="field:'serial_number_name', width:260, align:'left'">文号名称</th>
						<th data-options="field:'preview_effect', width:300, align:'left'">预览效果</th>
						<th data-options="field:'enable', width:100, align:'left', formatter:formaterState">是否启用</th>
					</tr>
				</thead>
		</table>
	</div>
	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<a href="javascript:void(0)" onclick="btnOk();" class="easyui-linkbutton" plain="true">确定</a>
			<a href="javascript:void(0)" onclick="window.close();" class="easyui-linkbutton" plain="true">关闭</a>
		</div>
	</div>
</body>
<script type="text/javascript">
	function btnOk() {
		//选择文号
		var symbol_;//文号Id
		var symbolname_;//文号值
		var datas = $('#dtlist').datagrid('getSelections');
		$(datas).each(function(index) {
			symbol_ = datas[index].serial_id;
			symbolname_ = datas[index].serial_number_name;
		});
		window.opener.document.getElementById("symbol_").value = symbol_;
		window.opener.document.getElementById("symbolname_").value = symbolname_;
		window.close();
	}
</script>
</html>