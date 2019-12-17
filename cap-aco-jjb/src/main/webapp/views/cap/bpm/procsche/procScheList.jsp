<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>业务应用类别管理</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
<div data-options="region:'west',split:false" title="业务应用类别" style="width:200px;">
	<!-- 业务应用类别 -->
	<ul class="easyui-tree" id="bizSolCtlgTree">
	</ul>
	<!-- 业务应用类别右击菜单  -->
	 <div id="bizSolCtlgMenu" class="easyui-menu" style="width:120px;">
		<div id="addMenu" onclick="addBizSolCtlg('child')" data-options="iconCls:'icon-add'">添加类别</div>
		<div id="editMenu" onclick="editBizSolCtlg()" data-options="iconCls:'icon-edit'">编辑类别</div>
		<div id="delMenu" onclick="delBizSolCtlg()" data-options="iconCls:'icon-remove'">删除类别</div>
	</div>
	<!-- 流程定义类别新增/修改窗口 -->
	<div id="bizSolCtlgDlg" class="easyui-dialog" title="" closed="true" data-options="modal:true" style="width:400px;height:52%;padding:10px" buttons="#add-module-dlg-buttons">
		<form id="bizSolCtlg">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="parentId_" name="parentId_">
			<input type="hidden" id="treeType_" name="treeType_">
			<input type="hidden" id="sort_" name="sort_">
			<input type="hidden" id="createUserId_" name="createUserId_">
			<input type="hidden" id="createTime_" name="createTime_">
			<input type="hidden" id="updateUserId_" name="updateUserId_">
			<input type="hidden" id="updateTime_" name="updateTime_">
			<input type="hidden" id="ts_" name="ts_">
			<input type="hidden" id="dr_" name="dr_">
			<input type="hidden" id="remark_" name="remark_">
			<input type="hidden" name="code" id="code"/>
			<table cellpadding="3">
	    		<tr>
	    			<td >名称<span style="color:red;vertical-align:middle;">*</span>：</td>
	    			<td ><input class="easyui-textbox" data-options="validType:['isBlank','unnormal','length[1,256]']" type="text" required="true" missingMessage="不能为空" id="solCtlgName_" name="solCtlgName_" style="width:300px;"></input></td>
	    		</tr>
	    		<tr>
	    			<td >描述：</td>
	    			<td ><input class="easyui-textbox" type="text" id="desc_" name="desc_" data-options="multiline:true" style="height:120px;width:300px;"></input></td>
	    		</tr>
	    	</table>
		</form>
		<div id="add-module-dlg-buttons" class="window-tool">
    		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveBizSolCtlg();" plain="true">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#bizSolCtlgDlg').dialog('close');" plain="true">取消</a>
		</div>
	</div>
</div>
<!-- 页面布局中部 -->
<div data-options="region:'center',title:'业务应用'"  style="padding:5px;">
<!-- 列表工具栏 -->
<div id="toolbar" style="height: 45px">
	<div class="search-input">
		<input id="search" class="easyui-searchbox" data-options="searcher:findByModuleName,prompt:'输入名称查询'">
		<span class="clear" onclick="clearSearchBox()"></span>
	</div>
	<div id="operate_btn" >				
		<a href="javascript:void(0)" iconCls="icon-add" class="easyui-linkbutton" id="btn_add" plain="true" onclick="addProcSch();">新增</a>			
		<a href="javascript:void(0)" iconCls="icon-edit" class="easyui-linkbutton" id="btn_edit" plain="true" onclick="modProcSch();">修改</a>			
		<a href="javascript:void(0)" iconCls="icon-remove" class="easyui-linkbutton" id="btn_del" plain="true" onclick="delProcSch();">删除</a>		
	</div>
</div>
	  <table class="easyui-datagrid" id="dtlist" data-options="
				idField:'id',treeField : 'id',method:'post', fit: true,striped : true,fitColumns : true,singleSelect : true,rownumbers : true,
				 pagination : true,nowrap : false,toolbar:'#toolbar',pageSize : 10,showFooter : true">
		<thead>
			<tr>
				<th data-options="field:'ck', checkbox:true"></th>
				<th data-options="field :'id',hidden:true"></th>
					<th data-options="field :'code',hidden:true"></th>
				<th data-options="field:'solCtlgName_',width:100,align:'center'">业务应用名称</th>
				<th data-options="field:'desc_',width:200,align:'center'">业务应用描述</th>
			</tr>
		</thead>
	</table>
