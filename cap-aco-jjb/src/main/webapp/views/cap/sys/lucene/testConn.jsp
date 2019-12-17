<%@page import="com.yonyou.cap.sys.lucene.service.impl.DbsServiceImpl"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>测试连接</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>

<script type="text/javascript">
	
	function run1(){
		var AjaxURL = "luceneController/testIfConn";
		$.ajax({
			type: "POST",
			url: AjaxURL,
			async: false,
			data: {url:'${dbConn.luceData }', username:'${dbConn.luceName }',passwd:'${dbConn.lucePass }',classDriver:'${dbConn.luceDriver}'},
			success: function (data) {
			     if(data=='连接成功'){
			     $.messager.alert('测试接口数据', "连接成功！");
			     }else{
			     $.messager.alert('测试接口数据', "连接失败！");
			     }	
			}
		});
	}
</script>

</head>
<body>
		<div class="easyui-panel" style="padding-left:10px;">
			<form id="ff" name="ff" method="post" novalidate>
				<input type="hidden" id="id" name="intfc_id" value="${dbConn.id }">
				<p>数据库连接基本信息</p>
				<table class="">
					<tr>
						<td>数据库URL:</td>
						<td colspan="4"><input class="easyui-textbox"  readonly
							style="height:32px;width:100%" value="${dbConn.luceData }"></td>
					</tr>
					<tr>
						<td>数据库驱动:</td>
						<td colspan="4"><input class="easyui-textbox"  readonly
							style="height:32px;width:100%" value=${dbConn.luceDriver }></td>
					</tr>
					<tr>
						<td>用户名:</td>
						<td><input class="easyui-textbox" readonly
							style="height:32px;width:100%" value="${dbConn.luceName }"></td>
						<td>密码:</td>
						<td><input class="easyui-textbox" readonly
							style="height:32px;width:100%" value="${dbConn.lucePass }"></td>
					</tr>
				</table>
				
				
				
				<div style="margin-top:20px">
				<a onclick="run1()" class="easyui-linkbutton"
					iconCls="icon-ok">测试连接</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</div>
			</form>
		</div>
		
		<div id="clg" class="easyui-dialog" title="测试结果" closed="true"
		data-options="modal:true"
		style="width: 430px; height: 350px; padding: 10px">
		<div class="easyui-panel" style="width: 390px;height: 300px; padding: 20px">
			<span style="margin-bottom: 5px;" id="content">
			</span> 
		</div>
	</div>
</body>
</html>