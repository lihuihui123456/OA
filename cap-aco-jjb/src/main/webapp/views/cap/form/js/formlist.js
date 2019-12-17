$(function() {
	getListdata();
	initData();
});
function initData() {
	$("#form_datasource").combotree({
		url: 'formTableController/findMainFormTable',
		panelHeight: 150
	});
}
function createForm() {
	clearData();
	$('#formCtlgDlg').dialog({
		title: "创建表单"
	});
	$('#formCtlgDlg').dialog('open');
}
function copyForm(){
	clearData();
	copyData();
	
}
function updateForm() {
	clearData();
	setData();
}
function copyData(){
	var selecteds = $('#tb1').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('表单设计', '请选择操作项！');
		layer.tips('请选择操作项', '#btn_copy', { tips: 3 });
		return;
	}else if(selecteds.length>1){
		//$.messager.alert('表单设计', '请选择一条数据操作！');
		layer.tips('请选择一条数据操作', '#btn_copy', { tips: 3 });
		return;
	}else{
		formId=selecteds[0].form_id;
		copyform="true";
		$('#form_code').val(selecteds[0].form_code);
		$('#form_name').val(selecteds[0].form_name);
		$("#form_datasource").combotree("setValue",selecteds[0].form_url);
		$('#formCtlgDlg').dialog({
			title: "复制表单"
		});
		$('#formCtlgDlg').dialog('open');
	}
}
var formId="";
var copyform="";
function setData(){
	var selecteds = $('#tb1').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('表单设计', '请选择操作项！');
		layer.tips('请选择一条数据操作', '#btn_edit', { tips: 3 });
		return;
	}else if(selecteds.length>1){
		//$.messager.alert('表单设计', '请选择一条数据操作！');
		layer.tips('请选择一条数据操作', '#btn_edit', { tips: 3 });
		return;
	}else{
		formId=selecteds[0].form_id;
		$('#form_code').val(selecteds[0].form_code);
		$('#form_name').val(selecteds[0].form_name);
		$("#form_datasource").combotree("setValue",selecteds[0].form_url);
		$('#formCtlgDlg').dialog({
			title: "修改表单"
		});
		$('#formCtlgDlg').dialog('open');
	}
}
function formDesgin(){
	var selecteds = $('#tb1').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('表单设计', '请选择操作项！');
		layer.tips('请选择一条数据操作', '#btn_des', { tips: 3 });
		return;
	}else if(selecteds.length>1){
		//$.messager.alert('表单设计', '请选择一条数据操作！');
		layer.tips('请选择一条数据操作', '#btn_des', { tips: 3 });
		return;
	}else{
		var formid = selecteds[0].form_id;
		if (formid == "") {
			alert("请选择表单!");
		} else {
			/** 解决IE路径问题 */
			var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
			if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !(userAgent.indexOf("Opera") > -1)) {
				window.open("formdesginer?formid=" + formid);
		    } else {
		    	window.open("formModelDesginController/formdesginer?formid=" + formid);
		    } 
		}
	}
}
function saveForm() {
	if ($("#form_code").val() == '') {
		alert("表单编码不能为空！");
		return;
	}
	if ($("#form_name").val() == '') {
		alert("表单名称不能为空！");
		return;
	}
	if ($("#form_datasource").combotree("getValue") == '') {
		alert("数据源不能为空！");
		return;
	}
	var url="";
	if(copyform==""){
		url='formModelDesginController/save';
	}else{
		url='formModelDesginController/copy'
	}
	$.ajax({
		url: url,
		type: 'post',
		dataType: 'text',
		async: false,
		data: {
			formid:formId,
			form_code: $("#form_code").val(),
			form_name: $("#form_name").val(),
			form_url: $("#form_datasource").combotree("getValue"),
			updata:"true"
		},
		success: function(data) {
			var msg="";
			if(copyform!=""){
				msg="复制成功";
			}else if(formId==""){
				msg="添加成功";
			}else{
				msg="修改成功";
			}
			window.parent.$.messager.show({
				title: '提示',
				
				msg: msg,
				timeout: 2000,
			});
			$('#formCtlgDlg').dialog('close');
			clearData();
			reload();
		}
	});
}
/**
 * 初始化接口类型树
 */

