<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>日程管理-节假日列表</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" >
<script src="${ctx}/views/aco/calendar/js/holiday-list.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<style type="text/css">
.btn-div{
	padding: 5px 0px;
}
#toolbar{
	padding-top: 5px;
}
#search-div{
	width: 300px; 
	float: right;
}
</style>
</head>

<body>
	<div class="panel-body" style="padding-top:0;padding-bottom:0px;border:0;">
		<div id="toolbar" class="btn-group">
			<button id="add_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-plus" aria-hidden="true"></span> 新增
			</button>
		</div>
		<!-- 搜索框 -->
		<div class="btn-div" id="search-div">
			<div class="input-group">
				<input type="text" id="input-word" class="validate[required] form-control input-sm" value="请输入节日名称查询" 
					onFocus="if (value =='请输入节日名称查询'){value=''}" onBlur="if (value ==''){value='请输入节日名称查询'}"> 
				<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
				</span>
			</div>
		</div>
	</div>
	<table  id="tb_holiday" data-toggle="table" date-striped="true" data-click-to-select="true" ></table>
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="holidayModal" aria-hidden="true">
		<div class="modal-dialog" style="width: 600px;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >日程管理-新增节假日</h4>
				</div>
				<div class="modal-body" style="margin-bottom: 1px;">
					<form id="ff" enctype="multipart/form-data" class="form-horizontal "
						target="_top" method="post" action="">
						<input type="hidden" id="ID" name="ID">
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">节日</label>
							<div class="col-md-10">
								<input id="HOLIDAY_NAME" name="HOLIDAY_NAME" type="text" class="validate[required] form-control" placeholder="请输入节日">
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="validate[dateFormat] col-sm-2 control-label" style="text-align: left;">开始日期</label>
							<div class="col-sm-4">
								<div class="input-group date">
									<input type="text" id="HOLIDAY_START_DATE"  name="HOLIDAY_START_DATE" class="validate[required,custom[dateFormat]] form-control select"  onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
								</div>
							</div>
							<label class="col-sm-2 control-label" style="text-align: left;padding-left: 32px">结束日期</label>
							<div class="col-sm-4">
								<div class="input-group date">
									<input type="text" id="HOLIDAY_END_DATE" name="HOLIDAY_END_DATE" class="validate[required,custom[dateFormat]] form-control select" onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
								</div>
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" style="text-align: left;">节日天数</label>
							<div class="col-sm-4">
								<div class="input-group date">
									<input id="HOLIDAY_NUM" name="HOLIDAY_NUM" type="text" class="validate[required,custom[integer]] form-control" placeholder="请输入节日天数">
								</div>
							</div>
							<label class="col-sm-2 control-label" style="text-align: left;padding-left: 32px">备注</label>
							<div class="col-sm-4">
								<div class="input-group date">
									<input id="HOLIDAY_REMARK" name="HOLIDAY_REMARK" type="text" class="form-control" placeholder="请输入备注">
								</div>
							</div>
						</div>
						
					</form>
				</div>
				<div class="modal-footer" id="btnDiv" align="center">
					<button type="button" class="btn btn-primary" id=save_btn>保存</button>
					<button type="button" class="btn btn-primary" id="calendar">重置</button>
					<button type="button" id="modal_close" class="btn btn-primary" data-dismiss="modal">取消</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>