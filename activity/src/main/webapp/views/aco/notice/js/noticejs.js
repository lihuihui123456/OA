
var users = "";
var choose_userid="";
var choose_username="";
var fg = false;

$(function(){
	init();
	//
	//加载表格
	initTable();
	$('#ff').validationEngine({ });
	if(window.parent.$('#framehome')[0]){
		var noticeFrame=window.parent.$('#framehome')[0].contentWindow.$('#notice_iframe');
		if(noticeFrame!=null){
			noticeFrame[0].contentWindow.Flow.init();
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
   /* var inputs=document.getElementsByTagName("input");
    for(var i=0;i<inputs.length;i++){
    	inputs[i].setAttribute("disabled","disabled");
    }
    
    //$("#mainFrame").attr("src","");
    //$(window.frames["mainFrame"].document).find("button").attr("disabled","disabled");
    var buttons=$(window.frames["mainFrame"].document).find("button");
    for(var i=0;i<buttons.length;i++){
    	if(buttons[i].getAttribute("id")!="open" && buttons[i].getAttribute("id")!="resave"){
	    	buttons[i].setAttribute("disabled","disabled");
    	}
    }*/
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
		          },{
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

