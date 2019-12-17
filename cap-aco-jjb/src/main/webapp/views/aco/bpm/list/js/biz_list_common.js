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

var startTime = $("#startTime").val();
var endTime = $("#endTime").val();
/*var bizTitle =$("#bizTitle_").val();
var state = $("#STATE_").val();
var urgency = $("#URGENCY_").val();*/

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
        onClickRow : function (row, obj) {
    		var state = row.STATE_;
    		if (state != '0') {
            	var bizId = row.ID_;
         		var procInstId = row.PROC_INST_ID_;
         		var options = {
         			"text" : "查看",
         			"id" : "view"+bizId,
         			"href" : "bpmRunController/view?bizId=" + bizId,
         			"pid" : window.parent,
         			"isDelete":true,
         			"isReturn":true,
         			"isRefresh":true
         		};
         		window.parent.parent.createTab(options);
    		}else {
        		var bizId = row.ID_;
        		var serialNumber = row.SERIAL_NUMBER_;
        		var options = {
        			"text" : "修改",
        			"id" : "update"+bizId,
        			"href" : "bpmRunController/update?solId=" + solId + "&bizId=" + bizId + "&serialNumber=" + serialNumber,
        			"pid" : window.parent,
        			"isDelete":true,
        			"isReturn":true,
        			"isRefresh":true
        		};
        		window.parent.parent.createTab(options);
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
		if(value.length>25){
			return "<span class='tdClick' title='"+value+"'>"+value.substring(0,20)+"...</span>";
		}else{
			return "<span class='tdClick'>"+value+"</span>";
		}
	}else{
		return "<span class='tdClick'>-</span>"
	}
}

window.onTdClickTab = {
	 'click .tdClick': function (e, value, row, index) {
		var bizId = row.ID_;
 		var procInstId = row.PROC_INST_ID_;
 		var options = {
 			"text" : "查看",
 			"id" : "view"+bizId,
 			"href" : "bpmRunController/view?bizId=" + bizId,
 			"pid" : window.parent,
 			"isDelete":true,
 			"isReturn":true,
 			"isRefresh":true
 		};
 		window.parent.parent.createTab(options);
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
	var state = row.STATE_;
	if (state != null && state != "" && state != '0') {
		return [
		        '<a class="viewSubject" href="javascript:void(0)" title="查看">',
		        '<i class="fa fa-list"></i>',
		        '</a>  '
		        /*'<a class="deleteSubject" href="javascript:void(0)" title="删除">',
	        '<i class="fa fa-remove"></i>',
	        '</a>'*/
		        ].join('');
	} else {
		return [
		        '<a class="editSubject" href="javascript:void(0)" title="修改">',
		        '<i class="fa fa-pencil"></i>',
		        '</a>  '
		        /*'<a class="deleteSubject" href="javascript:void(0)" title="删除">',
        '<i class="fa fa-remove"></i>',
        '</a>'*/
		        ].join('');
	}
}
window.operateEvents = {
		'click .viewSubject': function (e, value, row, index) {
			stopPropagation();
			var bizId = row.ID_;
	 		var procInstId = row.PROC_INST_ID_;
	 		var options = {
	 			"text" : "查看",
	 			"id" : "view"+bizId,
	 			"href" : "bpmRunController/view?bizId=" + bizId,
	 			"pid" : window.parent,
	 			"isDelete":true,
	 			"isReturn":true,
	 			"isRefresh":true
	 		};
	 		window.parent.parent.createTab(options);
			
		},
    'click .editSubject': function (e, value, row, index) {
    	stopPropagation();
		var state = row.STATE_;
		if (state != '0') {
			layerAlert('已发的记录不能修改！');
			return;
		}
		date = new Date().getTime();
		var bizId = row.ID_;
		var serialNumber = row.SERIAL_NUMBER_;
		var options = {
			"text" : "修改",
			"id" : date,
			"href" : "bpmRunController/update?solId=" + solId + "&bizId=" + bizId + "&serialNumber=" + serialNumber,
			"pid" : window.parent,
			"isDelete":true,
			"isReturn":true,
			"isRefresh":true
		};
		window.parent.parent.createTab(options);
		
    },
    'click .deleteSubject': function (e, value, row, index) {
    	//stopPropagation();
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
								refreshTable('bizInfoList','bpmRuBizInfoController/findBpmRuBizInfoBySolId');
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
    }
};

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
			state : state
		}
	});
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

	
	
	//加载列表数据
	initDataTable();
	/*注册按钮事件*/
	//拟稿	
	$("#btn_new").click(function() {
		date = new Date().getTime();
		var options = {
			"text" : "拟稿",
			"id" : date,
			"href" : "bpmRunController/draft?solId=" + solId,
			"pid" : window,
			"isDelete":true,
			"isReturn":true,
			"isRefresh":true
		};
		
		window.parent.parent.createTab(options);
	});

	// 修改
	$("#btn_edit").click(function() {
		var selectRow = $("#bizInfoList").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单行进行修改！");
			return;
		}
		var state = selectRow[0].STATE_;
		if (state != '0') {
			layerAlert('已发的记录不能修改！');
			return;
		}
		date = new Date().getTime();
		var bizId = selectRow[0].ID_;
		var serialNumber = selectRow[0].SERIAL_NUMBER_;
		var options = {
			"text" : "修改",
			"id" : date,
			"href" : "bpmRunController/update?solId=" + solId + "&bizId=" + bizId + "&serialNumber=" + serialNumber,
			"pid" : window.parent,
			"isDelete":true,
			"isReturn":true,
			"isRefresh":true
		};
		window.parent.parent.createTab(options);
	});

	// 查看
	$("#btn_view").click(function() {
		var selectRow = $("#bizInfoList").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单行进行查看！");
			return;
		}
		var bizId = selectRow[0].ID_;
		var procInstId = selectRow[0].PROC_INST_ID_;
		var serialNumber = selectRow[0].SERIAL_NUMBER_;
		date = new Date().getTime();
		var options = {
			"text" : "查看",
			"id" : date,
			"href" : "bpmRunController/view?bizId=" + bizId,
			"pid" : window.parent,
			"isDelete":true,
			"isReturn":true,
			"isRefresh":true
		};
		window.parent.parent.createTab(options);
	});

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
	/* 按钮方法结束 */
});

/******************格式化方法********************/
 function indexFormatter(value, row, index) {
	return index + 1;
 }
	
 function formatterTime (value, row, index) {
	 if(value!=null){
		 return value.substr(0,16); 
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