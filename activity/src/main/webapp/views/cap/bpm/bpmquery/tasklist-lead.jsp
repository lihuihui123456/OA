<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>领导委托列表</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" >
<script src="${ctx}/views/cap/bpm/bpmquery/js/tasklist-lead.js"></script>
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
	<div class="panel-body" style="padding-top:0px;padding-bottom:0px;border:0;">
	<!-- 搜索框 -->
		<div class="btn-div" id="search-div">
			<div class="input-group" style="float:right;width:300px;">
				<input type="text" id="input-word" class="validate[required] form-control input-sm" value="请输入标题查询" 
					onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px; margin-right: 0px;" onclick="advSearchModal();">
						<i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
		</div>
			<div id="searchDiv" class="search-high-grade" style="display:none;">
	<form id="ff" enctype="multipart/form-data" class="form-horizontal "
						target="_top" method="post" action="">
						<div class="form-group" id="dialog-message">
							<label class="col-sm-1 control-label" style="text-align: right;">标题</label>
							<div class="col-sm-3">
								<input id="advTitle" name="advTitle" type="text" class="form-control input-sm" >
							</div>
							<label class="col-sm-1 control-label" style="text-align: right;">紧急程度</label>
							<div class="col-sm-3">
								<select  id="advLevel" name="advLevel" class="form-control input-sm" size="1" >
									<option value="">请选择</option>
									<option value="1">平件</option>
									<option value="2">急件</option>
									<option value="3">特急</option>
								</select>
							</div>
							<label class="col-sm-1 control-label" style="text-align: right;padding-left: 32px">类型</label>
							<div class="col-sm-3">
								<select  id="advType" name="advType" class="form-control input-sm" size="1" >
														<option value="">请选择</option>
										<option value="10011002">收文</option>
										<option value="10011001">发文</option>
										<option value="10011004">合同</option>
										<option value="10011006">请假</option>
										<option value="10011003">项目建设</option>
					    <%-- 			<c:forEach var="item" items="${typeList}" varStatus="status">     
                                <option value="${item.code}">${item.SOL_CTLG_NAME_}</option>
                                </c:forEach> --%>
								</select>
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-1 control-label" style="text-align: right;">送交时间</label>
							<div class="col-sm-3">
								<!-- <div class="input-group date"> -->
									<input type="text" id="advSendStartTime"  name="sendStartTime" class="form-control select input-sm"  onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: true,istime: true,})"/>
								<!-- </div> -->
							</div>
							<label class="col-sm-1 control-label" style="text-align: right;padding-left: 32px">到</label>
							<div class="col-sm-3">
								<!-- <div class="input-group date"> -->
									<input type="text" id="advSendEndTime" name="sendEndTime" class="form-control select input-sm" onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: true,istime: true,})"/>
								<!-- </div> -->
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-1 control-label" style="text-align: right;">拟稿日期</label>
							<div class="col-sm-3">
								<!-- <div class="input-group date"> -->
									<input type="text" id="advStartDate"  name="advStartDate" class="form-control select input-sm"  onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
								<!-- </div> -->
							</div>
							<label class="col-sm-1 control-label" style="text-align: right;padding-left: 32px">到</label>
							<div class="col-sm-3">
								<!-- <div class="input-group date"> -->
									<input type="text" id="advEndDate" name="advEndDate" class="form-control select input-sm" onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
								<!-- </div> -->
							</div>
						</div>						
					</form>
					<div class="modal-footer" id="btnDiv" align="center">
					<button type="button" class="btn btn-primary btn-sm" id="advSearch">查询</button>
					<button type="button" class="btn btn-primary btn-sm"
						id="advSearchCalendar">重置</button>
					<button type="button" id="modal_close"
						class="btn btn-primary btn-sm" data-dismiss="modal">取消</button>
				</div>
	</div>
		<table  id="tb_departments" data-toggle="table" date-striped="true" data-click-to-select="true" ></table>
	</div>
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>

	<!-- 模态框（Modal） -->
	<!-- <div class="modal fade" id="advSearchModal" aria-hidden="true">
		<div class="modal-dialog" style="width: 600px;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >高级搜索</h4>
				</div>
				<div class="modal-body" style="margin-bottom: 1px;">
					<form id="ff" enctype="multipart/form-data" class="form-horizontal "
						target="_top" method="post" action="">
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">标题</label>
							<div class="col-md-10">
								<input id="advTitle" name="advTitle" type="text" class="form-control" >
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">紧急程度</label>
							<div class="col-sm-4">
								<select  id="advLevel" name="advLevel" class="form-control" size="1" >
									<option value="">请选择</option>
									<option value="1">平件</option>
									<option value="2">急件</option>
									<option value="3">特急</option>
								</select>
							</div>
							<label class="col-sm-2 control-label" style="text-align: left;padding-left: 32px">类型</label>
							<div class="col-sm-4">
								<select  id="advType" name="advType" class="form-control" size="1" >
										<option value="">请选择</option>
					    				<option value="0">公文</option>
					    				<option value="sfw_fw">发文</option>
					    				<option value="sfw_sw">收文</option>
								</select>
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">送交时间</label>
							<div class="col-sm-4">
								<div class="input-group date">
									<input type="text" id="advSendStartTime"  name="sendStartTime" class="form-control select"  onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: true,istime: true,})"/>
								</div>
							</div>
							<label class="col-sm-2 control-label" style="text-align: left;padding-left: 32px">到</label>
							<div class="col-sm-4">
								<div class="input-group date">
									<input type="text" id="advSendEndTime" name="sendEndTime" class="form-control select" onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: true,istime: true,})"/>
								</div>
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">拟稿日期</label>
							<div class="col-sm-4">
								<div class="input-group date">
									<input type="text" id="advStartDate"  name="advStartDate" class="form-control select"  onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
								</div>
							</div>
							<label class="col-sm-2 control-label" style="text-align: left;padding-left: 32px">到</label>
							<div class="col-sm-4">
								<div class="input-group date">
									<input type="text" id="advEndDate" name="advEndDate" class="form-control select" onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
								</div>
							</div>
						</div>						
					</form>
				</div>
				<div class="modal-footer" id="btnDiv" align="center">
					<button type="button" class="btn btn-primary btn-sm" id="advSearch">查询</button>
					<button type="button" class="btn btn-primary btn-sm"
						id="advSearchCalendar">重置</button>
					<button type="button" id="modal_close"
						class="btn btn-primary btn-sm" data-dismiss="modal">取消</button>
				</div>
			</div>			
		</div>
	</div> -->
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
		// 初始化页面上面的按钮事件
		$("#zyxw_btn_over").click(function() {
		var selectRow = $("#tb_departments").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择一条数据！");
			return;
		}
		var taskId = selectRow[0].id_;
		var bizId = selectRow[0].bizid;
		var solId=selectRow[0].solId;
		var procInstId=selectRow[0].proc_inst_id_;
		var doc_type=selectRow[0].doc_type;
		var id=selectRow[0].id_;
		var	options = {
				        "text" : "办理",
						"id" : "update"+ taskId,
						//"href" : "bpmRuBizInfoController/deal?bizId=" + bizId +'&taskId=' + taskId,
						"href" : "bpmRunController/deal?bizId=" + bizId +'&taskId=' + taskId,
						"pid" : window
					};
		window.parent.createTab(options);
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
			var taskId = selectRow[0].id_;
				var options={
						"text":"办理详情",
						"id":"bizinfodetail"+bizid,
						"href":"${ctx}/bpmRuBizInfoController/toDealDetialPage?procInstId="+procInstId+"&taskId="+taskId,
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
</script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>