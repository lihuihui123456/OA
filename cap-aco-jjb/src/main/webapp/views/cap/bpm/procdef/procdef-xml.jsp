<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>activiti流程代码</title>
</head>
<body class="easyui-layout" style="width:100%;height:100%">
	<%-- <textarea style="width: 100%;height: 100%;">${xml}</textarea> --%>
	<pre><c:out value="${xml}" escapeXml="true"/>
	</pre>
</body>
</html>