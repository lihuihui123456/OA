/**
 * 初始化函数
 */
$(function() {
	// 初始化列表
	initDictList();
});

/**
 * 初始化列表
 * 
 * @param 无
 * @param 无
 */
function initDictList() {
	$('#dictList').datagrid({
		url : 'timerController/findLuceneDictList',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		method : 'POST',
		idField : 'id',
		striped : true,
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		fit: true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', 				checkbox : true }, 
		   { field : 'id', 		  		title : 'id', hidden : true }, 
		   { field : 'typeName', 		title : '词库类型名称', 	width : 80, 	align : 'left' },
		   { field : 'typeDesc', 		title : '描述',			width : 150, 	align : 'left'},
		   /*{ field : 'filePath', 		title : '词库类型路径',		width : 150, 	align : 'left'},
		   { field : 'opera', 			title : '操作',			width : 50, 	align : 'left',
			   formatter : function(value, row) {
					return '<a href="timerController/exportTemplate?filePath='+row.filePath+'" class="easyui-linkbutton">下载</a>';
				}
		   }*/
		]],
		onClickRow: function(index,row){
			//, formatter:formatIsDisable 
			//cancel all select
			$('#dictList').datagrid("clearChecked");
			//check the select row
			$('#dictList').datagrid("selectRow", index);
		}
	});
}

/**
 * 保存
 * 
 * @param 无
 * @param 无
 */
function doSaveDict() {
	if(!$('#dictForm').form('validate')){
		return;
	}

	var url = "";
	if (id == undefined || id == '') {
		url = "timerController/doSaveDict";
	} else {
		url = "timerController/doUpdateDict";
	}

	//限制文件为excel文件
	var picSrc = $('#filePath').filebox('getValue');
	if (picSrc != '' && picSrc.indexOf(".dic") < 0) {
		$.messager.alert('提示', '仅支持dic格式，请重新选择！', 'info');
		return;
	}
	
	$('#dictForm').form('submit', {
		url : url,
		/*onSubmit: function(param){   
	        param.id = $("#id").val();   
	        param.typeName = $("#typeName").textbox('getValue');   
	    } ,*/
	    success:function(data){
	    	$.messager.show({ title:'提示', msg:'保存成功！', showType:'slide' });
			$('#dictDialog').dialog('close');
			reload();
	    },
	    error:function(data){
	    	alert("执行出现异常");
	    }
	});
}

/**
 * 新增
 * 
 * @param 无
 * @param 无
 */
function openForm(title) {
	$('#dictDialog').dialog({
		title : title
	});
	initdldata();
	id = '';
		
	$("#path").css("display","");
	$('#dictDialog').dialog('open');
}

/**
 * 修改
 * 
 * @param 无
 * @param 无
 */
var id = "";
function openUpdateForm(title) {
	$('#dictDialog').dialog({
		title : title
	});
	$("#path").css("display","none");
	initdldata();
	var data = $('#dictList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		layer.tips('请选择操作项', '#btn_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行进行修改！', 'info');
			layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
			return;
		}
		var dict = data[0];
		$("#typeName").textbox('setValue',dict.typeName);
		$("#typeDesc").textbox('setValue',dict.typeDesc);
		//$("#filePath").filebox('setValue',dict.filePath);
		
		id = data[0].id;
		$("#id").val(id);
		
		$('#dictDialog').dialog('open');
	}
}

/**
 * 删除
 * 
 * @param 无
 * @param 无
 */
function doDeleteDict() {
	var selecteds = $('#dictList').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择需要删除的记录！', 'info');
		layer.tips('请选择操作项', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].id + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'timerController/doDeleteDict',
				async : false,
				dataType : 'json',
				data : {ids : ids},
				success : function(result) {
					var msg = result;
					$.messager.show({ title:'提示', msg:'删除成功!', showType:'slide' });
					reload();
					$('#dictList').datagrid('clearChecked'); // 清空选中的行
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败!', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 重新加载列表
 * 
 * @param 无
 * @param 无
 */
function reload() {
	$('#dictList').datagrid('reload', {});
}

/**
 * 初始化dialog清空数据
 * 
 * @param 无
 * @param 无
 */
function initdldata() {
	$("#typeName").textbox('setValue',"");
	$("#typeDesc").textbox('setValue',"");
	$("#filePath").filebox('setValue',"");
}