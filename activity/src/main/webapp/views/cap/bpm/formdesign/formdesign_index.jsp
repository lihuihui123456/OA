<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>业务表单设计</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" style="width:100%;height:98%">
	<!-- 页面布局西部 -->
	<div data-options="region:'west',split:true" title="业务应用类别" style="width:200px;">
		<!-- <span><button onclick="InitTreeData()" >刷新</button></span> -->
		<!-- 业务表单单类别树 -->
		<ul class="easyui-tree" id="formCtlgTree"></ul>
		
		<!-- 业务解决方案类别右击菜单  -->
		<div id="formCtlgMenu" class="easyui-menu" style="width:120px;">
			<div id="addMenu" onclick="addFormCtlg('brother')" data-options="iconCls:'icon-add'">添加同级类别</div>
			<div onclick="addFormCtlg('child')" data-options="iconCls:'icon-add'">添加子级类别</div>
			<div onclick="editFormCtlg()" data-options="iconCls:'icon-edit'">编辑所选类别</div>
			<div id="delMenu" onclick="delFormCtlg()" data-options="iconCls:'icon-remove'">删除所选类别</div>
		</div>
		<!-- 流程定义类别新增/修改窗口 -->
		<div id="formCtlgDlg" class="easyui-dialog" closed="true" title="" style="width:300px;height:290px;padding:10px">
			<form id="formCtlg">
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
				<div>类别名称:</div>
					<input class="easyui-textbox" id="formCtlgName_" name="formCtlgName_"
						data-options="required:true" missingMessage="不能为空" style="width:100%;height:32px">
				</div>
				<div style="margin-bottom:5px">
					<div>类别描述:</div>
					<input class="easyui-textbox" data-options="multiline:true" id="desc_" name="desc_"
						style="width:100%;height:100px">
				</div>
				<div>
				<a href="javascript:void(0)" onclick="doSaveFormCtlg()" class="easyui-linkbutton"
					iconCls="icon-ok" style="width:100%;height:32px">保存</a>
				</div>
			</form>
		</div>
	
	</div>
	
	<!-- 页面布局中部 -->
	<div data-options="region:'center',title:'业务表单信息'" style="padding:5px;">
		<!-- 列表工具栏 -->
		<div id="toolbar" style="height: auto">
			<a href="javascript:void(0)" onclick="detail()"
				class="easyui-linkbutton" iconCls="icon-add" id="btn_view" plain="true">明细</a>
			<a href="javascript:void(0)" onclick="add()"
				class="easyui-linkbutton" iconCls="icon-add" id="btn_add" plain="true">新增</a>
			<a href="javascript:void(0)" onclick="update()"
				class="easyui-linkbutton" iconCls="icon-edit" id="btn_edit" plain="true" >编辑</a> 
			<a href="javascript:void(0)" onclick="delele()"
				class="easyui-linkbutton" iconCls="icon-remove" id="btn_del" plain="true">删除</a>
			<!-- <a href="javascript:void(0)" onclick="upload()"
				class="easyui-linkbutton" iconCls="icon-add" plain="true">上传表单</a> -->
			<!-- <a href="javascript:void(0)" class="easyui-menubutton"
				data-options="menu:'#search',iconCls:'icon-serach'">高级查询方案</a>
			<div id="search" style="width: 150px;">
				<div data-options="iconCls:'icon-add'">新建查询方案</div>
				<div data-options="iconCls:'icon-redo'">查询方案列表</div>
			</div>
			<a href="javascript:void(0)" class="easyui-menubutton"
				data-options="menu:'#accessory',iconCls:'icon-serach'">附件</a>
			<div id="accessory" style="width: 150px;">
				<div data-options="iconCls:'icon-add'">新建附件</div>
				<div data-options="iconCls:'icon-add'">预览附件</div>
				<div data-options="iconCls:'icon-redo'">下载附件列表</div>
			</div>
			<a href="javascript:void(0)" onclick="addExcelUser()"
				class="easyui-linkbutton" iconCls="icon-add" plain="true">导入</a>
			<a href="javascript:void(0)" onclick="addExcelUser()"
				class="easyui-linkbutton" iconCls="icon-add" plain="true">导出</a>
			<a href="javascript:void(0)" id="mb" class="easyui-menubutton"
				data-options="menu:'#tool',iconCls:'icon-edit'">工具</a>
			<div id="tool" style="width: 150px;">
				<div data-options="iconCls:'icon-undo'">保存当前方案</div>
				<div data-options="iconCls:'icon-redo'">保存为新方案</div>
				<div data-options="iconCls:'icon-redo'">导出</div>
			</div> -->
			<div style="padding:3px">
				<span>查询条件：</span>
				<select class="easyui-combobox" id="zd" value="" data-options="editable:false,panelHeight:'auto',width:200">
					<option value="">请选择</option>
					<option value="formName_">名称</option>
					<option value="key_">标识键</option>
				</select>
				<select class="easyui-combobox" value="" id="tj" data-options="editable:false,panelHeight:'auto',width:200">
					<option value="">请选择</option>
					<option value="equal">等于</option>
					<option value="fuzzy">模糊匹配</option>
					<option value="left_fuzzy">左模糊匹配</option>
					<option value="right_fuzzy">右模糊匹配</option>
				</select>
				<input class="easyui-textbox" id="searchValue" />
				<a href="javascript:void(0)" onclick="searchData()" data-options="iconCls:'icon-search'"
					class="easyui-linkbutton" plain="true">查询</a>
				<a href="javascript:void(0)" onclick="reloadTableData()"
					class="easyui-linkbutton" plain="true">清空查询</a>
			</div>
		</div>

		<!-- 流程定义列表 -->
		<table class="easyui-datagrid" id="bpmReFormList"
			data-options="idField:'id',toolbar:'#toolbar',striped:true,fitColumns:true,fit:true,singleSelect:true,rownumbers:true,pagination:true,nowrap:false,showFooter:true,nowrap:false">
			<thead frozen="true">
				<tr>
					<th data-options="field :'ck',checkbox:true"></th>
					<th data-options="field:'id',align:'center',width:120,formatter: formatterOpert">操作</th>
				</tr>
			</thead>
			<thead>
				<tr>
					<th data-options="field:'formName_',width:200">名称</th>
					<th data-options="field:'key_',width:50,align:'center'">标志键</th>
					<th data-options="field:'state_',width:50,align:'center',formatter:formatterState">状态</th>
					<th data-options="field:'version_',width:50,align:'center'">主版本号</th>
					<th data-options="field:'formType_',width:80,align:'center',formatter:formatterType">类型</th>
					<th data-options="field:'createTime_',width:100,align:'center',formatter: formatterTime">创建时间</th>
				</tr>
			</thead>
		</table>
		
		<!-- 页面弹出窗口一 -->
		<div id="dialog" style="overflow:hidden;" closed="true" data-options="resizable:false,modal:true">
			<iframe scrolling="no" id="iframe" frameborder="0" style="width:100%;height:100%;"></iframe>
		</div>
		
		<!-- 页面弹出窗口二 -->
		<div id="dialog_" style="overflow:hidden;" closed="true" data-options="resizable:false,modal:true">
			<iframe scrolling="no" id="iframe_" frameborder="0" style="width:100%;height:100%;"></iframe>
		</div>
	</div>
