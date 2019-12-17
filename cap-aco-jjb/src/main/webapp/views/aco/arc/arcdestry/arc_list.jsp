<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script type="text/javascript">
$(function(){
	laydate.skin('dahong');	
	$("#tb_departments").bootstrapTable({
		url : "${ctx}/arcPubInfo/arcList", 
		method : 'get', 
		toolbar : '#toolbar', 
		striped : true, 
		cache : false,
		pagination : true,
		sortable : false, 
		sortOrder : "asc", 
		queryParams :function(params) {
			var temp = {
					pageSize : params.limit, // 页面大小
					pageNum : params.offset, // 页码
					arcName :$("#arcName").val(),
					startTime:$("#startTime").val(),
					endTime:$("#endTime").val()
				};
				return temp;
			}, 
		sidePagination : "server", 
		pageNumber : 1, 
		pageSize : 10, 
		search : false, 
		strictSearch : false,
		showColumns : false, 
		showRefresh : false, 
		minimumCountColumns : 2, 
		clickToSelect : true, 
		uniqueId : "arcId", 
		showToggle : false,
		cardView : false, 
		detailView : false, 
		singleSelect : true,
		columns : [ {
			checkbox : true
		}, {
			field : 'index',
			title : '序号',
			valign: 'middle',
 			width: '10%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		},{
			field : 'arcName',
			valign: 'middle',
			align : 'center',
			title : '文档名称'
			
		},
		{
			field : 'arcType',
			title : '文档类型',
			visible:false
			
		}
		]
	});
});
function search(){
	if($("#startTime").val() > $("#endTime").val()){
		layerAlert("归档开始日期不能大于结束日期");
		return;
	}
	$("#tb_departments").bootstrapTable('refresh');
}

function resetSearch(){
	$("#startTime").val('');
	$("#endTime").val('');
	$("#arcName").val('');
	$("#tb_departments").bootstrapTable('refresh');
}
//保存关联信息
function saveAttach(){
	//获取当前选取的数据
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if(obj.length<=0){
		return;
	}
	var arcId=obj[0].arcId;
	var arcName=obj[0].arcName;
	var arcType=obj[0].arcType;
	var arcExpiryDate=obj[0].expiryDate;
	window.parent.setArcInfo(arcId,arcName,arcType,arcExpiryDate);	
}
</script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
<div class="panel-body" style="padding-bottom:0px;border:0;'">
<div id="" style="border:1px solid #ddd; background:#fff; padding:10px; padding-right:10%; margin-top: 10px" >
					<form class="form-horizontal" id="search_form"">
							<div class="form-group">
						
							<label
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档时间:</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<input type="text" id="startTime" name="startTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
								<span
									style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
								<input type="text" id="endTime" name="endTime"
									value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
							</div>
								<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">文档名称:</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<input class="form-control input-sm" type="text" id="arcName"
									name="arcName" placeholder="请输入文档名称">
							</div>
						</div> 
								
						
				<div style="text-align:center;margin-left:5%;">
					<button type="button" id="btn_search" class="btn btn-default" onclick="search()">查询</button>
					<button type="reset" id="btn_reset" class="btn btn-default" onclick="resetSearch()">重置</button>
				</div>
				<div class="clearfix"></div>
						</form>	
						</div>	
	<div style="margin-bottom: 10px">								
	<table  id="tb_departments" data-toggle="table" date-striped="true" data-click-to-select="true" ></table>
	</div>	
	<div class="clearfix"></div>
</div>
</body>
</html>