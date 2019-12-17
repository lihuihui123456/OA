/**
 * 全局变量
 * */
var floatTableIds = "";//浮动表Id字符串
/**
 * 添加方法,未使用
 */
function add() {
}
/**
 * 修改方法
 */
function doUpdateForm(bizid) {
	return doSaveForm(bizid);
}
/**
 * 办理方法
 * @param bizid
 * @returns {String}
 */
function doDealForm(bizid) {
	return doSaveForm(bizid);
}
/**
 * 删除方法,未使用
 */
function del() {
}
/**
 * 获取标题，字段必须为title
 * @returns
 */
function getTitle() {
	if($("#title").val()==""){
		$("#title").focus();
		return;
	}
	return $("#title").val();
}

/**
 * 获取字段值
 * 
 * @author wangjiankun
 * @since 2017-06-27
 * @param column 字段名称
 * @returns 字段值
 */
function getFieldVal(column) {
	if($("#"+column) != null && $("#"+column) != undefined){
		return $("#"+column).val();
	}
	return "";
}
/**
 * 根据意见字段获取意见
 * @returns
 */
function getComment(commentColumn) {
	return $("#" + commentColumn).val();
}

/**
 * 获取意见
 * @returns {String}
 */
function getComments() {
	var comments = "";
	var conid = getQueryString("commentid");
	if (conid != null && conid != "") {
		comments = $("#" + conid).val();
	}
	return comments;
}
/**
 * 获取紧急程度，字段必须为URGENCY_LEVEL,流程控制，无法修改
 * @returns
 */
function getUrgencyLevel() {
	return $.trim($("#URGENCY_LEVEL").val());
}
/**
 * 获取打印导出内容方法
 */
function setexpdivContent() {
	
	$("#_export_doc").html($("#_validation_form").html());
	var t = $("#_export_doc");
	var title = $("#title").val();

	t.find(".form_annex").remove();
	//t.find(".form_annex_new").remove();
	t.find("#myModal").remove();
	t.find("#treeDiv_").remove();
	t.find("#_tableid").remove();
	t.find("#_formid").remove();
	t.find(".commentEditDiv").remove();
	t.find("._form_data_control").each(function() {

		var sdata = "";
		if (this.id != "" && this.type != "hidden") {
			if (this.className.indexOf('select2') > 0) {
				sdata = $("#" + this.id).select2('val');
			} else if (this.className.indexOf('select') >= 0) {
				if (this.className.indexOf('reload_data_select') >= 0) {
					sdata =$("#" + this.id).find("option:selected").text();
				} else {
					sdata = $("#" + this.id).val();
				}
			} else if (this.className.indexOf('_form_ueditor') > 0) {
				/*
				 * $("#"+this.id).val(UE.getEditor('editor').getContent());
				 * sdata=$("#"+this.id).val();
				 */
			} else if (this.className.indexOf('_com_form_data_control') > 0) {
				var comid="_com_"+this.id;
				for(var i=0;i<$("#"+comid).children().size();i++){
					sdata+=$("#"+comid).children()[i].innerHTML+"<br>";
				}
			}else {
				sdata = $("#" + this.id).val();
			}
			if (this.parentNode != null) {
				if (this.parentNode.nodeName == "DIV") {
					this.parentNode.parentNode.innerHTML = sdata;
				} else {
					if ($(this).parent().find("textarea").length > 0) {
						this.parentNode.innerHTML = "<div style='min-height:150px;'>"+sdata+"</div>";
					} else {
						this.parentNode.innerHTML = sdata;
					}
				}
			}
		}

	});
	
	t.find(".reload_data_select").each(function() {

		var sdata = "";
		if (this.id != "" && this.type != "hidden") {
			if (this.className.indexOf('select2') > 0) {
				sdata = $("#" + this.id).select2('val');
			} else if (this.className.indexOf('select') >= 0) {
				if (this.className.indexOf('reload_data_select') >= 0) {
					sdata =$("#" + this.id).find("option:selected").text();
				} else {
					sdata = $("#" + this.id).val();
				}
			} else if (this.className.indexOf('_form_ueditor') > 0) {
				/*
				 * $("#"+this.id).val(UE.getEditor('editor').getContent());
				 * sdata=$("#"+this.id).val();
				 */
			} else if (this.className.indexOf('_com_form_data_control') > 0) {
				var comid="_com_"+this.id;
				for(var i=0;i<$("#"+comid).children().size();i++){
					sdata+=$("#"+comid).children()[i].innerHTML+"<br>";
				}
			}else {
				sdata = $("#" + this.id).val();
			}
			if (this.parentNode != null) {
				if (this.parentNode.nodeName == "DIV") {
					this.parentNode.parentNode.innerHTML = sdata;
				} else {
					if ($(this).parent().find("textarea").length > 0) {
						this.parentNode.innerHTML = "<div style='min-height:150px;'>"+sdata+"</div>";
					} else {
						this.parentNode.innerHTML = sdata;
					}
				}
			}
		}

	});
	t.find(".form_annex_new").each(function() {
		var sdata =$("#fj").attr("value");
		if (this.parentNode != null) {
			if (this.parentNode.nodeName == "DIV") {
				this.parentNode.parentNode.innerHTML = sdata;
			} else {
				if ($(this).parent().find("textarea").length > 0) {
					this.parentNode.innerHTML = "<div style='min-height:150px;'>"+sdata+"</div>";
				} else {
					this.parentNode.innerHTML = sdata;
				}
			}
		}
	});
	return title;
}
/**
 * 打印方法
 */
