<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>指标查询</title>
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
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">功能分类:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<select id="sfgd" name="sfgd" class="selectPiker select input-sm" style="color: #333;width: 100%;padding: 0px 10px;">
									<option value=" "></option>
									<option value="0">行政运行</option>
									<option value="1">一般行政管理事务</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">项目名称:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
									<input type="text" class="form-control input-sm">
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
				<th data-align="center" data-valign="middle" data-field="index">序号</th>
				<th data-align="center" data-valign="middle" data-field="title">部门</th>
				<th data-align="center" data-valign="middle" data-field="month">功能分类</th>
				<th data-align="center" data-valign="middle" data-field="num">项目代码</th>
				<th data-align="center" data-valign="middle" data-field="outNum">项目名称</th>
				<th data-align="center" data-valign="middle" data-field="doNum1">用途</th>
				<th data-align="center" data-valign="middle" data-field="doNum2">预算总金额</th>
				<th data-align="center" data-valign="middle" data-field="doNum3">部门执行金额</th>
				<th data-align="center" data-valign="middle" data-field="doNum4">部门剩余指标</th>
				<th data-align="center" data-valign="middle" data-field="doNum5">财务执行金额</th>
				<th data-align="center" data-valign="middle" data-field="doNum6">实际剩余指标</th>
			</tr>
		</thead>
			<tr>
				<td>1</td>
				<td>办公室</td>
				<td>行政运行</td>
				<td>3YT001</td>
				<td>经常性办案费</td>
				<td>公车运维</td>
				<td>100000</td>
				<td><a href="javascript:void(0)" ><u>1000</u></a></td>
				<td>99000</td>
				<td><a href="javascript:void(0)" ><u>100</u></a></td>
				<td>99900</td>
			</tr>
			<tr>
				<td>2</td>
				<td>财务资金部</td>
				<td>一般行政管理事务</td>
				<td>3YT002</td>
				<td>经常性办案费</td>
				<td>差旅费</td>
				<td>50000</td>
				<td><a href="javascript:void(0)" ><u>10000</u></a></td>
				<td>40000</td>
				<td><a href="javascript:void(0)" ><u>2000</u></a></td>
				<td>48000</td>
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