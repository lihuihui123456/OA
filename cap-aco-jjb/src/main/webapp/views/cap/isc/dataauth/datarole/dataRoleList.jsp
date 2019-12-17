<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/dataauth/datarule/js/dataRule.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/dataauth/datarole/js/dataRole.js"></script>
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
				<shiro:hasPermission name="add:dataRoleController:dataRoleList">
					<a href="javascript:void(0)" onclick="openForm()" class="easyui-linkbutton" id="btn_add" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:dataRoleController:dataRoleList">
					<a href="javascript:void(0)" onclick="openUpdateForm()" class="easyui-linkbutton" id="btn_edit" iconCls="icon-edit" plain="true">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:dataRoleController:dataRoleList">
					<a href="javascript:void(0)" onclick="doDeleteRole()" class="easyui-linkbutton" id="btn_del" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="rule:dataRoleController:dataRoleList">
					<a href="javascript:void(0)" onclick="openRuleListDl()" class="easyui-linkbutton" id="btn_rule" iconCls="" plain="true">规则定义</a>
				</shiro:hasPermission>
			</div>
		</div>

		<!-- 角色列表 -->
		<table class="easyui-datagrid" id="roleList"></table>
	</div>
	
	<!-- 角色Form表单 -->
	<div id="roleDialog" class="easyui-dialog"  closed="true" title="新增数据角色信息" data-options="modal:true" style="width:460px;height:385px;padding:10px" buttons="#dlg-buttons">
			<form id="roleForm" method="post">
				<input type="hidden" id="roleId" name="roleId" />
				<table cellpadding="3">
		    		<tr>
		    			<td>所属单位<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input type="hidden" id="orgId" name="orgId" style="width:200px;" />
		    				<input class="easyui-textbox" type="text" name="orgName" id="orgName" disabled style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >数据角色名称<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td >
		    				<input class="easyui-textbox" data-options="validType:['isBlank','unnormal','length[1,256]']" required="true" missingMessage="不能为空" type="text" id="roleName" name="roleName" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td>数据角色描述:</td>
		    			<td>
		    				<input class="easyui-textbox" id="roleDesc" name="roleDesc" data-options="multiline:true" style="height:120px;width:300px;" />
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
	
	<!-- 新增数据角色规则Form表单 START -->
	<div id="ruleAddDialog" class="easyui-dialog"  closed="true" title="新增数据规则" data-options="modal:true" style="width:90%;height:90%;padding:10px" buttons="#ruledlg-buttons">
		<iframe frameborder="0" name="ruleAddFrame" id="ruleAddFrame"
			width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
	</div>
	<div id="ruledlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveRule()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#ruleAddDialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 数据角色规则Form表单 END -->
	
	<!-- 修改数据角色规则Form表单 START -->
	<div id="ruleUptDialog" class="easyui-dialog"  closed="true" title="修改数据规则" data-options="modal:true" style="width:90%;height:90%;padding:10px" buttons="#ruleUptdlg-buttons">
		<iframe frameborder="0" name="ruleUptFrame" id="ruleUptFrame"
			width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
	</div>
	<div id="ruleUptdlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveUptRule()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#ruleUptDialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 数据角色规则Form表单 END -->
	
	<!-- 数据角色规则list START -->
	<div id="ruleListDialog" class="easyui-dialog"  closed="true" title="数据规则列表" data-options="modal:true" style="width:90%;height:90%;padding:10px">
		<div class="easyui-layout" style="width:100%;height:100%;">
			<div data-options="region:'center'" class="content">
				<!-- 工具栏 -->
				<div id="ruleToolBar" class="clearfix">
					<div class="search-input">
						<input id="ruleSearch" class="easyui-searchbox" data-options="searcher:findRulesByCondition,prompt:'输入规则名称'">
						<span class="clear" onclick="clearRuleSearchBox()"></span>
					</div>
					<div id="ruleOperateBtn" class="tool_btn">
						<shiro:hasPermission name="add:dataRoleController:dataRoleList">
							<a href="javascript:void(0)" onclick="openRuleForm()" id="btn_rule_add" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="modify:dataRoleController:dataRoleList">
							<a href="javascript:void(0)" onclick="openUpdateRuleForm()" id="btn_rule_edit" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="delete:dataRoleController:dataRoleList">
							<a href="javascript:void(0)" onclick="doDeleteRule()" id="btn_rule_del" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
						</shiro:hasPermission>
					</div>
				</div>
				<!-- 规则列表 -->
				<table class="easyui-datagrid" id="ruleList"></table>
			</div>
		</div>	
	</div>
	<!-- 数据 角色规则Form表单 END -->
	
	<!-- 新增 选择人员、部门、单位弹出框 START -->
	<div id="commonAddDialog" class="easyui-dialog"  closed="true" title="选择" data-options="modal:true" style="width:90%;height:90%;padding:10px" buttons="#commonaddlg-buttons">
		<iframe frameborder="0" name="commonAddFrame" id="commonAddFrame"
			width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
	</div>
	<div id="commonaddlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:doSaveAddSelect()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#commonAddDialog').dialog('close')" plain="true">取消</a>
	</div>
	<!-- 新增 选择人员、部门、单位弹出框 END -->
	
	<!-- 修改 选择人员、部门、单位弹出框 START -->
	<div id="commonUptDialog" class="easyui-dialog"  closed="true" title="选择" data-options="modal:true" style="width:90%;height:90%;padding:10px" buttons="#commonuptlg-buttons">
		<iframe frameborder="0" name="commonUptFrame" id="commonUptFrame"
			width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
	</div>
	<div id="commonuptlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:doSaveUptSelect()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#commonUptDialog').dialog('close')" plain="true">取消</a>
	</div>
	<!-- 修改 选择人员、部门、单位弹出框 END -->
	
	<!-- 数据表字段弹出框 START -->
	<div id="tableColDialog" class="easyui-dialog"  closed="true" title="添加规则字段" data-options="modal:true" style="width:90%;height:90%;padding:10px" buttons="#tableCollg-buttons">
		<iframe frameborder="0" name="tableColFrame" id="tableColFrame"
			width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
	</div>
	<div id="tableCollg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:doUseDataRuleCol()" plain="true">使用</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:closeDlg()" plain="true">取消</a>
	</div>
	<!-- 数据表字段弹出框 END -->
</body>
</html>