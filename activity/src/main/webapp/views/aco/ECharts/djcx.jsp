<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>单据查询</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<link rel="stylesheet" type="text/css"  href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<style>
.form-horizontal .control-label{
	padding-top:5px;
	text-align:left;
	padding-left:50px;
	white-space:nowrap;
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

</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
				<div class="panel-body" style="padding-top:10px;padding-bottom:0px;border:0;"id="swxx_body">
				<div id="" style="border:1px solid #ddd; background:#fff; padding:10px; padding-right:10%;">
					<form class="form-horizontal" id="search_form"">
						<div class="form-group">
							<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="font-weight: bolder;">部门:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<select id="sfgd" name="sfgd" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
									<option value=" "></option>
									<option value="0">办公室</option>
									<option value="1">财务资金部</option>
								</select>
							</div>
							<label
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">报销人:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<input type="text" class="form-control input-sm">
							</div>
						</div>
						<div class="form-group">
							<label
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">填表日期:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
									<input type="text" id="startTime" name="startTime" value="" style="width:45%; float:left"
							class="form-control select input-sm"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
                        <span  style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
						<input type="text" id="endTime" name="endTime" value="" style="width:45%; float:left"
							class="form-control select input-sm"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
							</div>
						</div>
						<div style="text-align:center;margin-left:5%;">
							<button type="button" id="btn_search" class="btn btn-default"
								onclick="search();">查找</button>
							<button type="button" id="btn_reset" class="btn btn-default">重置</button>
						</div>
						<div class="clearfix"></div>
					</form>
				</div>
		<form id="export" action="">
		<table id=bizInfoList>
		<thead>
			<tr>
				<th data-align="center" data-valign="middle" data-field="index" data-width="45px">序号</th>
				<th data-align="center" data-valign="middle" data-field="dept" data-width="45px">部门</th>
				<th data-align="left" data-valign="middle" data-field="user" data-width="100px">报销人</th>
				<th data-align="left" data-valign="middle" data-field="date" data-width="100px">填表日期</th>
				<th data-align="left" data-valign="middle" data-field="money" data-width="140px">报销金额</th>
			    <th data-align="left" data-valign="middle" data-field="viewnum" data-width="140px">查看单据</th>
			</tr>
		</thead>
			<tr>
				<td>1</td>
				<td>办公室</td>
				<td>张某</td>
				<td>2017-03-10 9:00:00</td>
				<td>200</td>
				<td><a href=""><u>3</u></a></td>
			</tr>
			<tr>
				<td>2</td>
				<td>财务资金部</td>
				<td>李某</td>
				<td>2016XZ0001</td>
				<td>600</td>
				<td><a href="" ><u>4</u></a></td>
			</tr>
	</table>
	</form>
</div>
</body>
<script type="text/javascript">
$(function(){
	$('#bizInfoList').bootstrapTable({
		//url : 'bpmRuBizInfoController/findBpmRuBizInfoBySolId', // 请求后台的URL（*）
		//method : 'get', // 请求方式（*）
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
        //sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
		clickToSelect : true, // 是否启用点击选中行
        //idField : "id",  //指定主键列
	});
});
</script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>