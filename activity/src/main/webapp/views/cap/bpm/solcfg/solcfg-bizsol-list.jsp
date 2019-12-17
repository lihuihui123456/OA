<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>业务流程解决方案管理首页</title>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/easyui-lang-zh_CN.js"></script>
</head>
<script type="text/javascript">
var modelId = '${modelId}';
$(function() {
	InitTreeData();
});
/**
 * 业务解决方案类别Id
 * 用途：
 * 1、页面初始化时加载列表数据
 * 2、点击树节点加载对应类别下的列表数据
 * 3、点击新增/复制新增时 默认所属类别
 */ 
var bizSolCtlgId = '';
/**
 * 加载业务解决方案类别树
 */
function InitTreeData() {
	$('#bizSolCtlgTree').tree({
		url : '../bizSolMgr/findCtlgTree',
		animate : true, //开启折叠动画
		//树加载成功后回调函数（用于初始化列表）
		onLoadSuccess : function(node,data){
			if(data[0].children !=null ){
				var target = data[0].children[0];//获取根节点下的第一个节点
				if( target != null ) {
					//给 业务解决方案类别Id 赋值
					bizSolCtlgId = target.id;
					$("#bizSolCtlgTree").tree("select", target);//相当于默认点击了一下该节点，执行onSelect方法   
					$("#bizSolCtlgTree li:eq('1')").find("div").eq('0').addClass("tree-node-selected");//设置该树第一个子点高亮   
				}
			}
			// 初始化列表
			InitTableData();
		},
		//单击事件（用于加载列表数据）
		onClick : function(node, data) {
			//给 业务解决方案类别Id 赋值
			bizSolCtlgId = node.id;
			//重新加载列表数据
			reloadTableData();
		}
	});
}


var action;

/**
 * 加载流程定义列表
 */
function InitTableData() {
	$('#bizSolInfoList').datagrid({
		url : '../bizSolMgr/findBizSolInfoIdByCtlgId',
		queryParams: {
			'bizSolCtlgId': bizSolCtlgId,
			'searchValue' : '',
			'zd' : '',
			'tj' : ''
		},
		pageSize : 10
	});
}

/**
 * 列表搜索方法
 */
function searchData(){
	var searchValue  = $('#searchValue').val();//搜索值
	var zd = $('#zd').combobox('getValue');//搜索字段
	var tj = $('#tj').combobox('getValue');//搜索条件
	
	$('#bizSolInfoList').datagrid('reload', {
		'bizSolCtlgId': bizSolCtlgId,
		'searchValue' : searchValue,
		'zd' : zd,
		'tj' : tj
	});
}

/**
 * 重新加载流程定义列表数据
 */
function reloadTableData() {
	$('#zd').combobox('setValues',"");//搜索字段
	$('#tj').combobox('setValues',"");//搜索条件
	$('#searchValue').textbox("setValue",'');
	$('#bizSolInfoList').datagrid('reload', {
		'bizSolCtlgId': bizSolCtlgId,
		'searchValue' : '',
		'zd' : '',
		'tj' : ''
	});
	$('#bizSolInfoList').datagrid('clearSelections'); //清空选中的行
}

/**
 * 操作单元格图标点击事件
 * @param index 所点击的图标所在行索引
 * @param action 动作标识 detial： 打开明细弹窗 update:打开修改弹窗 
 * 				 	   delete：执行删除操作
 */
function imgClick(index, action){
	$('#bizSolInfoList').datagrid('clearSelections'); //清空选中的行
	$('#bizSolInfoList').datagrid('selectRow', index); //根据行索引选中一行
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	if(action == 'detial'){
		detail();
	}
}

/**
 * 打开明细弹窗
 */
function detail(){
	var data = $('#bizSolInfoList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('提示', '请选择单行记录查看！', 'info');
			return;
		}
		var id = data[0].id;
		var src = 'bizSolMgr/viewBizSolDetial?id='+id;
		$('#iframe').attr('src', src);
		$('#bizSolInfoDlg').dialog({    
		    title: '业务流程解决方案明细',
		    width: 750,
		    height: 400,
		    cache: false
		}); 
		$('#bizSolInfoDlg').dialog('open');
	}
}

