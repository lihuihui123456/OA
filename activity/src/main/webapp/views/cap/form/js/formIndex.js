/**
 * 初始化函数
 */
$(function() {
	InitTreeData();
	initData();
	getHelp();
	getChange();
	$('#col_key').switchbutton({
        checked: false,
        onChange: function(checked){
            if (checked) {
            	$("#col_length").textbox("setValue","64");
				$("#col_length").textbox("disable");
			} else {
				$("#col_length").textbox("setValue","");
				$("#col_length").textbox("enable");
			}
        }
    })
/*	$("#ref_type").combobox("disable");*/
	$("#dic_type").combobox("disable");
/*	$("#ref_obj").combobox("disable");*/
});
/**
 * 全局变量
 * */
var oldTableName = "";
/**
 * 初始化下拉列表数据
 */
function initData(){
	initDictnew({
		"col_type":"zdlx"
	},'true');
	initDictnew({
		"ctr_type":"kjlx"
	},'true');
	
	initDictnew({
		"ref_type":"czlx"
	},'true');
	initDictnew({
		"ref_obj":"czdx"
	},'true');
	allDicttypenew("dic_type");
	
}
var typeid = "";

/**
 * 初始化加载左侧树
 */
function InitTreeData() {
	$('#tree').tree({
		url : 'formTableController/findAllFormTable',
		animate : true,// 开启折叠动画
		checkbox : false,
		onlyLeafCheck : true,
		// 树加载成功后回调函数（用于初始化列表）
		onLoadSuccess : function(node, data) {
			findListDataById();
		},
		onClick : function(node) {
			typeid = node.id;
			reload();
		},
		onContextMenu : function(e, node) {
			e.preventDefault();
			$('#tree').tree('select', node.target);
			var nodes = $('#tree').tree('getSelected', 'info');
			if (nodes.id == '0') {
				$("#addMenu").show();
				$("#editMenu").hide();
				$("#delMenu").hide();
				$("#copyMenu").hide();
			} else if (nodes.id != null && nodes.id != '0') {
				$("#addMenu").hide();
				$("#editMenu").show();
				$("#delMenu").show();
				$("#copyMenu").show();
			}
			// 打开菜单
			$('#mm').menu('show', {
				left : e.pageX,
				top : e.pageY
			});
		}
	});
}

/**
 * 新增数据库表信息
 */
function addNote() {

	$("#tableCode").textbox('setValue', "");
	$("#tableCode").textbox('enable');
	$("#tableName").textbox('setValue', "");
	$("#remark").textbox('setValue', "");
	nodeid = '';
	copyflag='';
	$('#formTableDialog').dialog({
		title : "新增数据库表"
	});
	$('#formTableDialog').dialog('open');
}

/**
 * 删除数据库表信息
 */
function delNote() {
	var nodes = $('#tree').tree('getSelected', 'info');
	if (nodes == null) {
		$.messager.alert('提示', '请选择操作项!');
		return;
	} else if (nodes.id == '0') {
		$.messager.alert('提示', '父级节点不可删除!');
		return;
	} else {
		$.messager.confirm('提示', '确定删除' + nodes.text + '吗?', function(r) {
			if (r) {
				$.post("formTableController/checkTableData", {
					"tableid" : nodes.id
				}, function(data) {
					if (data == 'N') {
						$.messager.alert('提示', '数据库表含有数据,不可删除');
						return;
					} else {
						$.post("formTableController/doDeleteFormTable", {
							"ids" : nodes.id
						}, function(data) {
							$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
							InitTreeData();
							reload();
						});
					}
				});
			}
		});
	}
}
var copyflag="";
/**
 * 复制数据库表信息
 */
function copyNote(){
	var node = $('#tree').tree('getSelected');
	if (node) {
		nodeid = node.id;
		$("#tableCode").textbox('setValue', node.code);
		$("#tableName").textbox('setValue', node.text);
		$("#remark").textbox('setValue', node.remark);
		$('#formTableDialog').dialog({
			title : "复制数据库表"
		});
		copyflag="true";
		$('#formTableDialog').dialog('open');
	}
}
var nodeid = "";
/**
 * 修改数据库表信息
 */
