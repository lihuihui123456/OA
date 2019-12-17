function searchCommon() {
	$("#search_form")[0].reset();
	var bidName1 = $("#input-word").val();
	if (bidName1 == '请输入项目名称查询') {
		bidName1 = "";
	}else{
		bidName1 = bidName1
	}
	$("#arcBidList").bootstrapTable('refresh',{
		url : "arcBidController/findAllArcBidData",
		query:{
			bidName : $.trim(bidName1)
		}
	});
}
$(function() {
	/**
	 * 列表回车触发搜索
	 */
	$('#input-word').bind('keypress', function (event) {
	    if (event.keyCode == "13") {
	    	searchCommon();
	       return false ;   
	    } 
	});
	laydate.skin('dahong');
	initTable();
	
	/**
	 * 添加按钮事件
	 */
	$('#add_btn').click(function() {
		var typeId = $('#typeId').val();
		date = new Date().getTime();
		var options = {
			"text" : "招投标-登记",
			"id" : date,
			"href" : "arcBidController/goToArcBidAdd?typeId="+typeId,
			"pid" : window.parent
		};
		window.parent.parent.createTab(options);
		
	});
	
	/**
	 * 修改按钮事件
	 */
	$('#update_btn').click(function() {
		var typeId = $('#typeId').val();
		var selects = $("#arcBidList").bootstrapTable('getSelections');  
		var arcId = "";
		if(selects.length==0){
			window.parent.publicAlert("请选择一条数据！");
			return;
		}else if(selects[0].is_invalid==1){
			window.parent.publicAlert("档案已作废！");
		}else if(selects[0].is_invalid==2){
			window.parent.publicAlert("档案已销毁！");
		}else if(selects[0].file_start==1){
			window.parent.publicAlert("档案已归档！");
		}else if(selects.length==1){
			arcId=selects[0].arc_id;
			date = new Date().getTime();
			var options = {
					"text" : " 招投标-修改",
					"id" : date,
					"href" : "arcBidController/goToArcBidUpdate?arcId="+arcId+"&typeId="+typeId+"&type=update",
					"pid" : window.parent
			};
			window.parent.parent.createTab(options);
		}
	});
	
	/**
	 * 查看原文
	 */
	$('#view_btn').click(function(){
		var selects = $("#arcBidList").bootstrapTable('getSelections');  
		var arcId = "";
		var fileStart="";
		if(selects.length==0){
			window.parent.publicAlert("请选择一条数据！");
			return;
		}
		arcId=selects[0].arc_id;
		fileStart=selects[0].file_start;
		var options = {
				"text" : "招投标-查看",
				"id" : arcId,
				"href" : "arcBidController/goToArcBidView?arcId="+arcId+"&fileStart="+fileStart+"&type=view",
				"pid" : window.parent
			};
			window.parent.parent.createTab(options);
	});
	/**
	 * 归档按钮事件
	 */
	$('#file_btn').click(function(){
		var selects = $("#arcBidList").bootstrapTable('getSelections');  
		var arcId = "";
		if(selects.length==0){
			window.parent.publicAlert("请选择一条数据！");
			return;
		}else if(selects[0].is_invalid==1){
			window.parent.publicAlert("档案已作废！");
		}else if(selects[0].is_invalid==2){
			window.parent.publicAlert("档案已销毁！");
		}else if(selects[0].file_start==1){
			window.parent.publicAlert("档案已归档！");
		}else if(selects.length==1){
			arcId=selects[0].arc_id;
			$.ajax({
				type : "POST",
				url : "arcPubInfo/doUpdateFileStartByArcId",
				async:false,
				dataType:'text',
				data:{
					"arcId":arcId
				},
				success : function(data) {
					if(data=="true"){
						window.parent.publicAlert("归档成功！");
						/*$("#arcBidList").bootstrapTable('refresh');*/
						refreshTable('arcBidList','arcBidController/findAllArcBidData');
					}
				},
				error : function(data) {
					history.go(0);
					/*$("#arcBidList").bootstrapTable('refresh');*/
					refreshTable('arcBidList','arcBidController/findAllArcBidData');
				}
			});
		}
	});

	/**
	 * 追加归档按钮事件
	 */
	$('#addFile_btn').click(function(){
		var selects = $("#arcBidList").bootstrapTable('getSelections');  
		var arcId = "";
		var fileStart = "";
		if(selects.length==0){
			window.parent.publicAlert("请选择一条数据！");
			return;
		}else if(selects[0].is_invalid==1){
			window.parent.publicAlert("档案已作废！");
		}else if(selects[0].is_invalid==2){
			window.parent.publicAlert("档案已销毁！");
		}else if(selects[0].file_start==0){
			window.parent.publicAlert("档案未归档！");
		}else if(selects.length==1){
			arcId=selects[0].arc_id;
			fileStart=selects[0].file_start;
			$.ajax({
				type : "POST",
				url : "arcPubInfo/doAddFileUpdateFileStartByArcId",
				async:false,
				dataType:'text',
				data:{
					"arcId":arcId
				},
				success : function(data) {
					if(data=="true"){
						date = new Date().getTime();
						var options = {
								"text" : " 招投标-追加归档",
								"id" : date,
								"href" : "arcBidController/goToArcBidUpdate?arcId="+arcId+"&typeId="+typeId+"&type=addFile&fileStart="+fileStart,
								"pid" : window.parent
						};
						window.parent.parent.createTab(options);
					}
				},
				error : function(data) {
					history.go(0);
					/*$("#arcBidList").bootstrapTable('refresh');*/
					refreshTable('arcBidList','arcBidController/findAllArcBidData');
				}
			});
		}
	});
	
	/**
	 * 删除按钮事件
	 */
	$('#del_btn').click(function(){
		var selects = $("#arcBidList").bootstrapTable('getSelections');  
		var arcId = "";
		if(selects.length==0){
			window.parent.publicAlert("请选择一条数据！");
			return;
		}else if(selects[0].is_invalid==1){
			window.parent.publicAlert("档案已作废！");
		}else if(selects[0].is_invalid==2){
			window.parent.publicAlert("档案已销毁！");
		}else if(selects[0].file_start==1){
			window.parent.publicAlert("档案已归档！");
		}else if(selects.length==1){
			window.parent.publicConfirm("确定删除吗？",selects[0].arc_id);
/*			layer.confirm('确定删除吗？', {
				btn : [ '是', '否' ]
			}, function() {
				arcId=selects[0].arc_id;
				$.ajax({
					type : "POST",
					url : "arcPubInfo/doDelArcInfoByArcId",
					async:false,
					dataType:'text',
					data:{
						"arcId":arcId
					},
					success : function(data) {
						if(data=="true"){
							window.parent.publicAlert("删除成功！");
							$("#arcBidList").bootstrapTable('refresh');
						}
					},
					error : function(data) {
						history.go(0);
						$("#arcBidList").bootstrapTable('refresh');
					}
				});
			});	*/
		}
	});
	
	/**
	 * 作废按钮事件
	 */
	$('#inv_btn').click(function(){
		var selects = $("#arcBidList").bootstrapTable('getSelections');  
		var arcId = "";
		if(selects.length==0){
			window.parent.publicAlert("请选择一条数据！");
			return;
		}else if(selects[0].is_invalid==1){
			window.parent.publicAlert("档案已作废！");
		}else if(selects[0].is_invalid==2){
			window.parent.publicAlert("档案已销毁！");
		}else if(selects[0].file_start==0){
			window.parent.publicAlert("档案未归档！");
		}else if(selects.length==1){
			arcId=selects[0].arc_id;
			$.ajax({
				type : "POST",
				url : "arcPubInfo/doInvArcInfoByArcId",
				async:false,
				dataType:'text',
				data:{
					"arcId":arcId
				},
				success : function(data) {
					if(data=="true"){
						window.parent.publicAlert("作废成功！");
						/*$("#arcBidList").bootstrapTable('refresh');*/
						refreshTable('arcBidList','arcBidController/findAllArcBidData');
					}
				},
				error : function(data) {
					history.go(0);
					/*$("#arcBidList").bootstrapTable('refresh');*/
					refreshTable('arcBidList','arcBidController/findAllArcBidData');
				}
			});
		}
	});
	
});

