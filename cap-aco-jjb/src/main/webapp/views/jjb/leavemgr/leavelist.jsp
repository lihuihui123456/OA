<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>请假管理</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" >
<script src="${ctx}/views/jjb/leavemgr/js/leave.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>


<style>
.control-label{
	text-align:left!important;
}
</style>
</head>
<body>
	<div class="panel-body"  style="padding-top:0px;padding-bottom:0px;border:0;">
		<div id="toolbar" class="btn-group">
			<button id="mt_btn_new" type="button" class="btn btn-default btn-sm">
				<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>登记
			</button>
			<button id="mt_btn_edit" type="button" class="btn btn-default btn-sm">
				<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>修改
			</button>
			<!-- 
			<button id="mt_btn_view" type="button" class="btn btn-default btn-sm">
				<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>查看
			</button> 
			-->
		<shiro:hasPermission name="delete:leaveManager:toLeaveMList">
			<button id="mt_btn_delete" type="button" class="btn btn-default btn-sm">
				<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
			</button>
		</shiro:hasPermission>
		<shiro:hasPermission name="del:leaveManager:toLeaveMList">
			<button id="mt_btn_del" type="button" class="btn btn-default btn-sm">
				<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
			</button>
		</shiro:hasPermission>
		<button id="mt_btn_send" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-share-square-o" aria-hidden="true"></span>提交
			</button>
		<button id="mt_btn_export" type="button"
				class="btn btn-default btn-sm">
				<span class="fa fa-mail-reply" aria-hidden="true"></span>导出
			</button>
		</div>
		<div style="width: 300px; float: right; padding-top: 10px;padding-right: 0px;">
			<div class="input-group">
				<input type="text" id="input-word" class="form-control input-sm"
					value="请输入姓名查询" onFocus="if (value =='请输入姓名查询'){value=''}"
					onBlur="if (value ==''){value='请输入姓名查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px"
						onclick="searchLeaveInfo()">
						<i class="fa fa-search"></i> 查询
					</button>
				</span>
			</div>
		</div>
		<form id="exportLeaveInfoToExcel" action="">
			 <table id="dtlist" data-toggle="table" date-striped="true"
			data-click-to-select="true"></table>
			</form>
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