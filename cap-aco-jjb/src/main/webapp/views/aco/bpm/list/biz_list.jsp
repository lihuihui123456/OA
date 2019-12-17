<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>业务公共列表</title>
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
	white-space:nowrap;
}
</style>
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
	<!-- 搜索框 -->
	<div class="btn-div" id="search-div">
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
	
	<!-- table工具栏 -->
	<div class="btn-div btn-group">
		<button id="btn_new" type="button" class="btn btn-default btn-sm">
			<span class="fa fa-plus" aria-hidden="true"></span>拟稿
		</button>
		<!-- <button id="btn_edit" type="button" class="btn btn-default btn-sm">
			<span class="fa fa-pencil" aria-hidden="true"></span>修改
		</button>
		<button id="btn_view" type="button" class="btn btn-default btn-sm">
			<span class="fa fa-eye" aria-hidden="true"></span>查看
		</button> -->
		<button id="btn_delete" type="button" class="btn btn-default btn-sm">
			<span class="fa fa-remove" aria-hidden="true"></span>删除
		</button>
		<!-- <button id="btn_ready" type="button" class="btn btn-default btn-sm">
			<span class="fa fa-clock-o" aria-hidden="true"></span>待发
		</button>
		<button id="btn_already" type="button" class="btn btn-default btn-sm">
			<span class="fa fa-check" aria-hidden="true"></span>已发
		</button> -->
	</div>
	
	<!-- 高级查询 -->
	<div id="searchDiv" class="search-high-grade" style="display:none;width: 100%;">
		<form class="form-horizontal" id="search_form" >
			<div class="form-group" id="dialog-message">
				<label class="col-sm-1 control-label" style="text-align: left;">标题</label>
				<div class="col-md-3">
					<input id="bizTitle_" name="bizTitle_" type="text" class="form-control" >
				</div>
				<label class="col-sm-1 control-label" style="text-align: left;">紧急程度</label>
				<div class="col-sm-3">
					<select  id="URGENCY_" name="URGENCY_" class="form-control" size="1" >
						<option value="">请选择</option>
						<option value="1">平件</option>
						<option value="2">急件</option>
						<option value="3">特急</option>
					</select>
				</div>
				<label class="col-sm-1 control-label" style="text-align: left;padding-left: 22px">办理状态</label>
				<div class="col-sm-3">
					<select  id="STATE_" name="STATE_" class="validate[required] form-control" size="1" >
		    				<option value="">请选择</option>
		    				<option value="1">在办</option>
		    				<option value="2">办结</option>
					</select>
				</div>
			</div>
			<div class="form-group" id="dialog-message">
				<label class="col-sm-1 control-label" style="text-align: left;">拟稿时间</label>
				<div class="col-sm-3">
					<input type="text" id="startTime"  name="startTime" class="form-control"  onclick="laydate({format: 'YYYY-MM-DD hh:mm:ss',isclear: false})"/>
				</div>
				<label class="col-sm-1 control-label" style="text-align: left;padding-left: 32px">到</label>
				<div class="col-sm-3">
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
	
	
	<!-- 模态框（Modal） -->
	<!-- <div class="modal fade" id="searchModal" aria-hidden="true">
		<div class="modal-dialog" style="width: 600px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >高级搜索</h4>
				</div>
				<div class="modal-body">
					<form id="search_form" enctype="multipart/form-data" class="form-horizontal "
						target="_top" method="post" action="">
						<div class="form-group">
							<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">标题:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<input class="form-control input-sm" type="text" id="bizTitle_"
									name="bizTitle_">
							</div>	
							<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">程度:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<select id="URGENCY_" name="URGENCY_" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
									<option value="">全部</option>
									<option value="1">平件</option>
									<option value="2">急件</option>
									<option value="3">特急</option>
								</select>
							</div>				
						</div>
						<div class="form-group">
							<label style="padding-left: 0px;" class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">拟稿时间:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<input type="text" id="startTime" name="startTime" value="" style="width:45%; float:left"
									class="form-control select input-sm"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
		                        <span  style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
								<input type="text" id="endTime" name="endTime" value="" style="width:45%; float:left"
									class="form-control select input-sm"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
		
							</div>
							<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">状态:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
								<select id="STATE_" name="STATE_" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
									<option value="">全部</option>
									<option value="0">待发</option>
									<option value="1">在办</option>
									<option value="2">办结</option>
								</select>
							</div>	
						</div>
						
					</form>
				</div>
					<div class="modal-footer" id="btnDiv" align="center">
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
		</div>
	</div> -->
	
	<!-- 数据列表 -->
	<table id="bizInfoList">
		<thead>
			<tr>
				<th data-align="center" data-valign="middle" data-field="checkStatus" data-width="40px" data-checkbox=true></th>
				<th data-align="center" data-valign="middle" data-field="index" data-width="45px" data-formatter="indexFormatter">序号</th>
				<th data-field="PROC_INST_ID_" data-visible=false></th>
				
				<!-- <th data-align="left" data-valign="middle" data-width="22%" data-field="SERIAL_NUMBER_" data-sortable=true >发文流水号</th> -->
				
				<th data-align="left" data-valign="middle" data-field="BIZ_TITLE_" data-formatter="onTdClickTabFormatter" data-sortable=true>标题</th>
				<th data-align="center" data-valign="middle" data-field="URGENCY_" data-width="100px" data-sortable=true data-formatter="formatterUrgency">紧急程度</th>
				<th data-align="center" data-valign="middle" data-field="STATE_" data-width="100px" data-sortable=true data-formatter="formatterState">办理状态</th>
				<th data-align="right" data-valign="middle" data-field="CREATE_TIME_" data-width="140px" data-sortable=true data-formatter="formatterTime" >拟稿时间</th>
				<!-- <th data-align="center" data-valign="middle" data-field="operate" data-width="100px" data-events="operateEvents" data-formatter="operateFormatter" >操作</th> -->
			</tr>     
		</thead>
	</table>
	
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
</body>
<script type="text/javascript">
	var solId = "${solId}";//业务解决方案id
	
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
<script type="text/javascript" src="${ctx}/views/aco/bpm/list/js/biz_list_common.js"></script>
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
		/* var query,startTime,endTime;
		startTime = $("#startTime").val();
		endTime = $("#endTime").val()
		if(startTime != "" && endTime != "") {
			if(endTime <= startTime) {
				layer.msg("结束时间必须大于开始时间！");
				return;
			}
		}
		query = $("#search_form").serialize();
		$("#bizInfoList").bootstrapTable('refresh',{
			url : "bpmRuBizInfoController/findBpmRuBizInfoBySolId",
			query:{
				"queryParams" : query
			}
		});  */
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
</html>
<%@ include file="/views/aco/common/foot.jsp"%>