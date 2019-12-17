/*
 * 业务模块-列表页公共js
 * 
 * 实现的函数：
 * 	业务拟稿
 * 	业务修改
 * 	业务查看
 * 	业务删除
 * 	业务查询
 */
var date;
var title = "";//搜索参数
var state = "";//公文状态
var selectionIds = [];//记忆选中
var selectionIdsDB = [];//记忆选中待办
var startTime = $("#startTime").val();
var endTime = $("#endTime").val();
function initDataTable() {
	$('#bizInfoList').bootstrapTable({
		url : 'bpmRuBizInfoController/findBpmRuBizInfoBySolId', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable: true,//是否启用排序
		sortOrder : "DESC", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					rows  : params.limit, // 页面大小
					page : params.offset,
					solId : solId,
					state : state,
					title : $("#input-word").val()=="请输入标题查询"?"":$("#input-word").val(),
					sortName : this.sortName,
					sortOrder : this.sortOrder,
					modCode:modCode,
					query : $("#search_form").serialize()
				};
				return temp;
			},// 传递参数（*）
        sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		pageList : [ 10, 25, 50, 100 ], // 可供选择的每页的行数（*）
		clickToSelect : true, // 是否启用点击选中行
        idField : "ID_",  //指定主键列
        maintainSelected:true,
        responseHandler:function(res){
        	$.each(res.rows, function (i, row) {
        		 row.checkStatus  = $.inArray(row.ID_, selectionIds) !== -1;
        		});
        		return res;	
        },
        onClickRow : function(row, tr) {
        	var bizId = row.ID_;
     		var procInstId = row.PROC_INST_ID_;
     		var tname = "修改";
     		var status = "2";//编辑
     		if(procInstId!=null&&procInstId!="") {
     			tname = "查看";
     			status = "4";
     		}
     		var operateUrl = "bizRunController/getBizOperate?solId="+ row.SOL_ID_  + "&bizId=" + bizId + "&status=" + status;
     		var options = {
     			"text" : tname,
     			"id" : "view"+bizId,
     			"href" : operateUrl,
     			"pid" : window,
     			"isDelete":true,
     			"isReturn":true,
     			"isRefresh":true
     		};
     		window.parent.parent.createTab(options);
		}
	});
}
function initDataTableDB() {
	$('#tapList').bootstrapTable({
		url : 'bpmQuery/findTaskToDoListBySolId', // 请求后台的URL（*）
		method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		queryParams : function(params) {
			validateData();
		    var	title="";
			if($("#input-word-fw").val()!="请输入标题查询"&&$("#input-word-fw").val()!=""){
				title=title+$("#input-word-fw").val();
				$("#search_form_fw")[0].reset();
			}
			title = title + $("#advTitle").val();
			title = window.encodeURI(window.encodeURI(title));
			var temp = {
				rows : params.limit,
				page : params.offset,
				solId : solId,
				title : title,
			    sortName:this.sortName,
                sortOrder:this.sortOrder,
                query : $("#search_form_fw").serialize()
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
		uniqueId : "bizid",
		showToggle : false,
		cardView : false,
		detailView : false,
		singleSelect:false,
		maintainSelected:true,
		responseHandler:function(res){
			if(null != res && null != res.rows){
				$.each(res.rows, function (i, row) {
					 row.checkStatus  = $.inArray(row.bizid, selectionIdsDB) !== -1;
				});
			}
			return res;	
		},
		columns : [{
			checkbox : true,
			align : 'center',
			valign: 'middle',
			field: 'checkStatus',
			width: '20px'
		},{
			field : 'bizid',
			title : 'bizid',
			visible : false
		}, /*{
			field : 'index',
			title : '序号',
			halign: 'center',
			align:'center',
			valign: 'middle',
			width: '30px',
			formatter : function(value, row, index) {
				return index + 1;
			}
		},*/ 
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
			width: '60%',
			halign: 'left',
		    sortable: true,
		  /*  events: onTdClickTab,*/
            formatter: onTdClickTabFormatter
		}, {
			field : 'USER_NAME',
			title : '上环节处理人',
			align : 'left',
			valign: 'middle',
			width : '12%'
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
					return '<span class="label label-success">一般</span>';
				}else if (value == "2"){
					return '<span class="label label-warning">紧急</span>';
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
			field : 'CREATE_TIME_',
			title : '拟稿日期',
			width: '11%',
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
		}, /*{
			field : 'END_TIME_',
			title : '送交时间',
			width: '120px',
			halign: 'center',
			align:'center',
			valign: 'middle',
			sortable: true,
			cellStyle : cellStyle
		}, */{
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
		}/*, {
			 field: 'operate',
             title: '操作',
             halign: 'center',
             width: '60px',
             align:'center',
             events: operateEvents,
             formatter: operateFormatter
		}*/ ],
		onClickRow: function (row, tr) {
			var taskId = row.id_;
			var bizId = row.bizid;
			var solId=row.solId;
			var procInstId=row.proc_inst_id_;
			var bid = '';
			var id=row.id_;
			var options='';
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
	});
}
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
		if(value.length>50){
			return "<span class='tdClick' title='"+value+"'>"+value.substring(0,45)+"...</span>";
		}else{
			return "<span class='tdClick' title='"+value+"'>"+value+"</span>";
		}
	}else{
		return "<span class='tdClick'>-</span>"
	}
}

