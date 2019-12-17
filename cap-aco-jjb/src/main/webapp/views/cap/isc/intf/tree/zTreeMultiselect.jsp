<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>zTree多功能树(常用联系人)</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/demo.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css" rel="stylesheet">
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript">
	var username = "";//姓名
	var deptId = "";//部门id
	var setting = {
		async:{
			enable:true,
			dataType:"json",
			type:"post",
			url:"${ctx}/treeController/getMultiPurposeContacts",
			autoParam:["id","pId"],
			idKey:"id",
			pIdKey:"pId",
			rootPId:0
		},
		callback:{
			onAsyncSuccess: peoplegetOrgExpand,
			onClick:zTreeOnClick
		}
	};
	//异步加载成功回调函数  
	function peoplegetOrgExpand(event, treeId, treeNode, msg) {
		var treeObj = $.fn.zTree.getZTreeObj("tree");
		var nodes = treeObj.getNodes();
		for (var i = 0; i < nodes.length; i++) { //设置节点展开
			treeObj.expandNode(nodes[i], true, false, false);
		}
	};
	function zTreeOnClick(event,treeId,treeNode) {
		if(treeNode.pId=='1000') {
			deptId = '1000';
		}else if(treeNode.pId=='2000') {
			deptId = '2000';
		}else {
			deptId = treeNode.code;
		}
		//alert(deptId);
		$("#userList").bootstrapTable('refresh');
	};
	
	var maxNum = "",pags = "",c_check = "";
	$(document).ready(function() {
		//ztree初始化
		$.fn.zTree.init($("#tree"),setting);
		//bootstrapTable初始化
		$('#userList').bootstrapTable({
			url : '${ctx}/treeController/getMultiUserList',
			method : 'get', // 请求方式（*）
			toolbar : '#toolBar', // 工具按钮用哪个容器
			striped : true, // 是否显示行间隔色
			cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			pagination : true, // 是否显示分页（*）
			sortable : false, // 是否启用排序
			sortOrder : "asc", // 排序方式
			queryParams : function(params) {
				var paglimit = maxNum == "" ? params.limit : maxNum;
				var pagoffset = pags == "" ? params.offset : pags;
				var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					pageSize : paglimit, // 页面大小
					pageNum : pagoffset, // 页码
					username: username,
					deptId  : deptId
				};
				return temp;
			}, // 传递参数（*）
			sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
			pageNumber : 1, // 初始化加载第一页，默认第一页
			pageSize : 5, // 每页的记录行数（*）
			pageList : [5, 10, 25, 50, 100 ], // 可供选择的每页的行数（*）
			search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
			//strictSearch : true,
			showColumns : false, // 是否显示所有的列
			showRefresh : false, // 是否显示刷新按钮
			minimumCountColumns : 2, // 最少允许的列数
			clickToSelect : true, // 是否启用点击选中行
			uniqueId : "userId", // 每一行的唯一标识，一般为主键列
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
	 		    { field : 'userName', title : '姓名'}, 
	 		    /* { field : 'userMobile', title : '手机'} */
	 		    { field : 'deptName', title : '所属部门'},
	 		    { field : 'postName', title : '职务'}
	 		] ],
	 		 onCheck : function(row, checked) {
	 			insertSelectData(row);
	 		},
	 		onUncheck : function(row) {
	 			var userId = row.userId;
	 			var userName = row.userName;
	 			removeUser(userId,userName);
	 		},
	 		onCheckAll : function(rows) {
				$(rows).each(function(index,row){
					insertSelectData(row);
				  });
			},
			onUncheckAll : function(rows) {
				$(rows).each(function(index,row){
					removeUser(row.userId,row.userName);
				  });
			},
			onLoadSuccess : function(data) {
				if (c_check == true) {
					var rows = data.rows;
					$(rows).each(function(index,row){
						insertSelectData(row);
						$("#userList").bootstrapTable("check", index)
					});
				} else if (c_check == false) {
					var rows = data.rows;
					$(rows).each(function(index,row){
						removeUser(row.userId,row.userName);
						$("#userList").bootstrapTable("uncheck", index)
					});
				}
			}
		});
	});
	
	function search() {
		var name = $("#input-word").val();
		if(name=='姓名'){
			name='';
		}
		username=encodeURI(encodeURI(name));
		$("#userList").bootstrapTable('refresh');
	}
	
	var ids = '';
	var names = '';
	function insertSelectData(row){
		var userId = row.userId;
		var userName = row.userName;
		if (ids.indexOf(userId) != -1) {
			return;
		}
	   
		$("#content").append('<a id="'+userId+'">'+row.userName+'<span class="close_man" onclick="removeUser(\''+userId+'\',\''+userName+'\')">×</span></a>');
		ids += row.userId + ",";
		names += row.userName + ",";
	}
	
	function removeUser(userId,userName){
		$("#"+userId).remove();
		
		ids = ids.replace(userId+",", "");
		names = names.replace(userName+",", "");
	}
	
	function doSaveSelectUser(){
		var arr = new Array();
		arr[0] = ids.substring(0,ids.length-1);
		arr[1] = names.substring(0,names.length-1);
		if(arr[0] == ""){
			layer.msg("未选择人员");
			//layerAlert("未选择人员");
			return;
		}
		return arr;
	}
	function btnQk(){
		ids = "";
		names="";
		$('#content a').each(function(){
			$(this).remove();
			$("#userList").bootstrapTable('refresh');
		});
	}
	
	function checkAll(obj) {
		if (obj.checked) {
			c_check = true;
		} else {
			c_check = false;
		}
		maxNum = 10000;
		pags = 1;
		$(".fixed-table-pagination").css("opacity",0);
		$("#userList").bootstrapTable('refresh');
	}
