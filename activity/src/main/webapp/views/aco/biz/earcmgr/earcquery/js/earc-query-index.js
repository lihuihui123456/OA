var selectionIds = [];//记忆选中
var title="";
var ctlgId="";
$(document).ready(function() {
	/**
	 * 获取档案目录分类构建树
	 */
	/**
	 * 获取档案目录分类构建树
	 */
	var setting = {
		async: {
			enable: true,
			url: "earcController/findZtreeListByUserId"
		},
		data: {
			simpleData: {
				enable: true,
				idKey: "id",
				pIdKey: "pId",
				rootPId: 0
			}
		},
		callback : {
			onClick : zTreeOnClick
		}

	};
	$.fn.zTree.init($("#queryTree"), setting);
	initCtlgTableData();
	/**
	 * 高级搜索重置
	 */
	$("#advSearchCalendar").click(function(){
		document.getElementById("ff").reset(); 
		$("#draftUserId_").val('');
		$("#queryList").bootstrapTable('refresh',{
			url : "earcQueryController/findEarcDateAll",
			query:{
				query : $("#ff").serialize(),
			}
		});
		$("#advSearchModal").modal('hide');
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
		if($("#advStartDate").val() != "" && $("#advEndDate").val() != "") {
			if($("#advEndDate").val() <= $("#advStartDate").val()) {
				layer.msg("结束时间必须大于开始时间！");
				return;
			}
		}
		if($("#advStartDate").val() != "" && $("#advEndDate").val() != "") {
			if($("#advEndDate").val() <= $("#advStartDate").val()) {
				layer.msg("结束时间必须大于开始时间！");
				return;
			}
		}
		$("#queryList").bootstrapTable('refresh',{
			url : "earcQueryController/findEarcDateAll",
			query:{
				query : $("#ff").serialize(),
			}
		});
		
		$("#advSearchModal").modal('hide');
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
             if(ID_!=-1){  
                 array.splice(index, 1);  
             }  
         });  
        return array;  
	};    
	var _ = {"union":union,"difference":difference};
	/**
	 * bootstrap-table 记忆选中 
	 */
	$('#ctlgList').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
		var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
	        return row.ID_;  
	    });  
	    func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	    selectionIds = _[func](selectionIds, ids);   
	});
	
	
	$("#btn_sed").click(function(){
		var selects = $("#queryList").bootstrapTable('getSelections');  
		if(selects.length==0){
			layerAlert("请选择一条数据！");
			return;
		}else if(selects[0].EARC_STATE!=1){
			layerAlert("请选择已归档档案调阅!");
		}else{
			var modal = $("#sedModal");
			modal.modal('show');			
			$("#earcId").val(selects[0].ID_);
		}
	});
});

