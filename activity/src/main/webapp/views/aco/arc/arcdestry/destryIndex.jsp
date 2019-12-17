<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>销毁管理</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/need/laydate.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/skins/default/laydate.css" rel="stylesheet">



<script type="text/javascript" src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<%-- <link rel="stylesheet" type="text/css" href="${ctx}/views/aco/docmgt/css/zTreeRightClick.css" />
<script src="${ctx}/views/aco/docmgt/js/zTreeRightClick.js"></script> --%>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>
<script src="${ctx}/views/aco/arc/arcdestry/js/destryIndex.js"></script>						   
<script type="text/javascript">
$(document).ready(function() {
	$("#search_form").find("input").eq(1).focus();
	$('#folderContent').bootstrapTable({
		url : '${ctx}/arcDestry/pageListSort',
		method : 'get', // 请求方式（*）
	/* 	toolbar : '#toolBar', */ // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
		    var	nbr="";
			if($("#input-word").val()!="请输入销毁单号查询"&&$("#input-word").val()!=""){
				nbr=nbr+$("#input-word").val();
				$("#search_form")[0].reset();
			}
			nbr=nbr+$("#nbr").val();
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				nbr:$.trim(nbr),
				arcType :$("#arcType").val(),
				arcName:$.trim($("#arcName").val()),
				fileStartTime:$("#fileStartTime").val(),
				fileEndTime:$("#fileEndTime").val(),
				operStartTime:$("#operStartTime").val(),
				operEndTime:$("#operEndTime").val(),
				sortName:this.sortName,
				sortOrder:this.sortOrder,
		};
			return temp;
		}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
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
		singleSelect : true,
		columns : [ [ 
 			 { checkbox : true }, 
 		    { field : 'Number', title: '序号',align: 'center',width: '5%',
 		    	formatter: function (value, row, index) {
                    return index+1;
                }
 		    }, 
 		    { field : 'nbr', title : '销毁单号', align: 'left',sortable : true}, 
 		    { field : 'type_name', title : '档案类型', align: 'left',sortable : true},
		    { field : 'arc_name', title : '文件标题', align: 'left',width: '20%',sortable : true,
 	 		    /* events: onTdClickTab, */
 	 		    formatter: onTdClickTabFormatter},
		    { field : 'reg_dept', title : '所属部门', align: 'left',sortable : true}, 
 		 
 		   { field : 'file_time', title : '归档日期', align: 'center',sortable : true,
	 			formatter:function(value,row){
	 				if(row.file_start==0){
	 					return "--";
	 				}else{
						return new Date(parseInt(row.file_time)).Format('yyyy-MM-dd');
	 				}
			}}, 
		   { field : 'oper_time', title : '销毁日期', align: 'center',sortable : true,
	 			formatter:function(value,row){
	 				if(row.is_invalid==2){
						return new Date(parseInt(row.oper_time)).Format('yyyy-MM-dd');
	 				}
	 				else{ 					
	 					return "--";
	 				}
				}
			},
		    { field : 'expiry_date', title : '有效期', align: 'left',sortable : true,
				formatter:function(value,row){
					var num="年";
					if(row.expiry_date==0){
						num="永久有效";
					}
					else{
						num=row.expiry_date+num;
					}
					return num;
			}
		    
		    }, 
		    {
				field : 'is_invalid',
				title : '档案状态',
				align : 'left',
				align: 'left',
				sortable : true,
				formatter:function(value,row){
					//0:未归档1:已归档2：追加归档
					//0:正常1：作废2：销毁
					 var fileStart = row.file_start;
					 var isInvalid = row.is_invalid;
					 var closingDate = row.closing_date;
					 var now = getNowFormatDate();
					  if(isInvalid=='2'){
						 	return '<span class="label label-danger">已销毁</span>';
					 }else if(isInvalid=='1'){
						 	return '<span class="label label-success">已作废</span>';
					 }else if (now >= closingDate){
							 return '<span class="label label-warning">已到期</span>';
					 }else {
						 return "--";
					 }
				}
			}
		] ],
		onClickRow: function (row, tr) {
			date = new Date().getTime();
			var id = row.id;
			var options = {
				"text" : "档案销毁-查看",
				"id" : date,
				"href" : "arcDestry/goToDestryView?id="+ id,
				"pid" : window
			};
			window.parent.parent.createTab(options);
		}/* ,
		onDblClickRow :	function(row){
			date = new Date().getTime();
			var id = row.id;
			var options = {
				"text" : "档案销毁-查看",
				"id" : date,
				"href" : "arcDestry/goToDestryView?id="+ id,
				"pid" : window
			};
			window.parent.parent.createTab(options);
			
		} */	
	});
	
	$("#btn_reset").click(function(){
		$('#advSearchModal').modal('hide');
		$("#nbr").val("");
		$("#arcType option:first").attr("selected","selected");
		$("#arcName").val("");
		$("#fileStartTime").val("");
		$("#fileEndTime").val("");
		$("#operStartTime").val("");
		$("#operEndTime").val("");
		search();
	})
});
function search() {
	  $('#advSearchModal').modal('hide');
	  $("#input-word").val("");
	var operStartTime=$("#operStartTime").val();
	var operEndTime=$("#operEndTime").val();
	if(operStartTime > operEndTime){
		layerAlert("销毁开始日期不能大于结束日期");
		return;
	}
	var startTime=$("#fileStartTime").val();
	var endTime=$("#fileEndTime").val();
	if(startTime > endTime){
		layerAlert("归档开始日期不能大于结束日期");
		return;
	}
	var fileStartTime=$("#fileStartTime").val();
	var fileEndTime=$("#fileEndTime").val();
	var operStartTime=$("#operStartTime").val();
	var operEndTime=$("#operEndTime").val();
/* 	if(fileStartTime > fileEndTime){
		layerAlert("归档开始时间不能大于归档结束时间");
		return;
	}
	if(operStartTime > operEndTime){
		layerAlert("销毁开始时间不能大于销毁结束时间");
		return;
	} */
	$("#folderContent").bootstrapTable('refresh');
}

