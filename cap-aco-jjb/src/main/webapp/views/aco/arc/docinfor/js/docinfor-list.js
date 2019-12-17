//查询
var regTimeBeginn=$("#regTimeBeginn").val();
var regTimeEnd=$("#regTimeEnd").val();


var searchfileStart = $("#searchfileStart").val();
var searchregYear = $("#searchregYear").val();
var regTimeBeginn = $("#regTimeBeginn").val();
var regTimeEnd = $("#regTimeEnd").val();
var searchArcType = $('#searchArcType').val();
var selectionIds = [];
$(function() {
	laydate.skin('dahong');
	iniTable(globalFileType);
	$('#add_btn').click(function(){
		addDocinfor();
	});
	$('#edi_btn').click(function(){
		editDocinfor();
	});
	$('#view_btn').click(function(){
		readDocinfor();
	});
	$('#del_btn').click(function(){
		delDocinfor();
	});
	$('#guidang_btn').click(function(){
		doGuidang();
	});
	$('#zuofei_btn').click(function(){
		doZuofei();
	});
	$('#zhuijiaguidang_btn').click(function(){
		doZhuijiaDangan();
	});	
	
	$('#export_excel_btn').click(function() {
		dangandaochu();
	});
/*	$('#huanyuan_btn').click(function() {
		dohuanyuan();
	});*/
	$("#ff").find("input").eq(1).focus();
	
	//	记忆选中
	var union = function(array, ids) {
	$.each(ids, function(i, ID) {
		if ($.inArray(ID, array) == -1) {
			array[array.length] = ID;
		}
	});
	return array;
	};
	/**
	 * 取消选中事件操作数组
	 */
	var difference = function(array, ids) {
		$.each(ids, function(i, ID) {
			var index = $.inArray(ID, array);
			if (index != -1) {
				array.splice(index, 1);
			}
		});
		return array;
	};
	var _ = {
		"union" : union,
		"difference" : difference
	};

	/**
	 * bootstrap-table 记忆选中
	 */
	$('#docInforlist').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table',
		function(e, rows) {
			var ids = $.map(!$.isArray(rows) ? [ rows ] : rows,
					function(row) {
						return row.ID;
					});
			func = $.inArray(e.type, [ 'check', 'check-all' ]) > -1 ? 'union'
					: 'difference';
			selectionIds = _[func](selectionIds, ids);
		});

	});


function searchModal(){
	var display =$("#searchDiv").css('display');
	if(display == "none") {
		$("#searchDiv").show();
	}else {
		$("#searchDiv").hide();
	}
}
/*
 * function dohuanyuan(){ var selectOneRow = getOneTableSelect('docInforlist');
 * if(selectOneRow!=null){ if(selectOneRow.length>1){ return; }
 * if(selectOneRow[0].arcPubInfor.fileStart=='0'){
 * window.parent.publicAlert("所选文书档案为未归档，请先归档！"); }else
 * if(selectOneRow[0].arcPubInfor.fileStart=='1'){
 * if(selectOneRow[0].arcPubInfor.isInvalid=='0'){
 * window.parent.publicAlert("所选文书档案为已归档，请先作废！"); }else
 * if(selectOneRow[0].arcPubInfor.isInvalid=='1'){ //还原 var docid =
 * selectOneRow[0].docInfor.arcId; $.ajax({ type : "POST", url :
 * "arcPubInfo/doHuanyuanByArcId", async : false, data : { arcId:docid },
 * success : function(data) { if(data.result){
 * window.parent.publicAlert("还原成功!");
 * $('#docInforlist').bootstrapTable('refresh'); }else{
 * window.parent.publicAlert("还原失败!"); } //history.go(0); }, error :
 * function(data) { window.parent.publicAlert("error:" + data.responseText); }
 * }); } } } }
 */
/**
 * 查看原文
 */
