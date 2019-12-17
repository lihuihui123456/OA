/**
 * 李争辉
 */
var myArr = "";
var myArr2 = "";
var selectionIds = [];
$(function() {
	
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
	$('#tapList').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
	var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
        return row.id_;  
    });  
    func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
    selectionIds = _[func](selectionIds, ids);   
	}); 

	
	laydate.skin('dahong');
	$('#myTab a').click(function (e) {
	  e.preventDefault()
	  $(this).tab('show')
	 /* if($("#tapList2").val() == ""){
		  initTable2();
		  $("#tapList2").bootstrapTable('refresh');
	  }*/
	});
	
	initTable();
	
	//收文导出Excel
	$("#btn_excel").click(function(){
		var url = "gwgl/exportExcel";
		window.open(url);
	})
	
	//发文导出Excel
	$("#btn_excel_fw").click(function(){
		var url = "gwgl/exportExcel_fw";
		window.open(url);
	})
	
	//收文重置
	$("#btn_reset").click(function(){
		$('#tapList').bootstrapTable('removeAll');
		$("#djr").val("");
		$("#gwbt").val("");
		$("#lwdw").val("");
		$("#lsh").val("");
		$("#sfgd option:first").attr("selected","selected");
		$("#bwzt option:first").attr("selected","selected");
		$("#jjcd option:first").attr("selected","selected");
		$("#djsj").val("");
		$("#djsj1").val("");
		myArr = "";
		searchBJ();
	})
	
	//发文重置
	$("#btn_reset_gd").click(function(){
		$('#tapList2').bootstrapTable('removeAll');
		$("#gwbt_fw").val("");
		$("#lsh_fw").val("");
		$("#lwdw_fw").val("");
		$("#djr_fw").val("");
		$("#bwzt_fw option:first").attr("selected","selected");
		$("#jjcd_fw option:first").attr("selected","selected");
		$("#sfgd_fw option:first").attr("selected","selected");
		$("#djsj_fw").val("");
		$("#djsj1_fw").val("");
		myArr2 = "";
		searchGD();
	})
})

//已办结查询
function searchBJ(){
	var gwbt = $("#gwbt").val();
/*	var djr = $("#djr").val();
*/	var djsj = $("#djsj").val();
    var djsj1 = $("#djsj1").val();
/*	var bwzt = $("#bwzt").val();
	var jjcd = $("#jjcd").val();
	var lsh = $("#lsh").val();
	var sfgd = $("#sfgd").val();
	*/
    if(gwbt==""||gwbt==null){
    	gwbt="null";
    }
    if(djsj==""||djsj==null){
    	djsj="null";
    }
    if(djsj1==""||djsj1==null){
    	djsj1="null";
    }
    if (djsj1 < djsj) {
    	layerAlert("结束时间不能小于开始时间！");
    	return;
    }
	myArr = gwbt+"&"+djsj+"&"+djsj1;
	$("#tapList").bootstrapTable('refresh',{
		url : "docmgt/findHasDone",
		query:{
			query : myArr
		}
	});
}

