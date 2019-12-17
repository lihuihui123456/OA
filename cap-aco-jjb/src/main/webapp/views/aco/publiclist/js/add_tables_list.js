//记录添加删除操作对象
var rowObj = {};
$(document).ready(function() {
	//传来的列数据
	var columnJsonObj = eval(columnJsonStr);
	//传来的行数据
	var jsonDataObj = eval(jsonData);
	
	//如果行数据为空，默认建造一个空行数据
	if(jsonData == "[]"){
		var dataObj = {};
		$.each(columnJsonObj,function(index,value){
			dataObj[value["field"]] = "";
		});
		jsonDataObj[0] = dataObj;
	}
	
	//添加列前缀序号
	columnJsonObj.unshift(
			{
				field : 'columnId',
				title : '序号',
				formatter: indexFormatter,
				valign: 'middle',
				align : 'center',
				halign: 'center'
			}
	)
	//添加操作列（增加删除操作列）
	columnJsonObj.push(
			{
				field : '',
				title : '操作',
				events: operateEvents,
				formatter: operateFormatter,
				valign: 'middle',
				align : 'center',
				halign: 'center'
			} 
	)
	//为行数据赋唯一ID值
	$.each(jsonDataObj,function(index,value){
		value["columnId"] = new Date().getTime()+index;
	});
	//初始化table
	$table = $('#'+id).bootstrapTable({
		classes: 'table',
		resizable:true,
		columns:columnJsonObj,
		data: jsonDataObj,
		uniqueId: "columnId",
		height: 166
	});
} );
/**
 * 操作格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function operateFormatter(value, row, index) {
    return [
		'<a tabindex="-1" class="addRow" style="color:#167495;" href="javascript:void(0)" title="添加行">',
		'<i class="fa fa-plus"></i>',
		'</a>  ',
		 '<a tabindex="-1" class="removeRow" style="color:#167495;" href="javascript:void(0)" title="删除行">',
         '<i class="fa fa-remove"></i>',
         '</a>  ',
         
    ].join('');
}
//格式化输入框
function inputFormatter(value, row, index){
	return [
		"<input class=\"fd_input\" type=\"text\" onblur=upperCase('"+JSON.stringify(row)+"','"+this.field+"',this.value); value='"+value+"'/>"
	].join('');
}
//绑定动态更新表格数据方法
function upperCase(rowStr,rowName,value){
	rowStr = JSON.parse(rowStr);  
	if(typeof rowObj[rowStr.columnId] == "undefined"){
		rowStr[rowName] = value;
		rowObj[rowStr.columnId] = rowStr;
	}else{
		rowObj[rowStr.columnId][rowName] = value;
	}
}
//绑定固定ID列赋值自增
function indexFormatter(value, row, index) {
	return [index + 1].join('');
}
//保存返回整体表格数据方法
function saveFdTable(id){
	for(key in rowObj){
		$table.bootstrapTable('updateByUniqueId', {id: key, row: rowObj[key]});
	}
	var fdTableData = $('#'+id).bootstrapTable('getData');
	return fdTableData;
}
//操作列绑定点击事件
window.operateEvents = {
	'click .addRow': function (e, value, row, index) {
		for(key in rowObj){
			$table.bootstrapTable('updateByUniqueId', {id: key, row: rowObj[key]});
			delete rowObj[key];
		}
		var addRow = {};
		for(key in row){
			if(key == 'columnId'){
				addRow[key] = new Date().getTime();
			}else{
				addRow[key] = "";
			}
		}
		$table.bootstrapTable('insertRow', {index: index+1, row:addRow});
    },
    'click .removeRow': function (e, value, row, index) {
    	for(key in rowObj){
			$table.bootstrapTable('updateByUniqueId', {id: key, row: rowObj[key]});
			delete rowObj[key];
		}
    	if($table.bootstrapTable('getData').length == 1){
    		alert("您最少需要保留一行数据");
    	}else{
        	$table.bootstrapTable('removeByUniqueId', row.columnId);
    	}
    }
};




