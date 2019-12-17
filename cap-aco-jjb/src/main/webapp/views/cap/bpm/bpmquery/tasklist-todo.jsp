<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>待办事项</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" >
<script src="${ctx}/views/cap/bpm/bpmquery/js/tasklist-todo.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<style type="text/css">
.btn-div{
	padding: 5px 0px;
}
#search-div{
	height:40px;
}
</style>
<body>
	<div class="panel-body" style="padding-top:0;padding-bottom:0px;border:0;">
		<!-- 搜索框 -->
		<div class="btn-div" id="search-div">
			<div class="input-group" style="float:right;width:300px;">
				<input type="text" id="input-word" class="validate[required] form-control input-sm" value="请输入标题查询" 
					onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px; margin-right: 0px;" onclick="showOrHide();">
						<i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
			<div>
<!-- 			<button id="btn_circulation" type="button"  class="btn btn-default btn-sm" >
		          <span class="fa fa-file-text" aria-hidden="true"></span> 传阅
	        </button>  -->
		     <button id="zyxw_btn_trace" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-flag" aria-hidden="true"></span>跟踪事项
			</button>
			<button id="btn_attend" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-heart" aria-hidden="true"></span>关注事项
			</button>
		</div>
		</div>
		
			<!-- 模态框（Modal） -->
	<div id="advSearchModal" class="search-high-grade" style="display: none;">
					<form id="ff" enctype="multipart/form-data" class="form-horizontal "
						target="_top" method="post" action="">
						<div class="form-group" id="dialog-message">
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">标题</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<input id="advTitle" name="advTitle" type="text" class="form-control input-sm" >
							</div>
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">紧急程度</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<select  id="advLevel" name="advLevel" class="form-control input-sm" size="1" >
									<option value="">请选择</option>
									<option value="1">平件</option>
									<option value="2">急件</option>
									<option value="3">特急</option>
								</select>
							</div>
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">类型</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<select  id="advType" name="advType" class="form-control input-sm" size="1" >
						           <option value=" ">全部</option>
								</select>
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">送交时间</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<!-- <div class="input-group date"> -->
									<input type="text" id="advSendStartTime"  name="sendStartTime" class="form-control input-sm select"  onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: true,istime: true,})"/>
								<!-- </div> -->
							</div>
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">到</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<!-- <div class="input-group date"> -->
									<input type="text" id="advSendEndTime" name="sendEndTime" class="form-control input-sm select" onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: true,istime: true,})"/>
								<!-- </div> -->
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">拟稿日期</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<!-- <div class="input-group date"> -->
									<input type="text" id="advStartDate"  name="advStartDate" class="form-control input-sm select"  onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
								<!-- </div> -->
							</div>
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">到</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<!-- <div class="input-group date"> -->
									<input type="text" id="advEndDate" name="advEndDate" class="form-control input-sm select" onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
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
		
		<!-- table工具栏 -->
		<!-- <div class="btn-div">
			<button id="zyxw_btn_over" type="button" class="btn btn-default btn-sm">
				<span class="fa  fa-edit" aria-hidden="true"></span>办理
			</button>
			<button id="fordetails" type="button" class="btn btn-default btn-sm"> 
				<span class="fa fa-list" aria-hidden="true"></span>办理详情
			</button>
		</div>  -->
		
		<table  id="tb_departments" data-toggle="table" date-striped="true" data-click-to-select="true" ></table>
	</div>
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>

	<!-- 办理时传阅选人界面弹出模态框 -->
	<div class="modal fade" id="circulationDiv" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
	  <div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="gridSystemModalLabel">人员选择</h4>
	      </div> 
	      <div class="modal-body" style="text-align: center;">
	      	<iframe id="circulation_iframe" src=""  width="100%" height="450" frameborder="no" border="0" marginwidth="0"
				marginheight="0" scrolling="yes" style=""></iframe>
	      </div>
	      <div class="modal-footer" style="text-align: center;margin-top:0;">
	        <button type="button" class="btn btn-primary" onclick="circulation('${bizId}')">确认</button>
	        <button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->	


</body>
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