window.onTdClickTab = {
	 'click .tdClick': function (e, value, row, index) {
		var bizId = row.ID_;
 		var procInstId = row.PROC_INST_ID_;
 		var tname = "修改";
 		var status = "2";//编辑
 		if(procInstId!=null&&procInstId!="") {
 			tname = "查看";
 			status = "4";
 		}
 		var operateUrl = "bizRunController/getBizOperate?solId="+ row.SOL_ID_  + "&bizId=" + bizId + "&status=" + status;
 		var options = {
 			"text" : tname,
 			"id" : "view"+bizId,
 			"href" : operateUrl,
 			"pid" : window.parent,
 			"isDelete":true,
 			"isReturn":true,
 			"isRefresh":true
 		};
 		window.parent.parent.createTab(options);
	 }
}

function search() {
	title = $("#input-word").val();
	if (title == '请输入标题查询'||title == "") {
		title = "";
	}else{
		$("#search_form")[0].reset();
	}
	if(startTime != "" && endTime != "") {
		if(endTime <= startTime) {
			layer.msg("结束时间必须大于开始时间！");
			return;
		}
	}
	$("#bizInfoList").bootstrapTable('refresh',{
		url : "bpmRuBizInfoController/findBpmRuBizInfoBySolId",
		query:{
			title : title,
			state : state,
			modCode:modCode
		}
	});
}
//收文待办查询
function search_db() {
	//普通查询清空高级查询条件
	document.getElementById("search_form_fw").reset();
	var swzh = $("#input-word-fw").val();
	if (swzh == '请输入标题查询') {
		swzh = "";
	}
	$("#tapList").bootstrapTable('refresh',{
		url : "bpmQuery/findTaskToDoListBySolId",
		query:{
			solId : solId,
			title : swzh
		}
	});
}
function showOrHideFw() {
	var display = $('#upperSearchFw').css('display');
	if (display == "none") {
		$("#upperSearchFw").show();
	} else {
		$("#upperSearchFw").hide();
	}
}
/**
 *  高级查询方法
 */
function submitFormDB() {
	$("#input-word-fw").val("请输入标题查询");
	$('#tapList').bootstrapTable("refresh");
}
//高级搜索
function submitFormsw() {
	submitFormDB();
	$('#upperSearchFw').modal('hide');
}

//重置高级搜索表单
function clearFormsw() {
	$("#search_form_fw")[0].reset();
	submitFormDB();
}

