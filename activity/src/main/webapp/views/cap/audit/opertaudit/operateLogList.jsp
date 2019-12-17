<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>操作日志管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/audit/opertaudit/js/operateLogList.js"></script>
	<style type="text/css">
       * {
        	font-size:14px;
       } 
	</style>
</head>

<body class="easyui-layout" style="width: 100%; height: 98%;">
	<div data-options="region:'center'" class="content">
		<!-- 工具栏 -->
		<div id="toolBar" class="clearfix">
			<form id="searchForm">
				<table cellpadding="3">
					<tr>
						<td>账号：</td>
						<td><input class="easyui-textbox" type="text" name="acctLogin" id="acctLogin" style="width:100px;"></input></td>
						<td>姓名：</td>
						<td><input class="easyui-textbox" type="text" name="userName" id="userName" style="width:100px;"></input></td>
						<td>操作时间：</td>
						<td><input class="easyui-datetimebox input_txt" style="width:180px;"  id="timeStart" name="timeStart" data-options="editable:false"></td>
						<td>-</td>
						<td><input class="easyui-datetimebox input_txt" style="width:180px;"  id="timeEnd" name="timeEnd" data-options="editable:false"></td>
						<td><a href="javascript:submitForm();" class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width:80px">查询</a></td>
					</tr>
					<tr>
						
					</tr>
				</table>
			</form>
		</div>
		<!-- 操作日志列表 -->
		<table class="easyui-datagrid" id="operateLogList" ></table>
	</div>
</body>
</html>