<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>业务表单选择页</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" style="width:100%;height:100%">
	<!-- 页面布局西部 -->
	<div data-options="region:'west',split:true" title="业务应用类别" style="width:200px;">
		<!-- 业务表单类别树 -->
		<ul class="easyui-tree" id="formCtlgTree"></ul>
	</div>

	<!-- 页面布局中部 -->
	<div data-options="region:'center',title:'业务表单'">
		<!-- 列表工具栏 -->
		<div id="toolbar" style="padding: 5px; height: auto">
			<div style="padding:3px">
				<span>名称：</span>
				<input class="easyui-textbox" id="name" style="width:150px;">
				<span>标识键：</span>
				<input class="easyui-textbox" id="key" style="width:150px;">
				<a href="javascript:void(0)" onclick="searchData()" data-options="iconCls:'icon-search'"
				class="easyui-linkbutton" plain="true">查询</a>
				<a href="javascript:void(0)" onclick="reloadTableData()"
				class="easyui-linkbutton" plain="true">清空查询</a>
			</div>
		</div>
		<!--业务表单列表 -->
		<table class="easyui-datagrid" id="formList" 
			data-options="idField:'id',toolbar:'#toolbar',striped:true,singleSelect:true,
						  fitColumns:true,fit:true,rownumbers:true,
						  pagination:true, nowrap:false,
						  showFooter:true,nowrap:false">
			<thead>
				<tr>
					<th data-options="field :'ck',checkbox:true"></th>
					<th data-options="field:'formName_',width:100">名称</th>
					<th data-options="field:'key_',width:100,align:'left'">标志键</th>
				</tr>
			</thead>
		</table>
	</div>
	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<a href="javascript:void(0)" onclick="doSave()"
				class="easyui-linkbutton" plain="true">确定</a>
			<a href="javascript:void(0)"
				onclick="closeDialog()" class="easyui-linkbutton" plain="true">关闭</a>
		</div>
	</div>
</body>
<script type="text/javascript">
$(function() {
	InitTreeData();
});

/**
 * 流
 */
var formCtlgId = '';
function InitTreeData() {
	$('#formCtlgTree').tree({
		url : '${ctx}/formDesignController/formCtlgTree',
		animate : true, //开启折叠动画
		onLoadSuccess : function(node,data){
			if(data[0].children !=null ){
				var target = data[0].children[0];//获取根节点下的第一个节点
				if( target != null ) {
					formCtlgId = target.id;
					$("#formCtlgTree").tree("select", target);//相当于默认点击了一下该节点，执行onSelect方法   
					$("#formCtlgTree li:eq('1')").find("div").eq('0').addClass("tree-node-selected");//设置该树第一个子点高亮   
				}
			}
			InitTableData();
		},
		//单击事件
		onClick : function(node, data) {
			formCtlgId = node.id
			reloadTableData();
		}
	});
}



/**
 * 加载流程设计列表
 */
function InitTableData() {
	$('#formList').datagrid({
		url : '${ctx}/formDesignController/findPublishedBpmReFormEntity',
		queryParams: {
			'formCtlgId':formCtlgId,
			'name': '',
			'key' : ''
		},
		pageSize : 10,
	});
}

/**
 * 重新加载流程设计列表数据
 */
function reloadTableData() {
	$('#name').textbox("setValue",'');
	$('#key').textbox("setValue",'');
	$('#formList').datagrid('reload', {
		'formCtlgId':formCtlgId,
		'name': '',
		'key' : ''
	});
	$('#formList').datagrid('clearSelections'); //清空选中的行
}


function doSave(){
	var data = $('#formList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('查看流程设计管理明细', '请选择单行记录查看！');
			return;
		}
		var index = '${index}';
		var iframe = parent.window.document.getElementById('apprform').contentWindow;
		var row = iframe.$('#formList').datagrid('getData').rows[index];
		row.formId_ = data[0].id;
		row.formName_ = data[0].formName_;
		row.formKey_ = data[0].key_;
		window.parent.closeDialog('dialog');
		iframe.updateRow(index,row);
		//window.parent.$.messager.show({title:'提示',msg:'选择成功！',timeout:2000,});
		iframe.saveData();
	}
}


/**
 * 列表搜索方法
 */
function searchData(){
	var searchValue  = $('#searchValue').val();//搜索值
	var name = $('#name').val();//搜索字段
	var key = $('#key').val();//搜索条件
	
	$('#formList').datagrid('reload', {
		'formCtlgId':formCtlgId,
		'name': name,
		'key' : key
	});
}

/**
 * 关闭弹出的dialog
 */
function closeDialog(){
	window.parent.closeDialog('dialog');
}



</script>
</html>