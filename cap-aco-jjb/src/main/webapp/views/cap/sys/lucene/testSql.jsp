<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>检索索引管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
	<script type="text/javascript" src="${ctx}/views/cap/sys/lucene/js/testConn.js"></script>
	<script type="text/javascript">
		var id = '${id}';
	</script>

</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<input type="hidden" id="typeid">
	<div data-options="region:'west',split:true,collapsible:false" class="page_menu" style="width:150px">
		<div class="search-tree">
			<ul class="easyui-tree" id="dataSource"></ul>
		</div>
	</div>
	
	<div data-options="region:'center'" class="content">
		<div id="toolbar1" class="clearfix">
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:luceneController:indexList">
					<a href="javascript:void(0)" onclick="savesqls()" id="btn_add" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>				
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:luceneController:indexList">
					<a href="javascript:void(0)" class="easyui-linkbutton" id="btn_edit" iconCls="icon-edit" plain="true" onclick="updatesql()">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:luceneController:indexList">
					<a href="javascript:void(0)" onclick="deleteInfo()" id="btn_del" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a> 
				</shiro:hasPermission>
				<shiro:hasPermission name="index:luceneController:indexList">
					<a href="javascript:void(0)" onclick="choiseTime()" id="btn_create" class="easyui-linkbutton" iconCls="icon-add" plain="true">创建索引</a>
				</shiro:hasPermission>
			</div>
		</div>
		<table class="easyui-datagrid" id="tb1"></table>
	</div>
	
	<div id="add_sql_dialog" class="easyui-dialog" title="新增接口信息" data-options="modal:true"
		closed="true" style="width:550px;height:500px;padding:0 10px"
		buttons="#dlg-buttons">
		<form id="add_sqls_form" name="add_sqls_form" method="post" novalidate>
			<input type="hidden" id="rows" name="rows"> <input
				type="hidden" id="typeId" name="typeId"> <input
				type="hidden" id="id" name="id"> <input id="dbsid"
				name="dbsid" value="${id}" type="hidden"> <br />
			<table class="">
				<tr>
					<td colSpan="2">sql语句<span style="color:red;vertical-align:middle;">*</span>：<input class="easyui-textbox" id="sql" name="sql"
					required="true"	data-options="multiline:true"  style="height:40px;width:100%"></td>
				</tr>
				<tr>
					<td>索引类型<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td><!-- <input class="easyui-textbox" id="index_type" name="index_type"
						style="height:32px;width:200px"> -->
						<select class="easyui-combobox select_txt" style="width:200px;"  id="index_type" name="index_type" panelHeight="80" data-options="editable:false">
								</select></td>
						</td>
				</tr>
				<tr>
					<td style="display:block;height:32px;width:200px">表名<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td><input class="easyui-textbox" id="luce_table" name="luce_table"
						required="true" validType="checkName" missingMessage="不能为空" style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td style="height:32px;width:200px">主键字段<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td><input class="easyui-textbox" id="luce_id" name="luce_id"
						required="true" validType="checkName" missingMessage="不能为空" style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td>标题字段<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td><input class="easyui-textbox" id="luce_title" name="luce_title"
						required="true" validType="checkName" style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td>内容字段<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td><input class="easyui-textbox" id="luce_contents" name="luce_contents"
						required="true" validType="checkName" missingMessage="不能为空" style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td>权限字段:</td>
					<td><input class="easyui-textbox" id="luce_role" name="luce_role"
						style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td>其他业务字段:</td>
					<td><input class="easyui-textbox" id="luce_key" name="luce_key"
						style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td>时间字段<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td><input class="easyui-textbox" id="luce_time" name="luce_time"
						required="true" style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td>连接地址<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td><input class="easyui-textbox" id="luce_path" name="luce_path"
						required="true"  missingMessage="不能为空" style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td>附件字段 ：</td>
					<td><input class="easyui-textbox" id="luce_annex" name="luce_annex"
						 style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td>附件主键 ：</td>
					<td><input class="easyui-textbox" id="luce_document" name="luce_document"
						 style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td>正文字段:</td>
					<td><input class="easyui-textbox" id="luce_condition" name="luce_condition"
						style="height:32px;width:200px"></td>
				</tr>
				
				
			</table>
		</form>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			onclick="doSaveSqlInfo()" plain="true">保存</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			onclick="javascript:$('#add_sql_dialog').dialog('close')"
			plain="true">取消</a>
	</div>
	
	<div id="choice_time" class="easyui-dialog" title="选择索引时间" data-options="modal:true"
		closed="true" style="width:550px;height:200px;padding:0 10px"
		buttons="#time-buttons">
		<form id="choice_time_form" name="choice_time_form" method="post" novalidate>
			<br />
			<table class="">
				<tr>
					<td style="">全部：</td>
					<td><input id="isAdmin" class="easyui-switchbutton" onText="是"  offText="否"></td>
				</tr>
				<tr>
					<td style="">时间区间：</td>
					<td id="gettime"><input class="easyui-datebox input_txt" disabled="true" style="width:200px;"  id="start_time" name="start_time" data-options="editable:false">
					~<input class="easyui-datebox input_txt" style="width:200px;" disabled="true" id="end_time"  name="end_time" data-options="editable:false"></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="time-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			onclick="createIndex()" plain="true">确定</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			onclick="javascript:$('#choice_time').dialog('close')"
			plain="true">取消</a>
	</div>
</body>
</html>