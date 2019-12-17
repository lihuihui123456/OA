<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>通讯录</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link href="${ctx}/views/aco/contacts/css/contacts.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css" rel="stylesheet">
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${ctx}/views/aco/contacts/js/contacts.js"></script>
<script type="text/javascript" src="${ctx}/views/aco/contacts/js/contacts_client.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>

		
<style type="text/css">
.modal-footer{
	text-align:center;
}
.add_contact img{
	width:110px;
	height:110px;
	border-radius:50%;
}
.person_info{
	margin-left:120px;
	margin-top:-80px;
	margin-bottom:60px;
}
.operation i{
	font-size:30px;
	color:#989b9e;
}

#viewImgUrl {
	width: 100px;
	height: 100px;
}
.modal-footer{
	padding-top:10px;
	padding-bottom:10px;
}
.modal-body{
	padding-top:10px;
	padding-bottom:10px;
}
.modal-content{
	width:400px;
}
#viewUserName{
	margin-left:20px;
}
.fa-size-self{
	font-size: 1.3em;
}
</style>
	</head>
	<body>
		<div>
				<div class="sidebar easyui-resizable" data-options="minWidth:190">
					<div class="sidebar-collapse" style="height:100%">
						<div id="sidebar-menu" class="sidebar-menu" style="height:100%;overflow:auto;" >
							<ul id="dept_post_tree" class="ztree"></ul>
						</div>
					</div>
				</div>
			<div class="word-select">
				<ul class="word-select-ul">
				</ul>
				
			</div>
		<div class="main" id="main">
			<div id="search_div"
				style="width: 450px; float: right; padding-bottom: 10px;padding-top: 10px;">
				<div class="input-group">
					<input type="text" id="input-word" class="form-control input-sm"
						value="请输入姓名/部门名称/电话/手机/电子邮件查询" onFocus="if (value =='请输入姓名/部门名称/电话/手机/电子邮件查询'){value=''}"
						onBlur="if (value ==''){value='请输入姓名/部门名称/电话/手机/电子邮件查询'}"> <span
						class="input-group-btn">
						<button type="button" class="btn btn-primary btn-sm"
							style="margin-right: 0px" onclick="search()">
							<i class="fa fa-search"></i> 查询
						</button>
						<button type="button" class="btn btn-primary btn-sm"
							style="margin-right: 10px;margin-left:2px;" onclick="downloadExcel()">
							<i class="fa fa-cloud-download"></i> 导出
						</button>
					</span>
				</div>
			</div>
			<div class="panel-body" style="padding-top:0px;padding-bottom:0px;border:0;">
				<div id="toolbar" class="btn-group" style="margin-top:10px;">
					<!-- <button id="btn_add_user" type="button" class="btn btn-default btn-sm">
						<span class="fa fa-user-plus" aria-hidden="true"></span> 添加常用联系人
					</button>
					<button id="btn_delete_user" type="button" class="btn btn-default btn-sm">
						<span class="fa fa-user-times" aria-hidden="true"></span> 删除常用联系人
					</button> -->
					<!-- <button id="btn_download" type="button" onclick="downloadExcel()" class="btn btn-default btn-sm">
						<span class="fa fa-cloud-download" aria-hidden="true"></span> 导出
					</button> -->
					
			</div>
			<table id="userList"></table>
			
		</div>
	<form id="exportCuserToExcel" method="post" action="${ctx}/DownloadContactsc/downloadExcelByPoi">
		<input id="userIds" name="userIds" type="hidden">
		<input id="isSelectorNot" name="isSelectorNot" type="hidden">
		<input id="hidDeptId" name="hidDeptId" type="hidden">
		<input id="hidWord" name="hidWord" type="hidden">
		<input id="hidParam" name="hidParam" type="hidden">
	</form>
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
		
	</div>
	<div class="modal fade" id="viewModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" >
		<div class="modal-dialog" role="document" >
			<div class="modal-content" >
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">联系人详细信息</h4>
				</div>
				<div class="modal-body">
					<div class="add_contact">
						<img id="viewImgUrl">
						<div class="person_info">
							<h3>
								<span id="viewUserName" ></span><span id="viewUserIsInContacotors"></span>
							</h3>
							<!--  <p class="operation">
							
								&nbsp;&nbsp;<a href="javascript:;"><i class="fa fa-envelope"onclick="sendMail();"></a></i>&nbsp;&nbsp;&nbsp;&nbsp;
								<a href="javascript:;"><i class="fa fa-comment" onclick="sendMail();"></i></a>
							</p>  -->
						</div>
					</div>
					<form class="form-horizontal">
						<div class="form-group">
							<label class="col-sm-3" style="text-align: left;">部门名称： </label>
							<div class="col-sm-9">
								<span id="viewDeptName"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 " style="text-align: left;">电话 :</label>
							<div class="col-sm-9">
								<span id="viewTelephone"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 " style="text-align: left;">手机 :</label>
							<div class="col-sm-9">
								<span id="viewMobile"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3" style="text-align: left;">电子邮件:</label>
							<div class="col-sm-9">
								<span id="viewEmail"></span>
							</div>
						</div>
					</form>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
	</body>