</body>
<script type="text/javascript">
$(function() {
	InitTreeData();
});

/**
 * 业务表单类别Id
 * 用途：
 * 1、页面初始化时加载列表数据
 * 2、点击树节点加载对应类别下的列表数据
 * 3、点击新增/复制新增时 默认所属类别
 */ 
var formCtlgId = '';
/**
 * 加载业务解决方案类别树
 */
function InitTreeData() {
	$('#formCtlgTree').tree({
		url : '${ctx}/formDesignController/formCtlgTree',
		animate : true, //开启折叠动画
		//树加载成功后回调函数（用于初始化列表）
		onLoadSuccess : function(node,data){
			if(data[0].children !=null ){
				var target = data[0].children[0];//获取根节点下的第一个节点
				if( target != null ) {
					//给 业务解决方案类别Id 赋值
					formCtlgId = target.id;
					$("#formCtlgTree").tree("select", target);//相当于默认点击了一下该节点，执行onSelect方法   
					$("#formCtlgTree li:eq('1')").find("div").eq('0').addClass("tree-node-selected");//设置该树第一个子点高亮   
				}
			}
			// 初始化列表
			InitTableData();
		},
		//单击事件（用于加载列表数据）
		onClick : function(node, data) {
			//给 业务解决方案类别Id 赋值
			formCtlgId = node.id;
			//重新加载列表数据
			reloadTableData();
		}
	});
}


