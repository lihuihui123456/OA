<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>公文统计</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div>
		<div id="toolbar" class="btn-group" style="margin-top:10px;">
				<button id="backButton" type="button" style="margin-left:10px;"class="btn btn-default btn-sm">
					<span class="fa fa-arrow-left" aria-hidden="true"></span> 返回上一级
				</button>
			</div>
			<div id="search_div"
				style="width: 250px; float: right;padding-top: 10px;padding-right: 20px;">
				<div class="input-group">
					<input type="text" id="input-word" class="form-control input-sm"
						value="请输入单位或部门名称查询" onFocus="if (value =='请输入单位或部门名称查询'){value=''}"
						onBlur="if (value ==''){value='请输入单位或部门名称查询'}"> <span
						class="input-group-btn">
						<button type="button" class="btn btn-primary btn-sm"
							style="margin-right: 0px" onclick="search()">
							<i class="fa fa-search"></i> 查询
						</button>
					</span>
				</div>
			</div>
	<div class="panel-body" style="padding-top:10px;padding-bottom:0px;border:0;">
		<table id="tableList"></table>
	</div>
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
</body>
</html>
<script type="text/javascript">
	$(document).ready(function(){
		initTable();
		
	});
</script>
<style type="text/css">
.fixed-table-footer table{
	width:100%;
}
</style>
<script type="text/javascript" src="${ctx}/views/aco/docstatistics/js/docstatistics.js"></script>
<%@ include file="/views/aco/common/foot.jsp"%>