function initCtlgTableData(){
	$('#queryList').bootstrapTable({
		url : 'earcQueryController/findEarcDateAll', // 请求后台的URL（*）
        method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		sortable : true,
		sortOrder : "desc",
		queryParams : function(params) {
			var temp = {
				pageNum : params.offset, // 页码
				pageSize : params.limit, // 页面大小
				ctlgId : ctlgId,
				title : title,
				sortName : this.sortName,
				sortOrder : this.sortOrder,
				queryParams : $("#ff").serialize()
			};
			return temp;
		},
		sidePagination : "server",
		pageNumber : 1,
		pageSize : 10,
		pageList : [ 10, 25, 50, 100 ],
		search : false,
		strictSearch : false,
		showColumns : false,
		showRefresh : false,
		minimumCountColumns : 2,
		clickToSelect : true,
		uniqueId : "ID_",
		showToggle : false,
		cardView : false,
		detailView : false,
		maintainSelected:true,
		responseHandler:function(res){
        	$.each(res.rows, function (i, row) {
        		 row.checkStatus  = $.inArray(row.ID_, selectionIds) !== -1;
        		});
        		return res;	
        },
		columns : [ {
			checkbox : true,
			align : 'center',
			valign: 'middle',
			field: 'checkStatus'
		}, {
			field : 'index',
			title : '序号',
			valign : 'middle',
			width : '5%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'BIZ_TITLE_',
			title : '题名',
			align : 'left',
			valign : 'middle',
			sortable : true,
			/*events: onTdClickTab,*/
            formatter: onTdClickTabFormatter
		}, {
			field : 'CREATE_USER_ID_',
			title : '责任人',
			align : 'left',
			width:"15%",
			valign : 'middle',
			sortable : true
		}, {
			field : 'EARC_TYPE',
			title : '类型',
			align : 'center',
			cellStyle : cellStyle,
			width:"10%",
			valign : 'middle',
			sortable : true
		}, {
			field : 'SECURITY_LEVEL',
			title : '密级',
			cellStyle : cellStyle,
			align : 'center',
			valign : 'middle',
			width:"10%",
			sortable : true,
			formatter : function(val, row) {
				 if(row.SECURITY_LEVEL=='1'){
					 return '<span class="label label-success">&nbsp;低&nbsp;&nbsp;</span>';
				 }else if(row.SECURITY_LEVEL=='2'){
					 return '<span class="label label-warning">&nbsp;中&nbsp;&nbsp;</span>';
				 }else if(row.SECURITY_LEVEL=='3') {
					 return '<span class="label label-danger">&nbsp;高&nbsp;&nbsp;</span>';
				 }else {
					 return '--';
				 }
			}
		}, {
			field : 'OPER_TIME',
			title : '归档日期',
			cellStyle : cellStyle,
			align : 'center',
			valign : 'middle',
			width:"20%",
			sortable : true
		}, {
			field : 'EARC_STATE',
			title : '状态',
			cellStyle : cellStyle,
			align : 'center',
			width:"10%",
			valign : 'middle',
			sortable : true,
			formatter : function(val, row) {
				 if(row.EARC_STATE=='0'){
					 return '<span class="label label-success">&nbsp;未归档&nbsp;&nbsp;</span>';
				 }else if(row.EARC_STATE=='1'){
					 return '<span class="label label-warning">&nbsp;已归档&nbsp;&nbsp;</span>';
				 }else if(row.EARC_STATE=='2') {
					 return '<span class="label label-danger">&nbsp;已作废&nbsp;&nbsp;</span>';
				 }else if(row.EARC_STATE=='3') {
					 return '<span class="label label-danger">&nbsp;已销毁&nbsp;&nbsp;</span>';
				 }else if(row.EARC_STATE=='4') {
					 return '<span class="label label-danger">&nbsp;已到期&nbsp;&nbsp;</span>';
				 }else {
					 return '--';
				 }
			}
		}],
		onClickRow : function(row, tr) {
			var bizId = row.ID_;
			var operateUrl = "bizRunController/getBizOperate?solId="+ row.SOL_ID_  + "&bizId=" + bizId + "&status=4";
			var options = {
				"text" : "查看",
				"id" : "view"+bizId,
				"href" : operateUrl,
				"pid" : window.parent,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":true
			};
	 		window.parent.parent.createTab(options);
		}
	});
}


function showSearchDiv(){
	var display =$('#advSearchModal').css('display');
	if(display == "none") {
		$("#advSearchModal").show();
	}else {
		$("#advSearchModal").hide();
	}
}

function qxButton(){
	$("#advSearchModal").hide();	
}
/**
 * 搜索方法
 */
function search() {
	var title = $("#input-word").val();
	if(title == '请输入目录名称查询'){
		title="";
	}else{
		$("#queryList").bootstrapTable('refresh', {
			url : "earcQueryController/findEarcDateAll",
			query : {
				title : title
			}
		});
	}
	
}
/**
 * 目录树单击方法
 */
function zTreeOnClick(event, treeId, treeNode) {
	var zTree = $.fn.zTree.getZTreeObj("queryTree");
    zTree.expandNode(treeNode);
/*	var ctlgId = treeNode.id;
*/	 ctlgId = treeNode.id;

	var pId = treeNode.pId;
	$("#parentId").val(treeNode.id);
	$("#queryList").bootstrapTable('refresh', {
		url : "earcQueryController/findEarcDateAll",
		query : {
			ctlgId : ctlgId,
		}
	});
}


/**
 * 标题格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function onTdClickTabFormatter(value, row, index){
	/**
	 * 格式化标题
	 */
	if(value!=null){
		if(value.length>25){
			return "<span class='tdClick' title='"+value+"'>"+value.substring(0,20)+"...</span>";
		}else{
			return "<span class='tdClick'>"+value+"</span>";
		}
	}else{
		return "<span class='tdClick'>-</span>"
	}
}


window.onTdClickTab = {
		'click .tdClick': function (e, value, row, index) {
		var bizId = row.ID_;
		var operateUrl = "bizRunController/getBizOperate?solId="+ row.SOL_ID_  + "&bizId=" + bizId + "&status=4";
		var options = {
			"text" : "查看",
			"id" : "view"+bizId,
			"href" : operateUrl,
			"pid" : window.parent,
			"isDelete":true,
			"isReturn":true,
			"isRefresh":true
		};
 		window.parent.parent.createTab(options);
	 }
}



function writeObj(obj) {
	var description = "";
	for ( var i in obj) {
		var property = obj[i];
		description += i + " = " + property + "\n";
	}
	alert(description);
}
