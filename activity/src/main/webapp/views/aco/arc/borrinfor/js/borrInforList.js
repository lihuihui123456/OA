var selectionIds = [];
$(function() {
	laydate.skin('dahong');
	iniTable(null);
	$('#add_btn').click(function(){
		addBorrinfor();
	});
	$('#edi_btn').click(function(){
		editBorrinfor();
	});
	$('#view_btn').click(function(){
		readBorrinfor();
	});
	$('#del_btn').click(function(){
		delBorrinfor();
	});
	$('#guihuan_btn').click(function(){
		guihuanBorrinfor();
	});
	
	$('#export_excel_btn').click(function() {
		searchExport();
	});
	
	$('#input-word').bind('keypress', function (event) {
        if (event.keyCode == "13") {
        	search();
           return false ;   
        } });
	
	/**
	    * 选中事件操作数组  
	    */
	    var union = function(array,ids){  
	        $.each(ids, function (i, ID) {  
	            if($.inArray(ID,array)==-1){  
	                array[array.length] = ID;  
	            }  
	        });  
	         return array;  
	};
	/**
	     * 取消选中事件操作数组 
	     */ 
	    var difference = function(array,ids){  
	            $.each(ids, function (i, ID) {  
	                 var index = $.inArray(ID,array);  
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
		$('#borrInforList').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
	var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
	            return row.ID;  
	        });  
	        func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	        selectionIds = _[func](selectionIds, ids);   
	});  
	

	
});
/**
 * 借阅管理导出功能
 */
function searchExport(){
	if(selectionIds.length <= 0){
		selectionIds = [1,2];
	}
	$("#hideSelectionIds").val(selectionIds);
	var temp = $("#input-word").val()=="请输入标题查询"?"":$("#input-word").val()
	$("#hideInputWord").val(temp);
	var url = globalPath+"/borrInforController/doExportExcel?"+$("#ff").serialize();
	//window.open(url); 
	var aLink = document.createElement('a');
    aLink.href =url;
    aLink.click();
}

/**
 * 初始化table
 * @para type：docinfor的类型
 * */
function iniTable(para){
	$('#borrInforList').bootstrapTable({
		url : 'borrInforController/doFindAllBorrInforTableBean', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
//		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageNum : params.offset, // 页码
				pageSize : params.limit, // 页面大小
				sortName : this.sortName,
				sortOrder : this.sortOrder
			/*	dengjiBumen_ : $('#dengjiBumen_').val(),
				borrDept: $('#jieyueBumenId_').val(),
				arcName:$('#arcName').val(),
				borrUser:$('#jieyueUserId_').val(),
				planTimeBeginn:$('#planTimeBeginn').val(),
				planTimeEnd:$('#planTimeEnd').val(),
				actlTimeBeginn:$('#actlTimeBeginn').val(),
				actlTimeEnd:$('#actlTimeEnd').val(),
				arcType: $("#arcType").val(),
				isSet:$("#isSet").val()*/
			};
			return temp;
		},// 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		strictSearch : true,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "ID", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		/*singleSelect : true,*/
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.ID, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [ {
			checkbox : true,
			field: 'checkStatus'
		}, {
			field : 'ID',
			visible: false,
			formatter : function(value, row, index) {
				return row.ID;
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
			field : 'ARC_NAME',
			title : '文件标题',
			align : 'left',
			valign : 'middle',
			/*events: onTdClickTab,*/
            formatter: onTdClickTabFormatter,
			sortable:true
		}, {
			field : 'dengjibumen',
			title : '登记部门',
			align : 'left',
			valign : 'middle',
			sortable:true
			 /* formatter : function(val, row) {
					return row.dengjiBumen;
				}*/
		}, {
			field : 'TYPE_NAME',
			title : '档案类型',
			align : 'left',
			valign : 'middle',
			sortable:true
		/*	  formatter : function(val, row) {
					return row.TYPE_NAME ;
				}*/
		}, {
			field : 'jiyueren',
			title : '借阅人',
			align : 'left',
			valign : 'middle',
			sortable:true
			  /*formatter : function(val, row) {
					return row.jiyueren;
				}*/
		}, {
			field : 'jiyuebumen',
			title : '借阅部门',
			align : 'left',
			valign : 'middle',
			sortable:true
			  /*formatter : function(val, row) {
					return row.jiyuebumen;
				}*/
		},{
			field : 'blr',
			title : '办理人',
			align : 'left',
			valign : 'middle',
			sortable:true
			  /*formatter : function(val, row) {
					return row.blr;
				}*/
		}, {
			field : 'PLAN_TIME',
			title : '计划归还日期',
			align : 'left',
			valign : 'middle',
			sortable:true,
			formatter : function(val, row) {
					if (row.IS_RET == "Y"){
						return row.PLAN_TIME.substring(0,10);
					}else {
						return "--";
					}
				  }
		}, {
			field : 'ACTL_TIME',
			title : '实际归还日期',
			align : 'left',
			valign : 'middle',
			sortable:true,
			  formatter : function(val, row) {
					if (row.IS_RET == "Y"&&row.IS_BACK == "Y"){
						return row.ACTL_TIME.substring(0,10);
					}else {
						return "--";
					}
			  }
		}, {
			field : 'IS_BACK',
			title : '归还状态',
			align : 'left',
			valign : 'middle',
			sortable:true,
			  formatter : function(val, row) {
				  if(row.IS_RET=='N'){
					  return '<span class="label label-success">&nbsp;无需归还&nbsp;&nbsp;</span>';
				  }else{
					  if (row.IS_BACK == "Y"){
						  return '<span class="label label-success">&nbsp;已归还&nbsp;&nbsp;</span>';
					  }else if (row.IS_BACK == "N"){
						  return '<span class="label label-warning">&nbsp;未归还&nbsp;&nbsp;</span>';
					  }else{
						  return "--";
					  }
				  }
				}
		}, {
			 field: 'operate',
             title: '操作',
             halign: 'center',
             align:'center',
             width : '10%',
             events: operateEvents,
             formatter: operateFormatter
		}],
		onClickRow : function(row, tr) {
			var date = new Date().getTime();
			var options = {
				"text" : "借阅管理-查看",
				"id" : date,
				"href" : "borrInforController/toBorrInforAdd?action=read&id="+row.ID,
				"pid" : window
			};
			window.parent.parent.createTab(options);
		}
	});
}

