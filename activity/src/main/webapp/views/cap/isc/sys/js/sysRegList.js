/**
 * 初始化函数
 */
$(function() {
	// 初始化系统注册列表
	initSysRegList();
	findSysTheme();
});

/**
 * 初始化系统注册列表
 * 
 * @param 无
 * @param 无
 */
function initSysRegList() {
	$('#sysRegList').datagrid({
		url : 'sysRegController/findByCondition',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		method : 'POST',
		idField : 'sysId',
		striped : true,
		fitColumns : true,
		singleSelect : true,
		selectOnCheck : true,
		checkOnSelect : true,
		rownumbers : true,
		fit: true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', checkbox : true }, 
		   { field : 'sysId', 		  	title : 'sysId', hidden : true }, 
		   { field : 'orgId', 		  	title : 'orgId', hidden : true }, 
		   { field : 'sysName', 		title : '系统名称', 	width : 130, 	align : 'left' },
		   { field : 'sysFlag', 		title : '系统标识',	width : 60, 	align : 'left' },
		   //{ field : 'sysUrl', 			title : '系统访问地址', width : 140, 	align : 'left' },
		   //{ field : 'sysRegCode', 		title : '系统注册码', 	width : 130, 	align : 'left' },
		   { field : 'sysDesc', 		title : '系统描述', 	width : 130, 	align : 'left'},
		   { field : 'isDisable', 		title : '禁用',  	width : 30, 	align : 'left', formatter:formatIsDisable },
		   { field : 'isOutSys', 		title : '系统类型',	width : 55, 	align : 'left', formatter:formatIsOutSys }
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#sysRegList').datagrid("clearChecked");
			//check the select row
			$('#sysRegList').datagrid("selectRow", index);
		}
	});
}

/**
 * 保存
 * 
 * @param 无
 * @param 无
 */
function doSaveSysReg() {
	if(!$('#sysRegForm').form('validate')){
		return;
	}
	var sysFlag =  $("#sysFlag").textbox('getValue');
	var sysName =  $("#sysName").textbox('getValue');
	var sysUrl =  $("#sysUrl").textbox('getValue');
	//var sysRegCode =  $("#sysRegCode").textbox('getValue');
	var sysDesc =  $("#sysDesc").textbox('getValue');
	var isDisable = $("#isDisable").switchbutton("options").checked;
	if (isDisable) {
		isDisable = "Y";
	} else {
		isDisable = "N";
	}
	/*var isOutSys = $("#isOutSys").switchbutton("options").checked;
	if (isOutSys) {
		isOutSys = "Y";
	} else {
		isOutSys = "N";
	}*/
	var isOutSys = $('#isOutSys').combobox('getValue');
	var url = "";
	if (flag == 0) {
		url = "sysRegController/doSaveSysReg";
		sysReg = {
			sysFlag : sysFlag,
			sysName : sysName,
			sysUrl : sysUrl,
			//sysRegCode : sysRegCode,
			sysDesc : sysDesc,
			isDisable : isDisable,
			isOutSys : isOutSys
		};
	} else {
		url = "sysRegController/doUpdateSysReg";
		sysReg.sysFlag = sysFlag;
		sysReg.sysName = sysName;
		sysReg.sysUrl = sysUrl;
		//sysReg.sysRegCode = sysRegCode;
		sysReg.sysDesc = sysDesc;
		sysReg.isDisable = isDisable,
		sysReg.isOutSys = isOutSys
	}

	$.ajax({
		url : url,
		type : "post",
		async : false,
		data : sysReg,
		success : function(data) {
			$.messager.show({ title:'提示', msg:data.message, showType:'slide' });
			flag = 0;
			if (data.status != '1') {
				$('#sysRegDialog').dialog('close');
				reload();
				initdldata();
			}
		},
		error : function() {
			$.messager.show({ title:'提示', msg:'操作失败！', showType:'slide' });
		}
	});
}

var flag = 0;

/**
 * 新增
 * 
 * @param 无
 * @param 无
 */
function openForm(title) {
	$('#sysRegDialog').dialog({
		title : title
	});
	flag = 0;
	initdldata();
	$("#isDisable").switchbutton("uncheck");
	//$("#isOutSys").switchbutton("uncheck");
	changeDesc();
	$('#sysRegDialog').dialog('open');
}

/**
 * 修改
 * 
 * @param 无
 * @param 无
 */
