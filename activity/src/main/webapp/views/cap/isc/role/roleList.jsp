<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/role/js/roleList.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/role/js/roleMenu.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/role/js/roleUserList.js"></script>
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
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:roleController:roleList">
					<a href="javascript:void(0)" onclick="openForm()" id="btn_add" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:roleController:roleList">
					<a href="javascript:void(0)" onclick="openUpdateForm()" id="btn_edit" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:roleController:roleList">
					<a href="javascript:void(0)" onclick="doDeleteRole()" id="btn_del" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="refUser:roleController:roleList">
					<a href="javascript:void(0)" onclick="addRoleUser()" id="btn_user" class="easyui-linkbutton" iconCls="icon-isc-glyh" plain="true">关联用户</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="permissions:roleController:roleList">
					<a href="javascript:void(0)" onclick="addRoleMenu()" id="btn_perm" class="easyui-linkbutton" iconCls="icon-isc-qxfp" plain="true">角色授权</a>
				</shiro:hasPermission>
			</div>
		</div>

		<!-- 角色列表 -->
		<table class="easyui-datagrid" id="roleList"></table>
	</div>

	<!-- 角色Form表单 -->
	<div id="roleDialog" class="easyui-dialog"  closed="true" title="新增角色信息" data-options="modal:true" style="width:460px;height:385px;padding:10px" buttons="#dlg-buttons">
			<form id="roleForm" method="post">
				<input type="hidden" id="roleId" name="roleId" />
				<table cellpadding="3">
		    		<tr>
		    			<td >角色名称<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td >
		    				<input class="easyui-textbox" required="true" data-options="validType:['isBlank','unnormal','length[1,256]']" missingMessage="不能为空" type="text" id="roleName" name="roleName" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td>角色英文名<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,256]']" required="true" missingMessage="不能为空" id="roleEname" name="roleEname" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >角色编码<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" type="text" id="roleCode" data-options="validType:['isBlank','unnormal','length[1,128]']" required="true" missingMessage="不能为空" name="roleCode" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td>所属单位<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input type="hidden" id="orgId" name="orgId" style="width:200px;" />
		    				<input class="easyui-textbox" type="text" id="orgName" disabled style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td>角色描述:</td>
		    			<td>
		    				<input class="easyui-textbox" id="roleDesc" name="roleDesc" data-options="multiline:true" style="width:300px;height:80px" />
		    			</td>
		    		</tr>
		    	</table>
			</form>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveRole()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#roleDialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 角色Form表单 END -->
	
	<!-- 角色权限Form表单 -->
	<div id="roleMenuDialog" class="easyui-dialog" closed="true" title="角色授权" data-options="modal:true" style="width:90%;height:460px;padding:5px"  buttons="#roleMenu-buttons">
		<div class="easyui-layout" style="width: 100%; height: 100%;"> 
			<div data-options="region:'west',split:true,collapsible:false" title="注册系统" style="width: 240px;">
				<!-- 系统注册树 -->
				<ul class="easyui-tree" id="sys_reg_tree" ></ul>
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
	
	<!-- 角色用户dialog  -->
	<div id="roleUserDialog" class="easyui-dialog" closed="true" title="关联用户" data-options="modal:true" style="width:90%;height:460px;padding:5px"  buttons="#roleUser-buttons">
		<div id="toolBar1" class="clearfix" style="display:none;">
			<div class="search-input">
				<input id="search1" class="easyui-searchbox" data-options="searcher:findByCondition1,prompt:'输入登录账号或真实姓名'">
				<span class="clear" onclick="clearSearchBox1()"></span>
			</div>
		</div>
		
		<!-- 新增 选择人员、部门、单位弹出框 START -->
			<iframe frameborder="0" name="commonAddFrame" id="commonAddFrame"
				width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
				marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
	
	<div id="roleUser-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveRoleUser()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#roleUserDialog').dialog('close')" plain="true">取消</a>
	</div>
	</div>
	<!-- 角色用户dialog END -->
</body>
</html>