function getListdata() {
	$('#tb1').datagrid({
		url : 'formModelDesginController/findFormpage',
		method : 'POST',
		idField : 'form_id',
		striped : true,
		fit : true,
		fitColumns : true,
		singleSelect : true,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolbar1',
		showFooter : true,
		columns : [ [ {
			field : 'ck',
			checkbox : true
		}, {
			field : 'form_id',
			title : 'form_id',
			hidden : true
		}, {
			field : 'form_code',
			title : '表单编码',
			hidden : true
		}, {
			field : 'form_name',
			title : '表单名称',
			width : 80,
			align : 'center'
		}, {
			field : 'form_url',
			title : '对应数据源',
			width : 80,
			formatter : function(value, row) {
				var temp = initDataSource();
				for (var i = 0; i < temp.length; i++) {
					if (temp[i].id == value) {
						return temp[i].text;
					}
				}
			},
			align : 'center'
		}, {
			field : 'ts',
			title : '创建时间',
			width : 80,
			hidden : true
		} ] ],
		onBeforeLoad : function(param) {
		},
		onLoadSuccess : function(data) {

		},
		onLoadError : function() {

		},
		onClickCell : function(rowIndex, field, value) {

		}
	});
}
var temp="";
/** 查询字段信息 **/
function initDictNew(dicttype){	
	$.ajax({
	url:"dictController/findDictByTypeCode",
	type:"get",
	async:false,
	dataType:"json",
	data:{"dictTypeCode":dicttype},
	success:function(data){
	temp = data;
	}
	});
	return temp;
}
/** 查询字段信息 **/
function initDataSource(){	
	$.ajax({
	url:"formTableController/findAllTablelist",
	type:"get",
	async:false,
	dataType:"json",
	success:function(data){
		temp = data;
	}
	});
	return temp;
}
/**
 * 重新加载接口类型树
 */
function reload() {
	$('#tb1').datagrid({
		url : 'formModelDesginController/findFormpage'
	});

}


/**
 * 删除接口信息
 */
function deleteInfo() {
	var selecteds = $('#tb1').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('删除数据库数据', '请选择操作项！');
		layer.tips('请选择操作项', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除数据库数据', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			var dbsid = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].form_id + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'formModelDesginController/deleteForm',
				dataType : 'json',
				data : {
					ids : ids
				},
				success : function(result) {
					var msg = result;
					$.messager.show({
						title : '提示',
						msg : '删除成功',
						showType : 'slide'
					});
					reload();
				},
				error : function(result) {
					$.messager.show({
						title : '提示',
						msg : '删除失败',
						showType : 'slide'
					});
				}
			});
		}
	});
}
function findByCondition() {
	/*var url = "formModelDesginController/findFormpage?searchValue="+$("#search").searchbox('getValue');
	$('#tb1').datagrid('reload',url);*/
	
	$('#tb1').datagrid({
		url : "formModelDesginController/findFormpage",
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams : {
			
			searchValue : $("#search").searchbox('getValue')
		}
	});
	$('#tb1').datagrid('clearSelections'); // 清空选中的行
}
/**
 * 清空搜索框
 * 
 * @param id 控件ID
 * */
function clearSearchBox(id){
	 $("#"+id).searchbox("setValue","");
}
function clearData(){
	formId="";
	copyform="";
	$('#form_code').val('');
	$('#form_name').val('');
	$("#form_datasource").combotree("setValue","");
}
/**
 * 关联浮动表
 * 
 * @author wangjiankun
 * @since 2017-06-28
 * @param 无
 * @return 无
 * */
/**
 * 打开数据规则列表弹出框
 */
function openFloatTabDl(){
	var selecteds = $('#tb1').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		layer.tips('请选择一条数据操作', '#asst_float_table', { tips: 3 });
		return;
	}else if(selecteds.length>1){
		layer.tips('请选择一条数据操作', '#asst_float_table', { tips: 3 });
		return;
	}else{
		formId=selecteds[0].form_id;
		$('#floatTableDialog').dialog({
			title: "关联浮动表"
		});
		initFloatTalList();
		$('#floatTable').datagrid("clearChecked");
		$('#floatTableDialog').dialog('open');
	}
}

