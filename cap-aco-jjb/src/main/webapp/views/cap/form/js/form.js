//绑定字典内容到指定的Select控件
function BindSelect(ctrlName, url) {
	var control = $('#' + ctrlName);
	// 设置Select2的处理
	control.select2({
		allowClear : false,
		formatResult : '',
		formatSelection : '',
		escapeMarkup : function(m) {
			return m;
		}
	});

	// 绑定Ajax的内容
	$.ajaxSettings.async = false;
	$.getJSON(url, function(data) {
		control.empty();// 清空下拉框
		$.each(data, function(i, item) {
			control.append("<option value='" + item.code + "'>&nbsp;"
					+ item.text + "</option>");
		});
	});
}
// 绑定链接内容到指定的Select2控件
function BindUserSelect(ctrlName, url) {
	var control = $('#' + ctrlName);

	// 设置Select2的处理
	control.select2({
		allowClear : false,
		formatResult : "",
		formatSelection : "",
		escapeMarkup : function(m) {
			return m;
		}
	});
	$.ajaxSettings.async = false;
	// 绑定Ajax的内容
	$.getJSON(url, function(data) {
		control.empty();// 清空下拉框
		$.each(data, function(i, item) {
			control.append("<option value='" + item.code + "'>&nbsp;"
					+ item.text + "</option>");
		});
	});
}
// 绑定字典内容到指定的控件
function BindDictItem(ctrlName, dictTypeName) {
	var url = 'dictController/findFormatDictByTypeCode?dictTypeCode='
			+ dictTypeName; /* + encodeURI(dictTypeName); */
	BindSelect(ctrlName, url);
}
// 绑定字典内容到指定的控件
function BindDataSource(ctrlName, url) {
	BindUserSelect(ctrlName, url);
}
//绑定数据字典内容到select组件
function BindSelectItembyDict(ctrlName, dictTypeName) {
	var url = 'dictController/findFormatDictByTypeCode?dictTypeCode='
			+ dictTypeName; /* + encodeURI(dictTypeName); */
	addItemsbyUrl(ctrlName, url);
}
function addItemsbyUrl(ctrlName, url) {
	var control = $('#' + ctrlName);
	$.ajax({
		url : url, // 后台webservice里的方法名称
		type : "post",
		dataType : "json",
		contentType : "application/json",
		traditional : true,
		async : false,
		success : function(data) {
			var optionstring = "";
			if (data != null && data.length > 0) {
				for (var j = 0; j < data.length; j++) {
					optionstring += "<option value=\"" + data[j].code + "\" >"
					+ data[j].text + "</option>";
				}
			}
			control.html("" + optionstring);
			
		},
		error : function(msg) {
		}
	});
}
/**
 * 打开模态框
 * @param id
 * @param url
 */
function selectPeople(id, url) {
	users = id;
	$('#myModal').modal('show');
	// 加载人员信息
	$('#group').attr("src", url);
}
/**
 * 人员列表
 */
function makesurePerson() {
	var arr = document.getElementById("group").contentWindow.doSaveSelectUser();
	document.getElementById(users).value = arr[0];
	document.getElementById(users + "_NAME").value = arr[1];
	// document.getElementById(users).value = arr[0];
	$('#myModal').modal('hide');
	users = '';
}
/**
 * 调用子页面清空方法
 */
function btnQk() {
	document.getElementById("group").contentWindow.btnQk();
}
/**
 * 取消方法
 */
function btnCancel() {
	// document.getElementById("group").contentWindow.btnCancel();
	$('#myModal').modal('hide');
}

var treetype;
var style;
/**
 * 人员选择树
 * @param url
 * @param treeType
 * @param event
 */
function peopleTree(url, treeType, event) {
	// 设定弹出div位置，绑定body鼠标单击事件
	var cityObj = $("#" + treeType + "_NAME");
	var cityOffset = $("#" + treeType + "_NAME").offset();
	$("#treeDemo_").css({
		width : cityObj.width()
	}).slideDown("fast");
	$("#treeDiv_").css({
		background : '#dddddd',
		left : cityOffset.left + "px",
		top : cityOffset.top + cityObj.outerHeight() + "px"
	}).slideDown("fast");
	$("body").bind("mousedown", onBodyDown);
	// end
	treetype = treeType;
	style = 2;
	var setting;

	setting = {
		async : {
			enable : true,
			dataType : "json",
			type : "post",
			url : url,
			autoParam : [ "id" ],
			idKey : "id",
			pIdKey : "pId",
			rootPId : 0
		},
		callback : {
			beforeClick : beforeClick,
			onAsyncSuccess : onAsyncSuccess,
			onDblClick : onDblclick

		}
	};
	$.fn.zTree.init($("#groupTree_"), setting);
}
/**
 * ztree异步处理方法
 * @param event
 * @param treeId
 * @param treeNode
 * @param msg
 */
