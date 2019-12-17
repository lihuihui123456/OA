<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
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
<%@ include file="/views/cap/common/theme.jsp"%>
<style type="text/css">
.btn-div{
	padding: 5px 0px;
}
#search-div{
	width: 300px; 
	height:40px;
	float: right;
}
</style>
</head>
<body>
<div class="panel-body" style="padding-top:0px;padding-bottom:0px;border:0;">
	<!-- 搜索框 -->
	<div class="btn-div" id="search-div">
		<div class="input-group">
			<input type="text" id="input-word" class="form-control input-sm"
				value="请输入委托人或被委托人姓名查询" onFocus="if (value =='请输入委托人或被委托人姓名查询'){value=''}"
				onBlur="if (value ==''){value='请输入委托人或被委托人姓名查询'}"> <span
				class="input-group-btn">
				<button type="button" class="btn btn-primary btn-sm"
					style="margin-right: 0px" onclick="search()">
					<i class="fa fa-search"></i> 查询
				</button>
			</span>
		</div>
	</div>
	<!-- table工具栏 -->
	<div id="toolbar" class="btn-group btn-div">
		<button id="btn_new" type="button" class="btn btn-default btn-sm">
			<span class="fa  fa-plus" aria-hidden="true"></span>新增
		</button>
		<!-- <button id="btn_edit" type="button" class="btn btn-default btn-sm">
			<span class="fa  fa-pencil" aria-hidden="true"></span>修改
		</button>
		<button id="btn_view" type="button" class="btn btn-default btn-sm">
			<span class="fa fa-eye" aria-hidden="true"></span>查看
		</button>
		<button id="btn_delete" type="button" class="btn btn-default btn-sm">
			<span class="fa fa-remove" aria-hidden="true"></span>删除
		</button> -->
	</div>
	<!-- 数据列表 -->
	<table id="delegateList"></table></div>
		<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false" >
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" ></h4>
				</div>
				<div class="modal-body" style="padding:30px 50px">
					<form id="ff" action="" method="post" enctype="multipart/form-data"
						class="form-horizontal " target="_top" style="margin-left: 5%;margin-right: 10%;">
						<input type="hidden" id="id" name="id">
						<input type="hidden" id="delegate_id" name="delegate_id">
						<div class="row">
							<div class="form-group"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-2 control-label" ><span class="star">*</span>委托人</label>
								<div class="col-sm-10">
									<input type="hidden" id="trust_user_id" name="trust_user_id" class="form-control" value="<shiro:principal property='id'/>">
									<input type="text" id="trust_user_name" name="trust_user_name" style="background-color: white;cursor:text; " class="validate[required] form-control input-sm"   readonly="true" value="<shiro:principal property='name'/>" onclick="choseUser(1)">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-2 control-label" ><span class="star">*</span>被委托人</label>
								<div class="col-sm-10">
                                    <input type="hidden" id="user_id" name="user_id" class="form-control" value="">
									<input type="text" id="user_name" name="user_name"style="background-color: white;cursor:text;"  class="validate[required] form-control input-sm"   readonly="true" onclick="choseUser(2)">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group"
								style="margin-left: 0; margin-right: 0">
							<label  class="control-label col-sm-2"><span class="star">*</span>委托时限</label>
							<div class="col-sm-10">
								<input type="text" id="start_time_" name="start_time_"			
									class="view form-control select input-sm validate[required]"
									style="width:45%; float:left" value="" readonly=""
									 />
									<script>
										laydate({
										  elem: '#start_time_',
										  min: laydate.now(), //代表今天
										  max: '2099-12-31' //
										});
									</script>			
								<span
									style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
								<input type="text" id="end_time_" name="end_time_"	readonly=""								
									class="view form-control select input-sm validate[required]"
									style="width:45%; float:left"   value=""
									 />
									 <script>
										laydate({
										  elem: '#end_time_',
										  min: laydate.now(), //代表今天
										  max: '2099-12-31' //
										});
									</script>
							</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-2 control-label" ><span class="star">*</span>委托事项</label>
								<div class="col-sm-10">
									<input type="hidden" id="sol_id" name="sol_id" class="form-control" value="">
									<input type="text" id="sol_name" name="sol_name" style="background-color: white;cursor:text;" class="validate[required] form-control input-sm" readonly="" value="" onclick="openSol()">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-2 control-label" >委托意见</label>
								<div class="col-sm-10">
									<input type="text" id="comment_" name="comment_" class="view form-control input-sm" value="" readonly="" maxlength="200">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-2 control-label" >备注</label>
								<div class="col-sm-10">
									<input type="text" id="remark_" name="remark_" class="view form-control input-sm" value="" maxlength="200" readonly="">
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer"  align="center">
					<div id="btnDiv" align="center">
						<button type="button" class="btn btn-primary btn-sm" onclick="saveDelegate()">保存</button>
						<button type="button" class="btn btn-primary btn-sm"
							data-dismiss="modal">关闭</button>
					</div>
					<div id="btnDiv1" align="center">
						<button type="button" class="btn btn-primary btn-sm"
							data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 委托选择人员  -->
	<div class="modal fade" id="delegateModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">
					选择人员
					</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<iframe id="group" runat="server" src="" width="100%" height="350" frameborder="no" border="0" marginwidth="0"
						 marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
					</div>
					<div class="modal-footer" style="text-align:center;">
						<button type="button" class="btn btn-primary" onclick="makesure()">确定</button>
						<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>
	</div>
<!-- 模态框（Modal） -->
	<div class="modal fade" id="solModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h3 class="modal-title" id="myModalLabel">委托事项</h3>
				</div>
				<div class="modal-body" >
					<iframe id="solframe" runat="server" width="100%" height="380" frameborder="no" border="0" marginwidth="0"
						 marginheight="0" scrolling="yes" allowtransparency="yes"></iframe>
				</div>
				<div class="modal-footer" style="text-align:center">
					<button type="button" class="btn btn-primary" onclick="saveSol()">确定</button>
 					<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
var url="";
var current_user="";
	var mySwiper = new Swiper('.swiper-container',{
	    loop:true,
		onSlidePrev: function(swiper){
		$("#delegateList").bootstrapTable('prevPage');
		  },
		onSlideNext: function(swiper){
		$("#delegateList").bootstrapTable('nextPage');
		}
	});
	$(function(){
		laydate.skin('dahong');
		 current_user="<shiro:principal property='id'/>";
	});
</script>
<!-- 页面自己的 js -->
<script type="text/javascript" src="${ctx}/views/aco/delegate/js/delegate_list.js"></script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>