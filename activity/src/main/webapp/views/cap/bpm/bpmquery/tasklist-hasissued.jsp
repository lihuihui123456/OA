<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>已发事项</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script src="${ctx}/views/cap/bpm/bpmquery/js/tasklist-hasissued.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="panel-body" style="padding-top:0;padding-bottom:0px;border:0;">
		<!-- 搜索框 -->
		<div style="padding: 5px 0px;width: 300px;float: right;">
			<div class="input-group">
				<input type="text" id="input-word" class="validate[required] form-control input-sm" value="请输入标题查询" 
					onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px;margin-right: 0px;" onclick="showOrHide();">
						<i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
		</div>
		
		<!-- table工具栏 -->
		<div style="padding: 5px 0px;">
			<!-- <button id="zyxw_btn_over" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-eye" aria-hidden="true"></span>查看
			</button>
			<button id="fordetails" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-list" aria-hidden="true"></span>办理详情</button> -->
					<button id="btn_delete" type="button" class="btn btn-default btn-sm">
		<span class="fa fa-remove" aria-hidden="true"></span>删除
	</button>
						<!-- 	<button id="btn_circulation" type="button"  class="btn btn-default btn-sm" >
		            <span class="fa fa-file-text" aria-hidden="true"></span> 传阅
	                </button>  -->
			<button id="zyxw_btn_recall" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-reply" aria-hidden="true"></span>撤回
			</button>

			<button id="zyxw_btn_trace" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-flag" aria-hidden="true"></span>跟踪事项
			</button>
			<button id="btn_attend" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-heart" aria-hidden="true"></span>关注事项
			</button>
		
		</div>
		
		<!-- 模态框（Modal） -->
	<div id="upperSearch" class="search-high-grade" style="display: none;">
				<form id="ff" enctype="multipart/form-data" class="form-horizontal "
					target="_top" method="post" action="">
					<div class="form-group" id="dialog-message">
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">标题</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
							<input id="BIZ_TITLE_" name="BIZ_TITLE_" type="text" class="form-control input-sm" >
						</div>
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">紧急程度</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
							<select  id="URGENCY_" name="URGENCY_" class="form-control input-sm" size="1" >
								<option value="">请选择</option>
								<option value="1">平件</option>
								<option value="2">急件</option>
								<option value="3">特急</option>
							</select>
						</div>
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">办理状态</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
							<select  id="STATE_" name="STATE_" class="validate[required] form-control input-sm" size="1" >
				    				<option value="">请选择</option>
				    				<option value="1">在办</option>
				    				<option value="2">办结</option>
							</select>
						</div>
					</div>
					<div class="form-group" id="dialog-message">
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">拟稿日期</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
							<input type="text" id="CREATE_TIME_START_"  name="CREATE_TIME_START_" class="form-control input-sm"  onclick="laydate({format: 'YYYY-MM-DD',isclear: false})"/>
						</div>
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">到</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
							<input type="text" id="CREATE_TIME_END_" name="CREATE_TIME_END_" class="form-control input-sm" onclick="laydate({format: 'YYYY-MM-DD',isclear: false})"/>
						</div>
					</div>
					<div class="form-group" id="dialog-message">
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label" >结束时间</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
							<input type="text" id="END_TIME_START_"  name="END_TIME_START_" class="form-control input-sm"  onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: false})"/>
						</div>
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">到</label>
						<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
							<input type="text" id="END_TIME_END_" name="END_TIME_END_" class="form-control input-sm" onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: false})"/>
						</div>
					</div>					
				</form>
				<div class="" id="btnDiv" align="center" style="width:100%; margin-bottom: 10px">
					<button type="button" class="btn btn-primary btn-sm" id="advSearch"
						onclick="submitForm()">查询</button>
					<button type="button" class="btn btn-primary btn-sm" id="advReset"
						onclick="clearForm()">重置</button>
					<button type="button" id="modal_close" class="btn btn-primary btn-sm" onclick="qxButton();">取消</button>
				</div>
	</div>
		
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
		// 删除按钮
		$("#btn_delete").click(function() {
			var selectRow = $("#tb_departments").bootstrapTable('getSelections');
			if (selectRow.length == 0) {
				layerAlert("请选择操作项！");
				return;
			}
			var bizIds = [];
			var flag = true;
			$(selectRow).each(function(index) {
				bizIds[index] = selectRow[index].bizid;
			});
			if(flag){
				layer.confirm('确定删除吗？', {
					btn : [ '是', '否' ]
					// 按钮
					}, function(index) {
						$.ajax({
							url : 'bpmRuBizInfoController/doDeleteBpmRuBizInfoEntitysByBizIds',
							dataType : 'text',
							data : {
								'bizIds' : bizIds
							},
							success : function(data) {
								if (data == 'Y') {
									layerAlert("删除成功！");
									//$("#bizInfoList").bootstrapTable('refresh');
									refreshTable('tb_departments','bpmQuery/findHasIssuedList')
								} else {
									layerAlert("删除失败！");
								}
							}
						});
						layer.close(index);
					}, function() {
						return;
				});
			}else{
				layerAlert("只能删除未发的记录！");
			}
		});
		$("#btn_attend").click(function(){
			var obj = $('#tb_departments').bootstrapTable('getSelections');
			var bizIds="";
			if (obj.length == '' || obj.length < 1) {
				layerAlert("请选择一条数据");
				return false;
			}else{
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
		//传阅按钮事件
		$("#btn_circulation").click(function() {
			var obj = $("#tb_departments").bootstrapTable('getSelections');
			if (obj.length != 1) {
				layerAlert("请选择一条数据");
				return false;
			}
			$("#circulation_iframe").attr("src","treeController/zMultiPurposeContacts?state=1");
			$("#circulationDiv").modal('show');
		});
		//跟踪事项
		$("#zyxw_btn_trace").click(function() {
			getselectoption();
			var obj = $('#tb_departments').bootstrapTable('getSelections');
			if (obj.length == '' || obj.length < 1) {
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
		// 初始化页面上面的按钮事件
		$("#zyxw_btn_over").click(function(){
			var obj =$('#tb_departments').bootstrapTable('getSelections');
			if (obj.length>1||obj.length=='') {
				layerAlert("请选择一条数据");
				return false;
			}else{
				var taskid = obj[0].id_;
				var bizid=obj[0].bizid;
				var timestamp=new Date().getTime();
				var options={
						"text":"查看-已发事项",
						"id":"bizinfoview"+bizid+timestamp,
						//"href":"bpmRuBizInfoController/view?bizId="+ bizid+"&&taskId="+taskid,
						"href":"bpmRunController/view?bizId="+ bizid+"&&taskId="+taskid,
						"pid":window,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":true
				};
				window.parent.createTab(options);
			}
		})
		//查看单位的办理详情
		$("#fordetails").click(function(){
			var bizid=getselectoption();
			var procInstId=getSelectProcInst();
			if(bizid==""){
				layerAlert("请选择一条数据");
			}else{
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
		})
		//撤回按钮操作
		$("#zyxw_btn_recall").click(function() {
			var obj =$("#tb_departments").bootstrapTable("getSelections");
			var bizid=obj[0].bizid;
			if (obj.length != 1) {
				layerAlert("请选择一条数据");
				return false;
			}
			var taskId = obj[0].id_;
			var procInstId = obj[0].proc_inst_id_;
			$.ajax({
				url : "bpmRunController/processRecall",
				type : "post",
				dataType : "json",
				data : {
					"taskId" : taskId,
					"procInstId" : procInstId
				},
				success : function(data) {
					if(data) {
						layerAlert(data.msg);
						//撤销流程后需要恢复请假和调休的天数
						if(data.flag == 'success'){
						$.ajax({
							type: "post",
							url: "${ctx}/leaveManager/resetLeaveInfo",
							dataType: 'json',
							data: {'bizId':bizid},
							success: function (data) {}
						});
						}
					}
				}
			});
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

function getSelectProcInst(){
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