var action;
/**
 * 添加表单类别（打开添加对话框）
 * @param level 类别等级 brother：同级 child:子级
 */
function addFormCtlg(level) {
	var node = $('#formCtlgTree').tree('getSelected');
    var pid = '';
	if (level == 'brother') {// 添加同级节点
		pid = node.parent_id;
	} else {// 添加子节点
		pid = node.id;
	}
	$('#formCtlg').form('clear');
	document.getElementById("parentId_").value = pid;
	$('#formCtlgDlg').dialog({title: "新增类别"});
	$('#formCtlgDlg').dialog('open');
	action = 'add';
}

/**
 * 修改流程定义类别（打开类别修改对话框，并回显表单）
 */
function editFormCtlg() {
	var node = $('#formCtlgTree').tree('getSelected');
	var id = node.id;
	if (node) {
		$.ajax({
			url : '${ctx}/formDesignController/findBpmReFormCtlgById',
			type : 'post',
			dataType : 'json',
			data : { 'id' : id },
			async: false,
			success : function(data) {
				$('#formCtlg').form('load',{
					id:data.id,
					parentId_:data.parentId_,
					formCtlgName_:data.formCtlgName_,
					desc_:data.desc_,
					treeType_:data.treeType_,
					sort_:data.sort_,
					createUserId_:data.createUserId_,
					createTime_:data.createTime_,
					updateUserId_:data.updateUserId_,
					updateTime_:data.updateTime_,
					ts_:data.ts_,
					dr_:data.dr_,
					remark_:data.remark_
				});
				$('#formCtlgDlg').dialog({title: "编辑类别"});
				$('#formCtlgDlg').dialog('open');
				action = 'update';
			}
		});
	}
}

/**
 * 流程定义类别新增/修改保存方法
 */
function doSaveFormCtlg() {
	if($("#formCtlg").form("validate")){
		var id = $("#id").val();
		var url = '';
		$.ajax({
			url : '${ctx}/formDesignController/doSaveFormCtlg',
			type : 'post',
			dataType : 'text',
			async: false,
			data : $('#formCtlg').serialize(),
			success : function(data) {
				var title;
				var msg;
				if( data=='Y' ){
					if(action == 'add'){
						title = '提示';
						msg = '新增成功!';
					}else{
						title = '提示';
						msg = '更新成功!';
					}
					$.messager.show({title : title,msg : msg});
					$('#formCtlgDlg').dialog('close');
					InitTreeData();
				}else{
					if(action == 'add'){
						title = '提示';
						msg = '新增失败!';
					}else{
						title = '提示';
						msg = '更新失败!';
					}
					$.messager.show({title:title,msg:msg});
				}
			}
		});
	}
}

/**
 * 删除流程定义类别
 */
