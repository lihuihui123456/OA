<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>数据权限设置</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/dataauth/authset/js/authSetList.js"></script>
	
</head>

<body class="easyui-layout" style="width: 100%; height: 98%;"> 
	<div data-options="region:'west',split:true,collapsible:false" class="page_menu">
		<!-- 单位部门树 -->
		<div class="search-tree">
			<input id="org_search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入单位名称'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<ul class="easyui-tree" id="org_dept_tree" ></ul>
		</div>
	</div>
	
	<div data-options="region:'center',iconCls:'icon-ok'" class="content">
		<div id="toolBar" class="clearfix">
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入登录帐号或真实姓名'">
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="refRole:authSetController:authSetList">
					<a href="javascript:void(0)" onclick="openRoleDlg()" id="btn_role" class="easyui-linkbutton" iconCls="icon-isc-fpjs" plain="true">分配数据角色</a>
				</shiro:hasPermission>
			</div>
		</div>

		<!-- 用户列表 -->
		<table class="easyui-datagrid" id="userList"></table>
	</div>
	
	<!-- 关联数据角色dialog  -->
	<div id="roleDialog" class="easyui-dialog" closed="true" title="分配数据角色" data-options="modal:true" style="width:90%;height:460px;padding:10px"  buttons="#role-buttons">
		<!-- 分配角色列表 -->
		<div class="usable_role" style="height:330px;width:38%;margin-left: 5%">
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
		<div class="selected_role" style="height:330px;width:38%">
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
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#roleDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>
	<!-- 分配角色dialog END -->
	
	<!-- 查看数据规则 -->
	<div id="ruleDialog" class="easyui-dialog" title="查看数据规则" closed="true" data-options="modal:true" style="width:900px;height:455px;padding:10px" buttons="#dlg-buttons">
		
		<iframe frameborder="0" name="ruleFrame" id="ruleFrame"
			width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
		<!-- <table class="excel table table-striped table-bordered tablepic" id="tb" width="100%" height="60%" border="1px" cellspacing="0px" style="border-collapse:collapse">
    		<tr>
    			<td style="width:25%;text-align:center;">角色描述</td>
    			<td>
    				asdasd
    			</td>
    		</tr>
    	</table> -->
    	
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#ruleDialog').dialog('close')" plain="true">关闭</a>
	</div>
</body>
</html>