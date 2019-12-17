<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>sql语句</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/css/style.css">
<script type="text/javascript"
	src="${ctx}/views/cap/form/js/formlist.js"></script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<div data-options="region:'center'" class="content">
		<div id="toolbar1" class="clearfix">
			<div class="search-input">
				<input id="search" class="easyui-searchbox"
					data-options="searcher:findByCondition,prompt:'编码/名称'"> <span
					class="clear" onclick="clearSearchBox('search')"></span>
			</div>
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission
					name="add:formModelDesginController:freeFormIndex">
					<a href="javascript:void(0)" onclick="createForm()"
						class="easyui-linkbutton" id="btn_add" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission
					name="copy:formModelDesginController:freeFormIndex">
					<a href="javascript:void(0)" onclick="copyForm()"
						class="easyui-linkbutton" id="btn_copy" iconCls="icon-add" plain="true">复制</a>
				</shiro:hasPermission>
				<shiro:hasPermission
					name="modify:formModelDesginController:freeFormIndex">
					<a href="javascript:void(0)" class="easyui-linkbutton"
						iconCls="icon-edit" plain="true" id="btn_edit" onclick="updateForm()">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission
					name="delete:formModelDesginController:freeFormIndex">
					<a href="javascript:void(0)" onclick="deleteInfo()"
						class="easyui-linkbutton" iconCls="icon-remove" id="btn_del" plain="true">删除</a>
				</shiro:hasPermission>
				<shiro:hasPermission
					name="asstfloat:formModelDesginController:freeFormIndex">
					<a href="javascript:void(0)" onclick="openFloatTabDl()" class="easyui-linkbutton" iconCls="icon-add" id="asst_float_table" plain="true">关联浮动表</a>
				</shiro:hasPermission>
				<shiro:hasPermission
					name="formDesign:formModelDesginController:freeFormIndex">
					<a href="javascript:void(0)" onclick="formDesgin()"
						class="easyui-linkbutton" iconCls="icon-add" id="btn_des" plain="true">表单设计</a>
				</shiro:hasPermission>
			</div>
		</div>
		<table class="easyui-datagrid" id="tb1"></table>
	</div>
	<div id="formCtlgDlg" class="easyui-dialog" closed="true" title=""
		style="width:300px;height:340px;padding:10px">
		<form id="formCtlg">
			<div style="margin-bottom:5px">
				<div>
					表单编码:<span class="input-must">*</span>
				</div>
				<input class="easyui-validatebox textbox" id="form_code"
					name="form_code" style="width:100%;height:32px">
			</div>
			<div style="margin-bottom:5px">
				<div>
					表单名称:<span class="input-must">*</span>
				</div>
				<input class="easyui-validatebox textbox" id="form_name"
					name="form_name" style="width:100%;height:100px">
			</div>
			<div style="margin-bottom:5px">
				<div>
					选择数据源:<span class="input-must">*</span>
				</div>
				<select id="form_datasource"
					class="easyui-combotree easyui-validatebox" name="form_datasource"
					required="true" missingMessage="不能为空" style="width:100%"
					data-options=""></select>

			</div>
			<div id="formCloumn-buttons" class="window-tool">

				<a href="javascript:void(0)" class="easyui-linkbutton"
					onclick="saveForm()" plain="true">保存</a> <a
					href="javascript:void(0)" class="easyui-linkbutton"
					onclick="javascript:$('#formCtlgDlg').dialog('close')" plain="true">取消</a>
			</div>
		</form>
	</div>
	
	<!-- 浮动表list START -->
	<div id="floatTableDialog" class="easyui-dialog"  closed="true" title="浮动表列表" data-options="modal:true" style="width:90%;height:90%;padding:10px">
		<div class="easyui-layout" style="width:100%;height:100%;">
			<div data-options="region:'center'" class="content">
				<!-- 工具栏 -->
				<div id="floatTableToolBar" class="clearfix">
					<div class="search-input">
						<input id="floatTableSearch" class="easyui-searchbox" data-options="searcher:findFloatTalbeByCondition,prompt:'输入浮动表名称'">
						<span class="clear" onclick="clearSearchBox('floatTableSearch')"></span>
					</div>
					<div id="floatTableOperateBtn" class="tool_btn">
						<shiro:hasPermission name="addfloat:formModelDesginController:freeFormIndex">
							<a href="javascript:void(0)" onclick="openFloatTableForm('add')" id="btn_floatTable_add" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
						</shiro:hasPermission>	
						<shiro:hasPermission name="editfloat:formModelDesginController:freeFormIndex">
							<a href="javascript:void(0)" onclick="openFloatTableForm('update')" id="btn_floatTable_edit" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="delfloat:formModelDesginController:freeFormIndex">
							<a href="javascript:void(0)" onclick="deleteFloatTable()" id="btn_floatTable_del" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
						</shiro:hasPermission>
					</div>
				</div>
				<!-- 浮动表列表 -->
				<table class="easyui-datagrid" id="floatTable"></table>
			</div>
		</div>	
	</div>
	<!-- 浮动表 END -->
	
	<!-- 新增浮动表表单 START -->
	<div id="tableAddDialog" class="easyui-dialog"  closed="true" title="新增浮动表" data-options="modal:true" style="width:90%;height:90%;padding:10px" buttons="#tabledlg-buttons">
		<iframe frameborder="0" name="tableAddFrame" id="tableAddFrame"
			width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
	</div>
	<div id="tabledlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveFloatTable()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#tableAddDialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 浮动表表单 END -->

</body>
</html>