<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>文号管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/docmgr/js/docnum_list.js"></script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
<!-- 页面布局 -->
		<div data-options="region:'west',split:true,collapsible:false" style="width: 25%;" class="page_menu">
			<!-- 部门机构树 -->
			<div class="search-tree">
				<ul class="easyui-tree" id="doc_num_tree" />
			</div>
		</div>
	<div data-options="region:'center',iconCls:'icon-ok'" class="content">
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
					<th data-options="field:'enable', width:100, align:'left'">是否启用</th>
				</tr>
				</thead>
		</table>
	</div>
</body>
</html>