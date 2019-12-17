<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
	<head>
		<title>关联用户</title>
		<%@ include file="/views/cap/common/easyui-head.jsp"%>
		<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/userResGroupList.js"></script>
		<script type="text/javascript">
			var userGroupId = '${userGroupId}';
		</script>
		<style type="text/css">
		</style>
	</head>
	<body class="easyui-layout" style="width:100%;height:100%;margin-top:10px;">
	
		<div data-options="region:'west',split:true,collapsible:false"
			class="page_menu">
			<!-- <input id="tree_search"></input> -->
			<ul class="easyui-tree" id="org_tree"></ul>
		</div>
		<!-- 用户组用户列表 -->
		<div data-options="region:'center'" class="content">
		
			<div id="toolBar" class="clearfix">
				<!-- 条件查询 -->
				<div class="search-input">
						<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入登录帐号或真实姓名'">
						<span class="clear" onclick="clearSearchBox()"></span>
				</div>
				
				<!-- 工具栏 -->
				<div id="operateBtn" class="tool_btn">
					<a href="javascript:void(0)" onclick="doSaveUser()"
						class="easyui-linkbutton" iconCls="icon-save" plain="true">保存</a>
				</div>
			</div>
			<!-- 用户列表 -->
				<table class="easyui-datagrid" id="userList" data-options="{
					queryParams:{
						orgId : ''
					},
					method : 'POST',
					view : dataGridExtendView,
					emptyMsg : '没有相关记录！',
					idField : 'userId',
					striped : true,
					fit : true,
					fitColumns : true,
					singleSelect : false,
					rownumbers : true,
					pagination : true,
					nowrap : false,
					toolbar : '#toolBar',
					pageSize : 10,
					showFooter : true,
					columns : [ [ 
			 		    { field : 'ck', checkbox : true }, 
			 		    { field : 'userId', title : 'userId', hidden : true }, 
			 		    { field : 'acctLogin', title : '登录账号', width : 150, align : 'left' }, 
			 		    { field : 'userName', title : '真实姓名', width : 150, align : 'left' }, 
			 		    { field : 'deptName', title : '所属部门', width : 150, align : 'left' }
			 		] ],
			 		onLoadSuccess : function(data) {
			 			getChecked(data);
					},
				}"></table>
			</div>
		
	</body>
</html>