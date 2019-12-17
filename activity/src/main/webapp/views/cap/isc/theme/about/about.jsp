<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>关于</title>
		<%@ include file="/views/aco/common/head.jsp"%>
		<link href="${ctx}/views/cap/isc/theme/about/css/about.css" rel="stylesheet">
	</head>
	<body>
		<div class="about-info">
			<c:choose>
				<c:when test="${not empty logoPath}">
					<img class="logo" src="${ctx}/sysLogoController/doDownLoadPicFile?picPath=${logoPath}" />
				</c:when>
				<c:otherwise>
					<img src="${ctx}/views/cap/isc/theme/about/images/logo_1.png">
				</c:otherwise>
			</c:choose>
			<p><b>版本号：</b> ${APP_NAME_VER}</p>
			<p><b>产品ID：</b> ${VERSION_TYPE}</p>
			<p><b>公司邮箱：</b> ${MAIL}</p>
			<p><b>&nbsp;</b></p>
			<!-- 
			<p><b>咨询电话：</b> ${TEL}</p>
			 -->
			<div class="rules"></div>
			<!-- <p>版权所有 2017 ${APP_COPYRIGHT} 保留所有权利</p> -->
		</div>				
		<div class="code">
			<img src="${ctx}/views/cap/isc/theme/about/images/qr_code.jpg">
			<p>关注我们</p>
		</div>		
	</body>
</html>