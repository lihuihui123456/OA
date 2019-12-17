<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<style type="text/css">
html, body {
	padding: 0 10px;
	height: 100%;
}
</style>
<title>委托设置公共列表</title>
<%@ include file="/views/aco/common/head.jsp"%>
<!-- bootstrop 样式 -->
<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css">
<!-- 引入bootstrap-table-js -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/views/cap/isc/theme/common/js/jquery.nicescroll.js"></script>

<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
var userid = "${userid}";//业务解决方案id
$(".choose_object").niceScroll({
	cursorcolor : "#000",
	cursoropacitymax : 0.5,
	touchbehavior : false,
	cursorwidth : "8px",
	cursorborder : "0",
	cursorborderradius : "8px"
});
</script>
<style type="text/css">
.choose_object{
	width:99%;
	height:60px;
	position:fixed;
	z-index:11;
	bottom:0px;
	background:#fff;
	border-top:1px solid #ddd;
	padding-top:5px;
	overflow-x:hidden;
	overflow-y:auto;
 }
 .choose_object > a{
 	color:#333;
 	margin-right:10px;
 }
  .choose_object > a span.close_man{
  	color:#333;
  	opacity:0.5;
  	margin-left:3px;
  	font-weight:bold;
  }
  .choose_object > a span.close_man:hover{
  	opacity:1;
  	cursor:pointer;
  }
</style>
</head>
<body>
	<!-- 搜索框 -->
	<div style="width: 300px; float: right; padding-top: 10px; padding-right: 0px;">
		<div class="input-group">
			<input type="text" id="input-word" class="form-control input-sm"
				value="请输入名称查询" onFocus="if (value =='请输入名称查询'){value=''}"
				onBlur="if (value ==''){value='请输入名称查询'}"> <span
				class="input-group-btn">
				<button type="button" class="btn btn-primary btn-sm"
					style="margin-right: 0px" onclick="search()">
					<i class="fa fa-search"></i> 查询
				</button>
			</span>
		</div>
	</div>
	<!-- 数据列表 -->
	<table id="solList"></table>
	<div class="clearfix"></div>
	<div class="choose_object" id="content"><span >已选事项：</span>
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
		$("#solList").bootstrapTable('prevPage');
		  },
		onSlideNext: function(swiper){
		$("#solList").bootstrapTable('nextPage');
		}
	});
</script>
<!-- 页面自己的 js -->
<script type="text/javascript" src="${ctx}/views/aco/delegate/js/sol_list.js"></script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>