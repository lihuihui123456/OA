<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>同联Da3政务协同办公平台发展简史管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/softHist/js/sysSoftHistList.js"></script>
	
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
<div data-options="region:'center'" class="content">
		<!-- 工具栏 -->
		<div id="toolBar" class="clearfix">
			<div class="search-input">
			<!-- 条件查询 -->
				<input id="name" name="name" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入事件名称'"/>
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:historyController:sysSoftHistList">
					<a href="javascript:void(0)" onclick="openForm('新增公司简史信息')" id="btn_add" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:historyController:sysSoftHistList">
					<a href="javascript:void(0)" onclick="openUpdateForm('修改公司简史信息')" id="btn_edit" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:historyController:sysSoftHistList">
					<a href="javascript:void(0)" onclick="doDeleteHistory()" id="btn_del" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="preview:historyController:sysSoftHistList">
					<a href="${ctx}/historyController/showSysSoftHist"  target="view_window" id="btn_view" class="easyui-linkbutton" iconCls="icon-isc-yl" plain="true">预览</a>
				</shiro:hasPermission>
			</div>
		</div>
		<!-- 系统注册列表 -->
		<table class="easyui-datagrid" id="historyList"></table>
</div>
	<!-- 系统注册Form表单 -->
	<div id="historyDialog" class="easyui-dialog"  closed="true" data-options="modal:true" title="新增系统注册信息" style="width:470px;height:415px;" buttons="#dlg-buttons">
		<div class="easyui-panel window-body" style="height: 100%;">
			<form id="historyForm" method="post" class="window-form">
				<input type="hidden" id="histId" name="histId" />
				<table cellpadding="3" class="form-table">
					<tr>
						<td>皮肤：</td>
						<td>
							<select class="easyui-combobox" style="width:300px;"  id="histSkin" name="histSkin" data-options="editable:false">
								<option value="">默认</option>
								<option value="yellow">黄色</option>
								<option value="blue">蓝色</option>
							</select>
						</td>
					</tr>
		    		<tr>
		    			<td>事件日期<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-datebox input_txt" style="width:300px;"  id="histDate" name="histDate" data-options="editable:false">
		    			</td>
		    		</tr>
		    		<tr>
		    			<td>事件名称<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,256]']" required="true" missingMessage="不能为空" id="histName" name="histName" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td>事件简述:</td>
		    			<td>
		    				<input class="easyui-textbox" data-options="validType:['length[1,1024]']" id="histDesc" name="histDesc" data-options="multiline:true" style="width:300px;height:80px" />
		    			</td>
		    		</tr>
		    	</table>
			</form>
		</div>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveSysHistory()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#historyDialog').dialog('close')" plain="true">取消</a>
	</div>

</body>
</html>