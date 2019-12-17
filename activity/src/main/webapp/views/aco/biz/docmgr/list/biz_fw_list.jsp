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
			<a href="#fwdj_div" role="tab" data-toggle="tab" id="xx_fw">登记</a></li>
		<li role="presentation" >
			<a href="#fwdb_div" role="tab" data-toggle="tab" id="xx_sw">待办</a></li>

	</ul>

	<!-- Tab panes -->
	<div class="tab-content">
		<!-- 个人收文待办  start-->
		<div role="tabpanel" class="tab-pane " id="fwdb_div">
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
						<button type="button" class="btn btn-primary btn-sm" id="advSearch"
							onclick="submitFormsw()">查询</button>
						<button type="button" class="btn btn-primary btn-sm" id="advReset"
							onclick="clearFormsw()">重置</button>
						<button type="button" class="btn btn-primary btn-sm" id="modal_close"
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
		<div role="tabpanel" class="tab-pane active" id="fwdj_div">
			<div class="panel-body" id="fwxx_body" style="padding-bottom: 0px; border: 0;">
				<!-- 个人收文登记搜索框  satrt-->
	<!-- 搜索框 -->
	<div class="btn-div" id="search-div"  >
		<div class="input-group">
			<input type="text" id="input-word" class="validate[required] form-control input-sm" value="请输入标题查询" 
				onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
			<span class="input-group-btn">
				<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
					<i class="fa fa-search"></i> 查询
				</button>
				<button id="supperSearchBtn" type="button" class="btn btn-primary btn-sm" style="margin-left: 2px; margin-right: 0px;">
					<i class="fa fa-search-plus"></i> 高级
				</button>
			</span>
		</div>
	</div>
	<!-- 引入列表工具栏条 -->
	<%@ include file="/views/aco/biz/commons/biz_btn_list_do.jsp"%>
	<!--  发文管理：传阅、撤回、跟踪、关注开始 -->
	<div class="btn-div btn-group">
		<button id="btn_circulation" type="button"  class="btn btn-default btn-sm" >
		<span class="fa fa-file-text" aria-hidden="true"></span> 传阅
	</button>
			<button id="btn_recall" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-reply" aria-hidden="true"></span>撤回
			</button>
			<button id="btn_editSubject" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-flag" aria-hidden="true"></span>跟踪事项
			</button>
			<button id="btn_attend" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-heart" aria-hidden="true"></span>关注事项
			</button>
	</div>
	<!--  发文管理：传阅、撤回、跟踪、关注结束 -->
	<input id="solId" name="solId" type="hidden" value="${solId}" />
	<!-- 引入列表工具栏条 -->
	<!-- 高级查询 -->
	<div id="searchDiv" class="search-high-grade" style="display:none;width: 100%;">
		<form class="form-horizontal" id="search_form" >
			<div class="form-group" id="dialog-message">
				<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">标题</label>
				<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
					<input id="bizTitle_" name="bizTitle_" type="text" class="form-control">
				</div>
				<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">紧急程度</label>
				<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
					<select  id="URGENCY_" name="URGENCY_" class="form-control" size="1" >
						<option value="">请选择</option>
						<option value="1">平件</option>
						<option value="2">急件</option>
						<option value="3">特急</option>
					</select>
				</div>
				<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">办理状态</label>
				<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
					<select  id="STATE_" name="STATE_" class="validate[required] form-control" size="1" >
		    				<option value="">请选择</option>
		    				<option value="0">待发</option>
		    				<option value="1">在办</option>
		    				<option value="2">办结</option>
					</select>
				</div>
			</div>
			<div class="form-group" id="dialog-message">
				<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">拟稿时间</label>
				<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
					<input type="text" id="startTime"  name="startTime" class="form-control"  onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: false})"/>
				</div>
				<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">到</label>
				<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
					<input type="text" id="endTime" name="endTime" class="form-control" onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: false})"/>
				</div>
			</div>
		</form>
		<div align="center" style="width:100%; margin-bottom: 10px">
			<button id="supperSearch_search" type="button" class="btn btn-primary btn-sm" >
				<i class="fa"></i> 查询
			</button>
			<button id="supperSearch_reset" type="button" class="btn btn-primary btn-sm" style="margin-left:1px">
				<i class="fa"></i> 重置
			</button>
			<button id="supperSearch_cancel" type="button" class="btn btn-primary btn-sm" style="margin-left:1px">
				<i class="fa"></i> 取消
			</button>
		</div>
	</div>
	<!-- 数据列表 -->
	<table id="bizInfoList">
		<thead>
			<tr>
				<th data-align="center" data-valign="middle" data-field="checkStatus" data-width="40px" data-checkbox=true></th>
				<th data-align="center" data-valign="middle" data-field="index" data-width="45px" data-formatter="indexFormatter">序号</th>
				<th data-field="PROC_INST_ID_" data-visible=false></th>
				<!-- <th data-align="left" data-valign="middle" data-width="22%" data-field="SERIAL_NUMBER_" data-sortable=true >发文流水号</th> -->
				<th data-align="left" data-valign="middle" data-field="BIZ_TITLE_" data-formatter="onTdClickTabFormatter"  data-sortable="true">标题</th>
				<th data-align="center" data-valign="middle" data-field="URGENCY_" data-width="100px" data-sortable="true" data-cell-style="cellStyle" data-formatter="formatterUrgency">紧急程度</th>
				<th data-align="center" data-valign="middle" data-field="STATE_" data-width="100px"  data-sortable="true" data-cell-style="cellStyle" data-formatter="formatterState">办理状态</th>
				<th data-align="center" data-valign="middle" data-field="CREATE_TIME_" data-width="140px"  data-sortable="true" data-cell-style="cellStyle" data-formatter="formatterTime" >拟稿时间</th>
				<!-- <th data-align="center" data-valign="middle" data-field="operate" data-width="100px" data-events="operateEvents" data-formatter="operateFormatter" >操作</th> -->
			</tr>     
		</thead>
	</table>
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
	</div>
	</div>
	<!-- 个人收文登记 end -->
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
<script type="text/javascript" src="${ctx}/views/aco/biz/docmgr/list/js/biz_list_common.js"></script>
<script type="text/javascript">
$(function() {
	$("#supperSearchBtn").click(function() {
		var display =$("#searchDiv").css('display');
		if(display == "none") {
			$("#searchDiv").show();
		}else {
			$("#searchDiv").hide();
		}
	})
	//开始高级搜索
	$("#supperSearch_search").click(function() {
		$("#input-word").val("");
		search();
		$("#searchDiv").show();
	})
	//重置高级搜索选项
	$("#supperSearch_reset").click(function() {
		$("#search_form")[0].reset();
		$("#input-word").val("");
		search();
	})
	//取消高级搜索选项
	$("#supperSearch_cancel").click(function() {
		$("#search_form")[0].reset();
		$("#searchDiv").hide();
	})
	$('#input-word').keydown(function(event){ 
		if(event.keyCode==13){
			search();
		} 
	}); 
})
laydate.skin('dahong');
</script>
<style type="text/css">
.btn-div{
	padding: 5px 0px;
}
#search-div{
	width: 300px; 
	float: right;
}
.form-horizontal .control-label{
	padding-top:5px;
	text-align:left;
	padding-left:6px;
}

</style>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>