function printPage() {
	setexpdivContent();
	$($("#_export_doc").html()).jqprint();
}
/**
 * 导出方法
 */
function exportdoc() {
	var title = setexpdivContent();
	var expdata = $("#_export_doc").html();
	$.ajax({
		url : "formDocController/createformdoc",
		type : "post",
		dataType : "text",
		async : false,
		data : {
			expdata : expdata,
			titleName : title
		},
		success : function(data) {
			var url = window.ctx+"/formDocController/downloadFormDoc?filepath=" + data;
			url = encodeURI(url);
			url = encodeURI(url);
			location.href = url;
			$("#_export_doc").html("");
		}
	});

}

/**
 * 自由表单保存方法
 */
function doSaveForm(bizid, action, operate) {
	if (!$('#_validation_form').validationEngine()) {
		return ;
	}
	
	var flag = "N"
	if (bizid == null || bizid == "") {
		return flag;
	}
	var tableid = $("#_tableid").val();
	var commentColumn = getFormParamByKey("commentColumn");
	var data = {};
	$("._form_data_control").each(function() {
		if (this.className.indexOf('select2') > 0) {
			data[this.id] = $("#" + this.id).select2('val');
		} else if (this.className.indexOf('select') >= 0) {
			if (this.className.indexOf('btn-group') >= 0) {
			} else {
				if (this.id != null && this.id != "") {
					data[this.id] = $("#" + this.id).val();
				}
			}
		} else if (this.className.indexOf('_form_ueditor') > 0) {
			/*
			 * $("#"+this.id).val(UE.getEditor('editor').getContent());
			 * data+=this.id+":'"+$("#"+this.id).val()+"',";
			 */
		} else {
			if(commentColumn != null && this.id == commentColumn && action != null && action == "send") {
				data[this.id] = "";
			}else {
				data[this.id] = $("#" + this.id).val();
			}
		}
	});
	/**
	 * modify by hegd 获取下拉列表的值添加到data里 2017-5-26
	 */
	$(".reload_data_select").each(function() {
		if (this.className.indexOf('select') >= 0) {
			if (this.id != null && this.id != "") {
				var selectedValue = $("#" + this.id).val();//解决ie8获取select值问题，ie8下为["1"]
				data[this.id] = typeof selectedValue == "object" ? selectedValue[0] : selectedValue;
			} 
		}
	});
	
	saveMemory();
	
	/** 检查有没有浮动表 */
	checkFolatTable();
	var jsonArr = [];
	if (floatTableIds != '') {
		var idAttr = floatTableIds.split(",");
		for (var i = 0; i < idAttr.length; i++) {
			var tableId = idAttr[i];
			if (window.frames[tableId] != null && window.frames[tableId] != undefined) {
				var floatTableData = window.frames[tableId].saveFdTable(tableId);
				var jObj = {};
				jObj.id = tableId;
				jObj.data = floatTableData;
				jsonArr[i] = jObj;
			}
		}
	}
	var jsonStr = JSON.stringify(jsonArr);
	$.ajax({
		url : "formdataController/saveformdata",
		type : "post",
		dataType : "text",
		async : false,
		data : {
			tableid : tableid,
			bizid : bizid,
			formdata : JSON.stringify(data),
			floatTableData : jsonStr
		},
		success : function(data) {
			flag = data;
		}
	});
	return flag;
}

/**
 * 获取动态行数据，拼成json数组字符串
 * 
 * @author wangjiankun
 * @since 2017-05-08
 * @param 无
 * @return jsonArrStr json字符串
 * */
