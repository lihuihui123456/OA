var treetype;
var style;
var callbackfunc;
var datatable;
function IndexLibraryTree(type, treeType,event,callback) {
	treetype = treeType;
	openIndexLibrarySelectTree("selectionIndexLibrary_div");
	initDataIndexLibraryTable();
}
function openIndexLibrarySelectTree(treeDivId){
	layer.open({
		type: 1,
		shade: 0.3,
		area: ['100%', '420px'],
		title: '请选择', 
		offset: '-1px',
		scrollbar: false,
		content: $("#"+treeDivId), //捕获的元素，注意：最好该指定的元素要存放在body最外层，否则可能被其它的相对元素所影响
		cancel: function(){
		}
	});
}
var deptName = "";

function initDataIndexLibraryTable() {
/*	var datetable = $('#IndexLibraryInfoList').DataTable();
//	datetable.cell(':eq(2)').focus();
	datetable.clear().draw();*/
	
	if (datatable == null) {
		initBootstrapTable();
	} 
	var deptName = $.trim($("#inputIndexLibrary-word").val());
	
	if (deptName == '请输入查询内容') {
		deptName = "";
	}
	$("#IndexLibraryInfoList").bootstrapTable('refresh',{
		url : "indexLibraryController/findIndexLibDateByQueryParams",
		query:{
			deptName : deptName
		}
	});
}
function initBootstrapTable() {
	datatable =$('#IndexLibraryInfoList').bootstrapTable({
		url : 'indexLibraryController/findIndexLibDateByQueryParams', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
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
		maintainSelected:true,
		columns : [ {
			checkbox : true,
			valign: 'middle',
			halign: 'center',
			field: 'checkStatus'
		}, {
			field : 'index',
			title : '序号',
			valign : 'middle',
			width: '6px',
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
				} else if (value == '1') {
					return '"丹柯杯"项目';
				} else {
					return '基本经费';
				}
			}
		}, {
			field : 'funcType',
			title : '功能分类',
			width: '12%',
			
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
			
		}, {
			field : 'deptExtAmount',
			title : '部门执行金额',
			width: '12%',
			
			align : 'center',
			valign : 'middle'
		}, {
			field : 'deptResIndex',
			title : '部门剩余指标',
			align : 'center',
			width: '12%',
			
			valign : 'middle'
		},{
			field : 'fincExtAmount',
			title : '财务执行金额',
			align : 'center',
			width: '12%',
			
			valign : 'middle'
		},{
			field : 'actResIndex',
			title : '实际剩余指标',
			align : 'center',
			width: '12%',
			
			valign : 'middle'
		}],
		onClickRow:function(row,tr){
			
		}
	});
}
	var browser=navigator.appName 
	var b_version=navigator.appVersion 
	var version=b_version.split(";"); 
	var trim_Version=version[1].replace(/[ ]/g,""); 
	if(browser!="Microsoft Internet Explorer" && trim_Version!="MSIE8.0") {
		//设置监听
		$("#inputIndexLibrary-word").bind("input propertychange", function() { 
			var searchValue = $("#inputIndexLibrary-word").val();
			if (searchValue != "请输入标题查询") {
			}	
		});
	}
	
function IndexLibrary_search() {
	initDataIndexLibraryTable();
}


function IndexLibrary_select(){ 
	var selectRow = $("#IndexLibraryInfoList").bootstrapTable('getSelections');
	var value = selectRow[0].proName;
	if (value == '0') {
		value= '"双优"评选项目';
	} else if (value == '1') {
		value=  '"丹柯杯"项目';
	} else {
		value=  '基本经费';
	}
	$("#"+treetype.replace("_","Name_")).val(value);
	$("#" + treetype).val(selectRow[0].id);
	layer.closeAll();
}

function IndexLibrary_close(){
	layer.closeAll();
}
