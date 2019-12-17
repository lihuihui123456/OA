/**
 * 页面加载时初始化相关函数
 */
$(function() {
	initDeptTypeList();
	//set the datagrid only one row can be selected
	$('#deptTypeDataGrid').datagrid({
		onClickRow: function(index,row){
			//cancel all
			$('#deptTypeDataGrid').datagrid("clearChecked");
			//check the select row
			$('#deptTypeDataGrid').datagrid("selectRow", index);
		}
	});
});

var operatorFlag = 'save';

/**
 * 初始化部门类型列表
 * 
 * @param 无
 * @return 无
 */
function initDeptTypeList() {
	var url = "deptTypeController/findByCondition";
	$('#deptTypeDataGrid').datagrid({
		url:url,
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		method:'POST',
		idField:'deptTypeId',
		striped:true,
		fitColumns:true,
		singleSelect:false,
		sortOrder:'desc',
		fit: true,
		rownumbers:true,
		pagination:true,
		nowrap:false,
		toolbar:'#toolBar',
		pageSize:10,
		showFooter:true,
		columns:[[ 
 		    { field:'ck', checkbox:true }, 
 		    { field:'deptTypeId',   title:'deptTypeId',	hidden:true }, 
 		    { field:'deptTypeName', title:'部门类型名称',  	width:180, align:'left' }, 
 		    { field:'deptTypeCode', title:'部门类型编码',  	width:180, align:'left' }, 
 		    { field:'deptTypeDesc', title:'部门类型描述',  	width:200, align:'left' }, 
 		    { field:'isSeal',       title:'是否封存', 		width:70, align:'left', formatter:formatIsSeal }, 
 		    { field:'createTime',   title:'创建日期', 		width:80, align:'left', formatter:formatCreateTime },
 		   { field : 'operate', title : '操作', width : 100, align : 'center', formatter : formatOperate }
 		]]
	});
	//直接从第一页加载
	$('#deptTypeDataGrid').datagrid('load');
}

/**
 * 初始化部门类型编辑对话框 初始化面板 初始化数据
 */
function initDeptTypeDlg(title) {
	$('#deptTypeDialog').dialog({
		title : title
	});
	$('#deptTypeForm').form('clear');
	changeDesc();
	$('#deptTypeDialog').dialog("open");
	if( operatorFlag == 'save' ) {
		$("#deptTypeCode").removeAttr("disabled");
		//$(":radio[value=N]").attr("checked","checked");
		$("#isSeal").switchbutton("check"); 
	}
}

function closeDeptTypeDlg() {
	$('#deptTypeForm').form('clear');
	$('#deptTypeDialog').dialog("close");
}
/**
 * 添加部门类型对话框弹出
 */
function doAddDeptTypeBefore() {
	operatorFlag = 'save';
	initDeptTypeDlg("新增部门类型");
}
/**
 * 添加修改部门类型保存方法
 */
function doSaveOrUpdateDeptType() {
	var url = "";
	if (operatorFlag == 'save') {
		url = "deptTypeController/doSaveDeptType";
	} else {
		$("#deptTypeCode").removeAttr("disabled");
		url = "deptTypeController/doUpdateDeptType";
	}
	var is_Seal = $("#isSeal").switchbutton("options").checked;
	if (is_Seal) {
		is_Seal = "N";
	} else {
		is_Seal = "Y";
	}
	var obj = $('#deptTypeForm').serialize()+'&'+'isSeal='+is_Seal;
	$.ajax({
		url : url,
		async : false,
		type : "post",
		data : obj,
		beforeSend : function() {
			$('input.easyui-validatebox').validatebox('enableValidation');
			return $('#deptTypeForm').form('validate');
		},
		success : function(data) {
			//01：修改或者保存成功  02：类型编码重复 03：操作失败
			if(data=='01'){
				if (operatorFlag == 'save') {
					$.messager.show({ title:'提示', msg:'保存成功', showType:'slide' });
				} else {
					$.messager.show({ title:'提示', msg:'修改成功', showType:'slide' });
				}
				$('#deptTypeDialog').dialog('close');
				initDeptTypeList();
				$('#deptTypeDataGrid').datagrid('clearSelections'); // 清空选中的行
			}else if(data=='02'){
				$.messager.show({ title:'提示', msg:'类型名字重复', showType:'slide' });
			}else if(data=='03'){
				$.messager.show({ title:'提示', msg:'服务器操作失败', showType:'slide' });
			}
		},
		error : function(data){
			$.messager.alert('错误','请求失败！','error');
		}
	});
}
/**
 * 修改对话框弹出
 */
