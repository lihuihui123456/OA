<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>项目投资档案信息列表</title>
<%@ include file="/views/aco/common/head.jsp"%>
<!-- 引入bootstrap-table-css -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/css/bootstrap.min.css">
<!-- end -->
<!-- end -->
<!-- 引入 jQuery-Validation-Engine css -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/jquery/jQuery-Validation-Engine-2.6.2/css/validationEngine.jquery.css">
<!-- end -->
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">
	
<link href="${ctx}/views/aco/arc/arcbid/css/arcbid.css"
	rel="stylesheet">
<link
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css"
	rel="stylesheet">
<%-- <script
	src="${ctx}/static/cap/plugins/bootstrap/js/jquery-1.11.1.min.js"></script> --%>
<script src="${ctx}/views/aco/arc/inv/list/js/arcinv-list.js"></script>
<!-- 引入jQuery-Validation-Engine js -->
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/jquery/jQuery-Validation-Engine-2.6.2/js/jquery.validationEngine.min.js"></script>
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/jquery/jQuery-Validation-Engine-2.6.2/js/jquery.validationEngine-zh_CN.js"></script>
<!-- end -->
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
<!-- 日期控件 begin -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/skins/dahong/laydate.css" rel="stylesheet">
<style>
.control-label {
	text-align: left !important;
}
#toolbar{
margin-top: 10px;
}
</style>
<script type="text/javascript">
	function tableRefresh(){
		window.location.href=window.location.href;
	}

	/**
	 * 导出按钮事件
	 */
	 function expExcel(){
			//判断是否有选中
			var obj = $('#arcInvList').bootstrapTable('getSelections');
			if (obj.length!=''||obj.length==1) {
				$("#selectIds").val(obj[0].arc_id);
			}else{
				$("#selectIds").val("");
			}
					if($("#input-word").val()!="请输入项目名称查询"&&$("#input-word").val()!=""){
						var sproName=$("#input-word").val();
						$("#search_form")[0].reset();
						$("#sproName").val(sproName);
					}
					 window.location.href = "${ctx}/arcInvController/exportInvExcel?"+$("#search_form").serialize();
					if($("#input-word").val()!="请输入项目名称查询"&&$("#input-word").val()!=""){
						 $("#sproName").val("");
					}	
	 }
	 $(function(){
	 		$("#search_form").find("input").eq(1).focus();
			var myDate= new Date();
			//var startYear=myDate.getFullYear()-5;//起始年份
			var startYear=myDate.getFullYear();
			var endYear=myDate.getFullYear()+5;//结束年份
			var obj=document.getElementById('searchregYear')
			for (var i=startYear;i<=endYear;i++)
			{
			obj.options.add(new Option(i,i));
			}
		});  
</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div style="padding-top: 0px;padding-bottom:0px;border:0;">
				   <div id="search_div" style="width: 300px; float: right; padding-bottom: 10px;padding-top: 10px;">
					<div class="input-group">
						<input type="text" id="input-word" class="form-control input-sm"
							value="请输入项目名称查询" onFocus="if (value =='请输入项目名称查询'){value=''}"
							onBlur="if (value ==''){value='请输入项目名称查询'}"> 
						<span class="input-group-btn">
							<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px"
								onclick="searchCommon()">
								<i class="fa fa-search"></i> 查询
							</button>
								<button type="button" class="btn btn-primary btn-sm" style="margin-left:2px" onclick="advSearchModal()">高级
					</button>
						</span>
					</div>
				</div>
		<div id="toolbar" class="btn-group">
			<button id="add_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-plus" aria-hidden="true"></span> 登记
			</button>
			<button id="update_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa  fa-edit" aria-hidden="true"></span> 修改
			</button>
			<button id="file_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-files-o" aria-hidden="true"></span> 归档
			</button>
			<button id="addFile_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-folder-open" aria-hidden="true"></span> 追加归档
			</button>
			<button id="del_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-remove" aria-hidden="true"></span> 删除
			</button>
			<button id="inv_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-ticket" aria-hidden="true"></span> 作废
			</button>
			<button id="exp_btn" type="button" onclick="expExcel();" class="btn btn-default btn-sm">
				<span class="fa fa-download" aria-hidden="true"></span> 导出Excel
			</button>
		</div>
		<input type="hidden" id="typeId" name="typeId" value='${typeId}'>	
