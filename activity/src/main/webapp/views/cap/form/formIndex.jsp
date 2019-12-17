<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<script type="text/javascript"
	src="${ctx}/views/cap/form/js/formIndex.js"></script>

<style>
</style>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<input type="hidden" id="typeid">

	<!-- 左侧自由表单区域 -->
	<div data-options="region:'west',split:true,collapsible:false"
		style="width: 200px;" class="page_menu">
		<div class="search-tree">
			<input id="org_search" class="easyui-searchbox"
				data-options="searcher:orgTreeSearch,prompt:'输入表单名称'" />
			<!-- 左侧自由表单树 -->
			<ul class="easyui-tree" id="tree"></ul>
		</div>
		<!-- 右键菜单 -->
		<div id="mm" class="easyui-menu" style="width: 60px;">
			<div id="addMenu" onclick="addNote()"
				data-options="iconCls:'icon-add'">新增数据库表</div>
			<div id="editMenu" onclick="modNote()"
				data-options="iconCls:'icon-edit'">修改数据库表</div>
			<div id="delMenu" onclick="delNote()"
				data-options="iconCls:'icon-remove'">删除数据库表</div>
			<div id="copyMenu" onclick="copyNote()"
				data-options="iconCls:'icon-remove'">复制数据库表</div>
		</div>
	</div>



	<!-- 右侧自由表单列表区域 -->
	<div data-options="region:'center'" class="content">
		<div id="tb" class="clearfix">
			<div class="search-input">
				<input id="search" class="easyui-searchbox"
					data-options="searcher:findByCondition,prompt:'编码/名称'"> <span
					class="clear" onclick="clearSearchBox()"></span>
			</div>
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:formTableController:formIndex">
					<a href="javascript:void(0)" class="easyui-linkbutton"
						data-options="iconCls:'icon-add',plain:true" id="btn_add" onclick="append()">添加</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:formTableController:formIndex">
					<a href="javascript:void(0)" class="easyui-linkbutton"
						data-options="iconCls:'icon-edit',plain:true" id="btn_edit" onclick="edit()">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:formTableController:formIndex">
					<a href="javascript:void(0)" class="easyui-linkbutton"
						data-options="iconCls:'icon-remove',plain:true"
						onclick="removeit('col')" id="btn_del">删除</a>
				</shiro:hasPermission>
				<shiro:hasPermission
					name="permissions:formTableController:formIndex">
					<a href="javascript:void(0)" class="easyui-linkbutton"
						data-options="iconCls:'icon-isc-qxfp',plain:true"
						onclick="setRoles('col')" id="btn_perm">权限设置</a>
					<!-- <a href="javascript:void(0)"
					class="easyui-linkbutton"
					data-options="iconCls:'icon-isc-qxfp',plain:true"
					onclick="setServeRoles()">通用设置</a> -->
				</shiro:hasPermission>
				<shiro:hasPermission name="defaultVal:formTableController:formIndex">
					<a href="javascript:void(0)" class="easyui-linkbutton"
						data-options="iconCls:'icon-large-shapes',plain:true"
						onclick="setDatas('col')" id="btn_set">默认值配置</a>
				</shiro:hasPermission>
			</div>
		</div>
		<table class="easyui-datagrid" id="col"></table>
	</div>
	<!-- 权限设置 -->
	<div id="setrole" class="easyui-dialog" title="字段权限设置"
		data-options="modal:true" closed="true" style="width:80%;height:90%;">
		<iframe id="ifrole" style="width:98%;height:98%;" src=""></iframe>
	</div>
	<div id="setdata" class="easyui-dialog" title="数据规则设置"
		data-options="modal:true" closed="true" style="width:80%;height:90%;">
		<iframe id="ifdata" style="width:98%;height:98%;" src=""></iframe>
	</div>
	<!-- 自由表单 -->
	<div id="formTableDialog" class="easyui-dialog" title="新增数据库表"
		data-options="modal:true" closed="true"
		style="width:410px;height:320px;" buttons="#formTable-buttons">
		<form action="" id="tableForm">
			<table cellpadding="3">
				<tr>
					<td>浮动表</td>
					<td><input id="isFloat" class="easyui-switchbutton" onText="是" offText="否"></td>
				</tr>
				<tr>
					<td>表名<span style="color:red;vertical-align:middle;">*</span>：
					</td>
					<td><input class="easyui-textbox" type="text"
						data-options="required:true, validType:['checkTalCode','talNameRepeat']"
						id="tableCode" missingMessage="不能为空" style="width:300px;" /t></td>
				</tr>
				<tr>
					<td>中文名<span style="color:red;vertical-align:middle;">*</span>：
					</td>
					<td><input class="easyui-textbox" type="text"
						data-options="required:true, validType:['checkTalName','talCHNameRepeat']"
						missingMessage="不能为空" id="tableName" style="width:300px;" /></td>
				</tr>
				<tr>
					<td>备注：</td>
					<td><input class="easyui-textbox" id="remark"
						data-options="multiline:true" style="width:300px;height:50px" />
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
	<!-- 自由表单 -->
	<div id="formCloumnDialog" class="easyui-dialog" title="新增数据库表"
		data-options="modal:true" closed="true"
		style="width:650px;height:380px;" buttons="#formCloumn-buttons">
		<form action="" id="cloumnForm">
			<table cellpadding="3">
				<tr>
					<td>字段编码<span style="color:red;vertical-align:middle;">*</span>：
					</td>
					<td><input class="easyui-textbox" type="text"
						data-options="required:true, validType:['checkColCode','colCodeRepeat']"
						id="col_code" missingMessage="不能为空" style="width:200px;" /t></td>

					<td>字段名称<span style="color:red;vertical-align:middle;">*</span>：
					</td>
					<td><input class="easyui-textbox" type="text"
						data-options="required:true, validType:'checkColName'"
						missingMessage="不能为空" id="col_name" style="width:200px;" /></td>
				</tr>
				<tr>
					<td>字段类型<span style="color:red;vertical-align:middle;">*</span>：
					</td>
					<td><select class="easyui-combobox select_txt"
						style="width:200px;" id="col_type" name="col_type"
						panelHeight="150" data-options="editable:false">
					</select></td>
					<td>字段长度：</td>
					<td><input class="easyui-textbox"
						data-options="validType:'checkNumber'" id="col_length"
						style="width:200px;height:50px" /></td>
				</tr>
				<tr>
					<td>是否主键：</td>
					<td><input class="easyui-switchbutton" onText="是" offText="否"
						id="col_key" /></td>
					<td>是否流程字段：</td>
					<td><input class="easyui-switchbutton" onText="是" offText="否"
						id="wf_key" /></td>
				</tr>
				<tr>
					<td>控件：<a id="hp_ctr_type" href="javascript:void(0)"
						style=" text-decoration:none;">？</a></td>
					<td><select class="easyui-combobox select_txt"
						style="width:200px;" id="ctr_type" name="ctr_type"
						panelHeight="150" data-options="editable:true">
					</select></td>
					<!-- <td>参照类型：<a id="hp_ref_type" href="javascript:void(0)" style=" text-decoration:none;">？</a></td>
					<td><select class="easyui-combobox select_txt" style="width:200px;"  id="ref_type" name="ref_type" panelHeight="80" data-options="editable:true">
								</select></td>
				</tr>
				<tr> -->
					<td>值域：<a id="hp_dic_type" href="javascript:void(0)"
						style=" text-decoration:none;">？</a></td>
					<td><select class="easyui-combobox select_txt"
						style="width:200px;" id="dic_type" name="dic_type"
						panelHeight="150" data-options="editable:true">
					</select></td>
					</td>
					<!-- <td>参照对象：<a id="hp_ref_obj" href="javascript:void(0)" style=" text-decoration:none;">？</a></td>
					<td><select class="easyui-combobox select_txt" style="width:200px;"  id="ref_obj" name="ref_obj" panelHeight="80" data-options="editable:true">
								</select></td> -->
				</tr>
				<tr>
					<td>辅助输入：</td>
					<td><input class="easyui-switchbutton" onText="是" offText="否"
						id="ismemory" /></td>
					<td></td>
					<td></td>
				</tr>
			</table>
		</form>
	</div>
	<!-- 自由表单按钮 -->
	<div id="formCloumn-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			onclick="savecolumn()" plain="true">保存</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			onclick="javascript:$('#formCloumnDialog').dialog('close')"
			plain="true">取消</a>
	</div>
</body>
</html>