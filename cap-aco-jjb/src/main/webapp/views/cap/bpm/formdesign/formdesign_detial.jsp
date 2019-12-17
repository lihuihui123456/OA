<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<%@page import="java.io.InputStream"%>  
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>流程设计明细</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" data-options="fit:true"> 
	<div data-options="region:'center',height:'auto'" style="padding:5px;overflow:auto">
    	<table border="1" style="width: 100%;" class="table-style">
    		<tr style="height: 35px">
				<th class="Theader" colspan="4">业务表单明细</th>
			</tr>
			<tr style="height: 35px">
				<th style="width:20%;text-align: right;">业务应用类别</th>
				<td style="width:30%;text-align: left;">${bpmReForm.formCtlgName_ }</td>
				<th style="width:20%;text-align: right;">表单类型</th>
				<td style="width:30%;text-align: left;">
					<c:choose>
						<c:when test="${bpmReForm.formType_ eq '1'}">
							超链接表单
						</c:when>
						<c:when test="${bpmReForm.formType_ eq '2'}">
							自由表单
						</c:when>
						<c:otherwise>
							${bpmReForm.formType_}
						</c:otherwise>
					</c:choose> 
				</td>
			</tr>
			<tr style="height: 35px;text-align: right;">
				<th style="width:20%;text-align: right;">业务表单名称</th>
				<td style="width:30%;text-align: left;">${bpmReForm.formName_ }</td>
				<th style="width:20%;text-align: right;">标识Key</th>
				<td style="width:30%;text-align: left;">${bpmReForm.key_ }</td>
			</tr>
	<%-- 		<tr style="height: 35px">
				<th style="width:20%">Activity流程定义ID：</th>
				<td style="width:30%">${modelBean.procdefId_ }</td>
				<th style="width:20%">ACT流程发布ID：</th>
				<td style="width:30%">${modelBean.deploymentId_ }</td>
			</tr>
			<tr style="height: 35px">
				<th style="width:20%">设计模型ID：</th>
				<td style="width:30%">${modelBean.modelId_ }</td>
				<th style="width:20%">主定义ID：</th>
				<td style="width:30%">${modelBean.id }</td>
			</tr> --%>
			<tr style="height: 45px">
				<th style="width:20%;text-align: right;">描述</th>
				<td colspan="3">${bpmReForm.desc_ }</td>
			</tr>
		</table>
		<br/>
		<table border="1" style="width: 100%" class="table-style">
			<tr style="height: 35px">
				<th class="Theader" colspan="4">修改记录</th>
			</tr>
			<tr style="height: 35px">
				<th style="width:20%;text-align: right;">创建人</th>
				<td style="width:30%;text-align: left;">${bpmReForm.createUserName_ }</td>
				<th style="width:20%;text-align: right;">创建时间</th>
				<td style="width:30%;text-align: left;">
				<fmt:formatDate value="${bpmReForm.createTime_ }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
			</tr>
			<tr style="height: 35px">
				<th style="width:20%;text-align: right;">更新人</th>
				<td style="width:30%;text-align: left;">${bpmReForm.updateUserName_ }</td>
				<th style="width:20%;text-align: right;">更新时间</th>
				<td style="width:30%;text-align: left;">
				<fmt:formatDate value="${bpmReForm.updateTime_ }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
			</tr>
		</table>
    </div>
	   <!--  <div title="在线表单预览效果" data-options="" style="padding:2px 5px;display:none;overflow: hidden">
	    	<iframe id="bdyl" width="100%" height="100%" frameborder="0" marginheight="0" marginwidth="0">
		  	</iframe>
	    </div> -->
	
	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<a href="javascript:void(0)" onclick="closeDig()"
					class="easyui-linkbutton" plain="true">关闭</a>
		</div>
	</div>
</body>
<script type="text/javascript">
var divId = '${divId}';
$(function() {
	$('#detialTab').tabs({
	    border:false,
	    onSelect:function(title,index){
	    	if(title=="在线表单预览效果") {
	    		var url = "";
	    		var id = '${bpmReForm.id }';
	    		if(${bpmReForm.formType_ } == 2){
	    			url = "${ctx}/formController/formurl?formcode=${bpmReForm.key_}";
	    		}else{
	    			url = "${ctx}/formDesignController/toFormPreview?id=${bpmReForm.id}";
	    		}
		        //加载iframe的src
		        $('#bdyl').attr("src",url);
	    	};
	    }
	});
});

function closeDig(){
	window.parent.closeDialog(divId);
}

</script>
</html>