<%-- 		<div id="" style="border:1px solid #ddd; background:#fff; padding:10px; padding-right:10%; margin-top: 10px" >
			<form class="form-horizontal" id="search_form"">
				<input id="searchArcType" name="searchArcType" value="${acrTypeId }" style = "display:none;">
				<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">项目名称:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="sproName"
							name="sproName" placeholder="请输入项目名称" style="margin-left: -50px;">
					</div>
						<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">文件标题:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="sarcName"
							name="sarcName" placeholder="请输入文件标题" style="margin-left: -50px;">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档状态:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<select id="searchfileStart" name="fileStart" class="form-control input-sm" style="color: #000;width: 100%;margin-left: -50px;">
							<option value="5" >全部</option>
							<option value="1" >已归档</option>
							<option value="0" >未归档</option>
							<option value="4" >已作废</option>
						</select>
					</div>	
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">投资形式:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<select id="searchInvType" name="searchInvType" class="form-control input-sm" style="color: #000;width: 100%;margin-left: -50px;">
							<option value="2" >所有</option>
							<option value="0" >货币</option>
							<option value="1" >无形资产</option>
						</select>
					</div>
				</div>
				<div class="form-group">												
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">登记日期:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<input type="text" id="startTime" name="startTime"
							value="" 
							class="form-control select input-sm"
							style="width:45%; float:left;margin-left: -50px;"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
						<span
							style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
						<input type="text" id="endTime" name="endTime"
							value=""  
							class="form-control select input-sm"
							style="width:45%; float:left;"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
					</div>
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">年度:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<select class="form-control input-sm selectpicker" id="searchregYear"
								name="searchregYear" value="" title="请选择年度" style="margin-left: -50px;">
								<option value=""></option>
						</select>
					</div>	
				</div>	
				<div style="text-align:center;margin-left:5%;">
					<button type="button" id="view_btn" class="btn btn-default" >查看原文</button>				
					<button type="button" id="btn_search" class="btn btn-default" onclick="searchData();">查找</button>
					<button type="button" id="btn_reset" onclick="clearCUserForm('search_form')" class="btn btn-default">重置</button>
				</div>
			</form>	
		</div>	 --%>
		<table id="arcInvList">
		</table>
	</div>
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="swiper-slide mask_layer"></div>
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
				<input type="hidden" id="selectIds" name="selectIds"/>
				<input id="searchArcType" name="searchArcType" value="${acrTypeId }" style = "display:none;">
				<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">项目名称:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="sproName"
							name="sproName" placeholder="请输入项目名称" style="margin-left: -50px;">
					</div>
						<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">文件标题:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="sarcName"
							name="sarcName" placeholder="请输入文件标题" style="margin-left: -50px;">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档状态:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<select id="searchfileStart" name="fileStart" class="form-control input-sm" style="color: #000;width: 100%;margin-left: -50px;">
							<option value="5" >全部</option>
							<option value="1" >已归档</option>
							<option value="0" >未归档</option>
							<option value="4" >已作废</option>
						</select>
					</div>	
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">投资形式:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<select id="searchInvType" name="searchInvType" class="form-control input-sm" style="color: #000;width: 100%;margin-left: -50px;">
							<option value="2" >所有</option>
							<option value="0" >货币</option>
							<option value="1" >无形资产</option>
						</select>
					</div>
				</div>
				<div class="form-group">												
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">登记日期:</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<input type="text" id="startTime" name="startTime"
							value="" 
							class="form-control select input-sm"
							style="width:45%; float:left;margin-left: -50px;"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
						<span
							style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
						<input type="text" id="endTime" name="endTime"
							value=""  
							class="form-control select input-sm"
							style="width:45%; float:left;"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"/>
					</div>
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">年度:</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<select class="form-control input-sm selectpicker" id="searchregYear"
								name="searchregYear" value="" title="请选择年度" style="margin-left: -50px;">
								<option value=""></option>
						</select>
					</div>	
				</div>	
				
				<div class="clearfix"></div>
			</form>
		
				</div>
				<div class="modal-footer" style="text-align: center;">
					<button type="button" id="btn_search" class="btn btn-primary btm-sm"
						onclick="searchData()">查询</button>
					<button type="button" id="btn_reset" class="btn btn-primary btm-sm" onclick="clearCUserForm('search_form')">重置</button>
					<button type="button" id="modal_close" class="btn btn-primary btm-sm" data-dismiss="modal">取消</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>