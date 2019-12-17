function search() {
	$("#search_form")[0].reset();
	var title = $("#input-word").val();
	if (title == '请输入标题查询') {
		title = "";
	}else{
		title = title;
	}
	$("#tb_departments").bootstrapTable('refresh',{
		url : "bpmMonitor/findMonitorListPage",
		query:{
			title :$.trim(title) 
		}
	});
}


$(document).ready(function() {
	$('#tb_departments').bootstrapTable({
		url : 'bpmMonitor/findMonitorListPage',
		method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		sortable : true,
		sortOrder : "asc",
		queryParams : function(params) {
			validateData();						
		    var	title="";
			if($("#input-word").val()!="请输入标题查询"&&$("#input-word").val()!=""){
				title=$("#input-word").val();
				$("#search_form")[0].reset();
			}
			 title=title+$("#title").val();
			 title = title;
/*			if($("#input-word").val()!="请输入标题查询"&&$("#input-word").val()!=""){
				title=title+$("#input-word").val();
			}*/
			var state_ = $("#state").val();
			var level=$("#level").val();
			var circuStartTime=$("#circuStartTime").val();
			var circuEndTime=$("#circuEndTime").val();
			var userName=$("#userName").val();
			var draftDepartment=$("#draftDepartment").val();
			var vuserName=$("#vuserName").val();
			var temp = {
				rows : params.limit,
				page : params.offset,
				state_ : state_,
				title :$.trim(title),
				level:level,
				circuStartTime:circuStartTime,
				circuEndTime:circuEndTime,
				userName:userName,
			    draftDepartment:draftDepartment,
			    vuserName:vuserName,
				sortName:this.sortName,
			    sortOrder:this.sortOrder
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
		singleSelect:false,
		columns : [ {
			checkbox : true,
			align : 'center',
			valign: 'middle',
			width : '4%',
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			valign: 'middle',
			width: '7%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, 
		/*{
			field : 'serial_number',
			title : '流水号',
			align : 'center',
			valign: 'middle',
			width : '14%',
		}, */
		{
			field : 'name_',
			title : '标题',
			align : 'left',
			valign: 'middle',
			sortable : true,
			width : '35%',
/*			events: onTdClickTab,
*/	        formatter: onTdClickTabFormatter
		}, {
			field : 'urgency',
			title : '紧急程度',
			width : '11%',
			cellStyle : cellStyle,
			align : 'center',
			valign: 'middle',
			sortable : true,
			formatter:function(value,row){
				if (value == "1")
					return '<span class="label label-success">平件</span>';
				if (value == "2")
					return '<span class="label label-warning">急件</span>';
				if (value == "3")
					return '<span class="label label-danger">特急</span>';
				if (value == "普通")
					return '<span class="label label-success">平件</span>';
			}
		}, {
			field : 'state_',
			title : '办理状态',
			width : '11%',
			cellStyle : cellStyle,
			align : 'center',
			valign: 'middle',
			sortable : true,
			formatter:function(value,row){
				if (value == "0")
					return '<span class="label label-danger">未办</span>';
				if (value == "2")
					return '<span class="label label-success">办结</span>';
				if (value == "1")
					return '<span class="label label-warning">在办</span>';
				if	(value == "4")
					return '<span class="label label-default">挂起</span>';
			}
		}, {
			field : 'user_name',
			title : '拟稿人',
			align : 'left',
			width : '8%',
			valign: 'middle',
			sortable : true,
		}, 
		/*{
			field : 'draft_department',
			title : '拟稿部门',
			width : '15%',
			valign: 'middle',
			align : 'left',
			sortable : true,
		}, */
		{
			field : 'create_time',
			title : '拟稿日期',
			width : '12%',
			cellStyle : cellStyle,
			align : 'center',
			valign: 'middle',
			sortable : true,
		}, {
			field : 'vuser_name',
			title : '办理人',
			width : '8%',
			valign: 'middle',
			align : 'left',
			sortable : true,
		}, {
			field : 'bizid',
			title : '业务id',
			visible : false
		}, {
			field : 'taskid',
			title : '任务id',
			visible : false
		}, {
			field : 'proc_inst_id_',
			title : '流程实例id',
			visible : false
		}, {
			field : 'solId',
			title : '业务解决方案id',
			visible : false
		} , {
			 field: 'operate',
             title: '操作',
             width : '10%',
             align : 'center',
             events: operateEvents,
             formatter: operateFormatter
		} ],
		onClickRow: function (row, tr) {
			var bizid = row.bizid;
			var taskid = row.taskid;
			var proc_inst_id_=row.proc_inst_id_;
			var solId=row.solId;
			var timestamp=new Date().getTime();
			var operateUrl = "bizRunController/getBizOperate?status=4&solId="+ solId + "&bizId=" + bizid;
			var options={
					"text":"查看",
					"id":"bizinfoview"+bizid+timestamp,
					"href":operateUrl,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
		}
	});
});

/**
 * 高级搜索模态框
 */
function advSearchModal(){
	$('#advSearchModal').modal('show');
}

$(function(){
	laydate.skin('dahong');
	
	/**
	 * 列表回车触发搜索
	 */
	$('#input-word').bind('keypress', function (event) {
	    if (event.keyCode == "13") {
	    	search();
	       return false ;   
	    } 
	});
	/**
	 * 高级搜索方法
	 */
/*	$("#advSearch").click(function(){
		$('#advSearchModal').modal('hide');
		$("#input-word").val("");
		$('#tb_departments').bootstrapTable("refresh");
	});*/
	
	/**
	 * 高级搜索重置
	 */
/*	$("#advSearchCalendar").click(function(){
		$("#search_form")[0].reset();
		$('#advSearchModal').modal('hide');
		$('#tb_departments').bootstrapTable("refresh");
		$("#input-word").val("");
		$("#title").val("");
		$("#level").val("");
		$("#isread").val("");
		$("#circuStartTime").val("");
		$("#circuEndTime").val("");
		$("#circulationMan").val("");
	});*/
	
});
function validateData() {
	var startRegTime=$("#circuStartTime").val();
	var endRegTime=$("#circuEndTime").val();
	if(startRegTime!=""&&endRegTime!=""){
		if(startRegTime > endRegTime){
			jAlert("拟稿开始时间不能大于结束时间");
			return;
		}
	}
}
function operateFormatter(value, row, index) {
    return [
            '<a class="editSubject" style="color:#167495;" href="javascript:void(0)" title="修改意见">',
            '<i class="fa fa-file-text"></i>',
            '</a>  ',
        '<a class="fordetails" style="color:#167495;" href="javascript:void(0)" title="办理详情">',
        '<i class="fa fa-list"></i>',
        '</a>'
    ].join('');
}

/*
 * 操作方法
 */
window.operateEvents = {
	    'click .editSubject': function (e, value, row, index) {
	    	stopPropagation();
	    	var bizid=row.bizid;
			var proc_inst_id_=row.proc_inst_id_;
				if(row.state_=='2'){
					layerAlert("办理完结，无法修改意见!");
					return;
				}else{
					 var options={
							"text":"修改意见",
							"id":"bizinfocom"+bizid,
							"href":"bpmMonitor/toMonitorAdviceList?bizid="+bizid,
							"pid":window,
							"isDelete":true,
							"isReturn":true,
							"isRefresh":true
					};
					window.parent.createTab(options); 
				}
			
	    },
    'click .fordetails': function (e, value, row, index) {
    	stopPropagation();
    	var bizid=row.bizid;
		var proc_inst_id_=row.proc_inst_id_;
			var options={
					"text":"办理详情",
					"id":"bizinfodetail"+bizid+"_sxjk",
					"href":"bpmRuBizInfoController/toSxjkDealDetialPage?procInstId="+proc_inst_id_+"&&bizId="+ bizid,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
		
    }
};

/**
 * 标题格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function onTdClickTabFormatter(value, row, index){
	/**
	 * 格式化标题
	 */
	if(value==null){
		return "<span class='tdClick'>-</span>"
	}
	else if(value.length>30){
		return "<span class='tdClick' title='"+value+"'>"+value.substring(0,29)+"...</span>"
	}else{
		return "<span class='tdClick' title='"+value+"'>"+value+"</span>"
	}}
/*
 * table 点击标题弹出查看/办理页面
 */
window.onTdClickTab = {
	 'click .tdClick': function (e, value, row, index) {
			var bizid = row.bizid;
			var taskid = row.taskid;
			var proc_inst_id_=row.proc_inst_id_;
			var solId=row.solId;
		/*	var timestamp=new Date().getTime();*/
			var options={
					"text":"查看原文",
					"id":"bizinfoview"+bizid,
					"href":"bpmRunController/view?bizId="+ bizid+"&taskId="+taskid,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
	 }
}
$(function(){
	$("#advSearchModal").click(function() {
		var display =$('#advSearch').css('display');
		if(display == "none") {
			$("#advSearch").show();
		}else {
			$("#advSearch").hide();
		}
	})
		$("#modal_close").click(function(){
			$("#advSearch").hide();	
		})
});

	/**
 *  高级查询方法
 */
function submitForm() {
/*    $('#advSearchModal').modal('hide');
*/   $("#input-word").val("请输入标题查询");
	$("#tb_departments").bootstrapTable('refresh');
}
/**
 *  高级查询方法
 */
function clearForm() {
/*	 $('#advSearchModal').modal('hide');
*/		document.getElementById("search_form").reset();
        submitForm();
}