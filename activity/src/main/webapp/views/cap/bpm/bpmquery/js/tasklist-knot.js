function search() {
	var title = $("#input-word").val();
	if (title == '请输入标题查询') {
		title = "";
	}else{
		title = window.encodeURI(window.encodeURI(title));
	}
	$("#tb_departments").bootstrapTable('refresh',{
		url : "bpmQuery/findTaskKnotList",
		query:{
			title : title
		}
	});
}

$(document).ready(function() {
	$('#tb_departments').bootstrapTable({
		url : 'bpmQuery/findTaskKnotList',
		striped : true,
		cache : false,
		pagination : true,
		sortable : false,
		sortOrder : "asc",
		queryParams : function(params) {
			var temp = {
				rows : params.limit,
				page : params.offset,
				title : $("#input-word").val()=="请输入标题查询"?"":$("#input-word").val()
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
		columns : [ {
			radio : true,
			valign: 'middle',
			width : '40px'
		}, {
			field : 'id_',
			title : 'id_',
			visible : false
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			valign: 'middle',
			width : '6%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'serial_number',
			title : '流水号',
			align : 'left',
			valign: 'middle',
			width : '16%'
		}, {
			field : 'name_',
			title : '标题',
			width : '30%' ,
			valign: 'middle',
			align : 'left'
		},{
			field : 'doc_type',
			title : '待办类型',
			valign: 'middle',
			align : 'left',
			width : '9%',
			formatter:function(value,row){
				if (value == null){
					return '公文';
				}else if (value == "阅件"){
					return '阅件';
				}else if (value.substring(0,6) == 'sfw_fw'){
					return '发文';
				}else if (value.substring(0,6) == 'sfw_sw'){
					return '收文';
				}
			}
		} ,{
			field : 'urgency',
			title : '紧急程度',
			align : 'left',
			valign: 'middle',
			width : '9%',
			formatter:function(value,row){
				if (value == "1"){
					return '<span class="label label-success">平件</span>';
				}else if (value == "2"){
					return '<span class="label label-warning">急件</span>';
				}else if(value == "3"){
					return '<span class="label label-danger">特急</span>';
				}else if (value == '普通'){
					return '<span class="label label-success">平件</span>';
				}else if (value == '急件'){
					return '<span class="label label-warning">急件</span>';
				}else if (value == '特急'){
					return '<span class="label label-danger">特急</span>';
				}
			}
		}, {
			field : 'create_time',
			title : '拟稿日期',
			align : 'left',
			valign: 'middle'
		}, {
			field : 'deliver_time',
			title : '送交时间',
			align : 'left',
			valign: 'middle'
		}, {
			field : 'bizid',
			title : '业务id',
			visible : false
		}, {
			field : 'solId',
			title : '业务解决方案id',
			visible : false
		}, {
			field : 'proc_inst_id_',
			title : '流程实例id',
			visible : false
		} ],
		onDblClickRow : function(row, tr) {
			var taskId = row.id_;
			var bizId=row.bizid;
			var solId=row.solId;
			var procInstId=row.proc_inst_id_;
			var doc_type=row.doc_type;
			var id=row.id_;
			var options='';
			if(doc_type=='阅件'){
				 options={
						"text":"查看-传阅事项",
						"id":"cysx_view_"+id,
						"href":"bpmCirculate/findCirculate?bizid="+bizId+"&id="+id,
						"pid":window,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":true
				};
			}else{
				 options = {
							"text" : "办理",
							"id" : "update"+ taskId,
							//"href" : "bpmRuBizInfoController/deal?solId=" + solId + "&bizId=" + bizId +'&taskId=' + taskId + '&procInstId=' +procInstId,
							"href":"bpmRunController/deal?bizId="+ bizId+"&taskId="+taskId,
							"pid" : window
						};
			}
			window.parent.createTab(options);
		}
	});
	var oButtonInit = new ButtonInit();
	oButtonInit.Init();
});