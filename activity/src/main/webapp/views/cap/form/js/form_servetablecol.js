/**
 * 初始化函数
 */
$(function() {
	serveid=getQueryString("serviceId");
	formid=getQueryString("formId");
	findListDataById();
});
var serveid='';
var formid='';
function findListDataById() {
	$('#col').datagrid({
		url : 'formColumnController/findColsbyFormid',
		method : 'POST',
		queryParams : {
			'formid' : formid
		},
		view : dataGridExtendView,
		emptyMsg : '没有相关记录!',
		cache : false,
		toolbar : '#tb',
		striped : true,
		fit : true,
		fitColumns : true,
		singleSelect : false,
		selectOnCheck : true,
		checkOnSelect : true,
		rownumbers : true,
		showFooter : true,
		pagination : false,
		nowrap : false,
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
		} ] ],
		onBeforeLoad : function(param) {
		},
		onLoadSuccess : function(datas) {
			$.ajax({
				url : 'formServeUserRuleController/getRulelistBySerForm',
				type : 'post',
				dataType : 'json',
				data : {
					formid : formid,
					serveid : serveid
				},
				success : function(data) {
					if (data != null && data != '') {
						for(var j=0;j<data.length;j++){
							var colid=data[j]["column_id"];
							$.each(datas.rows, function(i,e) {
								if (e.col_id==colid) {
									$("#col").datagrid('selectRow', i);
								}
							});
						}
					}
				}
			});
			
		},
		onLoadError : function() {

		},
		onClickCell : function(rowIndex, field, value) {

		}
	});
}
function getcolrule() {
	$.ajax({
		url : 'formServeUserRuleController/getRulelistBySerForm',
		type : 'post',
		dataType : 'json',
		data : {
			formid : formid,
			serveid : serveid
		},
		success : function(data) {
			if (data != null && data != '') {
				alert(data);
			} else {

			}
		}
	});
}

function save() {
	var rows = $('#col').datagrid('getSelections');
	var servetype = "0";
	var list = new Array();
	if (rows != null && rows.length > 0) {
		for (var i = 0; i < rows.length; i++) {
			var colid = rows[i]["col_id"];
			var tableid = rows[i]["table_id"];
			var data = {
				'table_id' : tableid,
				'column_id' : colid,
				'serve_type' : servetype,
				'serve_id' : serveid,
				'rule_type' : '0',
				'rule_id' : '0',
				'control_type':'disabled'
			};
			list[i] = data;
		}
		var str = JSON.stringify(list);
		$.ajax({
			url : 'formServeUserRuleController/saveRule',
			type : 'post',
			dataType : 'json',
			data : {
				str : str,
			},
			success : function(data) {
				if (data != null && data != '') {
					alert("保存成功");
				} else {

				}
			}
		});
	} else {
		alert("请选择数据后保存!");
		return;
	}
}
/** 权限设置 * */
function setRoles() {
	var rows = $('#col').datagrid('getSelections');
	var colid="";
	if(rows!=null&&rows.length>0){
		for(var i=0;i<rows.length;i++){
			var row=rows[i];
			colid+="'"+row.col_id+"'";
			if(i!=rows.length-1){
				colid+=",";
			}
		}
		var url = "formServeUserRuleController/form_rule_index?colid=" + colid+"&serveid="+serveid;
		$('#ifrole').attr("src", url);
		$('#setrole').dialog('open');
	} else {
		$.messager.alert("警告", "请选择数据!");
	}
}

function getQueryString(name) {
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	var r = window.location.search.substr(1).match(reg);
	if (r != null)
		return unescape(r[2]);
	return null;
}