function doSave(){
	var data = $('#bizSolInfoList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('提示', '请选择单行记录查看！', 'info');
			return;
		}
		var solId = data[0].id;
		$.ajax({
			url : '../solutionCfgController/updateModelUrl',
			type : 'post',
			dataType : 'text',
			data : {
				'modelId' : modelId,
				'solId' : solId
			},
			success : function(data){
				if(data == 1){
					closeDialog();
					window.parent.$.messager.show({
						title:'提示',
						msg:'选择成功',
						timeout:2000,
					});
					window.parent.reload();
				}
			}
		});
	}
}


/**
 * 关闭弹出的dialog
 */
function closeDialog(){
	window.parent.$('#bizSolDlg').dialog('close');
}



function formatterOpert (val, row, index){
	return '<table border="0" width="100%"><tr>'
			+'<td><img style="cursor:pointer" src="../views/bpm/bizsolmgr/img/detail.png"  title="明细" onclick="imgClick(\''+index+'\',\'detial\')"/></td>'
			+'</tr></table>';
}

function formatterTime (value, row, index) {
	return value.substr(0,19);
}

</script>
<body class="easyui-layout" style="width:100%;height:100%">
	<!-- 页面布局西部 -->
	<div data-options="region:'west',split:true" title="业务解决方案类别" style="width:200px;">
		<!-- 业务解决方案类别 -->
		<ul class="easyui-tree" id="bizSolCtlgTree"></ul>
	</div>
	
	<!-- 页面布局中部 -->
	<div data-options="region:'center',title:'业务流程解决方案'">
		<!-- 列表工具栏 -->
		<div id="toolbar" style="padding: 5px; height: auto">
		<!-- 	<div style="padding:3px">
				<span>请选择查询字段：</span>
				<select class="easyui-combobox" id="zd" value="" data-options="editable:false,panelHeight:'auto',width:200">
					<option value="">请选择</option>
					<option value="solName_">业务解决方案名称</option>
					<option value="key_">标志key</option>
				</select>
				<select class="easyui-combobox" id="tj" value="" data-options="editable:false,panelHeight:'auto',width:200">
					<option value="">请选择</option>
					<option value="equal">等于</option>
					<option value="fuzzy">模糊匹配</option>
					<option value="left_fuzzy">左模糊匹配</option>
					<option value="right_fuzzy">右模糊匹配</option>
				</select>
				<input class="easyui-textbox" id="searchValue"  >
				<a href="javascript:void(0)" onclick="searchData()"
				class="easyui-linkbutton" plain="true">搜索</a>
				<a href="javascript:void(0)" onclick="reloadTableData()"
				class="easyui-linkbutton" plain="true">清空搜索</a>
			</div> -->
		</div>
		<!-- 流程定义列表 -->
		<table class="easyui-datagrid" id="bizSolInfoList"
			data-options="idField:'id',toolbar:'#toolbar',striped:true,singleSelect:true,fitColumns:true,fit:true,rownumbers:true,pagination:true,nowrap:false,showFooter:true,nowrap:false">
			<thead>
				<tr>
					<th data-options="field :'ck',checkbox:true"></th>
					<th data-options="field :'procDefId_',hidden:true"></th>
					<th data-options="field:'solName_',width:100">解决方案名称</th>
					<th data-options="field:'key_',width:100,align:'left'">标志键</th>
					<th data-options="field:'state_',width:100,align:'left'">状态</th>
					<th data-options="field:'createTime_',width:100,align:'left',formatter:formatterTime">创建时间</th>
				</tr>
			</thead>
		</table>
	</div>
	<div data-options="region:'south'" style="height:50px;">
		<div align="center" style="margin-top: 10px">
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
</html>