var bidName = "";
var bidCo = "";
var startTime = "";
var endTime = "";
var year ="";
var fileStart="";
/**删除一条数据*/
function deleteData(arc_id){
	arcId=arc_id;
	$.ajax({
		type : "POST",
		url : "arcPubInfo/doDelArcInfoByArcId",
		async:false,
		dataType:'text',
		data:{
			"arcId":arcId
		},
		success : function(data) {
			if(data=="true"){
				window.parent.publicAlert("删除成功！");
				/*$("#arcBidList").bootstrapTable('refresh');*/
				refreshTable('arcBidList','arcBidController/findAllArcBidData');
			}
		},
		error : function(data) {
			history.go(0);
			/*$("#arcBidList").bootstrapTable('refresh');*/
			refreshTable('arcBidList','arcBidController/findAllArcBidData');
		}
	});
}
/**
 * 表格数据初始化
 */
function initTable() {
	$('#arcBidList').bootstrapTable({
		url : 'arcBidController/findAllArcBidData', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
//		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			validateData();
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize:params.limit, // 页面大小
				pageNum:params.offset, // 页码
				bidName:$.trim(bidName),
				bidCo:$.trim(bidCo),
				startTime:startTime,
				endTime:endTime,
				year:year,
				fileStart:fileStart,
				sortName:this.sortName,
				sortOrder:this.sortOrder
			};
			bidName="";
			return temp;
		},// 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		strictSearch : true,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "arc_id", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		singleSelect : true,
		columns : [ {
			checkbox : true
		}, {
			field : 'index',
			title : '序号',
			valign : 'middle',
			width: '5%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'reg_time',
			title : '登记日期',
			align : 'left',
			valign : 'middle',
			sortable : true,
 			formatter:function(value,row){
 				if(value != null && value != ""){
 					return jsonTimeStamp(value);
 				}
				return "--";
		   }
		}, {
			field : 'arc_name',
			title : '文件标题',
			align : 'left',
			valign : 'middle',
			width: '20%',
			sortable : true,
/* 		    events: onTdClickTab,
*/ 		    formatter: onTdClickTabFormatter
		}, {
			field : 'bid_name',
			title : '项目名称',
			align : 'left',
			valign : 'middle',
			sortable : true
		}, {
			field : 'bid_time',
			title : '招标时间',
			align : 'center',
			valign : 'middle',
			sortable : true,
 			formatter:function(value,row){
 				if(value != null && value != ""){
 					return jsonTimeStamp(value);
 				}
				return "--";
		   }
		}, {
			field : 'bid_co',
			title : '中标单位',
			align : 'left',
			valign : 'middle',
			sortable : true
		}, {
			field : 'file_start',
			title : '档案状态',
			align : 'left',
			valign : 'middle',
			sortable : true,
			  formatter : function(val, row) {
				  //0:未归档1:已归档2：追加归档
				  //0:正常1：作废2：销毁
				 var fileStart = row.file_start;
				 var isInvalid = row.is_invalid;
				 if(isInvalid=='0'){
					 if (fileStart == "0"){
						 return '<span class="label label-success">&nbsp;未归档&nbsp;&nbsp;</span>';
					 }else if (fileStart == "1"){
						 return '<span class="label label-warning">&nbsp;已归档&nbsp;&nbsp;</span>';
					 }else{
						 return "--";
					 }
				 }else if(isInvalid=='1'){
					 return '<span class="label label-danger">&nbsp;已作废&nbsp;&nbsp;</span>';
				 }else {
					 return "--";
				 }
				}
		}, {
			field : 'dep_pos',
			title : '存放位置',
			align : 'left',
			valign : 'middle',
			sortable : true
		}],
		onClickRow: function (row, tr) {
			var options = {
					"text" : "招投标-查看",
					"id" : row.arc_id,
					"href" : "arcBidController/goToArcBidView?arcId="+row.arc_id+"&fileStart="+row.file_start+"&type=view",
					"pid" : window.parent
				};
				window.parent.parent.createTab(options);
		}		
		/*,
		onDblClickRow : function(row, tr) {
			var options = {
					"text" : "招投标-查看",
					"id" : row.arc_id,
					"href" : "arcBidController/goToArcBidView?arcId="+row.arc_id+"&fileStart="+row.file_start+"&type=view",
					"pid" : window.parent
				};
				window.parent.parent.createTab(options);
		}*/
	});
}

