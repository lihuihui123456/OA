<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>业务公共列表</title>

<%@ include file="/views/aco/common/head.jsp"%>
<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="padding:0 6px;">
	<!-- Nav tabs -->
	<ul class="nav nav-tabs" role="tablist" id="myTab">
			<li role="presentation" class="active">
			<a href="#swdj_div" role="tab" data-toggle="tab" id="xx_fw">登记</a></li>
	
		<li role="presentation" >
			<a href="#swdb_div" role="tab" data-toggle="tab" id="xx_sw">待办</a></li>
	</ul>

	<!-- Tab panes -->
	<div class="tab-content">
		<!-- 个人收文待办  start-->
		<div role="tabpanel" class="tab-pane " id="swdb_div">
			<div class="panel-body" id="swxx_body" style="padding-bottom: 0px; border: 0;">
				<!-- 收文待办搜索框  start-->
				<div style="padding: 5px 0px; width: 300px; float: right;">
					<div class="input-group">
						<input type="text" id="input-word-fw" class="validate[required] form-control input-sm" value="请输入标题查询"
							onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
						<span class="input-group-btn">
							<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search_db()">
								<i class="fa fa-search"></i> 查询
							</button>
							<button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px; margin-right: 0px;"
								onclick="showOrHideFw();">
								<i class="fa fa-search-plus"></i> 高级
							</button>
						</span>
					</div>
				</div>
				<!-- 收文待办搜索框  end-->
				<!-- 收文待办按钮栏  start-->
				<div style="padding: 5px 0;">
					<button id="btn_attend1" type="button" class="btn btn-default btn-sm">
						<span class="fa fa-heart" aria-hidden="true"></span>关注事项
					</button>
				</div>
				<!-- 收文待办按钮栏  end-->
				<!-- 收文待办高级搜索  start-->
				<div id="upperSearchFw" class="search-high-grade" style="display: none;">
					<form id="search_form_fw" class="form-horizontal " target="_top" method="post" action="" style="width: 90%;">
						<div class="form-group" id="dialog-message">
							<label class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label">标题</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<input id="advTitle" name="advTitle" type="text" class="form-control input-sm" >
							</div>
							<label class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label">紧急程度</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<select  id="advLevel" name="advLevel" class="form-control input-sm" size="1" >
									<option value="">请选择</option>
									<option value="1">一般</option>
									<option value="2">紧急</option>
									<option value="3">特急</option>
								</select>
							</div>
<%-- 							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">收文总号</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<input id="advSwzh" name="advSwzh" type="text" class="form-control input-sm" >
								<select  id="advSWZH" name="advSWZH" class="form-control input-sm" size="1" >
										<option value="">请选择</option>
					    		<c:forEach var="item" items="${typeList}" varStatus="status">     
                                <option value="${item.code}">${item.SOL_CTLG_NAME_}</option>
                                </c:forEach>
								</select>
							</div> --%>
						</div>