/**
 * 查看原文
 */
$('#view_btn').click(function(){
	var selects = $("#borrInforList").bootstrapTable('getSelections');  
	if(selects.length==0){
		window.parent.publicAlert("请选择一条数据！");
		return;
	}
	var id=selects[0].ID;
	var date = new Date().getTime();
	var options = {
		"text" : "借阅管理-查看",
		"id" : date,
		"href" : "borrInforController/toBorrInforAdd?action=read&id="+id,
		"pid" : window
	};
	window.parent.parent.createTab(options);
});
/**
 * 归还操作
 */
function guihuanBorrinfor(){
	var selectOneRow = getOneTableSelect('borrInforList');
	
	if(selectOneRow[0].IS_RET=='N'){
		layerAlert('所选借阅无需归还！');
	}else{
		if(selectOneRow[0].IS_BACK=='N'){
			var ids='';
			for(var i=0;i<selectOneRow.length;i++){
				ids = ids + selectOneRow[i].ID+',';
			}
			ids = ids.substring(0,ids.length-1); 
			//send request to the sever
			$.ajax({
				type : "POST",
				url : "borrInforController/doReturnBorrInfor",
				async : false,
				data : {
					id:ids
				},
				success : function(data) {
					if(data.result){
						layerAlert("设置归还成功!");
					/*	$('#borrInforList').bootstrapTable('refresh');*/
						refreshTable('borrInforList','borrInforController/doFindAllBorrInforTableBean')
					}else{
						layerAlert("设置归还失败!");
					}
					//history.go(0);
				},
				error : function(data) {
					layerAlert("error:" + data.responseText);
				}
			});
		}else{
			layerAlert('已归还的借阅不能再次归还！');
		}		
	}

}

window.operateEvents = {
	    'click .editSubject': function (e, value, row, index) {
	    		stopPropagation();
	    		ids = row.ID+',';
	    		ids = ids.substring(0,ids.length-1); 
	    		if(row.IS_RET=='N'){
	    		$.ajax({
					type : "POST",
					url : "borrInforController/doDelBorrInforById",
					async : false,
					data : {
						ids:ids
					},
					success : function(data) {
						if(data.result){
							layerAlert("删除成功!");
							/*$('#borrInforList').bootstrapTable('refresh');*/
							refreshTable('borrInforList','borrInforController/doFindAllBorrInforTableBean')
						}else{
							layerAlert("删除失败!");
						}
						//history.go(0);
					},
					error : function(data) {
						layerAlert("error:" + data.responseText);
					}
				});
	    	}else{
	    		if(row.IS_BACK=='Y'){
	    			layerAlert('已归还的借阅不能删除！');
	    		}
	    		if(row.IS_BACK=='N'){
	    			layerAlert('未归还的借阅不能删除！');
	    		}
	    	}
			
	    },
    'click .fordetails': function (e, value, row, index) {
    	stopPropagation();
		if(row.IS_BACK=='N'||row.IS_RET=='N'){
			var docid = row.ID;
			$("#docInforId").val('');
			var date = new Date().getTime();
			var options = {
				"text" : "档案文书-修改",
				"id" : date,
				"href" : "borrInforController/toBorrInforAdd?action=modify&id="+docid,
				"pid" : window
			};
			window.parent.parent.createTab(options);
		}else{
			layerAlert('已归还的借阅不能修改！');
		}
    }
};

