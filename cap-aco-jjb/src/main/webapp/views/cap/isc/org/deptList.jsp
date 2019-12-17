<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html style="width: 100%; height: 100%;">
	<head>
	<title>部门管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/org/js/deptList.js"></script>

	<script type="text/javascript">
		var path = '${ctx}';
	</script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;" onclick="cancelEdit()">
	<div data-options="region:'west',split:true,collapsible:false" class="page_menu">
		<!-- 单位机构树 -->
		<div class="search-tree">
			<input id="org_search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入单位名称'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<ul class="easyui-tree" id="orgTree" />
		</div>
	</div>

	<!-- 右侧内容区域 -->
	<div data-options="region:'center'" class="content">
		<!-- 工具栏 -->
		<div id="toolbar" class="clearfix">
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入部门名称或编码'"></input>
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:deptController:deptList">
					<a href="javascript:void(0)" onclick="doAddDeptBefore()" class="easyui-linkbutton" id="btn_dept_add" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:deptController:deptList">
					<a href="javascript:void(0)" onclick="doUpdateDeptBefore()" class="easyui-linkbutton" id="btn_dept_update" iconCls="icon-edit" plain="true">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:deptController:deptList">
					<a href="javascript:void(0)" onclick="doDeleteDept()" class="easyui-linkbutton" id="btn_dept_del" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission> 
				<shiro:hasPermission name="dstrRole:deptController:deptList">
					<a href="javascript:void(0)" onclick="saveRole()" class="easyui-linkbutton" id="btn_dept_role" iconCls="icon-isc-fpjs" plain="true">分配角色</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="orgPic:deptController:deptList"> 
					<a href="javascript:void(0)" onclick="showDeptPic()" class="easyui-linkbutton" iconCls="icon-isc-dept" plain="true">查看结构图</a>
				</shiro:hasPermission>	
				<shiro:hasPermission name="sortDept:deptController:deptList">
					<a href="javascript:void(0)" onclick="sortDept()" class="easyui-linkbutton" id="btn_dept_sort" iconCls="icon-isc-sort" plain="true">部门排序</a>
				</shiro:hasPermission>
			</div>
		</div>

		<!-- 部门列表 -->
		<table class="easyui-treegrid" id="deptTreeGrid" data-options="
			idField:'id', method:'post', toolbar:'#toolbar', treeField:'text', striped:true, fit:true, fitColumns:true, singleSelect:true,
			selectOnCheck:true, checkOnSelect:true, rownumbers:true, nowrap:false">
			<thead>
				<tr>
				 
		          <th data-options="field:'ck', checkbox:true"></th>
		          <th data-options="field:'id',title:'部门ID',  hidden:true"></th>
		          <th data-options="field:'parent_id',title:'上级部门ID', hidden:true"></th>
		          <th data-options="field:'text', title:'部门名称', width:180, align:'left'"></th>
		          <th data-options="field:'deptCode', title:'部门编码',width:180, align:'left', formatter:formaterDeptCode,hidden:true"></th>
		          <th data-options="field:'deptDesc', title:'部门描述', width:200, align:'left', formatter:formaterDeptDesc"></th>
		          <th data-options="field:'isSeal',  title:'是否封存', width:70, align:'left', formatter:formaterIsSeal"></th>
		          <th data-options="field:'createTime', title:'创建日期',width:90, align:'left', formatter:formaterCreateTime,hidden:true"></th>
		          <th data-options="field : 'operate', title : '操作', width : 60, align : 'center', formatter : formatOperate"></th>
				</tr>
			</thead>
		</table>
	</div>

	<!-- 部门Form -->
	<div id="deptDialog" class="easyui-dialog" title="添加部门信息" data-options="modal:true" closed="true" style="width:580px;height:400px;padding:10px" buttons="#dlg-buttons">
		<form action="" id="deptForm">
			<input type="hidden" id="deptId" name="deptId"/>
			<input type="hidden" id="deptCode" name="deptCode"/>
			<table cellpadding="3">
	    		<tr>
	    			<td >部门名称<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td ><input class="easyui-validatebox" required="true" missingMessage="不能为空" data-options="validType:['isBlank','unnormal','length[1,128]']" id="deptName" name="deptName" style="width:380px;line-height: 30px;"></td>
	    		</tr>

	    		<tr>
	    			<td>部门类型<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td>
	    				<select id="deptTypeId" class="easyui-combotree" name="deptTypeId" style="width:380px;width:400px\0;" required="true" missingMessage="不能为空"></select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>所属单位：</td>
	    			<td>
	    				<input type="hidden" id="orgId" name="orgId"/>
	    				<input class="easyui-validatebox" id="orgName" name="orgName" disabled="disabled" type="text"  style="width:380px;line-height: 30px;" >
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>上级部门：</td>
	    			<td>
	    				<select id="parentDeptId" class="easyui-combotree" name="parentDeptId" data-options="editable:false" style="width:380px;width:400px\0;"></select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>是否封存：</td>
	    			<td>
						<input id="isSeal" class="easyui-switchbutton" onText="否" offText="是" checked>
					</td>
	    		</tr>
	    		<tr>
	    			<td>部门描述：</td>
	    			<td>
	    				<input class="easyui-textbox" id="deptDesc" name="deptDesc" data-options="multiline:true" style="width:380px;width:400px\0;height:120px;">
					</td>
	    		</tr>
	    		<tr>
	    			<td>创建时间：</td>
	    			<td>
	    				<input  id="createTime" name="createTime"  type="text"  >
					</td>
	    		</tr>
	    	</table>
    	</form>
	</div>
	<!-- Form表单按钮 -->
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" onclick="doSaveOrUpdateDept()" class="easyui-linkbutton " plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#deptDialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 分配角色dialog  -->
	<div id="roleDialog" class="easyui-dialog" closed="true" title="分配角色" data-options="modal:true" style="width:90%;height:460px;padding:10px"  buttons="#role-buttons">
		<!-- 分配角色列表 -->
		<!-- <table class="easyui-datagrid" id="select_role" style="height: 100%"></table> -->
			<div class="usable_role" style="height:330px;width:38%;margin-left: 5%">
				
				<table id="tb1" class="easyui-datagrid" style=" height: 330px;"
							border="0"
							data-options="
					           rownumbers:false,
					           animate: true,
					           collapsible: true,
					           fitColumns: true,
					           method:'post',
					           onDblClickRow :function(rowIndex,rowData){
								   $(this).datagrid('selectRow', rowIndex);
								   add(rowIndex);
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
				<input type="button" class="green" value="&gt" onclick="add(this);" /><br/>
				<input type="button" class="green" value="&gt&gt" onclick="addAll(this);" /><br/>
				<input type="button" class="red" value="&lt" onclick="del(this);" /><br/>
				<input type="button" class="red" value="&lt&lt" onclick="delAll(this);" />
			</div>
			<div class="selected_role" style="height:330px;width:38%">
				<table id="tb2" class="easyui-datagrid" style=" height: 330px;"
							border="0"
							data-options="
					           rownumbers:false,
					           animate: true,
					           collapsible: true,
					           fitColumns: true,
					           method:'post',
					           onDblClickRow :function(rowIndex,rowData){
								   $(this).datagrid('selectRow', rowIndex);
								   del(rowIndex);
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
	<!-- 分配角色dialog END -->
	
	<!-- 排序dialog  -->
	<div id="sortDialog" class="easyui-dialog" closed="true" title="部门排序" data-options="modal:true" style="width:90%;height:460px;padding:10px"  buttons="#sort-buttons">
		<!-- 部门列表 -->
		<table class="easyui-treegrid" id="tg" data-options="
			idField:'id', method:'post',treeField:'text', striped:true, fit:true, fitColumns:true, singleSelect:false,
			rownumbers:true, nowrap:false,onClickRow:onClickRow">
			<thead>
				<tr>
				 
		          <th data-options="field:'ck', checkbox:false"></th>
		          <th data-options="field:'id',title:'部门ID',  hidden:true"></th>
		          <th data-options="field:'parent_id',title:'上级部门ID', hidden:true"></th>
		          <th data-options="field:'text', title:'部门名称', width:180, align:'left'"></th>
		          <th data-options="field:'deptCode', title:'部门编码',width:180, align:'left', formatter:formaterDeptCode"></th>
		          <th data-options="field : 'sort', title : '排序号', width : 60, align : 'center',formatter:formaterOrgSort"></th>
				</tr>
			</thead>
		</table>

		<div id="sort-buttons" class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveSort()" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#sortDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>
</body>
</html>