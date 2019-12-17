$(document).ready(function(){
	$('#tb_departments_advice').bootstrapTable({
		url : 'bpmMonitor/findAdviceList', 
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
					bizid: bizid
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
		uniqueId : "ID", 
		showToggle : false,
		cardView : false, 
		detailView : false,
		singleSelect:true,
		columns : [{
			checkbox : true,
			width : '40px'
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			valign: 'middle',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'task_name_',
			title : '环节名称',
			align : 'left',
			valign: 'middle'
		}, {
			field : 'user_id_',
			title : '办理用户',
			align : 'left',
			valign: 'middle'
		}, {
			field : 'message_',
			title : '意见',
			align : 'left',
			valign: 'middle'
		}, {
			field : 'createtime',
			title : '完成日期',
			align : 'center',
			valign: 'middle'
		}, {
			field : 'id',
			title : '注释表id',
			visible:false
		}]
	});
});