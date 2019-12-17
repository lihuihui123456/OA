<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>会议室清单</title>
 <%@ include file="/views/aco/common/head.jsp"%>
<!-- 引入bootstrap-table-css -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<!-- end -->

<script src="${ctx}/views/aco/meetingroom/js/meetingroom.js"></script>

<!-- 引入bootstrap-table-js -->
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- end -->
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<style>
.select{outline:none !important;}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="panel-body"  style="padding-top:0px;padding-bottom:0px;border:0;">
		<div id="toolbar" class="btn-group" style="margin-top:2px;margin-top:0px\0;margin-bottom: -15px;">
			<button id="mt_btn_new" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-plus" aria-hidden="true"></span>新增
			</button>
			<!-- <button id="mt_btn_edit" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-pencil" aria-hidden="true"></span>修改
			</button>
			<button id="mt_btn_view" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-eye" aria-hidden="true"></span>查看
			</button> -->
			<button id="mt_btn_delete" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-remove" aria-hidden="true"></span>删除
			</button>
		</div>
		<div style="width: 300px; float: right; padding-top: 5px;padding-right: 0px;">
			<div class="input-group">
			     <input type="hidden" id="input-word-hidden" value="">
				<input type="text" id="input-word" class="form-control input-sm"
					value="请输入会议室名称查询" onFocus="if (value =='请输入会议室名称查询'){value=''}"
					onBlur="if (value ==''){value='请输入会议室名称查询'}"> 
				<span class="input-group-btn">
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
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">名称</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="room_name"
							name="room_name">
					</div>				
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">编号</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="room_num"
							name="room_num">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">座位数</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="seats"
							name="seats">
					</div>				
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">面积</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="area"
							name="area">
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">楼层</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<input class="form-control input-sm" type="text" id="floor"
							name="floor">
					</div>				
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">投影仪</label>
					<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
						<select id="projector" name="projector" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
							<option value="">全部</option>
							<option value="1">有</option>
							<option value="0">无</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">多媒体</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
						<select id="video_conference" name="video_conference" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
							<option value="">全部</option>
							<option value="1">支持</option>
							<option value="0">不支持</option>
						</select>
					</div>
					<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">状态</label>
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4" align="left">
						<select id="status" name="status" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
							<option value="">全部</option>
							<option value="1">启用</option>
							<option value="0">禁用</option>
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
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" ></h4>
				</div>
				<div class="modal-body" style="padding:20px 60px">
					<form id="ff" action="" method="post" enctype="multipart/form-data"
						class="form-horizontal " target="_top" style="margin-left: 5%;margin-right: 10%;">
						<input type="hidden" id="idm" name="id">
						<input type="hidden" id="sortm" name="sort">
						<input type="hidden" id="tsm" name="ts">
						<input type="hidden" id="recorddatem" name="recorddate">
						<input type="hidden" id="recorduseridm" name="record_userid">
						<div class="row">
							<div id="roomNameForm" class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="room_name"
									><span style="color:red">*</span>会议室名称 </label>
								<div class="col-sm-8">
									<input type="text" id="room_namem" name="room_name" 
										class="validate[required] form-control" placeholder="" maxlength=10>
									 <span id="checkRoomName"
										class="form-control-feedback"></span>
								</div>
							</div>
							<div id="roomNumForm" class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="room_num"
									><span style="color:red">*</span>会议室编号 </label>
								<div class="col-sm-8">
								<!-- 会议室编号重复验证   validate[required,ajax[roomnum]]-->
									<input type="text" id="room_numm" name="room_num"
										class="validate[required] form-control" placeholder="" maxlength=10 > 
									<span id="checkRoomNum"
										class="form-control-feedback"></span>
								</div>
							</div>
						</div>
						<div class="row">
							<div id="seatsForm" class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="seats"
									><span style="color:red"> *</span>座位数</label>
								<div class="col-sm-8">
									<input type="number" id="seatsm" name="seats" class="validate[required,custom[integer],min[10]] form-control"
										placeholder="" maxlength=4 > 
									<span id="checkSeats" 
										class="glyphicon form-control-feedback"></span>
								</div>
							</div>
							<div class="form-group col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="status"
									><span style="color:red">*</span>状态 </label>
								<div class="col-sm-8">
									<select id="statusm" name="status" class="form-control selectpicker select">
										<option value="1">启用</option>
										<option value="0">禁用</option>
									</select>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="projector"
									>投影仪</label>
								<div class="col-sm-8">
									<select id="projectorm" name="projector" class="form-control selectpicker select"
										>
										<option value="1">有</option>
										<option value="0">无</option>
									</select>
								</div>
							</div>
							<div class="form-group col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="videoconference"
									>多媒体</label>
								<div class="col-sm-8">
									<select id="videoconferencem" name="video_conference"
										class="form-control selectpicker select" size="1">
										<option value="1">支持</option>
										<option value="0">不支持</option>
									</select>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="floor"
									>楼层</label>
								<div class="col-sm-8">
									<input type="text" id="floorm" name="floor" class="form-control"
										placeholder="">
								</div>
							</div>
							<div class="form-group col-sm-6"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-4 control-label" for="area"
									>&nbsp;面积（平米）</label>
								<div class="col-sm-8">
									<input type="text" id="aream" name="area" class="form-control"
										placeholder="">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group col-sm-12"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-2 control-label" for="address"
									>地址</label>
								<div class="col-sm-10">
									<textarea id="addressm" name="address" style="resize: none;" rows="2"
										class="form-control"></textarea>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group col-sm-12"
								style="margin-left: 0; margin-right: 0">
								<label class="col-sm-2 control-label" for="remark"
									>备注</label>
								<div class="col-sm-10">
									<textarea id="remarkm" style="resize: none;" name="remark" rows="3"
										class="form-control"></textarea>
								</div>
							</div>
						</div>				
					</form>
				</div>
				<div class="modal-footer" id="btnDiv" align="center">
					<button type="button" class="btn btn-primary btn-sm" id="savebutton"
						onclick="saveRoomInfo()">保存</button>
					<button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
				</div>
				<div class="modal-footer" id="btnDiv1" align="center">
					<button type="button" class="btn btn-primary btn-sm" id="close_btn"
						data-dismiss="modal">关闭</button>
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