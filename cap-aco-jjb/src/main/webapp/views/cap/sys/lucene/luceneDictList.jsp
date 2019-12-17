<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>索引词典管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/lucene/js/luceneDictList.js"></script>
	
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<div data-options="region:'center'" class="content">
		<!-- 工具栏 -->
		<div id="toolBar" class="clearfix">
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:timerController:luceneDictList">
					<a href="javascript:void(0)" onclick="openForm('新增词库信息')" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>				
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:timerController:luceneDictList">
					<a href="javascript:void(0)" onclick="openUpdateForm('修改词库信息')" id="btn_edit" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>				
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:timerController:luceneDictList">
					<a href="javascript:void(0)" onclick="doDeleteDict()" class="easyui-linkbutton" id="btn_del" iconCls="icon-remove" plain="true">删除</a>				
				</shiro:hasPermission>
			</div>
		</div>
		<!-- 列表 -->
		<table class="easyui-datagrid" id="dictList"></table>
	</div>
	<!-- Form表单 -->
	<div id="dictDialog" class="easyui-dialog"  closed="true" data-options="modal:true" title="新增词典" style="width:470px;height:335px;" buttons="#dlg-buttons">
		<div class="easyui-panel window-body" style="height: 100%;">
			<form id="dictForm" method="post" class="window-form" enctype="multipart/form-data">
				<input type="hidden" id="id" name="id" />
				<table cellpadding="3" class="form-table">
		    		<tr>
		    			<td>词库类型名称<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,64]']" required="true" missingMessage="不能为空" id="typeName" name="typeName" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td>描述:</td>
		    			<td>
		    				<input class="easyui-textbox" id="typeDesc" name="typeDesc" data-options="multiline:true" style="width:300px;height:80px" />
		    			</td>
		    		</tr>
		    		<tr id="path">
		    			<td >词库类型路径<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input id="filePath" name="filePath" class="easyui-filebox" style="width:95%" data-options="prompt:'请选择词库路径...'" />
		    			</td>
		    		</tr>
		    	</table>
			</form>
		</div>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveDict()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#dictDialog').dialog('close')" plain="true">取消</a>
	</div>
</body>
</html>