function modNote() {
	var node = $('#tree').tree('getSelected');
	copyflag="";
	if (node) {
		nodeid = node.id;
		$("#tableCode").textbox('setValue', node.code);
		$("#tableCode").textbox('disable');
		$("#tableName").textbox('setValue', node.text);
		$("#remark").textbox('setValue', node.remark);
		if (node.isFloat == "Y") {
			$("#isFloat").switchbutton("check");
		} else {
			$("#isFloat").switchbutton("uncheck");
		}
		$('#formTableDialog').dialog({
			title : "修改数据库表"
		});
		oldTableName = node.text;
		$('#formTableDialog').dialog('open');
	}
}

/**
 * 保存数据库表信息
 */
function savetype() {
	if (!$('#tableForm').form('validate')) {
		return;
	}
	var isFloat = $("#isFloat").switchbutton("options").checked;
	if (isFloat) {
		isFloat = "Y";
	} else {
		isFloat = "N";
	}
	var tableCode = $("#tableCode").textbox('getValue');
	var tableName = $("#tableName").textbox('getValue');
	var remark = $("#remark").textbox('getValue');
	var url = "";
	if(nodeid==""){
		tableCode="FD_"+tableCode;
	}
	var formTable = {
		tableId : nodeid,
		tableCode : tableCode,
		tableName : tableName,
		remark : remark,
		isFloat : isFloat
	};
	if (nodeid == '') {
		url = "formTableController/doSaveFormTable";
		$.ajax({
			url : url,
			type : "POST",
			data : formTable,
			success : function(data) {
				if (data == 'true') {
					$.messager.show({ title:'提示', msg:'保存成功', showType:'slide' });
					$('#formTableDialog').dialog('close');
					InitTreeData();
					reload();
				}
			}
		});
	} else {
		if(copyflag==""){
			url = "formTableController/doUpdateFormTable";
			$.ajax({
				url : url,
				type : "POST",
				data : formTable,
				success : function(data) {
					$.messager.show({ title:'提示', msg:'修改成功', showType:'slide' });
					$('#formTableDialog').dialog('close');
					InitTreeData();
				}
			});
		}else{
			url = "formTableController/doCopyFormTable";
			$.ajax({
				url : url,
				type : "POST",
				data : formTable,
				success : function(data) {
					$.messager.show({ title:'提示', msg:'复制成功', showType:'slide' });
					$('#formTableDialog').dialog('close');
					InitTreeData();
				}
			});
		}
	}
}

/**
 * 重新加载字段数据列表
 */
function reload() {
	$("#col").datagrid("uncheckAll");
	$('#col').datagrid('reload', {
		"tableid" : typeid
	});
}
/**
 * 左侧树搜索
 */
function orgTreeSearch() {
	var searchValue = $("#org_search").searchbox('getValue');
	$("#tree").tree('search', searchValue);
}


var editIndex = undefined;
/** 添加行 * */
function append() {
	if(typeid==""||typeid=="0"){
		//$.messager.alert('提示','请选择元数据');
		layer.tips('请选择元数据', '#btn_add', { tips: 3 });
		return;
	}
	$('#formCloumnDialog').dialog({
		title : "添加字段"
	});
	clearData();
	$('#formCloumnDialog').dialog('open');
}

