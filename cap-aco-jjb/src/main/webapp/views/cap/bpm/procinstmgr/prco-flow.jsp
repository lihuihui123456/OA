<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流程流转记录</title>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.edatagrid.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
</head>
<body>
	<table class="table-style">
		<thead>
			<tr>
				<th width="7%"></th>
				<th width="7%">节点名称</th>
				<th width="7%">意见备注</th>
				<th width="7%">创建时间</th>
				<th width="7%">审批时间</th>
				<th width="7%">持续时长</th>
				<th width="7%">审批人</th>
				<th width="7%">审批状态</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${not empty histasklist}">
					<c:forEach items="${histasklist}" var="histask" varStatus="vs">
						<tr>
							<td>${vs.index+1}</td>
							<td>${histask.task_def_key_}</td>
							<td>${histask.commnet_message_}</td>
							<td>${histask.start_time_}</td>
							<td>${histask.end_time_}</td>
							<td>${histask.duration_}</td>
							<td>${histask.user_name}</td>
							<td>${histask.delete_reason_}</td>
						</tr>
					</c:forEach>
				</c:when>
			</c:choose>
		</tbody>
	</table>
</body>
</html>