/**
 * 初始化浮动表列表
 */
function initFloatTalList(){
	$('#floatTable').datagrid({
		method : 'POST',
		url : 'formFloatTableController/findByCondition',
		idField : 'id',
		striped : true,
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams:{
			formId : formId
		},
		fitColumns : true,
		fit: true,
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#floatTableToolBar',
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', checkbox : true }, 
		   { field : 'id', title : 'id', hidden : true }, 
		   { field : 'formId', title : 'formId', hidden : true }, 
		   { field : 'tableCode', title : 'tableCode', hidden : true },
		   { field : 'tableName', title : '浮动表名称', width : 100, align : 'left'},
		   { field : 'columnDef',  title : '列定义', width : 550, align : 'left'}
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#floatTable').datagrid("clearChecked");
			//check the select row
			$('#floatTable').datagrid("selectRow", index);
		}
	});
}

/**
 * 浮动表条件查询
 */
function findFloatTalbeByCondition(){
	var tableName = $("#floatTableSearch").searchbox('getValue');
	$('#floatTable').datagrid({
        url:"formFloatTableController/findByCondition",
        queryParams:{
        	formId : formId,
        	tableName : tableName
        }
    });
}

/**
 * 打开模态框
 * 
 * @author wangjiankun
 * @since 2017-07-04
 * @param type add:新增 update:修改
 * @return 无
 */
function openFloatTableForm(type) {
	var url = "formFloatTableController/toFloatTableIframe?formId="+formId;
	if ("update" == type) {
		var selecteds = $('#floatTable').datagrid('getSelections');
		if (selecteds == null || selecteds.length == 0) {
			layer.tips('请选择一条数据操作', '#btn_floatTable_edit', { tips: 3 });
			return;
		}else if(selecteds.length>1){
			layer.tips('请选择一条数据操作', '#btn_floatTable_edit', { tips: 3 });
			return;
		}else{
			formId=selecteds[0].formId;
			var id = selecteds[0].id;
			var tableCode = selecteds[0].tableCode;
			var columnDef = selecteds[0].columnDef;
			var tableName = selecteds[0].tableName;
			$('#tableAddDialog').dialog({
				title: "修改浮动表"
			});
			url = "formFloatTableController/toFloatTableIframe?formId="+formId+"&tableCode="+tableCode+"&id="+id+"&columnDef="+columnDef+"&tableName="+tableName;
			$("#tableAddFrame").attr("src",url);
			$('#tableAddDialog').dialog("open");
		}
	} else {
		$('#tableAddDialog').dialog({
			title: "新增浮动表"
		});
		$("#tableAddFrame").attr("src",url);
		$('#tableAddDialog').dialog("open");
	}
}

/**
 * 保存浮动表
 * */
function doSaveFloatTable(){
	window.frames["tableAddFrame"].doSaveFormFloat();
}

/**
 * 删除浮动表
 * 
 * @author wangjiankun
 * @since 2017-07-05
 * */
function deleteFloatTable(){
	var selecteds = $('#floatTable').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		layer.tips('请选择操作项', '#btn_floatTable_del', { tips: 3 });
		return;
	} 
	$.messager.confirm('删除浮动表', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].id + ",";
			});

			ids = ids.substring(0, ids.length - 1);
			$.ajax({
				url : 'formFloatTableController/doDeleteFormFloat',
				dataType : 'json',
				async : false,
				data : {
					ids : ids
				},
				success : function(result) {
					if (result.code == 200) {
						$.messager.show({ title:'提示', msg:result.msg, showType:'slide' });
						$('#floatTable').datagrid('reload');
						$('#floatTable').datagrid("clearChecked");
					} else {
						$.messager.show({ title:'提示', msg:result.msg, showType:'slide' });
					}
					
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
				}
			});
		}
	});
}
