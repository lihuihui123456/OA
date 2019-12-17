/**
 * 
 * 从父层模板获取页面参数
 * @param key
 * @returns
 */
function getFormParamByKey(key) {
	var formParams = window.parent.getFormParam();
	if(formParams != null && formParams != undefined) {
		return formParams[key];
	}else {
		return "";
	}
}

/**
 * 根据url参数名获取参数值
 * 
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

//业务Id
var bizId = getFormParamByKey("key");
//当前环节可以编辑的意见字段
var commentColumn = getFormParamByKey("commentColumn");
$(function() {
	getDataRules();
	getWfDataRules();
	reload_data();
	getWfCommentsData();
	doShowComment();
	getBarCode();
	getFormid();
	setMemory();
	/** 前台打开表单时，标签页标题禁止编辑 */
	$(".demo a").removeAttr("contenteditable");
	
	/**文本域自适应高度*/
	$("textarea").each(function(index){
		autoTextarea($(this)[0]);
	});
});

var wfcode = "";
var wfvalue = "";
var formid = '';
/**
 * 获取表单id
 */
function getFormid() {
	if ($("#_formid") != null && $("#_formid").val() != null
			&& $("#_formid").val() != "") {
		formid = $("#_formid").val();
	} else {
		formid = getFormParamByKey('formid');

	}
	if (formid == null || formid == "") {
		formid = "0";
	}
}

//var procInstId = getQueryString("procInstId");
/**
 * 初始化加载数据
 */
function reload_data() {
	// 手写签批绑定控件
	$(".form_signature").each(function() {
		var id = this.id;
		$("#" + id).mySignature();
	});
	
	var tableid = $("#_tableid").val();
	var keyId = getFormParamByKey("key");
	$.ajax({
		url : "formdataController/getformdatas",
		type : "post",
		async : false,
		dataType : "json",
		data : {
			tableid : tableid,
			keyid : keyId
		},
		success : function(data) {

			if (data != null && data.length > 0) {
				var obj = data[0];
				for ( var key in obj) {
					if (wfcode != "" && wfcode == key) {//判断该字段是否是流程赋值字段
						if (obj[key] != null && obj[key] != "") {//判断数据库是否已经存值，如果存了，取数据库值
							$("#" + key).val(obj[key]);
						} else {//如果数据库未存或为空，去流程赋值
							$("#" + key).val(wfvalue);
						}
					} else {
						if ("dynamic_data" == key) {//加载动态行数据
							var dynamicDom = $("#dynamic_data");
							var dynamicDataStr = obj[key];
							if (dynamicDom != null && dynamicDom != undefined && dynamicDataStr != null && dynamicDataStr !='') {
								var tr = $(dynamicDom).find("tr").eq(1);
								var content = "";
								var jsonArra = eval(dynamicDataStr);
								for (var o in jsonArra) {//o为索引，0开始
									var newRow = $("<tr>"+$(tr).html()+"</tr>").appendTo($(dynamicDom));
									for (var key in jsonArra[o]) {
										$(newRow).find("[name="+key+"]").val(jsonArra[o][key]);
									}
								}
								$(tr).remove();
							}
						} else {
							$("#" + key).val(obj[key]);
							var css = $("#" + key).attr("class");
							if (css != null
									&& css.indexOf("_com_form_data_control") > 0) {
								var vdisable = $("#" + key).attr("disabled");
								if (vdisable != null && vdisable == 'disabled') {
									$("#" + key).val("");
								}
							}
							if (css != null && css.indexOf("_form_ueditor") > 0) {
								$("#editor")[0].innerHTML = obj[key];
							}
						}

						/*
						 * var css=$("#" + key).attr("class");
						 * if(css!=null&&css.indexOf("select2")>0){ $("#" +
						 * key).select2().select2("val",obj[key]); var
						 * spanid="select2-"+key+"-container";
						 * $("#"+spanid).text($("#"+spanid).attr("title")); }
						 */
					}
				}
			}
		}
	});
	/*var bizId = keyid;

	if (bizId == "") {
		bizId = "12343324123";
	}*/
	// 旧版附件绑定数据源
	$(".form_annex").each(function() {
		var id = this.id;
		var src = $("#" + id).attr("src");
		src += "&tableId=" + bizId;
		$("#" + id).attr("src", src);
	});
	var view = getFormParamByKey("formstype");
	if (view != "view") {
		view = "edit";
	}
	var demo = {
		apply : true,
		authority : view
	};
	// 新版附件生成方法
	$(".form_annex_new").each(function() {
		var id = this.id;
		upload({// 引用customized-upload.js中方法
			multipart_params : {
				refId : bizId,
				refType : id
			}
		}, id, demo);
	});
}
// 流程意见赋值
function getWfCommentsData() {
	var bizId = getFormParamByKey("key");
	if (bizId == null || bizId == "") {
		return;
	}
	var url = "bpmRuBizInfoController/findBizInfoByBizId";
	var params = {"bizId" : bizId};
	$.post(url, params, function(data) {
		if(data != null) {
			var procInstId = data.procInstId_;
			getAllWfCommentsData(procInstId);
			getCommentsData(procInstId);
		}
	}, "json");
}

