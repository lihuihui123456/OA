<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>流程定义管理</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" style="width:100%;height:98%">
	<!-- 页面布局西部 -->
	<div data-options="region:'west',split:false" title="流程定义类别" style="width:200px;padding-bottom: 20px">
		<!-- 流程定义类别树 -->
		<ul class="easyui-tree" id="procDefCategoryTree"></ul>
		
		<!-- 流程定义类别树右击菜单  -->
		<div id="procdsgnCtlgMenu" class="easyui-menu" closed="true" style="width:120px;">
			<div id="addMenu" onclick="addProcdsgnCtlg('brother')" data-options="iconCls:'icon-add'">添加本级类别</div>
			<div onclick="addProcdsgnCtlg('child')" data-options="iconCls:'icon-add'">添加下级类别</div>
			<div onclick="editProcdsgnCtlg()" data-options="iconCls:'icon-edit'">编辑类别</div>
			<div id="delMenu" onclick="delProcdsgnCtlg()" data-options="iconCls:'icon-remove'">删除类别</div>
		</div>
		
		<!-- 流程定义类别新增/修改窗口 -->
		<div id="procdsgnCtlgDlg" class="easyui-dialog" closed="true" title="" style="width:300px;height:290px;padding:10px">
			<form id="procdsgnCtlgFm">
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
					<input class="easyui-textbox" id="modelCtlgName_" name="modelCtlgName_"
						data-options="required:true" missingMessage="不能为空" style="width:100%;height:32px">
					</div>
				<div style="margin-bottom:5px">
					<div>类别描述:</div>
					<input class="easyui-textbox" data-options="multiline:true" id="desc_" name="desc_"
						style="width:100%;height:100px">
				</div>
				<div>
					<a href="javascript:void(0)" onclick="saveProcdsgnCtlg()" class="easyui-linkbutton"
						iconCls="icon-ok" style="width:100%;height:32px">保存</a>
				</div>
			</form>
		</div>
	</div>
	
	<!-- 页面布局中部 -->
	<div data-options="region:'center',title:'流程定义信息'" style="padding:5px;">
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
			<a href="javascript:void(0)" onclick="exportBpmn()"
				class="easyui-linkbutton" iconCls="icon-redo" id="btn_exp" plain="true">导出</a>
			<a href="javascript:void(0)" onclick="importBpmn()"
				class="easyui-linkbutton" iconCls="icon-undo" plain="true">上传</a>
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
				class="easyui-linkbutton" iconCls="icon-add" plain="true">上传BPMN设计文件</a>
			<a href="javascript:void(0)" id="mb" class="easyui-menubutton"
				data-options="menu:'#tool',iconCls:'icon-edit'">工具</a>
			<div id="tool" style="width: 150px;">
				<div data-options="iconCls:'icon-undo'">保存当前方案</div>
				<div data-options="iconCls:'icon-redo'">保存为新方案</div>
				<div data-options="iconCls:'icon-redo'">导出</div>
			</div> -->
			<div style="padding:3px">
				<span>查询条件：</span>
				<select class="easyui-combobox" value="" id="zd" data-options="editable:false,panelHeight:'auto',width:200" >
					<option value="">请选择</option>
					<option value="name_">标题</option>
					<option value="key_">标志key</option>
				</select>
				<select class="easyui-combobox" value="" id="tj"  data-options="editable:false,panelHeight:'auto',width:200">
					<option value="">请选择</option>
					<option value="equal">等于</option>
					<option value="fuzzy">模糊匹配</option>
					<option value="left_fuzzy">左模糊匹配</option>
					<option value="right_fuzzy">右模糊匹配</option>
				</select>
				<input class="easyui-textbox" id="searchValue"  >
				<a href="javascript:void(0)" onclick="searchData()" data-options="iconCls:'icon-search'"
				class="easyui-linkbutton" plain="true">查询</a>
				<a href="javascript:void(0)" onclick="reloadTableData()"
				class="easyui-linkbutton" plain="true">清空查询</a>
			</div>
		</div>
		
		<!-- 流程定义列表 -->
		<table class="easyui-datagrid" id="procdsgnList" data-options="method : 'post',idField : 'id',striped : true,fitColumns : true,
                fit:true,singleSelect : true,rownumbers : true,
                pagination : true,nowrap : false,toolbar : '#toolbar',showFooter : true,">
			 <thead frozen="true">    
		        <tr>    
		            <th data-options="field :'ck',checkbox:true"></th>
                    <th data-options="field :'procdefId_',hidden:true,"></th>
                    <th data-options="field :'deploymentId_',hidden:true"></th>
                    <th data-options="field :'modelId_',hidden:true"></th>
					<th data-options="field :'id',align:'center',formatter: formatterOperate,width:140">操作</th>  
		        </tr>    
		    </thead> 
			<thead>
				<tr>
					<th data-options="field :'name_',width:200,align:'left'">标题</th>
					<th data-options="field :'key_',title:'标志Key',width:80,align:'center'">标识Key</th>
					<th data-options="field :'state_',width:50,align:'center',formatter:formatterState_">状态</th>
					<!-- <th data-options="field :'mainVersion_',width:80,align:'center'">主版本</th> -->
					<th data-options="field :'version_',width:80,align:'center'">主版本号</th>
					<th data-options="field:'createTime_',width:150,align:'center',formatter: formatterDateTime">创建时间</th>
				</tr>
			</thead>
		</table>
		
		<!-- 流程定义新增编辑窗口 -->
		<div id="procdsgnDlg" style="overflow:hidden" closed="true" data-options="cache:false,modal:true">
			<iframe scrolling="no" id="iframe" frameborder="0" width="100%" height="100%"></iframe>
		</div>
		
		<!-- 流程定义新增编辑窗口 -->
		<div id="procdsgnDlg_" style="overflow:hidden" data-options="cache:false,modal:true">
			<iframe scrolling="no" id="iframe_" frameborder="0" width="100%" height="100%"></iframe>
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
/**初始化流程定义类别树*/
function InitTreeData() {
	$("#procDefCategoryTree").tree({
		url : '${ctx}/procDefController/findProcDefCategory',
		animate : true, //开启折叠动画
		onLoadSuccess : function(node,data){
			if(data[0].children !=null ){
				var target = data[0].children[0];//获取根节点下的第一个节点
				if( target != null ) {
					procdsgnCtlgId = target.id;
					$("#procDefCategoryTree").tree("select", target);//相当于默认点击了一下该节点，执行onSelect方法   
					$("#procDefCategoryTree li:eq('1')").find("div").eq('0').addClass("tree-node-selected");//设置该树第一个子点高亮   
				}
			}
			InitTableData();
		},
		//单击事件
		onClick : function(node, data) {
			procdsgnCtlgId = node.id;
			reloadTableData();
		},
		//右击事件
		onContextMenu : function(e, node) {
			e.preventDefault();
			$("#procDefCategoryTree").tree('select', node.target);
			if( node.parent_id != null && node.parent_id!="" && node.children ==null ){
				$("#addMenu").show();
				$("#delMenu").show();
			}else if( node.parent_id != null && node.parent_id!="" && node.children !=null ){
				$("#addMenu").show();
				$("#delMenu").hide();
			}else{
				$("#addMenu").hide();
				$("#delMenu").hide();
			}
			$('#procdsgnCtlgMenu').menu('show', {
				left : e.pageX,
				top : e.pageY
			});
		}
	});
}

