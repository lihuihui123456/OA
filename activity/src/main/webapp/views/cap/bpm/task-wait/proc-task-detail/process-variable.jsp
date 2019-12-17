<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流程变量</title>
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
 				<th>key</th>
 				<th>类型</th>
 				<th>值</th>
 			</tr>
 		</thead>
 		<tbody>
 		<c:choose>
 			<c:when test="${not empty actvar}">
 				<c:forEach items="${actvar}" var="actvar" varStatus="vs">
 					<tr>
		 				<td width="150">${actvar.name_}</td>
		 				<td width="150">${actvar.type_}</td>
		 				<td width="150">${actvar.text_}</td>
		 			</tr>
 				</c:forEach>
 			</c:when>
 		</c:choose>
 		</tbody>
	</table>
</body>
</html>