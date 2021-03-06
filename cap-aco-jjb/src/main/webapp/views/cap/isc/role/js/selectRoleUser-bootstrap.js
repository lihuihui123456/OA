$(function() {
	InitTreeData();
	roleId = '1';
	findUserListByRoleId();
	$("#sidebar-menu").hover(function() {
		// 鼠标经过的操作
		$('#sidebar-menu').css('overflow-y', 'auto');
	}, function() {
		// 鼠标离开的操作
		$('#sidebar-menu').css('overflow-y', 'hidden');
	});

	$('#role_tree').on('nodeSelected', function(event, data) {
		roleId = data.id;
		if (roleId == "0") {
			return;
		}
		$("#search_div").show();
		$("#userList").bootstrapTable('refresh');
		//findUserListByRoleId();
	});
});

/**
 * 初始化加载左侧树
 */
var roleId = "";
function InitTreeData() {
	$.ajax({
		type : "POST",
		url : "roleController/findRoleTreeByLoginId",
		async: false,
		dataType : "json",
		success : function(data) {
			 var $tree = $('#role_tree').treeview({
				  color: "#666666",
				  text:'16px',
				  icon:'fa fa-group',
		          expandIcon:'fa fa-angle-right',
		          collapseIcon:'fa fa-angle-down',
		          nodeIcon: 'iconfont icon-bookmark',
		          levels:1,
		          enableLinks: true,          
		          data: data
		       }); 
		}
	});
}

/**
 * 按组织机构，查询条件加载用户列表信息
 * 
 * @param orgId 组织机构id
 */
function findUserListByRoleId() {
	var url = "roleUserController/findUserListByRoleId-bs";
	$('#userList').bootstrapTable({
		url : url,
		method : 'get', // 请求方式（*）
		toolbar : '#toolBar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				query:title,
				roleId : roleId
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
		columns : [ [ 
 		    { checkbox : true }, 
 		    { field : 'Number', title: '序号',
 		    	formatter: function (value, row, index) {
                    return index+1;
                }
 		    }, 
 		    { field : 'acctLogin', title : '登录账号', }, 
 		    { field : 'userName', title : '真实姓名',  }, 
 		    { field : 'userMobile', title : '手机', } 
 		] ]
	});
}

var title = "";
function search(){
	title = $(".form-control").val();
	if(title == '输入登录帐号或真实姓名'){
		title = "";
	}
	$("#userList").bootstrapTable('refresh');
}

function doSaveRoleUser(){
	var selecteds = $('#userList').bootstrapTable('getSelections');
	
	var ids = '';
	var names = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].userId + ",";
		names = names + selecteds[index].userName + ",";
	});
	
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	if(names != ''){
		names = names.substring(0, names.length - 1);
	}
	var arr = [];
	arr[0]=ids;
	arr[1]=names;
	return arr;
}

function doSaveData(){
	var selecteds = $('#userList').bootstrapTable('getSelections');
	
	var ids = '';
	var names = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].userId + ",";
		names = names + selecteds[index].userName + ",";
	});
	
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	if(names != ''){
		names = names.substring(0, names.length - 1);
	}
	var arr = [];
	arr[0]=ids;
	arr[1]=names;
	return arr;
}