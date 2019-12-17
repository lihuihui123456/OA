var selectionIds = [];
$(function() {
	initTable();
	initWindowTable();
	
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
		$('#chooseGoodsList').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
	var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
	            return row.id_;  
	        });  
	        func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	        selectionIds = _[func](selectionIds, ids);   
	});  
	
	
	$("#mt_btn_all").addClass("state1");
	
	$("#mt_btn_new").click(function() {
		/*var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow == null || selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}

		$(selectRow).each(function(index) {
			idss[index] = selectRow[index].id;
		});
		$("#chooseGoodsList").bootstrapTable('refresh')
		idss.length = 0;*/
		$('#chooseGoodsList').bootstrapTable('refresh',{url:'bizMaterialController/findAllMaterialData'});
		$('#myModal').modal({
			backdrop : 'static',
			keyboard : false
		});

	});
	// 搜索方法
	$("#searchData").click(function() {
		$("#search_form")[0].reset();
		m_name_ = $("#input-word").val();
		if(m_name_ == '请输入物品名称查询'){
			m_name_="";
		}else{
//			var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
//			if(m_name_.match(reg)==null){
//				layerAlert("输入内容含有非法字符！");
//				return;
//			}
		}
		$("#dtlist").bootstrapTable('refresh',{
			url : "bizMaterialStockController/findAllStockQuery",
			query : {
				mode : mode,
				m_name_ : m_name_
			}
		});

	});
	
	$('#input-word').bind('keypress', function (event) {
        if (event.keyCode == "13") {
        	searchData();
           return false ;   
        } });
	
	function searchData(){
		$("#search_form")[0].reset();
		m_name_ = $("#input-word").val();
		if(m_name_ == '请输入物品名称查询'){
			m_name_="";
		}else{
//			var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
//			if(m_name_.match(reg)==null){
//				layerAlert("输入内容含有非法字符！");
//				return;
//			}
		}
		$("#dtlist").bootstrapTable('refresh',{
			url : "bizMaterialStockController/findAllStockQuery",
			query : {
				mode : mode,
				m_name_ : m_name_
			}
		});
	}
	
	$("#mt_btn_all").click(function() {
		mode = "getAll";
		$("#mt_btn_all").addClass("state1").removeClass("state2");
		$("#mt_btn_warn").addClass("state2").removeClass("state1");
		$("#dtlist").bootstrapTable('refresh');
	});
	$("#mt_btn_warn").click(function() {
		mode = "getWarn";
		$("#mt_btn_warn").addClass("state1").removeClass("state2");
		$("#mt_btn_all").addClass("state2").removeClass("state1");
		$("#dtlist").bootstrapTable('refresh');
	});
	// 入库框提交方法
	$("#submitList").click(function() {
		var allData = $("#chooseGoodsList").bootstrapTable('getSelections');
		if (allData.length == 0) {
			layerAlert("请选择入库物品！");
			return false;
		}
		var material = '';
		var flag = false;
		$(allData).each(function(index) {
			var id = allData[index].id_;
			var innumber = allData[index].innumber_;
			if (innumber == undefined || innumber== 0) {
				flag = true;
			}
			material = material + id + "==" + innumber + ",";
		});
		if(flag){
			layerAlert("请输入入库数量！");
			return false;
		}
		material = material.substring(0, material.length - 1);
		$.ajax({
			url : 'bizMaterialStockController/doInStock/' + material,
			dataType : 'json',
			success : function(result) {
				//check the result
				if(result){
					$('#myModal').modal('hide');
					$("#dtlist").bootstrapTable('refresh');
				}else{
					layerAlert("入库失败");
				}
			},
			error : function(result) {
				layerAlert("入库失败");
			}
		});
	});
});

var mode = "getAll";
var	m_name_ = "";

