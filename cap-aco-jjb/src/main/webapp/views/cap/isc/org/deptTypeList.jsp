<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>部门类型管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/org/js/deptTypeList.js"></script>

</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<div data-options="region:'center'" class="content">
		<!-- 部门类型列表 -->
		<div id="toolBar" class="clearfix">
			<!-- 条件查询 -->
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入部门类型名称或编码'"/>
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<!-- 工具栏 -->
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:deptTypeController:deptTypeList">
					<a href="javascript:void(0)" onclick="doAddDeptTypeBefore()" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:deptTypeController:deptTypeList">
					<a href="javascript:void(0)" onclick="doUpdateDeptTypeBefore()" class="easyui-linkbutton" id="btn_dept_type_update" iconCls="icon-edit" plain="true">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:deptTypeController:deptTypeList">
					<a href="javascript:void(0)" onclick="doDeleteDeptType()" class="easyui-linkbutton" id="btn_dept_type_del" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission>
			</div>
		</div>

		<!-- 部门类型列表 -->
		<table class="easyui-datagrid" id="deptTypeDataGrid"></table>
	</div>

	<!-- 部门类型信息新增修改对话框 -->
	<div id="deptTypeDialog" class="easyui-dialog" closed="true" data-options="modal:true" style="width:570px;height:320px;padding: 10px;" buttons="#dlg-buttons">
		<form id="deptTypeForm" method="post">
			<input type="hidden" id="deptTypeId" name="deptTypeId">
			<input type="hidden" id="deptTypeCode" name="deptTypeCode" >
			<table cellpadding="3">
				<tr>
					<td>部门类型名称<span style="color:red;vertical-align:middle;">*</span>:</td>
					<td>
						<input class="easyui-textbox" id="deptTypeName" name="deptTypeName" required="true" data-options="validType:['isBlank','unnormal','length[1,128]']" style="width:300px;vertical-align: middle;" missingMessage="不能为空">
					</td>
				</tr>
				<tr>
					<td>是否封存:</td>
					<td>
						<input id="isSeal" class="easyui-switchbutton" onText="否" offText="是" checked>
					</td>
				</tr>
				<tr>
					<td>部门类型描述:</td>
					<td>
						<input class="easyui-textbox" id="deptTypeDesc" name="deptTypeDesc" data-options="multiline:true" style="width:300px;height:80px">
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveOrUpdateDeptType()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#deptTypeDialog').dialog('close')" plain="true">取消</a>
	</div>
</body>
</html>