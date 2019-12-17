<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>选择部门岗位人员</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/org/js/selectOrgDeptUserMultiple.js"></script>
	
</head>

<body class="easyui-layout" style="width: 100%; height: 98%;padding:10px"> 
	<div data-options="region:'west',split:true,collapsible:false" class="page_menu">
		<!-- 单位部门树 -->
		<div class="search-tree">
			<input id="org_search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入单位名称'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<ul class="easyui-tree" id="org_dept_tree" ></ul>
		</div>
	</div>
	
	<div data-options="region:'center',iconCls:'icon-ok'" class="content">
		<div id="toolBar" class="clearfix">
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入登录帐号或真实姓名'">
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<!-- <div id="operateBtn" class="tool_btn">
				<a href="javascript:void(0)" onclick="saveUserRoles()" class="easyui-linkbutton" iconCls="icon-isc-fpjs" plain="true">保存</a>
			</div> -->
		</div>

		<!-- 用户列表 -->
		<table class="easyui-datagrid" id="userList"></table>
	</div>
</body>
</html>