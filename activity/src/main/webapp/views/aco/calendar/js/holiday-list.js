/**
 * 页面初始化
 */
$(function() {
	initHoliDayList();
});

/**
 * 查询操作
 */
function findByCondition(){
	var holiName = $("#search").val();
	if (holiName == '请输入节日名称查询') {
		holiName = "";
	}
	$('#holidayDataGrid').datagrid({
		url : 'bizCalendarController/findBizCalendarHolidayData',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams:{
			holiName : holiName
		},
		pagination : true,
		nowrap : false,
		pageSize : 10,
		columns : [[ {field:'ck', checkbox:true},
		             {field:'ID',hidden:true},
		             {field:'HOLIDAY_NAME',title : '节日名称', width:135, align:'left'},
		             {field:'HOLIDAY_NUM',title : '节日天数', width:85, align:'left'},
		             {field:'HOLIDAY_START_DATE',title : '开始日期', width:135, align:'left'},
		             {field:'HOLIDAY_END_DATE',title : '结束日期', width:135, align:'left'},
		             {field:'DATA_USER_ID',title : '创建用户', width:135, align:'left'},
		             {field:'HOLIDAY_REMARK',title : '备注', width:165, align:'left'}
				] ]
	});
	$('#holidayDataGrid').datagrid('load');
	$('#holidayDataGrid').datagrid('clearSelections'); // 清空选中的行
}

/**
 * 清空查询框值
 */
function clearSearchBox(){
	 $("#search").searchbox("setValue","");
	 findByCondition();
}

/**
 * 初始化信息
 */
function initHoliDayList(){
	$('#holidayDataGrid').datagrid({
		url : 'bizCalendarController/findBizCalendarHolidayData',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		columns : [[ {field:'ck', checkbox:true},
		             {field:'ID',hidden:true},
		             {field:'HOLIDAY_NAME',title : '节日名称', width:135, align:'left'},
		             {field:'HOLIDAY_NUM',title : '节日天数', width:85, align:'left'},
		             {field:'HOLIDAY_START_DATE',title : '开始日期', width:135, align:'left'},
		             {field:'HOLIDAY_END_DATE',title : '结束日期', width:135, align:'left'},
		             {field:'DATA_USER_ID',title : '创建用户', width:135, align:'left'},
		             {field:'HOLIDAY_REMARK',title : '备注', width:165, align:'left'}
				] ]
	});
	$('#holidayDataGrid').datagrid('load');
	$('#holidayDataGrid').datagrid('clearSelections'); // 清空选中的行
}

/**
 * 新增节假日信息
 */
function doAddHoliday(){
	$('#holiday_dialog').form('clear');
	$('#holiday_dialog').dialog("open");
}

/**
 * 修改单行信息
 * */
function doUpdate(){
	var nodes = $('#holidayDataGrid').treegrid('getChecked');
	if(nodes==null||nodes.length!=1){
		layer.tips('请选择一行进行修改', '#btn_holiday_modify', { tips: 3 });
		return;
	}
	$.ajax({
		type : "POST",
		url : "bizCalendarController/findBizCalendarHolidayDataById",
		data : {"Id":nodes[0].ID},
		success : function(data) {
			$('#holiday_dialog').form('clear');
			$("#ID").val(data.ID);
			$("#HOLIDAY_NAME").val(data.HOLIDAY_NAME);
			$("#HOLIDAY_NUM").val(data.HOLIDAY_NUM);
			$("#HOLIDAY_START_DATE").textbox("setValue",data.HOLIDAY_START_DATE);
			$("#HOLIDAY_END_DATE").textbox("setValue",data.HOLIDAY_END_DATE);
			$("#HOLIDAY_REMARK").textbox("setValue",data.HOLIDAY_REMARK);
			$('#holiday_dialog').dialog("open");
		},
		error : function(data) {
			layerAlert("error:" + data.responseText);
		}
	});
}

/**
 * 删除单行信息
 * */
function doDel(){
	var selecteds = $('#holidayDataGrid').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		layer.tips('请选择操作项', '#btn_holiday_delete', { tips: 3 });
		return;
	}
	
	$.messager.confirm('删除此信息','确定删除？',function(r){
	    if (r){
	    	var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].ID + ",";
			});
			ids = ids.substring(0, ids.length - 1);
	    	$.ajax({
	    		type : "POST",
	    		url : "bizCalendarController/doDelCalendarHoliDayById",
	    		data : {"Id":ids},
	    		success : function(data) {
	    			if(data=="1"){
	    				$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
	    			}else{
	    				$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
	    			}
	    			initHoliDayList();
	    		},
	    		error : function(data) {
	    			layerAlert("error:" + data.responseText);
	    		}
	    	});
	    }
	});
}

/*
 * 解决IE8不支持trim函数去除空格的问题
 */
String.prototype.trim = function() {
	return this.replace(/(^\s*)|(\s*$)/g, "");
}

/**
 * 保存或修改信息
 * */
function doSaveOrUpdateHoliday(){
	var HOLIDAY_NAME = $("#HOLIDAY_NAME").val().trim();
	var HOLIDAY_START_DATE = $('#HOLIDAY_START_DATE').textbox('getValue');
	var HOLIDAY_END_DATE = $('#HOLIDAY_END_DATE').textbox('getValue');
	var HOLIDAY_NUM = $("#HOLIDAY_NUM").val().trim();
	if(HOLIDAY_NAME==null||HOLIDAY_NAME.length==0){
		$.messager.alert('提示', '节日不能为空！', 'info');
		return;
	}
	/*
	 * if(HOLIDAY_NUM==null||HOLIDAY_NUM.length==0){
		$.messager.alert('提示', '节日天数不能为空！', 'info');
		return;
	}
	if(HOLIDAY_START_DATE==null||HOLIDAY_START_DATE.length==0||HOLIDAY_END_DATE==null||HOLIDAY_END_DATE.length==0){
		$.messager.alert('提示', '开始时间或结束时间不能为空！', 'info');
		return;
	}
	 */
	$.ajax({
		type : "post",
		url : "bizCalendarController/doSaveOrUpdateCalendarHoliday",
		data : $('#holiday_form').serialize(),
		dataType:'json',
		success : function(data) {
			if(data=="1"){
				$.messager.show({ title:'提示', msg:'保存成功', showType:'slide' });
			}else{
				$.messager.show({ title:'提示', msg:'保存失败', showType:'slide' });
			}
			$('#holiday_dialog').dialog('close');
			initHoliDayList();
		},
		error : function(data) {
			layerAlert("error:" + data.responseText);
		}
	});
}

/**
 * 自动赋值天数
 * */
function getDays(){
	var start = $('#HOLIDAY_START_DATE').textbox('getValue');
	var end = $('#HOLIDAY_END_DATE').textbox('getValue');
	if(start==null||start.length==0||end==null||end.length==0){
		
	}else{
		var days = DateDiff(start, end);
		$("#HOLIDAY_NUM").val(days);
	}
}

/**
 * 返回天数
 * */
function DateDiff(start, end) {  
    var aDate, oDate1, oDate2, iDays;
    aDate = start.split("-");
    oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);  //转换为yyyy-MM-dd格式
    aDate = end.split("-");
    oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);
    var gap = oDate2 - oDate1;
    if(gap<0){
    	$.messager.alert('提示', '结束时间必须大于开始时间！', 'info');
    	return "";
    }
    iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 / 24); //把相差的毫秒数转换为天数
    iDays = iDays + 1;
    return iDays;
}