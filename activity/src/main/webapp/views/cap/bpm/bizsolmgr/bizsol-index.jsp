<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>应用模型管理</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" style="width:100%;height:98%">
<!-- 页面布局西部 -->
<div data-options="region:'west',split:false" title="业务应用类别" style="width:200px;">
	<!-- <span><button onclick="InitTreeData()">刷新</button></span> -->
	<!-- 业务应用类别 -->
	<ul class="easyui-tree" id="bizSolCtlgTree">
	</ul>
	<!-- 业务应用类别新增/修改窗口 -->
	<div id="bizSolCtlgDlg" class="easyui-dialog" closed="true" title="" style="width:300px;height:290px;padding:10px">
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
			<div style="margin-bottom:5px">
				<div>业务应用类别名称:</div>
				<input class="easyui-textbox" id="solCtlgName_" name="solCtlgName_" 
					data-options="required:true" missingMessage="不能为空" style="width:100%;height:32px">
			</div>
			<div style="margin-bottom:5px">
				<div>业务应用类别描述:</div>
				<input class="easyui-textbox" data-options="multiline:true" id="desc_" name="desc_" style="width:100%;height:100px">
			</div>
			<div>
				<a href="javascript:void(0)" onclick="doSaveBizSolCtlg()" class="easyui-linkbutton" iconcls="icon-ok" style="width:100%;height:32px">保存</a>
			</div>
		</form>
	</div>
</div>

<!-- 页面布局中部 -->
<div data-options="region:'center',title:'应用模型信息'" style="padding:5px;">
	<!-- 列表工具栏 -->
	<div id="toolbar" style="height: auto">
		<a href="javascript:void(0)" onclick="detail()" class="easyui-linkbutton" iconcls="icon-add" id="btn_view" plain="true">明细</a>
		<a href="javascript:void(0)" onclick="add()" class="easyui-linkbutton" iconcls="icon-add" id="btn_add" plain="true">新增</a>
		<a href="javascript:void(0)" onclick="update()" class="easyui-linkbutton" iconcls="icon-edit" id="btn_edit" plain="true">编辑</a>
		<a href="javascript:void(0)" onclick="delele()" class="easyui-linkbutton" iconcls="icon-remove" id="btn_del" plain="true">删除</a>
		<!-- <a href="javascript:void(0)" class="easyui-menubutton"
				data-options="menu:'#search',iconCls:'icon-serach'">高级查询</a>
		<div id="search" style="width: 150px;">
			<div data-options="iconCls:'icon-add'">
				新建查询
			</div>
			<div data-options="iconCls:'icon-redo'">
				查询列表
			</div>
		</div>
		<a href="javascript:void(0)" class="easyui-menubutton" data-options="menu:'#accessory',iconCls:'icon-serach'">附件</a>
		<div id="accessory" style="width: 150px;">
			<div data-options="iconCls:'icon-add'">
				新建附件
			</div>
			<div data-options="iconCls:'icon-add'">
				预览附件
			</div>
			<div data-options="iconCls:'icon-redo'">
				下载附件列表
			</div>
		</div>
		<a href="javascript:void(0)" onclick="addExcelUser()" class="easyui-linkbutton" iconcls="icon-add" plain="true">导入</a>
		<a href="javascript:void(0)" onclick="addExcelUser()" class="easyui-linkbutton" iconcls="icon-add" plain="true">导出</a>
		<a href="javascript:void(0)" id="mb" class="easyui-menubutton" data-options="menu:'#tool',iconCls:'icon-edit'">工具</a>
		<div id="tool" style="width: 150px;">
			<div data-options="iconCls:'icon-undo'">
				保存当前
			</div>
			<div data-options="iconCls:'icon-redo'">
				保存为新
			</div>
			<div data-options="iconCls:'icon-redo'">
				导出
			</div>
		</div>
		 -->
		<div style="padding:3px">
			<span>查询条件：</span>
			<select class="easyui-combobox" id="zd" value="" data-options="editable:false,panelHeight:'auto',width:200">
				<option value="">请选择</option>
				<option value="solName_">名称</option>
				<option value="key_">标识Key</option>
			</select>
			<select class="easyui-combobox" id="tj" value="" data-options="editable:false,panelHeight:'auto',width:200">
				<option value="">请选择</option>
				<option value="equal">等于</option>
				<option value="fuzzy">模糊匹配</option>
				<option value="left_fuzzy">左模糊匹配</option>
				<option value="right_fuzzy">右模糊匹配</option>
			</select>
			<input class="easyui-textbox" id="searchValue">
			<a href="javascript:void(0)" onclick="searchData()" data-options="iconCls:'icon-search'" class="easyui-linkbutton" plain="true">查询</a>
			<a href="javascript:void(0)" onclick="reloadTableData()" class="easyui-linkbutton" plain="true">清空查询</a>
		</div>
	</div>
	<!-- 流程定义列表 -->
	<table class="easyui-datagrid" id="bizSolInfoList" data-options="idField:'id',toolbar:'#toolbar',striped:true,fitColumns:true,fit:true,rownumbers:true,pagination:true,nowrap:false,showFooter:true,nowrap:false">
		<thead frozen="true">
			<tr>
				<th data-options="field :'ck',checkbox:true"></th>
				<th data-options="field :'procDefId_',hidden:true"></th>
				<th data-options="field:'id',width:100,align:'center',formatter: formatterOpert">操作</th>
			</tr>
		</thead>
		<thead>
			<tr>
				<th data-options="field:'solName_',width:160">名称</th>
				<th data-options="field:'key_',width:80,align:'center'">标识Key</th>
				<th data-options="field:'isProcess_',width:40,align:'center',formatter:formatterProcess">是否有流程</th>
				<th data-options="field:'createTime_',width:100,align:'center',formatter:formatterTime">创建时间</th>
			</tr>
		</thead>
	</table>
