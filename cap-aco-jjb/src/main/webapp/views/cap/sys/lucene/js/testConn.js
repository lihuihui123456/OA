$(function() {
	initTree();
	getListdata();
	initData();
	changeTime();
});

/**
 * 初始化加载左侧树
 */
function initTree() {
	$('#dataSource').tree({
		url : "luceneController/findDataSourceTree",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		onClick : function(node) {
			// 点击某一注册系统时，加载对应系统下的模块
			$('#dataSource').tree('expand', node.target);
			$("#dbsid").val(node.id);
			reload(node.id);
			//$('#roleList').datagrid('clearChecked');
		}
	});
}

function initData() {
	initDict({
		"index_type" : "indextype"
	}, 'false');
}

function createIndex() {
	var alltime="1";//全部数据
	var start_time="";
	var end_time="";
	var selecteds = $('#tb1').datagrid('getSelections');
	if (selecteds == null) {
		alert("请选择要创建索引的数据")
		return;
	}
	if($("#isAdmin").switchbutton("options").checked){
		alltime="1";
	}else{
		alltime="0";
		start_time=$("#start_time").datebox('getValue');
		end_time=$("#end_time").datebox('getValue');
		if(start_time==""||end_time==""){
			alert("请选择时间区间");
			return ;
		}
	}
	
	var id = selecteds[0].id;
	var dbsid = selecteds[0].sysLuceneId;
	var sql = selecteds[0].luceSelect;
	$.ajax({
		url : 'luceneController/createDataIndex',
		type : "post",
		data : {
			id : id,
			dbsid : dbsid,
			sql : sql,
			alltime:alltime,
			starttime:start_time,
			endtime:end_time
		},
		beforeSend: function () {
			$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%" }).appendTo("#choice_time");
            $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍待。。。").appendTo("#choice_time").css({ display: "block" });
	    },
		success : function(data) {
			
			$(".datagrid-mask").css({ display: "none"});
            $(".datagrid-mask-msg").css({ display: "none" })
            
			if(data=="true"){
				alert("索引创建成功");
				$('#choice_time').dialog('close');
			}else{
				alert("索引创建失败");
			}
		},
		error : function(data) {
			alert("服务器出错，创建失败");
		}
	});
}

function changeTime(){
	  var s_input = $("#start_time").siblings().eq(0).children().eq(1);
	  $(s_input).css("background-color","#ebebe5");
	  var e_input = $("#end_time").siblings().eq(2).children().eq(1);
	  $(e_input).css("background-color","#ebebe5");
	 $('#isAdmin').switchbutton({  
	      checked: true,  
	      onChange: function(checked){  
	    	  if($("#isAdmin").switchbutton("options").checked){
	    		  $("#start_time").datebox({ disabled: true });
	    		  $("#end_time").datebox({ disabled: true });
	    		  var s_input = $("#start_time").siblings().eq(0).children().eq(1);
	    		  $(s_input).css("background-color","#ebebe5");
	    		  var e_input = $("#end_time").siblings().eq(2).children().eq(1);
	    		  $(e_input).css("background-color","#ebebe5");
	    	  }else{
	    		  $("#start_time").datebox({ disabled: false });
	    		  $("#end_time").datebox({ disabled: false });
	    		  var s_input = $("#start_time").siblings().eq(0).children().eq(1);
	    		  $(s_input).css("background-color","white");
	    		  var e_input = $("#end_time").siblings().eq(2).children().eq(1);
	    		  $(e_input).css("background-color","white");
	    	  }
	      }  
	 }); 
}
/**
 * 初始化接口类型树
 */

