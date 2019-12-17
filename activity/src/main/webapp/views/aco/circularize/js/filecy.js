var users = "";
var choose_userid = "";
var choose_username = "";
var divId = "bizform";
var saveUrl = "circularize/saveInfor/update?time=";
$(function() {
	$("#textfield_td").hide();
	if(action == "add"){
		//此时没有意义只为实现springMVC数据绑定
		$("#creation_time").val("2016-01-01 14:20:23");
		saveUrl = "circularize/saveInfor/add?time="
	}
	
	//实例化编辑器
	//建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
	var type = $('#type').val();
	if (type == 'open') {
		var ue = UE.getEditor('editor', {
			readonly: true
		});
	}else{
		var ue = UE.getEditor('editor', {
			readonly: false
		});
	}
	//切换页签
	$('#myTabs a').click(function (e) {
		  e.preventDefault();
		  divId = $(this).attr('href').replace("#","");
	});
	init();

	$('#send_btn').click(function() {
		send();
	});

	$('#save_btn').click(function() {
		save();
	});

	$('#ff').validationEngine({});
});

function init() {
	var type = $('#type').val();
	if (type == 'open') {
		onlyRead();
		//加载表格
		initTable();
	} else {
		$("#name").focus();
	}
}
function onlyRead() {
	var inputs = document.getElementsByTagName("input");
	$('#priority').attr("disabled", "disabled");
	for (var i = 0; i < inputs.length; i++) {
		if($(inputs[i]).attr("name") != "zw"){
			inputs[i].setAttribute("disabled", "disabled");
		}
	}
	// $(window.frames["mainFrame"].document).find("button").attr("disabled","disabled");
	var buttons = $(window.frames["mainFrame"].document).find("button");
	for (var i = 0; i < buttons.length; i++) {
		if (buttons[i].getAttribute("id") != "open"
				&& buttons[i].getAttribute("id") != "resave") {
			buttons[i].setAttribute("disabled", "disabled");
		}
	}
	$("#send_btn").css("display", "none");
	$("#save_btn").css("display", "none");
}

function save(status) {
	var fg = false;
	changeIndex();
	if ($('#ff').validationEngine('validate')) {
		
		if ($('#mainBody_iframe').attr("src") != "") {
			document.getElementById('mainBody_iframe').contentWindow.SaveDocument();
			doSaveBizRuAction();
			fg = doSave(status);
		} else {
			fg = doSave(status);
		}
	}
	return fg;
}

function doSave(status){
	var flag = false;
	//获取值方法
	$("#textfield").val(UE.getEditor('editor').getContent());
	if($("#textfield").val().length>500){
		$("#textfield").val($("#textfield").val().substr(0,499));
	}
	if (status == '1') {
		$("#status").val('1');
	} else {
		$("#status").val('0');
	}
	var time = new Date().getTime();
	//赋值方法
	$.ajax({
		url : saveUrl+time,
		type : "post",
		async: false,
		dataType : "text",
		data : $('#ff').serialize(),
		success : function(data) {
			flag = true;
			if (status != '1') {
				window.parent.closePage(window, true, true, true);
			}
		}
	});
	return flag;
}

function send() {
	if (save('1')) {
		var a = $("#circulatedpeopleid").val();
		var b = $("#mustseeid").val();
		var c = $("#sceneid").val();
		var d = $("#id").val();
		var time = new Date().getTime();
		var AjaxURL = "circularize/sendGTasks?time"+time;
		$.ajax({
			type : "POST",
			url : AjaxURL,
			async : false,
			data : {
				circulatedpeopleid : a,
				mustseeid : b,
				sceneid : c,
				id : d
			},
			success : function(data) {
				window.parent.closePage(window, true, true, true);
			},
			error : function(data) {
			}
		});
	}
}

function initTable() {

	//var id = $('#id').val();
	$('#tapList').bootstrapTable({
		url : 'circularize/getAllLinkinfo', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : false, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				id : $('#id').val()
			};
			return temp;
		}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		pageList : [ 10, 25, 50, 100 ], // 可供选择的每页的行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		//strictSearch : true,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "id", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		columns : [ {
			field : 'receiveuid',
			title : '处理人员'
		}, {
			field : 'opinion',
			title : '处理状态',
			formatter : function(value, row) {
				if (value != null && value != '') {
					return '已处理';
				} else {
					return '未处理';
				}
			}
		}, {
			field : 'opinion',
			title : '处理意见'
		}, {
			field : 'finishtime',
			title : '处理时间'
		} ]
	});
}

function selectPeople(id) {
	changeIndex();
	users = id;
	$('#myModal').modal('show');
	//加载人员信息 

	$('#group').attr("src", "treeController/zMultiPurposeContacts?state=1");
	
}

function makesurePerson() {
	var arr = document.getElementById("group").contentWindow.doSaveSelectUser();
	document.getElementById(users).value = arr[1];
	document.getElementById(users + "id").value = arr[0];

	$('#myModal').modal('hide');
	$('#'+users).focus();
	users = '';
}

function btnQk() {
	document.getElementById("group").contentWindow.btnQk();
}
function btnCancel() {
	//document.getElementById("group").contentWindow.btnCancel();
	$('#myModal').modal('hide');
}

//切换到表单所在的页签
function changeIndex() {
	if (divId == "mainBody") {
		$('#myTabs li:eq(1)').removeClass("active");
		$('#mainBody').removeClass("active");
		$('#myTabs li:eq(0)').addClass("active");
		$('#bizform').addClass("active");
		divId = "bizform";
	}
}
