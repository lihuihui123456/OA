<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>文书档案</title>
<%@ include file="/views/aco/common/head.jsp"%>

<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<!-- 引入bootstrap-table-css -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<!-- end -->

<!-- 日期控件 -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/views/aco/arc/docinfor/js/docinfor-list.js"></script>

<script	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- end -->
<!-- 滑动start -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css"
	rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<style>

</style>
<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
	 $(function(){
	 		$("#searcharcName").focus();
			var myDate= new Date();
			//var startYear=myDate.getFullYear()-5;//起始年份
			var startYear=myDate.getFullYear();//起始年份
			var endYear=myDate.getFullYear()+5;//结束年份
			var obj=document.getElementById('searchregYear')
			for (var i=startYear;i<=endYear;i++)
			{
			obj.options.add(new Option(i,i));
			}
		}); 
	 function tableRefresh(){
			window.location.reload();
		}
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
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
	
	<div style="padding-top: 0px;padding-bottom:0px;border:0;">
		
				<div style="padding: 5px 0px;width: 300px;float: right;">
			<div class="input-group">
				<input type="text" id="input-word" class="validate[required] form-control input-sm" value="请输入标题查询" 
					onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button id="supperSearchBtn" type="button"  onclick="searchModal()" class="btn btn-primary btn-sm" style="margin-right: 0px;margin-left: 2px">
						<i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
		</div>
		<div id="toolbar" class="btn-group" style="margin-top:5px;margin-bottom:5px" >
			<button id="add_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-plus" aria-hidden="true"></span> 登记
			</button>
			<!-- <button id="edi_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa  fa-edit" aria-hidden="true"></span>
				修改
			</button> -->
			<button id="guidang_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-files-o" aria-hidden="true"></span> 归档
			</button>
			<button id="zhuijiaguidang_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-folder-open" aria-hidden="true"></span>
				追加档案
			</button>
			<!-- <button id="del_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-remove" aria-hidden="true"></span> 删除
			</button> -->		
			<button id="zuofei_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-ticket" aria-hidden="true"></span> 作废
			</button>
<!-- 			<button id="huanyuan_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-ticket" aria-hidden="true"></span> 还原
			</button> -->
			<button id="export_excel_btn" type="button" class="btn btn-default btn-sm" >
				<span class="fa fa-download" aria-hidden="true"></span>
				导出Excel
			</button>
		</div>

		<!-- 搜索框 -->
		<!-- <div class="btn-div" id="search-div">
			<div class="input-group">
				<span class="input-group-btn">
					<button id="supperSearchBtn" type="button" class="btn btn-primary btn-sm" style="margin-right: 0px;margin-left: 2px">
						<i class="fa "></i> 高级
					</button>
				</span>
			</div>
		</div> -->
		
		<!-- 高级查询 -->
		<div id="searchDiv" class="search-high-grade" style="display:none;">
			<form id="ff" enctype="multipart/form-data"
				class="form-horizontal " target="_top" method="post" action="">
				<input id="searchArcType" name="searchArcType" value="${acrTypeId }" style = "display:none;">
				<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">文件标题:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="searcharcName"
							name="searcharcName" placeholder="请输入文件标题">
					</div>
						<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">登记人:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="searchdocNBR"
							name="searchdocNBR" placeholder="请选择登记人">
					</div>
				</div>
				<div class="form-group">
					<label
						class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">登记日期:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<input type="text" id="regTimeBeginn" name="regTimeBeginn"
							value=""
							class="form-control select input-sm"
							style="width:45%; float:left" onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
						<span
							style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
						<input type="text" id="regTimeEnd" name="regTimeEnd"
							value=""
							class="form-control select input-sm"
							style="width:45%; float:left" onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
					</div>
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">年度:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<select class="form-control input-sm selectpicker" id="searchregYear"
								name="searchregYear" value="" title="请选择年度">
								<option value=""></option>
						</select><!-- 要么 去掉 inputsm 要么 样式有问题 -->
					</div>	
				</div>
				<div class="form-group">
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档状态:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<select id="searchfileStart" name="searchfileStart" class="selectPiker select form-control " style="color: #000;width: 100%;">
							<option value="all" >全部</option>
							<c:forEach items="${filestart }" var="item">
								<option value="${item.getValue()}" >${item.getChname()}</option>
							</c:forEach>
						</select>
					</div>	
				</div>	
				
			</form>
			<div class="modal-footer" style="text-align: center;">
				<!-- <button type="button" id="view_btn" class="btn btn-default" >查看原文</button> -->
				<button type="button" id="btn_search" class="btn btn-primary btn-sm" onclick="searchTable();">查找</button>
				<button type="button" id="btn_reset" class="btn btn-primary btn-sm" onclick="clearForm();">重置</button>
				<button type="button" id="modal_close" class="btn btn-primary btn-sm" onclick="cancelForm();">取消</button>
			</div>
		</div>
		
		<table id="docInforlist" ></table>
	</div>
	
	<div class="swiper-container"> 
		<div class="swiper-wrapper">
			<div class="swiper-slide mask_layer"></div>
		</div>
	</div>
	
<script type="text/javascript">
	var golbalArcType = '${acrTypeId}';
	var globalFileType = '${fileTypeId}';
	var globalPath ='${ctx}';

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
</html>
<%@ include file="/views/aco/common/foot.jsp"%>