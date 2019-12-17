<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>系统配置</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/config/js/sysConfig.js"></script>
	<style type="text/css">
		.title{
			width: 100%;
			height: 24px;
			background:#ceddea;
			padding-left: 4px;
			padding-top: 7px;
			color: #000;
		}
	</style>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;" >
	<div data-options="region:'center'" class="content">
		<c:if test="${not empty list }">
			<div class="title">
				${title }
			</div>
			<form id="configForm" style="margin-top: 8px;">
				<table>
					<c:forEach items="${list }" var="config">
						<tr>
							<td style="width: 100px;">${config.proName }：</td>
							<c:if test="${config.configType == '0' }">
								<td>
									<input class="easyui-textbox" type="text" value="${config.proValue }" data-options="onChange:rememberData<c:if test="${not empty config.validRule}">,validType:${config.validRule }</c:if>" required="true" missingMessage="不能为空" configId="${config.id }" style="width:300px;" />
								</td>
							</c:if>
							<c:if test="${config.configType == '1' }">
								<td>
									<select class="easyui-combobox" data-options="valueField:'id',textField:'text'<c:if test="${not empty config.jsonData}">,data:${config.jsonData }</c:if>,onLoadSuccess:function(){$(this).combobox('setValue','${config.proValue }');},onChange:rememberData" configId="${config.id }" style="width:300px;" panelHeight="80" data-options="editable:false"></select>
								</td>
							</c:if>
						</tr>
						<tr>
							<td></td>
							<td>${config.configDesc }</td>
						</tr>
						<tr>
							<td colspan="2"><hr/></td>
						</tr>
					</c:forEach>
				</table>
			</form>
			<div>
				<button onclick="doSave()">保存</button>
			</div>
		</c:if>
	</div>
</body>
</html>