//已归档查询
function searchGD(){
	var gwbt_fw = $("#gwbt_fw").val();
/*	var djr_fw = $("#djr1").val();
*//*	var lwdw_fw = $("#lwdw_fw").val();
	var lsh_fw = $("#lsh_fw").val();
	var jjcd_fw = $("#jjcd_fw").val();
	var sfgd_fw = $("#sfgd_fw").val();
	var bwzt_fw = $("#bwzt_fw").val();*/
	var djsj_fw = $("#djsj_fw").val();
	var djsj1_fw = $("#djsj1_fw").val();
    if(gwbt_fw==""||gwbt_fw==null){
    	gwbt_fw="null";
    }
    if(djsj_fw==""||djsj_fw==null){
    	djsj_fw="null";
    }
    if(djsj1_fw==""||djsj1_fw==null){
    	djsj1_fw="null";
    }
    if (djsj1_fw < djsj_fw) {
    	layerAlert("结束时间不能小于开始时间！");
    	return;
    }
	myArr2 = gwbt_fw+"&"+djsj_fw+"&"+djsj1_fw;
	$("#tapList2").bootstrapTable('refresh');
	$("#tapList2").bootstrapTable('refresh',{
		url : "docmgt/findHasBelong",
		query:{
			query : myArr2,
			id: chooseNode
		}
	});
}
function getmyArr(){
	var gwbt = $("#gwbt").val();
	var djsj = $("#djsj").val();
	var djsj1 = $("#djsj1").val();
    if(gwbt==""||gwbt==null){
	   gwbt="null";
	}
	if(djsj==""||djsj==null){
	   djsj="null";
	}
	if(djsj1==""||djsj1==null){
	   djsj1="null";
	}
	if (djsj1 < djsj) {
	   layerAlert("结束时间不能小于开始时间！");
	   return;
	}
	myArr = gwbt+"&"+djsj+"&"+djsj1;
	return myArr;
}
function getmyArr2(){
	    var gwbt_fw = $("#gwbt_fw").val();
		var djsj_fw = $("#djsj_fw").val();
		var djsj1_fw = $("#djsj1_fw").val();
	    if(gwbt_fw==""||gwbt_fw==null){
	    	gwbt_fw="null";
	    }
	    if(djsj_fw==""||djsj_fw==null){
	    	djsj_fw="null";
	    }
	    if(djsj1_fw==""||djsj1_fw==null){
	    	djsj1_fw="null";
	    }
	    if (djsj1_fw < djsj_fw) {
	    	layerAlert("结束时间不能小于开始时间！");
	    	return;
	    }
		myArr2 = gwbt_fw+"&"+djsj_fw+"&"+djsj1_fw;
	return myArr2;
}
//已办结未归档
function initTable() {
	$('#tapList').bootstrapTable({
		url : "docmgt/findHasDone", // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）0.
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "DESC", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				query : getmyArr(),
				sortName : this.sortName,
				sortOrder : this.sortOrder
			};
			return temp;
		}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		pageList : [ 10, 25, 50, 100 ], // 可供选择的每页的行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		//strictSearch : true,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "ID_", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
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
			valign: 'middle',
			width : '3%'
		}, {
			field : 'ID_',
			title : 'ID_',
			visible : false
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			valign: 'middle',
			width : '5%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, /*{
			field : 'SERIAL_NUMBER_',
			title : '流水号',
			valign: 'middle',
			align : 'left',
			width : '12%',
			sortable : true,
		},*/ {
			field : 'BIZ_TITLE_',
			title : '文件标题',
			valign: 'middle',
			align:'left',
			width : '35%',
			sortable : true,
			/*events: onTdClickTab,*/
            formatter: onTdClickTabFormatter
		}, {
			field : 'URGENCY_',
			title : '紧急程度',
			cellStyle : cellStyle,
			align : 'center',
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
			field : 'USER_NAME',
			title : '拟稿人',
			align : 'left',
			valign: 'middle',
			width : '8%',
			sortable : true,
		}, {
			field : 'CREATE_TIME_',
			title : '拟稿日期',
			cellStyle : cellStyle,
			align : 'center',
			valign: 'middle',
			width : '12%',
			sortable : true,			
			formatter:function(value,row){
 				if(row.CREATE_TIME_==null){
	 				  return "--";
	 				}
	 				else{
	 					return row.CREATE_TIME_;	
	 				}
			}
		}, /*{
			field : 'STATE_',
			title : '办理状态',
			align : 'left',
			valign: 'middle',
			width : '8%',
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
		},*/ {
			field : 'END_TIME_',
			title : '办结时间',
			cellStyle : cellStyle,
			align : 'center',
			valign: 'middle',
			width : '11%',
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
		}],
		onClickRow : function (row, obj) {
			var bizid=row.bizid;
			var solId=row.SOL_ID_;
     		var procInstId = row.PROC_INST_ID_;
     		var tname = "查看";
     		var status = "4";//编辑
     		/*if(procInstId!=null&&procInstId!="") {
     			tname = "查看";
     			status = "4";
     		}*/
     		var operateUrl = "bizRunController/getBizOperate?solId="+ solId  + "&bizId=" + bizid + "&status=" + status;
     		var options = {
     			"text" : tname,
     			"id" : "view"+bizid,
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
			return "<span class='tdClick'>"+value+"</span>"
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
		var options={
				"text":"查看原文",
				"id":"bizinfoview"+bizid,
				"href":"bpmRunController/view?bizId="+ bizid+"&&procInstId="+ proc_inst_id_ +"&&taskId="+taskid +"&&solId="+solId,
				"pid":window,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":true
		};
		window.parent.createTab(options);
	 }
}

function view(bizId){
	var options={
			"text":"查看公文",
			"id":"viewgw"+bizId,
			"href":"bpmRuBizInfoController/view?bizId="+ bizId,
			"pid":window,
			"isDelete":true,
			"isReturn":true,
			"isRefresh":true
	};
	window.parent.createTab(options);
}

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
/*//已归档
function initTable2() {
	$('#tapList2').bootstrapTable({
		url : "docmgt/findHasBelong", // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）0.
		pagination : true, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				query : myArr2
			};
			return temp;
		}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		pageList : [ 10, 25, 50, 100 ], // 可供选择的每页的行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		//strictSearch : true,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "id", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		columns : [ {
			radio : true,
			valign: 'middle',
			width : '6%',
		}, {
			field : 'id_',
			title : 'id_',
			visible : false
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			valign: 'middle',
			width : '2%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'serial_number',
			title : '流水号',
			align : 'left',
			valign: 'middle',
			width : '12%',
		}, {
			field : 'name_',
			title : '文件标题',
			align : 'left',
			valign: 'middle',
			width : '20%'
		}, {
			field : 'urgency',
			title : '缓急程度',
			align : 'left',
			valign: 'middle',
			width : '10%',
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
			field : 'user_name',
			title : '拟稿人',
			align : 'left',
			valign: 'middle',
			width : '8%',
		}, {
			field : 'create_time',
			title : '拟稿日期',
			align : 'left',
			valign: 'middle',
			width : '10%'
		}, {
			field : 'state_',
			title : '办理状态',
			align : 'left',
			valign: 'middle',
			width : '8%',
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
			field : 'start_time',
			title : '送交时间',
			align : 'left',
			valign: 'middle',
			width : '12%',
		} ],
		onDblClickRow : function(row, tr) {
			var taskid = row.id_;
			var bizid=row.bizid;
			var proc_inst_id_=row.proc_inst_id_;
			var solId=row.solId;
			var options={
					"text":"查看原文",
					"id":"bizinfoview"+bizid,
					"href" : "bpmRunController/view?bizId=" + bizId,
					"href":"bpmRuBizInfoController/view?bizId="+ bizid+"&&procInstId="+ proc_inst_id_ +"&&taskId="+taskid +"&&solId="+solId,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
		}
	});
}
	*/