var sysId = "0";
var sysReg;
function openUpdateForm(title) {
	$('#sysRegDialog').dialog({
		title : title
	});
	initdldata();
	var data = $('#sysRegList').datagrid('getChecked');
	if (data == "") {
		//tips层-下
		layer.tips('请选择一行记录进行修改', '#btn_sys_reg_modify', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			layer.tips('请选择一行记录进行修改', '#btn_sys_reg_modify', { tips: 3 });
			//$.messager.alert('提示', '请选择一行进行修改！', 'info');
			return;
		}
		sysReg = data[0];
		$("#sysFlag").textbox('setValue',sysReg.sysFlag);
		$("#sysName").textbox('setValue',sysReg.sysName);
		$("#sysUrl").textbox('setValue',sysReg.sysUrl);
		$("#sysRegCode").textbox('setValue',sysReg.sysRegCode);
		$("#sysDesc").textbox('setValue',sysReg.sysDesc);
		$("#orgId").val(data[0].orgId);
		sysId = data[0].sysId;
		flag = 1;

		// 是否禁用 Y禁用 N启用
		var isDisable = sysReg.isDisable;
		changeDesc();
		$('#sysRegDialog').dialog("open");
		if (isDisable == "Y") {
			$("#isDisable").switchbutton("check"); 
		} else {
			$("#isDisable").switchbutton("uncheck"); 
		}
		// 是否外系统 Y是 N否
		var isOutSys = sysReg.isOutSys;
		$('#isOutSys').combobox('setValue',isOutSys);
		/*if (isOutSys == "Y") {
			$("#isOutSys").switchbutton("check"); 
		} else {
			$("#isOutSys").switchbutton("uncheck"); 
		}*/
	}
}

/**
 * 删除
 * 
 * @param 无
 * @param 无
 */
