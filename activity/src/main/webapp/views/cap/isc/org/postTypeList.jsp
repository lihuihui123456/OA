<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>岗位类型管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/org/js/postTypeList.js"></script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<!-- 用户界面布局 -->
	<div data-options="region:'west',split:true,collapsible:false" class="page_menu">
		<!-- 单位机构树 -->
		<div class="search-tree">
			<input id="org_search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入单位名称'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<ul class="easyui-tree" id="org_tree" />
		</div>
	</div>
	<!-- 右侧内容区域 -->
	<div data-options="region:'center'" class="content">
		<div id="toolBar" class="clearfix">
			<!-- 条件查询 -->
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入岗位类型名称或编码'">
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<!-- 工具栏 -->
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:postTypeController:postTypeList">
					<a href="javascript:void(0)" onclick="doAddPostTypeBefore()" class="easyui-linkbutton" id="btn_post_add" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:postTypeController:postTypeList">
					<a href="javascript:void(0)" onclick="doUpdatePostTypeBefore()" class="easyui-linkbutton" id="btn_post_edit" iconCls="icon-edit" plain="true">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:postTypeController:postTypeList">
					<a href="javascript:void(0)" onclick="doDeletePostType()" class="easyui-linkbutton" iconCls="icon-remove" id="btn_post_del" plain="true">删除</a>
				</shiro:hasPermission>
			</div>
		</div>
		<!-- 岗位类型列表 -->
		<table class="easyui-datagrid" id="postTypeList" data-options="
			method : 'POST',
			idField : 'postTypeId',
			striped : true,
			fitColumns : true,
			fit: true,
			singleSelect : false,
			rownumbers : true,
			pagination : true,
			nowrap : false,
			toolbar : '#toolBar',
			pageSize : 10,
			showFooter : true" >
				<thead>
					<tr>
						<th data-options="field : 'ck', checkbox : true"></th>
						<th data-options="field : 'postTypeId', title : 'postTypeId', hidden : true"></th>
						<th data-options="field : 'postTypeName', title : '岗位类型名称', width : 180, align : 'left'"></th>
						<th data-options="field : 'postTypeCode', title : '岗位类型编码', width : 180, align : 'left'"></th>
						<th data-options="field : 'postTypeDesc', title : '岗位类型描述', width :180, align : 'left'"></th>
						<th data-options="field : 'isSeal', title : '是否封存', width :70, align : 'center', formatter:formaterIsSeal"></th>
						<th data-options="field : 'createTime', title : '创建日期', width : 90, align : 'left', formatter:formaterCreateTime"></th>
						<th data-options="field : 'operate', title : '操作', width : 100, align : 'center', formatter : formatOperate"></th>
					</tr>
				</thead>
			
			</table>
	</div>

	<div id="postTypeDlg" class="easyui-dialog" closed="true" data-options="modal:true" style="width:570px;height:350px;padding:10px" buttons="#dlg-buttons">
		<form id="postTypeForm" method="post">
			<input type="hidden" id="postTypeId" name="postTypeId">
			<input type="hidden" id="postTypeCode" name="postTypeCode" >
			<table cellpadding="3">
				<tr>
					<td>岗位类型名称<span style="color:red;vertical-align:middle;">*</span>:</td>
					<td><input class="easyui-textbox" type="text" id="postTypeName" name="postTypeName"  required="true" missingMessage="不能为空" data-options="validType:['isBlank','unnormal','length[1,128]']" style="width:380px;"></td>
				</tr>
				<tr>
					<td>所属单位名称:</td>
					<td>
						<input type="hidden" id="org_id" name="orgId"/>
						<input class="easyui-textbox" id="org_name" disabled="disabled" style="width:380px;">
					</td>
				</tr>
				<tr>
					<td>是否封存:</td>
					<td>
						<input id="isSeal" class="easyui-switchbutton" onText="否" offText="是" checked>
					</td>
				</tr>
				<tr>
					<td>岗位类型描述:</td>
					<td>
					<input class="easyui-textbox" id="postTypeDesc" name="postTypeDesc"  data-options="multiline:true"
						style="height:120px;width:380px;"></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveOrUpdatePostType()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#postTypeDlg').dialog('close')" plain="true">取消</a>
	</div>
</body>
</html>