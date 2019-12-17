<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
	<head>
	<title>单位管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/org/js/orgList.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/datagrid-scrollview.js"></script>
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
			<ul class="easyui-tree" id="orgTree" ></ul>
			<div id="parentNode" class="easyui-menu" style="width: 120px;">
				<div onclick="updateRootNode()" iconcls="icon-edit">编辑</div>
			</div>
		</div>
	</div>
	
	<!-- 右侧内容区域 -->
	<div data-options="region:'center'" class="content">
		<!-- 工具栏 -->
		<div id="toolBar" class="clearfix">
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入单位名称或编码'">
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:orgController:orgList">
					<a href="javascript:void(0)" onclick="doAddOrgBefore()" class="easyui-linkbutton" id="btn_org_add" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:orgController:orgList">
					<a href="javascript:void(0)" onclick="doUpdateOrgBefore()" class="easyui-linkbutton" id="btn_org_update" iconCls="icon-edit" plain="true">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:orgController:orgList">
					<a href="javascript:void(0)" onclick="doDeleteOrg()" class="easyui-linkbutton" id="btn_org_del" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission> 
				<shiro:hasPermission name="orgPic:orgController:orgList"> 
					<a href="javascript:void(0)" onclick="showOrgPic()" class="easyui-linkbutton" iconCls="icon-isc-org" plain="true">查看结构图</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="sortOrg:orgController:orgList"> 
					<a href="javascript:void(0)" onclick="sortOrg()" class="easyui-linkbutton" id="btn_org_sort" iconCls="icon-isc-sort" plain="true">单位排序</a>
				</shiro:hasPermission>
			</div>
		</div>

		<!-- 单位列表 -->
		<table class="easyui-datagrid" id="orgTreeGrid" data-options="view : dataGridExtendView,emptyMsg : '没有相关记录！',
			idField:'orgId', method:'post', toolbar:'#toolBar',striped:true,fitColumns:true,fit:true,rownumbers:true,pagination:true,showFooter:true,nowrap:false">
			<thead>
				<tr>
					<th data-options="field:'ck', checkbox:true"></th>
					<th data-options="field:'orgId', hidden:true"></th>
					<th data-options="field:'parent_id', hidden:true"></th>
					<th data-options="field:'orgName', title : '单位名称', width:200, align:'left'"></th>
					<th data-options="field:'orgUniqId',title : '', width:120, align:'left'"></th>
					<th data-options="field:'orgCode', title : '单位编码',width:120, align:'left', formatter:formaterOrgCode"></th>
					<th data-options="field:'orgDesc', title : '单位描述',width:200, align:'left', formatter:formaterOrgDesc"></th>
					<th data-options="field:'isSeal',title : '是否封存', width:70, align:'left', formatter:formaterIsSeal"></th>
					<th data-options="field:'createTime',title : '创建日期', width:100, align:'left', formatter:formaterCreateTime"></th>
					<th data-options="field:'operate', title : '操作', width : 60, align : 'center', formatter : formatOperate"></th>
				</tr>
			</thead>
		</table>
	</div>

	<!-- 单位Form -->
	<div id="orgDialog" class="easyui-dialog" title="添加单位信息" data-options="modal:true" closed="true" style="width:570px;height:380px;padding:10px;" buttons="#dlg-buttons">
		<form action="" id="orgForm">
			<input type="hidden" id="orgId" name="orgId"/>
			<input type="hidden" id="orgCode" name="orgCode"/>
			<table cellpadding="3">
	    		<tr>
	    			<td >单位名称<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td ><input class="easyui-textbox" type="text" required="true" missingMessage="不能为空" data-options="validType:['isBlank','unnormal','length[1,128]']" id="orgName" name="orgName" style="width:380px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>单位标识<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td><input class="easyui-textbox" type="text" required="true" missingMessage="不能为空" data-options="validType:['isBlank','unnormal','length[1,128]']" id="orgUniqId" name="orgUniqId" style="width:380px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>上级单位：</td>
	    			<td>
	    				<select id="parentOrgId" class="easyui-combotree" name="parentOrgId" style="width:380px;" data-options=""></select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>是否封存：</td>
	    			<td>
	    				<input id="isSeal" class="easyui-switchbutton" onText="否" offText="是" >
					</td>
	    		</tr>
	    		<tr>
	    			<td>单位描述：</td>
	    			<td>
	    				<input class="easyui-textbox" id="orgDesc" name="orgDesc" data-options="multiline:true" style="height:120px;width:380px;">
					</td>
	    		</tr>
	    	</table>
    	</form>
	</div>
	<!-- Form表单按钮 -->
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" id="saveBtn" onclick="doSaveOrUpdateOrg()" class="easyui-linkbutton " plain="true">保存</a>
		<a href="javascript:void(0)" id="closeBtn" class="easyui-linkbutton" onclick="javascript:$('#orgDialog').dialog('close')" plain="true">取消</a>
	</div>
	
	
	<!-- 修改根节点模态框 -->
	<div id="rootDialog" class="easyui-dialog" title="修改" data-options="modal:true" closed="true" style="width:500px;height:180px;padding:10px;" buttons="#root-buttons">
		<form action="" id="rootForm">
			<input type="hidden" id="orgId" name="orgId"/>
			<table>
	    		<tr>
	    			<td >组织架构名称<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td ><input class="easyui-textbox" type="text" required="true" missingMessage="不能为空" data-options="validType:['isBlank','unnormal','length[1,128]']" id="rootName" name="rootName" style="width:330px;"></input></td>
	    		</tr>
	    	</table>
    	</form>
	</div>
	<!-- Form表单按钮 -->
	<div id="root-buttons" class="window-tool">
		<a href="javascript:void(0)" id="saveBtn" onclick="doUpdateRoot()" class="easyui-linkbutton " plain="true">保存</a>
		<a href="javascript:void(0)" id="closeBtn" class="easyui-linkbutton" onclick="javascript:$('#rootDialog').dialog('close')" plain="true">取消</a>
	</div>
	

	<!-- 排序dialog  -->
	<div id="sortDialog" class="easyui-dialog" closed="true" title="单位排序" data-options="modal:true" style="width:90%;height:460px;padding:10px"  buttons="#sort-buttons">
		<!-- 单位列表 -->
		<table class="easyui-datagrid" id="orgSortGrid" data-options="idField:'orgId', method:'post',striped:true,fitColumns:true,fit:true,
			rownumbers:true,pagination:false,singleSelect:true,nowrap:false,onClickRow:onClickRow,onFetch:fetch">
			<thead>
				<tr>
					<th data-options="field:'ck', checkbox:false"></th>
					<th data-options="field:'orgId', hidden:true"></th>
					<th data-options="field:'parent_id', hidden:true"></th>
					<th data-options="field:'orgName', title : '单位名称', width:200, align:'left'"></th>
					<th data-options="field:'orgCode', title : '单位编码',width:120, align:'left', formatter:formaterOrgCode"></th>
					<th data-options="field:'sort', title : '排序号', width : 80, align : 'center',formatter:formaterOrgSort"></th>
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