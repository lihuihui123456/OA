<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>节点属性配置</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/datagrid-groupview.js"></script>
</head>
<body>
<div style="padding: 5px">
	<table id="nodeConfigureList" title="节点属性配置" class="easyui-treegrid" style="width: 99%" 
		url="${ctx}/bizSolMgr/findNodeConfigureBySolId?solId=${solId }&&procdefId=${procdefId}" 
		data-options="idField:'nodeId',treeField:'nodeName', 
			striped:true,fitColumns:true,rownumbers:true,
			nowrap:false,showFooter:true">
		<thead frozen="true">
			<tr>
				<th data-options="field:'procdefId',hidden:true"></th>
				<th data-options="field:'nodeId',hidden:true"></th>
				<th data-options="field:'sortNum',hidden:true"></th>
				<th data-options="field:'actId',hidden:true"></th>
				<th data-options="field:'id',width:80,formatter:formatterOpert">操作</th>
			</tr>
		</thead>
		<thead>
			<tr>
				<th data-options="field:'nodeName',width:100">节点名称</th>
				<th data-options="field:'nodeType',width:80">节点类型</th>
				<th data-options="field:'sortType',width:50,formatter:formatUpdateSort">排序</th>
			</tr>
		</thead>
	</table>
</div>
</body>
<script type="text/javascript">
/**
 * 操作单元格图标点击事件
 * @param index 所点击的图标所在行索引
 * @param action 动作标识 detial： 打开明细弹窗 update:打开修改弹窗 
 * 				 	   delete：执行删除操作
 */
function imgClick(nodeCfgId,solId,procdefId,nodeId,nodeName,nodeType,actId,action){
	if(action == 'jdsxpz'){
		//节点属性配置
		if(nodeType == 'userTask' || nodeType == 'Process'){
			nodeConfigure(nodeCfgId,solId,procdefId,nodeId,nodeName,nodeType,actId);
		}else if(nodeType == 'startEvent'){
			$.messager.show({title:'提示', msg:'流程开始节点不需要配置！',timeout:2000});
		}else if(nodeType == 'endEvent'){
			$.messager.show({title:'提示', msg:'流程结束节点不需要配置！',timeout:2000});
		}else if(nodeType == 'exclusiveGateway'){
			$.messager.show({title:'提示', msg:'流程网关不需要配置！',timeout:2000});
		}
	}else if(action == 'cbpz'){
		//催办配置
	}
}

//更改节点排序
function updateSort(id, action){
	$.ajax({
		url : "${ctx}/bizSolMgr/updateNodeSort",
		type : "post",
		dataType : "text",
		async: false,
		data:{
			"id" : id,
			"solId" : "${solId}",
			"procDefId" : "${procdefId}",
			"action" : action
		},
		success:function(data){
			if(data == "true"){
				reloadTableData();
			}
		}
	})
}

/**
 * 重新加载流程设计列表数据
 */
function reloadTableData() {
	$('#nodeConfigureList').treegrid('reload');
}

//打开业务表单选择页面
function nodeConfigure(nodeCfgId,solId,procdefId,nodeId,nodeName,nodeType,actId){
	var src = '${ctx}/bizSolMgr/toEditNodeConfigure?nodeCfgId='+nodeCfgId+'&solId='+solId+'&procdefId='+procdefId+'&nodeId='+nodeId+'&nodeType='+nodeType+'&actId='+actId;
	window.parent.$('#iframe').attr('src', src);
	var title = '';
	if(nodeType == 'userTask' || nodeType == 'startEvent' || nodeType == 'endEvent'){
		title = '流程节点['+nodeName+']-属性配置';
	}else{
		title = '流程['+nodeName+']-属性配置';
	}
	window.parent.$('#dialog').dialog({    
	    title: title,
	    width: 930,
	    height: 450,
	    cache: false,
	    closed : false
	    /* onResize: function() {
			$(this).dialog('center');
		} */
	});
}

function formatterOpert(val,row,index){
	return '<table border="0" width="100%"><tr><td align="left">'
		+'<span><img style="cursor:pointer" src="${ctx}/views/cap/bpm/bizsolmgr/img/mgr.png"  title="节点属性配置" onclick="imgClick(\''+row.nodeCfgId+'\',\''+row.solId+'\',\''+row.procdefId+'\',\''+row.nodeId+'\',\''+row.nodeName+'\',\''+row.nodeType+'\',\''+row.actId+'\',\'jdsxpz\')"/></span>'
		/* +'<span style="margin-left:10px"><img style="cursor:pointer" src="${ctx}/views/cap/bpm/bizsolmgr/img/property.png" title="催办配置" onclick="imgClick(\''+row+'\',\'cbpz\')"/></span>' */
		+'</td></tr></table>';
}

function formatUpdateSort(val, row) {
	if(val == "parent"){
		return "";
	}else if(val == "firstNode"){
		return '<table border="0" width="100%"><tr><td align="left">'
		+'<span><img style="cursor:pointer" src="${ctx}/static/cap/plugins/easyui/themes/icons/down.png" title="下移" onclick="updateSort(\''+row.nodeId+'\',\'downSort\')"/></span>'
		+'</td></tr></table>';
	}else if(val == "lastNode"){
		return '<table border="0" width="100%"><tr><td align="left">'
		+'<span><img style="cursor:pointer" src="${ctx}/static/cap/plugins/easyui/themes/icons/up.png"  title="上移" onclick="updateSort(\''+row.nodeId+'\',\'upSort\')"/></span>'
		+'</td></tr></table>';
	}else{
		return '<table border="0" width="100%"><tr><td align="left">'
		+'<span><img style="cursor:pointer" src="${ctx}/static/cap/plugins/easyui/themes/icons/up.png"  title="上移" onclick="updateSort(\''+row.nodeId+'\',\'upSort\')"/></span>'
		+'<span style="margin-left:10px"><img style="cursor:pointer" src="${ctx}/static/cap/plugins/easyui/themes/icons/down.png" title="下移" onclick="updateSort(\''+row.nodeId+'\',\'downSort\')"/></span>'
		+'</td></tr></table>';
	}
}
</script>
</html>