</div>
</body>
<script type="text/javascript">
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
		url : '${ctx}/bizSolMgr/findCtlgTree',
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
		},
		//右击事件（用于打开树右击菜单）
		onContextMenu : function(e, node) {
			e.preventDefault();
			$('#bizSolCtlgTree').tree('select', node.target);
			bizSolCtlgId = node.id;
			if(node.dtype=='root'){
				$("#addMenu").show();
				$("#editMenu").show();	
				$("#delMenu").hide();
			}else{
				//根据节点控制菜单显示内容		
				$("#addMenu").show();
				$("#editMenu").show();		
				$("#delMenu").show();
			}			
			//打开菜单
			$('#bizSolCtlgMenu').menu('show', {
				left : e.pageX,
				top : e.pageY
			});
		}
	});
}
var action;
var type;
/**
 * 添加流程定义类别（打开添加对话框）
 * @param level 类别等级 brother：同级 child:子级
 */

function addBizSolCtlg(level) {
	var node = $('#bizSolCtlgTree').tree('getSelected');
	var pid = '';
	if (level == 'brother') { // 添加同级节点
		pid = node.parent_id;
	} else { // 添加子节点
		pid = node.id;
	}
	$('#bizSolCtlg').form('clear');
	document.getElementById("parentId_").value = pid;
	$('#bizSolCtlgDlg').dialog({
		title: "新增类别",
		closed: false,
		cache: false,
		modal: true,
		onResize: function() {
			$(this).dialog('center');
		}
	}); 
	action = 'add';
	type='ywlb';
}

/**
 * 修改流程定义类别（打开类别修改对话框，并回显表单）
 */

function editBizSolCtlg() {
	var node = $('#bizSolCtlgTree').tree('getSelected');
	var id = node.id;
	if (node) {
		$.ajax({
			url: '${ctx}/bizSolMgr/findBizSolCtlgById',
			type: 'post',
			dataType: 'json',
			data: {
				'id': id
			},
			async: false,
			success: function(data) {
				$('#bizSolCtlg').form('load', {
					id: data.id,
					parentId_: data.parentId_,
					solCtlgName_: data.solCtlgName_,
					desc_: data.desc_,
					treeType_: data.treeType_,
					sort_: data.sort_,
					createUserId_: data.createUserId_,
					createTime_: data.createTime_,
					updateUserId_: data.updateUserId_,
					updateTime_: data.updateTime_,
					ts_: data.ts_,
					dr_: data.dr_,
					remark_: data.remark_
				});
				$('#bizSolCtlgDlg').dialog({
					title: "修改类别",
					closed: false,
					cache: false,
					modal: true,
					onResize: function() {
						$(this).dialog('center');
					}
				}); 
				action = 'update';
				type='ywlb';
			}
		});
	}
}

/**
 * 流程定义类别新增/修改保存方法
 */

function doSaveBizSolCtlg() {
	if($("#bizSolCtlg").form("validate")){
		var id=$("#id").val();
		var name=$("#solCtlgName_").textbox('getValue');
		$.ajax({
			url: '${ctx}/procScheme/checkName',
			type: 'post',
			dataType: 'text',
			async: false,
			data:{id:id,name:name,bizSolCtlgId:bizSolCtlgId},
			success: function(data){
				if(data=='Y'){
					$.messager.alert('提示', '名称重复！', 'info');
				}else{
					if(type=='ywlb'){
						var id = $("#id").val();
						var url = '';
						$.ajax({
							url: '${ctx}/bizSolMgr/doSaveBizSolCtlg',
							type: 'post',
							dataType: 'text',
							async: false,
							data: $('#bizSolCtlg').serialize(),
							success: function(data) {
								var title;
								var msg;
								if (data == 'Y') {
									if (action == 'add') {
										title = '新增业务';
										msg = '新增成功!';
									} else {
										title = '修改业务';
										msg = '修改成功!';
									}
									$.messager.show({
										title: title,
										msg: msg,
										timeout: 2000,
									});
									$('#bizSolCtlgDlg').dialog('close');
									InitTreeData();
								} else {
									if (action == 'add') {
										title = '新增业务';
										msg = '新增失败!';
									} else {
										title = '修改业务';
										msg = '修改失败!';
									}
									$.messager.show({
										title: title,
										msg: msg,
										timeout: 2000,
									});
								}
							}
						});
					}else if(type=='ywlx'){
						$.ajax({
							url : '${ctx}/procScheme/doSaveBizSolCtlg',
							type : 'post',
							async : false,
							data : $("#bizSolCtlg").serialize(),
							success : function(data){
								if (data != null) {
									$.messager.show({ title:'提示', msg:'保存成功！', showType:'slide' });
									$('#bizSolCtlgDlg').dialog('close');	
									reloadTableData();
								} else {
									$.messager.show({ title:'提示', msg:'保存失败！', showType:'slide' });
									$('#bizSolCtlgDlg').dialog('close');
								}
							}
						});
					}
				}
			}
		});
	}
}
/**
 * 删除流程定义类别
 */

