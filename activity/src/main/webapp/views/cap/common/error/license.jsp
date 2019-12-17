<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<title>软件授权错误</title>
<meta http-equiv="X-UA-Compatible" content="IE=8" />
</head>
<body>
	<div>
		<h1>软件授权错误</h1>
		<div>
			请联系软件供应商 <br />您可以联系${APP_COPYRIGHT}<br />
			<p><b>版本号：</b> ${APP_NAME_VER}</p>
			<p><b>产品ID：</b> ${VERSION_TYPE}</p>
			<p><b>公司邮箱：</b> ${MAIL}</p>
			<p><b>咨询电话：</b> ${TEL}</p>
		</div>
	</div>
</body>
</html>