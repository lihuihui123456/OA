<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>档案类型管理</title>
<%@ include file="/views/aco/common/head.jsp"%>
<!-- 引入bootstrap-table-css -->
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />

<!-- 日期控件 -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<!-- 借阅管理列表js -->
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script src="${ctx}/views/aco/dispatch/js/deptData.js"></script>
<script src="${ctx}/views/aco/arc/borrinfor/js/borrInforList.js"></script>

<!-- 引入bootstrap-table-js -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- end -->

<!-- 滑动start -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css"
	rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->

<script type="text/javascript">
function tableRefresh(){
	window.location.reload();
}
</script>

<style type="text/css">
.treeDiv {
	height: 152px;
	overflow: auto;
	text-align: center;
	display: none;
	position: absolute;
	margin-top: -90px;
	margin-left: -145px;
	background-image: url('${ctx}/views/aco/dispatch/img/treeImg.png');
	background-color: black;
	z-index: 1;
}
.form-control {
padding-right:0;}
.treeDiv2 {
	height: 152px;
	overflow-x: hidden;
	overflow: auto;
	text-align: center;
	display: none;
	position: absolute;
	margin-top: -135px;
	margin-left: -145px;
	background-image: url('${ctx}/views/aco/dispatch/img/treeImg.png');
	background-color: black;
	z-index: 1;
}
.treeDiv3 {
	height: 152px;
	overflow-x: hidden;
	overflow: auto;
	text-align: center;
	display: none;
	position: absolute;
	margin-top: -180px;
	margin-left: -582px;
	background-image: url('${ctx}/views/aco/dispatch/img/treeImg.png');
	background-color: black;
	z-index: 1;
}
.form-control2 {
	border: 1px solid #ccc;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>

	<div style="padding-top:10px;padding-bottom:0px; padding-left:10px;border:0;">
		<div id="toolbar" class="btn-group" style="padding-bottom:10px;">
			<button id="add_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-plus" aria-hidden="true"></span> 登记
			</button>
			<!-- <button id="edi_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa  fa-edit" aria-hidden="true"></span>
				修改
			</button>
			 -->
			<button id="del_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-remove" aria-hidden="true"></span> 删除
			</button>
			<button id="guihuan_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-sign-in" aria-hidden="true"></span>
				归还
			</button>
			<button id="export_excel_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-download" aria-hidden="true"></span>
				导出Excel
			</button>
		</div>
		<div style="width: 300px; float: right;padding-right: 0px;padding-bottom:10px;">
			<div class="input-group">
				<input type="text" id="input-word" class="form-control input-sm"
					value="请输入标题查询" onFocus="if (value =='请输入标题查询'){value=''}"
					onBlur="if (value ==''){value='请输入标题查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px"
						onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px;margin-right: 0px;" onclick="upperSearch()">
						<i class="fa fa-search-plus"></i>高级
					</button>
				</span>
			</div>
		</div>
		
			<!-- 模态框（Modal） -->
	<div id="upperSearch" class="search-high-grade" style="display: none;">
			<form id="ff" enctype="multipart/form-data" class="form-horizontal "
						target="_top" method="post" action="" style="width: 90%;">
				<input type="hidden" id="hideSelectionIds" name="hideSelectionIds">
				<input type="hidden" id="hideInputWord" name="hideInputWord">
				<div class="form-group" style="margin-left: -10px;">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="margin-left: -30px;">登记部门:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<div id="treeDiv_dengjiBumen_" class="treeDiv" style="display:none;">
							<div id="treeDemo_dengjiBumen_" class="ztree"
								style="width:240px;height:120px; margin-top:24px;font-size: 13px;">
								<ul id="groupTree_dengjiBumen_" class="ztree"
									style="margin-top: 10px;"></ul>
							</div>
						</div> 
						<input id="dengjiBumen_" class="form-control2" name="dengjiBumen_"
							type="hidden" style="width: 100%; height: 29;" value="" />
						<input id="dengjiBumenName_" name="regDept" readOnly="true"
							class="validate[required] input-sm form-control2 select " type="text"
							style="width: 100%; height: 29; margin-left: 30px;"
							onclick="peopleTree(2,'dengjiBumen_');" value="" />
					</div>
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2" style="margin-left: -10px;">档案类型:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<select class="selectpicker select validate[required] form-control" style="color: #000;width: 100%;" id="arcType"
							name="arcType" value="" myvalue="" title="请选择" >
							<option value="" >请选择</option>
							<c:forEach items="${arcType }" var="item">
								<option value="${item.getId()}" >${item.getTypeName()}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="form-group" style="margin-left: -10px;">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="margin-left: -30px;">借阅部门:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
 						<div id="treeDiv_jieyueBumenId_" class="treeDiv2" style="display:none;">
							<div id="treeDemo_jieyueBumenId_" class="ztree"
								style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
								<ul id="groupTree_jieyueBumenId_" class="ztree"
									style="margin-top: 10px;"></ul>
							</div>
						</div> 
						<input id="jieyueBumenId_" class="form-control" name="jieyueBumenId_" type="hidden" style="width: 100%; height: 29;" value="" />
						<input id="jieyueBumenIdName_" name="regDept" class="validate[required] form-control2 select input-sm" name="draft_depart_name" type="text" 
							style="width: 100%; height: 29;margin-left: 30px;" readOnly="true"
							onclick="peopleTree(2,'jieyueBumenId_');" value="" /> 
					</div>

					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="margin-left: -10px;">文件标题:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="arcName"
							name="arcName" placeholder="请输入文件标题">
					</div>
				</div>
				<div class="form-group" style="margin-left: -10px;">
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">计划归还日期:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<input type="text" id="planTimeBeginn" name="planTimeBeginn"
							value=""
							class="form-control select input-sm"
							style="width:45%; float:left" onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
						<span
							style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
						<input type="text" id="planTimeEnd" name="planTimeEnd"
							value=""
							class="form-control select input-sm"
							style="width:45%; float:left" onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
							
					</div>
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="margin-left: -40px;">借阅人:&nbsp;&nbsp;&nbsp;</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<div id="treeDiv_jieyueUserId_" class="treeDiv3" style="display:none;">
							<div id="treeDemo_jieyueUserId_" class="ztree"
								style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
								<ul id="groupTree_jieyueUserId_" class="ztree"
									style="margin-top: 10px;"></ul>
							</div>
						</div> 
						<input id="jieyueUserId_" class="form-control" name="jieyueUserId_" type="hidden" style="width: 100%; height: 29;" value="" />
						<input id="jieyueUserIdName_" class="validate[required] form-control2 select input-sm" name="draft_depart_name" type="text" 
							style="width: 100%; height: 29;margin-left: 0px;" readOnly="true"
							onclick="peopleTree(1,'jieyueUserId_');" value="" /> 
					</div>				
				</div>
				<div class="form-group" style="margin-left: -10px;">
					<label
						class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">实际归还日期:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<input type="text" id="actlTimeBeginn" name="actlTimeBeginn"
							value=""
							class="form-control select input-sm"
							style="width:45%; float:left" onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
						<span
							style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
						<input type="text" id="actlTimeEnd" name="actlTimeEnd"
							value=""
							class="form-control select input-sm"
							style="width:45%; float:left" onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>

					</div>
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="margin-left: -40px;">归还状态:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<select id="isSet" name="isSet" class="selectPiker select form-control" style="color: #000;width: 100%;">
							<option value="" >请选择</option>
							<option value="Y" >已归还</option>
							<option value="N" >未归还</option>
							<option value="2" >无需归还</option>
						</select>
					</div>	
				</div>
					<div style="text-align:center;margin-left:5%;">
					<button type="button" id="btn_search" class="btn btn-default" onclick="submitForm();">查找</button>
					<button type="button" id="btn_reset" class="btn btn-default" onclick="clearForm();">重置</button>
					<button type="button" id="modal_close" class="btn btn-primary" onclick="qxButton();">取消</button>
					</div>
					</form>
	</div>
		<table id="borrInforList" data-toggle="table" date-striped="true"
			data-click-to-select="true"></table>
	</div>
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="swiper-slide mask_layer"></div>
		</div>
	</div>
<script type="text/javascript">
/* 	var golbalArcType = '${acrTypeId}';
	var globalFileType = '${fileTypeId}'; */
	var globalPath = '${ctx}';
</script>
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
.sidebar{
	position:fixed;
	z-index:11;
	top:0px;
	width:200px;
	background-color: #fff;
	border:1px solid #ddd;
}
.sidebar .sidebar-menu{
	width:200px;
}
.main{
	padding:0;
	padding-left:200px;
}
.dept_post_tree {
	font-size: 14px;
	overflow-y: auto;
}
.dept_post_tree a {
	font-size: 14px;
	padding-left: 5px;
}
.dept_post_tree li:hover {
	background-color:#fcf1f1!important;
	color:#576069!important;
}
.dept_post_tree li.node-selected{
	background-color:#fcf1f1!important;
	color:#576069!important;
}
.node-dept_post_tree{
	border-width:0!important;
	background-color:#fff!important;
	color:#576069!important;
}
.list-group-item {
	padding:10px;
}

.tablepic td{
  border:1px #becedb solid; 
  padding:5px;
 }
 .tablepic th{
   background:#eff0f5;
   border:1px #becedb solid;
 }
 .bmw{
  background:#f8f9fd;
 }
</style>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>