</div>
<!-- 流程定义新增编辑窗口 -->
<div id="bizSolInfoDlg" style="overflow:hidden;" closed="true" data-options="resizable:false,modal:true">
	<iframe scrolling="no" id="iframe" frameborder="0" border="0" 
		marginwidth="0" marginheight="0" style="width:100%;height:100%;"></iframe>
</div>
</body>
<script type="text/javascript">
$(function() {
	InitTreeData();
});

/**
 * 业务类别Id
 * 用途：
 * 1、页面初始化时加载列表数据
 * 2、点击树节点加载对应类别下的列表数据
 * 3、点击新增/复制新增时 默认所属类别
 */
var bizSolCtlgId = '';
/**
 * 加载业务类别树
 */

function InitTreeData() {
	$('#bizSolCtlgTree').tree({
		url: '${ctx}/bizSolMgr/findCtlgTree',
		animate: true,
		//开启折叠动画
		//树加载成功后回调函数（用于初始化列表）
		onLoadSuccess: function(node, data) {
			if (data[0].children != null) {
				var target = data[0].children[0]; //获取根节点下的第一个节点
				if (target != null) {
					//给 业务类别Id 赋值
					bizSolCtlgId = target.id;
					$("#bizSolCtlgTree").tree("select", target); //相当于默认点击了一下该节点，执行onSelect方法   
					$("#bizSolCtlgTree li:eq('1')").find("div").eq('0').addClass("tree-node-selected"); //设置该树第一个子点高亮   
				}
			}
			// 初始化列表
			InitTableData();
		},
		//单击事件（用于加载列表数据）
		onClick: function(node, data) {
			//给 业务类别Id 赋值
			bizSolCtlgId = node.id;
			//重新加载列表数据
			reloadTableData();
		},
		/* //右击事件（用于打开树右击菜单）
		onContextMenu: function(e, node) {
			e.preventDefault();
			$('#bizSolCtlgTree').tree('select', node.target);
			//根据节点控制菜单显示内容
			if (node.parent_id != null && node.parent_id != "" && node.children == null) {
				$("#addMenu").show();
				$("#delMenu").show();
			} else if (node.parent_id != null && node.parent_id != "" && node.children != null) {
				$("#addMenu").show();
				$("#delMenu").hide();
			} else {
				$("#addMenu").hide();
				$("#delMenu").hide();
			}
			//打开菜单
			$('#bizSolCtlgMenu').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		} */
	});
}


