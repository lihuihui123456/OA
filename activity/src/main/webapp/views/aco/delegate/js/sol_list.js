$(function(){
	//加载列表数据
	initDataTable();
	$('#input-word').bind('keypress', function (event) {
	    if (event.keyCode == "13") {
	    	search();
	       return false ;   
	    } }); 
});
var title = "";//搜索参数
var ids = '';
var names = '';
function initDataTable() {
	$('#solList').bootstrapTable({
		url : 'delegate/findSolList', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					rows  : params.limit, // 页面大小
					page : params.offset,
					userid : userid,
					title : $("#input-word").val()=="请输入名称查询"?"":$("#input-word").val()
				};
				return temp;
			},// 传递参数（*）
        sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 5, // 每页的记录行数（*）
		pageList : [ 5, 10, 25, 50 ], // 可供选择的每页的行数（*）
		clickToSelect : true, // 是否启用点击选中行
        idField : "sol_id",  //指定主键列
        columns: [{
                	checkbox : true
                }, {
                	 field: 'index',
		        	 title: '序号',
		        	 align : 'center',
		  			 valign: 'middle',
		  			 width : '10%' ,
                     formatter: function (value, row, index) {
                         return index+1;
                     }
                },{
                	 field: 'sol_id',
		        	 align : 'center',
		  			 valign: 'middle',
		  			 visible : false
                },{
                	 field: 'sol_name',
                	 title:'委托事项名称',
                	 align : 'center',
		  			 valign: 'middle'
                }],
                onCheck : function(row, checked) {
    	 			insertSelectData(row);
    	 		},
    	 		onUncheck : function(row) {
    	 			var sol_id = row.sol_id;
    	 			var sol_name = row.sol_name;
    	 			removeUser(sol_id,sol_name);
    	 		},
    	 		onCheckAll: function (rows) {
    	 			insertSelectDatas(rows);
    	        },
    	        onUncheckAll: function (rows) {
     	            for(var i=0;i<rows.length;i++){
     	            	var sol_id = rows[i].sol_id;
     		 			var sol_name = rows[i].sol_name;
     		 			removeUser(sol_id,sol_name);
     	       }
     	            }
	});
}
function insertSelectData(row){
	var sol_id = row.sol_id;
	var sol_name = row.sol_name;
	if (ids.indexOf(sol_id) != -1) {
		return;
	}
   
	$("#content").append('<a id="'+sol_id+'">'+row.sol_name+'<span class="close_man" onclick="removeUser(\''+sol_id+'\',\''+sol_name+'\')">×</span></a>');
	ids += row.sol_id + ",";
	names += row.sol_name + ",";
}

function removeUser(sol_id,sol_name){
	$("#"+sol_id).remove();
	
	ids = ids.replace(sol_id+",", "");
	names = names.replace(sol_name+",", "");
}
function insertSelectDatas(rows){
	for(var i=0;i<rows.length;i++){
		insertSelectData(rows[i]);
	}
}
function search() {
	title = $("#input-word").val();
	if (title == '请输入名称查询') {
		title = "";
	}
	$("#solList").bootstrapTable('refresh',{
		url : "delegate/findSolList",
		query:{
			title : title,
			userid : userid
		}
	});
}
function doSaveSelects(){
	var arr = new Array();
	arr[0] = ids.substring(0,ids.length-1);
	arr[1] = names.substring(0,names.length-1);
	if(arr[0] == ""){
		layerAlert("未选择数据");
		return;
	}
	return arr;
}
/******************格式化方法********************/
 function indexFormatter(value, row, index) {
	return index + 1;
 }