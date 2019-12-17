<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>索引权限管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
	<script type="text/javascript" src="${ctx}/views/cap/sys/lucene/js/luceneRole.js"></script>
	<script type="text/javascript">
		var sid = '${sid}';
	</script>

</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<input type="hidden" id="typeid">
	
	<div data-options="region:'west',split:true,collapsible:false" class="page_menu" style="width:200px">
		<div class="search-tree">
			<ul class="easyui-tree" id="dataSource"></ul>
		</div>
	</div>
	
	<div data-options="region:'center'" class="content">
		<div id="toolbar1" class="clearfix">
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:luceneRoleController:luceneRoleIndex">
					<a href="javascript:void(0)" onclick="savesqls()" id="btn_add" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>				
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:luceneRoleController:luceneRoleIndex">
					<a href="javascript:void(0)" id="btn_edit" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updatesql()">修改</a>				
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:luceneRoleController:luceneRoleIndex">
					<a href="javascript:void(0)" onclick="deleteInfo()" id="btn_del" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>				
				</shiro:hasPermission>
			</div>
		</div>
		<table class="easyui-datagrid" id="tb1"></table>
	</div>	
	
	<div id="add_sql_dialog" class="easyui-dialog" title="新增接口信息" data-options="modal:true"
		closed="true" style="width:550px;height:400px;padding:0 10px"
		buttons="#dlg-buttons">
		<form id="add_sqls_form" name="add_sqls_form" method="post" novalidate>
			<input type="hidden" id="rows" name="rows"> <input
				type="hidden" id="typeId" name="typeId"> <input
				type="hidden" id="id" name="id"> <input id="dbsid"
				name="dbsid" value="${id}" type="hidden"> <br />
			<table class="">
				<tr>
					<td colSpan="2">sql语句<span style="color:red;vertical-align:middle;">*</span>：<input class="easyui-textbox" id="sql"
						name="sql" data-options="multiline:true"
						style="height:40px;width:100%"></td>
				</tr>
				<tr>
					<td style="height:32px;width:200px">用户id字段<span
						style="color:red;vertical-align:middle;">*</span>：
					</td>
					<td><input class="easyui-textbox" id="userid" name="userid"
						required="true" validType="checkName" 
						style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td>用户编码<span style="color:red;vertical-align:middle;">*</span>：
					</td>
					<td><input class="easyui-textbox" id="usercode"
						name="usercode" required="true" validType="checkName"
						style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td>条件外键<span style="color:red;vertical-align:middle;">*</span>：
					</td>
					<td><input class="easyui-textbox" id="condition"
						name="condition" required="true" validType="checkName"
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
			<a href="javascript:void(0)" class="easyui-linkbutton"
			onclick="CheckSql()" plain="true">测试</a>
	</div>
</body>
</html>