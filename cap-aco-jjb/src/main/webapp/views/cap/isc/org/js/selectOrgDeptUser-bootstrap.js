$(function() {
	InitTreeData();
	findUserListByOrgId();
	$('#dept_post_tree').on('nodeSelected', function(event, data) {
		orgId = data.id;
		dtype = data.color;
		if (dtype == '0') {
			return;
		}
		$("#search_div").show();
		if(data.is_vrtl_node =="F"){
			editGroupInfo();
		}
		$("#userList").bootstrapTable('refresh');
		//新增修改显示问题
		if(dtype==""){
			$("#add").hide();
			$("#update").hide();
			$("#import").hide();
			$("#delete").hide();
			
		}else{
			$("#add").show();
			$("#update").show();
			$("#import").show();
			$("#delete").show();
		}
		
	});
	$('.dropdown-menu').dropdown();
});
/**
 * 初始化加载左侧树
 */
var userName = "";
var orgId = "";
var dtype = "";
function InitTreeData() {
	$.ajax({
		type : "POST",
		url : "bizContactsController/findOrgDeptTree_bs",
		async : false,
		dataType : "json",
		success : function(data) {
			var $tree = $('#dept_post_tree').treeview({
				text : '16px',
				icon : 'fa fa-group',
				expandIcon : 'fa fa-angle-right',
				collapseIcon : 'fa fa-angle-down',
				nodeIcon : 'iconfont icon-bookmark',
				levels : 1,
				enableLinks : true,
				data : data
			});
		}
	});
}

/**
 * 按组织机构，查询条件加载用户列表信息
 * 
 * @param orgId
 *            组织机构id
 */
function findUserListByOrgId() {
	var url = "bizContactsController/findContactsUserListByOrgId";
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
				userName : userName,
				orgId : orgId,
				dtype : dtype
			};
			return temp;
		}, // 传递参数（*）
		onDblClickRow : function(row) {
			$.ajax({
				type : "POST",
				url : "userController/findUserById",
				data : {
					"id" : row.userId
				},
				success : function(data) {
					var imgUrl ="uploader/uploadfile?pic=";
					var viewModel = $("#viewModal");
					viewModel.modal('show');
					//填充值给span标签
					var viewImgUrl = document.getElementById("viewImgUrl");
					var sex="";
					if(data.picUrl!=""){
						viewImgUrl.src=imgUrl+data.picUrl;
					}else{
						if(data.userSex=="1"){
							sex="男";
							viewImgUrl.src="views/aco/contacts/images/man.png";
						}else{
							sex="女";
							viewImgUrl.src="views/aco/contacts/images/woman.png";
						}
					}
					var viewName = document.getElementById("viewUserName");
					viewName.innerHTML = data.userName; 
					var viewUserSex = document.getElementById("userSex");
					viewUserSex.innerHTML = sex;
					var viewMobile = document.getElementById("viewMobile");
					viewMobile.innerHTML = data.userMobile;
					var viewEmail = document.getElementById("viewEmail");
					viewEmail.innerHTML = data.userEmail;
					var viewOrgName = document.getElementById("viewOrgName");
					viewOrgName.innerHTML = data.orgName;
					var viewPostName = document.getElementById("viewPostName");
					viewPostName.innerHTML = data.postName;
					var viewRemark = document.getElementById("viewRemark");
					viewRemark.innerHTML = data.remark;
					
				},
				error : function(data) {
					layerAlert("error:" + data.responseText);
				}
			});

		},
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		// strictSearch : true,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "userId", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		columns : [ [ {
			checkbox : true
		}, {
			field : 'Number',
			title : '序号',
			formatter : function(value, row, index) {
				return index + 1;
			}
		},{
			field : 'userName',
			title : '姓名',
		} ,
		{
			field : 'userEmail',
			title : '邮件',
			visible:true,
		},
		{
			field : 'userEmail',
			title : 'QQ号码',
			visible:true,
		}, {
			field : 'userSex',
			title : '性别',
			formatter : function(value, row) {
				if (value == 1)
					return '女';
				if (value == 2)
					return '男';
			}
		}, {
			field : 'userMobile',
			title : '手机',
		}, {
			field : 'userEmail',
			title : '电子邮件',
		}, {
			field : 'orgName',
			title : '单位名称',
		},{
			 title: '操作',
             field: 'id',
             align: 'center',
             formatter:function(value,row,index){  
            	 var e = '<i class="fa fa-envelope" onclick="sendMail(\''+ row.userEmail + '\');"></i>&nbsp;&nbsp;';
            	 var d = '<i class="fa fa-comment" onclick="sendMail(\''+ row.userEmail + '\');"></i>';  
            	 return e+d;  
           } 
		}] ]
	});
}

function search() {
	userName = $(".form-control").val();
	if (userName == '输入登录帐号或真实姓名') {
		userName = "";
	}
	$("#userList").bootstrapTable('refresh');
}

function doSaveSelectUser() {
	var selecteds = $('#userList').bootstrapTable('getSelections');

	var ids = '';
	var names = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].userId + ",";
		names = names + selecteds[index].userName + ",";
	});

	if (ids != '') {
		ids = ids.substring(0, ids.length - 1);
	}
	if (names != '') {
		names = names.substring(0, names.length - 1);
	}

	var arr = [];
	arr[0] = ids;
	arr[1] = names;
	return arr;
}

function doSaveData() {
	var selecteds = $('#userList').bootstrapTable('getSelections');

	var ids = '';
	var names = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].userId + ",";
		names = names + selecteds[index].userName + ",";
	});

	if (ids != '') {
		ids = ids.substring(0, ids.length - 1);
	}
	if (names != '') {
		names = names.substring(0, names.length - 1);
	}

	var arr = [];
	arr[0] = ids;
	arr[1] = names;
	return arr;
}
/**
 * 打开分组管理页签
 */
function editGroupInfo(){
	var options={
			"text":"分组管理",
			"id":"00000",
			"href":"bizContactsController/groupIndex",
			"icon":"fa fa-gear"
		};
		window.parent.parent.createTab(options);
}

function notGroupUser(){
	dtype="3";
	$("#userList").bootstrapTable('refresh');
}