<!-- 						<div class="form-group" id="dialog-message">
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">送交时间</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<div class="input-group date">
									<input type="text" id="advSendStartTime"  name="sendStartTime" class="form-control input-sm select"  onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: true,istime: true,})"/>
								</div>
							</div>
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">到</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<div class="input-group date">
									<input type="text" id="advSendEndTime" name="sendEndTime" class="form-control input-sm select" onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: true,istime: true,})"/>
								</div>
							</div>
						</div> -->
						<div class="form-group" id="dialog-message">
							<label class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label">拟稿日期</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<!-- <div class="input-group date"> -->
									<input type="text" id="advStartDate"  name="advStartDate" class="form-control input-sm select"  onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
								<!-- </div> -->
							</div>
							<label class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label">到</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<!-- <div class="input-group date"> -->
									<input type="text" id="advEndDate" name="advEndDate" class="form-control input-sm select" onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
								<!-- </div> -->
							</div>
						</div>	
					</form>
					<div id="btnDiv" align="center" style="width: 100%; margin-bottom: 10px">
						<button type="button" class="btn btn-primary btn-sm" id="advSearchDB"
							onclick="submitFormsw()">查询</button>
						<button type="button" class="btn btn-primary btn-sm" id="advResetDB"
							onclick="clearFormsw()">重置</button>
						<button type="button" class="btn btn-primary btn-sm" id="modal_closeDB"
							onclick="qxButtonSw();">取消</button>
					</div>
				</div>
				<!-- 收文待办高级搜索  end-->
				<!-- 收文待办列表  end-->
				<form id="export" action="">
					<table id="tapList"></table>
				</form>
				<!-- 收文待办列表  end-->
			</div>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide mask_layer"></div>
				</div>
			</div>
		</div>
		<!-- 个人收文待办 end-->
		<!-- 个人收文登记 start -->
		<div role="tabpanel" class="tab-pane active" id="swdj_div">
			<div class="panel-body" id="fwxx_body" style="padding-bottom: 0px; border: 0;">
				<!-- 个人收文登记搜索框  satrt-->
	<!-- 搜索框 -->
	<div class="btn-div btn-group" id="search-div">
		<div class="input-group">
			<input type="text" id="input-word" class="validate[required] form-control input-sm" value="请输入标题查询" 
				onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
			<span class="input-group-btn">
				<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
					<i class="fa fa-search"></i> 查询
				</button>
				<button id="supperSearchBtn" type="button" class="btn btn-primary btn-sm" style="margin-right: 0px;margin-left: 2px">
					<i class="fa fa-search-plus"></i> 高级
				</button>
			</span>
		</div>
	</div>
	<!-- table工具栏 -->
	<div class="btn-div btn-group">
		<button id="btn_dobiz" type="button" class="btn btn-default btn-sm">
			<span id="doBizBtnName" class="fa fa-plus" aria-hidden="true">登记</span>
		</button>
		<button id="btn_delete" type="button" class="btn btn-default btn-sm">
			<span class="fa fa-remove" aria-hidden="true">删除</span>
		</button>
	</div>
	<!-- 模态框（Modal） -->
	<div id="upperSearch" class="search-high-grade" style="display: none;">
		<form id="search_form" enctype="multipart/form-data" class="form-horizontal "
			target="_top" method="post" action="" style="width: 100%;">
			<div class="form-group">
				<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">标题</label>
				<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
					<input class="form-control input-sm" type="text" id="bizTitle_"
						name="bizTitle_">
				</div>	
				<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">办理状态</label>
				<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
					<select id="STATE_" name="STATE_" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
						<option value="">全部</option>
						<option value="0">待发</option>
						<option value="1">在办</option>
						<option value="2">办结</option>
					</select>
				</div>				
			</div>
			<div class="form-group">
			<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">拟稿日期</label>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
					<input type="text" id="startTime" name="startTime" value="" 
						class="form-control select input-sm" style="width:45%; float:left"
						onclick="laydate({ format: 'YYYY-MM-DD '})" />
				 <span  style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
					<input type="text" id="endTime" name="endTime" value="" 
						class="form-control select input-sm" style="width:45%; float:left"
						onclick="laydate({ format: 'YYYY-MM-DD '})" />

				</div>
			</div>
		</form>
		<div class="" id="btnDiv" align="center" style="width:100%; margin-bottom: 10px">
			<button type="button" class="btn btn-primary btn-sm" id="advSearch" onclick="submitForm()">查询</button>
			<button type="button" class="btn btn-primary btn-sm" id="advReset" onclick="clearForm()">重置</button>
			<button type="button" id="modal_close" class="btn btn-primary btn-sm">取消</button>
		</div>
	</div>
	
	<!-- 数据列表 -->
	<table id="bizInfoList">
		<thead>
			<tr>
				<th data-align="center" data-valign="middle" data-width="40px" data-field="checkStatus" data-checkbox=true></th> 
				<th data-align="center" data-valign="middle" data-width="45px" data-field="index" data-formatter="indexFormatter">序号</th>
				<th data-field="procInstId_" data-visible=false></th>
				<!-- 
				<th data-align="left" data-valign="middle" data-width="20%" data-field="serialNumber_">收文流水号</th>
				 -->
				<th data-align="left" data-valign="middle" data-field="BIZ_TITLE_" data-formatter="onTdClickTabFormatter" data-sortable=true data-width="">标题</th>
			    <th data-align="left" data-valign="middle" data-field="xmmc"  data-sortable=true data-width="200px">项目名称</th>
				<th data-align="center" data-valign="middle" data-field="STATE_" data-width="100px" data-formatter="formatterState" data-cell-style="cellStyle" data-sortable=true>办理状态</th>
				<th data-align="center" data-valign="middle" data-field="CREATE_TIME_" data-width="140px" data-formatter="formatterTime" data-cell-style="cellStyle" data-sortable=true>拟稿时间</th>
				<!-- <th data-align="center" data-valign="middle" data-field="operate" data-width="100px" data-events="operateEvents" data-formatter="operateFormatter" >操作</th> -->
			</tr>
		</thead>
	</table>
		<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
	
	</div></div></div>
