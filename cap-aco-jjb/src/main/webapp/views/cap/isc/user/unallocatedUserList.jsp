<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>未分配用户</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/unallocatedUserList.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/setUserInfo.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/datagrid-scrollview.js"></script>
</head>
<body class="easyui-layout" style="width:100%;height:98%;">

	<!-- 用户列表 -->
	<div data-options="region:'center'"  class="content">
	
			<div id="toolBar" class="clearfix">
				<!-- 工具栏 -->
				<div class="search-input">
					<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'请输入账号/姓名查询'"></input>
					<span class="clear" onclick="clearSearchBox()"></span>
				</div>
				<shiro:hasPermission name="AssignedUser:UnallocatedUserController:unallocatedUserList">
					<div id="operateBtn" class="tool_btn">
						<a href="javascript:void(0)" onclick="doAssignedUser()" id="btn_user_assigned" class="easyui-linkbutton" iconCls="icon-edit" plain="true">分配</a>
					</div>
				</shiro:hasPermission>
			</div>

			<!-- 用户列表 -->
			<table class="easyui-datagrid" id="userList" data-options="{
				queryParams:{
					orgName : ''
				},
				view : dataGridExtendView,
				emptyMsg : '没有相关记录！',
				method : 'POST',
				idField : 'userId',
				striped : true,
				fit : true,
				fitColumns : true,
				singleSelect : false,
				selectOnCheck : true,
				checkOnSelect : true,
				rownumbers : true,
				pagination : true,
				nowrap : false,
				toolbar : '#toolBar',
				pageSize : 10,
				showFooter : true,
				columns : [ [ 
		 		    { field : 'ck', checkbox : true }, 
		 		    { field : 'userId', title : 'userId', hidden : true }, 
		 		    { field : 'deptName', title : 'deptName', hidden : true }, 
		 		    { field : 'postName', title : 'postName', hidden : true }, 
		 		    { field : 'acctLogin', title : '登录账号', width : 90, align : 'left' }, 
		 		    { field : 'userName', title : '姓名', width : 90, align : 'left' }, 
		 		    { field : 'orgName', title : '所属单位', width : 160, align : 'left' }, 
		 		    { field : 'deptNamePart', title : '所属部门', width : 160, align : 'left' },
		 		    {  field : 'acctStat', title : '账号状态', width : 70, align : 'left',
		 		    	formatter:function(value,row){
		 		    		if(value == null || value == ''){
		 		    			return null;
		 		    		}
		 		    		if(value == 'Y') {
		 		    			return '禁用';
		 		    		}
		 		    		if(value == 'N') {
		 		    			return '启用';
		 		    		}
		 		    		return '';
		 		    	}
		 		    } ,
		 		    {  field : 'isAdmin', title : '是否管理员', width : 80, align : 'left',
		 		    	formatter:function(value,row){
		 		    		if(value == null || value == ''){
		 		    			return null;
		 		    		}
		 		    		if(value == 'Y') {
		 		    			return '是';
		 		    		}
		 		    		if(value == 'N') {
		 		    			return '否';
		 		    		}
		 		    		return '';
		 		    	}
		 		    }],
		 		],
		 		onClickRow : function(index,obj){
		 			getUserInfo(index,obj);
				}
			}"></table>
	</div>
	
	<!-- 用户列表模态框 -->
	<div id="userDialog" class="easyui-dialog"  closed="true" title="分配用户" data-options="modal:true" style="width:400px;height:350px;padding:10px" buttons="#dlg-buttons">
			<form id="userForm" method="post">
				<table cellpadding="3">
					<input type="hidden" id="orgCode" name="orgCode">
					<input type="hidden" id="deptCode" name="deptCode">
					<input type="hidden" id="postCode" name="postCode">
					<input type="hidden" id="ids" name="ids">
		    		<tr>
						<td><span class="input-must">*</span>所属单位：</td>
		    			<td>
		    				<select class="easyui-combotree select_txt" style="width:260px;"  id="orgName" name="orgName" data-options="required:true" missingMessage="不能为空">
							</select>
						</td>
					</tr>
					<tr>
						<td><span class="input-must">*</span>所属部门：</td>
		    			<td>
		    				<select class="easyui-combotree select_txt" style="width:260px;"  id="deptName" name="deptName" data-options="required:true" missingMessage="不能为空">
							</select>
						</td>
					</tr>
					<tr>
						<td><span class="input-must">*</span>所属岗位：</td>
		    			<td>
		    				<select class="easyui-combobox select_txt " style="width:260px;"  id="postName" name="postName" data-options="required:true,editable:false" missingMessage="不能为空">
							</select>
						</td>
					</tr>
		    	</table>
			</form>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveUnallocatedUser()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#userDialog').dialog('close')" plain="true">取消</a>
	</div>
	
</body>
</html>