function doDeleteSysReg() {
	var selecteds = $('#sysRegList').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		layer.tips('请选择需要删除的记录', '#btn_sys_reg_del', { tips: 3 });
		//$.messager.alert('提示', '请选择需要删除的记录！', 'info');
		return;
	}
	$.messager.confirm('删除角色', '确定删除吗?', function(r) {
		if (r) {
			id = selecteds[0].sysId;
			$.ajax({
				url : 'sysRegController/doDeleteSysReg',
				async : false,
				dataType : 'json',
				data : {id : id},
				success : function(result) {
					if (result.status == '200') {
						$.messager.show({ title:'提示', msg:result.msg, showType:'slide' });
						reload();
						$('#sysRegList').datagrid('clearSelections'); // 清空选中的行
					} else {
						$.messager.show({ title:'提示', msg:result.msg, showType:'slide' });
					}
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
	$('#sysRegList').datagrid('reload', {});
}

/**
 * 初始化dialog清空数据
 * 
 * @param 无
 * @param 无
 */
function initdldata() {
	$("#sysFlag").textbox('setValue',"");
	$("#sysName").textbox('setValue',"");
	$("#sysUrl").textbox('setValue',"");
	$("#sysRegCode").textbox('setValue',"");
	$("#sysDesc").textbox('setValue',"");
	// 是否禁用 Y禁用 N启用
	$("#isDisable").switchbutton("uncheck"); 
	// 是否外系统 Y是 N否
	//$("#isOutSys").switchbutton("uncheck"); 
}

/**
 * 条件查询
 * 
 * @param 无
 * @param 无
 */
function findByCondition(){
	var sysFlagAndName = $("#sysFlagAndName").textbox('getValue');
	$('#sysRegList').datagrid({
        url:"sysRegController/findByCondition",
        queryParams:{
        	sysFlagAndName : sysFlagAndName,
        	date:new Date()
        }
    });
}

/*************************** 格式化字段值 ***************************/
/**
 * 格式化是否禁用字段
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatIsDisable(val, row) {
	if(val == null || val == ''){
	   return null;
	}
	if(val == "Y") {
		return "<span style=\'color:red\'>是</span>";
	}
	if(val == "N") {
	   return '否';
	}
	return '';
}

/**
 * 格式化是否外围系统字段
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatIsOutSys(val, row) {
	if(val == null || val == ''){
	   return null;
	}
	if(val == "0") {
	   return '生长系统';
	}
	if(val == "1") {
	   return '接入系统';
	}
	if(val == "2") {
	   return '支撑平台';
	}
	return '';
}

/*************************** 公共函数 *****************************/
/**
 * 清空查询框值
 * 
 * @param 无
 * @returns 无
 */
function clearSearchBox(){
	 $("#sysFlagAndName").searchbox("setValue", "");
}

function toSetLogo(){
	var data = $('#sysRegList').datagrid('getChecked');
	if (data == "") {
		//tips层-下
		layer.tips('请选择一行记录进行操作', '#btn_sys_reg_logo', { tips: 3 });
		return;
	}
	if (data.length > 1) {
		layer.tips('请选择一行记录进行操作', '#btn_sys_reg_logo', { tips: 3 });
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		return;
	}
	var isOutSys = data[0].isOutSys;
	$("#logoFrame").attr("src",ctx+"/sysLogoController/logoConfig?sysType="+isOutSys);
	$("#logoDialog").dialog('open');
}

function toSetTheme(){
	var data = $('#sysRegList').datagrid('getChecked');
	if (data == "") {
		//tips层-下
		layer.tips('请选择一行记录进行操作', '#btn_sys_reg_theme', { tips: 3 });
		return;
	}
	if (data.length > 1) {
		layer.tips('请选择一行记录进行操作', '#btn_sys_reg_theme', { tips: 3 });
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		return;
	}
	if (data[0].isOutSys != '0') {
		layer.tips('请选择\'生长系统\'进行设置', '#btn_sys_reg_theme', { tips: 3 });
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		return;
	}
	sysId = data[0].sysId;
	
	$("#search1").searchbox("setValue","");
	$('#themeList').datagrid('clearChecked');
	reloadSysTheme();
	ids = [];
	cks = [];
	$("#themeDialog").dialog('open');
}

function findSysTheme() {
	var url = "themeController/findSysTheme";
	$('#themeList').datagrid({
		url : url,
		method : 'POST',
		idField : 'themeId',
		toolbar : '#toolBar1',
		striped : true,
		fitColumns : true,
		selectOnCheck : true,
		checkOnSelect : true,
		fit : true,
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		pageSize : 10,
		showFooter : true,
		queryParams : {
			sysId : sysId
		},
		columns : [ [ 
 		   { field : 'ck', checkbox : true }, 
 		   { field : 'themeName', 	title : '主题名称', 	width : 100, 	align : 'left'},
		   { field : 'themeCode',   title : '主题编码',	width : 100, 	align : 'left'},
		   { field : 'isDefault',   title : '是否默认',	width : 100, 	align : 'left',
			   formatter : function(value, row) {
				if (value == 'Y') {
					return '是';
				}   
				return '否';
			}}
 		] ],
		onLoadSuccess : function(data) {
			if (data!=null&&data.rows[0] != null) {
				for(var i=0;i<data.rows.length;i++){
					if(data.rows[i].checked==true){
						 $('#themeList').datagrid('selectRow',i);
					}
				}
            }
		},
		onCheck : function(index, row) {
			insertSelectData(row);
		},
		onUncheck : function(index, row) {
			var themeId = row.themeId;
			removeTheme(themeId);
		},
		onCheckAll : function(rows) {
			$(rows).each(function(index,row){
				insertSelectData(row);
			});
		},
		onUncheckAll : function(rows) {
			$(rows).each(function(index,row){
				removeTheme(row.themeId);
			});
		}
	});
}

var ids = [];
var cks = [];
function insertSelectData(row){
	var themeId = row.themeId;
	if (isCon(ids,themeId)) {
		updateData(themeId,"true");
	} else {
		ids.push(row.themeId);
		cks.push("true");
	}
}

function removeTheme(themeId){
	if (isCon(ids,themeId)) {
		updateData(themeId,"false");
	} else {
		ids.push(themeId);
		cks.push("false");
	}
}

function updateData(themeId,type){
	for (var i = 0; i < ids.length; i++) {
        if (ids[i] == themeId) {    
        	cks[i] = type;
            break;    
        }
    }
}

function findByCondition1() {
	//var url = "roleUserController/findByCondition";
	
	reloadSysTheme();
	/*$('#userList').datagrid({
		url : url,
		queryParams : {
			orgId : orgId,
			roleId : roleId,
			searchValue : $("#search1").searchbox('getValue')
		},
	});*/
}

function doSaveSysTheme(){
	$.ajax({
		url : 'themeController/doSaveSysTheme',
		dataType : 'json',
		async : false,
		type : "POST",
		data : {themeIds : ids.toString(),cks : cks.toString(),sysId : sysId},
		success : function(result) {
			
			ids = [];
			cks = [];
			var msg = result;
			$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
			$('#themeDialog').dialog('close');
			//window.parent.closeAndReloadTab("关联用户","");
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});
}

function clearSearchBox1(){
	 $("#search1").searchbox("setValue","");
}

/**
 * 重新加载列表
 */
function reloadSysTheme() {
	
	$('#themeList').datagrid('load', {
		sysId : sysId,
		searchValue : $("#search1").searchbox('getValue')
	});
}

function isCon(arr, val) {
	for (var i = 0; i < arr.length; i++) {
		if (arr[i] == val)
			return true;
	}
	return false;
}

/**
 * 监控系统名称的改变，系统描述跟着改变
 */
function changeDesc(){
    $('#sysName').textbox({
        onChange: function(value){ 
            var sysName = $("#sysName").textbox("getValue");
            $("#sysDesc").textbox("setValue",sysName);
        }
      });  
}