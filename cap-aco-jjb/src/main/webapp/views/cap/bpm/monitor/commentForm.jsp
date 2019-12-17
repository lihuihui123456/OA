<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改意见</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<script type="text/javascript">
function savecomment(){
	$.ajax({
		type: "post",  
        url: "${ctx}/bpm/doEditCommentById",
        dataType: 'json',
        data: {
        	message:$("#message").val(),
        	Id:$("#id").val()
        	},     
        success: function(data) {
        	if(data=="1"){
        		window.parent.refreshList();
        	}else{
        		layerAlert("保存失败");
        	}
        }
   });
}
</script>
</head>
<body>
	<div>
		<textarea class="form-control" id="message" name="message" onpropertychange="if(value.length>2048) value=value.substr(0,2048)" rows="6">${comment.message}</textarea>
		<input type="hidden" id="id" name="id" value="${comment.id}"/>
	</div>
</body>
</html>