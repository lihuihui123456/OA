<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<%@page import="java.io.InputStream"%>  
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>流程定义明细</title>
<style type="text/css">
.left-th{
	width:20%;
	text-align: left;
}
.right-td{
	width:30%;
	text-align: left;
}
</style>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" style="width:100%;height:100%">
    <div data-options="region:'center'">
		<div id="detialTab" class="easyui-tabs" data-options="fit:true"> 
	    	<div title="流程定义明细" style="padding:10px;display:none;overflow:auto">
	    		<table border="1" style="width: 100%;" class="table-style">
		    		<tr style="height: 35px">
						<th class="Theader" colspan="4">流程定义明细</th>
					</tr>
					<tr style="height: 35px">
						<th class="left-th">流程定义名称</th>
						<td colspan="3">${modelBean.name_ }</td>
					</tr>
					<tr style="height: 35px">
						<th class="left-th">标志Key</th>
						<td class="right-td">${modelBean.key_ }</td>
						<th class="left-th">版本号</th>
						<td class="right-td">${modelBean.version_ }</td>
					</tr>
					<tr style="height: 35px">
						<th class="left-th">状态</th>
						<td class="right-td">
							<c:choose>
								<c:when test="${modelBean.state_ eq '0'}">
									初始化
								</c:when>
								<c:when test="${modelBean.state_ eq '1'}">
									已部署
								</c:when>
								<c:otherwise>
									--
								</c:otherwise>
							</c:choose> 
						</td>
						<th class="left-th">是否主版本</th>
						<td class="right-td">
							<c:choose>
								<c:when test="${modelBean.mainVersion_  eq 'Y'}">
									是
								</c:when>
								<c:when test="${modelBean.mainVersion_  eq 'N'}">
									否
								</c:when>
								<c:otherwise>
									--
								</c:otherwise>
							</c:choose> 
						</td>
					</tr>
					<tr style="height: 35px">
						<th class="left-th">流程模型ID</th>
						<td colspan="3">${modelBean.modelId_ }</td>
					</tr>
					<tr style="height: 35px">
						<th class="left-th">流程定义ID</th>
						<td colspan="3">${modelBean.procdefId_ }</td>
					</tr>
					<tr style="height: 35px">
						<th class="left-th">流程部署ID</th>
						<td colspan="3">${modelBean.deploymentId_ }</td>
					</tr>
					<tr style="height: 45px">
						<th class="left-th">描述</th>
						<td colspan="3">${modelBean.desc_ }</td>
					</tr>
				</table>
				<br/>
				<table border="1" style="width: 100%" class="table-style">
					<tr style="height: 35px">
						<th class="Theader" colspan="4">修改记录</th>
					</tr>
					<tr style="height: 35px">
						<th class="left-th">创建人</th>
						<td class="right-td">${modelBean.createUserName_ }</td>
						<th class="left-th">创建时间</th>
						<td class="right-td">
						<fmt:formatDate value="${modelBean.createTime_ }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
					</tr>
					<tr style="height: 35px">
						<th class="left-th">更新人</th>
						<td class="right-td">${modelBean.updateUserName_ }</td>
						<th class="left-th">更新时间</th>
						<td class="right-td">
							<fmt:formatDate value="${modelBean.lastUpdateTime_ }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
					</tr>
				</table>
	   		</div>
	   		<c:if test="${not empty deploymentId}">
	   			<div title="流程图" style="padding:5px;display:none;overflow: hidden;">
					<div id = "picture" style="width: 100%;height: 100%;overflow:auto;border: 1px solid #DBDBDB;">
	    				<img src="${ctx}/procDefController/findProcPicture?deploymentId=${deploymentId} ">
	    			</div>
		    	</div>
		    	
			    <div title="Activiti设计原码" data-options="" style="padding:0px;display:none;overflow:hidden">
			  		<iframe id="bpmXml" width="100%" height="100%" frameborder="0" marginheight="0" marginwidth="0">
			  		</iframe>
			    </div>
	   		</c:if>
		</div>
	</div>
	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<span>
				<a href="javascript:void(0)" onclick="closeDig()"
						class="easyui-linkbutton" plain="true">关闭</a>
			</span>
			<!-- <span>
				<a href="javascript:void(0)" onclick="alert('暂未实现！')"
						class="easyui-linkbutton" plain="true">下载BPMN文件</a>
			</span> -->
		</div>
	 </div>
</body>
<script type="text/javascript">
	var divId = "${divId}";
	var deploymentId = "${deploymentId}";
	$(function(){
		if( deploymentId !=null && deploymentId != "" && deploymentId != "null"){
			$('#picture').show();
		}else{
			$('#picture').hide();
		}
		$('#detialTab').tabs({
		    border:false,
		    onSelect:function(title,index){
		    	if(title=="Activiti设计原码") {
			        //加载iframe的src
		    		//var modelId = '${modelBean.modelId_ }';
			       // $('#bpmXml').attr('src',"${ctx}/procDefController/getBpmXml?modelId="+modelId);
		    		var procdefId = '${modelBean.procdefId_}';
			        $('#bpmXml').attr('src',"${ctx}/procDefController/getBpmXmlByProcdefId?procdefId="+procdefId);
		    	};
		    }
		});
	});
	function closeDig(){
		window.parent.closeDialog(divId);
	}
	var workSpaceH;
	function autoHeight(){
		var divs = document.getElementsByName("div");
		window.parent.$('#'+divId+'').dialog({ 
			//窗口最大化触发
			onMaximize:function(){
				workSpaceH = document.body.clientHeight;//高度
				$(divs).each(function(index) {
					divs[index].style.height = 0.85*workSpaceH;
				});
				
			},
			//窗口恢复原始尺寸触发
			onRestore:function(){
				workSpaceH = document.body.clientHeight;//高度
				$(divs).each(function(index) {
					divs[index].style.height = 0.7*workSpaceH;
				});
			}
		});
	}
</script>
</html>