$('#view_btn').click(function(){
	var selects = $("#docInforlist").bootstrapTable('getSelections');  
	var arcId = "";
	if(selects.length==0){
		window.parent.publicAlert("请选择一条数据！");
		return;
	}
	arcId=selects[0].ARC_ID;
	var date = new Date().getTime();
	var options = {
		"text" : "文书档案-查看",
		"id" : date,
		"href" : "docInforController/toDocInforAdd?action=read&arcId="+arcId,
		"pid" : window.parent
	};
	window.parent.parent.createTab(options);
});
/**
 * 档案导出功能
 */
function dangandaochu(){
	//兼容性问题，
	var url = globalPath+"/docInforController/doExportExcel?"+$("#ff").serialize()+
		'&title='+encodeURI(encodeURI($("#input-word").val()))+'&globalFileType='+globalFileType+'&selectionIds='+selectionIds;
	//window.open(url); 
	//在ie8下可用，在ie11下不可用，点击链接后没有反应
	var aLink = document.createElement('a');
    aLink.href =url;
    aLink.click();
}

/**
 * 追加档案功能
 */
function doZhuijiaDangan(){
	var selectOneRow = getOneTableSelect('docInforlist');
	if(selectOneRow!=null){
		if(selectOneRow.length>1){
			return;
		}
		//check the current dangan status
		if(selectOneRow[0].FILE_START=='0'){
			window.parent.publicAlert("所选文书档案为未归档，不能追加归档！");
			return;
		}else if(selectOneRow[0].FILE_START=='1'){

		}
		if(selectOneRow[0].FILE_START=='0'){
			window.parent.publicAlert("所选文书档案为未归档，不能追加归档！");
			return;
		}else if(selectOneRow[0].FILE_START=='1'){
			if(selectOneRow[0].IS_INVALID=='0'){
				var docid = selectOneRow[0].ARC_ID;
				$("#docInforId").val('');
				//open a new tab
				var date = new Date().getTime();
				var options = {
					"text" : "文书档案-追加档案",
					"id" : date,
					"href" : "docInforController/toDocInforAdd?action=zhuijiadangan&arcId="+docid,
					"pid" : window.parent
				};
				window.parent.parent.createTab(options);
			}else if(selectOneRow[0].IS_INVALID=='1'){
				window.parent.publicAlert("所选文书档案为已作废，不能追加归档！");
			}
		}
	}
}

function addDocinfor(){
	globalFileType
	//open a new tab
	var date = new Date().getTime();
	var options = {
		"text" : "文书档案-登记",
		"id" : date,
		"href" : "docInforController/toDocInforAdd?action=add&arcTypeId="+golbalArcType+'&fileType='+globalFileType,
		"pid" : window.parent
	};
	window.parent.parent.createTab(options);
}

function doZuofei(){
	var selectOneRow = getOneTableSelect('docInforlist');
	if(selectOneRow!=null){
		if(selectOneRow.length>1){
			return;
		}
		//check the current dangan status
		if(selectOneRow[0].FILE_START=='0'){
			window.parent.publicAlert("所选文书档案未归档，不能作废！");
		}else if(selectOneRow[0].FILE_START=='1'){
			if(selectOneRow[0].IS_INVALID=='0'){
				
				var docid = selectOneRow[0].ARC_ID;
				$.ajax({
					type : "POST",
						url : "arcPubInfo/doInvArcInfoByArcId",
					async : false,
					data : {
						arcId:docid
					},
					success : function(data) {
						if(data=='true'){
							window.parent.publicAlert("作废成功!");
							//$('#docInforlist').bootstrapTable('refresh');
							var opt = {
									url : 'docInforController/searchDocinfor',
									silent : true,
									query:{    
										type:globalFileType,
										searchArcType:$('#searchArcType').val(),
										level:2   
									} 
								};
							$("#docInforlist").bootstrapTable('refresh', opt);
						}else{
							window.parent.publicAlert("作废失败!");
						}
						//history.go(0);
					},
					error : function(data) {
						window.parent.publicAlert("error:" + data.responseText);
					}
				});
			}else if(selectOneRow[0].IS_INVALID=='1'){
				window.parent.publicAlert("所选文书档案为已作废，不能再次作废！");
			}
		}
	}
}