var action;
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
			}
		});
	}
}

/**
 * 流程定义类别新增/修改保存方法
 */

function doSaveBizSolCtlg() {
	if($("#bizSolCtlg").form("validate")){
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
		$.messager.confirm('删除业务流程解决类别', '确定删除吗?', function(r) {
			if (r) {
				id = node.id
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



/**
 * 加载流程定义列表
 */

function InitTableData() {
	$('#bizSolInfoList').datagrid({
		url: '${ctx}/bizSolMgr/findBizSolInfoIdByCtlgId',
		queryParams: {
			'bizSolCtlgId': bizSolCtlgId,
			'searchValue': '',
			'zd': '',
			'tj': ''
		},
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		pageSize: 10,
	});
}

/**
 * 列表搜索方法
 */

function searchData() {
	var searchValue = $('#searchValue').val(); //搜索值
	var zd = $('#zd').combobox('getValue'); //搜索字段
	var tj = $('#tj').combobox('getValue'); //搜索条件

	$('#bizSolInfoList').datagrid('reload', {
		'bizSolCtlgId': bizSolCtlgId,
		'searchValue': searchValue,
		'zd': zd,
		'tj': tj
	});
}

/**
 * 重新加载流程定义列表数据
 */

function reloadTableData() {
	$('#zd').combobox('setValues', ""); //搜索字段
	$('#tj').combobox('setValues', ""); //搜索条件
	$('#searchValue').textbox("setValue", '');
	$('#bizSolInfoList').datagrid('reload', {
		'bizSolCtlgId': bizSolCtlgId,
		'searchValue': '',
		'zd': '',
		'tj': ''
	});
	$('#bizSolInfoList').datagrid('clearSelections'); //清空选中的行
}

/**
 * 操作单元格图标点击事件
 * @param index 所点击的图标所在行索引
 * @param action 动作标识 detial： 打开明细弹窗 update:打开修改弹窗
 * 				 	   delete：执行删除操作
 */

function imgClick(index, action) {
	$('#bizSolInfoList').datagrid('clearSelections'); //清空选中的行
	$('#bizSolInfoList').datagrid('selectRow', index); //根据行索引选中一行
	window.event.cancelBubble = true; //阻止冒泡事件 （行点击事件）
	if (action == 'detial') {
		detail();
	} else if (action == 'update') {
		update();
	} else if (action == 'delete') {
		delele();
	} else if (action == 'bbkz') {
		version();
	} else if (action == "fapz") {
		var data = $('#bizSolInfoList').datagrid('getChecked');
		var id = data[0].id;
		var url = '${ctx}/bizSolMgr/toschmcnfg?id=' + id+'&isProcess_='+data[0].isProcess_;
		if (id != null) {
			window.parent.addTab(data[0].solName_ + "-配置", url);
		}
	}
}

/**
 * 打开明细弹窗
 */

function detail() {
	var data = $('#bizSolInfoList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			//$.messager.alert('提示', '请选择单行记录查看！', 'info');
			layer.tips('请选择单行记录查看', '#btn_view', { tips: 3 });
			return;
		}
		var id = data[0].id;
		$('#iframe').attr('src', "${ctx}/bizSolMgr/viewBizSolDetial?id=" + id);
		$('#bizSolInfoDlg').dialog({
			title: '应用模型明细',
			width: 720,
			height: 450,
			closed: false,
			cache: false,
			onResize: function() {
				$(this).dialog('center');
			}
		});
	}
}

/**
 * 打开新增流程定义基本信息弹出框
 * @param mode 新增方式  new：新建  copy：复制新增
 */

function add() {
	$('#iframe').attr('src', "${ctx}/bizSolMgr/addBizSol?bizSolCtlgId=" + bizSolCtlgId);
	$('#bizSolInfoDlg').dialog({
		title: '新增应用模型',
		width: 720,
		height: 360,
		cache: false,
		closed: false,
		onResize: function() {
			$(this).dialog('center');
		}
	});
}

/**
 * 批量删除选中的流程定义基本信息
 */

function delele() {
	var datas = $('#bizSolInfoList').datagrid('getSelections');
	if (datas == null || datas.length == 0) {
		//$.messager.alert('提示', '请选择要删除的记录！', 'info');
		layer.tips('请选择要删除的记录', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除业务', '确定删除吗?', function(r) {
		if (r) {
			var ids = [];
			$(datas).each(function(index) {
				ids[index] = datas[index].id;
			});
			$.ajax({
				url: '${ctx}/bizSolMgr/doDeleteBizSolInfosByIds',
				dataType: 'text',
				data: {
					'ids': ids
				},
				async: false,
				success: function(data) {
					if (data == 'Y') {
						$.messager.show({
							title: '删除业务',
							msg: '删除成功！',
							timeout: 2000
						});
						reloadTableData();
					} else {
						$.messager.show({
							title: '删除业务',
							msg: '删除失败！',
							timeout: 2000
						});
					}
				}
			});
		}
	});
}

/**
 * 打开流程定义基本信息修改弹窗
 */

function update() {
	var data = $('#bizSolInfoList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			//$.messager.alert('提示', '请选择单行记录修改！', 'info');
			layer.tips('请选择单行记录修改', '#btn_edit', { tips: 3 });
			return;
		}
		var id = data[0].id;
		$('#iframe').attr('src', "${ctx}/bizSolMgr/updateBizSol?module=index&id=" + id);
		$('#bizSolInfoDlg').dialog({
			title: '编辑应用模型',
			width: 720,
			height: 360,
			cache: false,
			closed: false,
			onResize: function() {
				$(this).dialog('center');
			}
		});
	}
}
/**
 * 关闭弹出的dialog
 */

function closeDialog() {
	$('#bizSolInfoDlg').dialog('close');
}



function formatterOpert(val, row, index) {
	return '<table border="0" width="100%"><tr>' 
		+ '<td><img style="cursor:pointer" src="${ctx}/views/cap//bpm/bizsolmgr/img/detail.png"  title="明细" onclick="imgClick(\'' + index + '\',\'detial\')"/></td>' 
		+ '<td><img style="cursor:pointer" src="${ctx}/views/cap//bpm/bizsolmgr/img/mgr.png" title="配置" onclick="imgClick(\'' + index + '\',\'fapz\')"/></td>' 
		/* + '<td><img style="cursor:pointer" src="${ctx}/views/cap//bpm/bizsolmgr/img/icon-start.png" title="启动流程" onclick="imgClick(\'' + index + '\',\'qdlc\')"/></td>'  */
		+ '<td><img style="cursor:pointer" src="${ctx}/views/cap//bpm/bizsolmgr/img/edit.png" title="编辑" onclick="imgClick(\'' + index + '\',\'update\')"/></td>' 
		+ '<td><img style="cursor:pointer" src="${ctx}/views/cap//bpm/bizsolmgr/img/remove.png" title="删除" onclick="imgClick(\'' + index + '\',\'delete\')"/></td>' 
		+ '</tr></table>';
}

function formatterTime(value, row, index) {
	return value.substr(0, 19);
}
function formatterProcess(value, row, index){  
    if(row.isProcess_==1){  
        return "有";  
    }else{  
        return "无";  
    }  
}  
</script>
</html>