<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>物品管理</title>
<%@ include file="/views/aco/common/head.jsp"%>
<!-- 引入bootstrap-table-css -->

<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/css/bootstrap.min.css">
<!-- end -->
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">

<script src="${ctx}/views/aco/material/js/out-stock-list.js"></script>

<!-- 引入bootstrap-table-js -->
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
	
<!-- end -->
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<%@ include file="/views/cap/common/theme.jsp"%>
<style>
.fixed-table-toolbar .bars{
	margin-top:0px;
	margin-bottom:0px;
}
</style>
</head>
<body>
	<div class="panel-body"  style="padding-top: 0px;padding-bottom:0px;border:0;">

		<div style="width: 300px; float: right; padding-top: 5px;padding-right: 0px;">
			<div class="input-group">
				<input type="text" id="input-word" class="form-control input-sm"
					value="请输入标题查询" onFocus="if (value =='请输入标题查询'){value=''}"
							onBlur="if (value ==''){value='请输入标题查询'}"> <span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px"
						onclick="searchData()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button type="button" id="advSearchModal" class="btn btn-primary btn-sm" style="margin-left:2px; margin-right: 0px;" >
					<i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
		</div>
				<div class="btn-div btn-group" style="padding: 5px 0;">
			<button id="gm_btn_new" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-plus" aria-hidden="true"></span>新增
			</button>
			<button id="gm_btn_edit" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-pencil" aria-hidden="true"></span>修改
			</button>
		<!-- 	<button id="gm_btn_view" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-eye" aria-hidden="true"></span>查看
			</button> -->
			<button id="gm_btn_send" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-external-link" aria-hidden="true"></span>送交
			</button>
			<button id="gm_btn_remove" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-remove" aria-hidden="true"></span>删除
			</button>
		</div>
			<!-- 高级查询 -->
		<div id="advSearch" class="search-high-grade" style="display: none;">
		<form id="search_form" enctype="multipart/form-data" class="form-horizontal "
			target="_top" method="post" action="">
			
						<div class="form-group" id="dialog-message">
						<label class="col-sm-1 control-label" style="text-align: left;">标题:</label>
						<div class="col-md-3">
					   <input class="form-control input-sm" type="text" id="title_"
						name="title_">						
						</div>
						<label class="col-sm-1 control-label" style="text-align: left;">领用人:</label>
						<div class="col-sm-3">
							<input class="form-control input-sm" type="text" id="user" name="user">
						</div>
						<label class="col-sm-1 control-label" style="text-align: left;padding-left: 22px">经办人:</label>
						<div class="col-sm-3">
					<input class="form-control input-sm" type="text" id="operator"
						name="operator">
						</div>
					</div>
			
								<div class="form-group" id="dialog-message">
					<label class="col-sm-1 control-label" style="text-align: left;">创建时间:</label>
					<div class="col-sm-3">
					<input type="text" id="startTime" name="startTime" value="" 
						class="form-control select input-sm"
						onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
					</div>
					<label class="col-sm-1 control-label"
						style="text-align: left;padding-left: 32px">至</label>
					<div class="col-sm-3">
					<input type="text" id="endTime" name="endTime" value="" 
						class="form-control select input-sm"
						onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
					</div>
					<label class="col-sm-1 control-label" style="text-align: left;">办理状态:</label>
					<div class="col-md-3">
					<select id="status_" name="status_" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
					    <option value="">全部</option>
						<option value="0">未发送</option>
						<option value="1">审批中</option>
						<option value="2">已批准</option>
						<option value="3">未通过</option>
					</select>
					</div>
				</div>	
<!-- 			<div class="form-group">
				<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">标题:</label>
				<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
					<input class="form-control input-sm" type="text" id="title_"
						name="title_">
				</div>	
				<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">领用人:</label>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
					<input class="form-control input-sm" type="text" id="user"
						name="user">
				</div>				
			</div>
				<div class="form-group">
				<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">经办人:</label>
				<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
					<input class="form-control input-sm" type="text" id="operator"
						name="operator">
				</div>	
				<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">办理状态:</label>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
					<select id="status_" name="status_" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
					    <option value="">全部</option>
						<option value="0">未发送</option>
						<option value="1">审批中</option>
						<option value="2">已批准</option>
						<option value="3">未通过</option>
					</select>
				</div>				
			</div>		
			<div class="form-group">
			<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">库存创建时间:</label>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
					<input type="text" id="startTime" name="startTime" value="" style="width:45%; float:left"
						class="form-control select input-sm"
						onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
                       <span  style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
					<input type="text" id="endTime" name="endTime" value="" style="width:45%; float:left"
						class="form-control select input-sm"
						onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />

				</div>
			    </div> -->
		</form>
		<div class="" id="btnDiv" align="center" style="width:100%; margin-bottom: 10px">
			<button type="button" class="btn btn-primary btn-sm" id="advSearch" onclick="submitForm()">查询</button>
			<button type="button" class="btn btn-primary btn-sm" id="advReset" onclick="clearForm()">重置</button>
			<button type="button" id="modal_close" class="btn btn-primary btn-sm">取消</button>
		</div>
	</div>
		<table id="dtlist" data-toggle="table"></table>
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
	$("#dtlist").bootstrapTable('prevPage');
	  },
	onSlideNext: function(swiper){
	$("#dtlist").bootstrapTable('nextPage');
	}
});
</script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>