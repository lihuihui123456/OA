function search() {
	//普通查询清空高级查询条件
	$("#ff")[0].reset();
	var title = $("#input-word").val();
	if (title == '请输入标题查询') {
		title = "";
	}else{
		title = window.encodeURI(window.encodeURI(title));
	}
	$("#tb_departments").bootstrapTable('refresh',{
		url : "bpmQuery/findTaskLeadList",
		query:{
			title : title
		}
	});
}

/**
 * 高级搜索模态框
 */
function advSearchModal(){
	var display =$('#searchDiv').css('display');
	if(display == "none") {
		$("#searchDiv").show();
	}else {
		$("#searchDiv").hide();
	}
}

$(document).ready(function() {
	laydate.skin('dahong');
	/**
	 * 高级搜索方法
	 */
	$("#advSearch").click(function(){
		if($("#advStartDate").val() != "" && $("#advEndDate").val() != "") {
			if($("#advEndDate").val() <= $("#advStartDate").val()) {
				layer.msg("结束时间必须大于开始时间！");
				return;
			}
		}
		if($("#advSendStartTime").val() != "" && $("#advSendEndTime").val() != "") {
			if($("#advSendEndTime").val() <= $("#advSendStartTime").val()) {
				layer.msg("结束时间必须大于开始时间！");
				return;
			}
		}
/*		$("#tb_departments").bootstrapTable('refresh',{
			url : "bpmQuery/findTaskLeadList",
			query:{
				query : $("#ff").serialize(),
			}
		});*/
		
		//$("#advSearchModal").modal('hide');
		submitForm();
	});
	
	/**
	 * 高级搜索重置
	 */
	$("#advSearchCalendar").click(function(){
/*		document.getElementById("ff").reset(); 
		$("#tb_departments").bootstrapTable('refresh',{
			url : "bpmQuery/findTaskLeadList",
			query:{
				query : $("#ff").serialize(),
			}
		});*/
		//$("#advSearchModal").modal('hide');
		clearForm();
	});
	
	/**
	 *  高级查询方法
	 */
	function submitForm() {
		$("#input-word").val("请输入标题查询");
		$('#tb_departments').bootstrapTable("refresh");
	}
	/**
	 *  高级重置方法
	 */
	function clearForm() {
		$("#ff")[0].reset();
		submitForm();
	}
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
	 * 高级搜索取消
	 */
	$("#modal_close").click(function(){
/*		document.getElementById("ff").reset(); 
		$("#tb_departments").bootstrapTable('refresh',{
			url : "bpmQuery/findTaskLeadList",
			query:{
				query : $("#ff").serialize(),
			}
		});*/
		$("#searchDiv").hide();
	});
	$('#tb_departments').bootstrapTable({
		url : 'bpmQuery/findTaskLeadList',
		method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		queryParams : function(params) {
			validateData();
		    var	title="";
			if($("#input-word").val()!="请输入标题查询"&&$("#input-word").val()!=""){
				title=title+$("#input-word").val();
				$("#ff")[0].reset();
			}
			 title=title+$("#advTitle").val();
			 title = window.encodeURI(window.encodeURI(title));
			var temp = {
				rows : params.limit,
				page : params.offset,
				title :title,
			    sortName:this.sortName,
                sortOrder:this.sortOrder,
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
		clickToSelect : true,
		uniqueId : "ID",
		showToggle : false,
		cardView : false,
		detailView : false,
		singleSelect:true,
		columns : [{
			field : 'id_',
			title : 'id_',
			visible : false
		}, {
			field : 'index',
			title : '序号',
			halign: 'center',
			align:'center',
			valign: 'middle',
			width: '7%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, 
		/*{
			field : 'serial_number',
			title : '流水号',
			align : 'left',
			valign: 'middle',
			width : '16%'
		},*/
		{
			field : 'BIZ_TITLE_',
			title : '标题',
			valign: 'middle',
			width: '36%',
			halign: 'left',
		    sortable: true,
		  /*  events: onTdClickTab,*/
            formatter: onTdClickTabFormatter
		}, {
			field : 'URGENCY_',
			title : '紧急程度',
			width: '11%',
			cellStyle : cellStyle,
			halign: 'center',
			align:'center',
			valign: 'middle',
			sortable: true,
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
			field : 'code',
			title : '待办类型',
			valign: 'middle',
			width: '11%',
			halign: 'center',
			align: 'center',
			sortable: true,
			formatter:function(value,row){
				if(value!=null){
					var sw = value.indexOf("10011002");
					var fw = value.indexOf("10011001");
					var ht = value.indexOf("10011004");
					var qj = value.indexOf("10011006");
					var xmjs = value.indexOf("10011003");
					if (sw==0) {
						return "收文";
					}else if(fw==0){
						return "发文";
					}else if(ht==0){
						return "合同";
					}else if(qj==0){
						return "请假";
					}else if(xmjs==0){
						return "项目建设";
					}
				     else{
						return "传阅件";
					}	
				}else{
					return "其它";
				}
			},
			cellStyle : cellStyle
		}, {
			field : 'USER_NAME',
			title : '委托人',
			width: '8%',
			halign: 'center',
			sortable: true
		},{
			field : 'CREATE_TIME_',
			title : '拟稿日期',
			width: '11%',
			cellStyle : cellStyle,
			halign: 'center',
			align:'center',
			valign: 'middle',
			sortable: true,
			formatter:function(value,row){
				if (value == null){
					return '-';
				}else{
					return value.substring(0,10);

				}
			}
		}, {
			field : 'END_TIME_',
			title : '送交时间',
			width: '11%',
			halign: 'center',
			cellStyle : cellStyle,
			align:'center',
			valign: 'middle',
			sortable: true,
 			formatter:function(value,row){
 				if (value == null){
					return '-';
				}else{
					return value.substring(0,10);

				}
		}
		}, {
			field : 'bizid',
			title : '业务id',
			visible : false,
			sortable: true
		}, {
			field : 'solId',
			title : '业务解决方案id',
			visible : false,
			sortable: true
		}, {
			field : 'proc_inst_id_',
			title : '流程实例id',
			visible : false,
			sortable: true
		}, {
			 field: 'operate',
             title: '操作',
             halign: 'center',
             width: '7%',
             align:'center',
             events: operateEvents,
             formatter: operateFormatter
		} ],
		onClickRow: function (row, tr) {
			var taskId = row.id_;
			var bizId = row.bizid;
			var solId=row.solId;
			var procInstId=row.proc_inst_id_;
			var doc_type=row.BIZ_TYPE_;
			var bid = '';
			var id=row.id_;
			var options='';
			var operateUrl = "bizRunController/getBizOperate?status=3&solId="+ solId + "&taskId=" + taskId + "&bizId=" + bizId;
		    options = {
			    "text" : "办理",
				"id" : "update"+ taskId,
				"href" : operateUrl,
				"pid" : window,
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
	/**
	 * 格式化标题
	 */
	if(value.length>60){
		return "<span class='tdClick' title='"+value+"'>"+value.substring(0,59)+"...</span>"
	}else{
		return "<span class='tdClick' title='"+value+"'>"+value+"</span>"
	}
}

/**
 * 操作格式化
 * @param value
 * @param row
 * @param index
 * @returns
 */
function operateFormatter(value, row, index) {
    return [
        '<a class="fordetails" href="javascript:void(0)" title="办理详情">',
        '<i class="fa fa-list"></i>',
        '</a>'
    ].join('');
}

/*
 * table 点击标题弹出查看/办理页面  ---目前不用
 */
window.onTdClickTab = {
	 'click .tdClick': function (e, value, row, index) {
		 	var taskId = row.id_;
			var bizId = row.bizid;
			var solId=row.solId;
			var procInstId=row.proc_inst_id_;
			var doc_type=row.BIZ_TYPE_;
			var bid = '';
			var id=row.id_;
			var options='';
	        if(doc_type=='阅件'){
				 options={
						"text":"查看-传阅事项",
						"id":"cysx_view_"+id,
						"href":"bpmCirculate/findCirculate?bizid="+bizId+"&&id="+id,
						"pid":window,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":true
				};
			}else {
				  options = {
					    "text" : "办理",
						"id" : "update"+ taskId,
						"href" : "bpmRunController/deal?bizId=" + bizId +'&taskId=' + taskId,
						"pid" : window,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":true
				};
			}
			window.parent.createTab(options); 
	 }
}
/*
 * 操作方法
 */
window.operateEvents = {
    'click .fordetails': function (e, value, row, index) {
    	stopPropagation();
    	var doc_type=row.BIZ_TYPE_;
		var bizid=row.bizid;
		var procInstId=row.proc_inst_id_;
			var options={
					"text":"办理详情",
					"id":"bizinfodetail"+bizid+"_dbsx",
					"href":"bpmRuBizInfoController/toDealDetialPage?bizId="+bizid,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
    }
};
function validateData() {
	if($("#advStartDate").val() != "" && $("#advEndDate").val() != "") {
		if($("#advEndDate").val() <= $("#advStartDate").val()) {
			layer.msg("结束时间必须大于开始时间！");
			return;
		}
	}
	if($("#advSendStartTime").val() != "" && $("#advSendEndTime").val() != "") {
		if($("#advSendEndTime").val() <= $("#advSendStartTime").val()) {
			layer.msg("结束时间必须大于开始时间！");
			return;
		}
	}
}

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