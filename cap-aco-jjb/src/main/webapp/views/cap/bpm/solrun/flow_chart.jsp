<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>流程图查看</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<%
	response.setHeader("Pragma","No-cache");    
	response.setHeader("Cache-Control","no-cache");    
	response.setDateHeader("Expires", -10);
%>
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/qtip/jquery.qtip.min.css" />
<link href="${ctx}/views/aco/main/css/pages.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/qtip/jquery.qtip.min.js" type="text/javascript"></script>
</head>
<body>
<div style="width: 100%;height:100%;overflow: auto;">
	<img id="flowPicture" usemap="#flowmap" alt="" src="" />
	<map name="flowmap" id="flowmap" >
		<c:choose>
			<c:when test="${not empty list}">
				<c:forEach items="${list}" var="flownode" varStatus="vs">
					<c:if test="${flownode.nodeType==2}">
						<area id="${flownode.taskid}" shape="rect" coords="${flownode.nodeX},${flownode.nodeY},${flownode.width},${flownode.height}" type="userTask" target ="_blank"/> 
					</c:if>
				</c:forEach>
			</c:when>
		</c:choose>
	</map>
</div>
</body>
<script type="text/javascript">
	function chart() {
		var timestamp = Date.parse(new Date());
		var src = '${ctx}/bpmRuBizInfoController/viewFlowPicture?time='+timestamp+'&&bizId=${bizid}';
		$("#flowPicture").attr("src",src);
		$("area[type='userTask']").each(function(){
			var taskid=$(this).attr('id');
			$(this).qtip({
				content: {
		            text: function(event, api) {
		                $.ajax({
		                    url: "${ctx}/bpmRuBizInfoController/findNodeInfo?taskid="+taskid
		                })
		                .then(function(content) {
		                    api.set('content.text', content);
		                }, function(xhr, status, error) {
		                    api.set('content.text', status + ': ' + error);
		                });
		                return '正在加载...'; 
		            }
		        },
		        position: {
		            target: 'mouse', // Position it where the click was...
		            adjust: { mouse: false } // ...but don't follow the mouse
		        },
		    });
		
		});
	}
	$(function() {
		chart();
	});
</script>
</html>