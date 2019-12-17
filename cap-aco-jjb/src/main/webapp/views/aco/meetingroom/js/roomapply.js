var selectionIds = [];//记忆选中
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
	$('#dtlist').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
	var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
        return row.id_;  
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
	//查看
	$("#mt_btn_view").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单条记录进行查看！");
			return false;
		}
		var id = selectRow[0].id_;
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
			}
		});
	});
	
	// 通过按钮
	$("#mt_btn_true").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}
		/*if (selectRow.length > 1) {
			layerAlert("请选择一条操作项！");
			return false;
		}*/
		if (selectRow[0].status != 1) {
			layerAlert("不能对已审批过的记录进行此操作！");
			return;
		}
		var roomused_ids = '';
		var roomapply_ids = '';
		var action = 'true';
		$(selectRow).each(function(index) {
			roomused_ids = roomused_ids + selectRow[index].roomused_id + ",";
			roomapply_ids = roomapply_ids + selectRow[index].id_ + ",";
		});
		roomused_ids = roomused_ids.substring(0, roomused_ids.length - 1);
		roomapply_ids = roomapply_ids.substring(0, roomapply_ids.length - 1);
		$.ajax({
			url : 'roomUsed/doUpdateStatus',
			type : 'post',
			dataType : 'json',
			data : {
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
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}
		if (selectRow[0].status != 1) {
			layerAlert("不能对已审批过的记录进行此操作！");
			return;
		}
		var roomused_ids = '';
		var roomapply_ids = '';
		var action = 'false';
		$(selectRow).each(function(index) {
			roomused_ids = roomused_ids + selectRow[index].roomused_id + ",";
			roomapply_ids = roomapply_ids + selectRow[index].id_ + ",";
		});
		roomused_ids = roomused_ids.substring(0, roomused_ids.length - 1);
		roomapply_ids = roomapply_ids.substring(0, roomapply_ids.length - 1);
		$.ajax({
			url : 'roomUsed/doUpdateStatus',
			dataType : 'json',
			data : {
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
	
	// 删除按钮
	$("#mt_btn_delete").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow == null || selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}
		var ids = [];
		var flag = false;
		$(selectRow).each(function(index) {
			var status;
			ids[index] = selectRow[index].id_;
			status = selectRow[index].status;
			if (status != '0') {
				layerAlert(status);
				flag = true;
			}

		});
		if (flag) {
			layerAlert("只能删除未发的记录！");
			return false;
		}
		$.ajax({
			url : 'roomApply/deleteData',
			dataType : 'json',
			data : {
				ids : ids
			},
			success : function(result) {
				$("#dtlist").bootstrapTable('refresh');
			},
			error : function(result) {
				layerAlert(result);
			}
		});
	});
	/* 按钮方法结束 */
	
	/*高级搜索*/
	$("#supperSearch_search").click(function() {
		$("#input-word").val("");
		$("#dtlist").bootstrapTable('refresh',{
			url : "roomApply/findRoomApplyData",
			query:{	
				query : $("#search_form").serialize(),
			}
		});
	});
	
	/*高级搜索重置*/
	$("#supperSearch_reset").click(function() {
		document.getElementById("search_form").reset(); 
		$("#input-word").val("");
		
		$("#dtlist").bootstrapTable('refresh',{
			url : "roomApply/findRoomApplyData",
			query:{	
				query : $("#search_form").serialize(),
			}
		});
	});
	
	/*高级搜索取消*/
	$("#supperSearch_cancel").click(function() {
		document.getElementById("search_form").reset(); 
		$("#input-word").val("");
		
		$("#dtlist").bootstrapTable('refresh',{
			url : "roomApply/findRoomApplyData",
			query:{	
				query : $("#search_form").serialize(),
			}
		});
		$("#searchDiv").hide();
	});
});

function advSearchModal(){
	var display =$("#searchDiv").css('display');
	if(display == "none") {
		$("#searchDiv").show();
	}else {
		$("#searchDiv").hide();
	}
}

var meetingname;
function initTable(){
	$('#dtlist').bootstrapTable({
		url : 'roomApply/findRoomApplyData', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "desc", // 排序方式
		queryParams : function(params) {
			meetingname = $('#input-word').val();
			if( meetingname == '请输入会议标题'){
				meetingname = "";
			}else{
				/*var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
				if(meetingname.match(reg)==null){
					layerAlert("输入内容含有非法字符！");
					return;
				}*/
			}
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					pageSize : params.limit, // 页面大小
					pageNum : params.offset,
					modCode : modCode,
				    meetingname : meetingname,
				    sortName:this.sortName,
		            sortOrder:this.sortOrder,
		            query : $("#search_form").serialize()
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
		uniqueId : "id_", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		singleSelect:false,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.id_, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [ {
			field : 'checkStatus',
			checkbox : true
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			valign: 'middle',
			formatter : function(value, row, index) {
				return index + 1;
			},
			width : '5%'
		}, {
			field : 'meeting_name',
			title : '会议标题',
			sortable: true,
			align : 'left',
			valign: 'middle',
			width : '15%'
		}, {
			field : 'room_name',
			title : '会议室',
			sortable: true,
			align : 'left',
			valign: 'middle',
			width : '10%'
		}, {
			field : 'starttime',
			title : '开始时间',
			sortable: true,
			cellStyle : cellStyle,
			align : 'center',
			width : '18%'
		}, {
			field : 'endtime',
			title : '结束时间',
			cellStyle : cellStyle,
			sortable: true,
			align : 'center',
			width : '18%'
		}, {
			field : 'USER_NAME',
			title : '申请人',
			sortable: true,
			align : 'left',
			valign: 'middle',
			width : '8%'
		}, {
			field : 'status',
			title : '状态',
			sortable: true,
			cellStyle : cellStyle,
			align : 'center',
			valign: 'middle',
			formatter : function(value, row) {
				if (value == 0)
					return '<span class="label label-default">未发送</span>';
				if (value == 1)
					return '<span class="label label-warning">审批中</span>';
				if (value == 2)
					return '<span class="label label-success">已批准</span>';
				if (value == 3)
					return '<span class="label label-danger">未通过</span>';
			},
			width : '8%'
		}, {
			field : 'ts',
			title : '登记时间',
			cellStyle : cellStyle,
			sortable: true,
			align : 'center',
			valign: 'middle',
			width : '18%'
		} ],
		onClickRow:function(row,tr){
			var id = row.id_;
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
	$('#starttime1').val(data.start_time);
	$('#endtime1').val(data.end_time);
	$('#purpose').val(data.purpose);
	$('#resource').val(data.resource);
	$('#remark').val(data.remark);
}

function searchMeetingRoom() {
	meetingname = $('#input-word').val();
	document.getElementById("search_form").reset();
	if( meetingname == '请输入会议标题'){
		meetingname = "";
	}else{
		/*var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
		if(meetingname.match(reg)==null){
			layerAlert("输入内容含有非法字符！");
			return;
		}*/
	}
	$("#dtlist").bootstrapTable('refresh',{
		url : "roomApply/findRoomApplyData",
		query:{
			modCode : modCode,
		    meetingname : meetingname
		}
	});
}