function getListdata() {
	$('#tb1').datagrid({
		//url : 'luceneController/findSqlsById?id=' + id,
		method : 'POST',
		idField : 'id',
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
			field : 'id',
			title : 'id',
			hidden : true
		}, {
			field : 'sysLuceneId',
			title : '数据库id',
			hidden : true
		}, {
			field : 'index_type',
			title : '索引类型',
			width : 80,
			formatter : function(value, row) {
				var temp = initDictNew('indextype');
				for (var i = 0; i < temp.length; i++) {
					if (temp[i].dictCode == value) {
						return temp[i].dictVal;
					}
				}
			},
			align : 'center'
		},{
			field : 'luce_table',
			title : '表名',
			width : 80,
			align : 'center'
		}, {
			field : 'luce_id',
			title : '主键字段',
			width : 80,
			align : 'center'
		}, {
			field : 'luce_title',
			title : '标题字段',
			width : 80,
			align : 'center'
		}, {
			field : 'luce_contents',
			title : '内容字段',
			width : 80,
			align : 'center'
		}, {
			field : 'luce_path',
			title : '连接地址',
			width : 80,
			align : 'center',
			hidden : true
		}, {
			field : 'luce_time',
			title : '时间字段',
			width : 80,
			align : 'center'
		}, 
		/*{
			field : 'luce_role',
			title : '权限字段',
			width : 80,
			align : 'center'
		}, {
			field : 'luce_key',
			title : '其他业务字段',
			width : 80,
			align : 'center'
		},*/
		{
			field : 'luce_annex',
			title : '附件字段',
			width : 80,
			align : 'center'
		},{
			field : 'luce_document',
			title : '对应字段',
			width : 80,
			align : 'center',
			hidden : true
		}, {
			field : 'luceSelect',
			title : 'sql语句',
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
/**
 * 重新加载接口类型树
 */
function reload(typeid) {
	$('#tb1').datagrid({
		url : 'luceneController/findSqlsById',
		queryParams : {
			'id' : typeid
		}
	});
	$('#tb1').datagrid('clearSelections'); // 清空选中的行
	$('#tb1').datagrid('clearChecked'); // 清空选中的行

}

/**
 * 弹出新增sql信息页面
 */
function savesqls() {
	var node = $('#dataSource').tree('getSelected');
	if (node == null || node.id == '' || node.id == '0') {
		//$.messager.alert('提示', '请选择数据库！');
		layer.tips('请选择数据库', '#btn_add', { tips: 3 });
		return;
	}
	clearData();
	$('#add_sql_dialog').dialog({
		title : "添加sql语句"
	});
	$('#add_sql_dialog').dialog("open");
}
/**
 * 弹出选择索引时间界面
 */
function choiseTime() {
	var data = $('#tb1').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行操作！');
		layer.tips('请选择一行进行操作', '#btn_create', { tips: 3 });
		return;
	}
	$('#choice_time').dialog({
		title : "选择索引时间"
	});
	
	$("#isAdmin").switchbutton("check");
	$("#start_time").datebox("setValue","");
	$("#end_time").datebox("setValue","");
	$('#choice_time').dialog("open");
}

var id = 0;
/**
 * 弹出修改sql信息页面
 */
function updatesql() {
	var data = $('#tb1').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('修改接口数据', '请选择一行进行修改！');
		layer.tips('请选择一行进行操作', '#btn_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('修改接口数据', '请选择一行进行修改！');
			layer.tips('请选择一行进行操作', '#btn_edit', { tips: 3 });
			return;
		}
		id = data[0].id;
		dbsid = data[0].sysLuceneId;
		sql = data[0].luceSelect;
		var luce_id=data[0].luce_id;
		var luce_title=data[0].luce_title;
		var luce_contents=data[0].luce_contents;
		var luce_path=data[0].luce_path;
		var luce_time=data[0].luce_time;
		var luce_role=data[0].luce_role;
		var index_type=data[0].index_type;
		var luce_table=data[0].luce_table;
		var luce_key=data[0].luce_key;
		var luce_annex=data[0].luce_annex;
		var luce_document=data[0].luce_document;
		var luce_condition=data[0].luce_condition;
		$('#add_sqls_form').form('clear');
		$('#id').val(id);
		$('#dbsid').val(dbsid);// 赋值
		$("#luce_table").textbox('setValue',luce_table);
		$("#luce_id").textbox('setValue',luce_id);
		$("#luce_title").textbox('setValue',luce_title);
		$("#luce_contents").textbox('setValue',luce_contents);
		$("#luce_role").textbox('setValue',luce_role);
		$("#luce_time").textbox('setValue',luce_time);
		$("#luce_key").textbox('setValue',luce_key);
		$("#luce_path").textbox('setValue',luce_path);
		$("#luce_annex").textbox('setValue',luce_annex);
		$("#luce_document").textbox('setValue',luce_document);
		$("#index_type").combobox('select',index_type);
		$("#luce_condition").textbox('setValue',luce_condition);
		$('#sql').textbox('setValue', sql);// 赋值
		$('#add_sql_dialog').dialog({
			title : "修改sql语句"
		});
		$('#add_sql_dialog').dialog("open");
	}
}

/**
 * 删除接口信息
 */
function deleteInfo() {
	var selecteds = $('#tb1').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择操作项！');
		layer.tips('请选择一行进行操作', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('提示', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			var dbsid = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].id + ",";
				dbsid = selecteds[index].sysLuceneId;
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'luceneController/doDelete',
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
					reload(dbsid);
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
function clearData(){
	$('#id').val('');
	$("#luce_table").textbox('setValue',"");
	$("#luce_id").textbox('setValue',"");
	$("#luce_title").textbox('setValue',"");
	$("#luce_contents").textbox('setValue',"");
	$("#luce_role").textbox('setValue',"");
	$("#luce_time").textbox('setValue',"");
	$("#luce_path").textbox('setValue',"");
	$("#luce_key").textbox('setValue',"");
	$("#luce_annex").textbox('setValue',"");
	$("#index_type").textbox('setValue',"");
	$("#sql").textbox('setValue',"");
	$("#luce_condition").textbox('setValue',"");
	$("#luce_document").textbox('setValue',"");
}
function addRole(){
	var selecteds = $('#tb1').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		$.messager.alert('添加权限', '请选择操作项！');
		return;
	}else if(selecteds.length>1){
		$.messager.alert('添加权限', '请选择单条操作项！');
		return;
	}
	var sid = selecteds[0].id;
	window.parent.addTab("权限列表","luceneRoleController/luceneRoleIndex?sid="+sid);
}
/**
 * 保存修改sql 语句
 * 
 * @returns
 */
function doSaveSqlInfo() {
	if (!$('#add_sqls_form').form('validate')) {
		return;
	}
	if(!checkForm()){
		return;
	}
	var id = $("#id").val();
	var dbsid = $("#dbsid").val();
	var luce_table = $("#luce_table").textbox('getValue');
	var luce_id = $("#luce_id").textbox('getValue');
	var luce_title = $("#luce_title").textbox('getValue');
	var luce_contents = $("#luce_contents").textbox('getValue');
	var luce_role = $("#luce_role").textbox('getValue');
	var luce_time = $("#luce_time").textbox('getValue');
	var luce_path = $("#luce_path").textbox('getValue');
	var luce_annex = $("#luce_annex").textbox('getValue');
	var luce_key=$("#luce_key").textbox('getValue');
	var index_type = $("#index_type").textbox('getValue');
	var luce_document=$("#luce_document").textbox('getValue');
	var luce_condition = $("#luce_condition").textbox('getValue');
	var sql = $("#sql").textbox('getValue');
	if (!CheckSql(dbsid, sql)) {
		return;
	}
	if (id == '') {
		AjaxURL = "luceneController/doSavesqlsInfo";
		$.ajax({
			type : "POST",
			url : AjaxURL,
			async : false,
			data : {
				id : id,
				dbid : dbsid,
				luce_table : luce_table,
				luce_id : luce_id,
				luce_title : luce_title,
				luce_contents : luce_contents,
				luce_role : luce_role,
				luce_key:luce_key,
				luce_time : luce_time,
				luce_path : luce_path,
				luce_annex:luce_annex,
				luce_document:luce_document,
				index_type : index_type,
				luce_condition : luce_condition,
				luce_sql : sql
			},
			success : function(data) {
				$.messager.show({
					title : '提示',
					msg : '保存成功',
					showType : 'slide'
				});
				$('#add_sql_dialog').dialog('close');
				reload(dbsid);

			},
			error : function(data) {
				$.messager.show({
					title : '提示',
					msg : '保存失败',
					showType : 'slide'
				});
			}
		});
	} else {
		AjaxURL = "luceneController/doUpdatesqlsInfo";
		$.ajax({
			type : "POST",
			url : AjaxURL,
			async : false,
			data : {
				id : id,
				dbid : dbsid,
				luce_table : luce_table,
				luce_id : luce_id,
				luce_title : luce_title,
				luce_contents : luce_contents,
				luce_role : luce_role,
				luce_key:luce_key,
				luce_time : luce_time,
				luce_path : luce_path,
				luce_annex:luce_annex,
				luce_document:luce_document,
				index_type : index_type,
				luce_condition : luce_condition,
				luce_sql : sql
			},
			success : function(data) {
				$.messager.show({
					title : '提示',
					msg : '修改成功',
					showType : 'slide'
				});
				$('#add_sql_dialog').dialog('close');
				reload(dbsid);
			},
			error : function(data) {
				$.messager.show({
					title : '提示',
					msg : '修改失败',
					showType : 'slide'
				});
			}
		});
	}
}
//检查输入的表单是否符合条件
function checkForm(){
	var sql = $("#sql").textbox('getValue');
	if(sql==""){
		$.messager.alert('添加索引', '输入完整sql语句');
		$("#sql").focus();
		return false;
	}else{
		var luce_table = $("#luce_table").textbox('getValue');
		if(sql.indexOf(luce_table)<0){
			$.messager.alert('添加索引', '表名填写有误');
			$("#luce_table").focus();
			return false;
		}
		var luce_id = $("#luce_id").textbox('getValue');
		if(sql.indexOf(luce_id)<0){
			$.messager.alert('添加索引', '主键字段填写有误');
			$("#luce_id").focus();
			return false;
		}
		var luce_title = $("#luce_title").textbox('getValue');
		if(sql.indexOf(luce_title)<0){
			$.messager.alert('添加索引', '标题字段填写有误');
			$("#luce_title").focus();
			return false;
		}
		var luce_contents = $("#luce_contents").textbox('getValue');
		if(sql.indexOf(luce_contents)<0){
			$.messager.alert('添加索引', '内容字段填写有误');
			$("#luce_contents").focus();
			return false;
		}
		var luce_role = $("#luce_role").textbox('getValue');
		if(sql.indexOf(luce_contents)<0){
			$.messager.alert('添加索引', '内容字段填写有误');
			$("#luce_contents").focus();
			return false;
		}
		var luce_time = $("#luce_time").textbox('getValue');
		if(sql.indexOf(luce_time)<0){
			$.messager.alert('添加索引', '时间字段填写有误');
			$("#luce_time").focus();
			return false;
		}
		return true;
	}
	
	
}
function CheckSql(dbid, sql) {
	var flag = false;
	$.ajax({
		type : "POST",
		url : "luceneController/checkSql",
		async : false,
		data : {
			dbid : dbid,
			sql : sql
		},
		success : function(data) {
			if (data == "连接成功") {
				flag = true;
			} else {
				alert(data);
				flag = false;
			}
		},
		error : function(data) {
			alert(data);
			flag = false;
		}
	});
	return flag;
}
$.extend($.fn.textbox.defaults.rules, {
	checkUrl : {
		validator : function(value) {
			var falg = 1;
			for (var i = 0; i < value.length; i++) {
				if (value.charCodeAt(i) > 255) {
					falg = 0;
				}
			}
			if (falg == 0) {
				return false;
			} else {
				return true;
			}
		},
		message : 'URL格式不正确'
	},
	checkName : {
		validator : function(value) {
			var reg = /^\w+$/;
			if (reg.test(value)) {
				return true;
			} else {
				return false;
			}
		},
		message : '非法字符输入'
	}
});