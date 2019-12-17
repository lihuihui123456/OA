$(function() {
	initTable();//加载列表
	$('#goodsname').bind('keypress', function (event) {
        if (event.keyCode == "13") {
        	searchData();
           return false ;   
        } });
});

var mname="";//搜索条件： 物品名称
var user="";//搜索条件： 领用人
var operator="";//搜索条件： 经办人
var name="";//搜索条件： 物品名称
function initTable(){
	$('#dtlist').bootstrapTable({
		url : 'bizMaterialStockController/findStockDetialsQuery', // 请求后台的URL（*）
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
					m_name_:$.trim(mname),
					m_number_:$.trim($("#m_number_").val()),
					standard_:$.trim($("#standard_").val()),
					direction_:$.trim($("#direction_").val()),
					amount_:$.trim($("#amount_").val()),
					user:$.trim($("#user").val()),
					operator:$.trim($("#operator").val()),
					startTime:$.trim($("#startTime").val()),
					endTime:$.trim($("#endTime").val()),
					sortName:this.sortName,
					sortOrder:this.sortOrder
				};
			    mname="";
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
			checkbox : true
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
			width : '10%',
			valign: 'middle',
			sortable : true
		}, {
			field : 'standard_',
			title : '规格型号',
			align : 'right',
			width : '10%',
			valign: 'middle',
			sortable : true
		},  {
			field : 'direction_',
			title : '方向',
			width : '10%',
			align : 'center',
			valign: 'middle',
			sortable : true,
			formatter:function(value,row){
				if (value == "出库")
					return '<span class="label label-danger">出库</span>';
				if (value == "入库")
					return '<span class="label label-success">入库</span>';
			}
		}, {
			field : 'amount_',
			title : '数量',
			align : 'right',
			width : '10%',
			valign: 'middle',
			sortable : true
		}, {
			field : 'user',
			title : '领用人',
			width : '10%',
			align : 'left',
			valign: 'middle',
			sortable : true
		}, {
			field : 'operator',
			title : '经办人',
			width : '10%',
			align : 'left',
			valign: 'middle',
			sortable : true
		}, {
			field : 'end_time_',
			title : '出入库时间',
			width : '15%',
			align : 'center',
			valign: 'middle',
			sortable : true
		}, ],
		onClickRow:function(row,tr){
			
		}

	});
}

//普通搜索
function searchData() {
	$("#search_form")[0].reset();
	mname = $("#goodsname").val();
/*	clearForm();
*/	if(mname=='请输入物品名称查询'){
		mname="";
	}else{
		/*var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
		if(mname.match(reg)==null){
			layerAlert("输入内容含有非法字符！");
			return;
		}*/
	}
	$("#dtlist").bootstrapTable('refresh');
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
*/   $("#goodsname").val("请输入物品名称查询");
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
function validateData() {
	if($("#goodsname").val()!="请输入物品名称查询"&&$("#goodsname").val()!=""){
		mname=$("#goodsname").val();
		$("#search_form")[0].reset();
	}
	mname=mname+$("#m_name_").val();
/*	var startTime=$("#startTime").val();
	var endTime=$("#endTime").val();
	if(startTime!=""&&endTime!=""){
		if(startTime > endTime){
			window.parent.publicAlert("库存创建开始日期不能大于结束日期");
			return;
		}
	}*/
}
