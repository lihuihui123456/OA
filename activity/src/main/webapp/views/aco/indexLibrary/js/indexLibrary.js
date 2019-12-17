//翻页选中数组
var selectionIds = [];
$(function() {
	initTable();
	
	$("#add_btn").click(function(){
		date = new Date().getTime();
		var options = {
			"text" : "指标库新增-新增",
			"id" : date,
			"href" : "indexLibraryController/gotoIndexLibraryFron",
			"pid" : window
		};
		window.parent.parent.createTab(options);
	});
	
	
	/**
	 * 选中事件操作数组  
	 */
	 var union = function(array,ids){  
	     $.each(ids, function (i, ID_) {  
	         if($.inArray(ID_,array)==-1){  
	             array[array.length] = ID_;  
	         }  
	     });  
	      return array;  
	};
	
	/**
	 * 取消选中事件操作数组 
	 */
	var difference = function(array,ids){  
         $.each(ids, function (i, ID_) {  
              var index = $.inArray(ID_,array);  
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
	$('#indexLibTable').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
		var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
			return row.ID_;  
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
});

function qxButton(){
	$("#advSearchModal").hide();	
}
var deptName = "";
/**
 * 表格数据初始化
 */
var solId;
function initTable() {
	$('#indexLibTable').bootstrapTable({
		url : 'indexLibraryController/findIndexLibDateByQueryParams', // 请求后台的URL（*）
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
				deptName:$.trim(deptName)
			};
			deptName="";
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
		uniqueId : "id", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		singleSelect : true,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.ID_, selectionIds) !== -1;
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
			width: '50px',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'deptName',
			title : '部门',
			align : 'left',
			valign : 'middle',
			sortable : true,
			width: '12%'
		}, {
			field : 'proName',
			title : '项目名称',
			align : 'left',
			valign : 'middle',
			width: '12%',
			formatter : function(value, row, index) {
				if (value == '0') {
					return '"双优"评选项目';
				} else if (value == '0') {
					return '"丹柯杯"项目';
				} else {
					return '基本经费';
				}
			}
		}, {
			field : 'funcType',
			title : '功能分类',
			width: '12%',
			cellStyle : cellStyle,
			align : 'center',
			valign : 'middle',
			formatter : function(value, row, index) {
				if (value == '0') {
					return '会议费';
				} else {
					return '招待费';
				}
			}
		}, {
			field : 'budgetAmount',
			title : '预算总金额',
			align : 'center',
			width: '12%',
			valign : 'middle',
			cellStyle : cellStyle
		}, {
			field : 'deptExtAmount',
			title : '部门执行金额',
			width: '12%',
			cellStyle : cellStyle,
			align : 'center',
			valign : 'middle',
			formatter : function(value, row, index) {
				if(value==null||value==""){
					return "0";
				}else{
					return value;
				}
			}
		}, {
			field : 'deptResIndex',
			title : '部门剩余指标',
			align : 'center',
			width: '12%',
			cellStyle : cellStyle,
			valign : 'middle',
			formatter : function(value, row, index) {
				if(value==null||value==""){
					return "0";
				}else{
					return value;
				}
			}
		},{
			field : 'fincExtAmount',
			title : '财务执行金额',
			align : 'center',
			width: '12%',
			cellStyle : cellStyle,
			valign : 'middle',
			formatter : function(value, row, index) {
				if(value==null||value==""){
					return "0";
				}else{
					return value;
				}
			}
		},{
			field : 'actResIndex',
			title : '实际剩余指标',
			align : 'center',
			width: '12%',
			cellStyle : cellStyle,
			valign : 'middle',
			formatter : function(value, row, index) {
				if(value==null||value==""){
					return "0";
				}else{
					return value;
				}
			}
		}],
		onClickRow:function(row,tr){
			
		}
	});
}


/**
 *  查询方法
 */
function search() {
	var deptName = $.trim($("#input-word").val());
	if (deptName == '请输入部门查询') {
		deptName = "";
	}
	$("#indexLibTable").bootstrapTable('refresh',{
		url : "indexLibraryController/findIndexLibDateByQueryParams",
		query:{
			deptName : deptName
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


function doDelIndexLiarbryById(Id){
	var selectRow = $("#indexLibTable").bootstrapTable('getSelections');
	if(selectRow.length!=1){
		layerAlert("请选择一条数据!");
	}else{
		$.ajax({
			type : "POST",
			url : "indexLibraryController/doDelIndexLiarbryById",
			data : {Id:selectRow[0].id},
			success : function(data) {
				if(data=="1"){
					refreshTable("indexLibTable","indexLibraryController/findIndexLibDateByQueryParams");
					layerAlert("删除成功");
				}else{
					layerAlert("删除失败");
				}
			},
			error : function(data) {
				layerAlert("error:" + data.responseText);
			}
		});
	}
	
}


function doUpdateIndexLiarbryById(){
	var selectRow = $("#indexLibTable").bootstrapTable('getSelections');
	if(selectRow.length!=1){
		layerAlert("请选择一条数据!");
	}else{
		var options = {
			"text" : "指标库-修改",
			"id" : selectRow[0].id,
			"href" : "indexLibraryController/gotoIndexLibraryFron?id="+selectRow[0].id,
			"pid" : window
		};
		window.parent.parent.createTab(options);
	}
	
}



function formatDateTime(dateTime) {  
    var y = dateTime.getFullYear();  
    var m = dateTime.getMonth() + 1;  
    m = m < 10 ? ('0' + m) : m;  
    var d = dateTime.getDate();  
    d = d < 10 ? ('0' + d) : d;  
    var h = dateTime.getHours();
    h = h < 10 ? ('0' + h) : h; 
    var minute = dateTime.getMinutes();  
    minute = minute < 10 ? ('0' + minute) : minute;  
    var s = dateTime.getSeconds();
    s = s < 10 ? ('0' + s) : s;  

    return y + '-' + m + '-' + d+' '+h+':'+minute+':'+s;  
}
