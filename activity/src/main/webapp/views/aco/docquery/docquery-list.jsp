<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>公文查询</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script src="${ctx}/views/aco/docquery/js/docquery-list.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script src="${ctx}/views/aco/docmgt/js/TreeRightClick.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<link href="${ctx}/views/cap/bpm/solrun/css/navla.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<script type="text/javascript">
	var conn = "${ctx}";
</script>
<style>
.form-horizontal .control-label{
	padding-top:5px;
	text-align:right;	
}
.gw_title{
	text-align:center;
	margin-top:10px;
	margin-bottom:15px; 
	margin-left:5%;
}
select.form-control{
	padding-right:0;
}
.form-control2 {
	border: 1px solid #ccc;
}
select.input-sm{
	line-height:26px;
}
.fixed-table-toolbar .bars{
    margin-top: 0px;
    margin-bottom: 0px
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="tab-content">
		<div role="tabpanel" class="tab-pane active" id="fwxx_div">
			<div class="panel-body" style="padding-bottom:0px;border:0;"
				id="fwxx_body">
				<!-- 搜索框 -->
				<div style="padding: 5px 0px;width: 300px;float: right;">
					<div class="input-group">
						<input type="text" id="input-word"
							class="validate[required] form-control input-sm" value="请输入标题查询"
							onFocus="if (value =='请输入标题查询'){value=''}"
							onBlur="if (value ==''){value='请输入标题查询'}"> <span
							class="input-group-btn">
							<button type="button" class="btn btn-primary btn-sm"
								style="margin-right: 0px" onclick="search_fw()">
								<i class="fa fa-search"></i> 查询
							</button>
							<button type="button" class="btn btn-primary btn-sm"
								style="margin-left: 2px;margin-right: 0px;"
								onclick="showOrHideFw();">
								<i class="fa fa-search-plus"></i> 高级
							</button>
						</span>
					</div>
				</div>
				<!-- table工具栏 -->
				<div style="padding:5px 0;">
					<button id="btn_excel_fw" type="button"
						class="btn btn-default btn-sm">
						<span class="fa  fa-flag" aria-hidden="true"></span>导出Excel
					</button>
				</div>
				<!-- 发文模态框（Modal） -->
				<div id="upperSearch" class="search-high-grade"
					style="display: none;">
					<form id="search_form" enctype="multipart/form-data"
						class="form-horizontal " target="_top" method="post" action="">
						<input type="hidden" id="hideSelectionIdsfw"
							name="hideSelectionIdsfw"> <input type="hidden"
							id="hideInputWordfw" name="hideInputWordfw">
						<div id="" style="background:#fff; padding:10px;">
							<div class="form-group">
								<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">标题</label>
								<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
									<input class="form-control input-sm" type="text" id="gwbt_fw"
										name="gwbt_fw" placeholder="请输入标题">
								</div>
								<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">办理状态</label>
								<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
									<select id="bwzt_fw" name="bwzt_fw"
										class="selectPiker select input-sm"
										style="color: #333;width: 100%;padding: 0px 10px;">
										<option value=" ">全部</option>
										<option value="1">在办</option>
										<option value="2">办结</option>
									</select>
								</div>
								<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">业务类型</label>
								<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
									<select id="ywlx_fw" name="ywlx_fw"
										class="selectPiker select input-sm"
										style="color: #333;width: 100%;padding: 0px 10px;">
										<option value=" ">全部</option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">拟稿人</label>
								<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
									<input id="draftUserId_" class="form-control select"
										type="hidden" style="width: 100%; height: 29; border: 0;" />
									<input id="draftUserIdName_" name ="draftUserIdName_" class="form-control select"
										 onclick="peopleTree(1,'draftUserId_')"; 
										 type="text" />
								</div>
								<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">拟稿部门</label>
								<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
									<input id="draftDeptId_" class="form-control"  type="hidden"/> 
									<input id="draftDeptIdName_" name ="draftDeptIdName_"class="form-control select"  type="text" onclick="deptTree(2,'draftDeptId_');" />
								</div>
							</div>
						</div>
					</form>
					<div id="btnDiv" align="center"
						style="width:100%; margin-bottom: 10px">
						<button type="button" class="btn btn-primary btn-sm"
							id="advSearch" onclick="submitForm()">查询</button>
						<button type="button" class="btn btn-primary btn-sm" id="advReset"
							onclick="clearForm()">重置</button>
						<button type="button" id="modal_close"
							class="btn btn-primary btn-sm" onclick="qxButtonFw();">取消</button>
					</div>
				</div>
				<form id="export_fw" action="">
					<table id="tapList2"></table>
				</form>
			</div>
			<div class="swiper-container-fw" id="swiper-fw">
				<div class="swiper-wrapper">
					<div class="swiper-slide mask_layer"></div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/views/aco/common/selectionPeople_tree.jsp"%>
	<%@ include file="/views/aco/common/selectionDept_tree.jsp"%>
</body>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>