function onAsyncSuccess(event, treeId, treeNode, msg) {
	var zTree = $.fn.zTree.getZTreeObj("groupTree_");
	var allNodes = zTree.getNodes();// 这里只能找到最外层所有的节点

	for (var i = 0; i < allNodes.length; i++) { // 设置节点展开
		zTree.expandNode(allNodes[i], true, false, false);
	}
}
var className = "dark";
function beforeClick(treeId, treeNode, clickFlag) {
	className = (className === "dark" ? "" : "dark");
	return (treeNode.click != false);
}
function onDblclick(event, treeId, treeNode, clickFlag) {
	if (style == "1" || style == "3") {
		if (treeNode.isParent != null) {
			if (!treeNode.isParent) {
				$("#" + treetype + "_NAME").val(treeNode.name);
				$("#" + treetype).val(treeNode.id);
				$("#treeDiv_").css('display', 'none');
			}
		}
	} else {
		$("#" + treetype + "_NAME").val(treeNode.name);
		$("#" + treetype).val(treeNode.id);
		$("#treeDiv_").css('display', 'none');
	}
}
function hideMenu() {
	$("#treeDiv_").fadeOut("fast");
	$("body").unbind("mousedown", onBodyDown);
}
function onBodyDown(event) {
	if (!(event.target.id == treetype || event.target.id == "treeDiv_" || $(
			event.target).parents("#treeDiv_").length > 0)) {
		hideMenu();
	}
}
/**
 * 检查权限
 */
function checkRule() {
	var vtype = getFormParamByKey("formstype");
	var tableid = $("#_tableid").val();
	var keyid = getFormParamByKey("key");;
	if (keyid == null) {
		keyid = "";
	}
	if (data != "") {
		keyid = "";
	}
	var url = "formUserRuleController/formRuleValidation";
	$.ajax({
		url : url, // 后台webservice里的方法名称
		type : "post",
		dataType : "json",
		data : {
			tableid : tableid,
			keyid : keyid
		},
		success : function(data) {
			onlyRead();
			if (data != null && data.length > 0) {
				for (var i = 0; i < data.length; i++) {
					if (data[i] != null) {
						var con_id = data[i]["columncode"];
						var contype = data[i]["contype"];
						var contypevalue = data[i]["contypevalue"];
						if(vtype=="view"){
							contype="disabled";
							contypevalue="true";
						}
						if ($("#" + con_id) != null && contype != null && contype != "") {
							var css = $("#" + con_id).attr("class");
							if (css != null && css.indexOf("_com_form_data_control") > 0) {
								continue;
							}
							if (css != null && css.indexOf("form_annex_new") >= 0) {
								continue;
							}
							$("#" + con_id).attr(contype, contypevalue);
							if (css != null && css.indexOf("select2") > 0) {
								$("#" + con_id).next().children().children().attr(contype,contypevalue);
								$("#" + con_id).next().children().children().css("background-color","#eee");
							}
							if ($("#" + con_id)[0] != null) {
								var type = $("#" + con_id)[0].type;
								if ((type != null && type.indexOf("select") > 0) || css.indexOf("reload_data_select") > 0) {
									$("#" + con_id).parent().children(":first").addClass("disabled")
								}
							}
						}
						/** 动态行权限控制 */
						var dynamicDom = $("#dynamic_data").html();
						if (dynamicDom != null && dynamicDom != undefined) {
							if ($(dynamicDom).find("[name="+con_id+"]") != null && $(dynamicDom).find("[name="+con_id+"]") != undefined) {
								$(dynamicDom).find("[name="+con_id+"]").prop(contype,contypevalue);
							}
						}
					}
				}
			}
			/** 动态行按钮显示控制控制 */
			var dynamicDom = $("#dynamic_data").html();
			if (dynamicDom != null && dynamicDom != undefined) {
				if (vtype=="view") {
					var colLength = $(dynamicDom).find("tr:first").children().length;
					deleteCol(colLength-1);
				}
			}
			
			//add by luzhw 2017年5月18日(处理手写签批文字不能输入问题)
			var commentid = getFormParamByKey("commentColumn");
			if($("#" + commentid)) {
				$("#" + commentid).removeAttr("disabled");
			}
		},
		error : function(msg) {
		}
	});
}
/**
 * 检查工作流权限
 */
