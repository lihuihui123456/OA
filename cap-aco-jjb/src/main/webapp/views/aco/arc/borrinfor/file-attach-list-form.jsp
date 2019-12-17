<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<%@ include file="/views/aco/common/head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script type="text/javascript">
var content='';
var taskid;
var attachbizid='';
var attach_title='';
var title="";

$(function(){
	$('#tb_departments').bootstrapTable({
		url : "${ctx}/borrInforConn/listAllBiz", 
		method : 'get', 
		toolbar : '#toolbar', 
		striped : true, 
		cache : false,
		pagination : true,
		sortable : false, 
		sortOrder : "asc", 
		queryParams :function(params) {
			var temp = {
					rows : params.limit, 
					page : params.offset,
					title:title
				};
				return temp;
			}, 
		sidePagination : "server", 
		pageNumber : 1, 
		pageSize : 10, 
		pageList : [ 10, 25, 50, 100 ], 
		strictSearch : false,
		showColumns : false, 
		showRefresh : false, 
		minimumCountColumns : 2, 
		clickToSelect : true, 
		uniqueId : "ID", 
		showToggle : false,
		cardView : false, 
		detailView : false,
		singleSelect:true,
		columns : [ {
			radio : true
		}, {
			field : 'index',
			title : '序号',
			formatter : function(value, row, index) {
				return index + 1;
			}
		},{
			field : 'arcId',
			title : '借阅主键',
			visible:false
		},{
			field : 'arcName',
			title : '标题',
			width : '30%'
		},{
			field : 'fileName',
			width : '50%' ,
			title : '附件名称'
		},{
			field : 'id',
			title : '附件主键',
			visible:false
		}]
	});
});

function search() {
	title = $("#input-word").val();
	if (title == '请输入标题查询') {
		title = "";
	}else{
		var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
		if(title.match(reg)==null){
			layerAlert("输入内容含有非法字符！");
			return;
		}
	}
	title = encodeURI(encodeURI(title));
	$("#tb_departments").bootstrapTable('refresh');
}

//保存关联信息
function saveAttach(){
	//获取当前选取的数据
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if(obj==null){
		return null;
	}
	var myArray=new Array();
	myArray[0]=obj[0].arcId;
	myArray[1]=obj[0].arcName;
	myArray[2]=obj[0].id;
	myArray[3]=obj[0].fileName;
	return myArray;
}
</script>

<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
<div class="panel-body" style="padding-bottom:0px;border:0;'">
	<!-- 搜索框 -->
	<div class="btn-div" id="search-div">
		<div class="input-group">
			<input type="text" id="input-word" class="validate[required] form-control input-sm" value="请输入标题查询" 
				onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
			<span class="input-group-btn">
				<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
					<i class="fa fa-search"></i> 查询
				</button>
			</span>
		</div>
	</div>
	<table  id="tb_departments" data-toggle="table" date-striped="true" data-click-to-select="true" ></table>
</div>
</body>
</html>