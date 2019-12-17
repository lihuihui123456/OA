/** 全局变量模块ID：moduleId */
var moduleId = "";

/**
 * 页面初始化时加载相关函数
 */
$(function() {
	initResourceDataGrid(moduleId);
});
	
/**
 * 初始化资源列表树
 * 
 * @param moduleId 模块ID
 * @param 无
 */
function initResourceDataGrid(moduleId) {
	$('#resc_datagrid').datagrid({
		url : 'resourceController/findByModuleId',
		queryParams:{
			moduleId:moduleId
		},
		method : 'POST',
		idField : 'id',
		striped : true,
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		pagination : false,
		toolbar : '#resBar',
		nowrap : false,
		columns : [[
		   { field : 'ck', checkbox : true }, 
		   { field : 'resId', title : '资源ID', hidden : true }, 
		   { field : 'modId', title : '模块ID', hidden : true }, 
		   { field : 'resName', title : '资源名称', width : 80, align : 'left' },
		   { field : 'resType', title : '资源分类', width : 50, align : 'left',
			   formatter:function(value,row){
				   if(value == null || value == ''){
					   return null;
				   }
				   if(value == 0) {
					   return '按钮';
				   }
				   if(value == 1) {
					   return '文本框';
				   }
				   return '';
			   }
		   },
		   { field : 'resCode', title : '资源编码', width : 50, align : 'left' },
		   { field : 'resUnId', title : '资源标识', width : 280, align : 'left' },
		   { field : 'isAudit', title : '审计', width : 50, align : 'left',
			   formatter:function(value,row){
				   if(value == null || value == ''){
					   return null;
				   }
				   if(value == "Y") {
					   return '是';
				   }
				   if(value == 'N') {
					   return '否';
				   }
				   return '';
			   }
		   },
		   { field : 'isContr', title : '监控性能', width : 50, align : 'left',
			   formatter:function(value,row){
				   if(value == null || value == ''){
					   return null;
				   }
				   if(value == "Y") {
					   return '是';
				   }
				   if(value == 'N') {
					   return '否';
				   }
				   return '';
			   }
		   }
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#resc_datagrid').datagrid("clearChecked");
			//check the select row
			$('#resc_datagrid').datagrid("selectRow", index);
		}
	});
}

/**
 * 重新加载资源列表
 */
function reloadResourceList() {
	$('#resc_datagrid').datagrid('reload', {
		"moduleId" : moduleId
	});
}

/**
 * 打开添加资源窗口
 */
function addResource() {
	var data = $('#module_treegrid').datagrid('getChecked');
	if (data) {
		if (data.length > 1 || data.length == 0) {
			$.messager.alert('提示', '请选择一个模块！', 'info');
			return;
		}
		var isVrtlNode = data[0].isVrtlNode;
		var url = data[0].url;
		var unid = "";
		if (url.indexOf("/") != -1) {
			//将url中的“/”替换成“:”
			unid = url.replace(new RegExp("/","g"),":");
			//去掉第一个“:”,在最后加一个“:”
//			if (unid.indexOf(":", 0) != -1) {
//				unid = unid.substring(1)+":";
//			} else {
//				unid = unid + ":";
//			}
		} else {
			unid = url;
		}
		if (isVrtlNode == "Y") {
			$.messager.alert('提示', '虚拟节点不能添加资源！', 'info');
		} else {
			
			$("#addResForm").form("clear");
			$("#addUnid").textbox("setValue",unid);
			/**
			 * 初始化资源类型下拉
			 * */
			initDict({ "resType": "resType" }, 'false');
			//解决IE8删除键回退bug
			refuseBackspace("resType");
			$("#isAudit").switchbutton("check");
			$("#isContro").switchbutton("check");
//			$("#resType0").prop("checked","checked");
//			$("#isAuditY").prop("checked","checked");
//			$("#isControY").prop("checked","checked");
			bindAddResCodeChange();
			$('#addResDialog').dialog('open');
			$("#modId").val(data[0].id);
		}
	} else {
		$.messager.alert('提示', '请选择一个模块！', 'info');
		return;
	}
}

/**
 * 保存资源
 * */
function saveResource(){
	if (!$("#addResForm").form('validate')) {
		return;
	}
	var isAudit = $("#isAudit").switchbutton("options").checked;
	if (isAudit) {
		isAudit = "Y";
	} else {
		isAudit = "N";
	}
	var isContr = $("#isContro").switchbutton("options").checked;
	if (isContr) {
		isContr = "Y";
	} else {
		isContr = "N";
	}
	$.ajax({
		url : 'resourceController/doSaveResource',
		type : 'post',
		async : false,
		data : $("#addResForm").serialize()+'&isAudit='+isAudit+'&isContr='+isContr,
		success : function(data){
			$.messager.show({ title:'提示', msg:data, showType:'slide' });
			$('#addResDialog').dialog('close');
			reloadResourceList();
		},
		error : function() {
			$.messager.show({ title:'提示', msg:'操作失败！', showType:'slide' });
			$('#addResDialog').dialog('close');
			reloadResourceList();
		}
	});
}

/**
 * 删除资源
 * */
function delResource() {
	var selecteds = $('#resc_datagrid').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择操作项！', 'info');
		layer.tips('请选择操作项', '#btn_res_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除接口数据', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].resId + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'resourceController/doDeleteResource',
				async : false,
				dataType : 'json',
				data : {ids : ids},
				success : function(result) {
					$.messager.show({ title:'提示', msg:'删除成功！', showType:'slide' });
					$('#resc_datagrid').datagrid('clearSelections');
					reloadResourceList();
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败！', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 打开修改资源窗口
 * */
function modResource(){
	var data = $('#resc_datagrid').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		layer.tips('请选择一行进行修改', '#btn_res_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '请选择一行进行修改！', 'info');
			return;
		}
		var resource = data[0];
		/**
		 * 初始化资源类型下拉
		 * */
		initDict({
			"resType0":"resType"
		},'false');
		//解决IE8删除键回退bug
		refuseBackspace("resType0");
		$("#res_id").val(resource.resId);
		$("#res_mod_id").val(resource.modId);
		$("#res_code").textbox("setValue",resource.resCode);
		$("#res_name").textbox("setValue",resource.resName);
		$("#res_unId").textbox("setValue",resource.resUnId);
		$("#resType0").combobox("setValue",resource.resType);
		if (resource.isAudit == 'Y') {
			$("#isAudit0").switchbutton("check");
		} else {
			$("#isAudit0").switchbutton("uncheck");
		}
		if (resource.isContr == 'Y') {
			$("#isContro0").switchbutton("check");
		} else {
			$("#isContro0").switchbutton("uncheck");
		}
//		$("#resTypeMod"+resource.resType).prop("checked","checked");
//		$("#isAuditMod"+resource.isAudit).prop("checked","checked");
//		$("#isContrMod"+resource.isContr).prop("checked","checked");
		$("#sortMod").textbox("setValue",resource.sort);
		bindModResCodeChange();
		$("#modifyResDialog").dialog('open');
	}
}

/**
 * 修改资源
 * */
function modifyResource(){
	if (!$("#modifyResForm").form('validate')) {
		return;
	}
	var isAudit = $("#isAudit0").switchbutton("options").checked;
	if (isAudit) {
		isAudit = "Y";
	} else {
		isAudit = "N";
	}
	var isContr = $("#isContro0").switchbutton("options").checked;
	if (isContr) {
		isContr = "Y";
	} else {
		isContr = "N";
	}
	$.ajax({
		url : 'resourceController/doUpdateResource',
		type : 'post',
		async : false,
		data : $("#modifyResForm").serialize()+'&isAudit='+isAudit+'&isContr='+isContr,
		success : function(data){
			$.messager.show({ title:'提示', msg:data, showType:'slide' });
			$("#modifyResForm").form("clear");
			$('#modifyResDialog').dialog('close');
			$('#resc_datagrid').datagrid('clearChecked');
			reloadResourceList();
		},
		error : function() {
			$.messager.show({ title:'提示', msg:'操作失败！', showType:'slide' });
			$("#modifyResForm").form("clear");
			$('#modifyResDialog').dialog('close');
			$('#resc_datagrid').datagrid('clearChecked');
			reloadResourceList();
		}
	});
}

/**
 * 监控资源添加弹出框中资源编码输入框，当资源编码改变时，资源标识跟着改变
 */
function bindAddResCodeChange(){
    $('#addCode').textbox({  
        onChange: function(value){ 
        	//资源标识
            var unid = $("#addUnid").textbox("getValue");
            unid = unid.substring(unid.indexOf(":"),unid.length);
            $("#addUnid").textbox("setValue",value+unid);
        }
      });  
}

/**
 * 监控资源修改弹出框中资源编码输入框，当资源编码改变时，资源标识跟着改变
 */
function bindModResCodeChange(){
    $('#res_code').textbox({  
        onChange: function(value){ 
        	//资源标识
            var unid = $("#res_unId").textbox("getValue");
            unid = unid.substring(unid.indexOf(":"),unid.length);
            $("#res_unId").textbox("setValue",value+unid);
        }
      });  
}

/**
 * 快速生成增删改按钮
 */
function quickCreate() {
	var data = $('#module_treegrid').datagrid('getChecked');
	if (data) {
		if (data.length > 1 || data.length == 0) {
			$.messager.alert('提示', '请选择一个模块！', 'info');
			return;
		}
		var modId = data[0].id;
		var isVrtlNode = data[0].isVrtlNode;
		//将url中的“/”替换成“:”
		var unid = data[0].url.replace(new RegExp("/","g"),":");
		//去掉第一个“:”,在最后加一个“:”
		//unid = unid.substring(1)+":";
		if (isVrtlNode == "Y") {
			$.messager.alert('提示', '虚拟节点不能添加资源！', 'info');
		} else {
			$.ajax({
				type : 'post',
				url : 'resourceController/doSaveResources',
				async : false,
				data : {
					unid : unid,
					modId : modId
				},
				success : function(data) {
					$.messager.show({ title:'提示', msg:'添加成功！', showType:'slide' });
					reloadResourceList();
				}
			});
		}
	} else {
		$.messager.alert('提示', '请选择一个模块！', 'info');
		return;
	}
}