function doGuidang(){
	var selectOneRow = getOneTableSelect('docInforlist');
	if(selectOneRow!=null){
		if(selectOneRow.length>1){
			return;
		}
		//check the current dangan status
		if(selectOneRow[0].FILE_START=='0'){
			var docid = selectOneRow[0].ARC_ID;
			$.ajax({
				type : "POST",
				url : "docInforController/doGuidang",
				async : false,
				data : {
					arcId:docid
				},
				success : function(data) {
					if(data.result){
						window.parent.publicAlert("归档成功!");
						//$('#docInforlist').bootstrapTable('refresh');
						var opt = {
								url : 'docInforController/searchDocinfor',
								silent : true,
								query:{    
									type:globalFileType,
									searchArcType:$('#searchArcType').val(),
									level:2   
								} 
							};
						$("#docInforlist").bootstrapTable('refresh', opt);
					}else{
						window.parent.publicAlert("归档失败!");
					}
					//history.go(0);
				},
				error : function(data) {
					window.parent.publicAlert("error:" + data.responseText);
				}
			});
		}else if(selectOneRow[0].FILE_START=='1'){
			if(selectOneRow[0].IS_INVALID=='0'){
				window.parent.publicAlert("所选文书档案为已归档，不能再次归档！");
			}else if(selectOneRow[0].IS_INVALID=='1'){
				window.parent.publicAlert("所选文书档案为已作废，请先还原！");
			}
		}
	}
}


function editDocinfor(){
	var selectOneRow = getOneTableSelect('docInforlist');
	if(selectOneRow!=null){
		if(selectOneRow.length>1){
			return;
		}
		//check the current dangan status
		if(selectOneRow[0].FILE_START=='0'){
			var docid = selectOneRow[0].ARC_ID;
			$("#docInforId").val('');
			var date = new Date().getTime();
			var options = {
				"text" : "文书档案-修改",
				"id" : date,
				"href" : "docInforController/toDocInforAdd?action=modify&arcId="+docid+'&fileType='+globalFileType,
				"pid" : window.parent
			};
			window.parent.parent. createTab(options);
		}else if(selectOneRow[0].FILE_START=='1'){
			window.parent.publicAlert("所选文书档案为已归档，不能修改！");
		}
	}
}

function readDocinfor(){
	var selectOneRow = getOneTableSelect('docInforlist');
	if(selectOneRow!=null){
		var docid = selectOneRow[0].ARC_ID;
		$("#docInforId").val('');
		
		var date = new Date().getTime();
		var options = {
			"text" : "文书档案-查看",
			"id" : date,
			"href" : "docInforController/toDocInforAdd?action=read&arcId="+docid,
			"pid" : window.parent
		};
		window.parent.parent.createTab(options);
	}
	//fill the data
	//the inputs can not be modified
}

function delDocinfor(){
	//get the selected table column
	var selectOneRow = getOneTableSelect('docInforlist');
	if(selectOneRow!=null){
		if(selectOneRow.length>1){
			return;
		}
		//check the current dangan status
		if(selectOneRow[0].FILE_START=='0'){
			//add confirm layer
			layer.confirm('确定删除吗？', {
				btn : [ '是', '否' ]
			}, function() {
				var ids='';
				for(var i=0;i<selectOneRow.length;i++){
					ids = ids + selectOneRow[i].ARC_ID+',';
				}
				ids = ids.substring(0,ids.length-1); 
				//send request to the sever
				$.ajax({
					type : "POST",
					url : "docInforController/doDeleteDocInfor",
					async : false,
					data : {
						ids:ids
					},
					success : function(data) {
						if(data.result){
							window.parent.publicAlert("删除成功!");
							layer.closeAll('dialog');
							var opt = {
									url : 'docInforController/searchDocinfor',
									silent : true,
									query:{    
										type:globalFileType,
										searchArcType:$('#searchArcType').val(),
										level:2   
									} 
								};
							$("#docInforlist").bootstrapTable('refresh', opt);
						}else{
							window.parent.publicAlert("删除失败!");
							layer.closeAll('dialog');
						}
						//history.go(0);
					},
					error : function(data) {
						layer.closeAll('dialog');
						window.parent.publicAlert("error:" + data.responseText);
					}
				});
				/*$("#docInforlist").bootstrapTable('refresh',{
					url : "docInforController/findAllDocInforList",
					query:{
						type : globalFileType
					}
				});*/
			});
		}else if(selectOneRow[0].FILE_START=='1'){
			if(selectOneRow[0].IS_INVALID=='0'){
				window.parent.publicAlert("所选文书档案为已归档，请先作废，然后销毁！");
			}else if(selectOneRow[0].IS_INVALID=='1'){
				window.parent.publicAlert("所选文书档案为已作废，请在销毁管理中销毁！");
			}
		}
	}
}


