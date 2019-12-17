<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>业务表单版本控制</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" style="width:100%;height:100%">
	<div data-options="region:'center',height:'auto'">
		<table class="easyui-datagrid" id="formList" data-options=" 
			idField:'id',striped:true,fitColumns:true,fit:true,
			rownumbers:true,pagination:true,nowrap:false,showFooter:true,nowrap:false">
			<thead frozen="true">
				<tr>
					<th data-options="field :'ck',checkbox:true"></th>
					<th data-options="field :'sameSeries_',hidden:true"></th>
					<th data-options="field:'id',width:110,align:'center',formatter: formatterOpert">操作</th>
				</tr>
			</thead>
			<thead>
				<tr>
					<th data-options="field:'formName_',width:200">名称</th>
					<th data-options="field:'key_',width:50,align:'center'">标志键</th>
					<th data-options="field:'state_',width:50,align:'center',formatter:formatterState">状态</th>
				 	<th data-options="field:'mainVersion_',width:50,align:'center'">是否版本</th>
					<th data-options="field:'version_',width:50,align:'center'">版本</th>
					<th data-options="field:'formType_',width:80,align:'center',formatter:formatterType">类型</th>
				</tr>
			</thead>
		</table>
	</div>
	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<a href="javascript:void(0)" onclick="closeDig()"
					class="easyui-linkbutton" plain="true">关闭</a>
		</div>
	</div>
</body>
<script type="text/javascript">
var sameSeries = "${sameSeries}";
$(function(){
	$('#formList').datagrid({
		url : "${ctx}/formDesignController/findBpmReFormEntityBySameSeries",
		queryParams: {
			'sameSeries': sameSeries
		},
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		pageSize : 10
	});
});

/**
 * 重新加载流程设计列表数据
 */
function reloadTableData() {
	$('#formList').datagrid('reload', {
		'sameSeries':sameSeries
	});
	$('#formList').datagrid('clearSelections'); //清空选中的行
}

/**
 * 操作单元格图标点击事件
 * @param index 所点击的图标所在行索引
 * @param action 动作标识 detial： 打开明细弹窗 update:打开修改弹窗 
 * 				 	   delete：执行删除操作
 */
function imgClick(index, action){
	$('#formList').datagrid('clearSelections'); //清空选中的行
	$('#formList').datagrid('selectRow', index); //根据行索引选中一行
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	if(action == 'detial'){
		detail();
	}else if(action == 'update'){
		update();
	}else if(action == 'publish'){
		publish();
	}else if(action == 'delete'){
		delele();
	}else if(action == 'swzbb'){
		setMainVersion();
	}
}

/**
 * 打开明细弹窗
 */
function detail(){
	var data = $('#formList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('提示', '请选择单行记录查看！', 'info');
			return;
		}
		var id = data[0].id;
		window.parent.$('#iframe_').attr('src', "${ctx}/formDesignController/toFormDetial?divId=dialog_&id="+id);
		window.parent.$('#dialog_').dialog({    
		    title: '业务表单明细',
		    width: 750,
		    height: 400,
		    cache: false,
		    closed : false,
		    onResize:function(){
	           window.parent.$(this).dialog('center');
	        }
		}); 
	}
}

/**
 * 批量删除选中的流程定义基本信息
 */
function delele(){
	var datas = $('#formList').datagrid('getSelections');
	if (datas == null && datas.length != 1) {
		$.messager.alert('提示', '请选择单行记录删除！', 'info');
		return;
	}
	if (datas.state_ == "1") {
		$.messager.alert('提示', '表单已发布，不能删除！', 'info');
		return;
	}
	$.messager.confirm('提示', '确定删除吗?', function(r) {
		if (r) {
			var ids = [];
			$(datas).each(function(index) {
				ids[index] = datas[index].id;
			});
			$.ajax({
				url : '${ctx}/formDesignController/doDeleteBpmReFormByIds',
				dataType : 'text',
				data : {'ids' : ids},
				success : function(data){
					if( data == 'Y' ){
						window.parent.$.messager.show({title : '提示',msg : '删除成功！',timeout : 2000});
						reloadTableData();
						window.parent.reloadTableData();
					}else{
						window.parent.$.messager.show({title : '提示',msg : '删除失败！',timeout : 2000});
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
	var data = $('#formList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('提示', '请选择单行记录修改！','info');
			return;
		}
		var id = data[0].id;
		window.parent.$('#iframe_').attr('src', "${ctx}/formDesignController/toFormUpdate?divId=dialog_&id="+id);
		window.parent.$('#dialog_').dialog({    
		    title: '编辑业务解决方案',
		    width: 800,
		    height: 400,
		    cache: false,
		    closed : false,
		    onResize:function(){
	           window.parent.$(this).dialog('center');
	        }
		}); 
	}
}

function publish(){
	var datas = $('#formList').datagrid('getChecked');
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
					window.parent.$.messager.show({title : '提示',msg : data.msg,timeout : 2000});
					reloadTableData();
					window.parent.reloadTableData();
				}else{
					window.parent.$.messager.show({title : '提示',msg : data.msg,timeout : 2000});
				}
			}
		}); 
	}
}

/**
 * 设置主版本
 */
function setMainVersion(){
	var data = $('#formList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('设置主版本', '请选择单行记录修改！');
			return;
		}
		if (data[0].state_ != "1") {
			$.messager.alert('设置主版本', '请先发布该表单！');
			return;
		}
		var mainVersion = data[0].mainVersion_;
		if( mainVersion == 'YES'){
			$.messager.alert('设置主版本', '该记录已经是主版本！');
			return;
		}
		var id = data[0].id;
		var key = data[0].key_;
		var sameSeries = data[0].sameSeries_;
		$.ajax({
			url : '${ctx}/formDesignController/setMainVersion',
			type : 'post',
			dataType : 'text',
			data : {
				'id': id,
				'key' : key,
				'sameSeries' : sameSeries
			},
			success : function(data) {
				if( data == 1){
					window.parent.$.messager.show({title : '设置主版本',msg : '设置成功！',timeout : 2000});
					reloadTableData();
					window.parent.reloadTableData();
				} else {
					window.parent.$.messager.show({title : '设置主版本',msg : '设置失败！',timeout : 2000});
				}
			}
		});
		 
	}
}

function closeDig(){
	window.parent.closeDialog('dialog');
}

function formatterOpert (val, row, index){
	return '<table border="0" width="100%"><tr>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/formdesign/img/detail.png"  title="明细" onclick="imgClick(\''+index+'\',\'detial\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/formdesign/img/edit.png" title="编辑" onclick="imgClick(\''+index+'\',\'update\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/formdesign/img/icon-start.png" title="发布" onclick="imgClick(\''+index+'\',\'publish\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/formdesign/img/main.png" title="版本控制" onclick="imgClick(\''+index+'\',\'swzbb\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/formdesign/img/remove.png" title="删除" onclick="imgClick(\''+index+'\',\'delete\')"/></td>'
			+'</tr></table>';
}

function formatterState (value, row, index) {
	var state = '';
	if(value == '0'){
		state = '初始化';
	}
	if(value == '1'){
		state = '已发布';
	}
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

 </script>
</html>