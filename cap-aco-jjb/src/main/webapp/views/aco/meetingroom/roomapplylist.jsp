<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>会议室申请记录</title>
 <%@ include file="/views/aco/common/head.jsp"%>
<!-- 引入bootstrap-table-css -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<!-- end -->
<script type="text/javascript">
var modCode = "${modCode}";
</script>
<script src="${ctx}/views/aco/meetingroom/js/roomapply.js"></script>
<!-- 引入bootstrap-table-js -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- end -->
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="panel-body"  style="padding-top: 0px;padding-bottom:0px;border:0;">
		<div id="toolbar" class="btn-group" style="margin-top:2px;margin-top:0px\0;margin-bottom: -15px;">
				<!-- <button id="mt_btn_view" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-eye"></span>查看
				</button> -->
				<button id="mt_btn_true" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-check"></span>通过
				</button>
				<button id="mt_btn_false" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-remove"></span>不通过
				</button>
		</div>
		<div style="width: 300px; float: right; padding-top: 5px;padding-right: 0px;">
			<div class="input-group">
				<input type="text" id="input-word" class="form-control input-sm"
					value="请输入会议标题" onFocus="if (value =='请输入会议标题'){value=''}"
							onBlur="if (value ==''){value='请输入会议标题'}" > <span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px"
						onclick="searchMeetingRoom()">
						<i class="fa fa-search"></i> 查询
					</button>
					<button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px; margin-right: 0px;" onclick="advSearchModal()">
						<i class="fa fa-search-plus"></i> 高级
					</button>
				</span>
			</div>
		</div>
		
		<!-- 高级查询 -->
		<div id="searchDiv" class="search-high-grade" style="display:none;margin-top: 20px;">
			<form class="form-horizontal" id="search_form" style="width: 90%;">
				<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">会议标题</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="meeting_name"
							name="meeting_name">
					</div>				
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">会议室</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="room_name"
							name="room_name">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">开始时间</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input type="text" id="starttime" name="starttime"
							class="form-control select"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD',isclear: true})" />
					</div>			
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">到</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input type="text" id="endtime" name="endtime"
							class="form-control select"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD',isclear: true})" />
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" >申请人</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="USER_NAME"
							name="USER_NAME">
					</div>	
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">状态</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
						<select id="status" name="status" class="selectPiker select input-sm">
							<option value="">全部</option>
							<option value="1">审批中</option>
							<option value="2">已审批</option>
						</select>
					</div>				
				</div>
			</form>
			<div align="center" style="width:100%; margin-bottom: 10px">
				<button id="supperSearch_search" type="button" class="btn btn-primary btn-sm" >
					<i class="fa"></i> 查询
				</button>
				<button id="supperSearch_reset" type="button" class="btn btn-primary btn-sm" style="margin-left:1px">
					<i class="fa"></i> 重置
				</button>
				<button id="supperSearch_cancel" type="button" class="btn btn-primary btn-sm" style="margin-left:1px">
					<i class="fa"></i> 取消
				</button>
			</div>
		</div>
		
		
		<table id="dtlist" data-toggle="table" date-striped="true"
			data-click-to-select="true"></table>
	</div>
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style="width: 750px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >会议室申请详情</h4>
				</div>
				<div class="modal-body" style="padding-left: 60px;padding-top: 20px;">
					<form id="ff" action="" method="post" enctype="multipart/form-data"
						class="form-horizontal " target="_top">
						<div class="row">
							<div class="form-group has-feedback col-sm-12">
								<label class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label" for="meetingname">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;会议标题</label>
								<div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
									<input type="text" id="meetingname" name="meeting_name"
										class="form-control" >
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-12">
								<label class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label" for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;会议室</label>
								<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
									<input type="text" id="roomname" class="form-control">
								</div>
								<label class="col-lg-3 col-md-3 col-sm-3 col-xs-3 control-label" for="ts">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;登记时间</label>
								<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
									<input type="text" id="ts"  class="form-control">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-12">
								<label class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label" for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;申请人</label>
								<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
									<input type="text" id="applyuser" class="form-control">
								</div>
								<label class="col-lg-3 col-md-3 col-sm-3 col-xs-3 control-label" for="ts">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;部门</label>
								<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
									<input type="text" id="applyorg" class="form-control">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group col-sm-12">
								<label class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label" for="starttime">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;开始时间</label>
								<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
									<input type="text" id="starttime1" name="starttime1"
										class="form-control"  style="padding:6px 10px">
								</div>
								<label class="col-lg-3 col-md-3 col-sm-3 col-xs-3 control-label" for="endtime">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;结束时间</label>
								<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
									<input type="text" id="endtime1" name="endtime1"
										class="form-control"  style="padding:6px 10px">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-12">
								<label class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label" for="purpose">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;申请用途</label>
								<div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
									<textarea id="purpose" name="purpose" rows="2"
										class="form-control"></textarea>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-12">
								<label class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label" for="resource">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所需资源</label>
								<div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
									<textarea id="resource" name="resource" rows="3"
										class="form-control"></textarea>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-12">
								<label class="col-lg-2 col-md-2 col-sm-2 col-xs-2 control-label" for="remark">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备注</label>
								<div class="col-lg-9 col-md-9 col-sm-9 col-xs-9">
									<textarea id="remark" name="remark" rows="3"
										class="form-control"></textarea>
								</div>
							</div>
						</div>				
					</form>
				</div>
				<div class="modal-footer" id="btnDiv" align="center">
					<button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div>
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