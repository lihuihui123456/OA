
var users = "";
var choose_userid="";
var choose_username="";
var fg = false;
var time = Date.parse(new Date());

$(function(){
	//init();
	buttoninit();
	//加载表格
	initTable();
	$('#ff').validationEngine({ }); 
	  var buttons1=$(window.frames["mainFrame"].document).find("button");
	    for(var i=0;i<buttons1.length;i++){
	    	if(buttons1[i].getAttribute("id")!="open" && buttons1[i].getAttribute("id")!="resave"){
		    	buttons1[i].setAttribute("disabled","disabled");
	    	}
	    }
});


function init(){
	var type = $('#type').val();
	if (type == 'open') {
		onlyRead();
	}
}
function onlyRead(){
    var inputs=document.getElementsByTagName("input");
    for(var i=0;i<inputs.length;i++){
    	inputs[i].setAttribute("disabled","disabled");
    }
    
    
    var buttons=document.getElementsByTagName("button");
    for(var i=0;i<buttons.length;i++){
    	buttons[i].setAttribute("disabled","disabled");
    }
    $(window.frames["mainFrame"].document).find("button").attr("disabled","disabled");
    var buttons1=$(window.frames["mainFrame"].document).find("button");
    for(var i=0;i<buttons1.length;i++){
    	if(buttons1[i].getAttribute("id")!="open" && buttons1[i].getAttribute("id")!="resave"){
	    	buttons1[i].setAttribute("disabled","disabled");
    	}
    }
}

function buttoninit(){

	$('#send_btn').click(function(){
		send();
	});

	$('#save_btn').click(function(){
		save();
	});
}
function selectPeople(id){
	users = id;
	$('#myModal').modal('show');
	//加载人员信息 
	 
	$('#group').attr("src","treeController/zMultiPurposeContacts?state=1");
}

function makesurePerson(){
	
	var arr=document.getElementById("group").contentWindow.doSaveSelectUser();
	if(arr[1] == ""){
		layerAlert("未选择人员");
		return;
	}
	document.getElementById(users).value = arr[1];
	document.getElementById(users+"id").value = arr[0];
	
	$('#myModal').modal('hide');
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
	changeIndex();
	//获取值方法
	$("#textfield").val(UE.getEditor('editor').getContent());
	
	$("#flag").val(status);
	//赋值方法
	var AjaxURL = "circularize/saveLinkInfor?time="+time;
	$.ajax({
		type: "POST",
		url: AjaxURL,
		async: false,
		data: $('#ff').serialize(),
		success: function (data) {
			//document.getElementById("id").value =data;
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

function send(){
	save('1');
	if(fg){
		return;
	}
	var a = $("#circulatedpeopleid").val();
	var b = $("#mustseeid").val();
	var c =	$("#sceneid").val();
	var d =	$("#id").val();
	var AjaxURL = "circularize/sendGTasks?time="+time;
	$.ajax({
		type: "POST",
		url: AjaxURL,
		async: false,
		data: {circulatedpeopleid:a,mustseeid:b,sceneid:c,id:d},
		success: function (data) {
			window.parent.closePage(window,true,true,true);
		},
		error: function(data) {
		}
	});
}

function initTable() {
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
				id:$('#id').val()
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
		columns: [{ 
		        	  field: 'receiveuid', 
		        	  title: '处理人员'
		          }, {
		        	  field: 'opinion', 
		        	  title: '处理状态',
		  				formatter : function(value, row) {
							if (value != null && value != ''){
								return '已处理';
							}else{
								return '未处理';
							}
		  				}
		          }, {
		        	  field: 'opinion', 
		        	  title: '处理意见'
		          }, {
		        	  field: 'finishtime', 
		        	  title: '处理时间'
		          }
		      ] 
	});
}

