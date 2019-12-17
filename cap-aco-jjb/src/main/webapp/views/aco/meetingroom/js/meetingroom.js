var url;
var action;
var checkId = -1;
var flag=0;	
var selectionIds = [];
$(function(){
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
	
	/*
	 * 操作方法
	 */
	window.operateEvents = {
	    'click .update': function (e, value, row, index) {
	    	stopPropagation();
	    	var id = row.id_;
	    	$.ajax({
				url: 'meetingRoom/findMTGRoomById/'+id,
				dataType:'json',
				success: function(data){
					setValue(data);
					$('#myModalLabel').text('修改会议室');
					url = 'meetingRoom/doUpdateMeetingRoom';
					action = 'open';
					showOrHideModal(action);
					$("#room_namem").prop("disabled",true);
					$("#room_numm").attr("disabled",true);
				}
			});
	    }
	};
})

$(document).ready(function(){
	initTable();
	$("#mt_btn_new").click(function() {
		$('#myModalLabel').text('新增会议室');
		url = 'meetingRoom/doAddMeetingRoom';
		action = 'open';
		clearForm();
		checkId = -1;
		showOrHideModal(action);
		$("#room_namem").removeAttr("disabled");
		$("#room_numm").removeAttr("disabled");
	});

	// 修改按钮
	$("#mt_btn_edit").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单行进行修改！");
			return flse;
		}
		var id = selectRow[0].id;
		checkId = id;
		$.ajax({
			url: 'meetingRoom/findMTGRoomById/'+id,
			dataType:'json',
			success: function(data){
				setValue(data);
				$('#myModalLabel').text('修改会议室');
				url = 'meetingRoom/doUpdateMeetingRoom';
				action = 'open';
				showOrHideModal(action);
				$("#room_namem").prop("disabled",true);
				$("#room_numm").attr("disabled",true);
			}
		});
	});
	
	// 查看
	$("#mt_btn_view").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单行进行查看！");
			return flse;
		}
		var id = selectRow[0].id;
		$.ajax({
			url: 'meetingRoom/findMTGRoomById/'+id,
			dataType:'json',
			success: function(data){
				setValue(data);
				$('#myModalLabel').text('查看会议室');
				url = 'meetingRoom/doUpdateMeetingRoom';
				action = 'hide';
				showOrHideModal(action);
			}
		});
	});

	// 删除按钮
	$("#mt_btn_delete").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}
		var ids = [];
		$(selectRow).each(function(index) {
			ids[index] = selectRow[index].id_;
		});
		
		layer.confirm('确定删除吗？', {
			btn : [ '是', '否' ]
		}, function() {
			$.ajax({
				url : 'meetingRoom/doDelMeetingRoom',
				dataType : 'json',
				data : {
					ids : ids
				},
				success : function(data) {
					if(data != 0){
						layerAlert("删除失败，但有   "+data+" 个会议室因已被预订或正在使用不能删除！");
					} else{
						layerAlert("删除成功");
						  var totalRows=$('#dtlist').bootstrapTable('getOptions').totalRows;
							if(totalRows>0&&(totalRows%10)==1){
								flag=1;
							}
					}
					$("#dtlist").bootstrapTable('refresh');
				},
				error : function(result) {
					layerAlert(result);
				}
			});
		});
		
	});
	
	/*高级搜索*/
	$("#supperSearch_search").click(function() {
		$("#input-word").val("");
		$("#dtlist").bootstrapTable('refresh',{
			url : "meetingRoom/findAllMTGRoom",
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
			url : "meetingRoom/findAllMTGRoom",
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
			url : "meetingRoom/findAllMTGRoom",
			query:{	
				query : $("#search_form").serialize(),
			}
		});
		$("#searchDiv").hide();
	});
	
	/* 按钮方法结束 */
	$("#myModal").on("show.bs.modal", function () {
		//myModal form表单移除提示信息
		$('#ff').find('div .formError').remove();
	})
	$('#ff').validationEngine({
	});
});

function saveRoomInfo(){
	if($('#ff').validationEngine('validate')){
		$.ajax({
			type : "POST",
			url : url,
			data: $("#ff").serialize(),
			dataType:"json",
			/*beforeSend:function(){
				$("#savebutton").attr("disabled","disabled");
			},*/
			success : function(data) {
				if(data.result=='true'){
					layerAlert("保存成功！");
					$('#myModal').modal('hide');
					$("#dtlist").bootstrapTable('refresh');
					checkId = -1;
				}else if(data.result=='roomname'){
					layerAlert("会议室名称已存在！");
				}else if(data.result=='roomnum'){
					layerAlert("会议室编号已存在！");
				}else{
					layerAlert("保存失败！");
				}
			}/*,
			complete: function(){
				$("#savebutton").removeAttr("disabled");
			}*/
		});
	}
}