/** 删除行 * */
function removeit(id) {
	var rows = $('#' + id).datagrid('getSelections');
	if(rows.length<1){
		//$.messager.alert('提示', '请选择操数据');
		layer.tips('请选择数据', '#btn_del', { tips: 3 });
	}else if (rows) {
		$.messager.confirm('提示', '确定删除选中行数据吗?', function(r) {
		if (r) {
			for(var i=0;i<rows.length;i++){
				var row=rows[i];
			var cod_id=row.col_id;
			var editIndex = $('#' + id).datagrid('getRowIndex', row);
				if (editIndex == undefined) {
					return
				}
				if (row.col_id == '' || row.col_id == undefined) {
					$('#' + id).datagrid('cancelEdit', editIndex).datagrid('deleteRow',
							editIndex);
					editIndex = undefined;
				} else {
					$.ajax({
						url :"formColumnController/findDataById",
						type : "post",
						async : false,
						dataType : "json",
						data : {
							"id" : cod_id
						},
						success : function(result) {
							
							if (!result.result == "success") {
								$.messager.alert('提示', row.col_code + '包含数据,不可删除');
								return;
							} else {
								$('#' + id).datagrid('cancelEdit', editIndex).datagrid(
										'deleteRow', editIndex);
								$.ajax({
									url :"formColumnController/dodeleteColBykey",
									type : "post",
									async : false,
									dataType : "json",
									data : {
										"id" : cod_id
									},
									success : function(data) {
										editIndex = undefined;
									}
								});
							}
						}
					});
					$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
				}
			}
		}
	});
	} else {
		$.messager.alert('警告', '选择一条数据');
	}
}
/**
 * 下拉列表绑定指定数据字典
 * @param dictArr
 * @param showAll
 */
function initDictnew(dictArr,showAll){
	for(var code in dictArr)  {
		$('#' + code).combobox({  
		    url: "dictController/findDictByTypeCode?showAll="+showAll+"&dictTypeCode=" + dictArr[code], 
		    valueField: 'dictCode',    
		    textField: 'dictVal'   
		});
	}
}
var temp = "";
/**
 * 下拉列表绑定所有数据字典
 * @param code
 */
function allDicttypenew(code){
	
		$('#' + code).combobox({  
		    url: "dictTypeController/getAllDictType", 
		    valueField: 'code',    
		    textField: 'text'   
		});
	
}
/** 根据编码查询数据字典信息 * */
function initDict(dicttype) {
	$.ajax({
		url : "dictController/findDictByTypeCode",
		type : "get",
		async : false,
		dataType : "json",
		data : {
			"dictTypeCode" : dicttype
		},
		success : function(data) {
			temp = data;
		}
	});
	return temp;
}
/** 加载所有数据字典 * */
function allDicttype() {
	$.ajax({
		url : "dictTypeController/getAllDictType",
		type : "post",
		async : false,
		dataType : "json",
		success : function(data) {
			temp = data;
		}
	});
	return temp;
}

/** 保存变量信息 * */
var saveflag=false;
function savevarcnfgs(id) {
	if(saveflag){
		return;
	}
	saveflag=true;
	if (endEditing($('#' + id))) {
		
		if (!CheckData(id)) {
			return;
		}
		var effectRow = new Object();
		effectRow[id] = JSON.stringify($('#' + id).datagrid('getData'));
		$.ajax({
			url : 'formColumnController/doSaveFormCol?actid=' + id,
			type : 'POST',
			dataType : 'json',
			data : effectRow,
			success : function(result) {
				if (result.result == "success") {
					$.messager.show({ title:'提示', msg:'保存成功', showType:'slide' });
					$('#' + id).datagrid('reload');
				} else {
					$.messager.show({ title:'提示', msg:'保存失败', showType:'slide' });
				}
				saveflag=false;
			}
		});
	}
}
/** 检查数据正确性 * */
function CheckData() {
	var col_code=$("#col_code").val();
	var col_name=$("#col_name").val();
	var col_type=$("#col_type").combobox('getValue');
	var col_length=$("#col_length").val();
	if (col_code == null || col_code == "") {
		$.messager.alert("警告", "字段编码不能为空!");
		return false;
	}else{
		if(!colcode(col_code)||!colvalue(col_code)){
			$.messager.alert("警告", "字段编码字符不正确!");
			return false;
		}
		if(!doubledata(col_code)){
			if(oldcode!=col_code){
			
			}else{
				$.messager.alert("警告", "字段编码重复!");
				return false;
			}
			
		}else{
			if(oldcode==col_code){
				
			}else{
				$.messager.alert("警告", "字段编码重复!");
				return false;
			}
		}
	}
	if (col_name == null || col_name == "") {
		$.messager.alert("警告", "字段名称不能为空!");
		return false;
	}
	if (col_type == null || col_type == "") {
		$.messager.alert("警告", "字段类型不能为空!");
		return false;
	} else if (col_type == "varchar"
			|| col_type == "nvarchar") {
		if (col_length == null || col_length == "") {
			$.messager.alert("警告", "字段类型为varchar字段长度不能为空!");
			return false;
		}
	}
	if (col_length != null && col_length != "") {
		if(!collenght(col_length)){
			$.messager.alert("警告", "字段长度输入格式不正确!");
			return false;
		}
		
	}
	
	return true;
}
/**
 * 检查编码是否符合规则
 * @param value
 * @returns {Boolean}
 */
