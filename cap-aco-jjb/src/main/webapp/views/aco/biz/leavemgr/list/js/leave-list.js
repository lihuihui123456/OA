//翻页选中数组
var selectionIds = [];
$(function() {
	initTable();
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
			return row.LEAVE_ID;  
		});  
	     func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	     selectionIds = _[func](selectionIds, ids);   
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
		url : 'leaveController/findLeaveDateByQueryParams', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageNum:params.offset, // 页码
				pageSize:params.limit, // 页面大小
				solId:solId,//业务模块
				userName:$.trim(userName),
				sortName:this.sortName,
				sortOrder:this.sortOrder,
				queryParams : $("#ff").serialize(),
			};
			userName="";
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
		uniqueId : "LEAVE_ID", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		singleSelect : false,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.LEAVE_ID, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [ {
			checkbox : true,
			valign: 'middle',
			halign: 'center',
			field: 'checkStatus'
		}, {
			field : 'index',
			title : '序号',
			valign : 'middle',
			width: '5%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'USER_NAME',
			title : '姓名',
			align : 'left',
			valign : 'middle',
			sortable : true,
			width: '8%',
		}, {
			field : 'DEPT_NAME',
			title : '部门',
			align : 'left',
			valign : 'middle',
			width: '8%',
			sortable : true
		}, {
			field : 'POST_NAME',
			title : '职务',
			width: '8%',
			cellStyle : cellStyle,
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'STATE',
			title : '状态',
			align : 'center',
			width: '10%',
			valign : 'middle',
			cellStyle : cellStyle,
			sortable : true,
			formatter : function(val, row) {
				 if(row.STATE=='0'){
					 return '<span class="label label-success">&nbsp;待提交&nbsp;&nbsp;</span>';
				 }else if(row.STATE=='1'){
					 return '<span class="label label-warning">&nbsp;审批中&nbsp;&nbsp;</span>';
				 }else if(row.STATE=='2') {
					 return '<span class="label label-danger">&nbsp;通过&nbsp;&nbsp;</span>';
				 }else if(row.STATE=='3') {
					 return '<span class="label label-danger">&nbsp;未通过&nbsp;&nbsp;</span>';
				 }else {
					 return '--';
				 }
			}
		}, {
			field : 'LEAVE_TYPE',
			title : '请假类型',
			width: '10%',
			cellStyle : cellStyle,
			align : 'center',
			valign : 'middle',
			sortable : true,
			formatter : function(val, row) {
				 if(row.LEAVE_TYPE=='bj'){
					 return '<span class="label label-success">&nbsp;病假&nbsp;</span>';
				 }else if(row.LEAVE_TYPE=='xj'){
					 return '<span class="label label-warning">&nbsp;休假&nbsp;</span>';
				 }else if(row.LEAVE_TYPE=='sj'){
					 return '<span class="label label-warning">&nbsp;事假&nbsp;</span>';
				 }else {
					 return '--';
				 }
			}
		}, {
			field : 'START_TIME',
			title : '开始时间',
			align : 'center',
			width: '10%',
			cellStyle : cellStyle,
			valign : 'middle',
			sortable : true
		},{
			field : 'END_TIME',
			title : '结束时间',
			align : 'center',
			width: '10%',
			cellStyle : cellStyle,
			valign : 'middle',
			sortable : true
		},{
			field : 'LEAVE_DAYS',
			title : '天数',
			align : 'center',
			width: '8%',
			cellStyle : cellStyle,
			valign : 'middle',
			sortable : true
		},{
			field : 'IS_BJ',
			title : '是否出京',
			width: '10%',
			align : 'center',
			cellStyle : cellStyle,
			valign : 'middle',
			sortable : true,
			  formatter : function(val, row) {
				 if(row.IS_BJ=='s'){
					 return '<span class="label label-success">&nbsp;是&nbsp;&nbsp;</span>';
				 }else if(row.IS_BJ=='f'){
					 return '<span class="label label-warning">&nbsp;否&nbsp;&nbsp;</span>';
				 }else {
					 return '--';
				 }
				}
		},{
			field : 'IS_EXIT',
			title : '是否出境',
			width: '10%',
			align : 'center',
			cellStyle : cellStyle,
			valign : 'middle',
			sortable : true,
			  formatter : function(val, row) {
				 if(row.IS_EXIT=='s'){
					 return '<span class="label label-success">&nbsp;是&nbsp;&nbsp;</span>';
				 }else if(row.IS_EXIT=='f'){
					 return '<span class="label label-warning">&nbsp;否&nbsp;&nbsp;</span>';
				 }else {
					 return '--';
				 }
				}
		}/*,{
			field : 'SEND_TIME',
			title : '提交时间',
			width: '10%',
			align : 'center',
			cellStyle : cellStyle,
			valign : 'middle',
			sortable : true
		}*/],
		onClickRow:function(row,tr){
			var tname = "编辑";
			var status = "2";
			if(row.EARC_STATE!='0'){
				tname = '查看';
				status="4";
			}
			var bizId = row.LEAVE_ID;
			var operateUrl = "bizRunController/getBizOperate?solId="+ row.SOL_ID_  + "&bizId=" + bizId + "&status="+status;
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
		url : "leaveController/findLeaveDateByQueryParams",
		query:{
			userName : userName
		}
	});
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