</script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/js/jquery.nicescroll.js"></script>
<script type="text/javascript">
$(".choose_man").niceScroll({
	cursorcolor : "#000",
	cursoropacitymax : 0.5,
	touchbehavior : false,
	cursorwidth : "8px",
	cursorborder : "0",
	cursorborderradius : "8px"
});
</script>
<style type="text/css">
.choose_man{
	width:100%;
	height:50px;
	position:fixed;
	z-index:11;
	bottom:0px;
	background:#fff;
	border-top:1px solid #ddd;
	padding-top:5px;
	overflow-x:hidden;
	overflow-y:auto;
 }
 .choose_man > a{
 	color:#333;
 	margin-right:10px;
 }
  .choose_man > a span.close_man{
  	color:#333;
  	opacity:0.5;
  	margin-left:3px;
  	font-weight:bold;
  }
  .choose_man > a span.close_man:hover{
  	opacity:1;
  	cursor:pointer;
  }
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="overflow-x:hidden;overflow-y:auto;">
	<div class="container-fluid content">
			<!-- start: Main Menu -->
			<div class="sidebar ">
				<div class="sidebar-collapse">
					<div id="sidebar-menu" class="sidebar-menu">
						<ul id="tree" class="ztree" style="height: 400px;"></ul>
					</div>
				</div>
			</div>
			<!-- end: Main Menu -->
			<!-- start: Content -->
			<div class="main" id="main" style="padding-bottom:50px;">
				<div id="search_div" style="float: left; padding-top: 10px;padding-right: 0px;">
					<div >
						<span >
							<input title="全选/反选" type="checkbox" onClick="checkAll(this)"/>全选/反选
						</span>
					</div>
				</div>
				<div id="search_div" style="width: 300px; float: right; padding-bottom: 10px;padding-right: 0px;">
					<div class="input-group">
						<input type="text" id="input-word" class="form-control"
							value="姓名" onFocus="if (value =='姓名'){value=''}"
							onBlur="if (value ==''){value='姓名'}"> 
						<span class="input-group-btn">
							<button type="button" class="btn btn-primary" style="margin-right: 0px"
								vonclick="search()">
								<i class="fa fa-search"></i> 查询
							</button>
						</span>
					</div>
				</div>
				<table id="userList"></table>
			</div>
			<!-- end: Content -->
		<!--/container-->
	</div>
	<div class="clearfix"></div>
	<div class="choose_man" id="content"><span >已选人员：</span>
	</div>
</body>
<style type="text/css">
.sidebar{
	position:fixed;
	z-index:11;
	top:0px;
	width:200px;
	background-color: #fff;
	border:1px solid #ddd;
}
.sidebar .sidebar-menu{
	width:200px;
}
.main{
	padding:0;
	padding-left:200px;
}
.dept_post_tree {
	font-size: 14px;
	overflow-y: auto;
}
.dept_post_tree a {
	font-size: 14px;
	padding-left: 5px;
}
.dept_post_tree li:hover {
	background-color:#fcf1f1!important;
	color:#576069!important;
}
.dept_post_tree li.node-selected{
	background-color:#fcf1f1!important;
	color:#576069!important;
}
.node-dept_post_tree{
	border-width:0!important;
	background-color:#fff!important;
	color:#576069!important;
}
.list-group-item {
	padding:10px;
}

.tablepic td{
  border:1px #becedb solid; 
  padding:5px;
 }
 .tablepic th{
   background:#eff0f5;
   border:1px #becedb solid;
 }
 .bmw{
  background:#f8f9fd;
 }
 .fixed-table-pagination .page-list{
 display:inline;
 }
</style>
</html>