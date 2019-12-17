<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>登录日志管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/audit/loginaudit/js/auditLoginLogList.js"></script>
	<script type="text/javascript" src="${ctx }/static/cap/plugins/echarts/echarts.min.js"></script>
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
						<td>IP：</td>
						<td><input class="easyui-textbox" type="text" name="ipAddr" id="ipAddr" style="width:100px;"></input></td>
						<td>登录时间：</td>
						<td><input class="easyui-datetimebox input_txt" style="width:180px;"  id="loginTimeStart" name="loginTimeStart" data-options="editable:false"></td>
						<td>-</td>
						<td><input class="easyui-datetimebox input_txt" style="width:180px;"  id="loginTimeEnd" name="loginTimeEnd" data-options="editable:false"></td>
						<td><a href="javascript:submitForm();" class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width:80px">查询</a></td>
						<td><a href="javascript:openEchartsDlg();" class="easyui-linkbutton" style="width:80px">统计图表</a></td>
					</tr>
					<tr>
						
					</tr>
				</table>
			</form>
		</div>
		<!-- 在线用户列表 -->
		<table class="easyui-datagrid" id="auditLoginLogList" data-options="view : dataGridExtendView,emptyMsg : '没有相关记录！',
			idField:'sessionId', method:'post', toolbar:'#toolBar',striped:true,fitColumns:true,fit:true,rownumbers:true,pagination:true,showFooter:true,nowrap:false">
			<thead>
				<tr>
					<!-- <th data-options="field:'ck', checkbox:true"></th> -->
					<th data-options="field:'acctLogin', width:180, align:'left'">登陆账号</th>
					<th data-options="field:'userName', width:180, align:'left'">用户姓名</th>
					<th data-options="field:'ipAddr', width:100, align:'left'">登录IP</th>
					<th data-options="field:'sysName', width:100, align:'left'">业务系统</th>
 					<th data-options="field:'loginTime', width:180, align:'left'">登录时间</th>
 					<th data-options="field:'logoutTime', width:180, align:'left'">登出时间</th>
 					<th data-options="field:'onlineTime', width:80, align:'left'">在线时长（分）</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 图表弹出框 -->
	<div id="echartsDialog" class="easyui-dialog"  closed="true" data-options="modal:true" title="登录日志统计图" style="width:1000px;height:500px;" buttons="#dlg-buttons">
		<div>
			<table style="margin: auto;">
				<tr>
					<td>登录日期：</td>
					<td><input class="easyui-datebox input_txt" style="width:180px;"  id="loginTime" name="loginTime" data-options="editable:false"></td>
					<td><a href="javascript:getEdata();" class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width:80px">查询</a></td>
				</tr>
			</table>
		</div>
		<div id="echartsDiv" style="width: 100%;height:90%;"></div>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#echartsDialog').dialog('close')" plain="true">取消</a>
	</div>
</body>
</html>