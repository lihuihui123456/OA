<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>在线用户管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/onLine/js/onLineList.js"></script>
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
						<td>用户姓名：</td>
						<td><input class="easyui-textbox" type="text" name="userName" id="userName" style="width:140px;"></input></td>
						<td>登陆账号：</td>
						<td><input class="easyui-textbox" type="text" name="acctLogin" id="acctLogin" style="width:140px;"></input></td>
						<td>终端类型：</td>
						<td><select class="easyui-combobox" style="width:160px;"  id="terminalType" name="terminalType" data-options="editable:false"></select></td>
						<td><a href="javascript:submitForm();" class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width:80px">查询</a></td>
					</tr>
				</table>
			</form>
		</div>
		<!-- 在线用户列表 -->
		<table class="easyui-datagrid" id="onlineList" data-options="view : dataGridExtendView,emptyMsg : '没有相关记录！',
			idField:'orgId', method:'post', toolbar:'#toolBar',striped:true,fitColumns:true,fit:true,rownumbers:true,pagination:true,showFooter:true,nowrap:false">
			<thead>
				<tr>
					<!-- <th data-options="field:'ck', checkbox:true"></th> -->
					<th data-options="field:'userName', width:180, align:'left'">用户姓名</th>
					<th data-options="field:'acctLogin', width:180, align:'left'">登陆账号</th>
					<th data-options="field:'onlineTime', width:180, align:'left'">上线时间</th>
<!-- 					<th data-options="field:'offlineTime', width:180, align:'left'">下线时间</th>
 -->					<th data-options="field:'terminalType', width:80, align:'left', formatter:formatType">终端</th>
					<th data-options="field:'ipAddr', width:100, align:'left'">IP地址</th>
					<th data-options="field:'onlineState', width:60, align:'left', formatter:formatState">是否在线</th>
					<th data-options="field:'operator', width:60, align:'left', formatter:formatOperate">操作</th>
				</tr>
			</thead>
		</table>
	</div>
</body>
</html>