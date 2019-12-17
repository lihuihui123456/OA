<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>待办事项</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" >
<script src="${ctx}/views/cap/bpm/bpmquery/js/tasklist-knot.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="panel-body" style="padding-top:0px;padding-bottom:0px;border:0;">
		<!-- 搜索框 -->
		<div style="padding: 5px 0px;width: 300px;float: right;">
			<div class="input-group">
				<input type="text" id="input-word" class="validate[required] form-control input-sm" value="请输入标题查询" 
					onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
				</span>
			</div>
		</div>
		
		<!-- table工具栏 -->
		<div style="padding: 5px 0px;">
			<button id="zyxw_btn_over" type="button" class="btn btn-default btn-sm">
				<span class="fa  fa-edit" aria-hidden="true"></span>办理
			</button>
			<button id="fordetails" type="button" class="btn btn-default btn-sm"> 
				<span class="fa fa-list" aria-hidden="true"></span>办理详情
			</button>
		</div>
		<table  id="tb_departments" data-toggle="table" date-striped="true" data-click-to-select="true" ></table>
	</div>
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
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
		var options='';
		if(doc_type==null||doc_type==""||doc_type.substring(0,6)=='sfw_fw'||doc_type.substring(0,6)=='sfw_sw'){
		   options = {
			        "text" : "办理",
					"id" : "update"+ taskId,
					//"href" : "bpmRuBizInfoController/deal?bizId=" + bizId +'&taskId=' + taskId,
					"href" : "bpmRunController/deal?bizId=" + bizId +'&taskId=' + taskId,
					"pid" : window
				};
		}
		else if(doc_type=='阅件'){
			 options={
					"text":"查看-传阅事项",
					"id":"cysx_view_"+id,
					"href":"bpmCirculate/findCirculate?bizid="+bizId+"&id="+id,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
		}else if(doc_type=='传阅件'){
			options={
					"text":"文件传阅-查看",
					"id":"wjjs_view_"+id,
					"href":"circularize/queryBasicById_js?id="+id+"&type=open",
					"pid": window
			};
		}
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
			if(doc_type==null || doc_type=="" ||doc_type.substring(0,6)=='sfw_fw'||doc_type.substring(0,6)=='sfw_sw'||doc_type=='阅件'){
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
			}else{
				layerAlert("请选择公文或阅件！");
			}
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