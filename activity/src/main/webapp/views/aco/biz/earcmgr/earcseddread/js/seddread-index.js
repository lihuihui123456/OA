var selectionIds = [];//记忆选中
var ctlgName;
var ctlgId ="";
$(document).ready(function() {
	/**
	 * 添加按钮事件
	 */
	$('#btn_new').click(function() {
		var date = new Date();
		var modal = $("#seddreadModal");
		modal.modal('show');
		$("#seddreadListDiv").load('earcSeddRedController/searchEarcSeddReadLoad');		
	});
	
	/**
	 * 列表回车触发搜索
	 */
	$('#input-word').bind('keypress', function (event) {
	    if (event.keyCode == "13") {
	    	searchCommon();
	       return false ;   
	    } 
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
	$('#earcTable').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
		var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
	        return row.ID_;  
	    });  
	    func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	    selectionIds = _[func](selectionIds, ids);   
	});
	 initSeddReadTableData();
});
var solId;
function initSeddReadTableData(){
	$('#earcTable').bootstrapTable({
		url : 'earcSeddRedController/findEarcSeddRedInfo', // 请求后台的URL（*）
        method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		sortable : true,
		sortOrder : "desc",
		queryParams : function(params) {
			var flag=validateData();
			if(!flag){
				return false;
			}
		    var	biz_title_="";
			if($("#input-word").val()!="请输入题名查询"&&$("#input-word").val()!=""){
				biz_title_=$("#input-word").val();
				$("#search_form")[0].reset();
			}
			biz_title_=biz_title_+$("#biz_title_").val();
			var security_level = $("#security_level").val();
			var receive_user=$("#receive_user").val();
			var startTime=$("#startTime").val();
			var endTime=$("#endTime").val();
			var receive_user=$("#receiveUserIdName_").val();
			var send_user=$("#sendUserIdName_").val();
			var temp = {
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				sortName : this.sortName,
				sortOrder : this.sortOrder,
				solId:solId,//业务模块
				biz_title_ :$.trim(biz_title_),
				security_level:security_level,
				startTime:startTime,
				endTime:endTime,
				receive_user:receive_user,
				send_user:send_user,
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
			field : 'biz_title_',
			title : '题名',
			align : 'left',
			valign : 'middle',
			sortable : true,
			/*events: onTdClickTab,*/
            formatter: onTdClickTabFormatter
		}, {
			field : 'security_level',
			title : '密级',
			cellStyle : cellStyle,
			align : 'center',
			valign : 'middle',
			sortable : true,
			formatter : function(val, row) {
				 if(row.security_level=='1'){
					 return '<span class="label label-success">&nbsp;低&nbsp;&nbsp;</span>';
				 }else if(row.security_level=='2'){
					 return '<span class="label label-warning">&nbsp;中&nbsp;&nbsp;</span>';
				 }else if(row.security_level=='3') {
					 return '<span class="label label-danger">&nbsp;高&nbsp;&nbsp;</span>';
				 }else {
					 return '--';
				 }
			}
		}, {
			field : 'receive_user',
			title : '接收人',
			align : 'left',
			valign : 'middle',
			sortable : true
		}, {
			field : 'send_user',
			title : '发送人',
			valign : 'middle',
			align : 'left',
			sortable : true
		}, {
			field : 'start_date',
			title : '调阅时间',
			cellStyle : cellStyle,
			halign : 'center',
			align : 'center',
			sortable : true,
 			formatter:function(value,row){
 				if(row.start_date==null||row.start_date==''){
 					return '--';
 				}
				return new Date(parseInt(row.start_date)).Format('yyyy-MM-dd');
		   }
		} ],
		onClickRow : function(row, tr) {
			var bizId = row.id_;
			var operateUrl = "bizRunController/getBizOperate?solId="+ row.solId  + "&bizId=" + bizId  + "&status=4";
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

function searchCommon() {
	//普通查询清空高级查询条件
	$("#search_form")[0].reset();
	var biz_title_ = $("#input-word").val();
	if (biz_title_ == '请输入提名查询') {
		biz_title_ = "";
	} else {
		biz_title_ = biz_title_;
	}
	$("#earcTable").bootstrapTable('refresh', {
		url : "earcSeddRedController/findEarcSeddRedInfo",
		query : {
			biz_title_ : $.trim(biz_title_)
		}
	});
}

$(function(){
		$("#modal_close").click(function(){
			$("#advSearch").hide();	
		})
});
/**
 * 高级搜索模态框
 */
function advSearchModal() {
	var display =$('#advSearch').css('display');
	if(display == "none") {
		$("#advSearch").show();
	}else {
		$("#advSearch").hide();
	}
}
/**
 *  高级查询方法
 */
function submitForm() {
/*    $('#advSearchModal').modal('hide');
*/   $("#input-word").val("请输入提名查询");
	$("#earcTable").bootstrapTable('refresh');
}
/**
 *  高级查询方法
 */
function clearForm() {
/*	 $('#advSearchModal').modal('hide');
*/		document.getElementById("search_form").reset();
        submitForm();
}
/**
 * 目录树单击方法
 */
function zTreeOnClick(event, treeId, treeNode) {
	ctlgId=treeNode.id;
	$("#parentId").val(treeNode.id);
	$("#earcTable").bootstrapTable('refresh', {
		url : "earcCtlgController/findArcCtlgDataByCtlgId",
		query : {
			ctlgId : treeNode.id,
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


window.onTdClickTab = {'click .tdClick': function (e, value, row, index) {
		var bizId = row.id_;
		var operateUrl = "bizRunController/getBizOperate?solId="+ row.solId  + "&bizId=" + bizId  + "&status=4";
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

/**
 * 日期格式化
 */
Date.prototype.Format = function(fmt) { // author: meizz
	var o = {
		"M+" : this.getMonth() + 1, // 月份
		"d+" : this.getDate(), // 日
		"h+" : this.getHours(), // 小时
		"m+" : this.getMinutes(), // 分
		"s+" : this.getSeconds(), // 秒
		"q+" : Math.floor((this.getMonth() + 3) / 3), // 季度
		"S" : this.getMilliseconds()
	// 毫秒
	};
	if (/(y+)/.test(fmt))
		fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "")
				.substr(4 - RegExp.$1.length));
	for ( var k in o)
		if (new RegExp("(" + k + ")").test(fmt))
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k])
					: (("00" + o[k]).substr(("" + o[k]).length)));
	return fmt;
}
function validateData() {
	var startRegTime=$("#startTime").val();
	var endRegTime=$("#endTime").val();
	if(startRegTime!=""&&endRegTime!=""){
		if(startRegTime > endRegTime){
			layerAlert("开始时间不能大于结束时间");
			return false;
		}
	}
	return true;
}