//对每个意见域获取加载意见数据
function getCommentsData(procInstId) {
	if (procInstId == null || procInstId == "") {
		return;
	}
	$(".form_com_content").each(function() {
		var code = this.id;
		var name = code.substring(5, code.length);
		$.ajax({
			url : "bpmRuFormInfoController/findCommentByProcInstIdAndFieldName",
			type : "post",
			async : false,
			dataType : "json",
			data : {
				procInstId : procInstId,
				fieldName : name
			},
			success : function(data) {
				if (data.length > 0) {
					var com = "";
					for (var i = 0; i < data.length; i++) {
						if (name == data[i]["fieldName_"]) {
							com += "<div class='form_com_content_con' style='display:block;padding-left: 13px;'>"
									+ data[i]["message_"].replace(new RegExp("\n", 'g'),"<br>")
									+ "</div>";
							com += "<div class='form_com_content_ur' style='display:block;text-indent: 13px;'>"
									+ data[i]["userName_"]
									+ "&nbsp;&nbsp;&nbsp;"
									+ data[i]["dtime"]
									+ "</div>";

						}
						$("#" + code).html(com);
					}
				}
				doShowComment();
			}
		});

	});
}

// 获取所有流程意见信息（应用较少）
function getAllWfCommentsData(procInstId) {
	if (procInstId == null || procInstId == "") {
		return;
	}
	$("#all_comments").each(function() {
		var code = this.id;
		$.ajax({
			url : "bpmRuFormInfoController/findCommentByProcInstId",
			type : "post",
			async : false,
			dataType : "json",
			data : {
				procInstId : procInstId,
			},
			success : function(data) {
				if (data.length > 0) {
					var com = "";
					for (var i = 0; i < data.length; i++) {
						com += "<div style='display:block'>"
								+ data[i]["message_"] + "</div>";
						com += "<div style='display:block'>"
								+ data[i]["userName_"]
								+ "&nbsp;&nbsp;&nbsp;"
								+ data[i]["dtime"] + "</div>";

					}
					$("#all_comments").html(com);
				}
			}
		});

	});
}

/**
 * 生成二维码
 */
function getBarCode() {
	/* sno = '123456789'; */
	if (bizId == null || bizId == "") {
		return;
	}
	$(".form_barcode").attr("src", "bpmRuFormInfoController/getOneBarcodeByBizId?bizId=" + bizId);
}

/**
 * 获取数据规则设置
 */
function getDataRules() {
	var tableid = $("#_tableid").val();
	$
			.ajax({
				url : "formDataRuleController/getDataRulebyTab",
				type : "post",
				async : false,
				dataType : "json",
				data : {
					tableid : tableid,
				},
				success : function(data) {
					if (data != null && data.length > 0) {
						for (var i = 0; i < data.length; i++) {
							// 控件id
							var col_code = data[i].column_code;
							// 控制类型
							var con_type = data[i].control_type;
							// 规则类型
							var rule_type = data[i].rule_type;
							// 文号类型
							var doc_type = data[i].doc_type;
							// 表单文号
							var formwh = data[i].doc_formcode;
							// 默认值
							var def_value = data[i].data_detail;
							if (con_type == "2") {
								$("#" + col_code).val(def_value);
							} else if (con_type == "1") {
								if (rule_type == "user") {
									$("#" + col_code).val(getUser().id);
									$("#" + col_code.substr(0,col_code.length - 1)+"Name_").val(getUser().name);
								} else if (rule_type == "dept") {
									$("#" + col_code).val(getUser().deptId);
									$("#" + col_code.substr(0,col_code.length - 1)+"Name_").val(getUser().deptName);
								} else if (rule_type == "date") {
									$("#" + col_code).val(getNowFormatDate());
								} else if (rule_type == "doctype") {
									$("#" + col_code).val(
											getDocCode(doc_type, formwh));
								} else if (rule_type == "workflow") {
									$("#" + col_code).val(getWfWJBH());
								}
							}
						}
					}
				}
			});
}
/**
 * 获取流程中文号规则设置
 */
