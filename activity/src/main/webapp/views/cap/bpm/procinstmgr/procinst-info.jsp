<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流程实例基本信息</title>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.edatagrid.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript">

	</script>
</head>
<body>
	<table class="table-style">
		<tr>
			<th style="width:50px">标题</th>
			<td colspan='3'>${actproinst.biz_title_}</td>
		</tr>
		<tr>
			<th style="width:200px">运行状态</th>
			<td style="width:200px">${actproinst.state_}</td>
			<th style="width:200px">版本</th>
			<td style="width:200px">${actproinst.proc_def_id_}</td>
		</tr>
		<tr>
			<th>是否为测试</th>
			<td></td>
			<th>结束时间</th>
			<td>${actproinst.end_time_}</td>
		</tr>
		<tr>
			<th>实例ID</th>
			<td colspan='3'>${actproinst.id_}</td>
		</tr>
	</table>
	<br/>
	<table class="table-style">
		<thead>
			<tr>
				<th colspan="4" class="Theader">更新信息</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th style="width:200px">创建人</th>
				<td style="width:200px">${actproinst.create_user_name}</td>
				<th style="width:200px">创建时间</th>
				<td style="width:200px">${actproinst.start_time_}</td>
			</tr>
			<tr>
				<th>更新人</th>
				<td></td>
				<th>更新时间</th>
				<td></td>
			</tr>
		</tbody>
	</table>
</body>
</html>