function operateFormatter(value, row, index) {
    return [
            /*'<a class="editSubject" href="javascript:void(0)" title="删除">',
            '<i class="fa fa-remove"></i>',
            '</a>  ',*/
        '<a class="fordetails" href="javascript:void(0)" title="修改">',
        '<i class="fa fa-pencil"></i>',
        '</a>'
    ].join('');
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
	if(value.length>30){
		return "<span class='tdClick' title='"+value+"'>"+value.substring(0,29)+"...</span>"
	}else{
		return "<span class='tdClick'>"+value+"</span>"
	}
}

/**
 * 添加借阅
 */
function addBorrinfor(){
	//open a new tab
	var date = new Date().getTime();
	var options = {
		"text" : "借阅管理-登记",
		"id" : date,
		"href" : "borrInforController/toBorrInforAdd?action=add",
		"pid" : window
	};
	window.parent.parent.createTab(options);
}
/**
 * 清除搜索输入项
 */
/*function clearForm(){
	//reset the search form
	//set the select value
	setDefaultSelect('isSet','ALL');
	setDefaultSelect('arcType','ALL');
	setDefaultSelect('borrDept','ALL');
	//clear the input value
	$('#dengjiBumenName_').val('');
	$('#dengjiBumen_').val('');
	$('#jieyueBumenId_').val('');
	$('#jieyueBumenIdName_').val('');
	$('#arcName').val('');
	//$('#borrUser').val('');
	
	$('#jieyueUserId_').val('');
	$('#jieyueUserIdName_').val('');
	$('#planTimeBeginn').val('');
	$('#planTimeEnd').val('');
	$('#actlTimeBeginn').val('');
	$('#actlTimeEnd').val('');
	//refresh the table
	$("#borrInforList").bootstrapTable('refresh',{
		url : "borrInforController/doFindAllBorrInforList"
	});
}*/
/**
 * 根据select中的myvalue值设置默认选中项
 */
function setDefaultSelect( selectId,value){
	$('#'+selectId).find('option[selected="selected"]').removeAttr('selected');
	var option = $('#'+selectId).find('option[value="'+value+'"]');
	if(option!=null&&option.length==1){
		$(option[0]).attr('selected','selected');
	}
}
/**
 * 编辑借阅
 */
function editBorrinfor(){
	var selectOneRow = getOneTableSelect('borrInforList');
	if(selectOneRow!=null){
		if(selectOneRow.length>1){
			return;
		}
		if(selectOneRow[0].IS_BACK=='N'||selectOneRow[0].IS_RET=='N'){
			var docid = selectOneRow[0].ID;
			$("#docInforId").val('');
			
			var date = new Date().getTime();
			var options = {
				"text" : "档案文书-修改",
				"id" : date,
				"href" : "borrInforController/toBorrInforAdd?action=modify&id="+docid,
				"pid" : window
			};
			window.parent.parent.createTab(options);
		}else{
			layerAlert('已归还的借阅不能修改！');
		}
	}
}
/**
 * 读取借阅
 */
function readBorrinfor(){
	var selectOneRow = getOneTableSelect('borrInforList');
	if(selectOneRow!=null){
		var docid = selectOneRow[0].ID;
		
		var date = new Date().getTime();
		var options = {
			"text" : "借阅管理-查看",
			"id" : date,
			"href" : "borrInforController/toBorrInforAdd?action=read&id="+docid,
			"pid" : window
		};
		window.parent.parent.createTab(options);
	}
}
/**
 * 删除借阅
 */
function delBorrinfor(){
	//get the selected table column
	var selectOneRow = getOneTableSelect('borrInforList');
	if(selectOneRow.length>1){
		return;
	}
	if(selectOneRow[0].IS_RET=='N'){
		//add confirm layer
		layer.confirm('确定删除吗？', {
			btn : [ '是', '否' ]
		}, function() {
			var ids='';
			for(var i=0;i<selectOneRow.length;i++){
				ids = ids + selectOneRow[i].ID+',';
			}
			ids = ids.substring(0,ids.length-1); 
			//send request to the sever
			$.ajax({
				type : "POST",
				url : "borrInforController/doDelBorrInforById",
				async : false,
				data : {
					ids:ids
				},
				success : function(data) {
					if(data.result){
						layerAlert("删除成功!");
						/*$('#borrInforList').bootstrapTable('refresh');*/
						refreshTable('borrInforList','borrInforController/doFindAllBorrInforTableBean')
					}else{
						layerAlert("删除失败!");
					}
					//history.go(0);
				},
				error : function(data) {
					layerAlert("error:" + data.responseText);
				}
			});
		});
	}else{
		if(selectOneRow[0].IS_BACK=='Y'){
			layerAlert('已归还的借阅不能删除！');
		}
		if(selectOneRow[0].IS_BACK=='N'){
			layerAlert('未归还的借阅不能删除！');
		}
	}
}

