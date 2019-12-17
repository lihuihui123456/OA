<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/views/aco/common/head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script type="text/javascript">
var attachbizid='';
var attach_title='';
$(function() {
	$('#seddreadList').bootstrapTable({
		url : 'earcSeddRedController/searchEarcSeddRedInfo', // 请求后台的URL（*）
		method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		sortable : false,
		sortOrder : "desc",
		queryParams : function(params) {
			var temp = {
				pageSize : params.limit, // 页面大小
				pageNum : params.offset
			// 页码
			};
			return temp;
		},
		sidePagination : "server",
		pageNumber : 1,
		pageSize : 10,
		pageList : [ 10, 25, 50, 100 ],
		search : false,
		strictSearch : false,
		showColumns : false,
		showRefresh : false,
		minimumCountColumns : 2,
		clickToSelect : true,
		uniqueId : "ID_",
		showToggle : false,
		cardView : false,
		detailView : false,
		maintainSelected : true,
		columns : [ {
			checkbox : true,
			align : 'center',
			valign : 'middle',
			field : 'checkStatus'
		}, {
			field : 'index',
			title : '序号',
			valign : 'middle',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'biz_title_',
			title : '提名',
			align : 'left',
			valign : 'middle',
			sortable : true
		}, {
			field : 'security_level',
			title : '密级',
			align : 'center',
			cellStyle : cellStyle,
			valign : 'middle',
			sortable : true
		}, {
			field : 'receive_user',
			title : '责任人',
			align : 'left',
			valign : 'middle',
			sortable : true
		} ],
		onClickRow : function(row, tr) {
		}
	});
});
function checknum(){
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
		layerAlert("请选择一条数据");
		return false;
	}else{
		taskid=obj[0].taskId;
		bizid=obj[0].bizId;
		return true;
	}
}

function connect(){
	if(checknum()){
		var obj =$('#tb_departments').bootstrapTable('getSelections');
		var options = {
			"text" : "查看",
			"id" : "view"+obj[0].bizId,
			"href" : "bpmRunController/view?isRefresh=false&bizId="+ obj[0].bizId+"&&taskId="+obj[0].taskId,
			"pid" : window.parent.parent
		};
		window.parent.parent.parent.createTab(options);		
	}
	
}

function fordetails(){
	if(checknum()){
		//myModeliframe
		var obj =$('#tb_departments').bootstrapTable('getSelections');
		var options = {
			"text" : "办理详情",
			"id" : "bizinfoview"+obj[0].bizId,
			"href" : "${ctx}/bpmRuBizInfoController/toDealDetialPage?procInstId="+obj[0].procInstId_,
			"pid" : window.parent.parent
		};
		window.parent.parent.parent.createTab(options);
	}
}
//保存关联信息
function saveAttach(){
	//获取当前选取的数据
	var obj =$('#seddreadList').bootstrapTable('getSelections');
	for(var i=0;i<obj.length;i++){
		attachbizid+= obj[i].id_+',';
		attach_title+=obj[i].biz_title_+',';
	}
	attachbizid=attachbizid.substr(0, attachbizid.length-1);
	attach_title=attach_title.substr(0, attach_title.length-1)
	//进行数据的保存
	$.ajax({
		type: "post",  
        url: "${ctx}/media/savefileattach",
        dataType: 'json',
        data: {
        	bizid:'${bizid}',
        	attachbizid:attachbizid,
        	attach_title:attach_title
        },
        success: function(data) {  
			window.parent.findattachFile();
        }
	});
	
}
</script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
</head>
<body>
	<div class="panel-body" style="padding-bottom:0px;border:0;'">
	<table id="seddreadList" data-toggle="table" date-striped="true"
			data-click-to-select="true"></table>
</div>
</body>
</body>

</html>