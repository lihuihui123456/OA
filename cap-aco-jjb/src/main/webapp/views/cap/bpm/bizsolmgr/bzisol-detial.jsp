<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<%@page import="java.io.InputStream"%>  
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>业务流程解决方案明细</title>
<style type="text/css">
.left-th{
	width:18%;
}
.right-td{
	width:32%;
	text-align: left;
}
</style>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" style="width:100%;height:100%">
	<div data-options="region:'center',height:'auto'">
		<div name="div" style="overflow: auto;padding:5px 10px">
		   	<table border="1" style="width: 100%;"  class="table-style">
		   		<tr style="height: 35px">
					<th class="Theader" colspan="4">应用模型明细</th>
				</tr>
				<tr style="height: 35px">
					<th class="left-th">业务应用类别</th>
					<td class="right-td">${bizSolInfo.solCtlgName_}</td>
					<th class="left-th">业务应用</th>
					<td class="right-td">${bizSolInfo.bizCode_}</td>
				</tr>
				<tr style="height: 35px">
					<th class="left-th">应用模型名称</th>
					<td class="right-td">${bizSolInfo.name_ }</td>
					<th class="left-th">标志Key</th>
					<td class="right-td">${bizSolInfo.key_}</td>
				</tr>
				<tr style="height: 35px">
					<th class="left-th">是否有流程</th>
					<td colspan="3" style="text-align: left;">${bizSolInfo.isProcess_}</td>
				</tr>
				<tr style="height: 60px">
					<th class="left-th">描述</th>
					<td colspan="3" style="text-align: left;">${bizSolInfo.desc_ }</td>
				</tr>
			</table>
			<br/>
			<table border="1" style="width: 100%"  class="table-style">
				<tr style="height: 35px">
					<th  class="Theader" colspan="4">修改记录</th>
				</tr>
				<tr style="height: 35px">
					<th class="left-th">创建人</th>
					<td class="right-td">${bizSolInfo.createUserName_ }</td>
					<th class="left-th">创建时间</th>
					<td class="right-td">
					<fmt:formatDate value="${bizSolInfo.createTime_ }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr style="height: 35px">
					<th class="left-th">更新人</th>
					<td class="right-td">${bizSolInfo.updateUserName_ }</td>
					<th class="left-th">更新时间</th>
					<td class="right-td">
					<fmt:formatDate value="${bizSolInfo.updateTime_ }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
			</table>
	   	</div>
   	</div>
   	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		 <div class="window-tool">
			<a href="javascript:void(0)" onclick="closeDig()"
				class="easyui-linkbutton" plain="true">关闭</a>
		</div>
	</div>
</body>
<script type="text/javascript">


var divId;
var workSpaceH;
function closeDig(){
	window.parent.closeDialog(divId);
}
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

	var deploymentId = '${deploymentId}';
	if( deploymentId !=null && deploymentId != "" && deploymentId != "null"){
		$('#picture').show();
	}else{
		$('#picture').hide();
	}
}

function openTab(){
	$('#info_iframe').attr('src', src);
	$('#detialTab').tabs({    
	    border:false,    
	    onSelect:function(title){ 
	    	var iframeId = '';
	        if( title == '流程图' && b != true) {
	        	//iframeId = 'pic_iframe';
	        	$('#pic_iframe').attr('src', src);
	        	b = true;
	        }
	        if( title == 'Activity设计原码' && c != true) {
	        	//iframeId = 'act_iframe';
	        	$('#act_iframe').attr('src', src);
	        	c = true;
	        }
	        if( title == '设计器源代码' && d != true) {
	        	//iframeId = 'code_iframe';
	        	$('#code_iframe').attr('src', src);
	        	d = true;
	        } 
	    }    
	});
}
</script>
</html>