<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流程模块绑定</title>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="http://www.jeasyui.com/easyui/jquery.edatagrid.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/bpm/solcfg/js/solcfg.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/js/common.js"></script>
</head>
<body class="easyui-layout" style="width:100%;height:100%;">
	<!-- bpm系统注册树 -->
	<div data-options="region:'west',split:true,collapsible:false" title="注册系统" style="width: 200px;" class="page_menu">
		<ul class="easyui-tree" id="bpm_sys_tree" />
	</div>
	<!-- bpm模块列表 -->
	<div data-options="region:'center'" class="content">
		<!-- 工具btn -->
		<a href="javascript:void(0)" id="add" name="add" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addModule()" plain="true">添加</a>
		<a href="javascript:void(0)" id="save" name="save" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="selectBizSol()" plain="true">选择应用模型</a>
		<hr/>
		<!-- 查询 -->
		模块名称
		<input id="moduleName" name="moduleName" class="easyui-textbox" value="">
		模块Key
		<input id="moduleKey" name="moduleKey" class="easyui-textbox" value="">
		流程解决方案名称
		<input id="procSolName" name="procSolName"" class="easyui-textbox" value="">
		
		<a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" onclick="datagridrefresh()">查询</a>
		<a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="clearmessage()">清空查询</a>
		
		<br/>
		<br/>
		<div>
			<table class="easyui-treegrid" id="module_treegrid"></table>
		</div>
	</div>
	
	<!-- 业务流程解决方案选择窗口 -->
	<div id="bizSolDlg" style="overflow:hidden;" closed="true" data-options="maximizable:true,resizable:false,modal:true">
		<iframe scrolling="no" id="iframe" frameborder="0" border="0" marginwidth="0"
				marginheight="0" style="width:100%;height:100%;"></iframe>
	</div>
	
	<div id="detail">
			<!-- 流程绑定新增编辑窗口 -->
		<div id="bizSolInfoDlg" style="overflow:hidden;" class="easyui-window" closed="true" data-options="maximizable:true,resizable:false,modal:true">
			<iframe scrolling="no" id="iframe" frameborder="0" style="width:100%;height:100%;"></iframe>
		</div>
	</div>
	
	<!-- 新增模块弹框 -->
	<div id="addDialog" class="easyui-dialog" title="添加模块" closed="true" style="width:450px;height:370px;padding:10px" buttons="#add-module-dlg-buttons">
		<form action="" id="addForm">
			<input type="hidden" name="sysId" id="sys_id"/>
			<table cellpadding="3">
	    		<tr>
	    			<td ><span style="color:red;vertical-align:middle;">*</span>模块名称：</td>
	    			<td ><input class="easyui-textbox" type="text" required="true" missingMessage="不能为空" name="modName" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>模块链接：</td>
	    			<td><input class="easyui-textbox" type="text" name="modUrl" id="modurl" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>模块图标</td>
	    			<td><input class="easyui-textbox" type="text" name="modIcon" style="width:300px;"></input></td>
	    		</tr>
				<tr>
					<td>父级节点:</td>
					<td>
						<select class="easyui-combotree" id="addCombobox" name="parentModId" style="width:300px;" data-options="valueField:'parentModId', textField:'text'">
						</select>
					</td>
				</tr>
		    		<tr>
		    			<td>是否虚拟节点:</td>
		    			<td>
					    	<input name="isVrtlNode" value="Y" type="radio" class="box" id="isVrtlNodeY" />
					    	<label for="isVrtlNodeY">是</label>
	                		<input name="isVrtlNode" value="N" type="radio" class="box" id="isVrtlNodeN" checked/>
	                		<label for="isVrtlNodeN">否</label>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否审计:</td>
		    			<td>
					    	<input name="isAudi" value="Y" type="radio" class="box" id="isAudiY" checked/>
					    	<label for="isAudiY">是</label>
	                		<input name="isAudi" value="N" type="radio" class="box" id="isAudiN" />
	                		<label for="isAudiN">否</label>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否监控性能:</td>
		    			<td>
					    	<input name="isContr" value="Y" type="radio" class="box" id="isContrY" checked/>
					    	<label for="isContrY">是</label>
	                		<input name="isContr" value="N" type="radio" class="box" id="isContrN" />
	                		<label for="isContrN">否</label>
					    </td>
		    		</tr>
	    	</table>
    	</form>
    	<div id="add-module-dlg-buttons">
    		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSave();" iconCls="icon-ok" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addDialog').dialog('close');" iconCls="icon-cancel" plain="true">取消</a>
		</div>
	</div>
</body>
</html>