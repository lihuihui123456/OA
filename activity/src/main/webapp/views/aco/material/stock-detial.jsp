<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>出入库明细</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link href="/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/editable/css/bootstrap-editable.css"">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script src="${ctx}/views/aco/material/js/stock-detial.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/editable/js/bootstrap-table-editable.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/editable/js/bootstrap-editable.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>

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
	<div class="panel-body"  style="padding-top:0;padding-bottom:0px;border:0;">

		<div style="height:40px; padding-top: 5px;padding-bottom: 5px;padding-right: 0px;">
			<div class="input-group" style="width: 300px; float: right;">
				<input type="text" id="goodsname" class="form-control input-sm"
					value="请输入物品名称查询" onFocus="if (value =='请输入物品名称查询'){value=''}"
					onBlur="if (value ==''){value='请输入物品名称查询'}"> 
				<span class="input-group-btn">
					<button type="button"  style="margin-right: 0px" class="btn btn-primary btn-sm"
						onclick="searchData()">
						<i class="fa fa-search"></i> 查询
					</button>
		     <button type="button" id="advSearchModal" class="btn btn-primary btn-sm" style="margin-left:2px; margin-right: 0px;" >
		     <i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
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
					<label class="col-sm-1 control-label" style="text-align: left;">方向:</label>
					<div class="col-md-3">
					<input class="form-control input-sm" type="text" id="direction_"
						name="direction_">
					</div>
				</div>
			
					<div class="form-group" id="dialog-message">
						<label class="col-sm-1 control-label" style="text-align: left;">库存数量:</label>
						<div class="col-md-3">
		                 <input class="form-control input-sm" type="text" id="amount_"
						name="amount_">						</div>
						<label class="col-sm-1 control-label" style="text-align: left;">领用人:</label>
						<div class="col-sm-3">
					<input class="form-control input-sm" type="text" id="user"
						name="user">
						</div>
						<label class="col-sm-1 control-label" style="text-align: left;padding-left: 22px">经办人:</label>
						<div class="col-sm-3">
					<input class="form-control input-sm" type="text" id="operator"
						name="operator">
						</div>
					</div>
			
			
<!-- 			<div class="form-group">
				<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">物品名称:</label>
				<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
					<input class="form-control input-sm" type="text" id="m_name_" name="m_name_">
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
				<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">方向:</label>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
					<input class="form-control input-sm" type="text" id="direction_"
						name="direction_">
				</div>				
			</div> -->
<!-- 				<div class="form-group">
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
				<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">库存数量:</label>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
					<input class="form-control input-sm" type="text" id="amount_"
						name="amount_">
				</div>	
		
			</div>	 -->		
<!-- 			<div class="form-group">
		<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">领用人:</label>
				<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
					<input class="form-control input-sm" type="text" id="user"
						name="user">
				</div>
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">经办人:</label>
				<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
					<input class="form-control input-sm" type="text" id="operator"
						name="operator">
				</div>
			    </div> -->
		</form>
		<div class="" id="btnDiv" align="center" style="width:100%; margin-bottom: 10px">
			<button type="button" class="btn btn-primary btn-sm" id="advSearch" onclick="submitForm()">查询</button>
			<button type="button" class="btn btn-primary btn-sm" id="advReset" onclick="clearForm()">重置</button>
			<button type="button" id="modal_close" class="btn btn-primary btn-sm">取消</button>
		</div>
	</div>
		<table  id="dtlist" data-toggle="table" date-striped="true" data-click-to-select="true" ></table>
	</div>
		<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
	<!-- 模态框（Modal） -->
<!-- 	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >高级搜索</h4>
				</div>
				<div class="modal-body">
					<form id="ff" action="" method="post" enctype="multipart/form-data"
						class="form-horizontal " target="_top">
						<div class="form-group">
							<label class="col-sm-4 control-label" for="goodsname1"
								style="text-align: right;">物品名称&nbsp;&nbsp;&nbsp;</label>
							<div class="col-sm-6">
								<input type="text" id="goods"
									class="form-control" >
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label" for="user"
								style="text-align: right;">领用人&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
							<div class="col-sm-6">
								<input type="text" id="user"
									class="form-control" >
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label" for="operator"
								style="text-align: right;">经办人&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
							<div class="col-sm-6">
								<input type="text" id="operator"
									class="form-control" >
							</div>
						</div>					
					</form>
				</div>
				<div class="modal-footer" id="btnDiv" align="center">
							<button type="button" class="btn btn-primary btn-sm"
								onclick="submitForm()">查询</button>
							<button type="button" class="btn btn-primary btn-sm"
								data-dismiss="modal">关闭</button>
							<button type="button" class="btn btn-primary"
								onclick="clearForm()">重置</button>
						</div>
			</div>
		</div>
	</div> -->
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