function search(){
	if(regTimeBeginn > regTimeEnd){
		window.parent.publicAlert("登记开始日期不能大于结束日期");
		return;
	}
	document.getElementById("ff").reset();
	$("#docInforlist").bootstrapTable('refresh',{
		url : "docInforController/searchDocinfor",
		query:{
			title: encodeURI(encodeURI($("#input-word").val())),
			type : globalFileType,
			sortName:this.sortName,
			sortOrder:this.sortOrder
		}
	});
	$('#searchModal').modal('hide')
}
function searchTable(){
	if(regTimeBeginn > regTimeEnd){
		window.parent.publicAlert("登记开始日期不能大于结束日期");
		return;
	}
	$("#input-word").val("");
	$("#docInforlist").bootstrapTable('refresh',{
		url : "docInforController/searchDocinfor",
		query:{
			searcharcName : encodeURI(encodeURI($("#searcharcName").val())),
			searchdocNBR: encodeURI(encodeURI($("#searchdocNBR").val())),
			searchfileStart: $("#searchfileStart").val(),
			searchregYear:$("#searchregYear").val(),
			regTimeBeginn:$("#regTimeBeginn").val(),
			regTimeEnd:$("#regTimeEnd").val(),
			searchArcType:$('#searchArcType').val(),
			type : globalFileType,
			sortName:this.sortName,
			sortOrder:this.sortOrder
		}
	});
}

function clearForm(){
	document.getElementById("ff").reset();
	$("#docInforlist").bootstrapTable('refresh',{
		url : "docInforController/findAllDocInforList",
		query:{
			type : globalFileType
		}
	});
}
function cancelForm(){
	$("#search_form")[0].reset();
	$("#searchDiv").hide();
}

function getOneTableSelect(tableId){
	var selectOneRow = $("#"+tableId).bootstrapTable('getSelections');
	if (selectOneRow.length != 1) {
		window.parent.publicAlert("请选择一条记录！");
		return null;
	}
	var selectedTr = $("#"+tableId+" tr.selected");
	if(selectedTr.length!=1){
		window.parent.publicAlert("请选择一条记录！");
		return null;
	}
	return selectOneRow;
}

/*
 * 初始化table
 * @para type：docinfor的类型
 * */
