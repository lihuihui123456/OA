/**
 * 搜索
 */
function search() {
	var holiName = $("#input-word").val();
	if (holiName == '请输入节日名称查询') {
		holiName = "";
	}else{
		holiName = window.encodeURI(window.encodeURI(holiName));
	}
	$("#tb_holiday").bootstrapTable('refresh',{
		url : "bizCalendarController/findBizCalendarHolidayData",
		query:{
			holiName : holiName
		}
	});
}


$(document).ready(function() {
	/**
	 * 日期选择器初始化样式
	 */
	laydate.skin('dahong');
	
	/**
	 * 添加节假日信息
	 */
	$("#add_btn").click(function(){
		$('#ff').find('div .formError').remove();
		document.getElementById("ff").reset(); 
		$("#holidayModal").modal();
	});
	
	/**
	 * 保存节假日信息 
	 */
	$("#save_btn").click(function(){
		if ($('#ff').validationEngine('validate')) {
			$.ajax({
				type : "post",
				url : "bizCalendarController/doSaveOrUpdateCalendarHoliday",
				data : $('#ff').serialize(),
				dataType:'json',
				success : function(data) {
					if(data=="1"){
						layerAlert("保存成功!");
					}else{
						layerAlert("保存失败!");
					}
					$("#holidayModal").hide();
					$("#tb_holiday").bootstrapTable('refresh');
				},
				error : function(data) {
					layerAlert("error:" + data.responseText);
				}
			});
		}         
	});
	
	/**
	 * 新增重置
	 */
	$("#calendar").click(function(){
		document.getElementById("ff").reset(); 
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
	
	/**
	 * 表格数据初始化
	 */
	$('#tb_holiday').bootstrapTable({
		url : 'bizCalendarController/findBizCalendarHolidayData',
		method : 'post',
		contentType : "application/x-www-form-urlencoded",
		striped : true,
		cache : false,
		pagination : true,
		queryParams : function(params) {
			var temp = {
					pageSize : params.limit,
					pageNum : params.offset,
					holiName : $("#input-word").val()=="请输入节日名称查询"?"":$("#input-word").val(),
				    sortName:this.sortName,
	                sortOrder:this.sortOrder
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
		uniqueId : "ID",
		showToggle : false,
		cardView : false,
		detailView : false,
		singleSelect:true,
		columns : [{
			field : 'ID',
			title : 'ID',
			visible : false
		}, {
			field : 'index',
			title : '序号',
			halign: 'center',
			align:'center',
			valign: 'middle',
			width: '5%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, 
		{
			field : 'HOLIDAY_NAME',
			title : '节日名称',
			valign: 'middle',
			cellStyle:cellStyle,
			align:'center',
			halign: 'center',
		    sortable: true
		}, {
			field : 'HOLIDAY_NUM',
			title : '节日天数',
			halign: 'center',
			align:'center',
			cellStyle:cellStyle,
			valign: 'middle',
			sortable: true,
			formatter:formatterHoliDayNum
		}, {
			field : 'HOLIDAY_START_DATE',
			title : '开始日期',
			align:'center',
			valign: 'middle',
			cellStyle:cellStyle,
			halign: 'center',
			sortable: true
		}, {
			field : 'HOLIDAY_END_DATE',
			title : '结束日期',
			align:'center',
			cellStyle:cellStyle,
			halign: 'center',
			valign: 'middle',
			sortable: true
		}, {
			field : 'DATA_USER_ID',
			title : '创建用户',
			align:'center',
			cellStyle:cellStyle,
			halign: 'center',
			valign: 'middle',
			sortable: true
		}, {
			field : 'HOLIDAY_REMARK',
			title : '备注',
			halign: 'center',
			cellStyle:cellStyle,
			visible :'middle',
			sortable: true,
			formatter: formatterRemark
		},{
			 field: 'operate',
             title: '操作',
             halign: 'center',
             align:'center',
             events: operateEvents,
             formatter: operateFormatter
		} ],
	});
});

function formatterHoliDayNum(value, row, index){
	return '<span class="label label-danger">共'+value+'天</span>';
}


function formatterRemark(value, row, index){
	/**
	 * 格式化标题
	 */
	if(value.length>10){
		return "<span title='"+value+"'>"+value.substring(0,9)+"...</span>"
	}else{
		return "<span>"+value+"</span>"
	}
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
        '<a class="edit" href="javascript:void(0)" title="修改">',
        '<i class="fa fa-pencil"></i>',
        '</a>  ',
        '<a class="del" href="javascript:void(0)" title="删除">',
        '<i class="fa fa-remove"></i>',
        '</a>'
    ].join('');
}

/**
 * 操作方法
 */
window.operateEvents = {
    'click .edit': function (e, value, row, index) {
    	$.ajax({
    		type : "POST",
    		url : "bizCalendarController/findBizCalendarHolidayDataById",
    		data : {"Id":row.ID},
    		success : function(data) {
    			$("#ID").val(data.ID);
    			$("#HOLIDAY_NAME").val(data.HOLIDAY_NAME);
    			$("#HOLIDAY_NUM").val(data.HOLIDAY_NUM);
    			$("#HOLIDAY_START_DATE").val(data.HOLIDAY_START_DATE);
    			$("#HOLIDAY_END_DATE").val(data.HOLIDAY_END_DATE);
    			$("#HOLIDAY_REMARK").val(data.HOLIDAY_REMARK);
    			$("#holidayModal").modal('show');
    		},
    		error : function(data) {
    			layerAlert("error:" + data.responseText);
    		}
    	});
    },
    'click .del': function (e, value, row, index) {
    	$.ajax({
    		type : "POST",
    		url : "bizCalendarController/doDelCalendarHoliDayById",
    		data : {"Id":row.ID},
    		success : function(data) {
    			if(data=="1"){
    				layerAlert("删除成功!");
    			}else{
    				layerAlert("删除失败!");
    			}
    			$("#tb_holiday").bootstrapTable('refresh');
    		},
    		error : function(data) {
    			layerAlert("error:" + data.responseText);
    		}
    	});
    	
    }
};
