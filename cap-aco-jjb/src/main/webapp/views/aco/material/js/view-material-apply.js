$(function() {
	var id = $("#id").val();
	var url = 'bizMaterialStockController/findChoosedMaterialById/'+id;
	initTable(url);
});

function initTable(url){
	$('#chooseGoodsList').bootstrapTable({
		url : url, // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : false, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					rows : params.limit, // 页面大小
					page : params.offset, // 页码
				};
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
		columns : [{
			field : 'index',
			title : '序号',
			formatter : function(value, row, index) {
				return index + 1;
			}
		},{
			field : 'm_name_',
			title : '物品名称',
		}, {
			field : 'm_number_',
			title : '物品编号',
		}, {
			field : 'stock_',
			title : '物品库存',
			align : 'left'
		},{
			field : 'amount_',
			title : '出库数量'
		}, ]

	});
}