function colcode(value){
	var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;
	if (reg.test(value)) {
		return true;
	} else {
		return false;
	}
}
/**
 * 检查数据是否符合规则
 * @param value
 * @returns {Boolean}
 */
function colvalue(value){
	 reg = /^\w+$/;
	 if (reg.test(value)) {
			return true;
		} else {
			return false;
		}
}
/**
 * 检查数据长度
 * @param value
 * @returns {Boolean}
 */
function collenght(value){
	var reg = /^[0-9]*$/;
	if (reg.test(value)) {
		return true;
	} else {
		return false;
	}
}
/**
 * 检查数据是否已经存在
 * @param code
 * @returns {Boolean}
 */
function doubledata(code){
	var flag=false;
	$.ajax({
		url : 'formColumnController/checkcode',
		type : 'POST',
		dataType : 'json',
		async : false,
		data :{
			tableid:typeid,
			code:code
		},
		success : function(result) {
			if (result.result == "success") {
				flag=true;
			} else {
				flag=false;
			}
		}
	});
	return flag;
}
/** 权限设置 * */
function setRoles(id) {
	var rows = $('#' + id).datagrid('getSelections');
	var colid="";
	if(rows!=null&&rows.length>0){
		for(var i=0;i<rows.length;i++){
			var row=rows[i];
			if(row.col_id==null||row.col_id==""){
				$.messager.alert("警告", "未保存数据不能配置,请先保存!");
				return ;
			}
			colid+="'"+row.col_id+"'";
			if(i!=rows.length-1){
				colid+=",";
			}
		}
		var url = "formUserRuleController/form_rule_index?colid=" + colid;
		$('#ifrole').attr("src", url);
		$('#setrole').dialog('open');
	} else {
		//$.messager.alert("警告", "请选择数据!");
		layer.tips('请选择数据', '#btn_perm', { tips: 3 });
	}
}
/** 对外权限设置，暂时未用 * */
function setServeRoles() {
	if(typeid==""||typeid=="0"){
		$.messager.alert('提示','请选择元数据');
		return;
	}else{
		var url = "formServeUserRuleController/form_rule_index?tableid="+typeid+"&serveid=1";
		$('#ifrole').attr("src", url);
		$('#setrole').dialog('open');
	}
		
}
/** 数据初始化配置 * */
function setDatas(id) {
	var rows = $('#' + id).datagrid('getSelections');
	var colid="";
	if(rows!=null&&rows.length>0){
		for(var i=0;i<rows.length;i++){
			var row=rows[i];
			if(row.col_id==null||row.col_id==""){
				$.messager.alert("警告", "未保存数据不能配置,请先保存!");
				return ;
			}
			colid+="'"+row.col_id+"'";
			if(i!=rows.length-1){
				colid+=",";
			}
		}
		var url = "formDataRuleController/form_data_index?colid=" + colid;
		$('#ifdata').attr("src", url);
		$('#setdata').dialog('open');
	}else {
		//$.messager.alert("警告", "请选择数据!")
		layer.tips('请选择数据', '#btn_set', { tips: 3 });
	}
}
function getSelectRow() {
	/*
	 * var row=$('#'+id).datagrid('getSelected'); return row;
	 */
}
/**
 * 根据查询条件查询
 */
