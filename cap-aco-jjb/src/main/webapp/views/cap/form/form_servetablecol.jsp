<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据建模管理</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<script type="text/javascript"
	src="${ctx}/views/cap/form/js/form_servetablecol.js"></script>

<style>
</style>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<div data-options="region:'center'" class="content">
		<div id="operateBtn" class="tool_btn">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				data-options="iconCls:'icon-save',plain:true" onclick="save()">保存</a>
			<a href="javascript:void(0)"
				class="easyui-linkbutton"
				data-options="iconCls:'icon-isc-qxfp',plain:true"
				onclick="setRoles('col')">权限设置</a>
		</div>
		<table class="easyui-datagrid" id="col"></table>
	</div>
	<!-- 权限设置 -->
	<div id="setrole" class="easyui-dialog" title="字段权限设置"
		data-options="modal:true" closed="true" style="width:90%;height:95%;">
		<iframe id="ifrole" style="width:98%;height:98%;" src=""></iframe>
	</div>
</body>
</html>