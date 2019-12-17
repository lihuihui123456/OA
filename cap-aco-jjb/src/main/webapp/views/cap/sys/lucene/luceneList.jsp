<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>驱动类型</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/css/style.css">
<script type="text/javascript"
	src="${ctx}/views/cap/sys/lucene/js/luceneList.js"></script>
</head>
<body class="easyui-layout" style="width: 100%;height:98%">
	<div data-options="region:'center'" class="content">
		<!-- 部门类型列表 -->
		<div id="toolBar" class="clearfix">
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:luceneController:luceneList">
					<a href="javascript:void(0)" onclick="saveInfo()" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:luceneController:luceneList">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" id="btn_edit" plain="true" onclick="updateInfo()">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:luceneController:luceneList">
					<a	href="javascript:void(0)" onclick="deleteInfo()" class="easyui-linkbutton" id="btn_del" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="test:luceneController:luceneList">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-help" id="btn_test" plain="true" onclick="testConnUrl()">测试</a>
				</shiro:hasPermission>
			</div>
		</div>

		<table class="easyui-treegrid" id="dtlist" hidden="hidden"></table>

	</div>
	
	<div id="ff" class="easyui-dialog" title="添加数据库信息"
		data-options="modal:true" closed="true"
		style="width:410px;height:315px;" buttons="#tb-add">
		<form action="" id="tableForm">
			<input type="hidden" id="rows" name="rows"> <input
				type="hidden" id="typeId" name="typeId">
			<table cellpadding="3">
				<tr>
					<td>数据库名:<span style="color:red;vertical-align:middle;">*</span>
					</td>
					<td><input class="easyui-textbox" id="name" name="name"
						required="true" validType="checkName" missingMessage="不能为空"
						style="width:300px;" /></td>
				</tr>
				<tr>
					<td>URL:<span style="color:red;vertical-align:middle;">*</span>
					</td>
					<td><input class="easyui-textbox" id="url" name="url"
						required="true" validType="checkUrl" missingMessage="不能为空"
						style="width:300px;" /t></td>
				</tr>
				<tr>
					<td>用户名:<span style="color:red;vertical-align:middle;">*</span>
					</td>
					<td><input class="easyui-textbox" id="user" name="user"
						required="true" validType="checkName" missingMessage="不能为空"
						style="width:300px;" /></td>
				</tr>
				<tr>
					<td>密码:</td>
					<td><input class="easyui-textbox" id="pwd" name="pwd"
						validType="checkName" style="width:300px;height:50px" /></td>
				</tr>
				<tr>
					<td>驱动:</td>
					<td><select class="easyui-combobox" id="driver" name="driver"
						style="width:300px" panelHeight="50">
							<option value="com.mysql.jdbc.Driver">com.mysql.jdbc.Driver</option>
							<option value="oracle.jdbc.OracleDriver">oracle.jdbc.OracleDriver</option>
							<option value="net.sf.log4jdbc.DriverSpy">net.sf.log4jdbc.DriverSpy</option>
					</select></td>
				</tr>
			</table>
		</form>
	</div>

	<div id="tb-add" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			onclick="test()" plain="true">测试</a> <a href="javascript:void(0)"
			class="easyui-linkbutton" onclick="doSaveIntfcInfo()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton"
			onclick="javascript:$('#ff').dialog('close')" plain="true">取消</a>
	</div>

</body>
</html>