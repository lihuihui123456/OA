<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>字典类型</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/dict/js/dictIndex.js"></script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;" >
	<input type="hidden" id="typeid">

	<!-- 左侧数据字典区域 -->
	<div data-options="region:'west',split:true,collapsible:false" style="width: 200px;" class="page_menu">
		<div class="search-tree">
			<input id="org_search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入字典类型'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<!-- 左侧数据字典类型树 -->
			<ul class="easyui-tree" id="tree"></ul>
		</div>
	</div>

	<!-- 字典类型右键菜单 -->
	<div id="mm" class="easyui-menu" style="width: 60px;">
		<div onclick="addNote()">新增节点</div>
		<div onclick="modNote()">修改节点</div>
		<div onclick="delNote()">删除节点</div>
	</div>

	<!-- 右侧数据字典列表区域 -->
	<div data-options="region:'center',iconCls:'icon-ok'" class="content">
		<!-- 数据字典列表工具栏 -->
		<div id="toolbar1" class="clearfix">
			<div class="search-input">
				<input id="dict_name" class="easyui-searchbox" data-options="searcher:searchList,prompt:'输入数据字典值或简拼'" />
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:dictTypeController:dictIndex">
					<a href="javascript:void(0)" onclick="addData()" id="btn_add" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:dictTypeController:dictIndex">
					<a href="javascript:void(0)" class="easyui-linkbutton" id="btn_edit" iconCls="icon-edit" plain="true" onclick="modData()">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:dictTypeController:dictIndex">
					<a href="javascript:void(0)" onclick="delData()" id="btn_del" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="up:dictTypeController:dictIndex">
					<a href="javascript:void(0)" id="upsort" onclick="doUpSort()" class="easyui-linkbutton" iconCls="icon-top" plain="true">上移</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="down:dictTypeController:dictIndex">
					<a href="javascript:void(0)" id="downsort" onclick="doDownSort()" class="easyui-linkbutton" iconCls="icon-downp" plain="true">下移</a>
				</shiro:hasPermission>
			</div>
		</div>

		<!-- 右侧数据字典列表 -->
		<table class="easyui-datagrid" id="dictList"></table>
	</div>
	
	<!-- 字典类型表单 -->
	<div id="dictTypeDialog" class="easyui-dialog" title="新增字典类型" data-options="modal:true" closed="true" style="width:460px;height:305px;" buttons="#dictType-buttons">
		<form action="" id="typeForm">
			<table cellpadding="3">
				<tr>
					<td>字典类型名称<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td>
						<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,256]']" required="true" missingMessage="不能为空" id="dictTypeName" style="width:300px;" />
					</td>
				</tr>
				<tr>
					<td>字典类型标识<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td>
						<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,64]']" required="true" missingMessage="不能为空" id="dictTypeFlag" style="width:300px;">
					</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;字典类型描述:</td>
					<td>
						<input class="easyui-textbox" id="dictTypeDesc" data-options="multiline:true" style="width:300px;height:60px" />
					</td>
				</tr>
			</table>
		</form>
	</div>
	<!-- 字典类型表单按钮 -->
	<div id="dictType-buttons"  class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="savetype()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#dictTypeDialog').dialog('close')" plain="true">取消</a>
	</div>

	<!-- 字典Form表单 -->
	<div id="dictDialog" class="easyui-dialog" title="新增字典" data-options="modal:true" closed="true" style="width:450px;height:260px;" buttons="#dict-buttons">
		<form action="" id="dictForm">
			<table cellpadding="3">
				<tr>
					<td>数据字典值<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td>
						<input class="easyui-textbox" type="text" id="dictVal" data-options="validType:['isBlank','length[1,1024]']" required="true" missingMessage="不能为空" style="width:300px;" />
					</td>
				</tr>
				<tr>
					<td>数据字典编码<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td>
						<input class="easyui-textbox" type="text" id="dictCode" data-options="validType:['isBlank','length[1,128]']" required="true" missingMessage="不能为空" style="width:300px;" />
					</td>
				</tr>
				<tr>
					<td>数据字典简拼<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td>
						<input class="easyui-textbox" type="text" id="dictName" data-options="validType:['isBlank','length[1,128]']" required="true" missingMessage="不能为空" style="width:300px;" />
					</td>
				</tr>
			</table>
		</form>
	</div>
	<!-- 字典Form表单按钮 -->
	<div id="dict-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveData()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#dictDialog').dialog('close')" plain="true">取消</a>
	</div>
</body>
</html>