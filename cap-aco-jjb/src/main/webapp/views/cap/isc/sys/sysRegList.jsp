<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>系统注册管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/sys/js/sysRegList.js"></script>
	
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
<div data-options="region:'center'" class="content">
		<!-- 工具栏 -->
		<div id="toolBar" class="clearfix">
			<div class="search-input">
			<!-- 条件查询 -->
				<input id="sysFlagAndName" name="sysFlagAndName" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入系统标识或名称'"/>
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:sysRegController:sysRegList">
					<a href="javascript:void(0)" onclick="openForm('新增系统注册信息')" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:sysRegController:sysRegList">
					<a href="javascript:void(0)" onclick="openUpdateForm('修改系统注册信息')" class="easyui-linkbutton" iconCls="icon-edit" id="btn_sys_reg_modify" plain="true">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:sysRegController:sysRegList">
					<a href="javascript:void(0)" onclick="doDeleteSysReg()" class="easyui-linkbutton" iconCls="icon-remove" id="btn_sys_reg_del" plain="true">删除</a>
				</shiro:hasPermission>
				<a href="javascript:void(0)" onclick="toSetTheme()" class="easyui-linkbutton" iconCls="icon-sys-theme" id="btn_sys_reg_theme" plain="true">主题配置</a>
				<a href="javascript:void(0)" onclick="toSetLogo()" class="easyui-linkbutton" iconCls="icon-sys-logo" id="btn_sys_reg_logo" plain="true">logo配置</a>
			</div>
		</div>
		<!-- 系统注册列表 -->
		<table class="easyui-datagrid" id="sysRegList"></table>
</div>
	<!-- 系统注册Form表单 -->
	<div id="sysRegDialog" class="easyui-dialog"  closed="true" data-options="modal:true" title="新增系统注册信息" style="width:470px;height:415px;" buttons="#dlg-buttons">
		<div class="easyui-panel window-body" style="height: 100%;">
			<form id="sysRegForm" method="post" class="window-form">
				<input type="hidden" id="sysRegId" name="sysRegId" />
				<input type="hidden" id="orgId" name="orgId" />
				<table cellpadding="3" class="form-table">
		    		<tr>
		    			<td>系统名称<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,256]']" required="true" missingMessage="不能为空" id="sysName" name="sysName" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >系统标识<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td >
		    				<input class="easyui-textbox" data-options="validType:['isBlank','unnormal','length[1,128]']" required="true" missingMessage="不能为空" type="text" id="sysFlag" name="sysFlag" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr style="display: none;">
		    			<td >访问地址<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" data-options="validType:['isBlank','length[1,1024]','url']" type="text" id="sysUrl" missingMessage="不能为空" name="sysUrl" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td>是否禁用:</td>
		    			<td>
		    				<input id="isDisable" class="easyui-switchbutton" onText="是" offText="否" checked>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>系统类型:</td>
		    			<td>
		    				<select class="easyui-combobox select_txt" style="width:270px\0;"  id="isOutSys" name="isOutSys" panelHeight="80" data-options="editable:false">
		    					<option value="0">生长系统</option>
		    					<option value="1">接入系统</option>
		    					<option value="2">支撑平台</option>
		    				</select>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>系统描述:</td>
		    			<td>
		    				<input class="easyui-textbox" id="sysDesc" data-options="multiline:true" style="width:300px;height:80px" />
		    			</td>
		    		</tr>
		    	</table>
			</form>
		</div>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveSysReg()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#sysRegDialog').dialog('close')" plain="true">取消</a>
	</div>

	<!--logo配置 START -->
	<div id="logoDialog" class="easyui-dialog"  closed="true" title="logo配置" data-options="modal:true" style="width:90%;height:90%;padding:10px" buttons="#logo-buttons">
		<iframe frameborder="0" name="logoFrame" id="logoFrame"
			width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
	</div>
	<div id="logo-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#logoDialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<<!-- 主题设置dialog  -->
	<div id="themeDialog" class="easyui-dialog" closed="true" title="关联主题" data-options="modal:true" style="width:90%;height:460px;padding:5px"  buttons="#theme-buttons">
		<div id="toolBar1" class="clearfix">
			<div class="search-input" style="display:none;">
				<input id="search1" class="easyui-searchbox" data-options="searcher:findByCondition1,prompt:'输入主题名称'">
				<span class="clear" onclick="clearSearchBox1()"></span>
			</div>
		</div>
		<!-- 主题列表 -->
		<table class="easyui-datagrid" id="themeList" style="height: 100%"></table>
	
		<div id="theme-buttons" class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveSysTheme()" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#themeDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>
	<!-- 主题设置dialog END -->
</body>
</html>