<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>其他档案</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">


 <link href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/need/laydate.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/skins/default/laydate.css" rel="stylesheet">
<link href="${ctx}/views/aco/arc/arcbid/css/arcbid.css" rel="stylesheet">

<script type="text/javascript" src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css"
	rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>
<script src="${ctx}/views/aco/arc/pubinfo/js/pubInfoIndex.js"></script>						   
<script type="text/javascript">
function tableRefresh(){
	window.location.reload();
}
$(document).ready(function() {
	$("#search_form").find("input").eq(4).focus();
	$('#folderContent').bootstrapTable({
		url : '${ctx}/pubInfo/pageList',
		method : 'get', // 请求方式（*）
		/* toolbar : '#toolBar', */ // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			validateData();
		    var	arcName="";
			if($("#input-word").val()!="请输入文件标题查询"&&$("#input-word").val()!=""){
				arcName=arcName+$("#input-word").val();
				$("#search_form")[0].reset();
			}
			arcName=arcName+$("#arcName").val();
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				arcName:$.trim(arcName)  ,
				keyWord :$.trim($("#keyWord").val()) ,
				fileStart:$("#fileStart").val(),
				yearNum:$("#yearNum").val(),
				startRegTime:$("#startRegTime").val(),
				endRegTime:$("#endRegTime").val(),
				arcType:$("#typeId").val(),
				attribute:this.sortName,
				orderBy:this.sortOrder
			};
			return temp;
		}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageList : [10,15,20],
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		//strictSearch : true,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "arc_id", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		singleSelect : true,
		columns : [ [ 
 			 { checkbox : true }, 
 		    { field : 'Number', title: '序号',
 				valign: 'middle',
 				width: '5%',
 		    	formatter: function (value, row, index) {
                    return index+1;
                }
 		    }, 
 		    { field : 'arc_name', title : '文件标题',
 				align : 'left',
 				valign: 'middle',
 				width : '20%',
 		    	sortable : true,
/*  		    	events: onTdClickTab,
 */ 		        formatter: onTdClickTabFormatter}, 
 		    { field : 'key_word', title : '关键字',sortable : true},
		    { field : 'reg_dept', title : '登记部门',sortable : true},
		    { field : 'reg_user', title : '登记人',sortable : true}, 
 		    { field : 'reg_time', title : '登记日期',
				align : 'center',
				valign: 'middle',
		    	sortable : true,
	 			formatter:function(value,row){
					return new Date(parseInt(row.reg_time)).Format('yyyy-MM-dd');
			}},
		    { field : 'file_start', title : '档案状态',sortable : true,
			formatter :formatterFileStart
		    }, 
		    { field : 'dep_pos', title : '存放位置',sortable : true}, 
 		] ],
		onClickRow: function (row, tr) {
			date = new Date().getTime();
			var arcId = row.arc_id;
			var options = {
				"text" : "其他档案-查看",
				"id" : date,
				"href" : "pubInfo/goToPubInfoView?id="
						+ $("#typeId").val() + "&pId=" + $("#pId").val()
						+ "&arcId=" + arcId,
				"pid" : window.parent
			};
			window.parent.parent.createTab(options);
		}
	});
	var myDate= new Date();
	//var startYear=myDate.getFullYear()-5;//起始年份
	var startYear=myDate.getFullYear();
	var endYear=myDate.getFullYear()+5;//结束年份
	var obj=document.getElementById('yearNum')
	for (var i=startYear;i<=endYear;i++)
	{
	obj.options.add(new Option(i,i));
	}
});
function search() {
	if ($('#search_form').validationEngine('validate')) {
		$('#advSearchModal').modal('hide');
		 $("#input-word").val("");
		$("#folderContent").bootstrapTable('refresh');
	}	
}	
function validateData() {
	var startRegTime=$("#startRegTime").val();
	var endRegTime=$("#endRegTime").val();
	if(startRegTime!=""&&endRegTime!=""){
		if(startRegTime > endRegTime){
			window.parent.publicAlert("登记开始日期不能大于结束日期");
			return;
		}
	}
}
Date.prototype.Format = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}
/* document.onkeydown = function(event_e){    
    if(window.event)    
     event_e = window.event;    
     var int_keycode = event_e.charCode||event_e.keyCode;    
     if(int_keycode ==13){
    	 search(); 
    }  
}  */
/* $(function(){
	var myDate= new Date();
	var startYear=myDate.getFullYear()-5;//起始年份
	var endYear=myDate.getFullYear()+5;//结束年份
	var obj=document.getElementById('yearNum')
	for (var i=startYear;i<=endYear;i++)
	{
	obj.options.add(new Option(i,i));
	}
}); */
</script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<style>
.control-label {
	text-align: left !important;
}
#toolbar{
margin-top: 10px;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body  >
              	<div id="search_div" style="width: 300px; float: right; padding-bottom: 10px;padding-top: 10px;">
					<div class="input-group">
						<input type="text" id="input-word" class="form-control input-sm"
							value="请输入文件标题查询" onFocus="if (value =='请输入文件标题查询'){value=''}"
							onBlur="if (value ==''){value='请输入文件标题查询'}"> 
						<span class="input-group-btn">
							<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px"
								onclick="searchCommon()">
								<i class="fa fa-search"></i> 查询
							</button>
								<button type="button" class="btn btn-primary btn-sm" style="margin-left:2px" onclick="advSearchModal()">高级
					</button>
						</span>
					</div>
				</div>
			<div style="padding-top: 0px;padding-bottom:0px;border:0;">	
				<div id="toolbar" class="btn-group" style="margin-top:10px;">
				  <button id="add_btn" type="button" class="btn btn-default btn-sm" >
				    <span class="fa fa-plus" aria-hidden="true" ></span> 登记
			     </button>	
			     <button id="update_btn" type="button" class="btn btn-default btn-sm" >
				    <span class="fa  fa-edit" aria-hidden="true"></span> 修改
			     </button>	
				<button id="filestart_btn" type="button" class="btn btn-default btn-sm" >
				  <span class="fa fa-files-o" aria-hidden="true"></span> 归档
			     </button>	
			     <button id="addfilestart_btn" type="button" class="btn btn-default btn-sm" >
				   <span class="fa fa-folder-open" aria-hidden="true"></span> 追加归档
			     </button>		
			      <button id="delete_btn" type="button" class="btn btn-default btn-sm" >
				    <span class="fa fa-remove" aria-hidden="true"></span> 删除
			     </button>	
			      <button id="destry_btn" type="button" class="btn btn-default btn-sm" >
				    <span class="fa fa-ticket" aria-hidden="true"></span> 作废
			     </button>	
		<!-- 	     <button id="restore_btn" type="button" class="btn btn-default btn-sm" >
				    <span class="fa fa-reply" aria-hidden="true"></span> 还原
			     </button> -->
			      <button id="export_excel_btn" type="button" class="btn btn-default btn-sm" >
				   <span class="fa fa-download" aria-hidden="true"></span> 导出Excel
			     </button>	
			  <!--     <button id="view_btn" type="button" class="btn btn-default btn-sm" >
				 <span class="fa fa-eye" aria-hidden="true"></span>
				查看
			     </button> -->					
				</div>
		<%-- 			<div id="" style="border:1px solid #ddd; background:#fff; padding:10px; padding-right:10%; margin-top: 10px" >
					<form class="form-horizontal" id="search_form"">
					  <input type="hidden" id="typeId" name="typeId" value="${typeId}" />
				      <input type="hidden" id="pId" name="pId" value="${pId}" />
					 <input type="hidden" id="amsType" name="amsType" value="${typeId}" />
					 <input type="hidden" id="arcType" name="arcType" value="${typeId}" />
							<div class="form-group">
							<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">文件标题:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<input class="form-control input-sm" type="text" id="arcName"
									name="arcName" placeholder="请输入文件标题" style="margin-left: -50px;">
							</div>
								<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">关键字:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<input class="form-control input-sm" type="text" id="keyWord"
									name="keyWord" placeholder="请输入关键字" style="margin-left: -50px;">
							</div>
			
						</div>
						<div class="form-group">
									<label
							class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">档案状态:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<select id="fileStart" name="fileStart" class="selectPiker select input-sm" style="color: #000;width: 100%;margin-left: -50px;">
									<option value="">全部</option>									
									<option value="1">已归档</option>
									<option value="0">未归档</option>
									<option value="2">已作废</option>
								</select>
							</div>
											<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">年度:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4" >
									<select class="form-control input-sm selectpicker" id="yearNum"
								name="yearNum" value="" title="请选择年度" style="margin-left: -50px;">
								<option value=""></option>
						</select>
							</div>	
						</div>
						
						<div class="form-group">
																		
							<label
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">登记日期:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<input type="text" id="startRegTime" name="startRegTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left;margin-left: -50px;"
									 onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
								<span
									style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
								<input type="text" id="endRegTime" name="endRegTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									 onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
							</div>
				
							
						</div>	
				<div style="text-align:center;margin-left:5%;">
				<button type="button" id="view_btn" class="btn btn-default">查看原文</button>
					<button type="button" id="btn_search" class="btn btn-default" onclick="search()">查询</button>
					<button type="button" id="btn_reset" class="btn btn-default">重置</button>
				</div>
				<div class="clearfix"></div>
						</form>	
						</div>	 --%>				
				<table id="folderContent" ></table>
				</div>
			<div class="swiper-container">
	</div>
