<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>用户管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/userList.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/setUserInfo.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/datagrid-scrollview.js"></script>
</head>
<body class="easyui-layout" style="width:100%;height:98%;" onclick="cancelEdit()">
	<!-- 高级查询 -->
	<div data-options="region:'west',split:true,collapsible:false" class="page_menu">
		<div class="search-tree">
			<input id="org_search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入单位名称'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<ul class="easyui-tree" id="org_tree" ></ul>
		</div>
	</div>

	<!-- 用户列表 -->
	<div data-options="region:'center'"  class="content">
		<!-- 顶部模块列表区域 -->
			<div id="toolBar" class="clearfix">
				<!-- 条件查询 -->
				<div class="search-input" >
					<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'帐号/姓名'" >
					<span class="clear" onclick="clearSearchBox()"></span>
				</div>

				<!-- 工具栏 -->
				<div id="operateBtn" class="tool_btn">
					<shiro:hasPermission name="add:userController:userList">
						<a href="javascript:void(0)" onclick="doAddUserBefore()" id="btn_user_add" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="modify:userController:userList">
						<a href="javascript:void(0)" onclick="doUpdateUserBefore()" id="btn_user_edit" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="delete:userController:userList">
						<a href="javascript:void(0)" onclick="doDeleteUser()"  id="btn_user_del" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
					</shiro:hasPermission>

					<%-- 
					<shiro:hasPermission name="permissions:userController:userList">
						<a href="javascript:void(0)" onclick="doCopy()" class="easyui-linkbutton" iconCls="icon-add" plain="true">同权相赋</a>
					</shiro:hasPermission> 
					<shiro:hasPermission name="import:userController:userList">
						<a href="javascript:void(0)" onclick="doImportUser()" class="easyui-linkbutton"  iconCls="icon-add" plain="true">导入</a>
					</shiro:hasPermission>
					--%>

					<%-- <shiro:hasPermission name="role:userController:userList">
						<a href="javascript:void(0)" onclick="saveRole()" class="easyui-linkbutton" iconCls="icon-isc-fpjs" plain="true">分配角色</a>
					</shiro:hasPermission> 
					<shiro:hasPermission name="partTime:userController:userList">
						<a href="javascript:void(0)" onclick="saveDept()" class="easyui-linkbutton" iconCls="icon-isc-szjz" plain="true">设置兼职</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="userGroup:userController:userList">
						<a href="javascript:void(0)" onclick="saveUserGroup()" class="easyui-linkbutton" iconCls="icon-isc-fpyhz" plain="true">分配用户组</a>
					</shiro:hasPermission>
					<c:if test="${isAdmin == '1'}">
						<a href="javascript:void(0)" onclick="setAdmin()" class="easyui-linkbutton" iconCls="icon-isc-swgly" plain="true">设为管理员</a>
					</c:if>
					<shiro:hasPermission name="viewPerm:userController:userList">
						<a href="javascript:void(0)" onclick="viewPerm()" class="easyui-linkbutton" iconCls="icon-search" plain="true">查看权限</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="copyPerm:userController:userList">
						<a href="javascript:void(0)" onclick="copyPerm()" class="easyui-linkbutton" iconCls="icon-search" plain="true">权限复制</a>
					</shiro:hasPermission>--%>
					<a href="javascript:void(0)" class="easyui-menubutton"
						data-options="menu:'#accessory',plain:true">操作设置</a>
					<div id="accessory" style="width: 150px;">
						<shiro:hasPermission name="role:userController:userList">
							<div data-options="iconCls:'icon-isc-fpjs'" onclick="saveRole()">分配角色</div>
						</shiro:hasPermission>
						<shiro:hasPermission name="partTime:userController:userList">
							<div data-options="iconCls:'icon-isc-szjz'" onclick="saveDept()">设置兼职</div>
						</shiro:hasPermission>
						<shiro:hasPermission name="userGroup:userController:userList">
							<div data-options="iconCls:'icon-isc-fpyhz'" onclick="saveUserGroup()">分配用户组</div>
						</shiro:hasPermission>
						<shiro:hasPermission name="admin:userController:userList">
							<c:if test="${isAdmin == '1'}">
								<div data-options="iconCls:'icon-isc-swgly'" onclick="setAdmin()">设为管理员</div>
							</c:if>
						</shiro:hasPermission>
						<shiro:hasPermission name="viewPerm:userController:userList">
							<div data-options="iconCls:'icon-search'" onclick="viewPerm()">查看权限</div>
						</shiro:hasPermission>
						<shiro:hasPermission name="copyPerm:userController:userList">
							<div data-options="iconCls:'icon-isc-fpyhz'" onclick="copyPerm()">权限复制</div>
						</shiro:hasPermission>
						<shiro:hasPermission name="exportTemplate:userController:userList">
							<div data-options="iconCls:'icon-isc-yhdc'"><a href="${ctx}/excelController/exportTemplate" style="text-decoration: none;color:#444">导出用户模板</a></div>
						</shiro:hasPermission>
						<shiro:hasPermission name="import:userController:userList">
							<div data-options="iconCls:'icon-isc-yhdr'" onclick="openUserImportDlg()">导入用户</div>
						</shiro:hasPermission>
						<shiro:hasPermission name="sortUser:userController:userList">
							<div data-options="iconCls:'icon-isc-sort'" onclick="sortUser()">用户排序</div>
						</shiro:hasPermission>
						<div data-options="iconCls:'icon-isc-swgly'" onclick="resetPwd()">重置密码</div>
					</div>
				</div>
			</div>

			<!-- 用户列表 -->
			<table class="easyui-datagrid" id="userList" data-options="{
				queryParams:{
					orgId : ''
				},
				view : dataGridExtendView,
				emptyMsg : '没有相关记录！',
				method : 'POST',
				idField : 'userId',
				striped : true,
				fit : true,
				fitColumns : true,
				singleSelect : true,
				selectOnCheck : false,
				checkOnSelect : false,
				rownumbers : true,
				pagination : true,
				nowrap : false,
				toolbar : '#toolBar',
				pageSize : 10,
				showFooter : true,
				columns : [ [ 
		 		    { field : 'ck', checkbox : true }, 
		 		    { field : 'userId', title : 'userId', hidden : true }, 
		 		    { field : 'deptId', title : 'deptId', hidden : true }, 
		 		    { field : 'postId', title : 'postId', hidden : true }, 
		 		    { field : 'acctLogin', title : '登录账号', width : 90, align : 'left',sortable : true }, 
		 		    { field : 'userName', title : '姓名', width : 90, align : 'left' ,sortable : true}, 
		 		    { field : 'orgName', title : '所属单位', width : 160, align : 'left' ,sortable : true}, 
		 		    { field : 'deptNamePart', title : '所属部门', width : 160, align : 'left' ,sortable : true},
		 		    {  field : 'acctStat', title : '账号状态', width : 70, align : 'left',sortable : true,
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
		 		    {  field : 'isAdmin', title : '是否管理员', width : 80, align : 'left',sortable : true,
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
		 		    } ,
		 		    {	field : 'opeator', title : '操作', width : 70, align : 'left',
		 		    	formatter:function(value,row){
		 		    		return viewInfo(value,row);
		 		    	}
		 			}],
		 		],
		 		onClickRow : function(index,obj){
		 			getUserInfo(index,obj);
				}
			}"></table>
	</div>

	<!-- 用户信息新增修改对话框 -->
	<div id="userDlg" class="easyui-dialog" title="新增用户" closed="true" data-options="modal:true" style="width:75%;height:98%;" buttons="#dlg-buttons">
		<form id="userForm" method="post" class="window-form">
			<div class="add_user_head">
				<a href="javascript:void(0);" onclick="changePic()"><img style="border-radius:100px;max-height:160px" id="userpic"></a>
				<div>请添加要上传的照片，支持jpg、png、gif格式，文件不能大于2M</div>
			</div>
			<input type="hidden" id="user_id" name="userId">
			<input type="hidden" id="org_id" name="orgId">
			<input type="hidden" id="org_name" name="orgName">
			<input type="hidden" id="acctIpSegment" name="acctIpSegment">
			<input type="hidden" id="deptName" name="deptName">
			<input type="hidden" id="deptCode" name="deptCode">
			<input type="hidden" id="orgCode" name="orgCode">
			<input type="hidden" id="picUrl" name="picUrl">
			<div class="easyui-panel window-panel-header" style="width:100%;padding-left:10px;" title="必填信息 *">
				<table class="form-table">
					<tr>
						<td>姓名<span class="input-must">*</span>:</td>
						<td><input class="easyui-validatebox  input_txt" id="user_name" name="userName" data-options="required:true,validType:['isBlank','length[1,256]','name']" missingMessage="不能为空"></td>
						<td>所属组织机构<span class="input-must">*</span>:</td>
						<td><input class="easyui-validatebox  input_txt" id="orgName" disabled validType="name" data-options="required:true" ></td>
					</tr>
					<tr>
						<td>登录账号<span class="input-must">*</span>:</td>
						<td><input class="easyui-validatebox input_txt" id="acct_login" name="acctLogin" onblur="validAcctLoginExist(this)" data-options="required:true,validType:['isBlank','length[1,30]','username']" missingMessage="不能为空"></td>
						<td>登录密码<span class="input-must">*</span>:</td>
						<td><input class="easyui-validatebox input_txt" type="password" id="acct_pwd" name="acctPwd" data-options="required:true,validType:['isBlank','unnormal','length[1,256]']" missingMessage="不能为空"></td>
					</tr>
					<tr>
						<td>所属主部门<span class="input-must">*</span>：</td>
		    			<td>
		    				<select class="easyui-combotree select_txt" style="width:270px\0;"  id="deptId" name="deptId" data-options="required:true" missingMessage="不能为空">
							</select>
						</td>
						<td>所属主岗位<span class="input-must">*</span>：</td>
		    			<td>
		    				<select class="easyui-combobox select_txt " style="width:270px\0;"  id="postId" name="postId" data-options="required:true,editable:false" missingMessage="不能为空">
							</select>
						</td>
					</tr>
					<tr>
						<td class="input-label">移动端登录:</td>
						<td>
							<input id="allowMobileLogin" class="easyui-switchbutton" onText="启用"  offText="禁用" checked>
						</td>
						<td class="input-label">PC端登录:</td>
						<td>
							<input id="allowPcLogin" class="easyui-switchbutton" onText="启用"  offText="禁用" checked>
						</td>
					</tr>
					<tr>
						<c:if test="${isAdmin == '1'}">
							<td class="input-label">是否管理员<span class="input-must">*</span>:</td>
							<td>
								<!-- <input name="isAdmin1" id="isAdmin1Y" type="radio" value="Y"> 是
								<input name="isAdmin1" id="isAdmin1N" type="radio" value="N"> 否 -->
								
								<input id="isAdmin" class="easyui-switchbutton" onText="是"  offText="否" checked>
							</td>
						</c:if>
					</tr>
				</table>
			</div>
			<div class="easyui-panel" style="width:100%;padding-left:10px;" title="基本信息">
				<table class="form-table">
					<tr>
						<td class="input-label">证件类型:</td>
						<td><select class="easyui-combobox select_txt" style="width:270px\0;"  id="user_cert_type" name="userCertType" panelHeight="80" data-options="editable:false">
							</select></td>
						<td class="input-label">证件号码:</td>
						<td><input class="easyui-validatebox input_txt" id="user_cert_code" name="userCertCode" data-options="validType:['isBlank','unnormal','length[1,32]']"></td>
					</tr>
					<tr>
						<td class="input-label">电子邮箱<font color="red">(唯一)</font>:</td>
						<td><input class="easyui-validatebox input_txt" id="user_email" name="userEmail" onblur="validUserEmailExist()" data-options="validType:['isBlank','email','length[1,64]']"></td>
						<td class="input-label">手机号码<font color="red">(唯一)</font>:</td>
						<td><input class="easyui-validatebox input_txt" id="user_mobile" name="userMobile" onblur="validUserMobileExist()" data-options="validType:['isBlank','mobile','length[1,11]']"></td>
						
					</tr>
					<tr>
						<td class="input-label">出生日期:</td>
						<td><input class="easyui-datebox input_txt" style="width:270px\0;"  id="user_bitrth" name="userBitrth" data-options="editable:false"></td>
						<td class="input-label">性别:</td>
						
						<td><select class="easyui-combobox select_txt" style="width:270px\0;"  id="user_sex" name="userSex" panelHeight="80" data-options="editable:false">
							</select></td>
						<!-- <td>
							<input name="userSex" id="userSex2" type="radio" value="2"> 未知
							<input name="userSex" id="userSex0" type="radio" value="0"> 男
							<input name="userSex" id="userSex1" type="radio" value="1"> 女
						</td> -->
					</tr>
					<tr>
						<td class="input-label">政治面貌:</td>
						<td><input class="easyui-combobox select_txt" style="width:270px\0;" id="userPoliceType" name="userPoliceType" panelHeight="100" data-options="editable:false"></td>
						<td class="input-label">是否部门负责人:</td>
						<td>
							<input id="deptLeader" class="easyui-switchbutton" onText="是"  offText="否" checked>
						</td>
					</tr>
					<tr>
						<td class="input-label">籍贯:</td>
						<td><input class="easyui-validatebox input_txt" id="userNativePlace" name="userNativePlace" data-options="validType:['isBlank','unnormal','length[1,25]']"></td>
						<td class="input-label">学历:</td>
						<td><input class="easyui-combobox select_txt" style="width:270px\0;" id="userEducation" name="userEducation" panelHeight="150" data-options="editable:false"></td>
					</tr>
					<tr>
						<td class="input-label">学位:</td>
						<td><input class="easyui-combobox select_txt" style="width:270px\0;" id="userDegree" name="userDegree" panelHeight="150" data-options="editable:false"></td>
						<td class="input-label">工龄:</td>
						<td><input class="easyui-validatebox input_txt" id="userSeniority" name="userSeniority" data-options="validType:['isBlank','Number','length[1,11]']"></td>
					</tr>
					<tr>
						<td class="input-label">人员类型:</td>
						<td><select class="easyui-combobox select_txt" style="width:270px\0;"  id="userDutyTyp" name="userDutyTyp" panelHeight="150" data-options="editable:false">
							</select></td>
						<td class="input-label">聘任岗位:</td>
						<td><input class="easyui-validatebox input_txt" id="dutyPost" name="dutyPost" data-options="validType:['isBlank','unnormal','length[1,128]']"></td>
					</tr>
					<tr>
						<td class="input-label">入党时间:</td>
						<td><input class="easyui-datebox input_txt" style="width:270px\0;"  id="joinTime" name="joinTime" data-options="editable:false"></td>
						<td class="input-label">参加工作时间:</td>
						<td><input class="easyui-datebox input_txt" style="width:270px\0;"  id="workTime" name="workTime" data-options="editable:false"></td>
					</tr>
					<tr>
						<td class="input-label">调入时间:</td>
						<td><input class="easyui-datebox input_txt" style="width:270px\0;"  id="entryTime" name="entryTime" data-options="editable:false"></td>
						<td class="input-label">座机号码:</td>
						<td><input class="easyui-validatebox input_txt" id="userTelephone" name="userTelephone" data-options="validType:['isBlank','length[1,32]']"></td>
					</tr>
					<tr>
						<td class="input-label">账号状态:</td>
						<td>
							<!-- <input name="acctStat" type="radio" value="N"> 启用
							<input name="acctStat" type="radio" value="Y"> 禁用 -->
							
							<input id="acctStat" class="easyui-switchbutton" onText="启用"  offText="禁用" checked>
						</td>
						<td>密码失效日期:</td>
						<td><input class="easyui-datetimebox input_txt" style="width:270px\0;"  id="acct_pwd_expr_time" name="acctPwdExprTime" data-options="editable:false"></td>
					</tr>
					<tr>
						<td class="input-label">IP段限制:</td>
						<td colspan="3">
							<input class="easyui-validatebox input_txt" id="ip_segment1" data-options="validType:['isBlank','ip']">--
							<input class="easyui-validatebox input_txt" id="ip_segment2" data-options="validType:['isBlank','ip']">
						</td>
					</tr>
				</table>
			</div>
		</form>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveOrUpdateUser()"  plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="closeUserDlg()" plain="true">取消</a>
	</div>

	<!-- 分配角色dialog  -->
	<div id="roleDialog" class="easyui-dialog" closed="true" title="分配角色" data-options="modal:true" style="width:90%;height:460px;padding:10px"  buttons="#role-buttons">
		<!-- 分配角色列表 -->
		<!-- <table class="easyui-datagrid" id="select_role" style="height: 100%"></table> -->
		<div class="usable_role" style="height:330px;width: 38%;margin-left: 5%">
			<table id="role_tb1" class="easyui-datagrid" style=" height: 330px;"
						border="0"
						data-options="
				           rownumbers:false,
				           animate: true,
				           collapsible: true,
				           fitColumns: true,
				           method:'post',
				           onDblClickRow :function(rowIndex,rowData){
							   $(this).datagrid('selectRow', rowIndex);
							   add_role('role');
						   }
						   ">
				<thead>
					<tr>
						<th data-options="field:'roleId',hidden:true">roleId</th>
						<th data-options="field:'roleName',width:70,align:'left'">可选角色</th>
					</tr>
				</thead>
			</table>
		</div>
		<div class="operate_btn" style="margin-top:100px">
			<input type="button" class="green" value="&gt" onclick="add_role('role');" /><br/>
			<input type="button" class="green" value="&gt&gt" onclick="addAll_role('role');" /><br/>
			<input type="button" class="red" value="&lt" onclick="del_role('role');" /><br/>
			<input type="button" class="red" value="&lt&lt" onclick="delAll_role('role');" />
		</div>
		<div class="selected_role" style="height:330px;width: 38%;">
			<table id="role_tb2" class="easyui-datagrid" style=" height: 330px;"
						border="0"
						data-options="
				           rownumbers:false,
				           animate: true,
				           collapsible: true,
				           fitColumns: true,
				           method:'post',
				           onDblClickRow :function(rowIndex,rowData){
							   $(this).datagrid('selectRow', rowIndex);
							   del_role('role');
						   }
						   ">
				<thead>
					<tr>
						<th data-options="field:'roleId',hidden:true">roleId</th>
						<th data-options="field:'roleName',width:70,align:'left'">已选角色</th>
					</tr>
				</thead>
			</table>
		</div>
		<div id="role-buttons" class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveRole()" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#roleDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>

	<!-- 分配部门及岗位dialog  -->
	<div id="deptDialog" class="easyui-dialog" closed="true" title="设置兼职" data-options="modal:true" style="width:550px;height:460px;padding:10px"  buttons="#dept-buttons">
		<div class="search-tree">
			<input id="dept_search" class="easyui-searchbox" data-options="searcher:deptTreeSearch,prompt:'输入部门名称或岗位名称'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<!-- 部门岗位树 -->
			<ul class="easyui-tree tree-bggray" id="dept_post_tree" style="margin-left:50px"></ul>
		</div>
		<div id="dept-buttons" class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveSelectDeptPost()" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#deptDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>

	<!-- 分配用户组dialog  -->
	<div id="userGroupDialog" class="easyui-dialog" closed="true" title="分配用户组" data-options="modal:true" style="width:90%;height:460px;padding:10px"  buttons="#userGroup-buttons">
		<div class="usable_role" style="height:330px;width:38%;margin-left: 5%">
			<table id="userGroup_tb1" class="easyui-datagrid" style=" height: 330px;"
						border="0"
						data-options="
				           rownumbers:false,
				           animate: true,
				           collapsible: true,
				           fitColumns: true,
				           method:'post',
				           onDblClickRow :function(rowIndex,rowData){
				               $(this).datagrid('selectRow', rowIndex);
							   add_userGroup('userGroup');
						   }
						   ">
				<thead>
					<tr>
						<th data-options="field:'userGroupId',hidden:true">userGroupId</th>
						<th data-options="field:'userGroupName',width:70,align:'left'">可选用户组</th>
					</tr>
				</thead>
			</table>
		</div>
		<div class="operate_btn" style="margin-top:100px">
			<input type="button" class="green" value="&gt" onclick="add_userGroup('userGroup');" /><br/>
			<input type="button" class="green" value="&gt&gt" onclick="addAll_userGroup('userGroup');" /><br/>
			<input type="button" class="red" value="&lt" onclick="del_userGroup('userGroup');" /><br/>
			<input type="button" class="red" value="&lt&lt" onclick="delAll_userGroup('userGroup');" />
		</div>

		<div class="selected_role" style="height:330px;width:38%">
			<table id="userGroup_tb2" class="easyui-datagrid" style=" height: 330px;"
						border="0"
						data-options="
				           rownumbers:false,
				           animate: true,
				           collapsible: true,
				           fitColumns: true,
				           method:'post',
				           onDblClickRow :function(rowIndex,rowData){
							   $(this).datagrid('selectRow', rowIndex);
							   del_userGroup('userGroup');
						   }
						   ">
				<thead>
					<tr>
						<th data-options="field:'userGroupId',hidden:true">userGroupId</th>
						<th data-options="field:'userGroupName',width:70,align:'left'">已选用户组</th>
					</tr>
				</thead>
			</table>
		</div>

		<div id="userGroup-buttons" class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveUserGroup()" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#userGroupDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>

	<!-- 修改头像dialog -->
	<div id="pic_dialog" class="easyui-dialog" title="修改头像" data-options="modal:true" closed="true" style="width:460px;height:345px;" buttons="#pic_dialog-buttons">
		<iframe frameborder="0" name="picFrame" id="picFrame"
			src=""
			width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="auto" allowtransparency="yes" scrolling="no" allowtransparency="yes"></iframe>
	</div>
	<div id="pic_dialog-buttons" class="window-tool">
		<a href="javascript:void(0)" onclick="savePic()" class="easyui-linkbutton" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#pic_dialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 角色权限Form表单 -->
	<div id="roleMenuDialog" class="easyui-dialog" closed="true" title="查看权限" data-options="modal:true" style="width:550px;height:460px;padding:0px"  buttons="#roleMenu-buttons">
		<div class="easyui-layout" style="width: 100%; height: 100%;"> 
			<div data-options="region:'center',title:'模块资源'">
				<ul class="easyui-tree" id="menu_tree" style="margin-left:30px"></ul>
			</div>
		</div>
	</div>
	<div id="roleMenu-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#roleMenuDialog').dialog('close')" plain="true">取消</a>
	</div>

	<!-- 复制权限选择用户dialog -->
	<div id="copyPermDialog" class="easyui-dialog" closed="true" title="选择用户" data-options="modal:true" style="width:90%;height:460px;" buttons="#copyPerm-buttons">
		<div class="easyui-layout" style="width:100%;height:100%;">
			<!-- 选择用户列表 -->
			<div data-options="region:'center'" class="content">
				<div id="copyPermToolBar" class="clearfix">
					<!-- 条件查询 -->
					<div class="search-input">
						<input id="copyPermSearch" class="easyui-searchbox" data-options="searcher:findByCopyPerm,prompt:'输入登录帐号或真实姓名'">
						<span class="clear" onclick="clearSearchBox()"></span>
					</div>
				</div>
				<!-- 用户列表 -->
				<table class="easyui-datagrid" id="copyPermList"></table>
			</div>
		</div>
	</div>
	<div id="copyPerm-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveCopyPerm()" plain="true">保存</a> 
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#copyPermDialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 用户详情dialog -->
	<div id="userInfoDialog" class="easyui-dialog" closed="true" title="用户详情" data-options="modal:true" style="width:90%;height:460px;" buttons="#userInfo-buttons">
		<div class="easyui-layout" style="width:100%;height:100%;">
			<!-- 选择用户列表 -->
			<div data-options="region:'center'" class="content">
				<div class="easyui-tabs" border="true" fit="true" id="tabs" style="height:100%;">
					<div title="角色" style="margin-top:5px;font-family:'微软雅黑';">
						<!-- 角色列表 -->
						<table class="easyui-datagrid" id="role_list"></table>
					</div>
					
					<div title="部门" style="margin-top:5px;font-family:'微软雅黑';">
						<!-- 部门列表 -->
						<table class="easyui-datagrid" id="dept_list"></table>
					</div>
					
					<div title="用户组" style="margin-top:5px;font-family:'微软雅黑';">
						<table class="easyui-datagrid" id="user_group_list"></table>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="userInfo-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#userInfoDialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 排序dialog  -->
	<div id="sortDialog" class="easyui-dialog" closed="true" title="用户排序" data-options="modal:true" style="width:90%;height:460px;padding:10px"  buttons="#sort-buttons">
		<!-- 用户列表 -->
		<table class="easyui-datagrid" id="userSortGrid" data-options="view:scrollview,autoRowHeight:false,pageSize:10,
			idField:'userId', method:'post',striped:true,fitColumns:true,fit:true,rownumbers:true,pagination:false,singleSelect:true,nowrap:false,onClickRow:onClickRow,onFetch:fetch">
			<thead>
				<tr>
					<th data-options="field:'ck', checkbox:false"></th>
					<th data-options="field:'userId', hidden:true"></th>
					<th data-options="field:'acctLogin', title : '登录帐号', width:120, align:'left'"></th>
					<th data-options="field:'userName', title : '姓名',width:80, align:'left'"></th>
					<th data-options="field:'orgName', title : '所属单位',width:130, align:'left'"></th>
					<th data-options="field:'deptNamePart', title : '所属部门',width:100, align:'left'"></th>
					<th data-options="field:'sort', title : '排序号', width : 90, align : 'center',editor:'numberbox',formatter:formaterUserSort"></th>
					<th data-options="field:'weight', title : '权重值', width : 90, align : 'center',editor:'numberbox',formatter:formaterUserWeight"></th>
				</tr>
			</thead>
		</table>

		<div id="sort-buttons" class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveSort()" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#sortDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>
	<!-- 用户信息导入dialog -->
	<div id="userInfoImportDlg" class="easyui-dialog" closed="true" title="导入用户信息文件" data-options="modal:true" style="width:600px;height:160px;" buttons="#userInfoDlg-buttons">
		<div class="easyui-layout" style="width:100%;height:100%;">
			<div data-options="region:'center'" class="content" style="margin-top: 10px">
				<form id="importFileForm" method="post" enctype="multipart/form-data">
					<input id="file" name="file" class="easyui-filebox" style="width:95%" data-options="prompt:'请选择用户导入模板...'" />
				</form>
			</div>
		</div>
	</div>
	<div id="userInfoDlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:importUserInfo()" plain="true">确定</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#userInfoImportDlg').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 导入用户信息失败，错误信息dialog -->
	<div id="errorInfoDialog" class="easyui-dialog" closed="true" title="错误信息" data-options="modal:true" style="width:700px;height:500px;" buttons="#errorInfo-buttons">
		<div class="easyui-layout" style="width:100%;height:100%;">
			<!-- 错误信息列表 -->
			<div data-options="region:'center'" class="content">
				<table class="easyui-datagrid" id="errorList" data-options="{
					view : dataGridExtendView,
					emptyMsg : '没有相关记录！',
					striped : true,
					fit : true,
					fitColumns : true,
					rownumbers : true,
					nowrap : false,
					columns : [ [ 
			 		    { field : 'colName', title : '列名称', width : 100, align : 'left'}, 
			 		    { field : 'errorInfo', title : '错误信息', width : 250, align : 'left'},
			 		    { field : 'rowIndex', title : '错误行', width : 50, align : 'left',
			 		    	formatter:function(value,row){
			 		    		return '第'+value+'行';
			 		    	}
			 		     }, 
			 		    { field : 'colIndex', title : '错误列', width : 50, align : 'left',
			 		    	formatter:function(value,row){
			 		    		return '第'+value+'列';
			 		    	}
			 		     } 
			 		  ]
			 		]
				}"></table>
			</div>
		</div>
	</div>
	<div id="errorInfo-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#errorInfoDialog').dialog('close')" plain="true">取消</a>
	</div>
</body>
</html>