	Date.prototype.format = function(format){
		var o = {
			"M+" : this.getMonth()+1, //month
			"d+" : this.getDate(), //day
			"h+" : this.getHours(), //hour
			"m+" : this.getMinutes(), //minute
			"s+" : this.getSeconds(), //second
			"q+" : Math.floor((this.getMonth()+3)/3), //quarter
			"S" : this.getMilliseconds() //millisecond
		}

		if(/(y+)/.test(format)) {
			format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
		}

		for(var k in o) {
			if(new RegExp("("+ k +")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
			}
		}
		return format;
	}
	
function getOneTableSelect(tableId){
	var selectOneRow = $("#"+tableId).bootstrapTable('getSelections');
	if (selectOneRow.length != 1) {
		layerAlert("请选择一条记录！");
		return null;
	}
	var selectedTr = $("#"+tableId+" tr.selected");
	if(selectedTr.length!=1){
		layerAlert("请选择一条记录！");
		return null;
	}
	return selectOneRow;
}
$(function() {
	iniTable(searchKey);
});
function iniTable(arcName){
	
	$('#arcPubList').bootstrapTable({
		url : 'arcPubInfo/doPageFindByArcName', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
//		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageNum : params.offset, // 页码
				pageSize : params.limit, // 页面大小
				arcName : arcName
			};
			return temp;
		},// 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 5, // 每页的记录行数（*）
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
		columns : [ {
			radio : true
		}, {
			field : 'id',
			visible: false,
			formatter : function(value, row, index) {
				return row.Id;
			}
		},{
			field : 'arcId',
			visible: false,
			formatter : function(value, row, index) {
				return row.arcId;
			}
		},
		{
			field : 'index',
			title : '序号',
			align : 'center',
			valign : 'middle',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'regTime',
			title : '登记日期',
			align : 'left',
			valign : 'middle',
			  formatter : function(val, row) {
				  var date = new Date(row.regTime);
					return date.format("yyyy-MM-dd");
				}
		},{
			field : 'arcName',
			title : '文件标题',
			align : 'left',
			valign : 'middle',
			  formatter : function(val, row) {
					return row.arcName;
				}
		}],
		onCheck: function(row, tr) {
			var selectOneRow = getOneTableSelect('arcPubList');
			if(selectOneRow==null){
				return;
			}
			if(selectOneRow.length>1){
				layerAler("请只选择一条数据！");
			}
			if(selectOneRow.length==1){
				$('#arcId').val(selectOneRow[0].arcId);
				window.parent.loadAttList(selectOneRow[0].arcId);
			}
		}
	});
}