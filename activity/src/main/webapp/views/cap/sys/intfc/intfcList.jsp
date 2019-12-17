<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>接口类型</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/intfc/js/intfcList.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/sys/intfc/js/intfcInfo.js"></script>
	
</head>
<body class="easyui-layout" style="width:100%; height:98%;">
		<input type="hidden" id="typeid">
		<!-- 左侧接口类型区域 -->
		<div data-options="region:'west',split:true,collapsible:false" style="width: 200px;" class="page_menu">
			<div class="search-tree">
				<input id="org_search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入接口类型'"/>
				<span class="clear" onclick="clearSearchBox()"></span>
				<!-- 左侧接口类型树 -->
				<ul class="easyui-tree" id="tree"></ul>
			</div>
		</div>
		
		<!-- 右侧接口管理列表区域 -->
		<div data-options="region:'center',iconCls:'icon-ok'" class="content">
			<!-- 接口管理列表工具栏 -->
			<div id="toolbar1" class="clearfix">
				<div class="search-input">
					<input id="search" class="easyui-searchbox" data-options="searcher:searchList,prompt:'输入接口名称或接口类型'"></input>
					<span class="clear" onclick="clearSearchBox()"></span>
				</div>
				<div id="operateBtn" class="tool_btn">
					<shiro:hasPermission name="add:intfcController:intfcList">
						<a href="javascript:void(0)" onclick="saveInfo()" id="btn_add" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="modify:intfcController:intfcList">
						<a href="javascript:void(0)" class="easyui-linkbutton" id="btn_edit" iconCls="icon-edit" plain="true" onclick="updateInfo()">修改</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="delete:intfcController:intfcList">
						<a href="javascript:void(0)" onclick="deleteInfo()" id="btn_del" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
					</shiro:hasPermission>
				</div>
			</div>
			<!-- 右侧接口管理列表 -->
			<table class="easyui-datagrid" id="dtlist"></table>
		</div>
	</div>
	<div id="mm" class="easyui-menu" style="width: 60px;">
		<div onclick="addNode()">添加节点</div>
		<div onclick="modNode()">修改节点</div>
		<div onclick="delNode()">删除节点</div>
	</div>
	<div id="typeDialog" class="easyui-dialog" title="添加接口类型" closed="true" data-options="modal:true"
		style="width: 460px; height: 270px; padding: 10px" buttons="#typeDialog-buttons">
		<form id="typeForm" action="">
			<table cellpadding="3">
				<tr>
					<td>类型名称<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td>
						<input class="easyui-textbox" id="typeName" style="width: 300px" type="text" required="true" missingMessage="不能为空"/>
					</td>
				</tr>
				<tr>
					<td>备注信息：</td>
					<td>
						<input class="easyui-textbox" id="remark" style="width: 300px">
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div id="typeDialog-buttons" class="window-tool">
		<a href="javascript:void(0)" onclick="doSaveType()" class="easyui-linkbutton" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#typeDialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 接口信息新增修改对话框 -->
	<div id="add_intfc_dialog" class="easyui-dialog" title="添加接口" closed="true" data-options="modal:true" style="width:750px;height:480px;" buttons="#add_intfc_dialog-buttons">
		<form id="add_intfc_form" name="add_intfc_form" method="post" novalidate class="window-form">
			<input type="hidden" id="rows" name="rows">
			<input type="hidden" id="typeId" name="typeId">
			<input type="hidden" id="id" name="id" >
			<div class="easyui-panel window-panel-header" style="width:100%;padding-left:10px;" title="接口基本信息">
				<table class="form-table">
					<tr>
						<td>接口名称<span style="color:red;vertical-align:middle;">*</span>:</td>
						<td><input class="easyui-textbox" id="intfcName" name="intfcName" style="width:200px" required="true" missingMessage="不能为空"></td>
						<td>请求方式<span style="color:red;vertical-align:middle;">*</span>:</td>
						<td><select class="easyui-combobox" id="reqMode" name="reqMode" required="true" missingMessage="不能为空"
								style="width:200px;height:32px" panelHeight="50" data-options="editable:false">
									<option value="post">post</option>
									<option value="get">get</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>接口类型<span style="color:red;vertical-align:middle;">*</span>:</td>
						<td><select class="easyui-combobox" id="intfcType" name="intfcType" required="true" missingMessage="不能为空"
								style="width:200px;height:32px" panelHeight="50" data-options="editable:false">
									<option value="webservice">webservice</option>
									<option value="httpclient">httpclient</option>
							</select>
						</td>
						<td>实现方式<span style="color:red;vertical-align:middle;">*</span>:</td>
						<td><select class="easyui-combobox" id="impMode" name="impMode" required="true" missingMessage="不能为空"
								style="width:200px;height:32px" panelHeight="50" data-options="editable:false">
									<option value="axis2">axis2</option>
									<option value="cxf">cxf</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>接口地址<span style="color:red;vertical-align:middle;">*</span>:</td>
		    			<td colspan="4"><input class="easyui-textbox" id="url" name="url" style="height:32px;width:548px" required="true" missingMessage="不能为空"></td>
					</tr>
					<tr>
						<td>方法名称<span style="color:red;vertical-align:middle;">*</span>:</td>
						<td><input class="easyui-textbox" id="method" name="method" required="true" missingMessage="不能为空"
							style="height:32px;width:200px"></td>
						<td>系统名称<span style="color:red;vertical-align:middle;">*</span>:</td>
						<td><input class="easyui-textbox" id="sysName" name="sysName" required="true" missingMessage="不能为空"
							style="height:32px;width:200px"></td>
					</tr>
					<tr>
						<td>备注:</td>
						<td colspan="4">
							<textarea  id="remark1" rows="2" style="width:548px" name="remark"></textarea>
						</td>
					</tr>
				</table>
			</div>
			<div class="easyui-panel" style="width:100%;padding-left:10px;" title="接口参数信息">
				<a href="javascript:void(0)" class="easyui-linkbutton"  onclick="addParm()">添加参数</a>
				<div style="height:auto;">
                   <table id="tb1" class="easyui-datagrid" style="width: 650px; height: 150px;"
						border="0"
						data-options="
				           rownumbers:false,
				           animate: true,
				           collapsible: true,
				           fitColumns: true,
				           method:'post',
						   ">
						<thead>
							<tr>
								<th data-options="field:'infoId',hidden:true">infoId</th>
								<th data-options="field:'sort',width:80,align:'center'">参数序号</th>
								<th data-options="field:'parmName',width:140,align:'center'">参数名称</th>
								<th data-options="field:'defValue',width:140,align:'center'">默认值</th>
								<th data-options="field:'remark',width:160,align:'center'">描述</th>
								<th data-options="field:'modify',width:100,align:'center',
									formatter:function(value,row){
										return planUrl(value,row);
								}">操作</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</form>
	</div>
	<div id="add_intfc_dialog-buttons" class="window-tool">
		<a href="javascript:void(0)" id="save_intfc" onclick="doSaveIntfcInfo()" class="easyui-linkbutton" plain="true">保存</a>
		<a href="javascript:void(0)" id="update_intfc" onclick="doSaveIntfcInfo(1)" class="easyui-linkbutton" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#add_intfc_dialog').dialog('close')" plain="true">取消</a>
	</div>
	

	<div id="param_dialog" class="easyui-dialog" title="添加参数信息" data-options="modal:true" closed="true" style="width:460px;height:305px;" buttons="#param_dialog-buttons">
		<form id="paramForm">
		<table cellpadding="3">
			<tr>
				<td>参数名称<span style="color:red;vertical-align:middle;">*</span>:</td>
				<td>
					<input class="easyui-textbox" id="parmName" style="width: 300px; height: 32px" required="true" missingMessage="不能为空">
				</td>
			</tr>
			<tr>
				<td>参数序号<span style="color:red;vertical-align:middle;">*</span>:</td>
				<td>
					<input class="easyui-textbox" id="sort" style="width: 300px; height: 32px" required="true" missingMessage="不能为空">
				</td>
			</tr>
			<tr>
				<td>默认值:</td>
				<td>
					<input class="easyui-textbox" id="defValue" style="width: 300px; height: 32px">
				</td>
			</tr>
			<tr>
				<td>描述:</td>
				<td>
					<input class="easyui-textbox" id="para_remark" style="width: 300px; height: 32px">
				</td>
			</tr>
		</table>
		</form>
	</div>
	<div id="param_dialog-buttons" class="window-tool">
		<a href="javascript:void(0)" onclick="saveParms()" class="easyui-linkbutton" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#param_dialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 测试接口对话框 -->
	<div id="test_dialog" class="easyui-dialog" closed="true" title="测试接口"  data-options="modal:true" style="width:750px;height:480px;" buttons="#test_dialog-buttons">
		<iframe frameborder="0" name="testFrame" id="testFrame"
			src=""
			width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="auto" allowtransparency="yes" scrolling="no" allowtransparency="yes"></iframe>
	</div>
	<div id="test_dialog-buttons" class="window-tool">
		<a href="javascript:void(0)" onclick="run()" class="easyui-linkbutton" plain="true">测试请求</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#test_dialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<%-- <div id="dlgdata" class="easyui-dialog" title="添加接口"
		data-options="iconCls:'icon-save'" closed="true"
		style="width: 715px; height: 100%; padding: 10px">
		
		<iframe frameborder="0" name="mainFrame" id="mainFrame"
			src="${ctx}/views/system/intfc/intfc.jsp"
			width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="no" allowtransparency="yes" scrolling="no" allowtransparency="yes"></iframe> --%>
</body>
</html>