</html>
<script type="text/javascript">
var mySwiper = new Swiper('.swiper-container',{
    loop:true,
	onSlidePrev: function(swiper){
	$("#tb_departments").bootstrapTable('prevPage');
	  },
	onSlideNext: function(swiper){
	$("#tb_departments").bootstrapTable('nextPage');
	}
});
			var setting = {
				data: {
					simpleData: {
						enable: true,
						rootPId: ""
					}
				},
				callback:{
					onClick:zTreeOnClick,
				}
			};
			var userName="";
			/* function search(){
				userName=$("#input-word").val();
				if(userName=="请输入姓名/部门名称/电话/手机/电子邮件查询"){
					userName="";
				}
				$("#hidParam").val($("#input-word").val());
				$("#hidDeptId").val("");
				$("#hidWord").val("");
				type="";
				deptId="";
				zTree.cancelSelectedNode();
				validateIsLarger();
				ajaxContactors();
				$("#userList").bootstrapTable('refresh');
			} */
			var deptId="";
			var type="";
			/* function zTreeOnClick(event,treeId,treeNode){
				//treeNode.id 部门ID
				type=treeNode.type;
				$("#hidDeptId").val(treeNode.id);
				$("#hidWord").val("");
				$("#hidParam").val("");
				if(type=="3"){
					deptId="alwaysContactors";
					type=1;
					validateIsLarger();
					ajaxContactors();
					$("#input-word").val("请输入姓名/部门名称/电话/手机/电子邮件查询");
					userName="";
					$("#userList").bootstrapTable('refresh');
				}else{
					deptId=treeNode.id;
					type=treeNode.type;
					validateIsLarger();
					ajaxContactors();
					$("#input-word").val("请输入姓名/部门名称/电话/手机/电子邮件查询");
					userName="";
					$("#userList").bootstrapTable('refresh');
				}
				
			} */
			function downloadExcel(){
				$("#isSelectorNot").val("");
				var obj = $("#userList").bootstrapTable("getSelections");
 				if(obj.length==0){
 					layer.confirm('是否导出所有联系人？', {
 						btn : [ '是', '否' ]
 					}, function(index) {
 						$("#isSelectorNot").val("0");
 						$("#exportCuserToExcel").submit();
 						layer.close(index);
 					}, function() {
 						return;
 					});
 				}else{
 					var userIds="";
					for(var i=0;i<obj.length;i++){
						if(i==0){
							userIds+=obj[i].userId;
						}else{
							userIds+=","+obj[i].userId;
						}
					}	
					$("#userIds").val(userIds);
					$("#exportCuserToExcel").submit();
 				}
 				
			}
			
			function viewContactors(row){
				$("#viewUserIsInContacotors").html("");
				$.ajax({
					type: "post",
					async: false,
					url: "bizContactsController/valIsInContactors",
					data: {userId:row.userId},
					success: function (data) {
						if(data=="1"){
							$("#viewUserIsInContacotors").html("<li class=\"contacts-star fa fa-star fa-size-introduce\" onclick=\"operateCollect('"+row.userId+"','"+row.userName+"')\"></li>");
						}else{
							$("#viewUserIsInContacotors").html("<li class=\"contacts-star fa fa-star-o fa-size-introduce\" onclick=\"operateCollect('"+row.userId+"','"+row.userName+"')\"></li>");
						}
						$("#viewUserName").text(row.userName);
						$("#viewImgUrl").attr("src","${ctx}/uploader/uploadfile?pic="+row.picUrl);
						 $("#viewTelephone").text(row.userTelephone==null?"":row.userTelephone);
						$("#viewMobile").text(row.userMobile==null?"":row.userMobile);
						$("#viewEmail").text(row.userEmail==null?"":row.userEmail);
						$("#viewDeptName").text(row.deptName==null?"":row.deptName); 
					}
				});
			}
			var modalFlag;
			
			/**
			 * 初始化表格数据
			 */
			var word;
		 	var zNodes;
			var zTree;
			var listCub;
			function ajaxContactors(){
				$.ajax({
					type: "POST",
					async: false,
					url: "bizContactsController/ajaxContactors",
					data: {},
					success: function (data) {
						listCub=data;
					}
				});
			}
			function initTable(url,temp){
 				var url = "bizContactsController/queryUserByDept";
 				ajaxContactors();
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
							deptId:deptId,
							type:type,
							word:word,
							userName:userName
						}; 
						return temp;
					}, // 传递参数（*）
					sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
					pageNumber : 1, // 初始化加载第一页，默认第一页
					pageSize : 10, // 每页的记录行数（*）
					search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
					/* strictSearch : true,
					searchOnEnterKey:true, */
					showColumns : false, // 是否显示所有的列
					showRefresh : true, // 是否显示刷新按钮
					minimumCountColumns : 2, // 最少允许的列数
					clickToSelect : false, // 是否启用点击选中行
					uniqueId : "userId", // 每一行的唯一标识，一般为主键列
					showToggle : false, // 是否显示详细视图和列表视图的切换按钮
					cardView : false, // 是否显示详细视图
					detailView : false, // 是否显示父子表
					undefinedText:"",
					columns : [ [ {
						checkbox : true
					}, {
						field : 'Number',
						title : '序号',
						formatter : function(value, row, index) {
							return index + 1;
						},
						width:'45px',
						align:'center'
					},{
						field : '',
						title : '收藏',
						align:'center',
						width:'45px',
						valign:'middle',
						formatter :  function(value, row, index) {
							var flag=true;
							 $.each(listCub,function(index,obj){
								 if(obj.userId==row.userId){
									 flag=false;
								 }
				 			}); 
							 if(flag){
								return "<li class=\"contacts-star fa fa-star-o fa-size-self\" id=\"li"+row.userId+"\" title=\"点击收藏\" onclick=\"operateCollect('"+row.userId+"','"+row.userName+"')\"></li>"; 
							 }else{
								 return "<li class=\"contacts-star fa fa-star fa-size-self\" id=\"li"+row.userId+"\"  title=\"取消收藏\" onclick=\"operateCollect('"+row.userId+"','"+row.userName+"')\"></li>";
							 }
						},
						
					},{
						field : 'userName',
						title : '姓名',
						width:'80px',
						align:'center'
					},{
						field : 'deptName',
						title : '部门名称',
						width:'135px',
						formatter :  function(value, row, index) {
							return value==null?"":value;
						}
					}/* ,{
						field : 'userTelephone',
						title : '电话',
						align:'center',
						width:'100px',
						formatter :  function(value, row, index) {
							return value==null?"":value;
						}
					} */,{
						field : 'userMobile',
						title : '手机',
						align:'center',
						width:'105px',
						formatter :  function(value, row, index) {
							return value==null?"":value;
						}
					}, {
						field : 'userEmail',
						title : '电子邮件',
						width:'150px',
						formatter :  function(value, row, index) {
							return value==null?"":value;
						}
					}] ],onClickRow:function(row,obj){
						if(modalFlag!=1){
							viewContactors(row);
							var modal = $('#viewModal');
							modal.modal('show');
						}
						modalFlag="";
				      }
					
				});
			}
			function initTable(datas){
 				var url = "bizContactsController/queryUserByDept";
 				ajaxContactors();
 				$('#userList').bootstrapTable({
					//url : url,
					data:datas,
					method : 'get', // 请求方式（*）
					/* toolbar : '#toolBar', // 工具按钮用哪个容器 */
					striped : true, // 是否显示行间隔色
					cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
					pagination : true, // 是否显示分页（*）
					sortable : true, // 是否启用排序
					sortOrder : "asc", // 排序方式
					queryParams : function(params) {
					 	var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
							pageSize : params.limit, // 页面大小
							pageNum : params.offset, // 页码
							deptId:deptId,
							type:type,
							word:word,
							userName:userName
						}; 
						return temp;
					}, // 传递参数（*）
					sidePagination : "client", // 分页方式：client客户端分页，server服务端分页（*）
					pageNumber : 1, // 初始化加载第一页，默认第一页
					pageSize : 10, // 每页的记录行数（*）
					search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
					/* strictSearch : true,
					searchOnEnterKey:true, */
					showColumns : false, // 是否显示所有的列
					showRefresh : false, // 是否显示刷新按钮
					minimumCountColumns : 2, // 最少允许的列数
					clickToSelect : false, // 是否启用点击选中行
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
						},
						width:'45px',
						align:'center'
					},{
						field : '',
						title : '收藏',
						align:'center',
						width:'40px',
						valign:'middle',
						formatter :  function(value, row, index) {
							var flag=true;
							 $.each(listCub,function(index,obj){
								 if(obj.userId==row.userId){
									 flag=false;
								 }
				 			}); 
							 if(flag){
								return "<li class=\"contacts-star fa fa-star-o fa-size-self\" id=\"li"+row.userId+"\" title=\"点击收藏\" onclick=\"operateCollect('"+row.userId+"','"+row.userName+"')\"></li>"; 
							 }else{
								 return "<li class=\"contacts-star fa fa-star fa-size-self\" id=\"li"+row.userId+"\"  title=\"取消收藏\" onclick=\"operateCollect('"+row.userId+"','"+row.userName+"')\"></li>";
							 }
						},
						
					},{
						field : 'userName',
						title : '姓名',
						width:'70px',
						align:'center'
					},{
						field : 'deptName',
						title : '部门名称',
						width:'155px',
						formatter :  function(value, row, index) {
							return value==null?"":value;
						}
					} ,{
						field : 'userTelephone',
						title : '电话',
						align:'center',
						width:'100px',
						visible:false,
						formatter :  function(value, row, index) {
							return value==null?"":value;
						}
					} ,{
						field : 'userMobile',
						title : '手机',
						align:'center',
						width:'100px',
						formatter :  function(value, row, index) {
							return value==null?"":value;
						}
					}, {
						field : 'userEmail',
						title : '电子邮件',
						width:'100px',
						formatter :  function(value, row, index) {
							return value==null?"":value;
						}
					}] ],onClickRow:function(row,obj){
						if(modalFlag!=1){
							viewContactors(row);
							var modal = $('#viewModal');
							modal.modal('show');
						}
						modalFlag="";
				      }
					
				});
			}
			$(document).ready(function(){
	 			startWord=65;
	 			$.fn.zTree.init($("#dept_post_tree"), setting, ${treeList});
	 			zTree = $.fn.zTree.getZTreeObj("dept_post_tree");
	 			//initTable();
	 			queryOnceAll();
	 			createWord();
	 			$("#btn_add_user").show();
				$("#btn_delete_user").hide();
	 			$('#input-word').keydown(function(e){
	 				if(e.keyCode==13){
	 					search();
	 				}
				});
	 			$("#okExport").click(function(){
	 				$("#isSelectorNot").val("0");
	 				$("#exportCuserToExcel").submit();
	 				$("#myModal").modal("hide");
	 			});
	 			$(".easyui-resizable").mousemove(function(){
	 				$(".main").css("padding-left",$(".sidebar").width()+22);
	 				$(".word-select").css("left",$(".sidebar").width()+7);
	 				$("#sidebar-menu").css("width",$("#sidebar-menu").width()+7);
	 			});
	 			$("button[name='refresh']").css("display","none");
	 		});
			
		</script>
<%@ include file="/views/aco/common/foot.jsp"%>
