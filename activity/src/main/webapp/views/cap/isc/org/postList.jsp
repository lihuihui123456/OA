<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html style="width: 100%; height: 100%;">
<head>
	<title>岗位管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/org/js/postList.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/datagrid-scrollview.js"></script>
</head>
<body  class="easyui-layout" style="width: 100%; height: 98%;" onclick="cancelEdit()">
		<!-- 页面布局 -->
		<div data-options="region:'west',split:true,collapsible:false" class="page_menu">
			<!-- 部门机构树 -->
			<div class="search-tree">
				<input id="org_search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入单位名称'"/>
				<span class="clear" onclick="clearSearchBox()"></span>
				<ul class="easyui-tree" id="org_dept_tree" />
			</div>
		</div>
	
		<!-- 右侧内容区域 -->
		<div data-options="region:'center'" class="content">
			
			<!-- 工具栏 -->
			
			<div id="toolbar" class="clearfix" >
				<div class="search-input">
					<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入岗位名称或编码'"></input>
					<span class="clear" onclick="clearSearchBox()"></span>
				</div>
				<div id="operateBtn" class="tool_btn">
					<shiro:hasPermission name="add:postController:postList">
						<a href="javascript:void(0)" onclick="doAddPostBefore()" class="easyui-linkbutton" id="btn_post_add" iconCls="icon-add" plain="true">新增</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="modify:postController:postList">
						<a href="javascript:void(0)" onclick="doUpdatePostBefore()" class="easyui-linkbutton" id="btn_post_edit" iconCls="icon-edit" plain="true">修改</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="delete:postController:postList">
						<a href="javascript:void(0)" onclick="doDeletePost()" class="easyui-linkbutton" id="btn_post_del" iconCls="icon-remove" plain="true">删除</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="dstrRole:postController:postList">
						<a href="javascript:void(0)" onclick="saveRole()" class="easyui-linkbutton" id="btn_post_role" iconCls="icon-isc-fpjs" plain="true">分配角色</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="sortPost:postController:postList"> 
						<a href="javascript:void(0)" onclick="sortPost()" class="easyui-linkbutton" id="btn_post_sort" iconCls="icon-edit" plain="true">岗位排序</a>
					</shiro:hasPermission>
				</div>
			</div>
			<!-- 岗位列表 -->
			<table class="easyui-datagrid" id="postDataGrid" data-options="
				idField:'postId', method:'post', toolbar:'#toolbar', striped:true, fit:true, fitColumns:true, singleSelect:false,
				selectOnCheck:true, checkOnSelect:true, rownumbers:true,showFooter:true, pagination:true, nowrap:false">
				<thead>
					<tr>
						<th data-options="field:'ck', checkbox:true"></th>
						<th data-options="field:'postId', hidden:true">岗位ID</th>
						<th data-options="field:'postName', width:150, align:'left'">岗位名称</th>
						<th data-options="field:'postCode', width:150, align:'left'">岗位编码</th>
						<th data-options="field:'postDesc', width:150, align:'left'">岗位描述</th>
						<th data-options="field:'createTime', width:120, align:'left', formatter:formaterCreateTime">创建日期</th>
					</tr>
				</thead>
			</table>
		</div>

	<!-- 岗位Form -->
	<div id="post_dialog" class="easyui-dialog" title="添加岗位信息" data-options="modal:true" closed="true" style="width:580px;height:375px;padding:10px" buttons="#dlg-buttons">
			<form action="" id="post_form" >
				<input type="hidden" id="post_id" name="postId" />
				<input type="hidden" id="post_code" name="postCode" />
				<table cellpadding="3" class="form-table" >
					<tr>
						<td>岗位名称<span style="color:red;vertical-align:middle;">*</span>：</td>
						<td>
							<input class="easyui-validatebox" type="text" required="true" missingMessage="不能为空"  data-options="validType:['isBlank','unnormal','length[1,128]']" id="post_name" name="postName" style="width:380px;line-height: 30px;" />
						</td>
					</tr>
					<tr>
						<td>岗位类型<span style="color:red;vertical-align:middle;">*</span>：</td>
						<td>
							<select id="post_type_id" class="easyui-combotree" name="postTypeId" style="width:380px;width:400px\0;" required="true" missingMessage="不能为空"></select>
						</td>
					</tr>
					<tr>
						<td>所属部门：</td>
						<td>
							<input type="hidden" id="dept_id" name="deptId" />
							<input class="easyui-validatebox" id="dept_name" disabled="disabled" type="text" style="width:380px;line-height: 30px;">
						</td>
					</tr>
					<tr>
						<td>是否封存：</td>
						<td>
							<input id="isSeal" class="easyui-switchbutton" onText="否" offText="是" checked>
						</td>
					</tr>
					<tr>
						<td>岗位描述：</td>
						<td>
							<input class="easyui-textbox" id="post_desc" name="postDesc"  data-options="multiline:true" style="height:120px;width:380px;">
						</td>
					</tr>
				</table>
			</form>
	</div>
	<!-- Form表单按钮 -->
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" id="saveBtn" onclick="doSaveOrUpdatePost()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" id="closeBtn" onclick="javascript:$('#post_dialog').dialog('close')" plain="true">取消</a>
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
	<div id="sortDialog" class="easyui-dialog" closed="true" title="岗位排序" data-options="modal:true" style="width:90%;height:460px;padding:10px"  buttons="#sort-buttons">
		<!-- 单位列表 -->
		<table class="easyui-datagrid" id="postSortGrid" data-options="idField:'postId', method:'post',striped:true,fitColumns:true,fit:true,
			rownumbers:true,pagination:false,singleSelect:true,nowrap:false,onClickRow:onClickRow,onFetch:fetch">
			<thead>
				<tr>
					<th data-options="field:'ck', checkbox:false"></th>
					<th data-options="field:'postName', title : '岗位名称', width:150, align:'left'"></th>
					<th data-options="field:'postCode', title : '岗位编码',width:150, align:'left'"></th>
					<th data-options="field:'sort', title : '排序号', width : 80, align : 'center',formatter:formaterPostSort"></th>
				</tr>
			</thead>
		</table>

		<div id="sort-buttons" class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveSort()" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#sortDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>
	
	<script type="text/javascript">
	//扩展方法，点击事件触发一个单元格的编辑
	$.extend($.fn.datagrid.methods, {
		editCell: function(jq,param){
			return jq.each(function(){
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor1 = col.editor;
					if (fields[i] != param.field){
						col.editor = null;
					}
				}
				$(this).datagrid('beginEdit', param.index);
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor = col.editor1;
				}
			});
		}
	});
	</script>
</body>
</html>