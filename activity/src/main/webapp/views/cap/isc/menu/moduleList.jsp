<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>模块管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/menu/js/moduleList.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/menu/js/resource.js"></script>
	<style>
	.btn-postion{
	  height: 40px;
	  position: absolute;
	  top: 0;
	  left: 10px;
	  z-index: 2;
	  background: #FFF;
	  width: 96%;
	}
	</style>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<div data-options="region:'west',split:true,collapsible:false" class="page_menu">
		<!-- 系统注册树 -->
		<div class="search-tree">
			<input id="sys_search" class="easyui-searchbox" data-options="searcher:sysTreeSearch,prompt:'输入系统名称'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<ul class="easyui-tree" id="sys_reg_tree" ></ul>
		</div>
	</div>

	<div data-options="region:'center'" class="content">
		<div id="toolBar" class="clearfix">
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByModuleName,prompt:'输入模块名称'">
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<div id="operate_btn" class="tool_btn">
				<shiro:hasPermission name="add:moduleController:moduleList">
					<a href="javascript:void(0)" iconCls="icon-add" class="easyui-linkbutton" id="btn_module_add" plain="true" onclick="addModule();">新增模块</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:moduleController:moduleList">
					<a href="javascript:void(0)" iconCls="icon-edit" class="easyui-linkbutton" id="btn_module_update"  plain="true" onclick="modModule();">修改模块</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:moduleController:moduleList">
					<a href="javascript:void(0)" iconCls="icon-remove" class="easyui-linkbutton" id="btn_module_del"  plain="true" onclick="delModule();">删除模块</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="sort:moduleController:moduleList">
					<a href="javascript:void(0)" onclick="sortModule()" class="easyui-linkbutton" id="btn_module_sort" iconCls="icon-isc-sort" plain="true">模块排序</a>
				</shiro:hasPermission>
				<%--
				<shiro:hasPermission name="sort:moduleController:moduleList">
					<a href="javascript:void(0)" onclick="spreadModule()" class="easyui-linkbutton" id="btn_module_spread" iconCls="icon-cut" plain="true">一键展开</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="sort:moduleController:moduleList">
					<a href="javascript:void(0)" onclick="closeModule()" class="easyui-linkbutton" id="btn_module_close" iconCls="icon-no" plain="true">一键关闭</a>
				</shiro:hasPermission>
				--%>
			</div>
		</div>
			<!-- 模块列表树 -->
			<table class="easyui-treegrid" id="module_treegrid" data-options="
				idField:'id', method:'post', toolbar:'#toolBar', treeField:'text', striped:true, fit:true, fitColumns:true, singleSelect:true,
				selectOnCheck:true, checkOnSelect:true, rownumbers:true, nowrap:false">
			</table>
	</div>

	<!-- 新增模块弹框 -->
	<div id="addDialog" class="easyui-dialog" title="添加模块" closed="true" data-options="modal:true" style="width:500px;height:90%;padding:10px" buttons="#add-module-dlg-buttons">
		<form id="addForm" method="post" enctype="multipart/form-data">
			<input type="hidden" name="sysId" id="sys_id"/>
			<input type="hidden" name="modImg" id="modImg"/>
			<input type="hidden" name="modImgSmall" id="modImgSmall"/>
			<table cellpadding="3">
	    		<tr>
	    			<td >模块名称<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td ><input class="easyui-textbox" data-options="validType:['isBlank','unnormal','length[1,256]']" type="text" required="true" missingMessage="不能为空" name="modName" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td >表格名称：</td>
	    			<td ><input class="easyui-textbox" type="text" name="tableName" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>模块链接<span id="urlSpanAdd" style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td>
	    				<input class="easyui-textbox" data-options="validType:['isBlank','length[1,256]']" type="text" required="true" missingMessage="不能为空" name="modUrl" id="modurl" style="width:240px;"></input>
	    				<input type="checkbox" name="isBpm" id="isBpm" onclick="clearModUrlText('add');">应用模型</input>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>模块图标：</td>
	    			<td>
	    				<input class="easyui-textbox" data-options="validType:['length[1,256]']" type="text" name="modIcon" id="mod_icon_add" value="" style="width:230px;" ></input>
	    				<a href="javascript:void(0)" iconCls="icon-add" class="easyui-linkbutton" plain="true" onclick="openFunIconDialog('add');" style="width: 30px; height: 30px;"></a>
	    				<a href="javascript:void(0)" iconCls="icon-remove" class="easyui-linkbutton" plain="true" onclick="clearAddIconText();" style="width: 30px; height: 30px;"></a>
	    			</td>
	    		</tr>
				<tr>
					<td>父级节点：</td>
					<td>
						<select class="easyui-combotree" id="addCombobox" name="parentModId" style="width:300px;" data-options="valueField:'parentModId', textField:'text'">
						</select>
					</td>
				</tr>
		    		<tr>
		    			<td>是否封存：</td>
		    			<td>
		    				<input id="isSeal" class="easyui-switchbutton" onText="是" offText="否" checked>
					   		<span style="margin-left:74px">是否虚拟节点：</span>
					    	<input id="isVrtlNode" class="easyui-switchbutton" onText="是" offText="否" checked>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否审计：</td>
		    			<td>
		    				<input id="isAudi" class="easyui-switchbutton" onText="是" offText="否" checked>
					    	<span style="margin-left:74px">是否监控性能：</span>
					    	<input id="isContr" class="easyui-switchbutton" onText="是" offText="否" checked>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否展开：</td>
		    			<td>
		    				<input id="isExpand" class="easyui-switchbutton" onText="是" offText="否" checked>
					    </td>
		    		</tr>
		    		<tr>
		    			<td >模块大图：</td>
		    			<td >
							<input id="file1" name="file" class="easyui-filebox" style="width:300px;" data-options="prompt:'请选择一张图片...',onChange:fileOnchange" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >&nbsp;</td>
		    			<td colspan="2">
							<img id="picResImg1" width="300px" height="150px">
		    			</td>
		    		</tr>
		    		<tr style="display: none;">
		    			<td >模块小图：</td>
		    			<td >
							<input id="file1_s" name="file_s" class="easyui-filebox" style="width:300px;" data-options="prompt:'请选择一张图片...',onChange:fileOnchange" />
		    			</td>
		    		</tr>
		    		<tr style="display: none;">
		    			<td >&nbsp;</td>
		    			<td colspan="2">
							<img id="picResImg1_s" width="300px" height="150px">
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
	<div id="modifyDialog" class="easyui-dialog" title="修改模块" closed="true" data-options="modal:true" style="width:500px;height:90%;padding:10px" buttons="#modify-module-dlg-buttons">
		<form method="post" id="modifyForm" enctype="multipart/form-data">
			<input type="hidden" name="modId" id="mod_id"/>
			<input type="hidden" name="modImg" id="modImg"/>
			<input type="hidden" name="modImgSmall" id="modImgSmall"/>
			<table cellpadding="3">
	    		<tr>
	    			<td >模块名称<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td ><input class="easyui-textbox" data-options="validType:['isBlank','unnormal','length[1,256]']" type="text" required="true" missingMessage="不能为空" name="modName" id="mod_name" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td >表格名称：</td>
	    			<td ><input class="easyui-textbox" type="text" name="tableName" id="table_name" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>模块链接<span id="urlSpanModify" style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td>
	    				<input class="easyui-textbox" data-options="validType:['isBlank','length[1,256]']" type="text" required="true" missingMessage="不能为空" name="modUrl" id="mod_url" style="width:240px;"></input>
	    				<input type="checkbox" name="isBpm1" id="is_Bpm1" onclick="clearModUrlText('update');">应用模型</input>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>模块图标：</td>
	    			<td>
	    				<input class="easyui-textbox" data-options="validType:['length[1,256]']" type="text" name="modIcon" id="mod_icon" style="width:230px;" ></input>
	    				<a href="javascript:void(0)" iconCls="icon-add" class="easyui-linkbutton" plain="true" onclick="openFunIconDialog('update');" style="width: 30px; height: 30px;"></a>
	    				<a href="javascript:void(0)" iconCls="icon-remove" class="easyui-linkbutton" plain="true" onclick="clearEditIconText();" style="width: 30px; height: 30px;"></a>
	    			</td>
	    		</tr>
				<tr>
					<td>父级节点:</td>
					<td>
						<select class="easyui-combotree" id="modCombobox" name="parentModId" style="width:300px;" data-options="valueField:'parentModId', textField:'text'">
						</select>
					</td>
				</tr>
		    		<tr>
		    			<td>是否封存:</td>
		    			<td>
		    				<input id="isSeal0" class="easyui-switchbutton" onText="是" offText="否" checked>
					    	<span style="margin-left:84px">是否虚拟节点:</span>
					    	<input id="isVrtlNode0" class="easyui-switchbutton" onText="是" offText="否" checked>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否审计:</td>
		    			<td>
		    				<input id="isAudi0" class="easyui-switchbutton" onText="是" offText="否" checked>
					    	<span style="margin-left:84px">是否监控性能:</span>
					    	<input id="isContr0" class="easyui-switchbutton" onText="是" offText="否" checked>
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否展开：</td>
		    			<td>
		    				<input id="isExpand0" class="easyui-switchbutton" onText="是" offText="否" checked>
					    </td>
		    		</tr>
		    		<tr>
		    			<td >模块大图：</td>
		    			<td >
							<input id="file" name="file" class="easyui-filebox" style="width:300px;" data-options="prompt:'请选择一张图片...',onChange:fileOnchange" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >&nbsp;</td>
		    			<td colspan="2">
							<img id="picResImg" width="300px" height="150px">
		    			</td>
		    		</tr>
		    		<tr style="display: none;">
		    			<td >模块小图：</td>
		    			<td >
							<input id="file_s" name="file_s" class="easyui-filebox" style="width:300px;" data-options="prompt:'请选择一张图片...',onChange:fileOnchange" />
		    			</td>
		    		</tr>
		    		<tr style="display: none;">
		    			<td >&nbsp;</td>
		    			<td colspan="2">
							<img id="picResImg_s" width="300px" height="150px">
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
	    			<td ><input class="easyui-textbox" data-options="validType:['isBlank','unnormal','length[1,256]']" type="text" required="true" missingMessage="不能为空" name="resName" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>资源编码<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td><input class="easyui-textbox" data-options="validType:['isBlank','unnormal','length[1,128]']" type="text" required="true" missingMessage="不能为空" name="resCode" id="addCode" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>资源标识：</td>
	    			<td><input class="easyui-textbox" data-options="validType:['length[1,128]']" type="text" readonly="readonly" name="resUnId" id="addUnid" style="width:300px;"></input></td>
	    		</tr>
		    		<tr>
		    			<td>类型:</td>
		    			<td>
		    				<select class="easyui-combobox select_txt" style="width:300px;"  id="resType" name="resType" panelHeight="80" data-options="editable:false"></select>
					    	<!-- <input name="resType" value="0" type="radio" class="box" id="resType0" checked/>
					    	<label for="resType0">按钮</label>
	                		<input name="resType" value="1" type="radio" class="box" id="resType1" />
	                		<label for="resType1">文本框</label> -->
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否审计:</td>
		    			<td>
		    				<input id="isAudit" class="easyui-switchbutton" onText="是" offText="否" checked>
					    	<!-- <input name="isAudit" value="Y" type="radio" class="box" id="isAuditY" checked/>
					    	<label for="isAuditY">是</label>
	                		<input name="isAudit" value="N" type="radio" class="box" id="isAuditN" />
	                		<label for="isAuditN">否</label> -->
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否监控性能:</td>
		    			<td>
		    				<input id="isContro" class="easyui-switchbutton" onText="是" offText="否" checked>
					    	<!-- <input name="isContr" value="Y" type="radio" class="box" id="isControY" checked/>
					    	<label for="isControY">是</label>
	                		<input name="isContr" value="N" type="radio" class="box" id="isControN" />
	                		<label for="isControN">否</label> -->
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
			<input type="hidden" name="modId" id="res_mod_id"/>
			<table cellpadding="3">
	    		<tr>
	    			<td >资源名称<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td ><input class="easyui-textbox" data-options="validType:['isBlank','unnormal','length[1,256]']" type="text" required="true" missingMessage="不能为空" name="resName" id="res_name" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>资源编码<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td><input class="easyui-textbox" data-options="validType:['isBlank','unnormal','length[1,128]']" type="text" required="true" missingMessage="不能为空" name="resCode" id="res_code" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td>资源标识：</td>
	    			<td><input class="easyui-textbox" data-options="validType:['length[1,128]']" type="text" readonly="readonly" name="resUnId" id="res_unId" style="width:300px;"></input></td>
	    		</tr>
		    		<tr>
		    			<td>类型:</td>
		    			<td>
		    				<select class="easyui-combobox select_txt" style="width:300px;"  id="resType0" name="resType" panelHeight="80" data-options="editable:false"></select>
					    	<!-- <input name="resType" value="0" type="radio" class="box" id="resTypeMod0" checked/>
					    	<label for="resTypeMod0">按钮</label>
	                		<input name="resType" value="1" type="radio" class="box" id="resTypeMod1" />
	                		<label for="resTypeMod1">文本框</label> -->
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否审计:</td>
		    			<td>
		    				<input id="isAudit0" class="easyui-switchbutton" onText="是" offText="否" checked>
					    	<!-- <input name="isAudit" value="Y" type="radio" class="box" id="isAuditModY" checked/>
					    	<label for="isAuditModY">是</label>
	                		<input name="isAudit" value="N" type="radio" class="box" id="isAuditModN" />
	                		<label for="isAuditModN">否</label> -->
					    </td>
		    		</tr>
		    		<tr>
		    			<td>是否监控性能:</td>
		    			<td>
		    				<input id="isContro0" class="easyui-switchbutton" onText="是" offText="否" checked>
					    	<!-- <input name="isContr" value="Y" type="radio" class="box" id="isContrModY" checked/>
					    	<label for="isContrModY">是</label>
	                		<input name="isContr" value="N" type="radio" class="box" id="isContrModN" />
	                		<label for="isContrModN">否</label> -->
					    </td>
		    		</tr>
	    	</table>
    	</form>
    	<div id="modify-res-dlg-buttons" class="window-tool">
    		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="modifyResource()" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#modifyResDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>
	<!-- 图标选择 -->
	<div id="funIconDialog" class="easyui-dialog" title="图标选择" closed="true" data-options="modal:true" style="width:700px;height:450px;" >
		<iframe src="${ctx}/static/cap/font/index.html" frameborder="0" width="100%" height="100%" scrolling="yes" noresize="noresize"></iframe>
	</div>
		
	<!-- 业务流程解决方案选择窗口 -->
	<div id="bizSolDlg" style="overflow:hidden;" closed="true" data-options="maximizable:true,resizable:false,modal:true">
		<iframe scrolling="no" id="iframe" frameborder="0" border="0" marginwidth="0"
				marginheight="0" style="width:100%;height:100%;"></iframe>
	</div>
	
	<!-- 资源详情dialog  -->
	<div id="resDialog" class="easyui-dialog" closed="true" title="资源详情" data-options="modal:true" style="width:960px;height:460px;padding:10px"  buttons="#res-buttons">
		<div id="resBar" class="clearfix">
			<div id="operate_btn" class="tool_btn">
				<shiro:hasPermission name="addResc:moduleController:moduleList">
					<a href="javascript:void(0)" iconCls="icon-add" class="easyui-linkbutton" plain="true" onclick="addResource();">新增资源</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modifyResc:moduleController:moduleList">
					<a href="javascript:void(0)" iconCls="icon-edit" class="easyui-linkbutton" id="btn_res_edit" plain="true" onclick="modResource();">修改资源</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="deleteResc:moduleController:moduleList"> 
					<a href="javascript:void(0)" iconCls="icon-remove" class="easyui-linkbutton" id="btn_res_del" plain="true" onclick="delResource();">删除资源</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="genResc:moduleController:moduleList">
					<a href="javascript:void(0)" iconCls="icon-add" class="easyui-linkbutton"  plain="true" onclick="quickCreate();">生成增、删、改</a>
				</shiro:hasPermission>
			</div>
		</div>
		<!-- 资源列表 -->
		<table class="easyui-datagrid" id="resc_datagrid"></table>

		<div id="res-buttons" class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#resDialog').dialog('close')" plain="true">关闭</a>
		</div>
	</div>
	
	<!-- 排序dialog  -->
	<div id="sortDialog" class="easyui-dialog" closed="true" title="模块排序" data-options="modal:true" style="width:90%;height:460px;padding:10px"  buttons="#sort-buttons">
		<!-- 模块列表 -->
		<table class="easyui-treegrid" id="tg" data-options="
				idField:'id', method:'post', treeField:'text', striped:true, fit:true, fitColumns:true, singleSelect:true,
				rownumbers:true, nowrap:false,onClickRow:onClickRow">
			<thead>
				<tr>
		          <th data-options="field:'ck', checkbox:false"></th>
		          <th data-options="field:'text',title : '模块名称', width : 200,align : 'left'"></th>
		          <th data-options="field:'url',title : '模块链接', width : 260,align : 'left'"></th>
		          <th data-options="field:'isSeal', title : '封存',  width : 50, align : 'left', formatter : formatIsSeal"></th>
		          <th data-options="field:'isVrtlNode', title : '虚拟节点',  width : 60, align : 'left', formatter : formatIsVrtlNode"></th>
		          <th data-options="field : 'sort', title : '排序号', width : 80, align : 'center',formatter:formaterModuleSort"></th>
				</tr>
			</thead>
		</table>

		<div id="sort-buttons" class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveSort()" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#sortDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>
	
	<script type="text/javascript">
	    // 操作类型add：新增  update：修改
		var opertTtype = "";

		/**
		 * 关闭图标选择框
		 */
		function closeFunIconDialog(){
			$('#funIconDialog').dialog('close');
		}

		/**
		 * 打开图标选择框
		 */
		function openFunIconDialog(type) {
			opertTtype = type;
			$('#funIconDialog').dialog('open');
		}
		
		/**
		 * 清空增加图标框内容
		 */
		function clearAddIconText() {
			$('#mod_icon_add').textbox('setValue', "");
		}
		
		/**
		 * 清空修改图标框内容
		 */
		function clearEditIconText() {
			$('#mod_icon').textbox('setValue', "");
		}
		
		/**
		 * 清空模块链接框内容
		 */
		function clearModUrlText(value) {
			if(value == "add"){
				if(document.getElementById("isBpm").checked){
					/* $('#modurl').textbox('setValue', ""); */
					$('#modurl').textbox('textbox').attr('readonly',true);
					$("input",$("#modurl").next("span")).attr("onclick","selectBizSol('modurl');");
				}else{
					$('#modurl').textbox('textbox').attr('readonly',false);
					$("input",$("#modurl").next("span")).attr("onclick","");
				}
			}
			if(value == "update"){
				if(document.getElementById("is_Bpm").checked){
					/* $('#mod_url').textbox('setValue', ""); */
					$('#mod_url').textbox('textbox').attr('readonly',true);
					$("input",$("#mod_url").next("span")).attr("onclick","selectBizSol('mod_url');");
				}else{
					$('#mod_url').textbox('textbox').attr('readonly',false);
					$("input",$("#mod_url").next("span")).attr("onclick","");
				}
			
			}
			
		}
		
		/**
		 * 设置模块图标
		 */
		function setFunIcon(val){
			// 如果当前选择的系统支撑平台则图标样式为：[iconfont icon-ht icon-***]
			if (sysRegId == "8a81595755e20ec90155e23258e5000a") {
				val = "iconfont icon-ht " + val;
			} else { // 其他系统图标样式为：[iconfont icon-***]
				val = "iconfont " + val
			}

			if (opertTtype == "add") {
				$('#mod_icon_add').textbox('setValue', val);
			}
			if (opertTtype == "update") {
				$('#mod_icon').textbox('setValue', val);
			}
		}
	</script>
</body>
</html>