/**
 * 重置表单
 */
function clearCUserForm(type){
	 $('#advSearchModal').modal('hide');
	document.getElementById(type).reset();
	searchData();
}

/**
 *  查询方法
 */
function searchData() {
    $('#advSearchModal').modal('hide');
    $("#input-word").val("");
	$("#arcBidList").bootstrapTable('refresh');
}
function validateData() {
	if($("#input-word").val()!="请输入项目名称查询"&&$("#input-word").val()!=""){
		bidName=$("#input-word").val();
		$("#search_form")[0].reset();
	}
	bidName=bidName+$("#bidName").val();
	startTime=$("#startTime").val();
	endTime=$("#endTime").val();
	if(startTime!=""&&endTime!=""){
		if(startTime > endTime){
			window.parent.publicAlert("登记开始日期不能大于结束日期");
			return;
		}
	}
	year = $("#searchregYear").val();//项目名称
	bidCo = $("#bidCo").val();//中标单位
	fileStart = $("#searchfileStart").val();//中标单位
/*	if (bidName == '请输入项目名称') {
		bidName = "";
	} */
	if (bidCo == '请输入中标单位') {
		bidCo = "";
	} 
	if (year == '请输入年度') {
		year = "";
	}
}
/**
 * 归档状态格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function formatterFileStart (value, row, index) {
	/*if (value == "0"){
		return '<span class="label label-danger">&nbsp;未归档&nbsp;&nbsp;</span>';
	}else if (value == "1"){
		return '<span class="label label-warning">&nbsp;已归档&nbsp;&nbsp;</span>';
	}else if (value == "2"){
		return '<span class="label label-success">追加归档</span>';
	}else{
		return "--";
	}*/
	 if(row.is_invalid=='0'){
		 if (row.file_start == "0"){
			 return '<span class="label label-success">&nbsp;未归档&nbsp;&nbsp;</span>';
		 }else if (row.file_start == "1"){
			 return '<span class="label label-warning">&nbsp;已归档&nbsp;&nbsp;</span>';
		 }else{
			 return "--";
		 }
	 }else if(row.is_invalid=='1'){
		 return '<span class="label label-danger">&nbsp;已作废&nbsp;&nbsp;</span>';
	 }else {
		 return "--";
	 }
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
 * 作废状态表格格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function formatterInvalidStart (value, row, index) {
	if (value == "0"){
		return '<span class="label label-danger">未作废</span>';
	}else if (value == "1"){
		return '<span class="label label-warning">已作废</span>';
	}else if (value == "2"){
		return '<span class="label label-success">销&nbsp;&nbsp;毁</span>';
	}else{
		return "--";
	}
}
/*document.onkeydown = function(event_e){    
    if(window.event)    
     event_e = window.event;    
     var int_keycode = event_e.charCode||event_e.keyCode;    
     if(int_keycode ==13){
    	 searchData(); 
    }  
} */
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
/**
 * 高级搜索模态框
 */
function advSearchModal(){
	$('#advSearchModal').modal('show');
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
	if(value==null){
		return "<span class='tdClick'>-</span>"
	}
	else if(value.length>30){
		return "<span class='tdClick' title='"+value+"'>"+value.substring(0,29)+"...</span>"
	}else{
		return "<span class='tdClick'>"+value+"</span>"
	}
}
/*
 * table 点击标题弹出查看/办理页面
 */
window.onTdClickTab = {
	 'click .tdClick': function (e, value, row, index) {
			var options = {
					"text" : "招投标-查看",
					"id" : row.arc_id,
					"href" : "arcBidController/goToArcBidView?arcId="+row.arc_id+"&fileStart="+row.file_start+"&type=view",
					"pid" : window.parent
				};
				window.parent.parent.createTab(options);
	 }
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
        return year + "-" + month + "-" + date;
    } else {
        return "";
    }
 
} 

