$(function() {
	InitTreeData();
	getListdata("0");
	//initLevel();
});

var typeid = "";
/**
 * 初始化加载接口类型树
 */
function InitTreeData() {
	$('#tree').tree({
		url : 'intfcController/findAllIntfcType',
		animate : true,
		checkbox : false,
		onlyLeafCheck : true,
		onClick : function(node) {
			typeid = node.id;
			$("#typeid").val(typeid);
			reloadbytype(typeid);
		},
		onContextMenu : function(e, node) {
			e.preventDefault();
			$('#tree').tree('select', node.target);
			$('#mm').menu('show', {
				left : e.pageX,
				top : e.pageY
			});
		}
	});
}

/**
 * 增加接口类型节点
 */
function addNode() {
	$("#typeName").textbox('setValue',"");
	$("#remark").textbox('setValue',"");
	$('#typeDialog').dialog('open');
}

/**
 * 删除接口类型节点
 */
function delNode() {
	var nodes = $('#tree').tree('getSelected');
	var ids = '';
	if (nodes == null) {
		$.messager.alert('提示', '请选择操作项！', 'info');
		return;
	} else if (nodes.id == '0') {
		$.messager.alert('提示', '父级节点不可删除！', 'info');
		return;
	} else {
		$.messager.confirm('删除接口类型', '确定删除吗?', function(r) {
			if (r) {
				ids = nodes.id;
				$.post("intfcController/findIntfcListByTypeId", {
					"typeid" : ids
				}, function(data) {
					if (data == null || data.total != '0') {
						$.messager.alert('提示', '此类型下包含接口数据,不可删除', 'info')
						return;
					} else {
						$.post("intfcController/doDeleteIntfcType", {
							"ids" : ids
						}, function(data) {
							InitTreeData();
						});
					}
				});
			}
		});
	}
}

var nodeid = "";
var uflag = 0;

/**
 * 修改接口类型节点
 */
function modNode() {
	var node = $('#tree').tree('getSelected');
	if (node) {
		nodeid = node.id;
		$("#typeName").textbox('setValue',node.text);
		$("#remark").textbox('setValue',node.remark);
		$('#typeDialog').dialog('open');
		uflag = 1;
	}
}

/**
 * 保存接口类型
 */
function doSaveType() {
	if (!$('#typeForm').form('validate')) {
		return;
	}
	var typeName = $("#typeName").textbox('getValue');
	var remark = $("#remark").textbox('getValue');
	var url = "";
	if (uflag == 0) {
		url = "intfcController/doSaveIntfcType";
	} else {
		url = "intfcController/doUpdateIntfcType";
	}
	var intfcType = {
		id : nodeid,
		typeName : typeName,
		remark : remark
	};
	$.ajax({
		url : url,
		type : "post",
		async : false,
		data : intfcType,
		success : function(data) {
			if (data == '1') {
				$.messager.alert('提示', '类型名称已存在', 'info');
				return;
			} else {
				$.messager.show({ title:'提示', msg:'保存成功', showType:'slide' });
				$('#typeDialog').dialog('close');
				InitTreeData();
			}
			uflag = 0;
		}
	});
}

/**
 * 根据接口类型获取接口数据列表
 */
function getListdata(id) {
	$('#dtlist').datagrid({
		url : 'intfcController/findIntfcListByTypeId',
		method : 'POST',
		idField : 'id',
		treeField : 'typeName',
		striped : true,
		fitColumns : true,
		fit : true,
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolbar1',
		pageSize : 10,
		showFooter : true,
		columns : [ [ 
		    { field : 'ck', checkbox : true }, 
		    { field : 'id', title : 'id', hidden : true }, 
		    { field : 'intfcName', title : '接口名称', width : 80, align : 'center'},
		    { field : 'reqMode', title : '请求方式', width : 40, align : 'center'},
		    { field : 'intfcType', title : '接口类型', width : 50, align : 'center'},
		    { field : 'impMode', title : '实现方式', width : 40, align : 'center'},
		    { field : 'url', title : '接口地址', width : 150, align : 'left'},
		    { field : 'remark', title : '备注', width : 100, align : 'left'},
		    { field : 'caozuo', title : '操作', width : 50, align : 'center',
				formatter : function(value, row) {
					return '<a href="javascript:testUrl()" class="easyui-linkbutton">测试接口</a>';
				}
		    } ] ],
		onClickRow: function(index,row){
			//cancel all select
			$('#dtlist').datagrid("clearChecked");
			//check the select row
			$('#dtlist').datagrid("checkRow", index);
		},
	});
}

/**
 * 重新加载接口类型树
 */
