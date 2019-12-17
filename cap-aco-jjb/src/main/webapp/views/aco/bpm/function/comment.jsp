<%-- <%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>签批意见</title>
<%@ include file="/views/aco/common/head.jsp"%>
<!-- bootstrop 样式 -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
ss
	<c:if test="${not empty comments}">
	<c:choose>
		<c:forEach items="${comments}" var="comment" varStatus="vs">
			<c:if test="${comment.type_ == 'signature' && comment.signature != ''}">
				<img src="${comment.signature }">
				<label style="color: #888; padding-left: 10px; margin-top: 5px; margin-bottom: 5px;">
					&nbsp;&nbsp;&nbsp;&nbsp;${comment.userName_}&nbsp;&nbsp;&nbsp;&nbsp;
				</label>
				<label style="color: #888;">
					<fmt:formatDate value="${comment.time_ }" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
				</label><br>
			</c:if>
			<c:if test="${comment.type_ == 'comment' && comment.message_!=''}">
				<label style="color: #2a2a2a; margin-top: 8px; padding-left: 10px;">${comment.message_}</label>
				<br>
				<label style="color: #888; padding-left: 10px; margin-top: 5px; margin-bottom: 5px;">
					&nbsp;&nbsp;&nbsp;&nbsp;${comment.userName_}&nbsp;&nbsp;&nbsp;&nbsp;
				</label>
				<label style="color: #888;">
					<fmt:formatDate value="${comment.time_ }" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
				</label>
				<br>
			</c:if>
		</c:forEach>
	</c:choose>
	</c:if>
</body>
</html> --%>
ss