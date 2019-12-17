<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<html>
<head>
<title>搜索页面</title>
	<%@ include file="/views/aco/common/head.jsp"%>
	<script src="${ctx}/views/aco/notice/js/luceneSearch.js"></script>
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="panel-body" style="padding-top:0;padding-bottom:0px;border:0;">
		<div style="width: 300px; float: right; padding-top: 10px;padding-right: 0px;">
			<div class="input-group">
				<input type="text" id="input-word" class="form-control input-sm"
					value="${fieldValue}" onFocus="if (value =='请输入标题查询'){value=''}"
					onBlur="if (value ==''){value='请输入标题查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px"
						onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
				</span>
			</div>
		</div>
		
		<table id="tapList"></table>
	</div>
	<!-- <div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div> -->
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