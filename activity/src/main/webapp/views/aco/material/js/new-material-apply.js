var idss = [];
var stock = 0;//库存数量
$(function() {
	
	initChoosedGoodsTable();
	initTable();
	
	//物品入库按钮方法
	$("#mt_btn_openDialog").click(function() {
		$("#dtlist").bootstrapTable('refresh',{
			url:'bizMaterialStockController/findAllStock',pageSize : 5});
		idss.length = 0;
		//弹出模态窗口
		$('#myModal').modal({
			backdrop : 'static',
			keyboard : false
		});

	});
	//搜索方法
	$("#searchData").click(function(){
		$("#dtlist").bootstrapTable('refresh');
	});
	//选择要出库的物品提交
	$("#submitList").click(function(){
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow == null || selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}else{
			$(selectRow).each(function(index) {
				idss[index] = selectRow[index].id_;
			});
			$('#myModal').modal('hide');
			$("#chooseGoodsList").bootstrapTable('refresh',
					{url : 'bizMaterialStockController/findChoosedStock'}
			);
			idss.length = 0;
		}
		
	});
	
});

function initTable(){
	$('#dtlist').bootstrapTable({
		url : '', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					rows : params.limit, // 页面大小
					page : params.offset, // 页码
					mname : $("#input-word").val()
				};
				return temp;
			},// 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 5, // 每页的记录行数（*）
		pageList : [ 5,10],
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
		columns : [ {
			checkbox : true
		}, {
			field : 'index',
			title : '序号',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'm_name_',
			title : '物品名称',
			align : 'left'
		}, {
			field : 'm_number_',
			title : '物品编号',
			align : 'left'
		}, {
			field : 'standard_',
			title : '规格型号',
			align : 'left'
		}, {
			field : 'unit_',
			title : '计量单位',
			align : 'left'
		}, {
			field : 'amount_',
			title : '库存数量',
			align : 'left'
		}]
	});
}

//加载
function initChoosedGoodsTable(){
	$('#chooseGoodsList').bootstrapTable({
		url : '', // 请求后台的URL（*）
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
					ids : idss
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
		onClickCell : function(field,value,row,$element){
			stock =row.stock_;
		},
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
			title : '物品名称'
		}, {
			field : 'm_number_',
			title : '物品编号'
		}, {
			field : 'stock_',
			title : '物品库存',
			align : 'left'
		},{
			field : 'innumber_',
			title : '出库数量',
			editable : {
				//type : 'number',
				validate : function(value) {
					var reg = /^[0-9]*[1-9][0-9]*$/;
					if(reg.test(value)){
						if ($.trim(value) == '') {
							return '出库数量不能为空！';
						} else if ($.trim(value) < 0) {
							return '请输入非负数！';
						}else if($.trim(value) > stock){
							return '出库数量不能大于库存数量！';
						}
					}else{
						return '出库数量必须为数字！';
					}
				}
			},
			formatter : function(value) {
				return 0;
			}
		}]

	});
}

function writeObj(obj){   var description = "";   for(var i in obj){    var property=obj[i];    description+=i+" = "+property+"\n";   }   alert(description);  } 

//出库框提交方法
function send(){
	var action = 'send';
	submitForm(action);
}


function save(){
	var action = 'save';
	submitForm(action);
}

function submitForm(action){
	var allData = $("#chooseGoodsList").bootstrapTable('getData');
	if (allData == null || allData.length == 0) {
		layerAlert("未选择物品！");
		return false;
	}
	var user = $("#user").val();
	if (user == null || user == '') {
		layerAlert("请填写领用人！");
		return false;
	}
	var userorg = $("#userorg").val();
	if (userorg == null || userorg == '') {
		layerAlert("请填写标领用部门！");
		return false;
	}
	var title = $("#title").val();
	if (title == null || title == '') {
		layerAlert("请填写标题！");
		return false;
	}
	var material = '';
	var flag = false;
	$(allData).each(function(index) {
		var id = allData[index].id_;
		var innumber = allData[index].innumber_;
		if(innumber == undefined || innumber == 0){
			flag = true;
		}
		material = material + id + "==" + innumber + ",";
	});
	if(flag){
		layerAlert("物品出库数量不能为零");
		return false;
	}
	material = material.substring(0, material.length - 1);
	$.ajax({
		url : 'bizMaterialApplyController/doAddMaterialApply/' + material+'/'+action,
		type : "POST",
		dataType : 'json',
		data:$("#ff").serialize(),
		success : function(result) {
			if(result == true){
				window.parent.parent.closePage(window.parent,true,true,true);
			}
		}
	});
}
