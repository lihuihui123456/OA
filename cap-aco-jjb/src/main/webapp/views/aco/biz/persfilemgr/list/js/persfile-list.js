//翻页选中数组
var selectionIds = [];
$(function() {

	initTable();
	$("#btn_delete").css("display","none");
	/**
	 * 选中事件操作数组  
	 */
	 var union = function(array,ids){  
	     $.each(ids, function (i, id) {  
	         if($.inArray(id,array)==-1){  
	             array[array.length] = id;  
	         }  
	     });  
	      return array;  
	};
	
	/**
	 * 取消选中事件操作数组 
	 */
	var difference = function(array,ids){  
         $.each(ids, function (i, id) {  
              var index = $.inArray(id,array);  
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
	$('#persFileTable').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
		var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
			return row.id;  
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
	
	
	/**
	 * 高级搜索方法
	 */
	$("#advSearch").click(function(){
		$("#persFileTable").bootstrapTable('refresh',{
			url : "persFileController/findPersFileDateByQueryParams",
			query:{
				queryParams : $("#ff").serialize(),
			}
		});
		$("#advSearchModal").modal('hide');
	});
	
	$("#btn_delete_pers").click(function(){
		if (selectionIds.length == 0) {
			layerAlert("请选择操作项！");
			return;
		}
		layer.confirm('确定删除吗？', {
			btn : [ '是', '否' ]
			// 按钮
			}, function(index) {
				$.ajax({
					url : 'persFileController/doDelPersFileInfoByPersFileId',
					dataType : 'text',
					data : {
						'persFileIds' : selectionIds
					},
					success : function(data) {
						if (data == 'Y') {
							layerAlert("删除成功！");
							refreshTable("persFileTable","persFileController/findPersFileDateByQueryParams");
						} else {
							layerAlert("删除失败！");
						}
						selectionIds =[];
					}
				});
				layer.close(index);
			}, function() {
				return;
		});
	});
	
	
	/**
	 * 修改人事信息
	 */
	$("#btn_update_pers").click(function(){
		var selectRow = $("#persFileTable").bootstrapTable('getSelections');
		if (selectRow.length == 1) {
			var bizId = selectRow[0].id;
     		var tname = "修改";
     		var status = "2";//编辑
     		var operateUrl = "bizRunController/getBizOperate?solId="+ selectRow[0].sol_id_  + "&bizId=" + bizId + "&status=" + status;
     		var options = {
     			"text" : tname,
     			"id" : "view"+bizId,
     			"href" : operateUrl,
     			"pid" : window,
     			"isDelete":true,
     			"isReturn":true,
     			"isRefresh":true
     		};
     		window.parent.parent.createTab(options);
		}else if(selectRow.length > 1){
			layerAlert("请选择一条记录修改!");
			return;
		}else{
			layerAlert("请选择操作项！");
			return;
		}
	});
	
	/**
	 * 高级搜索重置
	 */
	$("#advSearchCalendar").click(function(){
		document.getElementById("ff").reset();
		$("#persFileTable").bootstrapTable('refresh',{
			url : "persFileController/findPersFileDateByQueryParams",
			query:{
				queryParams : $("#ff").serialize(),
			}
		});
		$("#advSearchModal").modal('hide');
	});
	
});

function qxButton(){
	$("#advSearchModal").hide();	
}
var userName = "";
/**
 * 表格数据初始化
 */
var solId;
function initTable() {
	$('#persFileTable').bootstrapTable({
		url : 'persFileController/findPersFileDateByQueryParams', // 请求后台的URL（*）
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
				solId:solId,//业务模块
				userName:$.trim(userName),
				sortName:this.sortName,
				sortOrder:this.sortOrder,
				queryParams : $("#ff").serialize(),
			};
			userName="";
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
		singleSelect : false,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.id, selectionIds) !== -1;
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
			width: '5%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'userName_',
			title : '姓名',
			align : 'left',
			valign : 'middle',
			sortable : true,
		}, {
			field : 'deptName_',
			title : '部门',
			align : 'left',
			valign : 'middle',
			sortable : true,
		}, {
			field : 'user_sex',
			title : '性别',
			align : 'left',
			valign : 'middle',
			sortable : true,
			formatter : function(val, row) {
				 if(row.user_sex=='0'){
					 return '女';
				 }else if(row.user_sex=='1'){
					 return '男';
				 }else if(row.user_sex=='2') {
					 return '未知';
				 }else {
					 return '--';
				 }
			}
		}, 
		{
			field : 'user_bitrth',
			title : '出生日期',
			align : 'center',
			valign : 'middle',
			sortable : true,
 			formatter:function(value,row){
 				if(row.user_bitrth==null||row.user_bitrth==""){
					 return '--';
				}else{
					var str=row.user_bitrth.split(" ");
 					return str[0];
				}
		}
		}, 
		{
			field : 'user_education',
			title : '学历',
			align : 'left',
			valign : 'middle',
			sortable : true,
			formatter : function(val, row) {
				 if(row.user_education=='bk'){
					 return '本科';
				 }else if(row.user_education=='ss'){
					 return '硕士';
				 }else if(row.user_education=='bs') {
					 return '博士';
				 }else if(row.user_education=='gz') {
					 return '高中';
				 }else if(row.USER_EDUCATION=='zk') {
					 return '专科';
				 }else if(row.USER_EDUCATION=='qt') {
					 return '其他';
				 }else {
					 return '--';
				 }
			}
		}/*,{
			field : 'user_police_type',
			title : '政治面貌',
			cellStyle : cellStyle,
			align : 'center',
			valign : 'middle',
			sortable : true,
			formatter : function(val, row) {
				 if(row.user_police_type=='dy'){
					 return '党员';
				 }else if(row.user_police_type=='gqty'){
					 return '共青团员';
				 }else if(row.user_police_type=='wdprs') {
					 return '无党派人士';
				 }else {
					 return '--';
				 }
			}
		}*/, {
			field : 'join_time',
			title : '入党时间',
			align : 'center',
			valign : 'middle',
			cellStyle : cellStyle,
			sortable : true,
 			formatter:function(value,row){
 				if(row.join_time==null||row.join_time==""){
					 return '--';
				}else{
				var str=row.join_time.split(" ");
					return str[0];
				}
		}
		}, {
			field : 'entry_time',
			title : '调入时间',
			cellStyle : cellStyle,
			align : 'center',
			valign : 'middle',
			sortable : true,
 			formatter:function(value,row){
 				if(row.entry_time==null||row.entry_time==""){
 					 return '--';
 				}else{
 					var str=row.entry_time.split(" ");
 					return str[0];
 				}
		}
		}],
		onClickRow:function(row,tr){
	/*		alert(row);
			var tname = "编辑";
			var status = "2";
			if(row.EARC_STATE!='0'){
				tname = '查看';
				status="4";
			}*/
			var tname = "查看";
			var status = "4";
			var bizId = row.id;
			var operateUrl = "bizRunController/getBizOperate?solId="+ solId  + "&bizId=" + bizId + "&status="+status;
			var options = {
				"text" : tname,
				"id" : "view"+bizId,
				"href" : operateUrl,
				"pid" : window,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":true
			};
	 		window.parent.parent.createTab(options);
		}
	});
}

/**
 *  查询方法
 */
function search() {
	$("#USER_NAME").val('');
	var userName = $.trim($("#input-word").val());
	if (userName == '请输入姓名查询') {
		userName = "";
	}
	$("#persFileTable").bootstrapTable('refresh',{
		url : "",
		query:{
			userName : userName
		}
	});
}


/**
 * 高级搜索
 */
function showOrHide(){
	var display =$('#advSearchModal').css('display');
	if(display == "none") {
		$("#advSearchModal").show();
	}else {
		$("#advSearchModal").hide();
	}
}
Date.prototype.Format = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}