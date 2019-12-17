<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>档案类型管理</title>
<%@ include file="/views/aco/common/head.jsp"%>
<!-- 引入bootstrap-table-css -->
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<!-- end -->
<!-- end -->
<!-- 引入 jQuery-Validation-Engine css -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/jquery/jQuery-Validation-Engine-2.6.2/css/validationEngine.jquery.css">
<!-- end -->

<script src="${ctx}/views/aco/arc/arctype/js/arctype-list.js"></script>
<!-- 引入jQuery-Validation-Engine js -->
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/jquery/jQuery-Validation-Engine-2.6.2/js/jquery.validationEngine.min.js"></script>
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/jquery/jQuery-Validation-Engine-2.6.2/js/jquery.validationEngine-zh_CN.js"></script>
<!-- end -->
<!-- 引入bootstrap-table-js -->
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- end -->
<!-- 滑动start -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css"
	rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.exedit-3.5.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.js"></script>
<script type="text/javascript" src="${ctx}/views/cap/common/js/pub-stop-propagation.js"></script>
<script type="text/javascript">
var treeList=${treeList};
</script>
<style>
.control-label {
	text-align: left !important;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
<div class="container-fluid content">

		<!-- start: Main Menu -->
		<div class="sidebar " >
			<div class="sidebar-collapse" style="height:100%">
				<div id="sidebar-menu" class="sidebar-menu" style="height:100%;overflow:auto;" >
					<ul id="folderTree" class="ztree"></ul>
				</div>
			</div>
		</div>
		<!-- end: Main Menu -->
    
    <div id="listResult" class="main">
	<div class="panel-body"
		style="padding-top: 10px;padding-bottom:0px;border:0;">
		<div id="toolbar" class="btn-group">
			<button id="add_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-plus" aria-hidden="true"></span> 新增
			</button>
			<button id="edi_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa  fa-edit" aria-hidden="true"></span>
				修改
			</button>
			<button id="del_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-remove" aria-hidden="true"></span>
				删除
			</button>
		</div>
		<div
			style="width: 300px; float: right; padding-top: 10px;padding-right: 0px;">
			<div class="input-group">
				<input type="text" id="input-word" class="form-control input-sm"
					value="请输入类型名称" onFocus="if (value =='请输入类型名称'){value=''}"
					onBlur="if (value ==''){value='请输入类型名称'}"> <span
					class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm"
						style="margin-right: 0px" onclick="searchCommon()">
						<i class="fa fa-search"></i> 查询
					</button>
							<button type="button" class="btn btn-primary btn-sm" style="margin-left:2px" onclick="advSearchModal()">高级
					</button>
				</span>
			</div>
		</div>
		<table id="typeList" data-toggle="table" date-striped="true"
			data-click-to-select="true"></table>
	</div>
	</div>
		</div>
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="swiper-slide mask_layer"></div>
		</div>
	</div>
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="arcTypeModal" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style="width: 600px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">档案类型管理</h4>
				</div>
				<div class="modal-body" style="padding:20px">
					<form id="arcTypeForm" enctype="multipart/form-data"
						class="form-horizontal " target="_top">
						<input type="hidden" id="id" name="id">
						<input type="hidden" id="typeId" name="typeId">
						<div class="row">
							<div id="typeNameDiv" class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="typeNameLabel">创建用户：<span
									style="color:red;">*</span></label>
								<div class="col-sm-8">
									<input type="hidden" id="creUser" name="creUser" value="<shiro:principal property='id'/>">
									<input type="text" readonly="true" class="form-control" id="creUserName" name="creUserName" value="<shiro:principal property='name'/>">
								</div>
							</div>
						
							<div id="arcTypeDiv" class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="arcTypeLabel">新增日期：<span
									style="color:red;"></span></label>
								<div class="col-sm-8">
								<input type="text" readonly="true" class="form-control" id="creTime" name="creTime">
								</div>
							</div>
						</div>
						<div class="row">
							<div id="typeNameDiv" class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="typeNameLabel">档案类型：<span
									style="color:red;"></span></label>
								<div class="col-sm-8">
									
									<select class="selectpicker select form-control" id="prntId"
										name="prntId" value="" title="请选择">
									</select>
									
								</div>
							</div>
						
							<div id="prntIdDiv" class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="prntIdLabel">子类名称：<span
									style="color:red;">*</span></label>
								<div class="col-sm-8">
									<input type="text" id="typeName" name="typeName" class="validate[required] form-control input">
								</div>
							</div>
						</div>
							<div class="row">
							<div id="hrefPath" class="form-group has-feedback col-sm-12"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-2 control-label" for="prntIdLabel">连接地址：<span
									style="color:red;">*</span></label>
								<div class="col-sm-10">
									<input type="text" id="href" name="href" class="validate[required] form-control input">
								</div>
							</div>
						</div>
						<div class="row">
							<div id="remarkDiv" class="form-group has-feedback col-sm-12"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-2 control-label" for="prntIdLabel">备注信息：</label>
								<div class="col-sm-10">
									<input type="text" id="remark" name="remark" class="form-control input">
								</div>
							</div>
						</div>
<!-- 							<div class="row">
							<div id="orderBy" class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="prntIdLabel">order：<span
									style="color:red;">*</span></label>
								<div class="col-sm-8">
									<input type="text" id="order" name="order" class="validate[required] form-control input">
								</div>
							</div>
						</div> -->
						
					</form>
				</div>
				<div class="modal-footer">
					<div id="btnDiv" align="center">
							<button type="button" class="btn btn-primary btn-sm"
								onclick="saveArcType();">保存</button>
							<button type="button" class="btn btn-primary btn-sm"
								data-dismiss="modal">关闭</button>
						</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 查看档案类型（Modal） -->
	<div class="modal fade" id="viewModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">查看档案类型</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal">
						<div class="form-group">
							<label class="col-sm-2 " style="text-align: right;">类型名称 :</label>
							<div class="col-sm-10">
								<span id="viewName"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2" style="text-align: right;">创建时间:</label>
							<div class="col-sm-10">
								<span id="viewTime"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2" style="text-align: right;">创建用户： </label>
							<div class="col-sm-10">
								<span id="viewUser"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2" style="text-align: right;">备注信息： </label>
							<div class="col-sm-10">
								<span id="viewRemark"></span>
							</div>
						</div>
					</form>
				</div>

				<div class="modal-footer" style="text-align: center;">
					<button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
				<!-- 模态框（Modal） -->
	<div class="modal fade" id="advSearchModal" aria-hidden="true">
		<div class="modal-dialog" style="width: 700px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >高级搜索</h4>
				</div>
				<div class="modal-body">
				<form class="form-horizontal" id="search_form"">
				<input id="searchArcType" name="searchArcType" value="${acrTypeId }" style = "display:none;">
				<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">类型名称:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="typeName1"
							name="typeName1" placeholder="请输入类型名称" style="margin-left: -50px;">
					</div>
						<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">创建人:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="creUser1"
							name="creUser1" placeholder="创建人" style="margin-left: -50px;">
					</div>
				</div>
				
				<div class="form-group">
																	
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">创建日期:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<input type="text" id="startTime1" name="startTime1"
							value=""
							class="form-control select input-sm"
							style="width:45%; float:left;margin-left: -50px;" onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
						<span
							style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
						<input type="text" id="endTime1" name="endTime1"
							value=""
							class="form-control select input-sm"
							style="width:45%; float:left" onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
					</div>
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">备注:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
							<input class="form-control input-sm" type="text" id="remark1"
							name="remark1" placeholder="备注" style="margin-left: -50px;">
					</div>	
				</div>
				
				<div class="clearfix"></div>
			</form>
				</div>
				<div class="modal-footer" style="text-align: center;">					
					<button type="button" id="btn_search" class="btn btn-primary btn-sm"
						onclick="searchData()">查询</button>
					<button type="button" id="btn_reset" class="btn btn-primary btn-sm" onclick="clearForm()">重置</button>
					<button type="button" id="modal_close" class="btn btn-primary btn-sm" data-dismiss="modal">取消</button>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	var mySwiper = new Swiper('.swiper-container', {
		loop : true,
		onSlidePrev : function(swiper) {
			$("#dtlist").bootstrapTable('prevPage');
		},
		onSlideNext : function(swiper) {
			$("#dtlist").bootstrapTable('nextPage');
		}
	});
</script>
<style type="text/css">
.sidebar {
	position: fixed;
	z-index: 11;
	top: 10px;
	width: 200px;
	background-color: #fff;
	border: 1px solid #ddd;
	padding-bottom: 10px;
}

.sidebar .sidebar-menu {
	width: 200px;
}
.main {
	padding: 0;
	padding-left: 200px;
}
</style>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>