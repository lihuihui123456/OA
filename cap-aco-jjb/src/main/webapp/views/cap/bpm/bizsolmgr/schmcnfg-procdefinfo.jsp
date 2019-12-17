<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>流程定义基础信息</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body>
<div style="padding:5px;">
	<span> 
		<a href="javascript:void(0)" onclick="selectProcdef()"
			class="easyui-linkbutton" plain="true">选择流程定义</a>
	</span> 
</div>
<c:choose>
	<c:when test="${empty procdefId}">
		<div id="warn" style="overflow: auto; padding: 5px 10px; height: 200px; text-align: center">
			<img alt="" src="${ctx}/views/cap/bpm/bizsolmgr/img/warn.png"> 
			<font size="4" color="red">请绑定流程定义！</font>
		</div>
	</c:when>
	<c:otherwise>
		<div style="padding:5px;" id="procdefInfo">
			<table border="1" style="width: 100%" class="table-style">
				<tr style="height: 35px">
					<th class="Theader" colspan="2">绑定流程的基本信息</th>
				</tr>
				<tr style="height: 35px">
					<th style="width: 25%;">流程定义名称</th>
					<td style="width: 75%;text-align: left">${title}</td>
				</tr>
				<tr style="height: 35px">
					<th style="width: 25%;">描述</th>
					<td style="width: 75%;text-align: left">${desc}</td>
				</tr>
				<tr>
					<td colspan="2">
						<div id="picture" style="margin: 0px; padding: 0px">
							<img id="img" src="">
						</div>
					</td>
				</tr>
			</table>
		</div>
	</c:otherwise>
</c:choose> 
</body>
<script type="text/javascript">
$(function(){
	var deploymentId = '${deploymentId}';
	if(deploymentId != null && deploymentId != ""){
		$('#img').attr('src',"${ctx}/procDefMgr/findProcPicture?deploymentId="+deploymentId); 
	}
})
function selectProcdef(){
	var id = '${id}';
	window.parent.$('#iframe').attr('src', "${ctx}/bizSolMgr/toProcdefSelect?id="+id);
	window.parent.$('#dialog').dialog({    
	    title: '流程定义选择',
	    width: 810,
	    height: 430,
	    cache: false,
	    closed : false,
	    onResize:function(){
           window.parent.$(this).dialog('center');
        }
	}); 
}

</script>
</html>