function getWfDataRules() {
	var tableid = $("#_tableid").val();
	$.ajax({
		url : "formDataRuleController/getDataRulebyTab",
		type : "post",
		async : false,
		dataType : "json",
		data : {
			tableid : tableid,
		},
		success : function(data) {
			if (data != null && data.length > 0) {
				for (var i = 0; i < data.length; i++) {
					// 控件id
					var col_code = data[i].column_code;
					// 规则类型
					var rule_type = data[i].rule_type;
					if (rule_type == "workflow") {
						wfcode = col_code;
						wfvalue = getWfWJBH();
						$("#" + col_code).val(getWfWJBH());
					}
				}
			}
		}
	});
}
/**
 * 获取url参数中传递的文号参数
 * TODO 需要添加中文解码方法 
 * @returns
 */
function getWfWJBH() {
	return getFormParamByKey("bizno");
}
/**
 * 获取当前登录用户
 * 
 * @returns {String}
 */
function getUser() {
	var user;
	$.ajax({
		url : "formDataRuleController/getShiroUser",
		type : "post",
		async : false,
		dataType : "json",
		success : function(data) {
			
			if (data != null) {

				user = data;
			}
		}
	});
	return user;
}
/**
 * 获取当前等部门
 * 
 * @returns {String}
 */
function getDept() {
	var deptname = "";
	$.ajax({
		url : "formDataRuleController/getShiroDept",
		type : "post",
		async : false,
		dataType : "json",
		success : function(data) {
			if (data != null) {
				deptname = data.deptName;
			}
		}
	});
	return deptname;
}
/*
 * 根据文号规则获取文号
 */
function getDocCode(doc_type, formcode) {
	var doccode = "";
	$.ajax({
		url : "docNumMgrController/getDocNumById",
		type : "post",
		async : false,
		dataType : "text",
		data : {
			id : doc_type,
			sfwType : formcode
		},
		success : function(data) {
			if (data != null) {
				doccode = data;
			}
		}
	});
	return doccode;
}
/**
 * 设置辅助输入项
 */
function setMemory() {
	$(".form_memory").each(function() {
		var code = this.id;
		getSelectData(code);
	});
}
/**
 * 保存辅助输入项
 */
function saveMemory() {
	$(".form_memory").each(function() {
		var code = this.id;
		var content = $("#" + code).val();
		$.ajax({
			url : 'formMemoryController/addFormMemory',
			type : 'post',
			dataType : 'JSON',
			data : {
				formid : formid,
				concode : code,
				content : content
			},
			success : function(data) {
				headdata = data.source;
			}
		});
	});
}
var headdata = "";
/**
 * 从数据库中获取本表单辅助输入列表
 * 
 * @param code
 */
function getSelectData(code) {
	$.ajax({
		url : 'formMemoryController/getFormMemoryList',
		type : 'post',
		dataType : 'JSON',
		async : false,
		data : {
			formid : formid,
			concode : code
		},
		success : function(data) {
			headdata = data.source;
		}
	});

	$('#' + code).typeahead({
		source : headdata,
		itemSelected : function(item, value, text) {
			$('#' + code).val(text);
		}
	});
}
/**
 * 设置开始时间结束时间控件，未使用
 */
function getDate() {
	var start = {
		elem : '#wh',
		format : 'YYYY/MM/DD',
		min : laydate.now(), // 设定最小日期为当前日期
		max : '2099-06-16 23:59:59', // 最大日期
		istime : true,
		istoday : true,
		choose : function(datas) {
			end.min = datas; // 开始日选好后，重置结束日的最小日期
			end.start = datas // 将结束日的初始值设定为开始日
		}
	};
	var end = {
		elem : '#end',
		format : 'YYYY/MM/DD hh:mm:ss',
		min : laydate.now(),
		max : '2099-06-16 23:59:59',
		istime : true,
		istoday : true,
		choose : function(datas) {
			start.max = datas; // 结束日选好后，重置开始日的最大日期
		}
	};
	laydate(start);
	laydate(end);
}
/**
 * 获取当前登录时间
 * 
 * @returns {String}
 */
function getNowFormatDate() {
	var date = new Date();
	var seperator1 = "-";
	var seperator2 = ":";
	var month = date.getMonth() + 1;
	var strDate = date.getDate();
	var hours = date.getHours();
	var minutes = date.getMinutes();
	var seconds = date.getSeconds();
	if (month >= 1 && month <= 9) {
		month = "0" + month;
	}
	if (strDate >= 0 && strDate <= 9) {
		strDate = "0" + strDate;
	}
	if (hours >= 0 && hours <= 9) {
		hours = "0" + hours;
	}
	if (minutes >= 0 && minutes <= 9) {
		minutes = "0" + minutes;
	}
	if (seconds >= 0 && seconds <= 9) {
		seconds = "0" + seconds;
	}
	var currentdate = date.getFullYear() + seperator1 + month + seperator1
			+ strDate + " " + hours + seperator2 + minutes + seperator2
			+ seconds;
	return currentdate;
}
/**
 * 附件权限控制
 */
