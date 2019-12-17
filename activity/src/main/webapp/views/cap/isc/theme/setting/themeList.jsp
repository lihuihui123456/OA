<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>主题管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/setting/js/themeList.js"></script>
	
	<script type="text/javascript">
		var path = '${ctx}';
	</script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<input type="hidden" id="typeId">
	<!-- 左侧主题类型区域 -->
	<%--
	<div data-options="region:'west',split:true,collapsible:false" style="width: 200px;" class="page_menu">
		<div class="search-tree">
			<input id="type_search" class="easyui-searchbox" data-options="searcher:typeTreeSearch,prompt:'输入主题类型'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<!-- 左侧主题类型树 -->
			<ul class="easyui-tree" id="tree"></ul>
		</div>
	</div>
	--%>
	<!-- 主题类型右键菜单 -->
	<div id="mm" class="easyui-menu" style="width: 130px;">
		<div onclick="addNote()">新增主题类型</div>
		<div onclick="modNote()">修改主题类型</div>
		<div onclick="delNote()">删除主题类型</div>
	</div>
	
	<div data-options="region:'center'" class="content">
		<!-- 工具栏 -->
		<div id="toolBar" class="clearfix">
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:themeController:themeList">
					<a href="javascript:void(0)" onclick="openForm('新增系统主题信息')" id="btn_add" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:themeController:themeList">
					<a href="javascript:void(0)" onclick="openUpdateForm('修改系统主题信息')" id="btn_edit" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:themeController:themeList">
					<a href="javascript:void(0)" onclick="doDeleteTheme()" class="easyui-linkbutton" id="btn_del" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission> 
				
				<shiro:hasPermission name="role:themeTypeController:themeList">
					<a href="javascript:void(0)" onclick="openRole()" class="easyui-linkbutton" id="btn_role" iconCls="icon-isc-fpjs" plain="true">关联角色</a>
				</shiro:hasPermission> 
				<%-- <shiro:hasPermission name="themeSetting:themeTypeController:themeList">
					<a href="javascript:void(0)" onclick="setTheme()" class="easyui-linkbutton" id="btn_set" iconCls="icon-isc-fpjs" plain="true">主题设置</a>
				</shiro:hasPermission>  --%>
				<shiro:hasPermission name="themePreview:themeTypeController:themeList">
					<a href="javascript:void(0)" onclick="viewTheme()" class="easyui-linkbutton" id="btn_view" iconCls="icon-isc-fpjs" plain="true">主题预览</a>
				</shiro:hasPermission> 
			</div>
			<div class="search-input">
				<input id="theme_name" class="easyui-searchbox" data-options="searcher:searchList,prompt:'输入主题名称'" />
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
		</div>
		<!-- 系统主题列表 -->
		<table class="easyui-datagrid" id="themeList"></table>
	</div>
	<!-- 系统主题Form表单 -->
	<div id="themeDialog" class="easyui-dialog"  closed="true" data-options="modal:true" style="width:510px;height:445px;" buttons="#dlg-buttons">
		<div class="easyui-panel window-body" style="height: 100%;">
			<form id="themeForm" method="post" class="window-form" enctype="multipart/form-data">
				<input type="hidden" id="themeId" name="themeId" />
				<input type="hidden" id="themePic" name="themePic" />
				<table cellpadding="3" class="form-table">
		    		<tr>
		    			<td>主题名称<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,256]']" required="true" missingMessage="不能为空" id="themeName" name="themeName" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >主题编码<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td >
		    				<input class="easyui-textbox" data-options="validType:['isBlank','unnormal','length[1,128]']" required="true" missingMessage="不能为空" type="text" id="themeCode" name="themeCode" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >主题URL<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td >
		    				<input class="easyui-textbox" data-options="validType:['isBlank','length[1,1024]','modUrl']" required="true" missingMessage="不能为空" type="text" id="themeUrl" name="themeUrl" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >主题预览URL<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td >
		    				<input class="easyui-textbox" data-options="validType:['isBlank','length[1,1024]','modUrl']" required="true" missingMessage="不能为空" type="text" id="viewUrl" name="viewUrl" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<!-- <tr>
		    			<td >主题类型：</td>
		    			<td >
		    				<input class="easyui-textbox" disabled required="true" missingMessage="不能为空" type="text" id="themeType" name="themeType" style="width:300px;" />
		    			</td>
		    		</tr> -->
		    		<tr>
		    			<td >状态：</td>
		    			<td >
		    				<input id="is_valid" class="easyui-switchbutton" onText="启用" offText="禁用" checked />
		    				<span style="margin-left:100px">默认主题：</span>
		    				<input id="isDefault" class="easyui-switchbutton" onText="是" offText="否" unchecked />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >主题图片<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td >
							<input id="file" name="file" class="easyui-filebox" style="width:85%" data-options="prompt:'请选择一张图片...',onChange:fileOnchange" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td colspan="3">
							<img id="picResImg" width="350px" height="200px">
		    			</td>
		    		</tr>
		    	</table>
			</form>
		</div>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveTheme()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#themeDialog').dialog('close')" plain="true">取消</a>
	</div>

	<!-- 主题类型表单 -->
	<div id="themeTypeDialog" class="easyui-dialog" title="新增主题类型" data-options="modal:true" closed="true" style="width:460px;height:305px;" buttons="#themeType-buttons">
		<form action="" id="typeForm">
			<input type="hidden" id="themeTypeId" name="themeTypeId">
			<table cellpadding="3">
				<tr>
					<td>主题类型名称<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td>
						<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,256]']" required="true" missingMessage="不能为空" id="themeTypeName" name="themeTypeName" style="width:300px;" />
					</td>
				</tr>
				<tr>
					<td>主题类型标识<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td>
						<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,128]']" required="true" missingMessage="不能为空" id="themeTypeCode" name="themeTypeCode" style="width:300px;">
					</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;是否生效:</td>
					<td>
						<input id="isValid" class="easyui-switchbutton" onText="是" offText="否" checked />
					</td>
				</tr>
			</table>
		</form>
	</div>
	<!-- 字典类型表单按钮 -->
	<div id="themeType-buttons"  class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="savetype()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#themeTypeDialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 分配角色dialog  -->
	<div id="roleDialog" class="easyui-dialog" closed="true" title="关联角色" data-options="modal:true" style="width:850px;height:460px;padding:10px"  buttons="#role-buttons">
		<div class="easyui-layout" style="width: 800px; height: 340px;"> 
			
			<div data-options="region:'west',split:true,collapsible:false" title="选择单位" style="width: 250px;">
				<!-- 单位树 -->
				<ul class="easyui-tree" id="org_tree" ></ul>
			</div>
			
			<div data-options="region:'center'">
				<div class="usable_role" style="height:330px;margin-left:30px;width:200px">
				
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
				<div class="selected_role" style="height:330px;width:200px">
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
					<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveRole('close')" plain="true">保存并关闭</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#roleDialog').dialog('close')" plain="true">取消</a>
				</div>
			</div>
		</div>
	</div>
	<!-- 分配角色dialog END -->
	
	<!-- 主题设置dialog  -->
	<div id="setThemeDialog" class="easyui-dialog" closed="true" title="主题设置" data-options="modal:true" style="width:850px;height:460px;padding:10px"  buttons="#setTheme-buttons">
		<div class="easyui-layout" style="width: 800px; height: 340px;"> 
			<iframe id="themeFrame" height="340" width="800" frameborder=0 scrolling=no
				allowTransparency="true"> </iframe>
			
		</div>
	</div>
	<div id="setTheme-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#setThemeDialog').dialog('close')" plain="true">取消</a>
	</div>
	<!-- 分配角色dialog END -->
</body>
</html>