/**
  添加、更新 类别动作标识
	add : 新增 update ：更新
	var action = '';
*/
/**
 * 添加流程设计类别（打开添加对话框）
 * @param level 类别等级 brother：同级 child:子级
 */
function addProcdsgnCtlg(level) {
	$("#procdsgnCtlgFm").form('clear');
	var node = $("#procDefCategoryTree").tree('getSelected');
    var pid = '';
	if (level == 'brother') {// 添加同级节点
		pid = node.parent_id;
	} 
	if (level == 'child') {// 添加子节点
		pid = node.id;
	} 
	$("#parentId_").val(pid);
	$("#procdsgnCtlgDlg").dialog({    
		title: '新增类别',
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
 * 打开编辑流程定义类别窗口
 */
function editProcdsgnCtlg() {
	var node = $("#procDefCategoryTree").tree('getSelected');
	var id = node.id;
	if (node) {
		$.ajax({
			url : "${ctx}/procDefController/findProcDefById",
			type : "post",
			dataType : "json",
			data : { "categoryId" : id },
			success : function(data) {
				$("#procdsgnCtlgFm").form('load',{
					id:data.id,
					parentId_:data.parentId_,
					modelCtlgName_:data.modelCtlgName_,
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
				$("#procdsgnCtlgDlg").dialog({    
					title: '修改类别',
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
 * 流程设计类别新增/修改保存方法
 */
function saveProcdsgnCtlg() {
	if($("#procdsgnCtlgFm").form("validate")){
		$.ajax({
			url : "${ctx}/procDefController/doSaveProcDefCategory",
			type : 'post',
			dataType : 'json',
			async: false,
			data : $("#procdsgnCtlgFm").serialize(),
			success : function(data) {
				var msg = '';
				if(data){
					if(action == 'add'){
						msg = '新增成功！'
					}else{
						msg = '更新成功！'
					}
					$("#procdsgnCtlgDlg").dialog('close');
					$.messager.show({title:'提示', msg:msg,timeout:2000});
					InitTreeData();
				}else{
					if(action == 'add'){
						msg = '新增失败！'
					}else{
						msg = '更新失败！'
					}
					$.messager.show({title:'提示', msg:msg,timeout:2000});
				}
			}
		});
	}
}

/**
 * 删除流程设计类别
 */
function delProcdsgnCtlg() {
	var node = $("#procDefCategoryTree").tree('getSelected');
	var id = '';
	if (node == null) {
		$.messager.alert('删除流程设计类别', '请选择操作项！');
		return;
	} else if (node.children != null) {
		$.messager.alert('删除流程设计类别', '父级节点不可删除！');
		return;
	} else {
		$.messager.confirm('删除流程设计类别', '确定删除吗?', function(r) {
			if (r) {
				id = node.id
				$.ajax({
					url : "${ctx}/procDefController/doDelProcDefCategory",
					type : 'post',
					data : {"categoryId" : id},
					dataType : 'text',
					async: false,
					success : function(data){
						if(data == 'Y'){
							$.messager.show({title:'提示', msg:'删除成功',timeout:2000});
							InitTreeData();
						}else if(data == 'N'){
							$.messager.show({title:'提示', msg:'删除失败',timeout:2000});
						}else{
							$.messager.show({title:'提示', msg:'该类别下存在流程定义，不能删除！',timeout:2000});
						} 
					}
				});
			}
		});
	}
}


/**初始化流程定义列表*/
function InitTableData() {
	$('#procdsgnList').datagrid({
		url : "${ctx}/procDefController/findAllDatabyCategoryId",
		queryParams: {
			"categoryId":procdsgnCtlgId,
			"searchValue" : '',
			"zd" : '',
			"tj" : ''
		},
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
        pageSize : 10
	});
}

/**
 * 重新加载流程设计列表数据
 */
function reloadTableData() {
	$('#zd').combobox('setValues',"");//搜索字段
	$('#tj').combobox('setValues',"");//搜索条件
	$('#searchValue').textbox("setValue",'');
	$('#procdsgnList').datagrid('reload', {
		"categoryId":procdsgnCtlgId
	});
	$('#procdsgnList').datagrid('clearSelections'); //清空选中的行
}

/**
 * 打开明细弹窗
 */
function detail(){
	var data = $('#procdsgnList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			//$.messager.alert('查看流程设计管理明细', '请选择单行记录查看！');
			layer.tips('请选择单行记录查看', '#btn_view', { tips: 3 });
			return;
		}
		var modelExtId = data[0].id;
		var deploymentId = data[0].deploymentId_;
		$('#iframe').attr('src', "${ctx}/procDefController/toProcDefDetialPage?divId=procdsgnDlg&modelExtId="+modelExtId+"&deploymentId="+deploymentId);
		$('#procdsgnDlg').dialog({    
		    title: '流程定义明细',
		    width: 700,
		    height: 450,
		    closed: false,
			cache: false,
			modal: true,
			onResize: function() {
				$(this).dialog('center');
			}
		}); 
	}
}

/**
 * 打开新增流程设计基本信息弹出框
 */
function add(){
	$("#iframe").attr('src', "${ctx}/procDefController/toProcDefAddPage?divId=procdsgnDlg&categoryId="+procdsgnCtlgId);
	$("#procdsgnDlg").dialog({    
	    title: '新增流程定义',
	    width: 720,
	    height: 350,
	    closed: false,
		cache: false,
		modal: true,
		onResize: function() {
			$(this).dialog('center');
		}
	}); 
}

/**
 * 打开版本控制弹出框
 */
function version(){
	var data = $('#procdsgnList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('查看流程设计管理明细', '请选择单行记录查看！');
			return;
		}
		var key = data[0].key_;
		$('#iframe').attr('src', "${ctx}/procDefController/procdefInfoVersion?key="+key);
		$('#procdsgnDlg').dialog({    
		    title: '流程定义版本控制',
		    width: 720,
		    height: 450,
		    onResize:function(){
               $(this).dialog('center');
            }
		});
		$('#procdsgnDlg').dialog('open');
	}
}

/**
 * 批量删除选中的流程设计基本信息
 */
function delele(){
	var datas = $('#procdsgnList').datagrid('getSelections');
	if (datas == null || datas.length != 1) {
		//$.messager.alert('提示', '请选择单行记录进行删除！', 'info');
		layer.tips('请选择单行记录进行删除', '#btn_del', { tips: 3 });
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
						$.messager.show({title:'提示',msg:data.msg,timeout:2000,});
						reloadTableData();
					}else if(data.flag == 'warn'){
						window.parent.$.messager.alert("提示", data.msg, "info");
					}else{
						$.messager.show({title:'提示',msg:data.msg,timeout:2000,});
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
	var data = $('#procdsgnList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			//$.messager.alert('修改流程定义', '请选择单行记录修改！');
			layer.tips('请选择单行记录修改', '#btn_edit', { tips: 3 });
			return;
		}
		var id = data[0].id;
		$("#iframe").attr("src", "${ctx}/procDefController/toProcDefEditPage?divId=procdsgnDlg&id="+id);
		$("#procdsgnDlg").dialog({    
		    title: '修改流程定义',
		    width: 720,
		    height: 350,
		    closed: false,
			cache: false,
			modal: true,
			onResize: function() {
				$(this).dialog('center');
			}
		}); 
	}
}

/**
 * 列表搜索方法
 */
function searchData(){
	var searchValue  = $('#searchValue').val();//搜索值
	var zd = $('#zd').combobox('getValue');//搜索字段
	var tj = $('#tj').combobox('getValue');//搜索条件
	$('#procdsgnList').datagrid('reload', {
		'categoryId':procdsgnCtlgId,
		'searchValue' : searchValue,
		'zd' : zd,
		'tj' : tj
	});
}

/**
 * 关闭弹出的dialog
 */
function closeDialog(divId){
	$('#'+divId+'').dialog('close');
}


function exportBpmn(){
	var data = $("#procdsgnList").datagrid("getChecked");
	if (data) {
		if (data.length != 1) {
			//$.messager.alert('提示', '请选择单行记录导出！');
			layer.tips('请选择单行记录导出', '#btn_exp', { tips: 3 });
			return;
		}
		var deploymentId = data[0].deploymentId_;
		if(deploymentId == null || deploymentId == ""){
			$.messager.alert('提示', '请先部署该流程！');
			return;
		}
		location.href="${ctx}/procDefController/exportBpmn?deploymentId=" + deploymentId;
		
	}
}

function importBpmn(){
	$('#iframe').attr('src', "${ctx}/procDefController/toBpmnUpload?procCtlgId="+procdsgnCtlgId);
	$('#procdsgnDlg').dialog({    
	    title: '文件上传',
	    width: 350,
	    height: 250,
	    onResize:function(){
	       $(this).dialog('center');
	    }
	}); 
	$('#procdsgnDlg').dialog('open');
}

/****************************************data**************************************/

function formatterOperate(value,row,index){
	return '<table border="0" width="100%"><tr>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/procdef/img/detail.png"  title="明细" onclick="imgClick(\''+index+'\',\'detial\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/procdef/img/edit.png" title="编辑" onclick="imgClick(\''+index+'\',\'update\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/procdef/img/flow-design.png" title="设计" onclick="imgClick(\''+index+'\',\'design\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/procdef/img/icon-start.png" title="部署" onclick="imgClick(\''+index+'\',\'deploy\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/procdef/img/version.png" title="版本控制" onclick="imgClick(\''+index+'\',\'bbkz\')"/></td>'
			//+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/procdef/img/upload.png" title="上传新版本BPMN文件" onclick="imgClick(\''+index+'\',\'scwj\')"/></td>'
			+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/procdef/img/remove.png" title="删除" onclick="imgClick(\''+index+'\',\'delete\')"/></td>'
		+'</tr></table>';
}


function formatterState_(value,row,index){
	var message = '';
	if( value == "0" ){
		message = '初始化';
	}else{
		message = '已部署';
	}
	return message;
}

function formatterDateTime(value,row,index){
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

/**
 * 操作单元格图标点击事件
 * @param index 所点击的图标所在行索引
 * @param action 动作标识 detial： 打开明细弹窗 
 *						 update:打开修改弹窗 
 * 				 	     delete：执行删除操作
 */
function imgClick(index, action){
	$('#procdsgnList').datagrid('clearSelections'); //清空选中的行
	$('#procdsgnList').datagrid('selectRow', index); //根据行索引选中一行
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	if(action == 'detial'){
		detail();
	}else if(action == 'update'){
		update();
	}else if(action == 'delete'){
		delele();
	}else if(action == 'bbkz'){
		version();
	}else if(action == 'scwj'){
		alert("上传文件功能正在研发！");
	}else if(action == "design") {
		var data = $('#procdsgnList').datagrid('getChecked');
		openWindow(data[0].modelId_);
	}else if(action == "deploy") {
		var data = $('#procdsgnList').datagrid('getChecked');
		deploy(data[0].modelId_);
	}
}

function deploy(modelId){
	//异步请求后台部署资源
	$.ajax({
		url: "${ctx}/procDefController/doDeployProcDef",
		type: "post",
		dataType: "json",
		async: false,
	    data: {
	    	"modelId" : modelId
	    },
	    success:function(data) {
	    	if(data != null){
		    	if(data.flag == "true") {
		    		$.messager.show({title:'提示',msg:data.msg,timeout:2000,});
					reloadTableData();
		    	}else{
		    		window.parent.$.messager.alert("提示", data.msg, "info");
		    	}
	    	}
	    }
	});
}

function openWindow(id){
	var url = "${ctx}/views/cap/bpm/modeler.html?modelId="+id;
	var time = new Date().getTime();
	window.open (url,'newwindow'+time,'width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)+
			',top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no'); 
}
</script>
</html>