function delBizSolCtlg() {
	var node = $('#bizSolCtlgTree').tree('getSelected');
	var id = '';
	if (node == null) {
		$.messager.alert('提示', '请选择操作项！', 'info');
		return;
	} else if (node.children != null) {
		$.messager.alert('提示', '父级节点不可删除！', 'info');
		return;
	} else {
		id = node.id;
		$.ajax({
			url: '${ctx}/procScheme/checkDelete',
			type: 'post',
			data: {
				'id': id
			},
			dataType: 'text',
			async: false,
			success: function(data){
				if (data == 'Y'){
					$.messager.alert('提示', '包含业务类型,不能删除！', 'info');
					return;
				}else{
					$.messager.confirm('提示', '确定删除吗?', function(r) {
						if (r) {
							$.ajax({
								url: '${ctx}/bizSolMgr/doDeleteBizSolCtlgById',
								type: 'post',
								data: {
									'id': id
								},
								dataType: 'text',
								async: false,
								success: function(data) {
									if (data == 'Y') {
										$.messager.show({
											title: '提示',
											msg: '删除成功'
										});
										InitTreeData();
									} else {
										$.messager.show({
											title: '提示',
											msg: '删除失败'
										});
									}
								}
							});
						}
					});
				}
			}
		});
	}
}
function InitTableData() {
	$('#dtlist').datagrid({
		url: '${ctx}/procScheme/findAllProcType',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		pageSize: 10,
		queryParams: {
			'bizSolCtlgId': bizSolCtlgId,
			'searchValue': ''
		}
	});
	$('#dtlist').datagrid('load');
	$('#dtlist').datagrid('clearSelections'); // 清空选中的行
}
function reloadTableData() {
	$('#dtlist').datagrid('reload', {
		'bizSolCtlgId': bizSolCtlgId,
		'searchValue': $("#search").searchbox('getValue'),
	});
	$('#dtlist').datagrid('clearSelections'); //清空选中的行
}
function addProcSch() {
	$("#bizSolCtlg").form("clear");
	document.getElementById("parentId_").value = bizSolCtlgId;
	$('#bizSolCtlgDlg').dialog({title: "新增业务应用"});
	changeDesc();
	$('#bizSolCtlgDlg').dialog('open');
	type='ywlx';
}
function modProcSch(){
	var data = $('#dtlist').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length != 1) {
			//$.messager.alert('提示', '请选择一行进行修改！', 'info');
			layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
			return;
		}
		$("#bizSolCtlg").form("clear");
		$('#bizSolCtlgDlg').dialog({title : "修改业务应用"});		
		document.getElementById("id").value = data[0].id;
		$("#solCtlgName_").textbox('setValue',data[0].solCtlgName_);
		$("#desc_").textbox('setValue',data[0].desc_);
		changeDesc();
		$('#bizSolCtlgDlg').dialog('open');
		type='ywlx';
	}
}
/**
 * 删除功能
 */
function delProcSch() {
	var selecteds = $('#dtlist').treegrid('getChecked');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择操作项！', 'info');
		layer.tips('请选择操作项', '#btn_del', { tips: 3 });
		return;
	}
	$.ajax({
		url : '${ctx}/procScheme/chenkChildren',
		type : 'post',
		async : false,
		data : {code:selecteds[0].code},
		success : function(data){
			if(data=='Y'){
				$.messager.alert('提示', '不能删除！', 'info');
			}else{
				$.messager.confirm('提示', '确定删除吗?', function(r) {
					if (r) {
						var ids = '';
						$(selecteds).each(function(index) {
							ids = ids + selecteds[index].id + ",";
						});
						ids = ids.substring(0, ids.length - 1);
						$.ajax({
							url : '${ctx}/procScheme/doDeleteBizSolCtlg',
							async : false,
							data : {ids : ids},
							success : function(result) {
								if (result != null) {
									$.messager.show({ title:'提示', msg:'删除成功！', showType:'slide' });
								} else {
									$.messager.show({ title:'提示', msg:'删除失败！', showType:'slide' });
								}
								reloadTableData();
							},
							error : function(result) {
								$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
							}
						});
					}
				});
			}		
		}
	});
}
/**
 * 查询条件
 * */
function findByModuleName() {
	reloadTableData();
}
function clearSearchBox(){
	 $("#search").searchbox("setValue","");
	 reloadTableData();
}

/**
 * 监控名称的改变，描述跟着改变
 */
function changeDesc(){
    $("#solCtlgName_").textbox({
        onChange: function(value){ 
            var solCtlgName_ = $("#solCtlgName_").textbox("getValue");
            $("#desc_").textbox("setValue",solCtlgName_);
        }
      });  
}
</script>
</html>