/**
 * 查询操作
 */
function search(){
/*	var startTime=$("#planTimeBeginn").val();
	var endTime=$("#planTimeEnd").val();
	if(startTime > endTime){
		layerAlert("计划归还开始日期不能大于结束日期");
		return;
	}
	var startTime=$("#actlTimeBeginn").val();
	var endTime=$("#actlTimeEnd").val();
	if(startTime > endTime){
		layerAlert("实际归还开始日期不能大于结束日期");
		return;
	}
	var dengjiBumen_ = $("#dengjiBumen_").val();
	var arcType = $("#arcType").val();
	//var jieyueBumenId_ = $("#jieyueBumenId_").val();
	var jieyueBumenId_ = $("#jieyueBumenId_").val();
	var arcName = $("#arcName").val();
	
	arcName = encodeURI(encodeURI(arcName));
	
	var isSet = $("#isSet").val();
	var borrUser = $("#jieyueUserId_").val();
	var planTimeBeginn = $("#planTimeBeginn").val();
	var planTimeEnd = $("#planTimeEnd").val();
	var actlTimeBeginn = $("#actlTimeBeginn").val();
	var actlTimeEnd = $('#actlTimeEnd').val();*/
	document.getElementById("ff").reset();
	$("#borrInforList").bootstrapTable('refresh',{
		url : "borrInforController/doFindAllBorrInforTableBean",
		query:{
			arcName:window.encodeURI(window.encodeURI($("#input-word").val()=="请输入标题查询"?"":$("#input-word").val())),
		}
	});
}
/**
 * 获取列表中的选中记录
 */
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

window.onTdClickTab = {
		 'click .tdClick': function (e, value, row, index) {
			 	stopPropagation();
				var date = new Date().getTime();
				var options = {
					"text" : "借阅管理-查看",
					"id" : date,
					"href" : "borrInforController/toBorrInforAdd?action=read&id="+row.ID,
					"pid" : window
				};
				window.parent.parent.createTab(options);
		 }
	}

/**
 * 归档状态格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function formatterFileStart (value, row, index) {
	if (value == "Y"){
		return '<span class="label label-success">&nbsp;已归还&nbsp;&nbsp;</span>';
	}else if (value == "N"){
		return '<span class="label label-warning">&nbsp;未归还&nbsp;&nbsp;</span>';
	}else{
		return "--";
	}
}
	document.onkeydown = function(event_e){
	    if(window.event)    
	     event_e = window.event;    
	     var int_keycode = event_e.charCode||event_e.keyCode;    
	     if(int_keycode ==13){
	    	 search(); 
	    }  
	}	
	
	/**
	 * 高级搜索模态框
	 */
	function upperSearch(){
		/*document.getElementById("ff").reset();*/
		/*$('#upperSearch').modal({
			backdrop : 'static',
			keyboard : false
		});*/
		var display =$('#upperSearch').css('display');
		if(display == "none") {
			$("#upperSearch").show();
		}else {
			$("#upperSearch").hide();
		}
	}
	
	function qxButton(){
		$("#upperSearch").hide();	
	}
	
	//重置高级搜索表单
	function clearForm(){
		document.getElementById("ff").reset();
		$("#borrInforList").bootstrapTable('refresh',{
			url : "borrInforController/doFindAllBorrInforTableBean",
			query:{
				"queryPams" : $("#ff").serialize(),
			}
		});
		$("#upperSearch").modal('hide');
	}
	
	//高级搜索
	function submitForm(){
		searchModel();
		$('#upperSearch').modal('hide');
	}
	
	function searchModel(){
		var startTimeN,endTimeN;
		startTimeN = $("#planTimeBeginn").val();
		endTimeN = $("#planTimeEnd").val();
		if(startTimeN != "" && endTimeN != "") {
			if(endTimeN <= startTimeN) {
				layer.msg("计划归还日期必须大于开始日期！");
				return;
			}
		}
		
		var startTimeJ,endTimeJ;
		startTimeJ = $("#actlTimeBeginn").val();
		endTimeJ = $("#actlTimeEnd").val();
		if(startTimeJ != "" && endTimeJ != "") {
			if(endTimeJ <= startTimeJ) {
				layer.msg("实际归还时间必须大于开始时间！");
				return;
			}
		}
		$("#borrInforList").bootstrapTable('refresh',{
			url : "borrInforController/doFindAllBorrInforTableBean",
			query:{
				"queryPams":$("#ff").serialize()
			}
		});
	}


