var selectionIds = [];
function search() {
	var title = $("#input-word").val();
	if (title == '请输入标题查询') {
		title = "";
	}else{
		title = window.encodeURI(window.encodeURI(title));
	}
	document.getElementById("ff").reset();
	$("#tb_departments").bootstrapTable('refresh',{
		url : "bpmTrace/findTraceTaskList",
		query:{
			title : title
		}
	});
}

/**
 * 高级搜索模态框
 */
/*function advSearchModal(){
	$("#searchDiv").show();
}*/

function advSearchModal(){
	var display =$('#searchDiv').css('display');
	if(display == "none") {
		$("#searchDiv").show();
	}else {
		$("#searchDiv").hide();
	}
}

$(document).ready(function() {
	/**
    * 选中事件操作数组  
    */
    var union = function(array,ids){  
        $.each(ids, function (i, id_) {  
            if($.inArray(id_,array)==-1){  
                array[array.length] = id_;  
            }  
        });  
         return array;  
	};
	/**
     * 取消选中事件操作数组 
     */ 
    var difference = function(array,ids){  
        $.each(ids, function (i, id_) {  
             var index = $.inArray(id_,array);  
             if(index!=-1){  
                 array.splice(index, 1);  
             }  
         });  
        return array;  
	};    
	var _ = {"union":union,"difference":difference};

	/**
	 * bootstrap-table 记忆选中 
	 */
	$('#tb_departments').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
		var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
        return row.id_;  
    });  
    func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
    selectionIds = _[func](selectionIds, ids);   
	});
	
	/**
	 * 高级搜索方法
	 */
	$("#advSearch").click(function(){
		if($("#traceStartTime").val() != "" && $("#traceEndTime").val() != "") {
			if($("#traceEndTime").val() <= $("#traceStartTime").val()) {
				layer.msg("结束时间必须大于开始时间！");
				return;
			}
		}
		if($("#sendStartTime").val() != "" && $("#sendEndTime").val() != "") {
			if($("#sendEndTime").val() <= $("#sendStartTime").val()) {
				layer.msg("结束时间必须大于开始时间！");
				return;
			}
		}
		$("#input-word").val("");
		$("#tb_departments").bootstrapTable('refresh',{
			url : "bpmTrace/findTraceTaskList",
			query:{
				query : $("#ff").serialize(),
			}
		});
		//$("#searchDiv").hide();
	});
	
	/**
	 * 高级搜索重置
	 */
	$("#advSearchCalendar").click(function(){
		document.getElementById("ff").reset();
		$("#input-word").val("");
		$("#tb_departments").bootstrapTable('refresh',{
			url : "bpmTrace/findTraceTaskList",
			query:{
				query : $("#ff").serialize(),
			}
		});
		//$("#searchDiv").hide();
	});
	/**
	 * 高级搜索取消
	 */
	$("#modal_close").click(function(){
		$("#searchDiv").hide();
/*		$("#input-word").val("");
		$("#tb_departments").bootstrapTable('refresh',{
			url : "bpmTrace/findTraceTaskList",
			query:{
				query : $("#ff").serialize(),
			}
		});
		$("#searchDiv").hide();*/
	});
	
	
	$('#tb_departments').bootstrapTable({
		url : 'bpmTrace/findTraceTaskList',
		method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		sortable : true,
		sortOrder : "DESC",
		queryParams : function(params) {
			var temp = {
				rows : params.limit,
				page : params.offset,
				title : window.encodeURI(window.encodeURI($("#input-word").val()=="请输入标题查询"?"":$("#input-word").val())),
				sortName : this.sortName,
				sortOrder : this.sortOrder,
				query : $("#ff").serialize(),
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
		clickToSelect : false,
		uniqueId : "ID",
		showToggle : false,
		cardView : false,
		detailView : false,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.id_, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [ {
			checkbox : true,
			field: 'checkStatus',
			align : 'center',
			valign: 'middle',
			width : '4%'
		}, {
			field : 'id_',
			title : 'id_',
			visible : false
		}, {
			field : 'index',
			title : '序号',
			valign: 'middle',
			align : 'center',
			width : '6%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, 
		/*{
			field : 'serial_number',
			title : '流水号',
			valign: 'middle',
			align : 'left',
			width : '16%'
		}, */
		{
			field : 'BIZ_TITLE_',
			title : '标题',
			valign: 'middle',
			sortable : true,
			width : '43%',
			/*events: onTdClickTab,*/
            formatter: onTdClickTabFormatter,
			align : 'left'
		}, {
			field : 'URGENCY_',
			title : '紧急程度',
			cellStyle : cellStyle,
			align : 'center',
			valign: 'middle',
			sortable : true,
			width : '11%',
			formatter:function(value,row){
				if (value == "1"){
					return '<span class="label label-success">平件</span>';
				}else if (value == "2"){
					return '<span class="label label-warning">急件</span>';
				}else if(value == "3"){
					return '<span class="label label-danger">特急</span>';
				}
			}
		}, {
			field : 'STATE_',
			title : '办理状态',
			valign: 'middle',
			cellStyle : cellStyle,
			sortable : true,
			align : 'center',
			width : '11%',
			formatter:function(value,row){
				if (value == "0"){
					return '<span class="label label-danger">待发</span>';
				}else if (value == "2"){
					return '<span class="label label-success">办结</span>';
				}else if (value == "1"){
					return '<span class="label label-warning">在办</span>';
				}else if(value == "4"){
					return '<span class="label label-default">挂起</span>';
				}
			}
		}, {
			field : 'USER_NAME',
			title : '办理人',
			valign: 'middle',
			sortable : true,
			align : 'left',
			width : '8%',
			formatter:function(value,row){
				if(value==null||value==''){
					return value;
				}else if (value.length>6){
					return value.substring(0,6)+'...';
				}else{
					return value;
				}
			}
		}, 
		{
			field : 'sendTime',
			title : '送交时间',
			valign: 'middle',
			sortable : true,
			cellStyle : cellStyle,
			width : '11%',
			align : 'center',
 			formatter:function(value,row){
 				if (value == null){
					return '-';
				}else{
					return value.substring(0,10);

				}			
		}
		},
		/*{
			field : 'TRACE_TIME',
			title : '跟踪时间',
			valign: 'middle',
			cellStyle : cellStyle,
			formatter: traceTimeFormatter,
			width : '22%',
			align : 'center',
			sortable : true,
		}, */
		{
			field : 'proc_inst_id_',
			title : 'procinst_id',
			visible : false
		}, {
			field : 'bizid',
			title : '业务id',
			visible : false
		}, {
			field : 'solId',
			title : '业务解决方案id',
			visible : false
		}, {
			field : '',
			title : '操作',
			width : '8%',
			events: operateEvents,
			formatter: operateFormatter,
			valign: 'middle',
			align : 'center',
		},{
			field : 'taskid',
			title : '任务id',
			visible : false
		} ],
		onClickRow : function(row, tr) {
			var proc_inst_id_ = row.proc_inst_id_;
			var bizid=row.bizid;
			var taskid=row.taskid;
			var solId=row.solId;
			var operateUrl = "bizRunController/getBizOperate?solId="+ solId  + "&bizId=" + bizid + "&status=4";
			var options={
					"text":"查看-跟踪事项",
					"id":"bizinfoview"+bizid,
					"href": operateUrl,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
		}
	});
	var oButtonInit = new ButtonInit();
	oButtonInit.Init();
});
/**
 * 标题格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function onTdClickTabFormatter(value, row, index){
	if(value!=null){
		if(value.length>60){
			return "<span class='tdClick' title='"+value+"'>"+value.substring(0,59)+"...</span>"
		}else{
			return "<span class='tdClick' title='"+value+"'>"+value+"</span>"
		}
	}else{
		return "<span class='tdClick'>-</span>"
	}
}

function traceTimeFormatter(value, row, index){
	if(value!=null){
		if(value.length>20){
			return "<span class='tdClick' title='"+value+"'>"+value.substring(0,19)+"...</span>"
		}else{
			return "<span class='tdClick' title='"+value+"'>"+value+"</span>"
		}
	}else{
		return "<span class='tdClick'>-</span>"
	}
}

window.onTdClickTab = {
		 'click .tdClick': function (e, value, row, index) {
			var proc_inst_id_ = row.proc_inst_id_;
			var bizid=row.bizid;
			var taskid=row.taskid;
			var solId=row.solId;
			var operateUrl = "bizRunController/getBizOperate?status=4&solId="+ solId + "&bizId=" + bizid;
			var options={
					"text":"查看-跟踪事项",
					"id":"bizinfoview"+bizid,
					"href":operateUrl,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
		 }
	}
/**
 * 操作格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function operateFormatter(value, row, index) {
    return [
		'<a class="fordetails" style="color:#167495;" href="javascript:void(0)" title="办理详情">',
		'<i class="fa fa-list"></i>',
		'</a>',
    ].join('');
}
window.operateEvents = {
		'click .fordetails': function (e, value, row, index) {
			stopPropagation();
			var doc_type=row.BIZ_TYPE_;
			var bizid=row.bizid;
			var procInstId=row.proc_inst_id_;
				var options={
						"text":"办理详情",
						"id":"bizinfodetail"+bizid+"_gzlb",
						"href":"bpmRuBizInfoController/toDealDetialPage?bizId="+bizid,
						"pid":window,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":true
				};
				window.parent.createTab(options);
	    }
};
Date.prototype.Format = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}