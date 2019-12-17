<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
	<head>
		<title>用户组关联角色</title>
		<%@ include file="/views/cap/common/easyui-head.jsp"%>
		<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/userGroupResRoleList.js"></script>
		<script type="text/javascript">
			var userGroupId = '${userGroupId}';
		</script>
		<style type="text/css">
		</style>
	</head>
	<body>
	<div class="easyui-layout" style="width:100%;height:100%">
		<div data-options="region:'west',split:true,collapsible:false"
			 class="page_menu">
			<div class="search-tree">
				<input id="userGroupSearch"></input>
				<ul class="easyui-tree" id="userGroupTree"></ul>
			</div>
		</div>
		<!-- 用户组关联角色列表 -->
		<div data-options="region:'center'">
			<div id="toolBar" style="padding:5px;height:auto">
				<!-- 条件查询 -->
				<div>
					<table>
						<tr>
							<td>角色编码:</td>
							<td>
								<input class="easyui-textbox" type="text" id="role_code_q" name="roleCode" />
							</td>
							<td>角色名称:</td>
							<td>
								<input class="easyui-textbox" type="text" id="role_name_q" name="roleName" />
							</td>
							<td>是否关联角色:</td>
							<td><input type="checkbox" id="is_res_role"></td>
							<td>
								<a href="javascript:void(0)" onclick="findByCondition()" plain="true" class="easyui-linkbutton" iconCls="icon-search">查询</a>
							</td>
						</tr>
					</table>
				</div>
				<!-- 工具栏 -->
				<div id="operateBtn" >
					<a href="javascript:void(0)" onclick="doAddRefRole()"
						class="easyui-linkbutton" iconCls="icon-add" plain="true">添加关联</a>
					<a href="javascript:void(0)" onclick="doDeleteRefRole()"
						class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除关联</a>
				</div>
			</div>
			<!-- 用户组关联角色 -->
			<div class="content">
				<table class="easyui-datagrid" id="roleList"></table>
			</div>
		</div>
		<!-- 用户组关联角色新增对话框 -->
		<div id="roleDlg" class="easyui-dialog" closed="true"
			data-options="" style="width:750px;height:450px;padding:0px;">
			<div class="easyui-panel" style="width:100%;height:50%;padding-left:10px;">
				
			</div>
		</div>
	</div>
	</body>
</html>