function findByCondition(){
	var searchValue = $("#search").searchbox('getValue');
	$('#col').datagrid({
		url : 'formColumnController/findFormColspage',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录!',
		queryParams:{
			'tableid' : typeid,
			'searchValue': $.trim(searchValue)
		},
		onLoadSuccess: function(data) {
			// $.messager.show({ title:'提示', msg:'搜索到 <span
			// style="color:red">'+data.rows.length+'</span> 条数据',
			// showType:'slide' });
		}
	});
	$('#postDataGrid').datagrid('load');}
/**
 * 清空查询框
 */
function clearSearchBox(){
	 $("#search").searchbox("setValue","");
}
/**
 * 加载数据字段信息
 */
function findListDataById(){
		$('#col').datagrid({
			url : 'formColumnController/findFormColspage',
			method : 'POST',
			queryParams : {
				'tableid' : typeid
			},
			view : dataGridExtendView,
			emptyMsg : '没有相关记录!',
			cache : false,
			
			toolbar:'#tb', 
			striped:true, 
			fit:true, 
			fitColumns:true, 
			singleSelect:false,
			selectOnCheck:true, 
			checkOnSelect:true, 
			rownumbers:true,
			showFooter:true, 
			pagination:true, 
			nowrap:false,
			columns : [ [ {
				field : 'ck',
				checkbox : true
			}, {
				field : 'col_id',
				title : 'col_id',
				hidden : true
			}, {
				field : 'table_id',
				title : 'table_id',
				hidden : true
			}, {
				field : 'col_code',
				title : '字段编码',
				width : 80,
				align : 'center'
			}, {
				field : 'col_name',
				title : '字段名称',
				width : 80,
				align : 'center'
			}, {
				field : 'col_type',
				title : '字段类型',
				width : 80,
				formatter : function(value, row) {
					var temp = initDict('zdlx');
					for(var i = 0; i < temp.length; i++) {
						if (temp[i].dictCode == value) {
							return temp[i].dictVal;
						}
				}
					},
				align : 'center'
			},{
				field : 'col_length',
				title : '字段长度',
				width : 80,
				align : 'center'
			},{
				field : 'col_key',
				title : '主键',
				width : 80,
				align : 'center'
			},{
				field : 'ismemory',
				title : '辅助输入',
				width : 80,
				align : 'center'
			},
			{
				field : 'wf_key',
				title : '流程',
				width : 80,
				align : 'center'
			},
			{
				field : 'ctr_type',
				title : '控件',
				width : 80,
				 formatter : function(value,row){
  					var temp=initDict('kjlx');
						for(var i = 0; i < temp.length; i++) {
						if (temp[i].dictCode == value) {
							return temp[i].dictVal;
						}
				}},
				align : 'center'
			},{
				field : 'ref_type',
				title : '参照类型',
				width : 80,
				hidden : true,
				 formatter : function(value,row){
  					var temp=initDict('czlx');
						for(var i = 0; i < temp.length; i++) {
						if (temp[i].dictCode == value) {
							return temp[i].dictVal;
						}
				}},
				align : 'center'
			},{
				field : 'ref_obj',
				title : '参照对象',
				width : 80,
				hidden : true,
				 formatter : function(value,row){
  					var temp=initDict('czdx');
						for(var i = 0; i < temp.length; i++) {
						if (temp[i].dictCode == value) {
							return temp[i].dictVal;
						}
				}},
				align : 'center'
			},{
				field : 'dic_type',
				title : '值域 ',
				width : 80,
				 formatter : function(value,row){
  					var temp=allDicttype();
  					for(var i = 0; i < temp.length; i++) {
						if (temp[i].code == value) {
							return temp[i].text;
						}
				}},
				align : 'center'
			},{
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
	/*
	 * var pg = $("#col").datagrid("getPager"); if(pg){ $(pg).pagination({
	 * onBeforeRefresh:function(){ reload(); },
	 * onRefresh:function(pageNumber,pageSize){ reload(); },
	 * onChangePageSize:function(){ reload(); },
	 * onSelectPage:function(pageNumber,pageSize){ reload(); } }); }
	 */
}
/**
 * 保存方法
 */
function savecolumn(){
	if(!CheckData()){
		return;
	}
	var col_code=$("#col_code").val();
	var col_name=$("#col_name").val();
	var col_type=$("#col_type").combobox('getValue');
	var col_length=$("#col_length").val();
	
	var col_key = $("#col_key").switchbutton("options").checked;
	if (col_key) {
		col_key = "P";
	} else {
		col_key = "";
	}
	var wf_key = $("#wf_key").switchbutton("options").checked;
	if (wf_key) {
		wf_key = "Y";
	} else {
		wf_key = "N";
	}
	var ismemory = $("#ismemory").switchbutton("options").checked;
	if (ismemory) {
		ismemory = "Y";
	} else {
		ismemory = "N";
	}
	var ctr_type=$("#ctr_type").combobox('getValue');
	/*var ref_type=$("#ref_type").combobox('getValue');*/
	var dic_type=$("#dic_type").combobox('getValue');
	/*var ref_obj=$("#ref_obj").combobox('getValue');*/
	var data=null;
	var url = "";
	if(colid!=null&&colid!=""){
		data={
				table_id:typeid,
				col_id:colid,
				col_code:col_code,
				col_name:col_name,
				col_type:col_type,
				col_length:col_length,
				col_key:col_key,
				wf_key:wf_key,
				ctr_type:ctr_type,
				ref_type:'',
				dic_type:dic_type,
				ref_obj:'',
				ismemory:ismemory
			};
		url = "formColumnController/doUpdateCol";
	}else{
		data={
				table_id:typeid,
				col_code:col_code,
				col_name:col_name,
				col_type:col_type,
				col_length:col_length,
				col_key:col_key,
				wf_key:wf_key,
				ctr_type:ctr_type,
				ref_type:'',
				dic_type:dic_type,
				ref_obj:'',
				ismemory:ismemory
			};
		url = "formColumnController/saveFormCol";
	}
	$.ajax({
		url : url,
		type : "post",
		async : false,
		dataType : "json",
		data:data,
		success : function(data) {
			if(data.code=='200'){
				$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
				$('#formCloumnDialog').dialog('close');
				reload();
				clearData();
			}else{
				$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
			}
		}
	});
}
var colid=null;
var oldcode="";
/**
 * 行编辑方法//已经弃用
 */
function edit(){
	var rows = $('#col').datagrid('getSelections');
	if(rows==null||rows.length==0){
		//$.messager.alert("警告", "请选择数据!");
		layer.tips('请选择数据', '#btn_edit', { tips: 3 });
		return;
	}else if(rows.length>1){
		//$.messager.alert("警告", "请选择单条数据修改!");
		layer.tips('请选择单条数据修改', '#btn_edit', { tips: 3 });
		return;
	}else{
		clearData();
		var row=rows[0];
		colid=row.col_id;
		oldcode=row.col_code;
		$("#col_code").textbox('setValue',row.col_code);
		$("#col_name").textbox('setValue',row.col_name);
		$("#col_type").combobox('setValue',row.col_type);
		$("#col_length").textbox('setValue',row.col_length);
		if(row.col_key=="P"){
			$("#col_key").switchbutton("check");
		}else{
			$("#col_key").switchbutton("uncheck");
		}
		if(row.wf_key=="Y"){
			$("#wf_key").switchbutton("check");
		}else{
			$("#wf_key").switchbutton("uncheck");
		}
		if(row.ismemory=="Y"){
			$("#ismemory").switchbutton("check");
		}else{
			$("#ismemory").switchbutton("uncheck");
		}
		var ctr_type=$("#ctr_type").combobox('setValue',row.ctr_type);
/*		var ref_type=$("#ref_type").combobox('setValue',row.ref_type);*/
		var dic_type=$("#dic_type").combobox('setValue',row.dic_type);
/*		var ref_obj=$("#ref_obj").combobox('setValue',row.ref_obj);*/
		$('#formCloumnDialog').dialog({
			title : "添加字段"
		});
		$('#formCloumnDialog').dialog('open');
	}
	
}
/**
 * 清空控件内容
 */
function clearData(){
	colid="";
	$("#col_code").textbox('setValue','');
	$("#col_name").textbox('setValue','');
	$("#col_type").combobox('setValue',"");
	$("#col_length").textbox('setValue','');
	$("#col_length").textbox('enable');
	$("#col_key").switchbutton("uncheck");
	$("#wf_key").switchbutton("uncheck");
	$("#ismemory").switchbutton("uncheck");

	var ctr_type=$("#ctr_type").combobox('setValue','');
	/*var ref_type=$("#ref_type").combobox('setValue','');*/
	var dic_type=$("#dic_type").combobox('setValue','');
	/*var ref_obj=$("#ref_obj").combobox('setValue','');*/
}
/**
 *  扩展方法，点击事件触发一个单元格的编辑
 */
$.extend($.fn.datagrid.methods, {
	editCell : function(jq, param) {
		var row = $('#col').datagrid('getSelected');
		$.post("formTableController/checkTableData", {
			"tableid" : row.table_id
		}, function(data) {
			if (data == 'N') {
				if ('col_key' == param.field) {
					return;
				} else {
					if (row.col_id == null) {
						return jq.each(editCell(param));
					} else if (row.col_id != null) {
						$.post("formColumnController/findDataById", {
							"id" : row.col_id
						}, function(data) {
							if (data == 'N') {
								if ('col_name' == param.field) {
									return jq.each(editCell(param));
								}
							} else {
								return jq.each(editCell(param));
							}
						});
					}
				}
			} else {
				return jq.each(editCell(param));
			}
		});
	}
});

/**
 * 验证信息
 */
$.extend($.fn.textbox.defaults.rules,
				{
					checkTalCode : {
						validator : function(value) {
							var reg = /^\w+$/;
							if (reg.test(value)) {
								return true;
							} else {
								return false;
							}
						},
						message : '由数字、字母或下划线组成'
					},
					checkTalName : {
						validator : function(value) {
							var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;
							if (reg.test(value)) {
								return true;
							} else {
								return false;
							}
						},
						message : '不能包含特殊字符'
					},
					checkColCode : {
						validator : function(value) {
							var reg = /^\w+$/;
							if (reg.test(value)) {
								return true;
							} else {
								return false;
							}
						},
						message : '由数字、字母或下划线组成'
					},
					checkColName : {
						validator : function(value) {
							var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;
							if (reg.test(value)) {
								return true;
							} else {
								return false;
							}
						},
						message : '不能包含特殊字符'
					},
					checkNumber : {
						validator : function(value) {
							var reg = /^[0-9]*$/;
							if (reg.test(value)) {
								return true;
							} else {
								return false;
							}
						},
						message : '请输入数字'
					},
					colCodeRepeat : {
						validator : function(value) {
							
							var count = 0;
							var arr = $('#col').datagrid('getData');
							for (var i = 0; i < arr.rows.length; i++) {
								if (value == arr.rows[i].col_code) {
									count = count + 1;
								}
							}
							if (count > 1) {
								return false;
							} else {
								return true;
							}
						},
						message : '字段编码重复'
					},
					colNameRepeat : {
						validator : function(value) {
							var count = 0;
							var arr = $('#col').datagrid('getData');
							for (var i = 0; i < arr.rows.length; i++) {
								if (value == arr.rows[i].col_name) {
									count = count + 1;
								}
							}
							if (count > 1) {
								return false;
							} else {
								return true;
							}
						},
						message : '字段名称重复'
					},
					talNameRepeat : {
						validator : function(value) {
							if(value.indexOf("FD_")<0){
								value="FD_"+value;
							}
							var falg = 1;
							$.ajax({
								url : "formTableController/checkTableName",
								type : "post",
								async : false,
								cache : false,
								data : {
									"name" : value
								},
								success : function(data) {
									if ('N' == data) {
										falg = 0;
									}
								}
							});
							if (falg == 0) {
								return false;
							} else {
								return true;
							}
						},
						message : '表名重复'
					},
					talCHNameRepeat : {
						validator : function(value) {
							var falg = 1;
							if ($.trim(oldTableName) == $.trim(value)) {
								return true;
							}
							$.ajax({
								url : "formTableController/checkTableByName",
								type : "post",
								async : false,
								cache : false,
								data : {
									"name" : value
								},
								success : function(data) {
									if ('N' == data) {
										falg = 0;
									}
								}
							});
							if (falg == 0) {
								return false;
							} else {
								return true;
							}
						},
						message : '中文名重复'
					}
				});
/**
 * 添加帮助信息
 */
function getHelp(){
	setHelp('hp_ctr_type','','控件类型');
	setHelp('hp_ref_type','','参照类型');
	setHelp('hp_dic_type','','数据字典');
	setHelp('hp_ref_obj','','参照对象');
}
/**
 * 设置帮助信息
 * @param id
 * @param url
 * @param title
 */
function setHelp(id,url,title){
	$('#'+id).tooltip({
        content: $('<div></div>'),
        showEvent: 'click',
        onUpdate: function(content){
            content.panel({
                width: 200,
                border: false,
                title: title,
                href: url
            });
        },
        onShow: function(){
            var t = $(this);
            t.tooltip('tip').unbind().bind('mouseenter', function(){
                t.tooltip('show');
            }).bind('mouseleave', function(){
                t.tooltip('hide');
            });
        }
    });
}
/**
 * 监听下拉列表改变事件
 */
function getChange(){
	$("#ctr_type").combobox({

		onChange: function (n,o) {

			var type=$("#"+this.id).combobox('getValue');
			
			if(type!="sys_dic"){				
				/*$("#ref_type").combobox("setValue","");*/
				$("#dic_type").combobox("setValue","");
			/*	$("#ref_obj").combobox("setValue","");
				$("#ref_type").combobox("disable");*/
				$("#dic_type").combobox("disable");
			/*	$("#ref_obj").combobox("disable");*/
			}else{
				/*$("#ref_type").combobox("enable");*/
				$("#dic_type").combobox("enable");
				/*$("#ref_obj").combobox("enable");*/
			}

		}});
	/** 绑定字段类型onchange事件，add by 王建坤,2017-05-02 */
	$("#col_type").combobox({
		onChange : function(newValue,oldValue){
			if (newValue == 'datetime' || newValue == 'blob' || newValue == 'text') {
				$("#col_length").textbox('setValue','');
				$("#col_length").textbox('disable');
			} else {
				$("#col_length").textbox('enable');
			}
		}
	});
	/*$("#ref_type").combobox({

		onChange: function (n,o) {

			var type=$("#"+this.id).combobox('getValue');
			if(type!="sys_dic"&&type!=null&&type!=''){
				$("#dic_type").combobox("disable");
				$("#ref_obj").combobox("enable");
			}else if(type==null||type==''){
				$("#dic_type").combobox("disable");
				$("#ref_obj").combobox("disable");
			}else{
				$("#dic_type").combobox("enable");
				$("#ref_obj").combobox("disable");
			}

		}});*/
}