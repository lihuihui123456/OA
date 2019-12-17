<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>系统消息管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/sysmessage/js/sysmessageList.js"></script>
	
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
<div data-options="region:'center'" class="content">
		<!-- 工具栏 -->
		<div id="toolBar" class="clearfix">
			<div class="search-input">
			<!-- 条件查询 -->
				<input id="sysFlagAndName" name="sysFlagAndName" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入查询条件'"/>
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<div id="operateBtn" class="tool_btn">
				<%-- <shiro:hasPermission name="add:sysMessageController:sysmessageList">
					<a href="javascript:void(0)" onclick="openForm('新增系统注册信息')" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:sysMessageController:sysmessageList">
					<a href="javascript:void(0)" onclick="openUpdateForm('修改系统注册信息')" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
				</shiro:hasPermission> --%>
				<shiro:hasPermission name="delete:sysMessageController:sysmessageList">
					<a href="javascript:void(0)" onclick="doDeleteSysMessage()" id="btn_del" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission>
			</div>
		</div>
		<!-- 系统消息列表 -->
		<table class="easyui-datagrid" id="sysmessageList"></table>
</div>
	<!-- 系统注册Form表单 -->
	<div id="sysRegDialog" class="easyui-dialog"  closed="true" data-options="modal:true" title="新增系统注册信息" style="width:470px;height:415px;" buttons="#dlg-buttons">
		<div class="easyui-panel window-body" style="height: 100%;">
			<form id="sysRegForm" method="post" class="window-form">
				<input type="hidden" id="sysRegId" name="sysRegId" />
				<input type="hidden" id="orgId" name="orgId" />
				<table cellpadding="3" class="form-table">
		    		<tr>
		    			<td>系统名称<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,256]']" required="true" missingMessage="不能为空" id="sysName" name="sysName" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >系统标识<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td >
		    				<input class="easyui-textbox" data-options="validType:['isBlank','unnormal','length[1,128]']" required="true" missingMessage="不能为空" type="text" id="sysFlag" name="sysFlag" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >访问地址<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" data-options="validType:['isBlank','length[1,1024]','url']" type="text" id="sysUrl" required="true" missingMessage="不能为空" name="sysUrl" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td>是否禁用:</td>
		    			<td>
		    				<input id="isDisable" class="easyui-switchbutton" onText="是" offText="否" checked>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否外围系统:</td>
		    			<td>
		    				<input id="isOutSys" class="easyui-switchbutton" onText="是" offText="否" checked>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>系统描述:</td>
		    			<td>
		    				<input class="easyui-textbox" data-options="validType:['length[1,1024]']" id="sysDesc" data-options="multiline:true" style="width:300px;height:80px" />
		    			</td>
		    		</tr>
		    	</table>
			</form>
		</div>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveSysReg()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#sysRegDialog').dialog('close')" plain="true">取消</a>
	</div>

</body>
</html>