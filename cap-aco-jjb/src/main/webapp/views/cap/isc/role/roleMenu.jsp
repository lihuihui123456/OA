<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>角色授权</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/role/js/roleMenu.js"></script>
	
	<script type="text/javascript">
		var roleId = '${roleId}';
	</script>
</head>
<body class="easyui-layout" style="width: 100%; height: 100%;"> 
	
	<input type="hidden" id="typeid">
	
		<div data-options="region:'west',split:true,collapsible:false" title="注册系统" style="width: 200px;" class="page_menu">
			<!-- 系统注册树 -->
			<ul class="easyui-tree" id="sys_reg_tree" ></ul>
		</div>
		
		<div data-options="region:'center',title:'角色授权',iconCls:'icon-ok'" class="content">
			
			<div id="toolbar1" style="height: auto">
				<div id="operateBtn" style="margin-bottom: 5px; margin-top: 5px">
					<a href="javascript:void(0)" onclick="saveData()"
					class="easyui-linkbutton" iconCls="icon-save" plain="true">保存</a>
				</div>
			</div>
			<ul class="easyui-tree" id="menu_tree"></ul>
		</div>
</body>
</html>