<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>页签详情表</title>
	<%@ include file="/views/aco/common/head.jsp"%>
	<script src="${ctx}/views/aco/notice/js/noticeList.js"></script>
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
	<div class="panel-body btn-group" style="padding-top:0;padding-bottom:0px;border:0;">
		<div style="width: 300px; float: right; padding-top: 5px;padding-right: 0px;">
			<div class="input-group">
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
		<div style="padding: 5px 0;">
			<button id="btn_add" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-plus" aria-hidden="true"></span>拟稿
			</button>
			<!-- <button id="btn_edit" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-pencil" aria-hidden="true"></span>修改
			</button> -->
			<!-- <button id="btn_open" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-eye" aria-hidden="true"></span>查看
			</button> -->
		 	<button id="btn_delete" type="button" class="btn btn-default btn-sm" style="margin-left: -5px;">
				<span class="fa fa-remove" aria-hidden="true"></span>删除
			</button> 
			<button id="btn_send" type="button" class="btn btn-default btn-sm" style="margin-left: -4px;">
				<span class="fa fa-share-square-o" aria-hidden="true"></span>送交
			</button>
		</div>
			<!-- 模态框（Modal） -->
		<div id="upperSearch" class="search-high-grade" style="display: none;">
					<form id="ff" enctype="multipart/form-data" class="form-horizontal "
						target="_top" method="post" action="" style="width: 90%;">
						<div class="form-group" id="dialog-message">
							<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">标题</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<input id="BIZ_TITLE_" name="BIZ_TITLE_" type="text" class="form-control input-sm">
							</div>
							<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">办理状态</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<select  id="URGENCY_" name="URGENCY_" class="selectPiker select input-sm" size="1" style="color: #333;width: 100%;padding: 0px 10px;">
									<option value="">请选择</option>
									<option value="1">已送交</option>
									<option value="0">未送交</option>
								</select>
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">拟稿日期</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<input type="text" id="CREATE_TIME_START_"  name="CREATE_TIME_START_" class="form-control select input-sm"
							 style="width:45%; float:left"  onclick="laydate({format: 'YYYY-MM-DD',isclear: false})"/>
							<!-- <label class="col-sm-1 control-label" style="text-align: left;padding-left: 32px">到</label> -->
							<span  style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
							<input type="text" id="CREATE_TIME_END_" name="CREATE_TIME_END_" class="form-control select input-sm"
							  style="width:45%; float:left"  onclick="laydate({format: 'YYYY-MM-DD',isclear: false})"/>
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