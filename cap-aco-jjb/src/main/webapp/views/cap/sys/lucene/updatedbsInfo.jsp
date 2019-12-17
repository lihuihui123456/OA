<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>新jia数据库信息</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/sys/lucene/js/luceneInfo.js"></script>

	<style type="text/css">
       * {
        	font-size:12px;
       } 
	</style>
	


</head>
<body>
		<div class="easyui-panel" style="padding-left:10px;">
			<form id="ff" name="ff" method="post" novalidate>
				<input type="hidden" id="rows" name="rows" ">
				<table class="">
					<tr hidden="hidden">
						<td>id:</td>
						<td><input class="easyui-textbox" id="id" name="id"
							style="height:32px;width:100%" value="${dbConn.id }"></td>
					</tr>
					<tr>
						<td>URL:</td>
						<td colspan="4"><input class="easyui-textbox" id="url" name="url"
							style="height:32px;width:100%" value="${dbConn.luceData }"></td>
					</tr>
					<tr>
						<td>用户名:</td>
						<td><input class="easyui-textbox" id="user" name="user" value="${dbConn.luceName }"
							style="height:32px;width:100%"></td>
						<td>密码:</td>
						<td><input class="easyui-textbox" id="pwd" name="pwd" value="${dbConn.lucePass }"
							style="height:32px;width:100%"></td>
					</tr>
					<tr>
						<td>驱动:</td>
						<td colspan="4"><select class="easyui-combobox" id="driver" name="driver" value="${dbConn.luceDriver }"
							style="width:100%" panelHeight="50">
								<option value="com.mysql.jdbc.Driver">com.mysql.jdbc.Driver</option>
								<option value="oracle.jdbc.OracleDriver">oracle.jdbc.OracleDriver</option>
						</select></td>
					</tr>
				</table>
				
				<a onclick="doSaveIntfcInfo('1')" class="easyui-linkbutton" iconCls="icon-ok"
					style="width:150px;height:32px">保存</a>
				</div><br>
			</form>
		</div>
		</div>
	</div>
</body>
</html>