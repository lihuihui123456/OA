<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
	<head>
		<title>用户组管理</title>
		<%@ include file="/views/cap/common/easyui-head.jsp"%>
		<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/selectUserGroup.js"></script>
		
	</head>
	<body class="easyui-layout" style="width: 100%; height: 98%;">
		<div data-options="region:'west',split:true,collapsible:false" class="page_menu">
			<div class="search-tree">
				<input id="org_search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入单位名称'"/>
				<span class="clear" onclick="clearOrgSearchBox()"></span>
				<!-- 系统角色树 -->
				<ul class="easyui-tree" id="org_tree_list"></ul>
			</div>
		</div>
		<div data-options="region:'center'" class="content">
			<!-- 用户组列表 -->
			<div id="toolBar" class="clearfix">
				<!-- 条件查询 -->
				<div class="search-input">
					<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入用户组编码或用户组名称'">
					<span class="clear" onclick="clearSearchBox()"></span>
				</div>
			</div>
			<!-- 用户组列表 -->
			<table class="easyui-datagrid" id="userGroupList"></table>
			<!-- 用户组信息新增修改对话框 -->
		</div>
	</body>
</html>