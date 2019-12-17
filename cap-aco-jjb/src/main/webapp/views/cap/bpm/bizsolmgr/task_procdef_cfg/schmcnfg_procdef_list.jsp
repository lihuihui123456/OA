<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>流程定义选择页</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" style="width:100%;height:98%">
	<!-- 页面布局西部 -->
	<div data-options="region:'west',split:false" title="流程定义类别" style="width:200px;">
		<!-- 流程定义类别树 -->
		<ul class="easyui-tree" id="procdsgnCtlgTree"></ul>
	</div>
	
	<!-- 页面布局中部 -->
	<div data-options="region:'center',title:'流程定义'">
		<!-- 列表工具栏 -->
		<div id="toolbar" style="padding: 5px; height: auto">
			<div style="padding:3px">
				<span>标题：</span>
				<input class="easyui-textbox" id="name" style="width:150px;">
				<span>标识key：</span>
				<input class="easyui-textbox" id="key" style="width:150px;">
				<a href="javascript:void(0)" onclick="searchData()" data-options="iconCls:'icon-search'"
				class="easyui-linkbutton" plain="true">查询</a>
				<a href="javascript:void(0)" onclick="reloadTableData()"
				class="easyui-linkbutton" plain="true">清空查询</a>
			</div>
		</div>
		<!-- 流程定义列表 -->
		<table class="easyui-datagrid" id="procdsgnList" ></table>
	</div>
	
	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<span> 
				<a href="javascript:void(0)" onclick="doSave()"
					class="easyui-linkbutton" plain="true">保存</a>
			</span> 
			<span> 
				<a href="javascript:void(0)" onclick="closeDialog()" 
					class="easyui-linkbutton" plain="true">关闭</a>
			</span>
		</div>
	</div>
</body>
<script type="text/javascript">
$(function() {
	InitTreeData();
});

/**
 * 流程定义分类ID
 */
var procdsgnCtlgId = '';
function InitTreeData() {
	$('#procdsgnCtlgTree').tree({
		url : "${ctx}/procDefController/findProcDefCategory",
		animate : true, //开启折叠动画
		onLoadSuccess : function(node,data){
			if(data[0].children !=null ){
				var target = data[0].children[0];//获取根节点下的第一个节点
				if( target != null ) {
					procdsgnCtlgId = target.id;
					$("#procdsgnCtlgTree").tree("select", target);//相当于默认点击了一下该节点，执行onSelect方法   
					$("#procdsgnCtlgTree li:eq('1')").find("div").eq('0').addClass("tree-node-selected");//设置该树第一个子点高亮   
				}
			}
			InitTableData();
		},
		//单击事件
		onClick : function(node, data) {
			procdsgnCtlgId = node.id
			reloadTableData();
		}
	});
}



/**
 * 加载流程设计列表
 */
function InitTableData() {
	$('#procdsgnList').datagrid({
		url : "${ctx}/procDefController/findMainProcDefbyCategoryId",
		queryParams: {
			"categoryId" : procdsgnCtlgId,
			"name" : '',
			"key" : ''
		},
		method : 'post',
		idField : 'id',
		striped : true,
		fitColumns : true,
		fit:true,
		singleSelect : true,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolbar',
		pageSize : 10,
		showFooter : true,
		frozenColumns:[[    
				{ field : 'ck', checkbox : true }, 
				{ field : 'procdefId_', hidden : true}, 
				{ field : 'deploymentId_', hidden : true}, 
				{ field : 'modelId_', hidden:true}, 
				{field  : 'id',width:40,align : 'center', title : '操作',
					formatter: function(value,row,index){
						return '<table border="0" width="100%"><tr>'
								+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/bizsolmgr/img/detail.png"  title="明细" onclick="imgClick(\''+index+'\',\'detial\')"/></td>'
							+'</tr></table>';
					}
				}
            ]],
		columns : [[ 
		    { field : 'name_', title : '标题', width : 200, align : 'left' }, 
		    { field : 'key_', title : '标识Key', width : 80, align : 'center' }, 
		    { field : 'state_', title : '状态', width : 50, align : 'center',
		    	formatter: function(value,row,index){
		    		return "已部署"
		    	}
		    }, 
		    { field : 'version_', title : '版本', width : 50, align : 'left' }
		]]
	});
}

/**
 * 重新加载流程设计列表数据
 */
function reloadTableData() {
	$('#name').textbox("setValue",'');
	$('#key').textbox("setValue",'');
	$('#procdsgnList').datagrid('reload', {
		"categoryId" : procdsgnCtlgId,
		"name" : '',
		"key" : ''
	});
	$('#procdsgnList').datagrid('clearSelections'); //清空选中的行
}

/**
 * 操作单元格图标点击事件
 * @param index 所点击的图标所在行索引
 * @param action 动作标识 detial： 打开明细弹窗 update:打开修改弹窗 
 * 				 	   delete：执行删除操作
 */
function imgClick(index, action){
	$('#procdsgnList').datagrid('clearSelections'); //清空选中的行
	$('#procdsgnList').datagrid('selectRow', index); //根据行索引选中一行
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	if(action == 'detial'){
		detail();
	}
}

/**
 * 打开明细弹窗
 */
function detail(){
	var data = $('#procdsgnList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('查看流程设计管理明细', '请选择单行记录查看！');
			return;
		}
		var modelExtId = data[0].id;
		var deploymentId = data[0].deploymentId_;
		window.parent.$("#iframe_").attr('src', "${ctx}/procDefController/toProcDefDetialPage?divId=dialog_&divId=procdsgnDlg_&modelExtId="+modelExtId+"&deploymentId="+deploymentId);
		window.parent.$("#dialog_").dialog({    
		    title: '流程流程定义明细信息',
		    width: 850,
		    height: 470,
		    closed: false,
			cache: false,
			modal: true,
			onResize: function() {
				window.parent.$(this).dialog('center');
			}
		}); 
	}
}

function doSave(){
	var data = $('#procdsgnList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('查看流程设计管理明细', '请选择单行记录查看！');
			return;
		}
		var procdefId = data[0].procdefId_;
		var id = '${id}';
		var procdefId = data[0].procdefId_;
		$.ajax({
			url : "${ctx}/bizSolMgr/doUpdateProcdefId",
			type : 'post',
			dataType : 'text',
			data : {
				'id' : id,
				'procdefId' : procdefId
			},
			success : function(data){
				if(data == 'Y'){
					window.parent.closeDialog('dialog');
					window.parent.$.messager.show({title:'提示',msg:'选择成功！',timeout:2000,});
					window.parent.updateProcDefId(procdefId);
				}else{
					window.parent.$.messager.show({title:'提示',msg:'选择失败！',timeout:2000,});
				}
			}
		});
	}
}

/**
 * 列表搜索方法
 */
function searchData(){
	var name = $('#name').val();//搜索字段
	var key = $('#key').val();//搜索条件
	
	$('#procdsgnList').datagrid('reload', {
		"categoryId" : procdsgnCtlgId,
		"name" : name,
		"key" : key
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