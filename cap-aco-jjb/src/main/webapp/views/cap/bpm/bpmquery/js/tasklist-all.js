function search() {
	var title = $("#input-word").val();
	if (title == '请输入标题查询') {
		title = "";
	}else{
		title = window.encodeURI(window.encodeURI(title));
	}
	document.getElementById("ff").reset();
	$("#tb_departments").bootstrapTable('refresh',{
		url : "bpmQuery/findAllTaskList",
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
	 * 高级搜索方法
	 */
	$("#advSearch").click(function(){
		if($("#creStartDate").val() != "" && $("#creEndDate").val() != "") {
			if($("#creEndDate").val() <= $("#creStartDate").val()) {
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
			url : "bpmQuery/findAllTaskList",
			query:{	
				query : $("#ff").serialize(),
			}
		});
	/*$.ajax({ 
        type: "post", 
       url: "bpmQuery/findAllTaskList", 
       cache:false, 
       data : $("#ff").serialize(),
       async:false, 
        dataType: ($.browser.msie) ? "text" : "xml", 
         success: function(xmlobj){ 
        } 

	});*/
		//$("#searchDiv").hide();
	});
	
	/**
	 * 高级搜索重置
	 */
	$("#advSearchCalendar").click(function(){
		document.getElementById("ff").reset(); 
		$("#input-word").val("");
		/*$("#advTitle").val("");
		$("#advLevel").options[""].selected; 
		$("#advType").options[""].selected; 
		$("#advStartDate").val("");
		$("#advEndDate").val("");
		$("#advSendStartTime").val("");
		$("#advSendEndTime").val("");*/
		$("#tb_departments").bootstrapTable('refresh',{
			url : "bpmQuery/findAllTaskList",
			query:{
				query : $("#ff").serialize(),
			}
		});
	});
	/**
	 * 高级搜索取消
	 */
	$("#modal_close").click(function(){
/*		document.getElementById("ff").reset(); 
		$("#input-word").val("");
		$("#tb_departments").bootstrapTable('refresh',{
			url : "bpmQuery/findAllTaskList",
			query:{
				query : $("#ff").serialize(),
			}
		});*/
		$("#searchDiv").hide();
	});
	
	$('#tb_departments').bootstrapTable({
		url : 'bpmQuery/findAllTaskList',
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
		clickToSelect : true,
		uniqueId : "id_",
		showToggle : false,
		cardView : false,
		detailView : false,
		singleSelect:true,
		columns : [ /*{
			radio : true,
			align : 'center',
			valign: 'middle',
		}, */{
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
		}, 
		/*{
			field : 'serial_number',events: operateEvents ：给按钮注册事件
											formatter: operateFormatter：表格中增加按钮
			title : '流水号',
			valign: 'middle',
			align : 'left',
			width : '16%'
		}, */
		{
			field : 'BIZ_TITLE_',
			title : '标题',
			valign: 'middle',
			align : 'left',
			halign: 'left',
			sortable : true,
			width : '25%',
			/*events: onTdClickTab,*/
            formatter: onTdClickTabFormatter,
		}, {
			field : 'USER_NAME',
			title : '拟稿人',
			width : '8%',
			align : 'left',
			halign: 'left',
			valign: 'middle',
			sortable : true,
			align : 'left',
		}, {
			field : 'URGENCY_',
			title : '紧急程度',
			align : 'center',
			cellStyle : cellStyle,
			halign: 'center',
			valign: 'middle',
			width : '10%',
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
			field : 'code',
			title : '文件类型',
			valign: 'middle',
			width: '9%',
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
						return "--";
					}	
				}else{
					return "其它";
				}
	
			},
			cellStyle : cellStyle
		}, {
			field : 'STATE_',
			title : '办理状态',
			cellStyle : cellStyle,
			width : '9%',
			align : 'center',
			halign: 'center',
			valign: 'middle',
			sortable : true,
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
			field : 'CREATE_TIME_',
			title : '拟稿日期',
			align : 'center',
			cellStyle : cellStyle,
			halign: 'center',
			sortable : true,
			width : '12%',
			valign: 'middle',
		}, {
			field : 'END_TIME_',
			title : '办理时间',
			cellStyle : cellStyle,
			valign: 'middle',
			align : 'center',
			halign: 'center',
			width : '12%',
			align : 'center',
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
			title : 'proc_inst_id_',
			visible : false
		}, {
			field : 'solId',
			title : '业务解决方案id',
			visible : false
		},{
			field : '',
			title : '操作',
			width : '11%',
			events: operateEvents,
			formatter: operateFormatter,
			valign: 'middle',
			align : 'center',
			halign: 'center',
			} ] ,
			onClickRow: function (row, tr) {
				var bizid=row.bizid;
				var solId=row.solId;
				var operateUrl = "bizRunController/getBizOperate?status=4&solId="+ solId + "&bizId=" + bizid;
				var options={
						"text":"查看-所有事项",
						"id":"bizinfoview"+bizid,
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
	if(value!=null){
		if(value.length>30){
			return "<span class='tdClick' title='"+value+"'>"+value.substring(0,29)+"...</span>"
		}else{
			return "<span class='tdClick' title='"+value+"'>"+value+"</span>"
		}
	}else{
		return "<span class='tdClick'>-</span>"
	}
}
window.onTdClickTab = {
	 'click .tdClick': function (e, value, row, index) {
		var taskid = row.id_;
		var bizid=row.bizid;
		var proc_inst_id_=row.proc_inst_id_;
		var solId=row.solId;
		var operateUrl = "${ctx}/bizRunController/getBizOperate?status=4&solId="+solId+ "&bizId=" + bizId;
		var options={
				"text":"查看-所有事项",
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
		'</a>  ',
		 '<a class="editSubject" style="color:#167495;" href="javascript:void(0)" title="跟踪事项">',
         '<i class="fa fa-flag"></i>',
         '</a>  ',
         '<a class="attend" style="color:#167495;" href="javascript:void(0)" title="关注">',
         '<i class="fa fa-heart"></i>',
         '</a>',
    ].join('');
}
window.operateEvents = {
	'click .fordetails': function (e, value, row, index) {
		stopPropagation();
		var bizid=row.bizid;
		var options={
			"text":"办理详情",
			"id":"bizinfodetail"+bizid+"_sysx",
			"href":"bpmRuBizInfoController/toDealDetialPage?bizId="+bizid,
			"pid":window,
			"isDelete":true,
			"isReturn":true,
			"isRefresh":true
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
		if(row.state_=='2'){
			layerAlert("有信息办理完结,无法进行跟踪");
			return;
		}
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
function jsonTimeStamp(milliseconds) {
    if (milliseconds != "" && milliseconds != null
            && milliseconds != "null") {
        var datetime = new Date();
        datetime.setTime(milliseconds);
        var year = datetime.getFullYear();
        var month = datetime.getMonth() + 1 < 10 ? "0"
                + (datetime.getMonth() + 1) : datetime.getMonth() + 1;
        var date = datetime.getDate() < 10 ? "0" + datetime.getDate()
                : datetime.getDate();
        var hour = datetime.getHours() < 10 ? "0" + datetime.getHours()
                : datetime.getHours();
        var minute = datetime.getMinutes() < 10 ? "0"
                + datetime.getMinutes() : datetime.getMinutes();
        var second = datetime.getSeconds() < 10 ? "0"
                + datetime.getSeconds() : datetime.getSeconds();
        return year + "-" + month + "-" + date + " " + hour + ":" + minute
                + ":" + second;
    } else {
        return "";
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