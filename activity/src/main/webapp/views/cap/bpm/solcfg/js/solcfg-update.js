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
		},
		//右击事件（用于打开树右击菜单）
		onContextMenu : function(e, node) {
			e.preventDefault();
			$('#bizSolCtlgTree').tree('select', node.target);
			//根据节点控制菜单显示内容
			if( node.parent_id != null && node.children ==null ){
				$("#addMenu").show();
				$("#delMenu").show();
			}else if( node.parent_id != null && node.children !=null ){
				$("#addMenu").show();
				$("#delMenu").hide();
			}else{
				$("#addMenu").hide();
				$("#delMenu").hide();
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
/**
 * 添加流程定义类别（打开添加对话框）
 * @param level 类别等级 brother：同级 child:子级
 */
function addBizSolCtlg(level) {
	var node = $('#bizSolCtlgTree').tree('getSelected');
    var pid = '';
	if (level == 'brother') {// 添加同级节点
		pid = node.parent_id;
	} else {// 添加子节点
		pid = node.id;
	}
	$('#bizSolCtlg').form('clear');
	document.getElementById("parentId_").value = pid;
	$('#bizSolCtlgDlg').dialog({title: "新增类别"});
	$('#bizSolCtlgDlg').dialog('open');
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
			url : '../bizSolMgr/findBizSolCtlgById',
			type : 'post',
			dataType : 'json',
			data : { 'id' : id },
			success : function(data) {
				$('#bizSolCtlg').form('load',{
					id:data.id,
					parentId_:data.parentId_,
					solCtlgName_:data.solCtlgName_,
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
				$('#bizSolCtlgDlg').dialog({title: "修改类别"});
				$('#bizSolCtlgDlg').dialog('open');
				action = 'update';
			}
		});
	}
}

/**
 * 流程定义类别新增/修改保存方法
 */
function doSaveBizSolCtlg() {
	var id = $("#id").val();
	var url = '';
	$.ajax({
		url : '../bizSolMgr/doSaveBizSolCtlg',
		type : 'post',
		dataType : 'text',
		data : $('#bizSolCtlg').serialize(),
		success : function(data) {
			var title;
			var msg;
			if( data=='Y' ){
				if(action == 'add'){
					title = '新增业务解决方案';
					msg = '新增成功!';
				}else{
					title = '修改业务解决方案';
					msg = '修改成功!';
				}
				$.messager.show({
					title : title,
					msg : msg,
					timeout:2000,
				});
				$('#bizSolCtlgDlg').dialog('close');
				InitTreeData();
			}else{
				if(action == 'add'){
					title = '新增业务解决方案';
					msg = '新增失败!';
				}else{
					title = '修改业务解决方案';
					msg = '修改失败!';
				}
				$.messager.show({
					title:title,
					msg:msg,
					timeout:2000,
				});
			}
		}
	});
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
		$.messager.confirm('删除业务流程解决方案类别', '确定删除吗?', function(r) {
			if (r) {
				id = node.id
				$.ajax({
					url : '../bizSolMgr/doDeleteBizSolCtlgById',
					type : 'post',
					data : { 'id' : id},
					dataType : 'text',
					success : function(data){
						if( data == 'Y' ){
							$.messager.show({ title:'提示', msg:'删除成功'});
							InitTreeData();
						}else{
							$.messager.show({ title:'提示', msg:'删除失败'});
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
		url : '../bizSolMgr/findBizSolInfoIdByCtlgId',
		singleSelect: true,
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
 * 重新加载流程定义列表数据
 */
function reloadTableData() {
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
	}else if(action == 'update'){
		update();
	}else if(action == 'delete'){
		delele();
	}else if(action == 'bbkz'){
		version();
	}else if(action == "fapz"){
		var data = $('#bizSolInfoList').datagrid('getChecked');
		var id = data[0].id;
		var url = '../bizSolMgr/toschmcnfg?id='+id;
		if(id!=null) {
			window.parent.addTab(data[0].solName_+"-方案配置",url);
		}
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
		    height: 500,
		    cache: false,
		    closed : false
		}); 
	}
}

/**
 * 打开新增流程定义基本信息弹出框
 * @param mode 新增方式  new：新建  copy：复制新增
 */
function add(){
	var src = 'bizSolMgr/addBizSol?bizSolCtlgId='+bizSolCtlgId;
	$('#iframe').attr('src', src);
	$('#bizSolInfoDlg').dialog({    
	    title: '新增业务解决方案',
	    width:650,
	    height: 300,
	    cache: false,
	    closed : false
	});
}

/**
 * 批量删除选中的流程定义基本信息
 */
function delele(){
	var datas = $('#bizSolInfoList').datagrid('getSelections');
	if (datas == null || datas.length == 0) {
		$.messager.alert('提示', '请选择要删除的记录！', 'info');
		return;
	}
	$.messager.confirm('删除业务解决方案', '确定删除吗?', function(r) {
		if (r) {
			var ids = [];
			$(datas).each(function(index) {
				ids[index] = datas[index].id;
			});
			$.ajax({
				url : '../bizSolMgr/doDeleteBizSolInfosByIds',
				dataType : 'text',
				data : {
					'ids' : ids
				},
				success : function(data){
					if( data == 'Y' ){
						$.messager.show({
							title : '删除业务解决方案',
							msg : '删除成功！',
							timeout : 2000
						});
						reloadTableData();
					}else{
						$.messager.show({
							title : '删除业务解决方案',
							msg : '删除失败！',
							timeout : 2000
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
function update(){
	var data = $('#bizSolInfoList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('提示', '请选择单行记录修改！','info');
			return;
		}
		var id = data[0].id;
		var src = '../bizSolMgr/updateBizSol?module=index&id='+id;
		$('#iframe').attr('src', src);
		$('#bizSolInfoDlg').window({    
		    title: '编辑业务解决方案',
		    width: 650,
		    height: 300,
		    cache: false,
		    closed : false
		}); 
	}
}
/**
 * 关闭弹出的dialog
 */
function closeDialog(){
	$('#bizSolInfoDlg').dialog('close');
}



function formatterOpert (val, row, index){
	return '<table border="0" width="100%"><tr>'
			+'<td><img src="../views/cap/bpm/bizsolmgr/img/detail.png"  title="明细" onclick="imgClick(\''+index+'\',\'detial\')"/></td>'
			+'<td><img src="../views/cap/bpm/bizsolmgr/img/mgr.png" title="方案配置" onclick="imgClick(\''+index+'\',\'fapz\')"/></td>'
			+'<td><img src="../views/cap/bpm/bizsolmgr/img/icon-start.png" title="启动流程" onclick="imgClick(\''+index+'\',\'qdlc\')"/></td>'
			+'<td><img src="../views/cap/bpm/bizsolmgr/img/edit.gif" title="编辑" onclick="imgClick(\''+index+'\',\'update\')"/></td>'
			+'<td><img src="../views/cap/bpm/bizsolmgr/img/remove.gif" title="删除" onclick="imgClick(\''+index+'\',\'delete\')"/></td>'
			+'</tr></table>';
}

function formatterTime (value, row, index) {
	return value.substr(0,19);
}