function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    var hour = date.getHours();
    var min = date.getMinutes();
    var sec = date.getSeconds();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate;
    return currentdate;
}
/* document.onkeydown = function(event_e){    
    if(window.event)    
     event_e = window.event;    
     var int_keycode = event_e.charCode||event_e.keyCode;    
     if(int_keycode ==13){
    	 search(); 
    }  
}  */
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

</script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<link rel="stylesheet" type="text/css"  href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<%@ include file="/views/cap/common/theme.jsp"%>
</head><body style="padding-left: 10px;padding-right: 10px">
<!--   			<div style="text-align: left ;margin-top:10px;font-size:16px;font-weight: bold;font-family: '宋体';letter-spacing:2px"><span>销毁管理</span></div>
 -->
 			   <div id="search_div" style="width: 300px; float: right; padding-bottom: 10px;padding-top: 10px;">
					<div class="input-group">
						<input type="text" id="input-word" class="form-control input-sm"
							value="请输入销毁单号查询" onFocus="if (value =='请输入销毁单号查询'){value=''}"
							onBlur="if (value ==''){value='请输入销毁单号查询'}"> 
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
 <div id="toolbar" class="btn-group" style="margin-top:10px;">
					 <button id="add_btn" type="button" class="btn btn-default btn-sm" >
				    <span class="fa fa-plus" aria-hidden="true" ></span> 登记
			     </button>	
			     	<button id="update_btn" type="button" class="btn btn-default btn-sm" >
				     <span class="fa  fa-edit" aria-hidden="true"></span> 修改
			     </button>	
				<button id="destry_btn" type="button" class="btn btn-default btn-sm" >
				   <span class="fa fa-gavel" aria-hidden="true"></span> 销毁
			     </button>	
			     <button id="restore_btn" type="button" class="btn btn-default btn-sm" >
				    <span class="fa fa-reply" aria-hidden="true"></span> 还原
			     </button>	 	
			      <button id="delete_btn" type="button" class="btn btn-default btn-sm" >
			      <span class="fa fa-remove" aria-hidden="true"></span>删除
			     </button>	
			      <button id="export_excel_btn" type="button" class="btn btn-default btn-sm" >
				   <span class="fa fa-download" aria-hidden="true"></span> 导出Excel
			     </button>	
				 <!--<button id="view_btn" type="button" class="btn btn-default btn-sm" >
				   <span class="fa fa-eye" aria-hidden="true"></span> 查看
			     </button>-->				
				</div>
