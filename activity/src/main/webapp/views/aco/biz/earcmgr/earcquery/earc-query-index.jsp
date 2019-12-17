<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<html>
<head>
<title>电子档案-档案总库查询</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/views/aco/docmgt/css/zTreeRightClick.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link rel="stylesheet" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css">
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.exedit-3.5.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.js"></script>
<script src="${ctx}/views/aco/arc/arcdoc/js/zTreeRightClick.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/views/aco/biz/earcmgr/earcquery/js/earc-query-index.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
var solId = "${solId}";
$(function() {
	$("#btn_seddRead").click(function(){
		var selects = $("#queryList").bootstrapTable('getSelections');  
		if(selects.length==0){
			layerAlert("请选择要调阅的档案信息！");
			return;
		}else{
			for(var i = 0;i < selects.length;i++){
				 $.ajax({
					type : "POST",
					url : "earcQueryController/doSaveBizRuNestInfo",
					data:{
						"bizid_attach":selects[i].ID_,
						"attach_title":selects[i].BIZ_TITLE_
					},
					success : function(data) {
						if(data!= null && data!=""){ 
							var res = doSaveBpmRuBizInfo(data,solId);
							if(res!="N"){
								var operateUrl = "bizRunController/getBizOperate?solId="+solId+"&bizId="+data  + "&status=2";
								var options = {
									"text" : "档案调阅",
									"id" : "view"+data,
									"href" : operateUrl,
									"pid" : window.parent,
									"isDelete":true,
									"isReturn":true,
									"isRefresh":true
								};
								window.parent.parent.createTab(options);
							}
					 	}else{
							layerAlert("失败！");
						}
					}
				});
			}
		}
	});
	
});

function doSaveBpmRuBizInfo(bizId,solId,tableName) {
	var params = {
		'bizId' : bizId,
		'solId' : solId,
		'tableName' : "",
		'procdefId' : "",
		'title' : "",
		'urgency' : "",
		'sfwType' : ""
	};
	var flag = "N";
	$.ajax({
		url : "bpmRuBizInfoController/doSaveBpmRuBizInfoEntity",
		type : "POST",
		dataType : "text",
		data : params,
		async : false,
		success : function(data) {
			flag = data;
		}
	});
	return flag;
}
/**
* 导出按钮事件
*/
function expExcel(){
	var title = $("#input-word").val();
	if(title == '请输入目录名称查询'){
		title="";
	}
	//判断是否有选中
	var selectIds;
	var obj = $('#queryList').bootstrapTable('getSelections');
	if (obj.length!=''||obj.length>=1) {
		selectIds=obj[0].ID_;
		for(i=1;i<obj.length;i++){
			selectIds=selectIds+","+obj[i].ID_;
		}
	}else{
		selectIds='';
	}
	window.location.href = "${ctx}/earcQueryController/exportExcel?selectIds="+selectIds+"&ctlgId="+ctlgId+"&title="+title+"&"+$("#ff").serialize();
 }
</script>
<style type="text/css">
.sidebar {
	position: fixed;
	z-index: 11;
	top: 10px;
	width: 200px;
	background-color: #fff;
	border: 1px solid #ddd;
	padding-bottom: 10px;
}

.sidebar .sidebar-menu {
	width: 200px;
}

.main {
	padding: 0;
	padding-left: 200px;
}

