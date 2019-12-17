<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
	<head>
		<title>用户组管理</title>
		<meta http-equiv="X-UA-Compatible" content="IE=8"/>
		<link href="${ctx}/static/cap/js/bootstrap/css/add-ons.min.css" rel="stylesheet" />
		<link href="${ctx}/static/cap/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
		<link href="${ctx}/static/cap/font/iconfont.css" rel="stylesheet" />
		<link href="${ctx}/static/cap/js/bootstrap/plugins/fullcalendar/css/fullcalendar.css" rel="stylesheet" />
		<link href="${ctx}/static/cap/js/bootstrap/css/style.min.css" rel="stylesheet">
		<link href="${ctx}/views/aco/main/css/pages.css" rel="stylesheet">
		<link href="${ctx}/views/aco/main/css/skin-red.css" rel="stylesheet">
		<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/selectUserGroup-bootstrap.js"></script>
		
	</head>
	<body class="easyui-layout" style="width: 100%; height: 100%;padding:10px">
		<!-- 用户组列表 -->
		<div id="toolBar" class="clearfix">
			<!-- 条件查询 -->
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入用户组编码或用户组名称'">
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
		</div>
		<!-- 用户组列表 -->
		<table class="easyui-datagrid" id="userGroupList"></table>
		<!-- 用户组信息新增修改对话框 -->
		
	</body>
</html>