<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>流程模块绑定</title>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${ctx}/views/cap/bpm/solcfg/js/solcfg-update.js"></script>
</head>
<body class="easyui-layout" style="width:100%;height:100%">
	<!-- 页面布局西部 -->
	<div data-options="region:'west',split:true" title="业务解决方案类别" style="width:200px;">
		<span><button onclick="InitTreeData()" >刷新</button></span>
		<!-- 业务解决方案类别 -->
		<ul class="easyui-tree" id="bizSolCtlgTree"></ul>
	</div>
	
	<!-- 页面布局中部 -->
	<div data-options="region:'center',title:'业务流程解决方案'">
		<!-- 流程定义列表 -->
		<table class="easyui-datagrid" id="bizSolInfoList"
			data-options="idField:'id',toolbar:'#toolbar',striped:true,fitColumns:true,fit:true,rownumbers:true,pagination:true,nowrap:false,showFooter:true,nowrap:false">
			<thead>
				<tr>
					<th data-options="field :'ck',checkbox:true"></th>
					<th data-options="field :'procDefId_',hidden:true"></th>
					<th data-options="field:'solName_',width:100">解决方案名称</th>
					<th data-options="field:'key_',width:100,align:'left'">标志键</th>
					<th data-options="field:'state_',width:100,align:'left'">状态</th>
					<th data-options="field:'createTime_',width:100,align:'left',formatter:formatterTime">创建时间</th>
				</tr>
			</thead>
		</table>
	</div>
</body>
</html>