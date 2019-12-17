<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>个人文件夹</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="overflow-x:hidden;overflow-y:hidden;">
	正文：<br/>
	<c:choose>
		<c:when test="${not empty list}">
			<c:forEach items="${list}" var="media" varStatus="vs">
				<c:if test="${media.htmlPath==null}">
					<a href="${ctx}/downLoadMedia/downLoadIweb1?id=${media.documentId}"> ${media.fileName}</a>
				</c:if>
			</c:forEach>
		</c:when>
	</c:choose>
	<hr/>
	附件：<br/>
	<c:choose>
		<c:when test="${not empty list}">
			<c:forEach items="${list}" var="media" varStatus="vs">
				<c:if test="${media.htmlPath!=null}">
				 <a href="${ctx}/downLoadMedia/downloadMedia1?id=${media.documentId}">${media.fileName}</a><br/>
				</c:if>
			</c:forEach>
		</c:when>
	</c:choose>
</body>
</html>