<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>常用语管理</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<script type="text/javascript" src="${ctx}/views/cap/bpm/phrasebook/js/phrasebook_index.js"></script>
</head>
<body class="easyui-layout" style="width:100%;height:100%">
	<!-- 页面布局西部 -->
	<div data-options="region:'west',split:true" title="业务表单分类" style="width:200px;">
		<!-- <span><button onclick="InitTreeData()" >刷新</button></span> -->
		<!-- 业务表单单类别树 -->
		<ul class="easyui-tree" id="formCtlgTree"></ul>
		
		<!-- 业务解决方案类别右击菜单  -->
		<div id="formCtlgMenu" class="easyui-menu" style="width:120px;">
			<div id="addMenu" onclick="addFormCtlg('brother')" data-options="iconCls:'icon-add'">添加同级类别</div>
			<div onclick="addFormCtlg('child')" data-options="iconCls:'icon-add'">添加子级类别</div>
			<div onclick="editFormCtlg()" data-options="iconCls:'icon-edit'">编辑所选类别</div>
			<div id="delMenu" onclick="delFormCtlg()" data-options="iconCls:'icon-remove'">删除所选类别</div>
		</div>
		<!-- 流程定义类别新增/修改窗口 -->
		<div id="formCtlgDlg" class="easyui-dialog" closed="true" title="" style="width:300px;height:290px;padding:10px">
			<form id="formCtlg">
				<input type="hidden" id="id" name="id">
				<input type="hidden" id="parentId_" name="parentId_">
				<input type="hidden" id="treeType_" name="treeType_">
				<input type="hidden" id="sort_" name="sort_">
				<input type="hidden" id="dr_" name="dr_">
				<input type="hidden" id="userId_" name="userId_">
				<input type="hidden" id="type_" name="type_">
				<div style="margin-bottom:5px">
				<div>类别名称:</div>
					<input class="easyui-textbox" id="name_" name="name_"
						style="width:100%;height:32px">
				</div>
				<div style="margin-bottom:5px">
					<div>类别描述:</div>
					<input class="easyui-textbox" data-options="multiline:true" id="desc_" name="desc_"
						style="width:100%;height:100px">
				</div>
				<div>
				<a href="#" onclick="doSaveFormCtlg()" class="easyui-linkbutton"
					iconCls="icon-ok" style="width:100%;height:32px">保存</a>
				</div>
			</form>
		</div>
	</div>
	
	<!-- 页面布局中部 -->
	<div data-options="region:'center',title:'业务表单'">
		<!-- 列表工具栏 -->
		<div id="toolbar" style="padding: 5px; height: auto">
			<a href="javascript:void(0)" onclick="add()"
				class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
			<a href="javascript:void(0)" onclick="update()"
				class="easyui-linkbutton" iconCls="icon-edit" plain="true" >编辑</a> 
			<a href="javascript:void(0)" onclick="delele()"
				class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
			<div style="padding:3px">
				<span>请选择查询字段：</span>
				<select class="easyui-combobox" id="zd" value="" data-options="editable:false,panelHeight:'auto',width:200">
					<option value="">请选择</option>
					<option value="formName_">名称</option>
					<option value="key_">标识键</option>
				</select>
				<select class="easyui-combobox" value="" id="tj" data-options="editable:false,panelHeight:'auto',width:200">
					<option value="">请选择</option>
					<option value="equal">等于</option>
					<option value="fuzzy">模糊匹配</option>
					<option value="left_fuzzy">左模糊匹配</option>
					<option value="right_fuzzy">右模糊匹配</option>
				</select>
				<input  class="easyui-textbox" id="searchValue"  >
				<a href="javascript:void(0)" onclick="searchData()" data-options="iconCls:'icon-search'"
				class="easyui-linkbutton" plain="true">查询</a>
				<a href="javascript:void(0)" onclick="reloadTableData()"
				class="easyui-linkbutton" plain="true">清空查询</a>
			</div>
		</div>

		<!-- 流程定义列表 -->
		<table class="easyui-datagrid" id="bpmReFormList"
			data-options="idField:'id',toolbar:'#toolbar',striped:true,fitColumns:true,fit:true,rownumbers:true,pagination:true,nowrap:false,showFooter:true,nowrap:false">
			<thead frozen="true">
				<tr>
					<th data-options="field :'ck',checkbox:true"></th>
				</tr>
			</thead>
			<thead>
				<tr>
					<th data-options="field:'content_',width:200">名称</th>
					<th data-options="field:'number_',width:80,align:'left'">使用次数</th>
					<th data-options="field:'lastUseTime_',width:100,align:'left',formatter: formatterTime">最后使用时间</th>
					<th data-options="field:'createTime_',width:100,align:'left',formatter: formatterTime">创建时间</th>
				</tr>
			</thead>
		</table>
	</div>
	<!--新增、修改窗口-->
	<div id="phrasebook" class="easyui-dialog" closed="true" title="" style="width:300px;height:290px;padding:10px">
		<form id="phrasebookFm">
			<div style="margin-bottom:5px">
				<div>常用语:</div>
				<input class="easyui-textbox" data-options="multiline:true" id="content_" name="content_"
					style="width:100%;height:100px">
			</div>
			<div>
			<a href="#" onclick="doSavePhrasebook()" class="easyui-linkbutton"
				iconCls="icon-ok" style="width:100%;height:32px">保存</a>
			</div>
		</form>
	</div>
	</div>
</body>
</html>