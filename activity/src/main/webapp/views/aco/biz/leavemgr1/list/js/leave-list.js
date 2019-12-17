//翻页选中数组
var selectionIds = [];
var selectionIdsDB = [];//记忆选中待办
$(function() {
	initTable();
	initDataTableDB();
	$("#btn_delete").css("display","none");
	/**
	 * 选中事件操作数组  
	 */
	 var union = function(array,ids){  
	     $.each(ids, function (i, LEAVE_ID) {  
	         if($.inArray(LEAVE_ID,array)==-1){  
	             array[array.length] = LEAVE_ID;  
	         }  
	     });  
	      return array;  
	};
	
	/**
	 * 取消选中事件操作数组 
	 */
	var difference = function(array,ids){  
         $.each(ids, function (i, LEAVE_ID) {  
              var index = $.inArray(LEAVE_ID,array);  
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
	$('#leaveTable').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
		var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
			return row.id;  
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
	/**
	 * 列表回车触发搜索
	 */
	$('#input-word').bind('keypress', function (event) {
	    if (event.keyCode == "13") {
	    	search();
	       return false ;   
	    } 
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
	$("#btn_delete_pers").click(function(){
		if (selectionIds.length == 0) {
			layerAlert("请选择操作项！");
			return;
		}
		layer.confirm('确定删除吗？', {
			btn : [ '是', '否' ]
			// 按钮
			}, function(index) {
				$.ajax({
					url : 'leaveController/doDelLeaveInfoByLeaveIds',
					dataType : 'text',
					data : {
						'leaveIds' : selectionIds
					},
					success : function(data) {
						if (data == 'Y') {
							layerAlert("删除成功！");
							refreshTable("leaveTable","leaveController/findLeaveDateByQueryParams");
						} else {
							layerAlert("删除失败！");
						}
						selectionIds =[];
					}
				});
				layer.close(index);
			}, function() {
				return;
		});
	});
	// 删除按钮
	$("#mt_btn_del").click(function() {
		var selectRow = $("#leaveTable").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}
		var ids = [];
		var flag = true;
		$(selectRow).each(function(index) {
			ids[index] = selectRow[index].id;
		/*	if(selectRow[index].state_=='0'){
			}else{
				flag = false;
			}*/
		});
		if(flag){
			layer.confirm('确定删除吗？', {
				btn : [ '是', '否' ]
			}, function() {
				$.ajax({
					url : 'leaveManager/doDelLeaveInfo',
					dataType : 'json',
					data : {
						ids : ids
					},
					success : function(data) {
						if(data != 0){
							layerAlert("删除失败");
						} else{
							layerAlert("删除成功");
							refreshTable("leaveTable","leaveManager/findAllLeaveInfo");
						}
					},
					error : function(result) {
						layerAlert(result);
					}
				});
			});
		}else{
			layerAlert("已送交的记录不能删除！");
		}		
	});
	// 删除按钮
	$("#mt_btn_delete").click(function() {
		var selectRow = $("#leaveTable").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}
		var ids = [];
		$(selectRow).each(function(index) {
			ids[index] = selectRow[index].id;
		});
			layer.confirm('确定删除吗？', {
				btn : [ '是', '否' ]
			}, function() {
				$.ajax({
					url : 'leaveManager/doDelLeaveInfo',
					dataType : 'json',
					data : {
						ids : ids
					},
					success : function(data) {
						if(data != 0){
							layerAlert("删除失败");
						} else{
							layerAlert("删除成功");
							refreshTable("leaveTable","leaveManager/findAllLeaveInfo");
						}
					},
					error : function(result) {
						layerAlert(result);
					}
				});
			});	
	});
	/**
	 * 高级搜索方法
	 */
	$("#advSearch").click(function(){
		$("#leaveTable").bootstrapTable('refresh',{
			url : "leaveController/findLeaveDateByQueryParams",
			query:{
				queryParams : $("#ff").serialize(),
			}
		});
		$("#advSearchModal").modal('hide');
	});
	
	/**
	 * 高级搜索重置
	 */
	$("#advSearchCalendar").click(function(){
		document.getElementById("ff").reset();
		$("#draftUserId_").val('');
		$("#leaveTable").bootstrapTable('refresh',{
			url : "leaveController/findLeaveDateByQueryParams",
			query:{
				queryParams : $("#ff").serialize(),
			}
		});
		$("#advSearchModal").modal('hide');
	});
	
});

function qxButton(){
	$("#advSearchModal").hide();	
}
var userName = "";
/**
 * 表格数据初始化
 */
var solId;
function initTable() {
	$('#leaveTable').bootstrapTable({
			url : 'leaveManager/findAllLeaveInfo', // 请求后台的URL（*）
			method : 'get', // 请求方式（*）
			toolbar : '#toolbar', // 工具按钮用哪个容器
			striped : true, // 是否显示行间隔色
			cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			pagination : true, // 是否显示分页（*）
			sortable : false, // 是否启用排序
			sortOrder : "asc", // 排序方式
			queryParams : function(params) {
				var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
						rows : params.limit, // 页面大小
						page : params.offset, // 页码
						searchInfo : $("#input-word").val()=="请输入姓名查询"?"":$("#input-word").val()
					};
					return temp;
				}, // 传递参数（*）
			sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
			pageNumber : 1, // 初始化加载第一页，默认第一页
			pageSize : 10, // 每页的记录行数（*）
			pageList : [ 10, 25, 50, 100 ], // 可供选择的每页的行数（*）
			search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
			strictSearch : false,
			showColumns : false, // 是否显示所有的列
			showRefresh : false, // 是否显示刷新按钮
			minimumCountColumns : 2, // 最少允许的列数
			singleSelect : false,
			clickToSelect : true, // 是否启用点击选中行
			uniqueId : "id", // 每一行的唯一标识，一般为主键列
			showToggle : false, // 是否显示详细视图和列表视图的切换按钮
			cardView : false, // 是否显示详细视图
			detailView : false, // 是否显示父子表
			columns : [ {
				field : 'ck',
				checkbox : true
			}, {
				field : 'index',
				title : '序号',
				align : 'center',
				width : '7%',
				formatter : function(value, row, index) {
					return index + 1;
				}
			},{
				field : 'id',
				title : '主键',
				visible:false
			}, {
				field : 'user_name',
				title : '姓名',
				width : '7%',
				align : 'left'
			}, {
				field : 'dept_name',
				title : '所在部门',
				width : '9%',
				align : 'left'
			}, {
				field : 'post_name',
				title : '职务',
				width : '9%',
				align : 'left'
			}, {
				field : 'state_',
				title : '状态',
				width : '7%',
				align : 'center',
				formatter:function(value,row){
					if (value == "0"){
						return '<span class="label label-danger">待发</span>';
					}else if (value == "1"){
						return '<span class="label label-success">在办</span>';
					}
					else if (value == "2"){
						return '<span class="label label-success">办结</span>';
					}else{
						return '<span class="label label-success">未知</span>';
					}
				}		
			},{
				field : 'leave_type',
				title : '请假类型',
				width : '7%',
				align : 'center'
			},{
				field : 'startTime',
				title : '开始时间',
				width : '11%',
				align : 'center'
			},{
				field : 'endTime',
				title : '结束时间',
				width : '11%',
				align : 'center'
			},{
				field : '',
				title : '请(休)假天数',
				width : '12%',
				align : 'center',
				formatter:function(value,row){
					if (row.xiujia_days!=null&&row.xiujia_days!= ""){
						return row.xiujia_days;
					}else{
						return row.qingjia_days;
					}
				}
			},{
				field : 'leave_capital',
				title : '出京',
				width : '7%',
				align : 'center'
			},{
				field : 'leave_country',
				title : '出境',
				width : '7%',
				align : 'center'
			},{
				field : 'sendTime',
				title : '提交时间',
				width : '11%',
				align : 'center',
	 			formatter:function(value,row){
	 				if (value == null){
						return '-';
					}else{
						return value.substring(0,10);

					}			
			}
			}],
			onClickRow : function(row, tr) {
				var bizId = row.id;
				var procInstId = row.proc_inst_id_;
	     		var tname = "修改";
	     		var status = "2";//编辑
	    		if(procInstId!=null&&procInstId!="") {
		 			tname = "查看";
		 			status = "4";
		 		}
	     		var operateUrl = "bizRunController/getBizOperate?solId="+ row.sol_id_  + "&bizId=" + bizId + "&status=" + status;
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
                query : $("#search_form_fw").serialize(),
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
			width: '20px',
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
			width: '200px',
			halign: 'left',
		    sortable: true,
		  /*  events: onTdClickTab,*/
            formatter: onTdClickTabFormatter
		}, {
			field : 'USER_NAME',
			title : '上环节处理人',
			align : 'left',
			valign: 'middle',
			width : '50px'
		}/*,{
			field : 'URGENCY_',
			title : '紧急程度',
			width: '60px',
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
		}*/, {
			field : 'CREATE_TIME_',
			title : '拟稿日期',
			width: '80px',
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
 *  查询方法
 */
function search() {
	$("#USER_NAME").val('');
	var userName = $.trim($("#input-word").val());
	if (userName == '请输入姓名查询') {
		userName = "";
	}
	$("#leaveTable").bootstrapTable('refresh',{
		url : "leaveManager/findAllLeaveInfo",
		query:{
			userName : userName
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
/**
 * table序号格式化
 * @param value
 * @param row
 * @param index
 * @returns
 */
function indexFormatter(value, row, index) {
	return index + 1;
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
		if(value.length>25){
			return "<span class='tdClick' title='"+value+"'>"+value.substring(0,20)+"...</span>";
		}else{
			return "<span class='tdClick' title='"+value+"'>"+value+"</span>";
		}
	}else{
		return "<span class='tdClick'>-</span>"
	}
}
/**
 * 高级搜索
 */
function showOrHide(){
	var display =$('#advSearchModal').css('display');
	if(display == "none") {
		$("#advSearchModal").show();
	}else {
		$("#advSearchModal").hide();
	}
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