function onlyRead() {
	var view = getFormParamByKey("formstype");
	if (view == 'view') {// 控制附件查看权限，查看只能操作打开和另存
		$(".form_annex").each(function() {
			var iframe = document.getElementById(this.id);
			iframe.onload = function() {
				var buttons = $(window.frames[this.id].contentWindow.document).find("button");
				for (var i = 0; i < buttons.length; i++) {
					if (buttons[i].getAttribute("id") != "open" && buttons[i].getAttribute("id") != "resave") {
						buttons[i].setAttribute("disabled","disabled");
					}
				}

			};

		});
		$(".form_annex_new").each(function() {
			var buttons = $("#" + this.id).find("button");
			for (var i = 0; i < buttons.length; i++) {
				if (buttons[i].getAttribute("id") != "open" && buttons[i].getAttribute("id") != "resave") {
					buttons[i].setAttribute("disabled", "disabled");
				}
			}
			var spans = $("#" + this.id).find("span");
			for (var i = 0; i < spans.length; i++) {
				if (spans[i].getAttribute("id") != "open" && spans[i].getAttribute("id") != "resave") {
					spans[i].setAttribute("disabled", "disabled");
				}
			}
		});
	}
}

/**
 * 动态添加行
 * 
 * @author 王建坤
 * @since 2017-05-08
 * @param 
 */
function addRow(obj){
	$('<tr>'+$(obj).parent().parent().html()+'</tr>').appendTo($(obj).parent().parent().parent());
}

/**
 * 删除行
 * 
 * @author 王建坤
 * @since 2017-05-10
 * @param 
 */
function deleteRow(obj){
	if ($("#dynamic_data").find("tr").length <= 2) {
		alert("请至少保留一行");
	} else {
		$(obj).parent().parent().remove();
	}
}

/**
 * 删除列
 * 
 * @author 王建坤
 * @since 2017-05-10
 * @param 
 */
function deleteCol(index){
    var table = document.getElementById("dynamic_data");
    var len = table.rows.length; 
    for(var i = 0;i < len;i++){
        table.rows[i].deleteCell(index);
    }
}

/**
 * 文本框根据输入内容自适应高度
 * 
 * @author wangjiankun
 * @since 2017-07-19
 * @param                {HTMLElement}        输入框元素
 * @param                {Number}                设置光标与输入框保持的距离(默认0)
 * @param                {Number}                设置最大高度(可选)
 */
var autoTextarea = function (elem, extra, maxHeight) {
        extra = extra || 0;
        var isFirefox = !!document.getBoxObjectFor || 'mozInnerScreenX' in window,
        isOpera = !!window.opera && !!window.opera.toString().indexOf('Opera'),
                addEvent = function (type, callback) {
                        elem.addEventListener ?
                                elem.addEventListener(type, callback, false) :
                                elem.attachEvent('on' + type, callback);
                },
                getStyle = elem.currentStyle ? function (name) {
                        var val = elem.currentStyle[name];
 
                        if (name === 'height' && val.search(/px/i) !== 1) {
                                var rect = elem.getBoundingClientRect();
                                return rect.bottom - rect.top -
                                        parseFloat(getStyle('paddingTop')) -
                                        parseFloat(getStyle('paddingBottom')) + 'px';        
                        };
 
                        return val;
                } : function (name) {
                                return getComputedStyle(elem, null)[name];
                },
                minHeight = parseFloat(getStyle('height'));
 
        elem.style.resize = 'none';
 
        var change = function () {
                var scrollTop, height,
                        padding = 0,
                        style = elem.style;
 
                if (elem._length === elem.value.length) return;
                elem._length = elem.value.length;
 
                if (!isFirefox && !isOpera) {
                        padding = parseInt(getStyle('paddingTop')) + parseInt(getStyle('paddingBottom'));
                };
                scrollTop = document.body.scrollTop || document.documentElement.scrollTop;
 
                elem.style.height = minHeight + 'px';
                if (elem.scrollHeight > minHeight) {
                        if (maxHeight && elem.scrollHeight > maxHeight) {
                                height = maxHeight - padding;
                                style.overflowY = 'auto';
                        } else {
                                height = elem.scrollHeight - padding;
                                style.overflowY = 'hidden';
                        };
                        style.height = height + extra + 'px';
                        scrollTop += parseInt(style.height) - elem.currHeight;
                        document.body.scrollTop = scrollTop;
                        document.documentElement.scrollTop = scrollTop;
                        elem.currHeight = parseInt(style.height);
                };
        };
 
        addEvent('propertychange', change);
        addEvent('input', change);
        addEvent('focus', change);
        change();
};