<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>模板列表</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<script type="text/javascript">
	//模板应用
	function tempUse(){
		opener.tempUse($('#tempName option:selected').val());
		window.close();
	}
</script>
<style>
.btn-primary {
  color: #61a2cd;
  background: #e3f1fc;
  border: 1px solid #9bc2d5;
}
.btn-primary:hover,
.btn-primary.disabled,
.btn-primary[disabled] {
  background-color: #b5d1e1;
  border-color: #7ca3b9;
}
.btn-primary:focus,
.btn-primary:focus{
  color: #fff;
  background-color: #b5d1e1;
  border-color: #7ca3b9;
}
.btn-primary:active,
.btn-primary.active {
  background-color: #b5d1e1;
	border-color: #7ca3b9;
}
</style>
</head>
<body>
	<div style="padding:10px;">
		<select id="tempName" class="form-control" style="width:80%">
			<c:choose>
		   		<c:when test="${not empty tempList}">
		   			<c:forEach items="${tempList}" var="temp" varStatus="vs">
						<option value="${temp.recordId_}">${temp.name_}</option>
					</c:forEach>
				</c:when>
			</c:choose>
		</select>
		<button type="button" class="btn btn-primary" onclick="tempUse()" style="float:right;margin-top:-34px;">确定</button>
	</div>
</body>
</html>