<%-- 					<div id="" style="border:1px solid #ddd; background:#fff; padding:10px; padding-right:10%; margin-top: 10px" >
					<form class="form-horizontal" id="search_form"">
								<div class="form-group">
							<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">销毁单号:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<input class="form-control input-sm" type="text" id="nbr"
									name="nbr" placeholder="请输入销毁单号">
							</div>
							
							
								<label
							class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">档案类型:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<select id="arcType" name="arcType" class="selectPiker select input-sm" style="color: #000;width: 100%;">
									<option value="">全部</option>	
									<c:forEach items="${listArcType}" var="arcTypeEntity">
									<option value="${arcTypeEntity.id}">${arcTypeEntity.typeName}</option>						
									</c:forEach>								
								</select>
							</div>
						</div>
						
							<div class="form-group">							
							<label
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">销毁日期:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<input type="text" id="operStartTime" name="operStartTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
								<span
									style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
								<input type="text" id="operEndTime" name="operEndTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									 onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
							</div>
							<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">文件标题:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<input class="form-control input-sm" type="text" id="arcName"
									name="arcName" placeholder="请输入文件标题">
							</div>
						</div>
						
						<div class="form-group">													
							<label
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档日期:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<input type="text" id="fileStartTime" name="fileStartTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
								<span
									style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
								<input type="text" id="fileEndTime" name="fileEndTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
							</div>
						</div>	
				<div style="text-align:center;margin-left:5%;">
					<button type="button" id="view_btn" class="btn btn-default" >查看原文</button>
					<button type="button" id="btn_search" class="btn btn-default" onclick="search()">查询</button>
					<button type="button" id="btn_reset" class="btn btn-default">重置</button>
				</div>
				<div class="clearfix"></div>
						</form>	
						</div>	 --%>				
				<table id="folderContent"></table>
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
			    <form class="form-horizontal" id="search_form"">
			    <input type="hidden" id="selectIds" name="selectIds"/>
			    
								<div class="form-group">
							<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">销毁单号:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<input class="form-control input-sm" type="text" id="nbr"
									name="nbr" placeholder="请输入销毁单号">
							</div>
							
							
								<label
							class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">档案类型:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<select id="arcType" name="arcType" class="selectPiker select input-sm" style="color: #000;width: 100%;">
									<option value="">全部</option>	
									<c:forEach items="${listArcType}" var="arcTypeEntity">
									<option value="${arcTypeEntity.id}">${arcTypeEntity.typeName}</option>						
									</c:forEach>								
								</select>
							</div>
						</div>
						
							<div class="form-group">							
							<label
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">销毁日期:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<input type="text" id="operStartTime" name="operStartTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
								<span
									style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
								<input type="text" id="operEndTime" name="operEndTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									 onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
							</div>
							<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">文件标题:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<input class="form-control input-sm" type="text" id="arcName"
									name="arcName" placeholder="请输入文件标题">
							</div>
						</div>
						
						<div class="form-group">													
							<label
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档日期:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<input type="text" id="fileStartTime" name="fileStartTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
								<span
									style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
								<input type="text" id="fileEndTime" name="fileEndTime"
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
					<button type="button" id="btn_reset" class="btn btn-primary btn-sm" onclick="clearCUserForm('search_form')">重置</button>
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
 #toolbar {
	margin-top: 10px;
}
</style>
</html>