<!-- 模态框（Modal） -->
	<div class="modal fade" id="advSearchModal" aria-hidden="true">
		<div class="modal-dialog" style="width: 700px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >高级搜索</h4>
				</div>
				<div class="modal-body">
			   <form class="form-horizontal" id="search_form">
			   		   <input type="hidden" id="selectIds" name="selectIds"/>
					  <input type="hidden" id="typeId" name="typeId" value="${typeId}" />
				      <input type="hidden" id="pId" name="pId" value="${pId}" />
					 <input type="hidden" id="amsType" name="amsType" value="${typeId}" />
					 <input type="hidden" id="arcType" name="arcType" value="${typeId}" />
							<div class="form-group">
							<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">文件标题:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<input class="form-control input-sm" type="text" id="arcName"
									name="arcName" placeholder="请输入文件标题" style="margin-left: -50px;">
							</div>
								<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">关键字:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<input class="form-control input-sm" type="text" id="keyWord"
									name="keyWord" placeholder="请输入关键字" style="margin-left: -50px;">
							</div>
			
						</div>
						<div class="form-group">
									<label
							class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">档案状态:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<select id="fileStart" name="fileStart" class="selectPiker select input-sm" style="color: #000;width: 100%;margin-left: -50px;">
									<option value="">全部</option>									
									<option value="1">已归档</option>
									<option value="0">未归档</option>
									<option value="2">已作废</option>
								</select>
							</div>
											<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">年度:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4" >
									<select class="form-control input-sm selectpicker" id="yearNum"
								name="yearNum" value="" title="请选择年度" style="margin-left: -50px;">
								<option value=""></option>
						</select>
							</div>	
						</div>
						
						<div class="form-group">
																		
							<label
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">登记日期:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<input type="text" id="startRegTime" name="startRegTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left;margin-left: -50px;"
									 onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
								<span
									style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
								<input type="text" id="endRegTime" name="endRegTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									 onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
							</div>
				
							
						</div>	
				
				<div class="clearfix"></div>
			</form>
				</div>
				<div class="modal-footer" style="text-align: center;">
					<button type="button" id="btn_search" class="btn btn-primary btn-sm"
						onclick="search()">查询</button>
					<button type="button" id="btn_reset" class="btn btn-primary btn-sm">重置</button>
					<button type="button" id="modal_close" class="btn btn-primary btn-sm" data-dismiss="modal">取消</button>
				</div>
			</div>
		</div>
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
</style>
</html>
<%-- <%@ include file="/views/arc/common/foot.jsp"%> --%>