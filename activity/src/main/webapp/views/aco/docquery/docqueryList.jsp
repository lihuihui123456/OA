<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>公文查询</title>
	<%@ include file="/views/aco/common/head.jsp"%>
	<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
	<script src="${ctx}/views/aco/docquery/js/docqueryList.js"></script>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<link href="${ctx}/views/cap/bpm/solrun/css/navla.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<script type="text/javascript">
var conn = "${ctx}";

</script>
<script src="${ctx}/views/aco/docquery/js/deptData.js"></script>
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
.treeDiv {
	height: 152px;
	overflow-x: hidden;
	overflow: auto;
	text-align: center;
	display: none;
	position: absolute;
	margin-top: -100px;
	margin-left: -653px;
	background-image:  url('${ctx}/views/aco/dispatch/img/treeImg.png');
	background-color: black;
	z-index: 1;
}
.treeDiv2 {
	height: 152px;
	overflow-x: hidden;
	overflow: auto;
	text-align: center;
	display: none;
	position: absolute;
	margin-top: -50px;
	margin-left: -300px;
	background-image: url('${ctx}/views/aco/dispatch/img/treeImg.png');
	background-color: black;
	z-index: 1;
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
	<!-- Nav tabs -->
	<ul class="nav nav-tabs" role="tablist" id="myTab">
		<li role="presentation" class="active">
			<a href="#fwxx_div" role="tab" data-toggle="tab" id="xx_fw">发文信息</a>
		</li>
		<li role="presentation">
			<a href="#swxx_div" role="tab" data-toggle="tab" id="xx_sw">收文信息</a>
		</li>
	</ul>

	<!-- Tab panes -->
	<div class="tab-content">
		<div role="tabpanel" class="tab-pane" id="swxx_div">
			<div class="panel-body" style="padding-bottom:0px;border:0;"id="swxx_body">
			
				<!-- 搜索框 -->
			<div style="padding: 5px 0px;width: 300px;float: right;">
			<div class="input-group">
				<input type="text" id="input-word-sw" class="validate[required] form-control input-sm" value="请输入标题查询" 
					onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px;margin-right: 0px;" onclick="showOrHideSw();">
						<i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
			</div>
			<!-- table工具栏 -->
		<div style="padding:5px 0;">
			<button id="btn_excel" type="button" class="btn btn-default btn-sm">
				<span class="fa  fa-flag" aria-hidden="true"></span>导出Excel
			</button>
		</div>
			
				<!-- 收文模态框 -->
	<div id="upperSearchsw" class="search-high-grade" style="display: none;">
				<form id="search_form_sw" enctype="multipart/form-data" class="form-horizontal "
							target="_top" method="post" action="" style="width: 90%;">
							<input type="hidden" id="hideSelectionIdssw" name="hideSelectionIdssw">
							<input type="hidden" id="hideInputWordsw" name="hideInputWordsw">
						<div id="" style=" background:#fff; padding:10px; padding-right:10%;">
						<div class="form-group">
						<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">标题</label>
						<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
							<input class="form-control input-sm" type="text" id="gwbt"
								name="gwbt" >
						</div>
						<label
							class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">登记人</label>
						<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								 <input
							id="draftUser2IdName_" name="regUser"
							class="select input-sm"
							type="text"
							style="width: 100%; height: 29; border: 1px solid #ccc;padding:12px;"
							value="" />
						</div>
					</div>
					<div class="form-group">
						<label
							class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">是否归档</label>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<select id="sfgd" name="sfgd" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
								<option value=" ">全部</option>
								<option value="0">未归</option>
								<option value="1">已归</option>
							</select>
						</div>
						<label
							class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">办理状态</label>
						<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
							<select id="bwzt" name="bwzt" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
								<option value=" ">全部</option>
								<option value="1">在办</option>
								<option value="2">办结</option>
							</select>
						</div>
					</div>
						</div>						
				</form>
				<div id="btnDiv" align="center" style="width:100%; margin-bottom: 10px">
					<button type="button" class="btn btn-primary btn-sm" id="advSearch"
						onclick="submitFormsw()">查询</button>
					<button type="button" class="btn btn-primary btn-sm" id="advReset"
						onclick="clearFormsw()">重置</button>
					<button type="button" id="modal_close" class="btn btn-primary btn-sm"
						onclick="qxButtonSw();">取消</button>
				</div>
	</div>
			
		
				<form id="export" action="">
					<table id="tapList"></table>
				</form>
			</div>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide mask_layer"></div>
				</div>
			</div>
		</div>
		<div role="tabpanel" class="tab-pane active" id="fwxx_div">
			<div class="panel-body" style="padding-bottom:0px;border:0;" id="fwxx_body">
		<!-- 搜索框 -->
			<div style="padding: 5px 0px;width: 300px;float: right;">
			<div class="input-group">
				<input type="text" id="input-word" class="validate[required] form-control input-sm" value="请输入标题查询" 
					onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search_fw()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px;margin-right: 0px;" onclick="showOrHideFw();">
						<i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
			</div>
			<!-- table工具栏 -->
		<div style="padding:5px 0;">
			<button id="btn_excel_fw" type="button" class="btn btn-default btn-sm">
				<span class="fa  fa-flag" aria-hidden="true"></span>导出Excel
			</button>
		</div>
			
			
				<!-- 发文模态框（Modal） -->
			<div  id="upperSearch" class="search-high-grade" style="display: none;">
					<form id="search_form" enctype="multipart/form-data" class="form-horizontal "
								target="_top" method="post" action="">
								<input type="hidden" id="hideSelectionIdsfw" name="hideSelectionIdsfw">
								<input type="hidden" id="hideInputWordfw" name="hideInputWordfw">
							<div id="" style="background:#fff; padding:10px;">
						<div class="form-group">
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">标题</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<input class="form-control input-sm" type="text" id="gwbt_fw" name="gwbt_fw"  placeholder="请输入标题">
							</div>
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">办理状态</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<select id="bwzt_fw" name="bwzt_fw" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
									<option value=" ">全部</option>
									<option value="1">在办</option>
									<option value="2">办结</option>
								</select>
							</div>
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">是否归档</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
							<!-- 	<input
								id="draftDeptIdName_" name="regDept" 
								class="select input-sm"
								type="text"
								style="width: 100%; height: 29px; border: 1px solid #ccc;padding:12px;"
								value="" /> -->
								<select id="sfgd_fw" name="sfgd_fw" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
									<option value=" ">全部</option>
									<option value="0">未归</option>
									<option value="1">已归</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">拟稿人</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<input
								id="draftUserIdName_" name="regUser"
								class="select input-sm"
								type="text" 
								style="width: 100%; height: 29; border: 1px solid #ccc;padding:12px;"
								value="" />
							</div>
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">紧急程度</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<select id="jjcd_fw" name="jjcd_fw" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
									<option value=" ">全部</option>
									<option value="1">平件</option>
									<option value="2">急件</option>
									<option value="3">特急</option>
								</select>
							</div>
						
							<!-- <label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">是否归档</label>
							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<select id="sfgd_fw" name="sfgd_fw" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
									<option value=" ">全部</option>
									<option value="0">未归</option>
									<option value="1">已归</option>
								</select>
							</div> -->
							
							
						</div>
					</div>						
					</form>
				<div id="btnDiv" align="center" style="width:100%; margin-bottom: 10px">
					<button type="button" class="btn btn-primary btn-sm" id="advSearch"
						onclick="submitForm()">查询</button>
					<button type="button" class="btn btn-primary btn-sm" id="advReset"
						onclick="clearForm()">重置</button>
					<button type="button" id="modal_close" class="btn btn-primary btn-sm"
						onclick="qxButtonFw();">取消</button>
				</div>
	</div>
			
			
			<form id="export_fw" action="">
		 		<table id="tapList2"></table>
		 	</form>
		</div>
		<div class="swiper-container-fw" id="swiper-fw">
		   	<div class="swiper-wrapper">
				<div  class="swiper-slide mask_layer" ></div>
			</div>
		</div>
	 </div>
	</div>
  </body>
  <script type="text/javascript">
</script>
<script type="text/javascript">
function selectDoc(flag) {
		var obj = $('#' + flag).bootstrapTable('getSelections');
		if(null == obj || "" == obj){
			layerAlert("请选择一条数据!");
		}else{
			var bizId = obj[0].ID_;
			var options={
					"text":"查看公文",
					"id":"viewgw"+bizId,
					"href":"bpmRunController/view?bizId="+ bizId,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
		}

}
</script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>