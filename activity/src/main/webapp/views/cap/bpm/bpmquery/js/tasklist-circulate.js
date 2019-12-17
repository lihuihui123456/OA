function search() {
	//普通查询清空高级查询条件
	$("#search_form")[0].reset();
	var title = $("#input-word").val();
	if (title == '请输入标题查询') {
		title = "";
	}else{
		title = window.encodeURI(window.encodeURI(title));
	}
	$("#tb_departments").bootstrapTable('refresh',{
		url : "bpmCirculate/findCirculateList",
		query:{
			title : $.trim(title)
		}
	});
}
/**
 * 高级搜索模态框
 */
function advSearchModal(){
	$('#advSearchModal').modal('show');
}
$(document).ready(function() {
	$('#tb_departments').bootstrapTable({
		url : 'bpmCirculate/findCirculateList',
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
				title=title+$("#input-word").val();
				$("#search_form")[0].reset();
			}
			 title=title+$("#title").val();
			 title = window.encodeURI(window.encodeURI(title));
	/*		if($("#input-word").val()!="请输入标题查询"&&$("#input-word").val()!=""){
				title=title+$("#input-word").val();
			}*/
			var level=$("#level").val();
			var isread=$("#isread").val();
			var circuStartTime=$("#circuStartTime").val();
			var circuEndTime=$("#circuEndTime").val();
			var circulationMan=$("#circulationMan").val();
			var temp = {
				rows : params.limit,
				page : params.offset,
				title :$.trim(title),
				circulationMan:circulationMan,
				level:level,
				isread:isread,
				circuStartTime:circuStartTime,
				circuEndTime:circuEndTime,
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
		singleSelect:true,
		columns : [ /*{
			radio : true,
			align : 'center',
			valign: 'middle',
		},*/ {
			field : 'id',
			title : 'id',
			visible : false
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
			valign: 'middle',
			align : 'left',
			width : '16%'
		}, */
		{
			field : 'biz_title',
			title : '标题',
			align : 'left',
			valign: 'middle',
			width : '28%',
			sortable : true,
/*			events: onTdClickTab,
*/	        formatter: onTdClickTabFormatter
		}, {
			field : 'urgency',
			title : '紧急程度',
			halign: 'center',
			align: 'center',
			cellStyle : cellStyle,
			width : '15%',
			valign: 'middle',
			sortable : true,
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
			field : 'isread',
			title : '办理状态',
			halign: 'center',
			cellStyle : cellStyle,
			align: 'center',
			valign: 'middle',
			width : '15%',
			sortable : true,
			formatter:function(value,row){
				if (value == "0")
					return '<span class="label label-danger">未阅读</span>';
				if (value == "1")
					return '<span class="label label-success">已阅读</span>';
			}
		}, {
			field : 'circulation_man',
			title : '传阅人',
			valign: 'middle',
			align : 'left',
			width : '10%',
			sortable : true,
		}, {
			field : 'circu_time',
			title : '传阅时间',
			align : 'center',
			cellStyle : cellStyle,
			valign: 'middle',
			width : '15%',
			sortable : true,
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
			visible : false
		}, {
			field : 'proc_inst_id_',
			title : '流程实例id',
			visible : false
		} , {
			 field: 'operate',
             title: '操作',
             align : 'center',
             events: operateEvents,
             formatter: operateFormatter
		}],
		onClickRow: function (row, tr) {
			var bizid = row.bizid;
			var id=row.id;
			var solId = row.solId;
			/*var operateUrl = "bizRunController/getBizOperate?status=4&solId="+ solId + "&bizId=" + bizid;*/
			var operateUrl="bpmCirculate/findCirculate?bizid="+bizid+"&id="+id+"&solId="+ solId;
			options={
					"text":"查看",
					"id":"cysx_view_"+id,
					"href":operateUrl,
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
	$("#advSearchCalendar").click(function(){
		$("#search_form")[0].reset();
		$('#advSearchModal').modal('hide');
		$('#tb_departments').bootstrapTable("refresh");
/*		$("#input-word").val("");
		$("#title").val("");
		$("#level").val("");
		$("#isread").val("");
		$("#circuStartTime").val("");
		$("#circuEndTime").val("");
		$("#circulationMan").val("");*/
	});
	
});
function validateData() {
	var startRegTime=$("#circuStartTime").val();
	var endRegTime=$("#circuEndTime").val();
	if(startRegTime!=""&&endRegTime!=""){
		if(startRegTime > endRegTime){
			jAlert("传阅开始时间不能大于结束时间");
			return;
		}
	}
}
function operateFormatter(value, row, index) {
    return [
        '<a class="fordetails" style="color:#167495;" href="javascript:void(0)" title="办理详情">',
        '<i class="fa fa-list"></i>',
        '</a>  ',
        '<a class="editSubject" style="color:#167495;" href="javascript:void(0)" title="跟踪事项">',
        '<i class="fa fa-flag"></i>',
        '</a>  '
    ].join('');
}

/*
 * 操作方法
 */
window.operateEvents = {
    'click .fordetails': function (e, value, row, index) {
    	stopPropagation();
		var bizid=row.bizid;
		var proc_inst_id_=row.proc_inst_id_;
			var options={
					"text":"办理详情",
					"id":"circulate_blxq_"+bizid+"_cysx",
					"href":"bpmRuBizInfoController/toDealDetialPage?bizId="+bizid,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
		
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
	}
}
/*
 * table 点击标题弹出查看/办理页面
 */
window.onTdClickTab = {
	 'click .tdClick': function (e, value, row, index) {
			var bizid = row.bizid;
			var id=row.id;
			var timestamp=new Date().getTime();
			options={
					"text":"查看-传阅事项",
					"id":"cysx_view_"+id+timestamp,
					"href":"bpmCirculate/findCirculate?bizid="+bizid+"&&id="+id,
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
	$("#input-word").val("请输入标题查询");
	$('#tb_departments').bootstrapTable("refresh");
}
/**
 *  高级查询方法
 */
function clearForm() {
	$("#search_form")[0].reset();
	submitForm();
}
