<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head >
		<title>新闻预览</title>
		<%@ include file="/views/cap/common/easyui-head.jsp"%>
		<link rel="shortcut icon" href="${ctx}/static/cap/plugins/bootstrap/ico/tl-favicon.ico" type="image/x-icon" />
		<link rel="stylesheet" href="${ctx}/views/cap/sys/news/css/sysNewsPage.css">
</head>
<body>
	<div class="div980">

		<div class="content">
			<h1> ${pic.picTitle }</h1>
			<div class="pic">
				<img alt="图片" src="${ pic.picPath}">
			</div>
		</div>

		<div class="left_zw">${pic.picContentShow }
		</div>
		<div>
			<div class="left_name">
				作者：${pic.createUserName }
			</div>
		</div>
	</div>
</body>
</html>