var roomName = '';
function initTable(){
	$('#dtlist').bootstrapTable({
		url : 'meetingRoom/findAllMTGRoom', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "desc", // 排序方式
		queryParams : function(params) {
			roomName = $("#input-word").val();
			var roomNameHidden=$("#input-word-hidden").val();
			if(roomName == '请输入会议室名称查询'){
				roomName="";
			}else{
				/*var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
				if(roomName.match(reg)==null){
					layerAlert("输入内容含有非法字符！");
					return;
				}*/
			}
			if(roomName!=roomNameHidden){
				params.offset=0;
				$("#input-word-hidden").val(roomName);
			}
			if(flag==1){
            	params.offset=params.offset- params.limit;
            	flag=0;
            }
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				rows : params.limit, // 页面大小
				page : params.offset, // 页码
				roomName : roomName,
				sortName:this.sortName,
	            sortOrder:this.sortOrder,
	            query : $("#search_form").serialize()
			};
			return temp;
		}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		//pageSize : 10, // 每页的记录行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		//strictSearch : false,
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
			field: 'checkStatus',
			checkbox : true
		}, {
			field : 'index',
			title : '序号',
			halign: 'center',
			align : 'center',
			valign: 'middle',
			width : '5%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'room_name',
			title : '会议室名称',
			halign: 'left',
			align : 'left',
			width : '15%',
			sortable: true,
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
			field : 'room_num',
			title : '会议室编号',
			halign: 'right',
			align : 'right',
			width : '12%',
			sortable: true,
		}, {
			field : 'seats',
			title : '座位数',
			halign: 'right',
			sortable: true,
			align : 'right',
			valign: 'middle',
			width : '10%',
		}, {
			field : 'area',
			title : '面积',
			sortable: true,
			halign: 'right',
			align : 'right',
			valign: 'middle',
			width : '10%',
		}, {
			field : 'floor',
			title : '楼层',
			sortable: true,
			halign: 'center',
			align : 'center',
			cellStyle : cellStyle,
			width : '10%',
		}, {
			field : 'projector',
			title : '投影仪',
			sortable: true,
			halign: 'center',
			align : 'center',
			cellStyle : cellStyle,
			valign: 'middle',
			width : '10%',
			formatter : function(value, row) {
				if (value == 1){
					return '支持';
				}else{
					return '不支持';
				}
			}
		}, {
			field : 'video_conference',
			title : '多媒体',
			sortable: true,
			cellStyle : cellStyle,
			halign: 'center',
			align : 'center',
			valign: 'middle',
			width : '10%',
			formatter : function(value, row) {
				if (value == 1){
					return '支持';
				}else{
					return '不支持';
				}
			}
		},{
			field : 'status',
			title : '状态',
			cellStyle : cellStyle,
			sortable: true,
			align : 'center',
			halign: 'center',
			valign: 'middle',
			width : '10%',
			formatter : function(value, row) {
				if (value == 1)
					return '<span class="label label-success">启用</span>';
				if (value == 0)
					return '<span class="label label-danger">禁用</span>';
			}
		},{
			field: 'operate',
            title: '操作',
            halign: 'center',
            align:'center',
            width : '8%',
            events: operateEvents,
            formatter: operateFormatter
		},],
		onClickRow : function(row, tr) {
			var id = row.id_;
			$.ajax({
				url: 'meetingRoom/findMTGRoomById/'+id,
				dataType:'json',
				success: function(data){
					setValue(data);
					$('#myModalLabel').text('查看会议室');
					url = 'meetingRoom/doUpdateMeetingRoom';
					action = 'hide';
					showOrHideModal(action);
				}
			});
		}
	});
}

function searchMeetingRoom() {
	roomName = $("#input-word").val();
	if(roomName == '请输入会议室名称查询'){
		roomName="";
	}else{
		/*var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
		if(roomName.match(reg)==null){
			layerAlert("输入内容含有非法字符！");
			return;
		}*/
	}
	document.getElementById("search_form").reset();
	$("#dtlist").bootstrapTable('refresh');
	
}


function advSearchModal(){
	var display =$("#searchDiv").css('display');
	if(display == "none") {
		$("#searchDiv").show();
	}else {
		$("#searchDiv").hide();
	}
}

function submitForm(form, valid){
	$.ajax({
		type : "POST",
		url : url,
		data: form.serialize(),
		async: false,
		success : function(data) {
			if(data=='true'){
				$('#myModal').modal('hide');
				$("#dtlist").bootstrapTable('refresh');
				checkId = -1;
			}
			if(data=='warn'){
				layerAlert("数据格式不正确，请重新输入！");
			}
			if(data=='false'){
				layerAlert("后台异常，数据保存失败!");
			}
		}
	});
}

//重置表单
function clearForm(){
	document.getElementById("ff").reset();
}

function showOrHideModal(action){
	if(action =='open'){
		$('input,select,textarea',$('form[id="ff"]')).removeAttr('disabled');
		$('#btnDiv').show();
		$('#btnDiv1').hide();
	}else{
		$('input,select,textarea',$('form[id="ff"]')).attr('disabled',true);
		$('#btnDiv').hide();
		$('#btnDiv1').show();
	}
	$('#myModal').modal({
		backdrop : 'static',
		keyboard : false
	});
}

//表单回显
function setValue(data){
	$('#idm').val(data.id);
	$('#sortm').val(data.sort);
	$('#tsm').val(data.ts);
	$('#recorddatem').val(data.record_date);
	$('#recorduseridm').val(data.record_userid);
	$('#room_namem').val(data.room_name);
	$('#room_numm').val(data.room_num);
	$('#seatsm').val(data.seats);
	$('#statusm').val(data.status);
	$('#projectorm').val(data.projector);
	$('#videoconferencem').val(data.video_conference);
	$('#floorm').val(data.floor);
	$('#aream').val(data.area);
	$('#addressm').val(data.address);
	$('#remarkm').val(data.remark);
}
function writeObj(obj){ 
	 var description = ""; 
	 for(var i in obj){ 
	 var property=obj[i]; 
	 description+=i+" = "+property+"\n"; 
	 } 
	 alert(description); 
	}

/**
 * 操作格式化
 * @param value
 * @param row
 * @param index
 * @returns
 */
function operateFormatter(value, row, index) {
    return [
        '<a class="update" style="color:#167495;" href="javascript:void(0)" title="修改">',
        '<i class="fa fa-pencil"></i>',
        '</a>'
    ].join('');
}



