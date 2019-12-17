<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>阅件接收详情表</title>
	<%@ include file="/views/aco/common/head.jsp"%>
	<script src="${ctx}/views/aco/notice/js/noticeJsList.js"></script>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<%@ include file="/views/cap/common/theme.jsp"%>
<style type="text/css">
.fixed-table-toolbar .bars{
    margin-top: 0px;
    margin-bottom: 0px
}
</style>
</head>
<body>
	<div class="panel-body" style="padding-top:0px;padding-bottom:0px;border:0;'">
	<!-- 	<div id="toolbar" class="btn-group">
			<button id="btn_open" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-eye" aria-hidden="true"></span>查看
			</button>
		</div> -->
		
		<div style="height:40px; padding-top: 5px;padding-bottom: 5px;padding-right: 0px;">
			<div class="input-group" style="width: 300px; float: right;">
				<input type="text" id="input-word" class="form-control input-sm"
					value="请输入标题查询" onFocus="if (value =='请输入标题查询'){value=''}"
					onBlur="if (value ==''){value='请输入标题查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px"
						onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px;margin-right: 0px;" onclick="showOrHide();">
						<i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
		</div>
		
	<!-- 模态框（Modal） -->
	<div id="upperSearch" class="search-high-grade" style="display: none;">
			<form id="ff" enctype="multipart/form-data" class="form-horizontal "
				target="_top" method="post" action="">
				<div class="form-group" id="dialog-message">
					<label class="col-lg-1  col-md-1 col-sm-1 col-xs-1 control-label">文件标题</label>
					<div class="col-lg-3  col-md-3 col-sm-3 col-xs-3">
						<input id="BIZ_TITLE_" name="BIZ_TITLE_" type="text" class="form-control">
					</div>
					<label class="col-lg-1  col-md-1 col-sm-1 col-xs-1 control-label">办理状态</label>
					<div class="col-lg-3  col-md-3 col-sm-3 col-xs-3">
						<select  id="URGENCY_" name="URGENCY_" class="form-control" size="1" >
							<option value="">请选择</option>
							<option value="1">已阅读</option>
							<option value="0">未阅读</option>
						</select>
					</div>
					<label class="col-lg-1  col-md-1 col-sm-1 col-xs-1 control-label">发送人</label>
					<div class="col-lg-3  col-md-3 col-sm-3 col-xs-3">
						<input id="USER_NAME" name="USER_NAME" type="text" class="form-control">
					</div>
				</div>
				<div class="form-group" id="dialog-message">
					<label class="col-lg-1  col-md-1 col-sm-1 col-xs-1 control-label">发送时间</label>
					<div class="col-lg-3  col-md-3 col-sm-3 col-xs-3">
						<input type="text" id="CREATE_TIME_START_"  name="CREATE_TIME_START_" class="form-control"  onclick="laydate({format: 'YYYY-MM-DD',isclear: false})"/>
					</div>
					<label class="col-lg-1  col-md-1 col-sm-1 col-xs-1 control-label">到</label>
					<div class="col-lg-3  col-md-3 col-sm-3 col-xs-3">
						<input type="text" id="CREATE_TIME_END_" name="CREATE_TIME_END_" class="form-control" onclick="laydate({format: 'YYYY-MM-DD',isclear: false})"/>
					</div>
				</div>
				
			</form>
		<div id="btnDiv" align="center"  style="width:100%; margin-bottom: 10px">
			<button type="button" class="btn btn-primary btn-sm" id="advSearch" onclick="submitForm()">查询</button>
			<button type="button" class="btn btn-primary btn-sm" id="advReset" onclick="clearForm()">重置</button>
			<button type="button" id="modal_close" class="btn btn-primary btn-sm" onclick="qxButton();">取消</button>
		</div>
	</div>
		
		<table id="tapList"></table>
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
	$("#tapList").bootstrapTable('prevPage');
	  },
	onSlideNext: function(swiper){
	$("#tapList").bootstrapTable('nextPage');
	}
});
</script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>