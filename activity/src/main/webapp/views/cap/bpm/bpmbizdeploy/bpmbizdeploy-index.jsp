<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>模块管理</title>
	<meta http-equiv="X-UA-Compatible" content="IE=8" />
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/bpm/bpmbizdeploy/js/bpmbizdeploy-index.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/bpm/bpmbizdeploy/js/resource.js"></script>
	<%-- <script type="text/javascript" src="${ctx}/views/cap/isc/menu/js/resource.js"></script> --%>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
		<div data-options="region:'west',split:true,collapsible:false" title="注册系统" style="width: 200px;" class="page_menu">
			<!-- 系统注册树 -->
			<ul class="easyui-tree" id="sys_reg_tree" />
		</div>

		<div data-options="region:'center'" class="content">
			<div id="modulePanel" class="easyui-panel" title="模块" style="width:100%;height:60%;">
			<div id="toolBar" class="clearfix mart-10">
				<div class="search-input">
					<input id="search" class="easyui-searchbox" data-options="searcher:findByModuleName,prompt:'输入模块名称'">
					<span class="clear" onclick="clearSearchBox()"></span>
				</div>
				<div id="operate_btn" class="tool_btn">
					<shiro:hasPermission name="add:moduleController:moduleList">
						<a href="javascript:void(0)" iconCls="icon-add" class="easyui-linkbutton" plain="true" onclick="addModule();">新增模块</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="modify:moduleController:moduleList">
						<a href="javascript:void(0)" iconCls="icon-edit" class="easyui-linkbutton"  plain="true" onclick="modModule();">修改模块</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="delete:moduleController:moduleList">
						<a href="javascript:void(0)" iconCls="icon-remove" class="easyui-linkbutton"  plain="true" onclick="delModule();">删除模块</a>
					</shiro:hasPermission>
				</div>
			</div>
				<div>
					<!-- 模块列表树 -->
					<table class="easyui-treegrid" id="module_treegrid"></table>
				</div>
			</div>
			<div id="rescPanel" class="easyui-panel" title="资源" style="width:100%;height:40%;">
				<div id="operate_btn" style="margin-bottom: 5px; margin-top: 5px">
					<shiro:hasPermission name="addResc:moduleController:moduleList">
						<a href="javascript:void(0)" iconCls="icon-add" class="easyui-linkbutton" plain="true" onclick="addResource();">新增资源</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="modifyResc:moduleController:moduleList">
						<a href="javascript:void(0)" iconCls="icon-edit" class="easyui-linkbutton"  plain="true" onclick="modResource();">修改资源</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="deleteResc:moduleController:moduleList"> 
						<a href="javascript:void(0)" iconCls="icon-remove" class="easyui-linkbutton"  plain="true" onclick="delResource();">删除资源</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="genResc:moduleController:moduleList">
						<a href="javascript:void(0)" iconCls="icon-remove" class="easyui-linkbutton"  plain="true" onclick="quickCreate();">生成增、删、改</a>
					</shiro:hasPermission>
				</div>
				<div>
					<!-- 资源列表 -->
					<table class="easyui-datagrid" id="resc_datagrid"></table>
				</div>
			</div>
		</div>

	<!-- 新增模块弹框 -->
	<div id="addDialog" class="easyui-dialog" title="添加模块" closed="true" data-options="modal:true" style="width:450px;height:400px;padding:10px" buttons="#add-module-dlg-buttons">
		<form action="" id="addForm">
			<input type="hidden" name="sysId" id="sys_id"/>
			<table cellpadding="3">
	    		<tr>
	    			<td >模块名称<span style="color:red;vertical-align:middle;">*</span>：</td>
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
    	<div id="add-module-dlg-buttons" class="window-tool">
    		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSave();" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addDialog').dialog('close');" plain="true">取消</a>
		</div>
	</div>

	<!-- 修改模块弹框 -->
	<div id="modifyDialog" class="easyui-dialog" title="修改模块" closed="true" data-options="modal:true" style="width:450px;height:400px;padding:10px" buttons="#modify-module-dlg-buttons">
		<form action="" id="modifyForm">
			<input type="hidden" name="modId" id="mod_id"/>
			<table cellpadding="3">
	    		<tr>
	    			<td >模块名称<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td ><input class="easyui-textbox" type="text" required="true" missingMessage="不能为空" name="modName" id="mod_name" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>模块链接：</td>
	    			<td><input class="easyui-textbox" type="text" name="modUrl" id="mod_url" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>模块图标</td>
	    			<td><input class="easyui-textbox" type="text" name="modIcon" id="mod_icon" style="width:300px;"></input></td>
	    		</tr>
				<tr>
					<td>父级节点:</td>
					<td>
						<select class="easyui-combotree" id="modCombobox" name="parentModId" style="width:300px;" data-options="valueField:'parentModId', textField:'text'">
						</select>
					</td>
				</tr>
		    		<tr>
		    			<td>是否虚拟节点:</td>
		    			<td>
					    	<input name="isVrtlNode" value="Y" type="radio" class="box" id="isVrtlNode0Y" />
					    	<label for="isVrtlNode0Y">是</label>
	                		<input name="isVrtlNode" value="N" type="radio" class="box" id="isVrtlNode0N" checked/>
	                		<label for="isVrtlNode0N">否</label>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否审计:</td>
		    			<td>
					    	<input name="isAudi" value="Y" type="radio" class="box" id="isAudi0Y" checked/>
					    	<label for="isAudi0Y">是</label>
	                		<input name="isAudi" value="N" type="radio" class="box" id="isAudi0N" />
	                		<label for="isAudi0N">否</label>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否监控性能:</td>
		    			<td>
					    	<input name="isContr" value="Y" type="radio" class="box" id="isContr0Y" checked/>
					    	<label for="isContr0Y">是</label>
	                		<input name="isContr" value="N" type="radio" class="box" id="isContr0N" />
	                		<label for="isContr0N">否</label>
					    </td>
		    		</tr>
	    	</table>
    	</form>
    	<div id="modify-module-dlg-buttons" class="window-tool">
    		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doModify()" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#modifyDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>

	<!-- 新增资源弹框 -->
	<div id="addResDialog" class="easyui-dialog" title="添加资源" closed="true" data-options="modal:true" style="width:450px;height:370px;padding:10px" buttons="#add-res-dlg-buttons">
		<form action="" id="addResForm">
			<input type="hidden" name="modId" id="modId"/>
			<table cellpadding="3">
	    		<tr>
	    			<td >资源名称<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td ><input class="easyui-textbox" type="text" required="true" missingMessage="不能为空" name="resName" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>资源编码<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td><input class="easyui-textbox" type="text" name="resCode" id="addCode" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>资源标识：</td>
	    			<td><input class="easyui-textbox" type="text" readonly="readonly" name="resUnId" id="addUnid" style="width:300px;"></input></td>
	    		</tr>
		    		<tr>
		    			<td>类型:</td>
		    			<td>
					    	<input name="resType" value="0" type="radio" class="box" id="resType0" checked/>
					    	<label for="resType0">按钮</label>
	                		<input name="resType" value="1" type="radio" class="box" id="resType1" />
	                		<label for="resType1">文本框</label>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否审计:</td>
		    			<td>
					    	<input name="isAudit" value="Y" type="radio" class="box" id="isAuditY" checked/>
					    	<label for="isAuditY">是</label>
	                		<input name="isAudit" value="N" type="radio" class="box" id="isAuditN" />
	                		<label for="isAuditN">否</label>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否监控性能:</td>
		    			<td>
					    	<input name="isContr" value="Y" type="radio" class="box" id="isControY" checked/>
					    	<label for="isControY">是</label>
	                		<input name="isContr" value="N" type="radio" class="box" id="isControN" />
	                		<label for="isControN">否</label>
					    </td>
		    		</tr>
	    	</table>
    	</form>
    	<div id="add-res-dlg-buttons" class="window-tool">
    		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveResource()" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addResDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>

	<!-- 修改资源弹框 -->
	<div id="modifyResDialog" class="easyui-dialog" title="修改资源" closed="true" data-options="modal:true" style="width:450px;height:370px;padding:10px"  buttons="#modify-res-dlg-buttons">
		<form action="" id="modifyResForm">
			<input type="hidden" name="resId" id="res_id"/>
			<table cellpadding="3">
	    		<tr>
	    			<td >资源名称<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td ><input class="easyui-textbox" type="text" required="true" missingMessage="不能为空" name="resName" id="res_name" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>资源编码<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td><input class="easyui-textbox" type="text" required="true" missingMessage="不能为空" name="resCode" id="res_code" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>资源标识：</td>
	    			<td><input class="easyui-textbox" type="text" readonly="readonly" name="resUnId" id="res_unId" style="width:300px;"></input></td>
	    		</tr>
		    		<tr>
		    			<td>类型:</td>
		    			<td>
					    	<input name="resType" value="0" type="radio" class="box" id="resTypeMod0" checked/>
					    	<label for="resTypeMod0">按钮</label>
	                		<input name="resType" value="1" type="radio" class="box" id="resTypeMod1" />
	                		<label for="resTypeMod1">文本框</label>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否审计:</td>
		    			<td>
					    	<input name="isAudit" value="Y" type="radio" class="box" id="isAuditModY" checked/>
					    	<label for="isAuditModY">是</label>
	                		<input name="isAudit" value="N" type="radio" class="box" id="isAuditModN" />
	                		<label for="isAuditModN">否</label>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否监控性能:</td>
		    			<td>
					    	<input name="isContr" value="Y" type="radio" class="box" id="isContrModY" checked/>
					    	<label for="isContrModY">是</label>
	                		<input name="isContr" value="N" type="radio" class="box" id="isContrModN" />
	                		<label for="isContrModN">否</label>
					    </td>
		    		</tr>
	    	</table>
    	</form>
    	<div id="modify-res-dlg-buttons" class="window-tool">
    		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="modifyResource()" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#modifyResDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>
	
	<!-- 业务流程解决方案选择窗口 -->
	<div id="bizSolDlg" style="overflow:hidden;" closed="true" data-options="maximizable:true,resizable:false,modal:true">
		<iframe scrolling="no" id="iframe" frameborder="0" border="0" marginwidth="0"
				marginheight="0" style="width:100%;height:100%;"></iframe>
	</div>
</body>
</html>