var ButtonInit = function() {
	var oInit = new Object();
	var postdata = {};
	oInit.Init = function() {
		//传阅按钮事件
		$("#btn_circulation").click(function() {
			var obj = $("#tb_departments").bootstrapTable('getSelections');
			if (obj.length != 1) {
				layerAlert("请选择一条数据");
				return false;
			}
			if(obj[0].BIZ_TYPE_=='传阅件'){
				layerAlert("传阅件无法传阅!");
				return false;
			}
			$("#circulation_iframe").attr("src","treeController/zMultiPurposeContacts?state=1");
			$("#circulationDiv").modal('show');
		});
		//跟踪事项
		$("#zyxw_btn_trace").click(function() {
			getselectoption();
			var obj = $('#tb_departments').bootstrapTable('getSelections');
			if (obj.length != 1) {
				layerAlert("请选择一条数据");
				return false;
			}else{
				for(var i=0;i<obj.length;i++){
					if(obj[i].state_=='2'){
						layerAlert("有信息办理完结,无法进行跟踪");
						return false;
					}
				}
			}
			if(obj[0].BIZ_TYPE_=='传阅件'){
				layerAlert("传阅件无法跟踪!");
				return false;
			}
			var pids = "";
			for (var i = 0; i < obj.length; i++) {
				if (pids.length > 0) {
					pids += ("," + obj[i].proc_inst_id_);
				} else {
					pids += obj[i].proc_inst_id_;
				}
			}
			$.ajax({
				type : "POST",
				url : "${ctx}/bpmTrace/doSaveTrace",
				data : {
					pids : pids
				},
				success : function(msg) {
					if (!!msg) {
						if ('true' == $.trim(msg)) {
							layerAlert("已加入跟踪事项.");
						} else {
							layerAlert("操作失败！");
						}
					}else {
						layerAlert("操作异常！");
					}
				}
			});
			
		});
		//关注事项
		$("#btn_attend").click(function(){
			var obj = $('#tb_departments').bootstrapTable('getSelections');
			var bizIds="";
			if (obj.length != 1) {
				layerAlert("请选择一条数据");
				return false;
			}else{
				if(obj[0].BIZ_TYPE_=='传阅件'){
					layerAlert("传阅件无法关注!");
					return false;
				}
				for(var i=0;i<obj.length;i++){
					if(i==0){
						bizIds+=obj[i].bizid;
					}else{
						bizIds+=","+obj[i].bizid;
					}
				}
			
			}
			$.ajax({
				type: "POST",
				async: false,
				url: "bpmAttend/doSaveAttend",
				data: {bizIds:bizIds},
				success: function (datas) {
					if(datas=="success"){
						layerAlert("已添加关注!");
					}else{
						layerAlert("关注失败!");
					}
				}
			});
		});
		// 初始化页面上面的按钮事件
		$("#zyxw_btn_over").click(function() {
			var selectRow = $("#tb_departments").bootstrapTable('getSelections');
			if (selectRow.length != 1) {
				layerAlert("请选择一条数据！");
				return;
			}else{
				var taskId = selectRow[0].id_;
				var bizId = selectRow[0].bizid;
				var solId=selectRow[0].solId;
				var procInstId=selectRow[0].proc_inst_id_;
				var doc_type=selectRow[0].doc_type;
				var bid = '';
				var id=selectRow[0].id_;
				var options='';
	            if(doc_type=='阅件'){
					 options={
							"text":"查看-传阅事项",
							"id":"cysx_view_"+id,
							"href":"bpmCirculate/findCirculate?bizid="+bizId+"&&id="+id,
							"pid":window,
							"isDelete":true,
							"isReturn":true,
							"isRefresh":true
					};
				}else {
					 /*  options = {
						    "text" : "办理",
							"id" : "update"+ taskId,
							"href" : "bpmRunController/deal?bizId=" + bizId +'&taskId=' + taskId,
							"pid" : window,
							"isDelete":true,
							"isReturn":true,
							"isRefresh":true
					}; */
					var operateUrl = "${ctx}/bizRunController/getBizOperate?status=3&solId="+solId + "&taskId=" + taskId + "&bizId=" + bizId;
					date = new Date().getTime();
					var options = {
						"text" : btnName,
						"id" : date,
						"href" : operateUrl,
						"pid" : window,
						"isDelete":true,
						"isReturn":true,
						"isRefresh": true
					};
				}
				window.parent.createTab(options);
			}
		});
	
	//查看单位的办理详情
	$("#fordetails").click(function(){
		var selectRow = $("#tb_departments").bootstrapTable('getSelections');
		if(selectRow.length != 1){
			layerAlert("请选择一条数据");
		}else{
			var doc_type=selectRow[0].doc_type;
			var bizid=getselectoption();
			var procInstId=getSelectProId();
				var options={
					"text":"办理详情",
					"id":"bizinfodetail"+bizid,
					"href":"${ctx}/bpmRuBizInfoController/toDealDetialPage?procInstId="+procInstId,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
				};
				window.parent.createTab(options);
		}
	});
};
	return oInit;
};
function getselectoption(){
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
		return "";
	}else{
		return obj[0].bizid;
	}
}

function getSelectProId(){
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
		return "";
	}else{
		return obj[0].proc_inst_id_;
	}
}
//传阅确定按钮
function circulation() {
	var selectRow = $("#tb_departments").bootstrapTable('getSelections');
  var bizId=selectRow[0].bizid
	var users = document.getElementById("circulation_iframe").contentWindow.doSaveSelectUser();
	var viewUserIds = users[0];
	$.ajax({
		type: 'post',  
      url: 'bpmRuBizInfoController/doSaveBizGwCircularsEntitys',
      dataType: 'json',
      data: {
      	'bizId' : bizId,
      	'viewUserIds' : viewUserIds
      },
      success: function(data) {
      	if(data){
	        	layerAlert("传阅成功！");
	        	$('#circulationDiv').modal('hide');
      	}else {
	        	layerAlert("传阅失败！");
      	}
      }
	});
}
</script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>