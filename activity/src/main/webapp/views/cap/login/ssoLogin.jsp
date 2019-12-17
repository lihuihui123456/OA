<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no"/>
	<%@ include file="/views/aco/common/head.jsp"%>
	<script type="text/javascript">
		function login(){
			var form = document.getElementById("submitForm");
			form.submit();
		}

	</script>
	</head>
	<body onload="login()">
		<form id ="submitForm" action = "${ctx }/login" method ="post">
  			<input name="authcode" value="${authcode }">
  		</form>
	</body>
</html>