function reloadbytype(typeid) {
	$('#dtlist').datagrid('clearChecked');
	$('#dtlist').datagrid('reload', {
		"typeid" : typeid
	});
}

var duflag = 0;
/**
 * 新增弹出接口信息页面
 */
function saveInfo() {
	/* window.parent.addTab('新增接口类型', 'dictype/add'); */
	duflag = 0;
	if (typeid == "") {
		//$.messager.alert('提示', '请选数据接口类型！', 'info');
		layer.tips('请选数据接口类型', '#btn_add', { tips: 3 });
	} else {
		//$('#dlgdata').dialog("open");
		//window.parent.addTab("添加接口","intfcController/addInfo?typeid="+typeid);
		
		//show the dialog
		$('#add_intfc_dialog').dialog({title: "添加接口"});
		$('#add_intfc_dialog').dialog("open");
		$('#save_intfc').show();
		$('#update_intfc').hide();
		$('#add_intfc_form').form('clear');
		//clear the parameter datagrid
		$('#tb1').datagrid('loadData',{'total':0,'rows':[]});
		//reset the add parameter mark
		flg="";
		//add typeid
		$('#typeId').val(typeid);
	}
}

var id = 0;
/**
 * 修改弹出接口信息页面
 */
function updateInfo() {
	var data = $('#dtlist').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行进行修改！', 'info');
			layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
			return;
		}
		id = data[0].id;
		//window.parent.addTab("修改接口","intfcController/updateInfo?id="+id);
		duflag = 1;
		//ajax get information then set in the dialog <div>
		$.ajax({
		url : 'intfcController/getOneInfo',
		dataType : 'json',
		async : false,
		data : {id : id},
		success : function(result) {
			if(result){
				//set value in the dialog
				var intfcInfo = result.intfcInfo;
				
				$('#add_intfc_form').form('clear');
				$('#add_intfc_dialog').dialog(
						{title: "修改接口"});
				$('#add_intfc_dialog').dialog("open");
				//set the value
				$('#typeId').val(intfcInfo.typeId);
				$('#id').val(intfcInfo.id);
				$("#intfcName").textbox('setValue',intfcInfo.intfcName);//赋值 
				$("#reqMode").textbox('setValue',intfcInfo.reqMode);
				$("#intfcType").textbox('setValue',intfcInfo.intfcType);
				$("#impMode").textbox('setValue',intfcInfo.impMode);
				$("#url").textbox('setValue',intfcInfo.url);
				$("#method").textbox('setValue',intfcInfo.method);
				$("#sysName").textbox('setValue',intfcInfo.sysName);
				$("#remark1").val(intfcInfo.remark);

				var data2 = '{"total":'+result.list.length+',"rows":'+result.arr+'}'; 
				var data = JSON.parse(data2);
				
				//load the parameter data to the parameter table 
				$('#tb1').datagrid('loadData',data);
				
				//switch save button
				$('#save_intfc').hide();
				$('#update_intfc').show();
			}
		},
		error : function(result) {
			$.messager.show({ title:'提示', msg:'服务器出错，添加失败', showType:'slide' });
		}
	});
		
		
	}
}

/**
 * 删除接口信息
 */
function deleteInfo() {
	var selecteds = $('#dtlist').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择操作项！', 'info');
		layer.tips('请选择操作项', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除接口数据', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].id + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'intfcController/doDeleteIntfcInfo',
				dataType : 'json',
				async : false,
				data : {ids : ids},
				success : function(result) {
					var msg = result;
					$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
					reloadbytype(typeid);
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 条件查询
 */
function searchList(){
	
	//var intfcName = $("#intfcName").val();
	//var intfcType = $("#intfcType").val();
	$('#dtlist').datagrid({
        url:"intfcController/findIntfcListByTypeId",
        queryParams:{
        	//intfcName:intfcName,
        	//intfcType:intfcType,
        	typeid : typeid,
        	searchValue : $("#search").searchbox('getValue'),
        	date:new Date()
        }
    });
}
/**
 * 弹出测试接口信息页面
 */
function testUrl(){
	//window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	var selecteds = $('#dtlist').datagrid('getSelections');
	var id = selecteds[0].id;
	$('#test_dialog').dialog("open");
	$("#testFrame").attr("src","intfcController/testIndex?id="+id);
	//window.parent.addTab("测试接口","intfcController/testIndex?id="+id);
}

function run(){
	window.frames["testFrame"].run();
}

function clearSearchBox(){
	$("#search").searchbox("setValue","");
	$("#org_search").searchbox("setValue","");
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#tree").tree('search',searchValue);
}