</body>
<script type="text/javascript">
	var solId = "${solId}";//业务解决方案id
	var modCode = "${modCode}";//权限code
	var mySwiper = new Swiper('.swiper-container',{
	    loop:true,
		onSlidePrev: function(swiper){
		$("#bizInfoList").bootstrapTable('prevPage');
		  },
		onSlideNext: function(swiper){
		$("#bizInfoList").bootstrapTable('nextPage');
		}
	});
</script>
<!-- 页面自己的 js -->
<script type="text/javascript" src="${ctx}/views/aco/biz/contractmgr/list/js/contract_list.js"></script>
<script type="text/javascript">
$(function() {
	$("#supperSearchBtn").click(function() {
		var display =$('#upperSearch').css('display');
		if(display == "none") {
			$("#upperSearch").show();
		}else {
			$("#upperSearch").hide();
		}
	})
	
	$("#modal_close").click(function(){
		$("#upperSearch").hide();	
	})
	
	$('#input-word').keydown(function(event){ 
		if(event.keyCode==13){ 
			search();
		} 
	}); 
	
	//登记
	$("#btn_dobiz").click(function() {
		var operateUrl = "${ctx}/bizRunController/getBizOperate?status=1&solId="+"${solId}";
		if(operateUrl!=null) {
			var btnName = $("#doBizBtnName").text();
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
			window.parent.createTab(options);
		}
	});
})
laydate.skin('dahong');

/**
 * 高级搜索模态框
 */
function upperSearch(){
	$('#upperSearch').modal({
		backdrop : 'static',
		keyboard : false
	});
}

//重置高级搜索表单
function clearForm(){
	document.getElementById("search_form").reset();
	$("#input-word").val("请输入标题查询");
	var query = $("#search_form").serialize();
	$("#bizInfoList").bootstrapTable('refresh',{
		url : "contractMgr/findBpmRuBizInfoBySolId",
		query:{
			"query" : query,
			"modCode":modCode,
		}
	});
	$("#upperSearch").modal('hide');
}

//高级搜索
function submitForm(){
	$("#input-word").val("请输入标题查询");
	searchModel();
	$('#upperSearch').modal('hide');
}

function searchModel(){
	var startTime,endTime;
	startTime = $("#startTime").val();
	endTime = $("#endTime").val();
	if(startTime != "" && endTime != "") {
		if(endTime <= startTime) {
			layer.msg("结束时间必须大于开始时间！");
			return;
		}
	}
	var query = $("#search_form").serialize();
	$("#bizInfoList").bootstrapTable('refresh',{
		url : "contractMgr/findBpmRuBizInfoBySolId",
		query:{
			"query":query,
			"modCode":modCode,
		}
	});
}
</script>
<style type="text/css">
.btn-div{
	padding: 5px 0px;
}
#search-div{
	width: 300px; 
	float: right;
}
</style>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>