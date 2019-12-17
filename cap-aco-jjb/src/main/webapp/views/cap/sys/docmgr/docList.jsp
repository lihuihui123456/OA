<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>文号管理</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	<script type="text/javascript" src="${ctx}/views/cap/sys/docmgr/js/docList.js"></script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
<!-- 页面布局 -->
		<div data-options="region:'west',split:true,collapsible:false" style="width: 25%;" class="page_menu">
			<!-- 部门机构树 -->
			<div class="search-tree">
				<ul class="easyui-tree" id="doc_num_tree" />
			</div>
		</div>
		<!-- 右键菜单 -->
	<div id="mm" class="easyui-menu" style="width: 60px;">
		<div id="addMenu" onclick="addNote()" data-options="iconCls:'icon-add'">新增节点</div>
		<div id="editMenu" onclick="modNote()" data-options="iconCls:'icon-edit'">修改节点</div>
		<div id="delMenu" onclick="delNote()" data-options="iconCls:'icon-remove'">删除节点</div>
	</div>
	<div data-options="region:'center'" class="content">
		<!-- 列表 -->
		<div id="toolBar" class="clearfix">
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:docNumMgrController:docList">
					<a href="javascript:void(0)" onclick="saveInfo()" id="btn_add" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission> 
				<shiro:hasPermission name="modify:docNumMgrController:docList">
					<a href="javascript:void(0)" class="easyui-linkbutton" id="btn_edit" iconCls="icon-edit" plain="true" onclick="updateInfo()">修改</a> 
				</shiro:hasPermission> 
				<shiro:hasPermission name="delete:docNumMgrController:docList">
					<a href="javascript:void(0)" onclick="deleteInfo()" id="btn_del" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission> 
			</div>
			<div class="search-input">
				<input id="doc_name" class="easyui-searchbox" data-options="searcher:searchList,prompt:'输入文号名称'" />
			</div>
		</div>

		<table class="easyui-datagrid" id="dtlist" data-options="
				idField:'serial_id',treeField : 'serial_id', method:'post', striped : true,fitColumns : true,singleSelect : true,rownumbers : true,
				pagination : true,fit : true,nowrap : false,toolbar : '#toolBar',pageSize : 10,showFooter : true">
			<thead>
					<tr>
						<th data-options="field:'ck', checkbox:true"></th>
						<th data-options="field:'serial_id', hidden:true">文号ID</th>
						<th data-options="field:'dept_id', hidden:true">单位、部门ID</th>
						<th data-options="field:'serial_number_name', width:260, align:'left'">文号名称</th>
						<th data-options="field:'preview_effect', width:300, align:'left'">预览效果</th>
						<th data-options="field:'enable', width:100, align:'left', formatter:formaterState">是否启用</th>
					</tr>
				</thead>
		</table>
	</div>

	<div id="ff" class="easyui-dialog" title="文号设置"
		data-options="modal:true" closed="true"
		style="width:875px;height:320px;" buttons="#tb-add">
		<form action="" id="tableForm">
		    <input type="hidden" id="rows" name="rows">
			<input type="hidden" id="typeId" name="typeId">
			<input type="hidden" id="dept_id" name="dept_id">
			<table  cellspacing="3">
				<tr>
					<td>文号名称:<span style="color:red;vertical-align:middle;">*</span></td>
					<td colspan="5"><input class="easyui-textbox" id="serial_number_name" name="serial_number_name" required="true" 
						 missingMessage="不能为空" style="width:469px;"/></td>
				</tr>
				<tr>
					<td>前缀固定值1:</td>
					<td><input class="easyui-textbox prefix" id="prefix_value_one" name="prefix_value_one"  style="width:200px;"/></td>
					<td>前缀对象:</td>
					<td><input class="easyui-textbox prefix" id="prefix_object" name="prefix_object" style="width:200px;" /></td>
					 <td>前缀固定值2:</td>
					<td><input class="easyui-textbox prefix" id="prefix_value_two" name="prefix_value_two" style="width:200px;" /></td>
				</tr>
				<tr>
					<td>文号长度:<span style="color:red;vertical-align:middle;">*</span></td>
					<td><input class="easyui-textbox prefix" id="serial_number_length" name="serial_number_length" required="true" 
						 missingMessage="不能为空" validType="checkNumber" style="width:200px;" /></td>
					<td>起始值:<span style="color:red;vertical-align:middle;">*</span></td>
					<td><input class="easyui-textbox prefix" id="initial_value" name="initial_value" required="true" 
						 missingMessage="不能为空" validType="checkNumber" style="width:200px;" /></td>
					 <td>自然号:<span style="color:red;vertical-align:middle;">*</span></td>
					<td ><select class="easyui-combobox prefix" id="nature_number" name="nature_number"
							required="true" missingMessage="不能为空" style="width:200px" panelHeight="50">
								<option value="0">是</option>
								<option value="1">否</option>
						</select></td>
				</tr>
				<tr>
					<td>后缀固定值1:</td>
					<td><input class="easyui-textbox prefix" id="suffix_value_one" name="suffix_value_one" style="width:200px;" /></td>
					<td>后缀对象:</td>
					<td><input class="easyui-textbox prefix" id="suffix_object" name="suffix_object" style="width:200px;" /></td>
					 <td>后缀固定值2:</td>
					<td><input class="easyui-textbox prefix" id="suffix_value_two" name="suffix_value_two" style="width:200px;" /></td>
				</tr>
				<tr>
					<td>预览效果:</td>
					<td colspan="3"><input class="easyui-textbox  prefix" id="preview_effect" name="preview_effect" style="width:469px;" /></td>
				 <td>是否启用:<span style="color:red;vertical-align:middle;">*</span></td>
					<td ><select class="easyui-combobox prefix" id="enable" name="enable"
							required="true" missingMessage="不能为空" style="width:200px" panelHeight="50">
								<option value="0">是</option>
								<option value="1">否</option>
						</select></td>
				</tr>
			</table>
			<span>&nbsp;说明:前缀、后缀的固定值中使用:[YYYY]表示年;[MM]表示月;[DD]表示日.</span>
		</form>
	</div>
	
	<div id="tb-add" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			onclick="doSaveDocInfo()" plain="true">保存</a> <a href="javascript:void(0)"
			class="easyui-linkbutton"
			onclick="javascript:$('#ff').dialog('close')"
			plain="true">取消</a>
	</div>
	<!-- 自由表单 -->
	<div id="formTableDialog" class="easyui-dialog" title="新增节点"
		data-options="modal:true" closed="true"
		style="width:420px;height:300px;" buttons="#formTable-buttons">
		<form action="" id="tableDoc">
			<table cellpadding="3">
				<tr>
					<td>名称<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td><input class="easyui-textbox" type="text" data-options="required:true" 
					      id="name_" missingMessage="不能为空" style="width:300px;" /t></td>
				</tr>
				<tr>
					<td>业务类别<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td><input class="easyui-textbox" type="text" required="true"
						validType="checkcode" missingMessage="不能为空" id="code_" style="width:300px;" /></td>
				</tr>
				<tr>
					<td>备注：</td>
					<td><input class="easyui-textbox" id="remark_" data-options="multiline:true" style="width:300px;height:50px" />
					</td>
				</tr>
			</table>
		</form>
	</div>
	<!-- 自由表单按钮 -->
	<div id="formTable-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			onclick="savetype()" plain="true">保存</a> <a href="javascript:void(0)"
			class="easyui-linkbutton"
			onclick="javascript:$('#formTableDialog').dialog('close')"
			plain="true">取消</a>
	</div>
</body>
</html>