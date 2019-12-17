<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>授权管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/role/js/allRoleMenu.js"></script>
	<script type="text/javascript">
		var roleId = '${roleId}';
	</script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<input type="hidden" id="typeid">
	<div data-options="region:'west',split:true,collapsible:false" class="page_menu">
		<div class="search-tree">
			<input id="org_search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入单位名称'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<!-- 系统角色树 -->
			<ul class="easyui-tree" id="org_tree" ></ul>
		</div>
	</div>

	<div data-options="region:'center'" class="content">
		<div id="toolBar" class="clearfix">
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入角色名称'">
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="permissions:roleMenuController:allRoleMenu">
					<a href="javascript:void(0)" onclick="addRoleMenu()" id="btn_perm" class="easyui-linkbutton" iconCls="icon-isc-qxfp" plain="true">角色授权</a>
				</shiro:hasPermission>
			</div>
		</div>

		<!-- 角色列表 -->
		<table class="easyui-datagrid" id="roleList"></table>
	</div>

	<!-- <div data-options="region:'east',title:'权限菜单'" style="width: 350px;">
		<ul class="easyui-tree" id="menu_tree"></ul>
	</div> -->

	<!-- <div data-options="region:'south'" style="width:100%;" >
		<div style="text-align:center;padding:5px;visibility: hidden" id="saveDiv">
            <a href="javascript:void(0)" onclick="saveData()"
				class="easyui-linkbutton" iconCls="icon-save" plain="true">保存</a>
    	</div>
	</div> -->

	<!-- 角色权限Form表单 -->
	<div id="roleMenuDialog" class="easyui-dialog" closed="true" title="角色授权" data-options="modal:true" style="width:90%;height:460px;padding:0px"  buttons="#roleMenu-buttons">
		<div class="easyui-layout" style="width: 100%; height: 355px;"> 

			<div data-options="region:'west',split:true,collapsible:false" title="注册系统" style="width: 240px;">
				<!-- 系统注册树 -->
				<ul class="easyui-tree" id="sys_reg_tree"></ul>
			</div>
			
			<div data-options="region:'center',title:'模块资源'">
				<ul class="easyui-tree" id="menu_tree"></ul>
			</div>
		</div>
	</div>
	<div id="roleMenu-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveData()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#roleMenuDialog').dialog('close')" plain="true">取消</a>
	</div>
	<!-- 角色Form表单 END -->
</body>
</html>