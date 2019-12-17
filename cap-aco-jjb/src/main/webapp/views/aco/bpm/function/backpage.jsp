<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>流程退回</title>
<%@ include file="/views/aco/common/head.jsp"%>
<!-- bootstrop 样式 -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="panel-body" style="padding-bottom: 0px; border: 0; background:#fff;overflow:hidden;" onload="setValue()">
	<c:if test="${not empty nodeMap}">
	<form id="myForm" class="form-horizontal">
	    <input type="hidden" id="chehui" name="chehui" value="Y"> 
		<input type="hidden" id="comment" name="comment"> 
		<input type="hidden" id="signature" name="signature"> 
		<input type="hidden" id="fieldName" name="fieldName" value="${fieldName}"> 
		<input type="hidden" name="taskId" value="${taskId}"> 
			<div class="form-group">
				<label for="recipient-name" class=" col-xs-2">办理环节：</label>
				<div class="col-xs-10">
					<c:forEach items="${nodeMap}" var="map" varStatus="index" begin="0">
						<c:set value="${map.value}" var="node"></c:set>
						<input type="radio" id="${node.actType}" 
							name="nodeId" value="${node.actId}" onclick="setUserInfo('${node.userId}','${node.userName}')"/><span>${node.actName}</span>
					</c:forEach>
				</div>
			</div>
		<div class="form-group" id="blry" style="display: block">
			<label for="recipient-name" class="control-label col-xs-2">办理人员：</label>
			<div class=" col-xs-10">
				<input type="hidden" id="userId" name="userId" /> 
				<!-- <input type="text" id="userName" class="validate[required] form-control" style="width: 300px;"/> -->
				<input type="text" id="userName" class="form-control" style="width: 300px;" readonly="readonly"/>
			</div>
		</div>
		<div class="form-group">
			<label for="recipient-name" class="control-label col-xs-2">任务标题：</label>
			<div class=" col-xs-10">
				<input type="text" style="width: 300px"
					class="form-control col-xs-10" id="title" name="title" value=""
					readonly="readonly">
			</div>
		</div>
	</form>
	</c:if>
	<c:if test="${empty nodeMap}">
		请配置当前节点的退回选项
		<!-- <script type="text/javascript">
			$('#submit', window.parent.document).attr("disabled", true);
		</script> -->
	</c:if>
</body>
<script type="text/javascript">
	
	function validateForm(){
		return true;
	}
	
	/**页面初始化后为页面赋值*/
	function setValue() {
		window.parent.setValue();
	}
	
	/**为标题赋值*/
	function setTitle(title) {
		$('#title').val(title);
	}
	
	/**为意见隐藏域赋值*/
	function setComment(comment) {
		$('#comment').val(comment);
	}
	
	/**为手写签批意见隐藏域赋值*/
	function setSignature(signature) {
		$("#signature").val(signature);
	}
	
	function setUserInfo(userId, userName) {
		$("#userId").val(userId);
		$("#userName").val(userName);
	}
	
	/**启动流程*/
	function startProcess() {
		var flag = "0";
		$.ajax({
			url : 'bpm/processBack',
			type : 'post',
			dataType : 'text',
			async : false,
			data : $('#myForm').serialize(),
			success : function(data) {
				flag = data;
			}
		});
		return flag;
	}
	function chehui() {
		return "Y";
	}
	$(function() {
		$("input[name=nodeId]:eq(0)").click();;
	});
</script>
</html>