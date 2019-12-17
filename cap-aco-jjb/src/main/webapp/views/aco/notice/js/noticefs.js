

var users = "";
var choose_userid="";
var choose_username="";
var fg = false; 

$(function(){
	init();
	buttoninit();
	
	$('#ff').validationEngine({ }); 
});

function init(){
	var type = $('#type').val();
	if (type == 'open') {
		onlyRead();
		//加载表格
		initTable();
	}else{
		$("#name").focus();
	}
}
function onlyRead(){
    var inputs=document.getElementsByTagName("input");
    for(var i=0;i<inputs.length;i++){
    	inputs[i].setAttribute("disabled","disabled");
    }
    //$(window.frames["mainFrame"].document).find("button").attr("disabled","disabled");
    
    $("#send_btn").css("display","none");
    $("#save_btn").css("display","none");
    
    var buttons=$(window.frames["mainFrame"].document).find("button");
    for(var i=0;i<buttons.length;i++){
    	if(buttons[i].getAttribute("id")!="open" && buttons[i].getAttribute("id")!="resave"){
	    	buttons[i].setAttribute("disabled","disabled");
    	}
    }
}

function buttoninit(){
	//送交
	$('#send_btn').click(function(){
		send();
	});

	$('#save_btn').click(function(){
		save();
	});
}


function makesurePerson(){
	var arr=document.getElementById("group").contentWindow.doSaveSelectUser();
	document.getElementById(users).value = arr[1];
	document.getElementById(users+"id").value = arr[0];
	$('#myModal').modal('hide');
	$('#'+users).focus();
	users = '';
}

function btnQk(){
	document.getElementById("group").contentWindow.btnQk();
}
function btnCancel(){
	//document.getElementById("group").contentWindow.btnCancel();
	$('#myModal').modal('hide');
}

function save(status){
	
	if(!$('#ff').validationEngine('validate')){
		fg = true;
		return ;
	}
	//获取值方法
	$("#textfield").val(UE.getEditor('editor').getContent());
	if($("#textfield").val().length>1000){
		$("#textfield").val($("#textfield").val().substr(0,999));
	}
	if(status == '1'){
		$("#status").val('1');
	}else{
		$("#status").val('0');
	}
	//赋值方法
	var AjaxURL = "notice/doSaveNoticeInfo";
	$.ajax({
		type: "POST",
		url: AjaxURL,
		async: false,
		data: $('#ff').serialize(),
		success: function (data) {
			document.getElementById("id").value =data;
			
			if(status != '1'){
				//layerAlert("保存成功！");
				window.parent.closePage(window,true,true,true);
			}
			//return "123";
		},
		error: function(data) {
			return false;
		}
	});
}

//送交方法
function send(){
	//保存发送通知的消息
	save('1');
	if(fg){
		return;
	}
	var a = $("#senderid").val();
	var c =	$("#sceneid").val();
	var d =	$("#id").val();
	var AjaxURL = "notice/doSaveRecePer";
	//保存接收通知的人员信息
	$.ajax({
		type: "POST",
		url: AjaxURL,
		async: false,
		data: {senderid:a,sceneid:c,id:d},
		success: function (data) {
			window.parent.closePage(window,true,true,true);
		},
		error: function(data) {
		}
	});
}

function initTable() {
	//var id = $('#id').val();
	$('#tapList').bootstrapTable({
		url : 'notice/findNoticeAllPeopleinfo', // 请求后台的URL（*）
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
				id:$('#id').val()
			};
			return temp;
		}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
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
		columns: [{ 
		        	  field: 'receiveuid', 
		        	  title: '阅读人员'
		          }, {
		        	  field: 'status', 
		        	  title: '是否阅读',
		  				formatter : function(value, row) {
		  					if (value == 1)
								return '是';
							if (value == 0)
								return '否';
							return null;
		  				}
		          }, {
		        	  field: 'finishtime', 
		        	  title: '阅读时间'
		          }
		      ] 
	});
}