function iniTable(typeName){
	if(regTimeBeginn > regTimeEnd){
		window.parent.publicAlert("登记开始日期不能大于结束日期");
		return;
	}
	$('#docInforlist').bootstrapTable({
		url : 'docInforController/searchDocinfor', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
//		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "DESC", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageNum : params.offset, // 页码
				pageSize : params.limit, // 页面大小
				title: encodeURI(encodeURI($("#input-word").val())),
				searcharcName : encodeURI(encodeURI($("#searcharcName").val())),
				searchdocNBR: encodeURI(encodeURI($("#searchdocNBR").val())),
				searchfileStart: $("#searchfileStart").val(),
				searchregYear:searchregYear,
				regTimeBeginn:$("#regTimeBeginn").val(),
				regTimeEnd:$("#regTimeEnd").val(),
				searchArcType:$('#searchArcType').val(),
				type : globalFileType,
				sortName:this.sortName,
				sortOrder:this.sortOrder
			};
			return temp;
		},// 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		pageList:[10, 25, 50, 100],
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "ID", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		singleSelect : false,
		/*maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.ID, selectionIds) !== -1;
				});
				return res;	
		},*/
		columns : [ {
			checkbox : true,
			field: 'checkStatus',
			valign: 'middle',
			checkbox : true
		}, {
			field : 'ID',
			visible: false,
			formatter : function(value, row, index) {
				return row.arcPubInfor.arcId;
			}
		}, {
			field : 'index',
			title : '序号',
			align : 'left',
			halign: 'center',
			align:'center',
			width : '8%',
			valign : 'middle',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'REG_TIME',
			title : '登记日期',
			align : 'left',
			valign : 'middle',
			sortable : true,
			  formatter : function(val, row) {
					return row.REG_TIME.substring(0,10);
				}
		}, {
			field : 'ARC_NAME',
			title : '文件标题',
			align : 'left',
			valign : 'middle',
			/*events: onTdClickTab,*/
            formatter: onTdClickTabFormatter,
			sortable : true,
		}, {
			field : 'DOC_CO',
			title : '来文单位',
			align : 'left',
			valign : 'middle',
			sortable : true,
			  formatter : function(val, row) {
					return row.DOC_CO;
				}
		}, {
			field : 'DOC_NBR',
			title : '文号',
			align : 'left',
			valign : 'middle',
			sortable : true,
			  formatter : function(val, row) {
					return row.DOC_NBR;
				}
		}, {
			field : 'REG_USER',
			title : '登记人',
			align : 'left',
			valign : 'middle',
			sortable : true,
			  formatter : function(val, row) {
					return row.REG_USER;
				}
		}, {
			field : 'FILE_START',
			title : '档案状态',
			align : 'left',
			valign : 'middle',
			sortable : true,
			  formatter : function(val, row) {
				  //0:未归档1:已归档2：追加归档
				  //0:正常1：作废2：销毁
				 var fileStart = row.FILE_START;
				 var isInvalid = row.IS_INVALID;
				 if(isInvalid=='0'){
					 if (fileStart == "0"){
						 return '<span class="label label-success">&nbsp;未归档&nbsp;&nbsp;</span>';
					 }else if (fileStart == "1"){
						 return '<span class="label label-warning">&nbsp;已归档&nbsp;&nbsp;</span>';
					 }else{
						 return "--";
					 }
				 }else if(isInvalid=='1'){
					 return '<span class="label label-danger">&nbsp;已作废&nbsp;&nbsp;</span>';
				 }else {
					 return "--";
				 }
				}
		}, {
			field : 'DEP_POS',
			title : '存放位置',
			align : 'left',
			valign : 'middle',
			sortable : true,
			  formatter : function(val, row) {
				return row.DEP_POS;
				}
		}, {
			 field: 'operate',
             title: '操作',
             align : 'center',
             events: operateEvents,
             formatter: operateFormatter
		}],
		onClickRow : function (row, obj) {
			var date = new Date().getTime();
			var options = {
				"text" : "文书档案-查看",
				"id" : date,
				"href" : "docInforController/toDocInforAdd?action=read&arcId="+row.ARC_ID,
				"pid" : window.parent
			};
			window.parent.parent.createTab(options);
        }
	});
	
}
function writeObj(obj){ 
	 var description = ""; 
	 for(var i in obj){ 
	 var property=obj[i]; 
	 description+=i+" = "+property+"\n"; 
	 } 
	 alert(description); 
	} 

