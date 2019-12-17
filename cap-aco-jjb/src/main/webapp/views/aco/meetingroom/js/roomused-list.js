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
	
	$("#mt_btn_view").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单条记录进行查看！");
			return false;
		}
		viewForm(selectRow[0].room_apply_id)
	});
	
	/*高级搜索*/
	$("#supperSearch_search").click(function() {
		$("#input-word").val("");
		$("#dtlist").bootstrapTable('refresh',{
			url : "roomUsed/findRoomUsed",
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
			url : "roomUsed/findRoomUsed",
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
			url : "roomUsed/findRoomUsed",
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
		url : "roomUsed/findRoomUsed", // 请求后台的URL（*）
		method : 'get',
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
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "id_", // 每一行的唯一标识，一般为主键列
		singleSelect:true,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.id_, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [ /*{
			field : 'checkStatus',
			checkbox : true
		}, */{
			field : 'room_apply_id',
			visible:false
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			valign: 'middle',
			formatter : function(value, row, index) {
				return index + 1;
			},
			width : '6%'
		}, {
			field : 'meeting_name',
			title : '会议标题',
			sortable : true,
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
			},
			width : '24%'
		}, {
			field : 'USER_NAME',
			title : '申请人',
			sortable : true,
			align : 'left',
			width : '10%'
		}, {
			field : 'start_time',
			title : '开始时间',
			sortable : true,
			align : 'center',
			cellStyle : cellStyle,
			valign: 'middle',
			width : '20%'
		}, {
			field : 'end_time',
			title : '结束时间',
			sortable : true,
			align : 'center',
			cellStyle : cellStyle,
			valign: 'middle',
			width : '20%'
		}, {
			field : 'room_name',
			title : '会议室',
			sortable : true,
			align : 'left',
			width : '10%'
		}, {
			field : 'status',
			title : '状态',
			sortable : true,
			cellStyle : cellStyle,
			align : 'center',
			valign: 'middle',
			width : '10%'
		}],
		onClickRow:function(row,tr){
			viewForm(row.room_apply_id)
		}
	});
}

//搜索方法
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
		url : "roomUsed/findRoomUsed",
		query:{
			meetingname : meetingname
		}
	});
}

function viewForm(id){
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
function writeObj(obj){ 
	 var description = ""; 
	 for(var i in obj){ 
	 var property=obj[i]; 
	 description+=i+" = "+property+"\n"; 
	 } 
	 alert(description); 
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