function getDynamicDataJsonStr(){
	var jsonStr = "";
	var jsonAttr = [];
	$("#dynamic_data").find("tr:gt(0)").each(function(){
			var jObj = {};
			var trLength = $(this).children().length;
			$(this).children().each(function(index){//td集合
				if (index != trLength-1) {
					var inputLength = $(this).find("input").length;
					if (inputLength > 0) {
						var key = $(this).children().eq(0).attr("name");
						var value = $(this).children().eq(0).val();
						jObj[key] = value;
					} else {
						var key = $(this).find("select").eq(0).attr("name");
						var value = $(this).find("select").eq(0).val();
						jObj[key] = value;
					}
				}
			});
			jsonAttr.push(jObj);
	});
	if (jsonAttr.length > 0) {
		jsonStr = JSON.stringify(jsonAttr);
	}
	return jsonStr;
}

/**
 * 保存方法 未用
 * @returns {String}
 */
function save() {
	if (!validateForm()) {
		return;
	}
	var key = getQueryString("key");
	var flag = "N";
	var tableid = $("#_tableid").val();
	var data = '{';
	$("._form_data_control").each(function() {
		if (this.className.indexOf('select2') > 0) {
			data += this.id + ":'" + $("#" + this.id).select2('val') + "',";
		} else if (this.className.indexOf('select') > 0) {
			data += this.id + ":'" + $("#" + this.id).val() + "',";
		} else {
			data += this.id + ":'" + this.value + "',";
		}
	});
	if (key == null || key == "") {
		key = "";
	}
	data = data.substring(0, data.length - 1) + "}";
	//data=ReplaceSeperator(data);
	saveMemory();
	$.ajax({
		url : "formdataController/saveformdata",
		type : "post",
		dataType : "text",
		async : false,
		data : {
			tableid : tableid,
			bizid : key,
			formdata : data
		},
		success : function(data) {
			flag = data;
		}
	});
	return flag;
}
/**
 * 非空校验
 * @returns {Boolean}
 */
function validateForm() {
	$('#_validation_form').submit();
	if ($(".formError") != null && $(".formError").size() > 0) {
		$(".formError").next().eq(0).blur();
		$(".formError").next().eq(0).focus();
		$(".formError").next().eq(0).blur();
		$(".formError").next().eq(0).focus();
	}
	if ($(".formError") != null && $(".formError").size() > 0) {
		return false;
	}
	return true;
}

/**
 * 取消方法
 */
function cancel() {
	this.window.close();
}
/**
 * 清空方法，需要补充
 */
function clearAll() {
	var controls = document.getElementsByTagName('input');
	for (var i = 0; i < controls.length; i++) {
		if (controls[i].type == 'text') {
			controls[i].value = '';
		}
	}
}
/**
 * 获取url参数值
 * @param name
 * @returns
 */
function getQueryString(name) {
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	var r = window.location.search.substr(1).match(reg);
	if (r != null)
		return unescape(r[2]);
	return null;
}
/**
 * 特殊字符处理
 * @param mobiles
 * @returns {String}
 */
function ReplaceSeperator(mobiles) {
    var i;
    var result = "";
    var c;
    for (i = 0; i < mobiles.length; i++) {
        c = mobiles.substr(i, 1);
        if (c != "\n"){
            result += c;
        }else{
        	result += "\\n";
        }
    }
    return result;
}
/**
 * 检查此表单有无浮动表
 * 
 * @author wangjiankun
 * @since 2017-07-10
 * @param 无
 * @return floatTableIds 浮动表ID字符串
 */
function checkFolatTable(){
	var formId = getFormParamByKey('formid');
	$.ajax({
		type : 'post',
		url : 'formFloatTableController/findFloatTabIdsOfMainForm',
		data : {
			formId : formId
		},
		async : false,
		success : function(data){
			floatTableIds = data;
		}
	});
}

$(function(){ 
	initSelectUserByDeptId("qbbmfzr");
}); 

/**
 * add by hegd 2017年7月10日16:18:42
 * 实现选中部门连动添加部门负责人
 * selectId 页面select元素Id
 * deptId 部门Id
 */
function initSelectUserByDeptId(selectId){
	var deptId=$("#qbbm_").val();
	$.ajax({
		url : "userController/findUsersByDeptId",
		type : "post",
		data : {deptId:deptId},
		success : function(data) {
			if(data!=null){
				$('#'+selectId).empty();
	            $.each(data, function(index, html) {
	                $('#'+selectId).append(
	                    $('<option></option>')
	                    .text(html.userName)
	                    .val(html.userId)
	                );
	            });
			}
		},
		error : function(data) {
			layerAlert("error:" + data.responseText);
		}
	});
}