/**
 * 操作格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function operateFormatter(value, row, index) {
    return [
            '<a class="editSubject" href="javascript:void(0)" title="修改">',
            '<i class="fa fa-pencil"></i>',
            '</a>  ',
	        '<a class="deleteSubject" href="javascript:void(0)" title="删除">',
	        '<i class="fa fa-remove"></i>',
	        '</a>'
		    ].join('');
}
window.operateEvents = {
    'click .editSubject': function (e, value, row, index) {
    	stopPropagation();
    	var selectOneRow = row;
    	if(selectOneRow!=null){
    		if(selectOneRow.length>1){
    			return;
    		}
    		//check the current dangan status
    		if(selectOneRow.FILE_START=='0'){
    			var docid = selectOneRow.ARC_ID;
    			$("#docInforId").val('');
    			var date = new Date().getTime();
    			var options = {
    				"text" : "文书档案-修改",
    				"id" : date,
    				"href" : "docInforController/toDocInforAdd?action=modify&arcId="+docid+'&fileType='+globalFileType,
    				"pid" : window.parent
    			};
    			window.parent.parent. createTab(options);
    		}else if(selectOneRow.FILE_START=='1'){
    			window.parent.publicAlert("所选文书档案为已归档，不能修改！");
    		}
    	}
		
    },
    'click .deleteSubject': function (e, value, row, index) {
    	stopPropagation();
    	var selectOneRow = row;
    	if(selectOneRow!=null){
    		if(selectOneRow.length>1){
    			return;
    		}
    		//check the current dangan status
    		if(selectOneRow.FILE_START=='0'){
    			//add confirm layer
    			layer.confirm('确定删除吗？', {
    				btn : [ '是', '否' ]
    			}, function() {
    				var ids='';
    				ids = selectOneRow.ARC_ID; 
    				//send request to the sever
    				$.ajax({
    					type : "POST",
    					url : "docInforController/doDeleteDocInfor",
    					async : false,
    					data : {
    						ids:ids
    					},
    					success : function(data) {
    						if(data.result){
    							window.parent.publicAlert("删除成功!");
    							layer.closeAll('dialog');
    							var opt = {
    									url : 'docInforController/searchDocinfor',
    									silent : true,
    									query:{    
    										type:globalFileType,
    										searchArcType:$('#searchArcType').val(),
    										level:2   
    									} 
    								};
    							$("#docInforlist").bootstrapTable('refresh', opt);
    						}else{
    							window.parent.publicAlert("删除失败!");
    							layer.closeAll('dialog');
    						}
    						//history.go(0);
    					},
    					error : function(data) {
    						layer.closeAll('dialog');
    						window.parent.publicAlert("error:" + data.responseText);
    					}
    				});
    				/*$("#docInforlist").bootstrapTable('refresh',{
    					url : "docInforController/findAllDocInforList",
    					query:{
    						type : globalFileType
    					}
    				});*/
    			});
    		}else if(selectOneRow[0].FILE_START=='1'){
    			if(selectOneRow[0].IS_INVALID=='0'){
    				window.parent.publicAlert("所选文书档案为已归档，请先作废，然后销毁！");
    			}else if(selectOneRow[0].IS_INVALID=='1'){
    				window.parent.publicAlert("所选文书档案为已作废，请在销毁管理中销毁！");
    			}
    		}
    	}
    }
};

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
		return "<span class='tdClick'>"+row.ARC_NAME+"</span>"
	}else{
		return "<span class='tdClick'>-</span>"
	}
}
window.onTdClickTab = {
		 'click .tdClick': function (e, value, row, index) {
			var date = new Date().getTime();
			var options = {
				"text" : "文书档案-查看",
				"id" : date,
				"href" : "docInforController/toDocInforAdd?action=read&arcId="+row.arcId,
				"pid" : window.parent
			};
			window.parent.parent.createTab(options);
		 }
	}

/**
 * 作废状态表格格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function formatterInvalidStart (value, row, index) {
	if (value == "0"){
		return '<span class="label label-danger">&nbsp;未归档&nbsp;&nbsp;</span>';
	}else if (value == "1"){
		return '<span class="label label-warning">&nbsp;已归档&nbsp;&nbsp;</span>';
	}else if (value == "2"){
		return '<span class="label label-success">追加归档</span>';
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