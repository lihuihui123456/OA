<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/role/js/selectRoleUser.js"></script>
	
</head>

<body class="easyui-layout" style="width: 100%; height: 100%;"> 
	<div data-options="region:'west',split:true,collapsible:false" title="角色名称" style="width: 200px;" class="page_menu">
		<!-- 系统角色树 -->
		<ul class="easyui-tree" id="role_tree" ></ul>
	</div>
	
	<div data-options="region:'center',iconCls:'icon-ok'" class="content">
		<div id="toolBar" class="clearfix">
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入登录帐号或真实姓名'">
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<div id="operateBtn" class="tool_btn">
				<!-- <a href="javascript:void(0)" onclick="doSaveRoleUser()" class="easyui-linkbutton" iconCls="icon-save" plain="true">保存</a> -->
			</div>
		</div>

		<!-- 角色列表 -->
		<table class="easyui-datagrid" id="userList"></table>
	</div>
</body>
</html>