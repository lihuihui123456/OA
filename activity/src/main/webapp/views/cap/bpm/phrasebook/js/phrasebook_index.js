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
		url : '../bpmPhrasebook/findPhrasebookCtlgTree',
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
		},
		//右击事件（用于打开树右击菜单）
		onContextMenu : function(e, node) {
			e.preventDefault();
			$('#formCtlgTree').tree('select', node.target);
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
			$('#formCtlgMenu').menu('show', {
				left : e.pageX,
				top : e.pageY
			});
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
	document.getElementById("type_").value = 0;
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
			url : '../bpmPhrasebook/findPhrasebookCtlgById',
			type : 'post',
			dataType : 'json',
			data : { 'id' : id },
			success : function(data) {
				$('#formCtlg').form('load',{
					id:data.id,
					parentId_:data.parentId_,
					name_:data.name_,
					desc_:data.desc_,
					userId_ : data.userId,
					treeType_:data.treeType_,
					type_ : data.type_,
					sort_:data.sort_,
					dr_:data.dr_,
				});
				$('#formCtlgDlg').dialog({title: "修改类别"});
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
	$.ajax({
		url : '../bpmPhrasebook/doSavePhrasebookCtlg',
		type : 'post',
		dataType : 'text',
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
					msg = '修改成功!';
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
					msg = '修改失败!';
				}
				$.messager.show({title:title,msg:msg});
			}
		}
	});
}

/**
 * 删除流程定义类别
 */
function delFormCtlg() {
	var node = $('#formCtlgTree').tree('getSelected');
	var id = '';
	if (node == null) {
		$.messager.alert('提示', '请选择操作项！', 'info');
		return;
	} else if (node.children != null) {
		$.messager.alert('提示', '父级节点不可删除！', 'info');
		return;
	} else {
		$.messager.confirm('删除表单类别', '确定删除吗?', function(r) {
			if (r) {
				id = node.id
				$.ajax({
					url : '../bpmPhrasebook/doDeletePhrasebookCtlg',
					type : 'post',
					data : { 'id' : id},
					dataType : 'text',
					success : function(data){
						if( data == 'Y' ){
							$.messager.show({ title:'提示', msg:'删除成功'});
							InitTreeData();
						}else if( data == 'N' ){
							$.messager.show({ title:'提示', msg:'删除失败'});
						}else{
							$.messager.show({ title:'提示', msg:'该类别下存常用语，不能删除！'});
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
		url : '../bpmPhrasebook/findPhrasebook',
		queryParams: {
			'ctlgId': formCtlgId,
			'content' : '',
		},
		pageSize : 10
	});
}

/**
 * 重新加载流程定义列表数据
 */
function reloadTableData() {
	$('#searchValue').textbox("setValue",'');
	$('#bpmReFormList').datagrid('reload', {
		'ctlgId' : formCtlgId,
		'content' : '',
	});
	$('#bpmReFormList').datagrid('clearSelections'); //清空选中的行
}

/**
 * 列表搜索方法
 */
function searchData(){
	var content  = $('#searchValue').val();//搜索值
	$('#bpmReFormList').datagrid('reload', {
		'ctlgId':formCtlgId,
		'content' : content,
	});
}

/**
 * 打开新增流程定义基本信息弹出框
 * @param mode 新增方式  new：新建  copy：复制新增
 */
function add(){
	action = "add";
	$('#phrasebookFm').form('clear');
	$('#phrasebook').dialog({    
	    title: '新增常用语',
	    width: 400,
	    height: 220,
	    cache: false,
	    closed : false,
	    onResize:function(){
	       $(this).dialog('center');
	    }
	});
}

/**
 * 打开流程定义基本信息修改弹窗
 */
var id = "";
function update(){
	var data = $('#bpmReFormList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('提示', '请选择单行记录修改！','info');
			return;
		}
		action = "update";
		$('#phrasebookFm').form('clear');
		id = data[0].id;
		$('#content_').textbox('setValue',data[0].content_);
		$('#phrasebook').dialog({    
		    title: '新增常用语',
		    width: 400,
		    height: 220,
		    cache: false,
		    closed : false,
		    onResize:function(){
		       $(this).dialog('center');
		    }
		}); 
	}
}

function doSavePhrasebook(){
	var url;
	if(action == "add"){
		url = "../bpmPhrasebook/doSavePhrasebook";
		$.ajax({
			url : url,
			type : 'post',
			dataType : 'text',
			data : {
				ctlgId : formCtlgId,
				content : $('#content_').val()
			},
			success : function(data){
				if( data=='Y' ){
					$.messager.show({title : '提示',msg : '新增成功!'});
					$('#phrasebook').dialog('close');
					InitTreeData();
				}
			}
		});
	}else{
		url = "../bpmPhrasebook/doUpdatePhrasebook";
		$.ajax({
			url : url,
			type : 'post',
			dataType : 'text',
			data : {
				id : id,
				content : $('#content_').val()
			},
			success : function(data){
				if( data=='Y' ){
					$.messager.show({title : '提示',msg : '修改成功!'});
					$('#phrasebook').dialog('close');
					InitTreeData();
				}
			}
		});
	}
}

/**
 * 批量删除选中的流程定义基本信息
 */
function delele(){
	var datas = $('#bpmReFormList').datagrid('getSelections');
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
				url : '../bpmPhrasebook/doDeletePhrasebookByIds',
				dataType : 'text',
				data : {'ids' : ids},
				success : function(data){
					if( data == 'Y' ){
						$.messager.show({title : '删除业务解决方案',msg : '删除成功！',timeout : 2000});
						reloadTableData();
					}else{
						$.messager.show({title : '删除业务解决方案',msg : '删除失败！',timeout : 2000});
					}
				}
			});
		}
	});
}


function formatterTime (value, row, index) {
	return value.substr(0,19);
}