#search-div {
	width: 300px;
	float: right;
}
</style>
</head>
<body style="background:#f2f4f8;">
	<div class="container-fluid content">
		<div class="sidebar ">
			<div class="sidebar-collapse" style="height:100%">
				<div id="sidebar-menu" class="sidebar-menu"
					style="height:100%;overflow:auto;">
					<ul id="queryTree" class="ztree"></ul>
				</div>
			</div>
		</div>
	</div>
	<div id="listResult" class="main">
		<div class="panel-body">
			<!-- 搜索框 -->
			<div class="input-group"  id="search-div">
				<input type="text" id="input-word"
					class="validate[required] form-control input-sm" value="请输入目录名称查询"
					onFocus="if (value =='请输入目录名称查询'){value=''}"
					onBlur="if (value ==''){value='请输入目录名称查询'}"> <span
					class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()"><i class="fa fa-search"></i> 查询</button>
					<button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px;" onclick="showSearchDiv()"><i class="fa fa-search-plus"></i> 高级</button>
				</span>
			</div>
			<!-- table工具栏 -->
			<div class="btn-group" id="toolbar">
				<button id="btn_export" type="button" class="btn btn-default btn-sm" onclick="expExcel();"  >
					<span class="fa fa-cloud-download" aria-hidden="true"></span> 导出Excel
				</button>
				<button id="btn_seddRead" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-plus" aria-hidden="true"></span> 调阅
				</button>
			</div>
		</div>
		<!-- 模态框（Modal） -->
		<div id="advSearchModal" class="search-high-grade" style="display: none; margin-top: 5px;">
			<form id="ff" enctype="multipart/form-data" class="form-horizontal "
				target="_top" method="post" action="">
				<div class="form-group" id="dialog-message">
					<label class="col-sm-1 control-label" style="text-align: left;">标题</label>
					<div class="col-sm-3">
						<input id="BIZ_TITLE_" name="BIZ_TITLE_" type="text" class="form-control" >
					</div>
					<label class="col-sm-1 control-label" style="">责任人</label>
					<div class="col-sm-3">
						<input id="draftUserId_" class="form-control select" name="CREATE_USER_ID_"
									type="hidden" style="width: 100%; height: 29; border: 0;" />
						<input id="draftUserIdName_" class="form-control select" name="draftUserIdName_"
									type="text" onclick="peopleTree(1,'draftUserId_')"; />
					</div>
					<label class="col-sm-1 control-label" style="text-align: left;padding-left: 32px">类型</label>
					<div class="col-sm-3">
						<input id="EARC_TYPE" name="EARC_TYPE" type="text" class="form-control" placeholder="请输入档案类型">
					</div>
				</div>
				<div class="form-group" id="dialog-message">
					<label class="col-sm-1 control-label" style="text-align: left;">密级</label>
					<div class="col-sm-3">
						<select  id="SECURITY_LEVEL" name="SECURITY_LEVEL" class="form-control" size="1" >
							<option value="">请选择</option>
							<option value="1">低</option>
		    				<option value="2">中</option>
		    				<option value="3">高</option>
						</select>
					</div>
					<label class="col-sm-1 control-label" style="text-align: left;padding-left: 32px">状态</label>
					<div class="col-sm-3">
						<select  id="EARC_STATE" name="EARC_STATE" class="form-control" size="1" >
							<option value="">请选择</option>
							<option value="1">已归档</option>
		    				<option value="2">已作废</option>
		    				<option value="3">已销毁</option>
		    				<option value="4">已到期</option>
						</select>
						
					</div>
				</div>
				<div class="form-group" id="dialog-message">
					<label class="col-sm-1 control-label" style="text-align: left;">归档日期</label>
					<div class="col-sm-3">
						<!-- <div class="input-group date"> -->
							<input type="text" id="advStartDate"  name="advStartDate" class="form-control select"  onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
						<!-- </div> -->
					</div>
					<label class="col-sm-1 control-label" style="text-align: left;padding-left: 32px">到</label>
					<div class="col-sm-3">
						<!-- <div class="input-group date"> -->
							<input type="text" id="advEndDate" name="advEndDate" class="form-control select" onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
						<!-- </div> -->
					</div>
				</div>						
			</form>
			<div id="btnDiv" align="center" style="width:100%; margin-bottom: 10px">
				<button type="button" class="btn btn-primary btn-sm" id="advSearch">查询</button>
				<button type="button" class="btn btn-primary btn-sm"
					id="advSearchCalendar">重置</button>
				<button type="button" id="modal_close"
					class="btn btn-primary btn-sm" onclick="qxButton();">取消</button>
			</div>
		</div>
		<div class="modal fade" id="sedModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content">
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		                <h4 class="modal-title" id="myModalLabel">档案调阅</h4>
		            </div>
		            <div class="modal-body">
		            	<table id="sedTable" data-toggle="table" date-striped="true" data-click-to-select="true"></table>
		            </div>
		            <div id="btnDiv" align="center" style="width:100%; margin-bottom: 10px">
						<button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
						<button type="button" class="btn btn-primary btn-sm" id="modal_close" onclick="qxButton();">确定</button>
					</div>
		        </div>
		    </div>
		</div>
		<table id="queryList" data-toggle="table" date-striped="true"
			data-click-to-select="true"></table>
	</div>
<%@ include file="/views/aco/common/selectionPeople_tree.jsp"%>
</body>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>