//取消
function qxButtonSw() {
	$("#upperSearchFw").hide();
}
$(function(){
	/**
    * 选中事件操作数组  
    */
    var union = function(array,ids){  
        $.each(ids, function (i, ID_) {  
            if($.inArray(ID_,array)==-1){  
                array[array.length] = ID_;  
            }  
        });  
        return array;  
	};
	/**
     * 取消选中事件操作数组 
     */ 
    var difference = function(array,ids){  
        $.each(ids, function (i, ID_) {  
             var index = $.inArray(ID_,array);  
             if(ID_!=-1){  
                 array.splice(index, 1);  
             }  
         });  
        return array;  
	};    
	var _ = {"union":union,"difference":difference};

	/**
	 * bootstrap-table 记忆选中 
	 */
	$('#bizInfoList').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
	var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
        return row.ID_;  
    });  
    func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
    selectionIds = _[func](selectionIds, ids);   
	});
	/**
	 * bootstrap-table 记忆选中待办 
	 */
	$('#tapList').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
	var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
        return row.ID_;  
    });  
    func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
    selectionIdsDB = _[func](selectionIdsDB, ids);   
	});
	//加载列表数据
	initDataTable();
	initDataTableDB();
	//页签切换
	$('#myTab a').click(function(e) {
		e.preventDefault()
		$(this).tab('show')
	});
	/*注册按钮事件*/
	// 删除按钮
	$("#btn_delete").click(function() {
		var selectRow = $("#bizInfoList").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return;
		}
		var bizIds = [];
		var state = '';
		var flag = true;
		$(selectRow).each(function(index) {
			bizIds[index] = selectRow[index].ID_;
			/*state = selectRow[index].STATE_;
			if(state == '0'){
			}else {
				flag = false;
			}*/
		});
		if(flag){
			layer.confirm('确定删除吗？', {
				btn : [ '是', '否' ]
				// 按钮
				}, function(index) {
					$.ajax({
						url : 'bpmRuBizInfoController/doDeleteBpmRuBizInfoEntitysByBizIds',
						dataType : 'text',
						data : {
							'bizIds' : bizIds
						},
						success : function(data) {
							if (data == 'Y') {
								layerAlert("删除成功！");
								//$("#bizInfoList").bootstrapTable('refresh');
								refreshTable('bizInfoList','bpmRuBizInfoController/findBpmRuBizInfoBySolId')
							} else {
								layerAlert("删除失败！");
							}
						}
					});
					layer.close(index);
				}, function() {
					return;
			});
		}else{
			layerAlert("只能删除未发的记录！");
		}
	});
	
	// 待发
	$("#btn_ready").click(function() {
		state="ready";
		$("#bizInfoList").bootstrapTable('refresh');
		state="";
	});
	
	// 已发
	$("#btn_already").click(function() {
		state="already";
		$("#bizInfoList").bootstrapTable('refresh');
		state="";
	});
	
	
	//传阅按钮事件
	$("#btn_circulation").click(function() {
		var obj = $("#bizInfoList").bootstrapTable('getSelections');
		if (obj.length != 1) {
			layerAlert("请选择一条数据");
			return false;
		}
		$("#circulation_iframe").attr("src","treeController/zMultiPurposeContacts?state=1");
		$("#circulationDiv").modal('show');
	});
	//撤回按钮操作
	$("#btn_recall").click(function() {
		var obj =$("#bizInfoList").bootstrapTable("getSelections");
		var bizid=obj[0].ID_;
		if (obj.length != 1) {
			layerAlert("请选择一条数据");
			return false;
		}
		if(obj[0].STATE_ != '1'){
			layerAlert("请选择未办结数据");
			return false;
		}
		
		var taskId = obj[0].TASK_ID;
		var procInstId = obj[0].PROC_INST_ID_;
		$.ajax({
			url : "bpmRunController/processRecall",
			type : "post",
			dataType : "json",
			data : {
				"taskId" : taskId,
				"procInstId" : procInstId
			},
			success : function(data) {
				if(data) {
					layerAlert(data.msg);
					//撤销流程后需要恢复请假和调休的天数
					if(data.flag == 'success'){
					$.ajax({
						type: "post",
						url: "${ctx}/leaveManager/resetLeaveInfo",
						dataType: 'json',
						data: {'bizId':bizid},
						success: function (data) {}
					});
					}
				}
			}
		});
	});
	//跟踪按钮操作
	$("#btn_editSubject").click(function() {
		stopPropagation();
		/*getselectoption();*/
		var obj =$("#bizInfoList").bootstrapTable("getSelections");
		if (obj.length != 1) {
			layerAlert("请选择一条数据");
			return false;
		}
		var pids = "";
		pids += obj[0].PROC_INST_ID_;
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
		
	});
	//关注按钮操作
	$("#btn_attend").click(function() {
		var obj =$("#bizInfoList").bootstrapTable("getSelections");
		if (obj.length != 1) {
			layerAlert("请选择一条数据");
			return false;
		}
    	stopPropagation();
		var bizid=obj[0].ID_;
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
		
	});
	//待办关注按钮操作
	$("#btn_attend1").click(function() {
		var obj =$("#tapList").bootstrapTable("getSelections");
		if (obj.length != 1) {
			layerAlert("请选择一条数据");
			return false;
		}
    	stopPropagation();
		var bizid=obj[0].bizid;
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
		
	});
	/* 按钮方法结束 */
});

/******************格式化方法********************/
 function indexFormatter(value, row, index) {
	return index + 1;
 }
	
 function formatterTime (value, row, index) {
	 if(value!=null){
		 return value.substr(0,10); 
	 }else{
		 return value; 
	 }	
}
function formatterState (value, row, index) {
	if (value == "0"){
		return '<span class="label label-danger">待发</span>';
	}else if (value == "1"){
		return '<span class="label label-warning">在办</span>';
	}else if (value == "2"){
		return '<span class="label label-success">办结</span>';
	}else if(value == "4"){
		return '<span class="label label-default">挂起</span>';
	}else{
		return "--";
	}
}

function formatterUrgency (value, row, index) {
	if (value == "1"){
		return '<span class="label label-success">平件</span>';
	}else if (value == "2"){
		return '<span class="label label-warning">急件</span>';
	}else if(value == "3"){
		return '<span class="label label-danger">特急</span>';
	}else{
		return "--";
	}
}

//传阅确定按钮
function circulation() {
	var selectRow = $("#bizInfoList").bootstrapTable('getSelections');
    var bizId=selectRow[0].ID_
	var users = document.getElementById("circulation_iframe").contentWindow.doSaveSelectUser();
	var viewUserIds = users[0];
	$.ajax({
		type: 'post',  
        url: 'bpmRuBizInfoController/doSaveBizGwCircularsEntitys',
        dataType: 'json',
        data: {
        	'bizId' : bizId,
        	'viewUserIds' : viewUserIds
        },
        success: function(data) {
        	if(data){
	        	layerAlert("传阅成功！");
	        	$('#circulationDiv').modal('hide');
        	}else {
	        	layerAlert("传阅失败！");
        	}
        }
	});
}
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