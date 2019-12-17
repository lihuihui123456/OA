<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>方案概述</title>
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
<body>
<div style="padding:5px;">
	<span>
	<a href="javascript:void(0)" onclick="update()" class="easyui-linkbutton" plain="true">编辑</a>
	</span>
</div>
<div style="padding:5px;">
	<form id="bizSolInfo">
		<table border="" "1" style="width: 100%" class="table-style">
		<tr style="height: 35px">
			<th class="Theader"colspan="4">业务方案基本信息</th>
		</tr>
		<tr style="height: 35px">
			<th class="left-th">业务方案名称</th>
			<td class="right-td">${bizSolInfo.name_}</td>
			<th class="left-th">业务方案标识Key</th>
			<td class="right-td">${bizSolInfo.key_}</td>
		</tr>
		<tr style="height: 35px">
			<th class="left-th">所属分类</th>
			<td class="right-td">${bizSolInfo.solCtlgName_}</td>
			<th class="left-th">业务方案ID</th>
			<td class="right-td">${bizSolInfo.id}</td>
		</tr>
		<%-- <tr style="height: 35px">
			<th class="left-th">状态</th>
			<td class="right-td">${bizSolInfo.state_}</td>
			<th class="left-th">单独使用业务模型</th>
			<td class="right-td">${bizSolInfo.isBizModel_}</td>
		</tr> --%>
		<tr style="height: 60px">
			<th class="left-th">描述</th>
			<td colspan="3" style="text-align: left: ;">
				${bizSolInfo.desc_}
			</td>
		</tr>
		</table>
	</form>
</div>
</body>
<script type="text/javascript">

function update(){
	var id = '${bizSolInfo.id}';
	window.parent.$('#iframe').attr('src', "${ctx}/bizSolMgr/updateBizSol?module=fags&id="+id);
	window.parent.$('#dialog').dialog({    
	    title: '编辑业务解决方案',
	    width: 750,
	    height: 320,
	    cache: false,
	    closed : false,
	    onResize:function(){
           window.parent.$(this).dialog('center');
        }
	}); 
}
</script>
</html>