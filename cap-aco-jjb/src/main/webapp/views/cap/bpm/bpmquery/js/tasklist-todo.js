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
		url : "bpmQuery/findTaskTableToDoList",
		query:{
			title : title
		}
	});
}

/**
 * 高级搜索模态框
 */
function advSearchModal(){
	$('#advSearchModal').modal('show')
	$("#input-word").val('');
}

function showOrHide(){
	var display =$('#advSearchModal').css('display');
	if(display == "none") {
		$("#advSearchModal").show();
	}else {
		$("#advSearchModal").hide();
	}
}

function qxButton(){
	
	$("#advSearchModal").hide();	
}

$(document).ready(function() {
	laydate.skin('dahong');
	initBizTypeToSelect();
	/**
	 * 高级搜索方法
	 */
	$("#advSearch").click(function(){
	/*	if($("#advStartDate").val() != "" && $("#advEndDate").val() != "") {
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
		}*/
		
/*		$("#tb_departments").bootstrapTable('refresh',{
			url : "bpmQuery/findTaskTableToDoList",
			query:{
				query : $("#ff").serialize(),
			}
		});
		
		$("#advSearchModal").modal('hide');*/
		submitForm();
	});
	
	/**
	 * 高级搜索重置
	 */
	$("#advSearchCalendar").click(function(){
/*		document.getElementById("ff").reset(); 
		$("#tb_departments").bootstrapTable('refresh',{
			url : "bpmQuery/findTaskTableToDoList",
			query:{
				query : $("#ff").serialize(),
			}
		});
		$("#advSearchModal").modal('hide');*/
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
	var selectionIds = [];
	/**
	 * 表格数据初始化
	 */
	$('#tb_departments').bootstrapTable({
		url : 'bpmQuery/findTaskTableToDoList',
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
				title : title,
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
		singleSelect:false,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.id_, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [{
			checkbox : true,
			align : 'center',
			valign: 'middle',
			field: 'checkStatus',
			width: '4%',
		},{
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
			width: '25%',
			halign: 'left',
		    sortable: true,
		  /*  events: onTdClickTab,*/
            formatter: onTdClickTabFormatter
		}, {
			field : 'USER_NAME',
			title : '拟稿人',
			align : 'left',
			valign: 'middle',
			sortable: true,
			width : '8%'
		},{
			field : 'URGENCY_',
			title : '紧急程度',
			width: '11%',
			halign: 'center',
			cellStyle : cellStyle,
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
			width: '12%',
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
					var BIZ_TYPE_=row.BIZ_TYPE_;
					if( BIZ_TYPE_ == '阅件'){
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
					}else if (sw==0) {
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
			field : 'CREATE_TIME_',
			title : '拟稿日期',
			width: '12%',
			halign: 'center',
			align:'center',
			valign: 'middle',
			sortable: true,
			cellStyle : cellStyle,
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
			width: '12%',
			halign: 'center',
			align:'center',
			valign: 'middle',
			sortable: true,
			cellStyle : cellStyle,
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
             width: '13%',
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
	        if(doc_type=='阅件'){
				 options={
						"text":"查看-传阅事项",
						"id":"cysx_view_"+id,
						"href":"bpmCirculate/findCirculate?bizid="+bizId+"&&id="+id+"&solId="+ solId,
						"pid":window,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":true
				};
				 window.parent.createTab(options);
				 if(window.parent.setReadNotice){
					 window.parent.setReadNotice("cap-aco",id); 
				 }				
			}else if(doc_type=='传阅件'){
				 options={
							"text":"查看-传阅件",
							"id":"cyj"+id,
							"href":"circularize/queryBasicById_js?type=open&id="+id,
							"pid":window,
							"isDelete":true,
							"isReturn":true,
							"isRefresh":true
						};
					 window.parent.createTab(options);
					 if(window.parent.setReadNotice){
						 window.parent.setReadNotice("cap-aco",id); 
					 }				
				}else {
				var operateUrl = "bizRunController/getBizOperate?status=3&solId="+ solId + "&taskId=" + taskId + "&bizId=" + bizId;
				date = new Date().getTime();
				var options = {
					"text" : "办理",
					"id" : "deal"+bizId,
					"href" : operateUrl,
					"pid" : window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh": true
				};
				  window.parent.createTab(options);
				  if(window.parent.setReadNotice){
					  window.parent.setReadNotice("cap-aco",bizId); 
				  }				  
			}			
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
	if(value != null && value != ""){
		if(value.length>30){
			return "<span class='tdClick' title='"+value+"'>"+value.substring(0,29)+"...</span>"
		}else{
			return "<span class='tdClick' title='"+value+"'>"+value+"</span>"
		}
	}else{
		return "<span class='tdClick'>-</span>"
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
        '<a class="fordetails" style="color:#167495;" href="javascript:void(0)" title="办理详情">',
        '<i class="fa fa-list"></i>',
        '</a>  ',
        '<a class="editSubject" style="color:#167495;" href="javascript:void(0)" title="跟踪事项">',
        '<i class="fa fa-flag"></i>',
        '</a>  ',
        '<a class="attend" style="color:#167495;" href="javascript:void(0)" title="关注">',
        '<i class="fa fa-heart"></i>',
        '</a>',
    ].join('');
}

/**
 * 操作方法
 */
window.operateEvents = {
    'click .fordetails': function (e, value, row, index) {
    	stopPropagation();
		var bizid=row.bizid;
		var options={
				"text":"办理详情",
				"id":"bizinfodetail"+bizid+"_dbsx",
				"href":"bpmRuBizInfoController/toDealDetialPage?bizId="+bizid,
				"pid":window,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":false
		};
		window.parent.createTab(options);
    },
    'click .attend': function (e, value, row, index) {
    	stopPropagation();
		var bizid=row.bizid;
		$.ajax({
			type: "POST",
			async: false,
			url: "bpmAttend/doSaveAttend",
			data: {bizIds:bizid},
			success: function (datas) {
				if(datas=="success"){
					layerAlert("已添加关注!");
				}else{
					layerAlert("关注失败!");
				}
			}
		});
    },
'click .editSubject': function (e, value, row, index) {
	stopPropagation();
	/*getselectoption();*/
	var pids = "";
	pids += row.proc_inst_id_;
	$.ajax({
		type : "POST",
		url : "bpmTrace/doSaveTrace",
		data : {
			pids : pids
		},
		success : function(msg) {
			if (!!msg) {
				if ('true' == $.trim(msg)) {
					layerAlert("已加入跟踪事项.");
				} else {
					layerAlert("操作失败！");
				}
			}else {
				layerAlert("操作异常！");
			}
		}
	});

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

function initBizTypeToSelect(){
	$.ajax({
		type : "POST",
		url : "docquery/findAllSolCtlg",
		success : function(data) {
			var select = document.getElementById("advType");
			select.options.length=0; //把select对象的所有option清除掉
			var op1 = document.createElement("option"); // 新建OPTION (op)
			op1.setAttribute("value", ""); // 设置OPTION的 VALUE
			op1.setAttribute("selected", true);
			op1.appendChild(document.createTextNode("全部")); // 设置OPTION的text
			select.appendChild(op1); // 为SELECT 新建一 OPTION(op)
			for (var i = 0; i < data.length; i++) {
				//排除人员管理
				if(data[i].code!='100110051001'){
				var op = document.createElement("option"); // 新建OPTION (op)
				op.setAttribute("value", data[i].code); // 设置OPTION的 VALUE
				op.appendChild(document.createTextNode(data[i].solCtlgName_)); // 设置OPTION的text
				select.appendChild(op); // 为SELECT 新建一 OPTION(op)
				// select.options.remove(i); //把select对象的第i个option清除掉
				}
				}
		},
		error : function(data) {
			layerAlert("error:" + data.responseText);
		}
	});
}