function doUpdateDeptTypeBefore() {
	operatorFlag = 'update';
	var data = $('#deptTypeDataGrid').datagrid('getChecked');
	if (data == "" || data.length > 1) {
		layer.tips('请选择一行记录进行修改', '#btn_dept_type_update', { tips: 3 });
		//$.messager.alert('提示','请选择一行进行修改！','info');
		return;
	}
	var userId = data[0].deptTypeId;
	$.ajax({
		url : 'deptTypeController/findDeptTypeById',
		async : false,
		dataType : 'json',
		data : {
			id : userId
		},
		success : function(deptType) {
			if (deptType != null) {
				initDeptTypeDlg("修改部门类型");
				$("#deptTypeId").val(deptType.deptTypeId);
				$("#deptTypeCode").val(deptType.deptTypeCode);
				$("#deptTypeName").textbox("setValue", deptType.deptTypeName);
				var isSeal = deptType.isSeal;
				if (isSeal == "N") {
					$("#isSeal").switchbutton("check"); 
				} else {
					$("#isSeal").switchbutton("uncheck"); 
				}
				//$(":radio[value=" + deptType.isSeal + "]").attr("checked","checked");
				$("#deptTypeDesc").textbox("setValue",deptType.deptTypeDesc);
				$("#deptTypeForm").form('validate');
				$("#deptTypeCode").attr("disabled","disabled");
			}
		},
		error : function(result) {
			$.messager.alert('错误','修改失败！','error');
		}
	});
}
/**
 * 删除部门类型
 */
function doDeleteDeptType() {
	var selecteds = $('#deptTypeDataGrid').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		layer.tips('请选择需要删除的记录', '#btn_dept_type_del', { tips: 3 });
		//$.messager.alert('提示','请选择需要删除的记录！','info');
		return;
	}
	$.messager.confirm('删除部门类型', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].deptTypeId + ",";
			});

			ids = ids.substring(0, ids.length - 1);
			$.ajax({
				url : 'deptTypeController/doDeleteDeptType',
				async : false,
				dataType : 'json',
				data : {
					ids : ids
				},
				success : function(result) {
					$.messager.show({ title:'提示', msg:'删除成功！', showType:'slide' });
					initDeptTypeList();
					$('#deptTypeDataGrid').datagrid('clearSelections'); // 清空选中的行
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败！', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 条件查询
 */
function findByCondition() {

	var searchValue = $.trim($("#search").textbox("getValue"));
	//筛选查询条件
	if(searchValue!=null&&searchValue.indexOf('%')>=0){
		$.messager.alert('提示', '输入非法查询字符\'%\'！', 'info');
		return;
	}
	$('#deptTypeDataGrid').datagrid({
		url : "deptTypeController/findByCondition",
		queryParams : {
			deptTypeCode: searchValue,
			deptTypeName : searchValue
		}/*,
		onLoadSuccess: function(data) {
			$.messager.show({ title:'提示', msg:'搜索到 <span style="color:red">'+data.rows.length+'</span> 条数据', showType:'slide' });
		}*/
	});
	$('#deptTypeDataGrid').datagrid('clearSelections'); // 清空选中的行
}
function validExist(){
	var deptTypeCode = $.trim($("#deptTypeCode").val());
	if(deptTypeCode==''){
		return;
	}
	$.ajax({
		url : 'deptTypeController/findDeptTypeByCode',
		async : false,
		dataType : 'json',
		data : {
			code : deptTypeCode
		},
		success : function(result) {
			if(result){
				if(result.deptTypeId && result.deptTypeId!=''){
					$.messager.alert('添加部门类型', "部门类型代码已存在！");
					$("#deptTypeCode").val("");
					$("#deptTypeForm").form('validate');
				}
			}
		},
		error : function(result) {
			$.messager.alert('添加部门类型', "部门类型代码验证失败！");
		}
	});
}

/**
 * 上移
 * @author 张多一
 * @param modId 单位ID
 * @param parentId 父节点ID
 */
function doUpSort(deptTypeId,parentId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$.ajax({
		type : 'post',
		url : 'deptTypeController/doUpSort',
		data : {
			deptTypeId : deptTypeId
		},
		dataType : 'json',
		success : function(data) {
			if (data.success) {
				$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
				initDeptTypeList();
			}
		}
	});
}

/**
 * 下移
 * @author 张多一
 * @param modId 模块ID
 * @param parentId 父节点ID
 */
function doDownSort(deptTypeId,parentId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$.ajax({
		type : 'post',
		url : 'deptTypeController/doDownSort',
		data : {
			deptTypeId : deptTypeId
		},
		dataType : 'json',
		success : function(data) {
			$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
			initDeptTypeList();
		}
	});
}


/**
 * 格式化上移下级操作
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatOperate(val, row) {
	var id = row.deptTypeId;
	var parentId = null;
	return '<img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/up.png" onclick="doUpSort(\''+id+'\',\''+parentId+'\')"/>'
		  +'&nbsp;&nbsp;<img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/down.png" onclick="doDownSort(\''+id+'\',\''+parentId+'\')" />';
}

/*************************** 格式化字段值 ***************************/
/**
 * 格式化是否封存字段
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatIsSeal(val, row) {
	if(val == 'Y'){
		return "是";
	}else{
		return "否";
	}
}

/**
 * 格式化创建时间
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatCreateTime(val, row) {
	//格式化时间，截取年月日
	return val.substring(0,10);
}
function clearSearchBox(){
	 $("#search").searchbox("setValue","");
}

/**
 * 监控名称的改变，描述跟着改变
 */
function changeDesc(){
    $('#deptTypeName').textbox({
        onChange: function(value){ 
            var deptTypeName = $("#deptTypeName").textbox("getValue");
            $("#deptTypeDesc").textbox("setValue",deptTypeName);
        }
      });  
}