function delFormCtlg() {
	var node = $('#formCtlgTree').tree('getSelected');
	var id = '';
	if (node == null) {
		$.messager.alert('提示', '请选择单行记录删除！', 'info');
		return;
	} else if (node.children != null) {
		$.messager.alert('提示', '父级节点不可删除！', 'info');
		return;
	} else {
		$.messager.confirm('删除类别', '确定删除吗?', function(r) {
			if (r) {
				id = node.id
				$.ajax({
					url : '${ctx}/formDesignController/doDeleteFormCtlgById',
					type : 'post',
					data : { 'id' : id},
					dataType : 'text',
					async: false,
					success : function(data){
						if( data == 'Y' ){
							$.messager.show({ title:'提示', msg:'删除成功'});
							InitTreeData();
						}else if( data == 'N' ){
							$.messager.show({ title:'提示', msg:'删除失败'});
						}else{
							$.messager.show({ title:'提示', msg:'该类别下存在表单，不能删除！'});
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
	$('#bpmReFormList').datagrid({
		url : '${ctx}/formDesignController/findBpmReFormByFormCtlgId',
		queryParams: {
			'formCtlgId': formCtlgId,
			'searchValue' : '',
			'zd' : '',
			'tj' : ''
		},
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		pageSize : 10,
	});
}

/**
 * 重新加载流程定义列表数据
 */
function reloadTableData() {
	$('#zd').combobox('setValues',"");//搜索字段
	$('#tj').combobox('setValues',"");//搜索条件
	$('#searchValue').textbox("setValue",'');
	$('#bpmReFormList').datagrid('reload', {
		'formCtlgId': formCtlgId,
		'searchValue' : '',
		'zd' : '',
		'tj' : ''
	});
	$('#bpmReFormList').datagrid('clearSelections'); //清空选中的行
}

/**
 * 列表搜索方法
 */
function searchData(){
	var searchValue  = $('#searchValue').val();//搜索值
	var zd = $('#zd').combobox('getValue');//搜索字段
	var tj = $('#tj').combobox('getValue');//搜索条件
	
	$('#bpmReFormList').datagrid('reload', {
		'formCtlgId':formCtlgId,
		'searchValue' : searchValue,
		'zd' : zd,
		'tj' : tj
	});
}

/**
 * 操作单元格图标点击事件
 * @param index 所点击的图标所在行索引
 * @param action 动作标识 detial： 打开明细弹窗 update:打开修改弹窗 
 * 				 	   delete：执行删除操作
 */
function imgClick(index, action){
	$('#bpmReFormList').datagrid('clearSelections'); //清空选中的行
	$('#bpmReFormList').datagrid('selectRow', index); //根据行索引选中一行
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	if(action == 'detial'){
		detail();
	}else if(action == 'update'){
		update();
	}else if(action == 'publish'){
		publish();
	}else if(action == 'delete'){
		delele();
	}else if(action == 'bbkz'){
		version();
	}else if(action == "fapz"){
		var data = $('#bpmReFormList').datagrid('getChecked');
		var id = data[0].id;
		var url = '${ctx}/formDesignController/toschmcnfg?id='+id;
		if(id!=null) {
			window.parent.addTab(data[0].solName_+"-方案配置",url);
		}
	}
}

/**
 * 打开明细弹窗
 */
function detail(){
	var data = $('#bpmReFormList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			//$.messager.alert('提示', '请选择单行记录查看！', 'info');
			layer.tips('请选择单行记录查看', '#btn_view', { tips: 3 });
			return;
		}
		var id = data[0].id;
		var src = '${ctx}/formDesignController/toFormDetial?id='+id+'&divId=dialog';
		$('#iframe').attr('src', src);
		$('#dialog').dialog({    
		    title: '业务表单明细',
		    width: 750,
		    height: 400,
		    cache: false,
		    closed : false,
		    onResize:function(){
               $(this).dialog('center');
            }
		}); 
	}
}

function publish(){
	var datas = $('#bpmReFormList').datagrid('getChecked');
	if (datas) {
		if (datas.length != 1) {
			$.messager.alert('提示', '请选择单行记录查看！', 'info');
			return;
		}
		if (datas[0].state_ == "1") {
			$.messager.alert('提示', '该业务表单已发布！');
			return;
		}
		var id = datas[0].id;
		$.ajax({
			url : '${ctx}/formDesignController/doUpdateStateById',
			dataType : 'json',
			data : {
				"id" : id,
				"state" : "1"
			},
			async: false,
			success : function(data){
				if( data.flag == 'true' ){
					$.messager.show({title : '提示',msg : data.msg,timeout : 2000});
					reloadTableData();
				}else{
					$.messager.show({title : '提示',msg : data.msg,timeout : 2000});
				}
			}
		}); 
	}
}

/**
 * 打开新增流程定义基本信息弹出框
 * @param mode 新增方式  new：新建  copy：复制新增
 */
function add(){
	var src = '${ctx}/formDesignController/toFormAdd?formCtlgId='+formCtlgId;
	$('#iframe').attr('src', src);
	$('#dialog').dialog({    
	    title: '新增业务表单',
	    width: 750,
	    height: 400,
	    cache: false,
	    closed : false,
	    onResize:function(){
	       $(this).dialog('center');
	    }
	});
}

/**
 * 打开版本控制弹出框
 */
function version(){
	var data = $('#bpmReFormList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('提示', '请选择单行记录删除！', 'info');
			return;
		}
		var sameSeries = data[0].sameSeries_;
		var src = '${ctx}/formDesignController/toFormVersion?sameSeries='+sameSeries;
		$('#iframe').attr('src', src);
		$('#dialog').dialog({    
		    title: '版本控制',
		    width: 750,
		    height: 450,
		    cache: false,
		    closed : false,
		    onResize:function(){
               $(this).dialog('center');
            }
		});
	}
}

/**
 * 批量删除选中的流程定义基本信息
 */
function delele(){
	var datas = $('#bpmReFormList').datagrid('getSelections');
	if (datas == null || datas.length != 1) {
		//$.messager.alert('提示', '请选择单行记录删除！', 'info');
		layer.tips('请选择单行记录删除', '#btn_del', { tips: 3 });
		return;
	}
	/* if (datas[0].state_ != null && datas[0].state_ == "1") {
		$.messager.alert('提示', '业务表单已发布，不能删除！', 'info');
		return;
	} */
	$.messager.confirm('删除业务表单', '确定删除吗?', function(r) {
		if (r) {
			var ids = [];
			$(datas).each(function(index) {
				ids[index] = datas[index].id;
			});
			$.ajax({
				url : '${ctx}/formDesignController/doDeleteBpmReFormByIds',
				dataType : 'text',
				data : {'ids' : ids},
				async: false,
				success : function(data){
					if( data == 'Y' ){
						$.messager.show({title : '提示',msg : '删除成功！',timeout : 2000});
						reloadTableData();
					}else{
						$.messager.show({title : '提示',msg : '删除失败！',timeout : 2000});
					}
				}
			});
		}
	});
}

/**
 * 打开流程定义基本信息修改弹窗
 */
function update(){
	var data = $('#bpmReFormList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			//$.messager.alert('提示', '请选择单行记录修改！','info');
			layer.tips('请选择单行记录修改', '#btn_edit', { tips: 3 });
			return;
		}
		var id = data[0].id;
		var src = '${ctx}/formDesignController/toFormUpdate?id='+id+'&divId=dialog';
		$('#iframe').attr('src', src);
		$('#dialog').dialog({    
		    title: '编辑业务表单',
		    width: 750,
		    height: 400,
		    cache: false,
		    closed : false,
		    onResize:function(){
               $(this).dialog('center');
            }
		}); 
	}
}

/**
 * 关闭弹出的dialog
 */
function closeDialog(dialogId){
	$('#'+dialogId+'').dialog('close');
}



function formatterOpert (val, row, index){
	return '<table border="0" width="100%"><tr>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/formdesign/img/detail.png"  title="明细" onclick="imgClick(\''+index+'\',\'detial\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/formdesign/img/edit.png" title="编辑" onclick="imgClick(\''+index+'\',\'update\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/formdesign/img/icon-start.png" title="发布" onclick="imgClick(\''+index+'\',\'publish\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/formdesign/img/version.png" title="版本控制" onclick="imgClick(\''+index+'\',\'bbkz\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/formdesign/img/remove.png" title="删除" onclick="imgClick(\''+index+'\',\'delete\')"/></td>'
			+'</tr></table>';
}

function formatterTime (value, row, index) {
	return value.substr(0,19);
}

function formatterState (value, row, index) {
	var state = '';
	if(value == '0'){
		state = '初始化';
	}
	if(value == '1')
		state = '已发布';
	return state;
}

function formatterType (value, row, index) {
	var type = '';
	if(value == '1')
		type = '超链接表单';
	if(value == '2')
		type = '自由表单';
	return type;
}

function upload() {
	var data = $('#bpmReFormList').datagrid('getChecked');
	var id = "";
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '不能同时对多条记录上传表单！','info');
			return;
		}
		if(data.length == 1){
			id = data[0].id;
		}
		var src = '${ctx}/formDesignController/toFormUpload?id=' +id;
		$('#iframe').attr('src', src);
		$('#dialog').dialog({    
		    title: '表单上传',
		    width: 450,
		    height: 380,
		    cache: false,
		    closed : false,
		    onResize:function(){
               $(this).dialog('center');
            }
		}); 
	}
}
</script>
</html>