function checkCommentRule() {
	var commentid = getFormParamByKey("commentColumn");
	$('._com_form_data_control').each(function() {
		var colid = this.id;
		if (commentid != "" && commentid == colid) {
			$("#" + commentid).focus();
		} else {
			var css = $("#" + colid).attr("class");
			if (css != null && css.indexOf("_form_ueditor") > 0) {
				var ue = UE.getEditor('editor', {
					readonly : true
				});
			} else if (css != null && css.indexOf("commentTable") > 0) {
				$(this).parent().css('background-color', '#fafafa');
			} else {
				$("#" + colid).attr("disabled", "disabled");
				$("#" + colid).hide();
				showComment.push(colid);
			}
		}
	});

}

var showComment = [];//历史意见容器id集合
function doShowComment(){
	if (showComment.length > 0) {
		for (var i = 0; i < showComment.length; i++) {
			if ($("#_com_"+showComment[i]).html() == '') {
				$("#"+showComment[i]).show();
			} else {
				if ($("#"+showComment[i]).attr("disabled") == "disabled") {
					$("#"+showComment[i]).hide();
					$("#_com_"+showComment[i]).css("min-height","150px");
				}
			}
		}
	}
}

var data = "";// 标示页面是否加载数据
$(function() {
	//动态调用方法
	$(".reload_data_select").each(function() {
		var code = this.id;
		var method = this.attributes.getNamedItem('method').value;
		var parameters = $(this).attr("parameter").split(',');
		var fn = eval(method);
		new fn(parameters[0], parameters[1]);
	});

	checkRule();
	checkCommentRule();
/*	$('#_validation_form').validationEngine({});*/
	$('#_validation_form').validationEngine({
		debug:true,
		ajaxFormValidation:true, //开启ajax提交方式(默认为false)
		ajaxFormValidationURL:'', //设置 Ajax 提交的 URL，默认使用 form 的 action 属性
		ajaxFormValidationMethod: 'post', //设置 Ajax 提交时，发送数据的方式
		onAjaxFormComplete: success //提交成功后的回调函数
	});
	laydate.skin('dahong');
	getRelaseContent();
	
	/*
	 * if($("#editor")!=null&&$("#editor")!=''&&$("#editor")[0]!=null){ var ue =
	 * UE.getEditor('editor', { readonly : false }); }
	 */

})
/**
 * 验证方法提交成功后的回调函数 
 */ 
function success(status, form, json, options){
	/*alert("status :"  + status);  //status  为表单元素提交前的验证信息， 是boolean类型
	alert("json :"  + json); //json是访问后台后返回的信息
*/}
/**
 * 界面格式化方法，从数据库大字段中取得的文件内容，需要此处理
 */
function getRelaseContent() {
	var e = "";
	var t = $("#_validation_form");
	t.find(".preview, .configuration, .drag, .remove").remove();
	t.find(".lyrow").addClass("removeClean");
	t.find(".box-element").addClass("removeClean");
	t.find(".lyrow .lyrow .lyrow .lyrow .lyrow .removeClean").each(function() {
		cleanHtml(this)
	});
//	t.find(".lyrow .lyrow .lyrow .lyrow .removeClean").each(function() {
//		cleanHtml(this)
//	});
//	t.find(".lyrow .lyrow .lyrow .removeClean").each(function() {
//		cleanHtml(this)
//	});
//	t.find(".lyrow .lyrow .removeClean").each(function() {
//		cleanHtml(this)
//	});
//	t.find(".lyrow .removeClean").each(function() {
//		cleanHtml(this)
//	});
	t.find(".removeClean .removeClean .removeClean .removeClean").each(function() {
		cleanHtml(this)
	});
	t.find(".removeClean .removeClean .removeClean").each(function() {
		cleanHtml(this)
	});
	t.find(".removeClean .removeClean").each(function() {
		cleanHtml(this)
	});
	t.find(".removeClean").each(function() {
		cleanHtml(this)
	});
	t.find(".removeClean").remove();
	t.find(".ui-sortable").removeClass("ui-sortable");
	t.find(".column").removeClass("column");
	if(t.find(".container-fluid").length<1){
		$("#_validation_form").children().wrap("<div class='container-fluid'></div>");
	}
}
function cleanHtml(e) {
	$(e).parent().append($(e).children().html())
}