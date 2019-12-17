<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/role/js/selectRoleList.js"></script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;"> 
	<div data-options="region:'west',split:true,collapsible:false" class="page_menu">
		<div class="search-tree">
			<input id="org_search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入单位名称'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<!-- 系统角色树 -->
			<ul class="easyui-tree" id="org_tree"></ul>
		</div>
	</div>

	<div data-options="region:'center'" class="content">
		<div id="toolBar" class="clearfix">
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入角色名称'">
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
		</div>

		<!-- 角色列表 -->
		<table class="easyui-datagrid" id="roleList"></table>
	</div>

</body>
</html>