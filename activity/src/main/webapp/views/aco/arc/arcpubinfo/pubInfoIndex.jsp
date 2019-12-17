<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>档案查询管理</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/need/laydate.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/skins/default/laydate.css" rel="stylesheet">

<script type="text/javascript" src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<%-- <link rel="stylesheet" type="text/css" href="${ctx}/views/aco/docmgt/css/zTreeRightClick.css" />
<script src="${ctx}/views/aco/docmgt/js/zTreeRightClick.js"></script> --%>
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>
<script src="${ctx}/views/aco/arc/arcpubinfo/js/pubInfoIndex.js"></script>	
<script src="${ctx}/views/aco/dispatch/js/deptData.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>				   
<script type="text/javascript">
function tableRefresh(){
	window.location.reload();
}
$(document).ready(function() {
	$("#arcName").focus();
	$('#folderContent').bootstrapTable({
		url : '${ctx}/arcPubInfo/arcPubInfoListPage',
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
				arcName:$.trim(arcName),
				arcType: $("#arcType").val(),
				fileUser:$("#gdUserId_").val(),
				fileDept:$("#gdDeptId_").val(),
				fileStartTime:$("#fileStartTime").val(),
				fileEndTime:$("#fileEndTime").val(),
				modCode:$("#modCode").val(),
				sortName:this.sortName,
				sortOrder:this.sortOrder
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
 		    { field : 'Number', title: '序号',
 				align : 'center',
 				valign : 'middle',
 				width: '5%',
 		    	formatter: function (value, row, index) {
                    return index+1;
                }
 		    }, 
 		    { field : 'arc_name', title : '文件标题',
 				valign : 'middle',
 				width: '30%',
 		    	sortable : true ,		   
/*  		    	events: onTdClickTab,
 */ 	 		    formatter: onTdClickTabFormatter}, 
 		    { field : 'file_user', title : '归档人员',sortable : true},
		    { field : 'file_dept', title : '归档部门',sortable : true},
		    { field : 'type_name', title : '档案类型',sortable : true}, 		 
 		    { field : 'file_time', title : '归档日期',sortable : true,
 				align : 'center',
	 			formatter:function(value,row){
	 				if(row.file_time!=null){
						return new Date(parseInt(row.file_time)).Format('yyyy-MM-dd');
	 				}else{
	 					return '--';
	 				}
			}}
		] ],
		onClickRow: function (row, tr) {
			arcTypeView(row);	
		}/* ,
		onDblClickRow :	function(row){
			arcTypeView(row);		
		} */	
	});
	$("#btn_reseta").click(function(){
		$('#advSearchModal').modal('hide');
		setDefaultSelect('arcType','ALL');
		$("#arcName").val("");
		/* $("#fileUser").val(""); */
		$("#fileStartTime").val("");
		$("#fileEndTime").val("");
		$("#gdUserId_").val("");
		$("#gdDeptId_").val("");
		$("#gdUserIdName_").val("");
		$("#gdDeptIdName_").val("");
		search();
	})

});
function search() {
	 $('#advSearchModal').modal('hide');
	 $("#input-word").val("");
	$("#folderContent").bootstrapTable('refresh');
}
function validateData() {
	var fileStartTime=$("#fileStartTime").val();
	var fileEndTime=$("#fileEndTime").val();
	if(fileStartTime!=""&&fileEndTime!=""){
		if(fileStartTime > fileEndTime){
			layerAlert("归档开始日期不能大于归档结束日期");
			return;
		}
	}
}
//查询正文和附件信息
function findMediaInfo(){
	var obj = $('#folderContent').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
		layerAlert("请选择一条数据");
		return false;
	}else{
		var docInfoId = obj[0].id;
		$('#myModal').modal('show');
		$('#media').attr("src","${ctx}/docmgt/toLoadMediaList?docInfoId="+docInfoId);
	}
}
//弹出选择办理人窗口
function choseUser(chooseUserUrl) { 
	$("#chooseUser_iframe").attr("src",chooseUserUrl);
 	$("#chooseUserDiv").modal('show');
}
//选人确定按钮
function makesure() {
	var arr = document.getElementById("chooseUser_iframe").contentWindow
			.doSaveSelectUser();
	var userName = arr[1];
	var userId = arr[0];
	$('#chooseUserDiv').modal('hide');
	for(var i=0;i<folderIds.length;i++){
		releaseFileStart(userId,folderIds[i]);
	}
	layer.msg("共享成功");
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
} */
</script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<style type="text/css">
.treeDiv {
	height: 152px;
	overflow-x: hidden;
	overflow: auto;
	text-align: center;
	display: none;
	position: absolute;
	margin-top: -50px;
	margin-left: -653px;
	background-image: url('${ctx}/views/aco/dispatch/img/treeImg.png');
	background-color: black;
	z-index: 1;
}
.treeDiv2 {
	height: 152px;
	overflow-x: hidden;
	overflow: auto;
	text-align: center;
	display: none;
	position: absolute;
	margin-top: -95px;
	margin-left: -175px;
	background-image: url('${ctx}/views/aco/dispatch/img/treeImg.png');
	background-color: black;
	z-index: 1;
}
.form-control2 {
	border: 1px solid #ccc;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
  		<body style="padding-left: 10px;padding-right: 10px">
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
<%-- 			<div id="" style="border:1px solid #ddd; background:#fff; padding:10px; padding-right:10%; margin-top: 10px" >
			<form class="form-horizontal" id="search_form"">
						<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">文件标题:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="arcName"
							name="arcName" placeholder="请输入文件标题">
					</div>
				<label
					class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档人员:</label>
				<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
					<div id="treeDiv_gdUserId_" class="treeDiv" style="display:none;">
					<div id="treeDemo_gdUserId_" class="ztree"
						style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
						<ul id="groupTree_gdUserId_" class="ztree"
							style="margin-top: 10px;"></ul>
					</div>
				</div> 
				  <input id="gdUserId_" class="form-control" name="gdUserId_" type="hidden" style="width: 100%; height: 29;" value="" />
				  <input id="gdUserIdName_" class="validate[required] form-control2 select input-sm" name="gdUserIdName_" type="text" 
					style="width: 100%; height: 29;margin-left: 0px;" readOnly="true"
					onclick="peopleTree(1,'gdUserId_');" value="" /> 
					</div>
				</div>
				
			<div class="form-group">
	          <label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档部门:</label>
			<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
				<div id="treeDiv_gdDeptId_" class="treeDiv2" style="display:none;">
					<div id="treeDemo_gdDeptId_" class="ztree"
						style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
						<ul id="groupTree_gdDeptId_" class="ztree"
							style="margin-top: 10px;"></ul>
					</div>
				</div> 
				  <input id=modCode class="form-control" name="modCode" type="hidden" value="${modCode}" />
				  <input id="gdDeptId_" class="form-control" name="gdDeptId_" type="hidden" style="width: 100%; height: 29;" value="" />
				  <input id="gdDeptIdName_" class="validate[required] form-control2 select input-sm" name="gdDeptIdName_" type="text" 
					style="width: 100%; height: 29;margin-left: 0px;" readOnly="true"
					onclick="peopleTree(2,'gdDeptId_');" value="" /> 
			</div>
				<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">档案类型:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<select class="selectpicker select validate[required]" style="color: #000;width: 100%;height: 29px" id="arcType"
							name="arcType" value="" myvalue="" title="请选择" >
							<option value="ALL" >全部</option>
							<c:forEach items="${arcType }" var="item">
								<option value="${item.getId()}" >${item.getTypeName()}</option>
							</c:forEach>
						</select>					
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档日期:</label>
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
					<button type="button" id="btn_reseta" class="btn btn-default">重置</button>
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
						<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">文件标题:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="arcName"
							name="arcName" placeholder="请输入文件标题">
					</div>
				<label
					class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档人员:</label>
				<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
					<div id="treeDiv_gdUserId_" class="treeDiv" style="display:none;">
					<div id="treeDemo_gdUserId_" class="ztree"
						style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
						<ul id="groupTree_gdUserId_" class="ztree"
							style="margin-top: 10px;"></ul>
					</div>
				</div> 
				  <input id="gdUserId_" class="form-control" name="gdUserId_" type="hidden" style="width: 100%; height: 29;" value="" />
				  <input id="gdUserIdName_" class="validate[required] form-control2 select input-sm" name="gdUserIdName_" type="text" 
					style="width: 100%; height: 29;margin-left: 0px;" readOnly="true"
					onclick="peopleTree(1,'gdUserId_');" value="" /> 
					</div>
				</div>
				
			<div class="form-group">
	          <label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档部门:</label>
			<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
				<div id="treeDiv_gdDeptId_" class="treeDiv2" style="display:none;">
					<div id="treeDemo_gdDeptId_" class="ztree"
						style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
						<ul id="groupTree_gdDeptId_" class="ztree"
							style="margin-top: 10px;"></ul>
					</div>
				</div> 
				  <input id=modCode class="form-control" name="modCode" type="hidden" value="${modCode}" />
				  <input id="gdDeptId_" class="form-control" name="gdDeptId_" type="hidden" style="width: 100%; height: 29;" value="" />
				  <input id="gdDeptIdName_" class="validate[required] form-control2 select input-sm" name="gdDeptIdName_" type="text" 
					style="width: 100%; height: 29;margin-left: 0px;" readOnly="true"
					onclick="peopleTree(2,'gdDeptId_');" value="" /> 
			</div>
				<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">档案类型:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<select class="selectpicker select validate[required]" style="color: #000;width: 100%;height: 29px" id="arcType"
							name="arcType" value="" myvalue="" title="请选择" >
							<option value="ALL" >全部</option>
							<c:forEach items="${arcType }" var="item">
								<option value="${item.getId()}" >${item.getTypeName()}</option>
							</c:forEach>
						</select>					
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档日期:</label>
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
					<button type="button" id="btn_reseta" class="btn btn-primary btn-sm" >重置</button>
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