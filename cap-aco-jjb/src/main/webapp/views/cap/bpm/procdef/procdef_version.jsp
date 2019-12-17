<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>流程定义版本控制</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" style="width:100%;height:100%">
	<div data-options="region:'center',heigh:'auto'">
		<table class="easyui-datagrid" id="procdef_version_List" style="width:100%;height: 100%"></table>
	</div>
	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="closeDig()"  plain="true">关闭</a>
		</div>
	</div>
</body>
<script type="text/javascript">
var mainVersionId = "";
$(function(){
	$('#procdef_version_List').datagrid({
		url : "${ctx}/procDefController/findAllDataByKey",
		queryParams: {
			'key': "${key}"
		},
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
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
			{ field : 'modelId_', hidden : true}, 
			{ field : 'procdefId_', hidden:true}, 
			{ field : 'id', width : 100, title : '操作',align : 'center',formatter: function(value,row,index){
				return '<table border="0" width="100%"><tr>'
				+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/procdef/img/detail.png"  title="明细" onclick="imgClick(\''+index+'\',\'detial\')"/></td>'
				+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/procdef/img/edit.png" title="编辑" onclick="imgClick(\''+index+'\',\'update\')"/></td>'
				+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/procdef/img/flow-design.png" title="设计" onclick="imgClick(\''+index+'\',\'design\')"/></td>'
				+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/procdef/img/main.png" title="设为主版本" onclick="imgClick(\''+index+'\',\'swzbb\')"/></td>'
				+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/procdef/img/remove.png" title="删除" onclick="imgClick(\''+index+'\',\'delete\')"/></td>'
				+'</tr></table>';
			}}
        ]],
		columns : [[ 
		    { field : 'name_', title : '标题', width : 200, align : 'left' }, 
		    { field : 'key_', title : '标志Key', width : 80, align : 'center' }, 
		    { field : 'state_', title : '状态', width : 80, align : 'center',
		    	formatter: function(value,row,index){
		    		if(value != null && value != "0"){
		    			return "已部署";
		    		}else{
		    			return "初始化";
		    		}
		    	}		
		   	},
		    { field : 'version_', title : '版本号', width : 50, align : 'center', }, 
		    { field : 'mainVersion_', title : '是否主版本', width : 80, align : 'center',
		    	formatter: function(value,row,index){
		    		if(value != null && value == "Y"){
		    			mainVersionId = row.id;
		    			return "是";
		    		}else{
		    			return "否";
		    		}
		    	}		
		   	},
		    { field : 'createTime_', title : '创建日期', width : 150, align : 'center', 
		    	formatter: function(value,row,index){
		    		if(value != null && value != ""){
			    		var now = new Date(value);
			    		var yy = now.getFullYear();      //年
			    		var mm = now.getMonth() + 1;     //月
			    		var dd = now.getDate();          //日
			    		var hh = now.getHours();         //时
			    		var ii = now.getMinutes();       //分
			    		var ss = now.getSeconds();       //秒
			    		var clock = yy + "-";
			    		if(mm < 10) clock += "0";
			    			clock += mm + "-";
			    		if(dd < 10) clock += "0";
			    			clock += dd + " ";
			    		if(hh < 10) clock += "0";
			    			clock += hh + ":";
			    		if (ii < 10) clock += '0'; 
			    			clock += ii + ":";
			    		if (ss < 10) clock += '0'; 
			    			clock += ss;
						return  clock;
		    		}
		    	}
		    } 
		]]
	});
});

/**
 * 重新加载流程设计列表数据
 */
function reloadTableData() {
	$('#procdef_version_List').datagrid('reload', {
		'key':"${key}"
	});
	$('#procdef_version_List').datagrid('clearSelections'); //清空选中的行
}

/**
 * 操作单元格图标点击事件
 * @param index 所点击的图标所在行索引
 * @param action 动作标识 detial： 打开明细弹窗 update:打开修改弹窗 
 * 				 	   delete：执行删除操作
 */
function imgClick(index, action){
	$('#procdef_version_List').datagrid('clearSelections'); //清空选中的行
	$('#procdef_version_List').datagrid('selectRow', index); //根据行索引选中一行
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	if(action == 'detial'){
		detail();
	}else if(action == 'update'){
		update();
	}else if(action == 'delete'){
		delele();
	}else if(action == 'swzbb'){
		version();
	}else if(action == 'scwj'){
		alert("上传文件功能正在研发！");
	}else if(action == "design"){
		var data = $('#procdef_version_List').datagrid('getChecked');
		var id = data[0].modelId_;
		if(id!=null) {
			window.parent.openWindow(id);
		}
	}
}

/**
 * 打开明细弹窗
 */
function detail(){
	var data = $('#procdef_version_List').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('查看流程设计管理明细', '请选择单行记录查看！');
			return;
		}
		var modelExtId = data[0].id;
		var deploymentId = data[0].deploymentId_;
		window.parent.$('#iframe_').attr('src', "${ctx}/procDefController/toProcDefDetialPage?divId=procdsgnDlg_&modelExtId="+modelExtId+"&deploymentId="+deploymentId);
		window.parent.$('#procdsgnDlg_').dialog({    
		    title: '流程流程定义明细信息',
		    width: 850,
		    height: 450,
		    closed: false,
			cache: false,
			modal: true,
			onResize: function() {
				window.parent.$(this).dialog('center');
			}
		}); 
	}
}


/**
 * 批量删除选中的流程设计基本信息
 */
function delele(){
	var datas = $('#procdef_version_List').datagrid('getSelections');
	if (datas == null || datas.length != 1) {
		$.messager.alert('提示', '请选择单行记录进行删！', 'info');
		$.messager.alert('删除流程设计管理', '请选择要删除的记录！');
		return;
	}
	$.messager.confirm('删除流程设计管理', '确定删除吗?', function(r) {
		if (r) {
			var id = datas[0].id;
			var procDefId = datas[0].procdefId_;
			$.ajax({
				url : "${ctx}/procDefController/doDelProcDef",
				dataType : 'json',
				data : {
					"id" : id,
					"procDefId" : procDefId
				},
				async: false,
				success : function(data) {
					if(data.flag == 'true'){
						window.parent.$.messager.show({title:'提示',msg:data.msg,timeout:2000});
						reloadTableData();
						window.parent.reloadTableData();
					}else if(data.flag == 'warn'){
						window.parent.$.messager.alert("提示", data.msg, "info");
					}else{
						window.parent.$.messager.show({title:'提示',msg:data.msg,timeout:2000,});
					}
				}
			});
		}
	});
}

/**
 * 打开流程设计基本信息修改弹窗
 */
function update(){
	var data = $('#procdef_version_List').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('修改流程设计', '请选择单行记录修改！');
			return;
		}
		var id = data[0].id;
		var src = '${ctx}/procDefMgr/procdefInfoEditPage?mode=update&divId=procdsgnDlg_&id='+id;
		window.parent.$("#iframe_").attr("src", "${ctx}/procDefController/toProcDefEditPage?divId=procdsgnDlg_&id="+id);
		window.parent.$("#procdsgnDlg_").dialog({    
		    title: '修改流程定义',
		    width: 650,
		    height: 350,
		    closed: false,
			cache: false,
			modal: true,
			onResize: function() {
				window.parent.$(this).dialog('center');
			}
		}); 
	}
}

/**
 * 打开流程设计基本信息修改弹窗
 */
function version(){
	var data = $('#procdef_version_List').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert("提示", "请选择单行记录修改！", "info");;
			return;
		}
		var mainVersion = data[0].mainVersion_;
		if( mainVersion !=null && mainVersion == 'Y'){
			$.messager.alert("提示", "该记录已经是主版本！", "info");
			return;
		}
		var id = data[0].id;
		$.ajax({
			url : "${ctx}/procDefController/doUpdateMainVersion",
			type : "post",
			dataType : "json",
			data : {
				"id" : id,
				"mainVersionId" : mainVersionId
			},
			success : function(data) {
				if(data.flag == "true" ){
					mainVersionId = id;
					window.parent.$.messager.show({title:'提示',msg:data.msg,timeout:2000});
					reloadTableData();
					window.parent.reloadTableData();
				} else {
					window.parent.$.messager.alert("提示", data.msg, "info");
				}
			}
		});
		 
	}
}

function closeDig(){
	window.parent.closeDialog('procdsgnDlg');
}
</script>
</html>