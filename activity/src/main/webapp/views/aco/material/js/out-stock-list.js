var selectionIds = [];
$(function() {
	initTable();
	/**
    * 选中事件操作数组  
    */
    var union = function(array,ids){  
        $.each(ids, function (i, billid) {  
            if($.inArray(billid,array)==-1){  
                array[array.length] = billid;  
            }  
        });  
         return array;  
	};
	
	$('#input-word').bind('keypress', function (event) {
        if (event.keyCode == "13") {
        	searchData();
           return false ;   
        } });
	/**
     * 取消选中事件操作数组 
     */ 
    var difference = function(array,ids){  
            $.each(ids, function (i, billid) {  
                 var index = $.inArray(billid,array);  
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

	
	$('#gm_btn_new').click(function(){
		var options = {
				"text" : "填写物品领用单",
				"id" : "wply_add",
				"href" : "bizMaterialApplyController/tab?action=new",
				"pid":window
			};
		window.parent.createTab(options);
	});
	$('#gm_btn_edit').click(function(){
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if(selectRow.length != 1){
			layerAlert("请选择单条记录进行修改！");
			return false;
		}
		if(selectRow[0].status_ != 0){
			layerAlert("只能处理未送发的记录！");
			return false;
		}
		var id = selectRow[0].id_;
		var options = {
				"text" : "修改物品领用单",
				"pid"  : window,  //默认填写
				"id" : "wply_edit_"+id,
				"href" : "bizMaterialApplyController/tab?action=edit&id="+id,
				"pid":window
				
			};
			window.parent.createTab(options);
	});
	$('#gm_btn_view').click(function(){
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if(selectRow.length != 1){
			layerAlert("请选择单条记录进行查看！");
			return false;
		}
		var id = selectRow[0].id_;
		var options = {
				"text" : "查看物品领用单",
				"id" : "wply_out_view_"+id,
				"href" : "bizMaterialApplyController/tab?action=view&id="+id,
				"pid":window
			};
			window.parent.createTab(options);
	});
	$('#gm_btn_send').click(function(){
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if(selectRow == null||selectRow.length != 1){
			layerAlert("请选择操作项！");
			return;
		}else{
			if(selectRow[0].status_ != 0){
				layerAlert("只能处理未送发的记录！");
				return false;
			}
		}
		var id = selectRow[0].id_;
		var action = 'send';
		$.ajax({
			url: 'bizMaterialApplyController/doDealApply',
			type:'post',
			dataType : 'json',
			data:{
				id:id,
				action:action
			},
			success : function(result) {
				if(result == '2'){
					layerAlert("送交成功!");
				}else{
					layerAlert("送交失败!");
				}
				$('#dtlist').bootstrapTable('refresh');
			}
		});
	});
	$('#gm_btn_remove').click(function(){
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}
		var ids='';
		var flag = false;
		$(selectRow).each(function(index) {
			var status;
			ids = ids + selectRow[index].id_ + ",";
			status = selectRow[index].status_;
			if (status != '0') {
				flag = true;
			}
		});
		if (flag) {
			layerAlert("只能删除未发的记录！");
			return false;
		}
		ids = ids.substring(0, ids.length - 1);
		layer.confirm('确定删除吗？', {
			btn : [ '是', '否' ]
		}, function() {
			$.ajax({
				url: 'bizMaterialApplyController/doDeleteByIds',
				type:'post',
				dataType : 'json',
				data:{ids:ids},
				success : function(result) {
					if(result = 'true'){
						layerAlert("删除成功！");
						$('#dtlist').bootstrapTable('refresh');
					}
				}
			});
		});
	});
});

var title='';
function initTable(){
	$('#dtlist').bootstrapTable({
		url : 'bizMaterialApplyController/findMaterialApplyRecordsQuery/consumer', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			validateData();
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					pageSize : params.limit, // 页面大小
					pageNum : params.offset, // 页码
					title_:$.trim(title),
					user:$.trim($("#user").val()),
					operator:$.trim($("#operator").val()),
					status_:$.trim($("#status_").val()),
					startRegisterTime:$.trim($("#startTime").val()),
					endRegisterTime:$.trim($("#endTime").val()),
					sortName:this.sortName,
					sortOrder:this.sortOrder
				};
			    title="";
				return temp;
/*			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					pageSize : params.limit, // 页面大小
					pageNum: params.offset, // 页码
					title : function (){
						if($("#input-word").val()=="请输入标题查询"){
							return '';
						}else{
							return $("#input-word").val();
						}
					}
			};*/
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
		uniqueId : "id_", // 每一行的唯一标识，一般为主键列
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
			width : '3%',	
		}, {
			field : 'index',
			title : '序号',
			width : '5%',	
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'title_',
			title : '标题',
			align : 'left',
			sortable : true,
			width : '15%'	
		}, {
			field : 'user',
			title : '领用人',
			width : '10%',	
			align : 'left',
			sortable : true
		},  {
			field : 'operator',
			title : '经办人',
			align : 'left',
			width : '10%',	
			sortable : true
		}, {
			field : 'register_time_',
			title : '申请时间',
			width : '15%',	
			align : 'center',
			sortable : true
		}, {
			field : 'status_',
			title : '状态',
			align : 'center',
			width : '10%',
			sortable : true,	
			formatter : function(value, row) {
				if (value == 0)
					return '<span class="label label-default">未发送</span>';
				if (value == 1)
					return '<span class="label label-warning">审批中</span>';
				if (value == 2)
					return '<span class="label label-success">已批准</span>';
				if (value == 3)
					return '<span class="label label-danger">未通过</span>';
			}
			
		} ],
		onClickRow:function(row,tr){
			var id = row.id_;
			var options = {
					"text" : "查看物品领用单",
					"id" : "wply_out_view_"+id,
					"href" : "bizMaterialApplyController/tab?action=view&id="+id,
					"pid":window
				};
				window.parent.createTab(options);
		}
	});
}

function searchData(){
	$("#search_form")[0].reset();
	title = $("#input-word").val();
	if(title == '请输入标题查询'){
		title = "";
	}else{
		/*var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
		if(title.match(reg)==null){
			layerAlert("输入内容含有非法字符！");
			return;
		}*/
	}
	$("#dtlist").bootstrapTable('refresh');
}
function validateData() {
	if($("#input-word").val()!="请输入标题查询"&&$("#input-word").val()!=""){
		title=$("#input-word").val();
		$("#search_form")[0].reset();
	}
	title=title+$("#title_").val();
/*	var startTime=$("#startTime").val();
	var endTime=$("#endTime").val();
	if(startTime!=""&&endTime!=""){
		if(startTime > endTime){
			window.parent.publicAlert("库存创建开始日期不能大于结束日期");
			return;
		}
	}*/
}
$(function(){
	$("#advSearchModal").click(function() {
		var display =$('#advSearch').css('display');
		if(display == "none") {
			$("#advSearch").show();
		}else {
			$("#advSearch").hide();
		}
	})
		$("#modal_close").click(function(){
			$("#advSearch").hide();	
		})
});

	/**
 *  高级查询方法
 */
function submitForm() {
/*    $('#advSearchModal').modal('hide');
*/   $("#input-word").val("请输入标题查询");
	$("#dtlist").bootstrapTable('refresh');
}
/**
 *  高级查询方法
 */
function clearForm() {
/*	 $('#advSearchModal').modal('hide');
*/		document.getElementById("search_form").reset();
        submitForm();
}