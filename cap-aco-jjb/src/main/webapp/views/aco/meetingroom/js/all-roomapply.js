var selectionIds = [];
$(function() {
	/**
	    * 选中事件操作数组  
	    */
	    var union = function(array,ids){  
	        $.each(ids, function (i, roomused_id) {  
	            if($.inArray(roomused_id,array)==-1){  
	                array[array.length] = roomused_id;  
	            }  
	        });  
	         return array;  
	};
	/**
	     * 取消选中事件操作数组 
	     */ 
	    var difference = function(array,ids){  
	            $.each(ids, function (i, roomused_id) {  
	                 var index = $.inArray(roomused_id,array);  
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
		$('#dtlist').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
	var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
	            return row.roomused_id;  
	        });  
	        func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	        selectionIds = _[func](selectionIds, ids);   
	});

	//回车查询
	$('#input-word').keydown(function(event){ 
		if(event.keyCode==13){ 
			searchMeetingRoom();
		} 
	}); 
	
	initTable();
	/* 按钮方法开始 */
	//查看按钮
	$("#mt_btn_view").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单条记录进行查看！");
			return false;
		}
		var id = selectRow[0].roomapply_id;
		$.ajax({
			url:'roomApply/findPerApplyById',
			dataType:'json',
			data: {id:id},
			success: function(data){
				setValue(data);
				$('input,select,textarea',$('form[id="ff"]')).attr('readonly',true);
				$('#myModal').modal({
					backdrop : 'static',
					keyboard : false
				});
			},
			error : function(data){
				layerAlert(data);
			}
		});
	});
	// 通过按钮
	$("#mt_btn_true").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow[0].status != 1) {
			layerAlert("不能对已审批过的记录进行此操作！");
			return;
		}
		var roomused_ids = '';
		var roomapply_ids = '';
		var action = 'true';
		$(selectRow).each(function(index) {
			roomused_ids = roomused_ids + selectRow[index].roomused_id + ",";
			roomapply_ids = roomapply_ids + selectRow[index].roomapply_id + ",";
		});
		roomused_ids = roomused_ids.substring(0, roomused_ids.length - 1);
		roomapply_ids = roomapply_ids.substring(0, roomapply_ids.length - 1);
		$.ajax({
			url : 'roomUsed/doUpdateStatus',
			type : 'post',
			dataType : 'json',
			data : {
				roomused_ids : roomused_ids,
				roomapply_ids : roomapply_ids,
				action : action
			},
			success : function(a) {
				$("#dtlist").bootstrapTable('refresh');
			},
			error : function(a) {
				layerAlert(a);
			}
		});
	});
	// 不通过按钮
	$("#mt_btn_false").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow[0].status != 1) {
			layerAlert("不能对已审批过的记录进行此操作！");
			return;
		}
		var roomused_ids = '';
		var roomapply_ids = '';
		var action = 'false';
		$(selectRow).each(function(index) {
			roomused_ids = roomused_ids + selectRow[index].roomused_id + ",";
			roomapply_ids = roomapply_ids + selectRow[index].roomapply_id + ",";
		});
		roomused_ids = roomused_ids.substring(0, roomused_ids.length - 1);
		roomapply_ids = roomapply_ids.substring(0, roomapply_ids.length - 1);
		$.ajax({
			url : 'roomUsed/doUpdateStatus',
			dataType : 'json',
			data : {
				roomused_ids : roomused_ids,
				roomapply_ids : roomapply_ids,
				action : action
			},
			success : function(a) {
				$("#dtlist").bootstrapTable('refresh');
			},
			error : function(a) {
				layerAlert(a);
			}
		});
	});
	/* 按钮方法结束 */
	
});

var meetingname;
function initTable(){
	$('#dtlist').bootstrapTable({
		url : 'roomUsed/findAllApply', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					pageSize : params.limit, // 页面大小
					pageNum : params.offset,
					meetingname : meetingname
				// 页码
				// roomName : 
				};
				return temp;
			}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		strictSearch : false,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "roomused_id", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		singleSelect:true,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.roomused_id, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [ {
			field : 'checkStatus',
			checkbox : true
		}, {
			field : 'roomapply_id',
			visible:false
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			valign: 'middle',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'meeting_name',
			title : '会议标题',
			align : 'left',
			formatter : function(value, row, index) {
				if(value != null){
					if(value.length > 21){
						return value.substring(0,20)+"...";					
					}else{
						return value;
					}
				}else{
					return "";
				}
			}
		}, {
			field : 'room_name',
			title : '会议室',
			align : 'left'
		}, {
			field : 'start_time',
			title : '开始时间',
			align : 'center',
			valign: 'middle'
		}, {
			field : 'end_time',
			title : '结束时间',
			align : 'center',
			valign: 'middle'
		}, {
			field : 'apply_user',
			title : '申请人',
			align : 'left'
		}, {
			field : 'status',
			title : '状态',
			align : 'center',
			valign: 'middle',
			formatter : function(value, row) {
				if (value == 1)
					return '<span class="label label-warning">审批中</span>';
				if (value == 2)
					return '<span class="label label-success">已批准</span>';
				if (value == 3)
					return '<span class="label label-danger">不批准</span>';
			}
		}, {
			field : 'apply_time',
			title : '登记时间',
			align : 'center',
			valign: 'middle'
		} ],
		onDblClickRow:function(row,tr){
			var id = row.roomapply_id;
			$.ajax({
				url:'roomApply/findPerApplyById',
				dataType:'json',
				data: {id:id},
				success: function(data){
					setValue(data);
					$('input,select,textarea',$('form[id="ff"]')).attr('readonly',true);
					$('#myModal').modal({
						backdrop : 'static',
						keyboard : false
					});
				},
				error : function(data){
					layerAlert(data);
				}
			});
		}
	});
}

function setValue(data){
	$('#meetingname').val(data.meeting_name);
	$('#roomname').val(data.room_name);
	$('#applyuser').val(data.apply_user);
	$('#applyorg').val(data.apply_org);
	$('#ts').val(data.apply_time);
	$('#starttime').val(data.start_time);
	$('#endtime').val(data.end_time);
	$('#purpose').val(data.purpose);
	$('#resource').val(data.resource);
	$('#remark').val(data.remark);
}

function searchMeetingRoom() {
	meetingname = $('#input-word').val();
	if( meetingname == '请输入会议标题'){
		meetingname = "";
	}else{
		var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
		if(meetingname.match(reg)==null){
			layerAlert("输入内容含有非法字符！");
			return;
		}
	}
	$("#dtlist").bootstrapTable('refresh');
}