function initTable(){
	$('#dtlist').bootstrapTable({
		url : 'bizMaterialStockController/findAllStockQuery', // 请求后台的URL（*）
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
					mode : mode,
					m_name_:$.trim(m_name_),
					m_number_:$.trim($("#m_number_").val()),
					standard_:$.trim($("#standard_").val()),
					unit_:$.trim($("#unit_").val()),
					supplier_:$.trim($("#supplier_").val()),
					amount_:$.trim($("#amount_").val()),
					inventory_floor_:$.trim($("#inventory_floor_").val()),
					startIndate:$.trim($("#startTime").val()),
					endIndate:$.trim($("#endTime").val()),
					sortName:this.sortName,
					sortOrder:this.sortOrder
				};
			    m_name_="";
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
		uniqueId : "id_", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		columns : [ /*{
			checkbox : true,
			align : 'center',
			valign: 'middle'
		}, */{
			field : 'index',
			title : '序号',
			align : 'center',
			valign: 'middle',
			width : '5%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'm_name_',
			title : '物品名称',
			align : 'left',
			valign: 'middle',
			width : '20%',
			sortable : true
		}, {
			field : 'm_number_',
			title : '物品编号',
			align : 'right',
			valign: 'middle',
			width : '10%',
			sortable : true
		}, {
			field : 'standard_',
			title : '规格型号',
			align : 'right',
			valign: 'middle',
			width : '10%',
			sortable : true
		}, {
			field : 'unit_',
			title : '计量单位',
			width : '10%',
			align : 'center',
			valign: 'middle',
			sortable : true
		}, {
			field : 'supplier_',
			title : '供货商',
			width : '10%',
			align : 'left',
			valign: 'middle',
			sortable : true
		}, {
			field : 'amount_',
			title : '库存数量',
			width : '10%',
			align : 'rigth',
			valign: 'middle',
			sortable : true
		}, {
			field : 'inventory_floor_',
			title : '库存下限',
			width : '10%',
			align : 'rigth',
			valign: 'middle',
			sortable : true
		}, {
			field : 'indate_',
			title : '库存创建时间',
			align : 'center',
			width : '15%',
			valign: 'middle',
			sortable : true
//			  formatter : function(val, row) {
//				  return row.indate_.substring(0,10);
//			}
		}, ]

	});
}

var idss = [];
function initWindowTable(){
	$('#chooseGoodsList').bootstrapTable({
		url : '', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		type : 'json',
		toolbar : '', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "desc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					pageSize : params.limit, // 页面大小
					pageNum : params.offset, // 页码
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
				/*field : 'ck',*/
				field: 'checkStatus',
				checkbox : true,
				align : 'center',
				valign: 'middle'
			}, {
				field : 'm_name_',
				title : '物品名称',
				align : 'left',
				valign: 'middle',
				width : '38%'
			}, {
				field : 'm_number_',
				title : '物品编号',
				align : 'left',
				valign: 'middle'
			}, {
				field : 'standard_',
				title : '规格型号',
				align : 'left',
				valign: 'middle'
			}, {
				field : 'unit_',
				title : '计量单位',
				align : 'left',
				valign: 'middle'
			}, {
				field : 'supplier_',
				title : '供货商',
				align : 'left',
				valign: 'middle'
			}, {
			field : 'innumber_',
			title : '入库数量',
			align : 'left',
			valign: 'middle',
			formatter : function(value,row) {
				return 0;
			},
			editable : {
				type : 'number',
				validate : function(value) {
					if ($.trim(value) == '') {
						return '入库数量不能为空！';
					} else if ($.trim(value) < 0) {
						return '请输入非负数！';
					}
					var index = $(this).parents('tr').data('index');
					$('#chooseGoodsList').bootstrapTable('check', index);
				}
			}
		}, ]
	});
}
function validateData() {
	if($("#input-word").val()!="请输入物品名称查询"&&$("#input-word").val()!=""){
		m_name_=$("#input-word").val();
		$("#search_form")[0].reset();
	}
	m_name_=m_name_+$("#m_name_").val();
	var startTime=$("#startTime").val();
	var endTime=$("#endTime").val();
	if(startTime!=""&&endTime!=""){
		if(startTime > endTime){
			window.parent.publicAlert("库存创建开始日期不能大于结束日期");
			return;
		}
	}
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
*/   $("#input-word").val("请输入物品名称查询");
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