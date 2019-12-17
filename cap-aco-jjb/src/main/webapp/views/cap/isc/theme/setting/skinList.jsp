<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>颜色管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/setting/js/skinList.js"></script>
	
	<script type="text/javascript">
		var path = '${ctx}';
	</script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	
	<div data-options="region:'center'" class="content">
		<!-- 工具栏 -->
		<div id="toolBar" class="clearfix">
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:skinController:skinList">
					<a href="javascript:void(0)" onclick="openForm('新增系统皮肤信息')" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:skinController:skinList">
					<a href="javascript:void(0)" onclick="openUpdateForm('修改系统皮肤信息')" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:skinController:skinList">
					<a href="javascript:void(0)" onclick="doDeleteSkin()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission> 
			</div>
			<div class="search-input">
				<input id="skin_name" class="easyui-searchbox" data-options="searcher:searchList,prompt:'输入皮肤名称'" />
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
		</div>
		<!-- 系统皮肤列表 -->
		<table class="easyui-datagrid" id="skinList"></table>
	</div>
	<!-- 系统皮肤Form表单 -->
	<div id="skinDialog" class="easyui-dialog"  closed="true" data-options="modal:true" style="width:510px;height:345px;" buttons="#dlg-buttons">
		<div class="easyui-panel window-body" style="height: 100%;">
			<form id="skinForm" method="post" class="window-form" enctype="multipart/form-data">
				<input type="hidden" id="skinId" name="skinId" />
				<table cellpadding="3" class="form-table">
		    		<tr>
		    			<td>皮肤名称<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,256]']" required="true" missingMessage="不能为空" id="skinName" name="skinName" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >皮肤编码<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td >
		    				<input class="easyui-textbox" data-options="validType:['isBlank','unnormal','length[1,128]']" required="true" missingMessage="不能为空" type="text" id="skinCode" name="skinCode" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >状态：</td>
		    			<td >
		    				<input id="is_valid" class="easyui-switchbutton" onText="启用" offText="禁用" checked />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >默认皮肤：</td>
		    			<td >
		    				<input id="isDefault" class="easyui-switchbutton" onText="是" offText="否" unchecked />
		    			</td>
		    		</tr>
		    	</table>
			</form>
		</div>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveSkin()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#skinDialog').dialog('close')" plain="true">取消</a>
	</div>
</body>
</html>