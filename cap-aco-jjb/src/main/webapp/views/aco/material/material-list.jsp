<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>物品管理</title>
 <%@ include file="/views/aco/common/head.jsp"%>
<!-- 引入bootstrap-table-css -->
<!-- end -->
<!-- end -->
<!-- 引入bootstrap-table-css -->
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<!-- 引入bootstrap-table-js -->
<script src="${ctx}/views/aco/material/js/material-list.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>

<!-- end -->
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<style>
.control-label{
	text-align:left!important;
}
</style>
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
					value="请输入物品名称查询" onFocus="if (value =='请输入物品名称查询'){value=''}"
							onBlur="if (value ==''){value='请输入物品名称查询'}"> <span class="input-group-btn">
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
				<span class="fa fa-eye" aria-hidden="true"></span> 查看
			</button> -->
			<button id="gm_btn_delete" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-remove" aria-hidden="true"></span>删除
			</button>
		</div>
		<!-- 高级查询 -->
		<div id="advSearch" class="search-high-grade" style="display: none; padding-top: 10px;">
		<form id="search_form" enctype="multipart/form-data" class="form-horizontal "
			target="_top" method="post" action="">
						<div class="form-group" id="dialog-message">
						<label class="col-sm-1 control-label" style="text-align: left;">物品名称:</label>
						<div class="col-md-3">
					<input class="form-control input-sm" type="text" id="m_name_" name="m_name_">
						</div>
						<label class="col-sm-1 control-label" style="text-align: left;">物品编号:</label>
						<div class="col-sm-3">
						<input class="form-control input-sm" type="text" id="m_number_"
						name="m_number_">
						</div>
						<label class="col-sm-1 control-label" style="text-align: left;padding-left: 22px">规格型号:</label>
						<div class="col-sm-3">
					<input class="form-control input-sm" type="text" id="standard_"
						name="standard_">
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
					<label class="col-sm-1 control-label" style="text-align: left;">计量单位:</label>
					<div class="col-md-3">
					<input class="form-control input-sm" type="text" id="unit_"
						name="unit_">
					</div>
				</div>	
											<div class="form-group" id="dialog-message">

					<label class="col-sm-1 control-label" style="text-align: left;">供货商:</label>
					<div class="col-md-3">
					<input class="form-control input-sm" type="text" id="supplier_"
						name="supplier_">
					</div>
				</div>
			
<!-- 			<div class="form-group">
				<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">物品名称:</label>
				<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
					<input class="form-control input-sm" type="text" id="m_name_"
						name="m_name_">
				</div>	
				<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">物品编号:</label>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
					<input class="form-control input-sm" type="text" id="m_number_"
						name="m_number_">
				</div>				
			</div> -->
<!-- 				<div class="form-group">
				<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">规格型号:</label>
				<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
					<input class="form-control input-sm" type="text" id="standard_"
						name="standard_">
				</div>	
				<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">计量单位:</label>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
					<input class="form-control input-sm" type="text" id="unit_"
						name="unit_">
				</div>				
			</div> -->
<!-- 				<div class="form-group">
				<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">创建时间:</label>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
					<input type="text" id="startTime" name="startTime" value="" style="width:45%; float:left"
						class="form-control select input-sm"
						onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
                       <span  style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
					<input type="text" id="endTime" name="endTime" value="" style="width:45%; float:left"
						class="form-control select input-sm"
						onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
				</div>			
				<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">供货商:</label>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
					<input class="form-control input-sm" type="text" id="supplier_"
						name="supplier_">
				</div>	
			</div>	 -->		
		</form>
		<div class="" id="btnAdv" align="center" style="width:100%; margin-bottom: 10px">
			<button type="button" class="btn btn-primary btn-sm" id="advSearch" onclick="submitFormAdv()">查询</button>
			<button type="button" class="btn btn-primary btn-sm" id="advReset" onclick="clearFormAdv()">重置</button>
			<button type="button" id="modal_close" class="btn btn-primary btn-sm">取消</button>
		</div>
	</div>
		<table id="dtlist" data-toggle="table" date-striped="true"
			data-click-to-select="true"></table>
	</div>
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style="width: 600px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" ></h4>
				</div>
				<div class="modal-body" style="padding:20px">
					<form id="ff" enctype="multipart/form-data" class="form-horizontal "
						target="_top">
						<input type="hidden" id="id" name="id_"> 
						<input type="hidden" id="indate" name="indate_"> 
						<input type="hidden" id="sort" name="sort_">
						<input type="hidden" id="status" name="status_">
						<div class="row">
							<div id="goodsnameForm" class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="goodsname"
									>物品名称<span style="color:red;">*</span></label>
								<div class="col-sm-8">
									<input type="text" id="goodsname" name="m_name_"
										class="form-control validate[required]" > 
									<span id="checkGoodsname"
										class="form-control-feedback"></span>
								</div>
							</div>
							<div id="goodsnumberForm" class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="goodsnumber"
									>物品编号<span style="color:red;">*</span></label>
								<div class="col-sm-8">
									<input type="text" id="goodsnumber" name="m_number_"
										class="form-control validate[required]" >
									<span id="checkGoodsnumber"
										class="form-control-feedback"></span>
								</div>
							</div>
						</div>
						<div class="row">
							<div id="standardForm" class="form-group has-feedback col-sm-6"
									style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="standard"
									>规格型号<span style="color:red;">*</span></label>
								<div class="col-sm-8">
									<input type="text" id="standard" name="standard_"
										class="form-control validate[required]"> 
									<span id="checkStandard"
										class="form-control-feedback"></span>
								</div>
							</div>
							<div id="inventoryfloorForm" class="form-group has-feedback col-sm-6"
									style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="inventoryfloor"
									>库存下限<span style="color:red;">*</span></label>
								<div class="col-sm-8">
									<input type="number" id="inventoryfloor" name="inventory_floor_"
										class="form-control validate[required,custom[integer],min[0]]" > 
									<span id="checkInventoryfloor"
										class="form-control-feedback"></span>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="supplier"
									>供货商</label>
								<div class="col-sm-8">
									<input type="text" id="supplier" name="supplier_"
										class="form-control" placeholder="">
								</div>
							</div>
							<div class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="unit"
									>计量单位</label>
								<div class="col-sm-8">
									<input type="text" id="unit" name="unit_" class="form-control"
										placeholder="">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-12"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-2 control-label" for="remark"
									>备注</label>
								<div class="col-sm-10">
									<textarea id="remark" name="remark_" rows="4"
										class="form-control"></textarea>
								</div>
							</div>
						</div>				
					</form>
				</div>
				<div class="modal-footer" id="btnDiv" align="center">
							<button type="button" class="btn btn-primary btn-sm" onclick="$('#ff').submit()">保存</button>
							<button type="button" class="btn btn-primary btn-sm"
								data-dismiss="modal">关闭</button>
						</div>
						<div class="modal-footer" id="btnDiv1" align="center">
							<button type="button" class="btn btn-primary btn-sm"
								data-dismiss="modal">关闭</button>
						</div>
			</div>
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