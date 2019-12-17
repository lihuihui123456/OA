<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>用户组管理</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/userGroupResRoleList.js"></script>
<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/userResGroupList.js"></script>
<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/userGroupList.js"></script>
<style type="text/css">
.input-must {
	font-size: 14px;
	color: red;
	vertical-align: middle;
	margin-right: 5px;
}
</style>
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
				<!-- 工具栏 -->
				<div id="operateBtn" class="tool_btn">
					<shiro:hasPermission name="add:userGroupController:userGroupList">
						<a href="javascript:void(0)" onclick="doAddUserGroupBefore()" id="btn_add" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="modify:userGroupController:userGroupList">
						<a href="javascript:void(0)" onclick="doUpdateUserGroupBefore()" id="btn_edit" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="delete:userGroupController:userGroupList">
						<a href="javascript:void(0)" onclick="doDeleteUserGroup()" id="btn_del" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="refUser:userGroupController:userGroupList">
						<a href="javascript:void(0)" onclick="doUserGroupResUser()" id="btn_user" class="easyui-linkbutton" iconCls="icon-isc-glyh" plain="true">关联用户</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="refRole:userGroupController:userGroupList">
						<a href="javascript:void(0)" onclick="openCroupResRoleDlg()" id="btn_role" class="easyui-linkbutton" iconCls="icon-isc-gljs" plain="true">关联角色</a>
					</shiro:hasPermission>
				</div>
			</div>
			<!-- 用户组列表 -->
			<table class="easyui-datagrid" id="userGroupList"></table>
		</div>
	

		<!-- 用户组信息新增修改对话框 -->
		<div id="userGroupDlg" class="easyui-dialog" closed="true"
			data-options="modal:true" style="width:470px;height:305px;padding:10px"
			buttons="#dlg-buttons">
			<form id="userGroupForm" method="post">
				<input type="hidden" id="org_id" name="orgId">
				<input type="hidden" id="user_group_id" name="userGroupId">
				<table cellpadding="3">
					<tr>
						<td>用户组编码<span class="input-must">*</span>:</td>
						<td><input class="easyui-validatebox" id="user_group_code" name="userGroupCode" validType="" onchange="validExist(this)" data-options="required:true" style="width:300px;line-height: 30px;" missingMessage="不能为空"></td>
					</tr>
					<tr>
						<td>用户组名称<span class="input-must">*</span>:</td>
						<td><input class="easyui-validatebox" id="user_group_name" name="userGroupName" validType="" data-options="required:true" style="width:300px;line-height: 30px;" missingMessage="不能为空"></td>
					</tr>
					<%--<tr>
								<td>是否封存:</td>
								<td><input type="radio" name="isSeal" value="Y"/>是
									<input type="radio" name="isSeal" value="N" checked="checked"/>否</td>
							</tr>--%>
					<tr>
						<td><span class="input-blank"></span>用户组描述:</td>
						<td><input class="easyui-textbox" id="user_group_desc" name="userGroupDesc" data-options="multiline:true" style="height:80px;width:300px;width:320px\0;"></td>
					</tr>
				</table>
			</form>
		</div>
		<div id="dlg-buttons" class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveOrUpdateUserGroup()" plain="true">保存</a> 
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#userGroupDlg').dialog('close')" plain="true">取消</a>
		</div>
		<!-- 关联用户Form表单 -->
		<div id="userGroupDialog" class="easyui-dialog" closed="true" title="关联用户" data-options="modal:true" style="width:90%;height:460px;" buttons="#userGroup-buttons">
			<div class="easyui-layout" style="width:100%;height:100%;display: none;">
				<!-- 用户组用户列表 -->
				<div data-options="region:'center'" class="content">
					<div id="userGroupToolBar" class="clearfix">
						<!-- 条件查询 -->
						<div class="search-input">
							<input id="userGroupSearch" class="easyui-searchbox" data-options="searcher:findByGroupCondition,prompt:'输入登录帐号或真实姓名'">
							<span class="clear" onclick="clearSearchBox()"></span>
						</div>
					</div>
					<!-- 用户列表 -->
					<table class="easyui-datagrid" id="userList"
						data-options="{
								queryParams:{
									orgId : ''
								},
								url : 'userRefGroupController/findByCondition',
								method : 'POST',
								view : dataGridExtendView,
								emptyMsg : '没有相关记录！',
								idField : 'userId',
								striped : true,
								fit : true,
								fitColumns : true,
								singleSelect : false,
								rownumbers : true,
								pagination : true,
								nowrap : false,
								toolbar : '#userGroupToolBar',
								pageSize : 10,
								showFooter : true,
								columns : [ [ 
						 		    { field : 'ck', checkbox : true }, 
						 		    { field : 'userId', title : 'userId', hidden : true }, 
						 		    { field : 'acctLogin', title : '登录账号', width : 150, align : 'left' }, 
						 		    { field : 'userName', title : '真实姓名', width : 150, align : 'left' }, 
						 		    { field : 'deptName', title : '所属部门', width : 150, align : 'left' }
						 		] ],
						 		onLoadSuccess : function(data) {
						 			getChecked(data);
								},onCheck : function(index, row) {
									insertSelectData(row);
								},
								onUncheck : function(index, row) {
									var userId = row.userId;
									removeUser(userId);
								},
								onCheckAll : function(rows) {
									$(rows).each(function(index,row){
										insertSelectData(row);
									});
								},
								onUncheckAll : function(rows) {
									$(rows).each(function(index,row){
										removeUser(row.userId);
									});
								}
							}"></table>
				</div>
			</div>
			<!-- 新增 选择人员、部门、单位弹出框 START -->
			<iframe frameborder="0" name="commonAddFrame" id="commonAddFrame"
				width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
				marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
		</div>
		<div id="userGroup-buttons" class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveUser()" plain="true">保存</a> 
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#userGroupDialog').dialog('close')" plain="true">取消</a>
		</div>
		<!-- 关联用户Form表单 END -->
		<!-- 关联角色dialog  -->
		<div id="roleDialog" class="easyui-dialog" closed="true" title="关联角色" data-options="modal:true" style="width:90%;height:460px;padding:10px"  buttons="#role-buttons">
			<!-- 分配角色列表 -->
			<!-- <table class="easyui-datagrid" id="select_role" style="height: 100%"></table> -->
				<div class="usable_role" style="height:330px;width:38%;margin-left: 5%">
					
					<table id="tb1" class="easyui-datagrid" style=" height: 330px;"
								border="0"
								data-options="
						           rownumbers:false,
						           animate: true,
						           collapsible: true,
						           fitColumns: true,
						           method:'post',
						           onDblClickRow :function(rowIndex,rowData){
						               $(this).datagrid('selectRow', rowIndex);
									   add(rowIndex);
								   }
								   ">
						<thead>
							<tr>
								<th data-options="field:'roleId',hidden:true">roleId</th>
								<th data-options="field:'roleName',width:70,align:'left'">可选角色</th>
							</tr>
						</thead>
					</table>
				</div>
				<div class="operate_btn" style="margin-top:100px">
					<input type="button" class="green" value="&gt" onclick="add(this);" /><br/>
					<input type="button" class="green" value="&gt&gt" onclick="addAll(this);" /><br/>
					<input type="button" class="red" value="&lt" onclick="del(this);" /><br/>
					<input type="button" class="red" value="&lt&lt" onclick="delAll(this);" />
				</div>
				<div class="selected_role" style="height:330px;width:38%">
					<table id="tb2" class="easyui-datagrid" style=" height: 330px;"
								border="0"
								data-options="
						           rownumbers:false,
						           animate: true,
						           collapsible: true,
						           fitColumns: true,
						           method:'post',
						           onDblClickRow :function(rowIndex,rowData){
						           	   $(this).datagrid('selectRow', rowIndex);
									   del(rowIndex);
								   }
								   ">
						<thead>
							<tr>
								<th data-options="field:'roleId',hidden:true">roleId</th>
								<th data-options="field:'roleName',width:70,align:'left'">已选角色</th>
							</tr>
						</thead>
					</table>
				</div>
		
			<div id="role-buttons" class="window-tool">
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveRole()" plain="true">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#roleDialog').dialog('close')" plain="true">取消</a>
			</div>
		</div>
		<!-- 分配角色dialog END -->
</body>
</html>