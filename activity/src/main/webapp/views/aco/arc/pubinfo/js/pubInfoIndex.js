function searchCommon() {
	//普通查询清空高级查询条件
	$("#search_form")[0].reset();
	var arcName = $("#input-word").val();
	if (arcName == '请输入文件标题查询') {
		arcName = "";
	}else{
		arcName = arcName;
	}
	$("#folderContent").bootstrapTable('refresh',{
		url : "pubInfo/pageList",
		query:{
			arcName :$.trim(arcName) 
		}
	});
}
$(function() {
	/**
	 * 列表回车触发搜索
	 */
	$('#input-word').bind('keypress', function (event) {
	    if (event.keyCode == "13") {
	    	searchCommon();
	       return false ;   
	    } 
	});
			laydate.skin('dahong');
			$('#btn_reset').click(function() {	
				  $('#advSearchModal').modal('hide');
				   $("#search_form")[0].reset();
					$("#folderContent").bootstrapTable('refresh');
			});
			
			$('#add_btn').click(function() {
				date = new Date().getTime();
				var options = {
					"text" : "其他档案-登记",
					"id" : date,
					"href" : "pubInfo/goToPubInfoAdd?id="
							+ $("#typeId").val() + "&pId=" + $("#pId").val(),
					"pid" : window.parent
				};
				window.parent.parent.createTab(options);
			});

			$('#update_btn').click(function() {
				var obj = $('#folderContent').bootstrapTable('getSelections');
				if (obj.length > 1 || obj.length == '') {
					window.parent.publicAlert("请选择一条数据");
					return false;
				}else if (obj.length == 1) {
					if(obj[0].file_start=='1'||obj[0].file_start=='2'){
					window.parent.publicAlert("请选择未归档档案进行修改");
					return false;
					}}
				
				var arcId = obj[0].arc_id;
				date = new Date().getTime();
				var options = {
					"text" : "其他档案-修改",
					"id" : date,
					"href" : "pubInfo/goToPubInfoUpdate?id="
							+ $("#typeId").val() + "&pId=" + $("#pId").val()
							+ "&arcId=" + arcId+"&addFuJian=''",
					"pid" : window.parent
				};
				window.parent.parent.createTab(options);
			});

			$('#view_btn').click(function() {
				var obj = $('#folderContent').bootstrapTable('getSelections');
				if (obj.length > 1 || obj.length == '') {
					window.parent.publicAlert("请选择一条数据");
					return false;
				}
				date = new Date().getTime();
				var arcId = obj[0].arc_id;
				var options = {
					"text" : "其他档案-查看",
					"id" : date,
					"href" : "pubInfo/goToPubInfoView?id="
							+ $("#typeId").val() + "&pId=" + $("#pId").val()
							+ "&arcId=" + arcId,
					"pid" : window
				};
				window.parent.parent.createTab(options);
			});

			$('#destry_btn').click(function() {
				var obj = $('#folderContent').bootstrapTable('getSelections');
				if (obj.length > 1 || obj.length == '') {
					window.parent.publicAlert("请选择一条数据");
					return false;
				} else if (obj.length == 1) {
					if(obj[0].is_invalid=='1'){
					window.parent.publicAlert("已作废");
					return false;
					}
				if(obj[0].file_start=='0'){
					window.parent.publicAlert("请选择已归档");
					return false;
					}
					$.ajax({
								type : "POST",
								url : "pubInfo/destryArcPubInfo",
								async : false,
								dataType : 'text',
								data : {
									"arcId" : obj[0].arc_id
								},
								success : function(data) {
									if (data == "true") {
										window.parent.publicAlert("作废成功！");
									/*	$("#folderContent")
												.bootstrapTable('refresh');*/
										refreshTable('folderContent','pubInfo/pageList');
									}
								},
								error : function(data) {
								/*	$("#folderContent")
											.bootstrapTable('refresh');*/
									refreshTable('folderContent','pubInfo/pageList');
								}
							});
				}
			});
			
					$('#filestart_btn').click(function() {
				var obj = $('#folderContent').bootstrapTable('getSelections');
				if (obj.length > 1 || obj.length == '') {
					window.parent.publicAlert("请选择一条数据");
					return false;
				} else if (obj.length == 1) {
					if(obj[0].file_start=='1'){
					window.parent.publicAlert("档案已归档");
					return false;
					}
					
					$.ajax({
								type : "POST",
								url : "arcPubInfo/doUpdateFileStartByArcId",
								async : false,
								dataType : 'text',
								data : {
									"arcId" : obj[0].arc_id
								},
								success : function(data) {
									if (data == "true") {
										window.parent.publicAlert("归档成功！");
										/*$("#folderContent")
												.bootstrapTable('refresh');*/
										refreshTable('folderContent','pubInfo/pageList');
									}
								},
								error : function(data) {
							/*		$("#folderContent")
											.bootstrapTable('refresh');*/
									refreshTable('folderContent','pubInfo/pageList');
								}
							});
				}
			});
			
				$('#addfilestart_btn').click(function() {
				var obj = $('#folderContent').bootstrapTable('getSelections');
				if (obj.length > 1 || obj.length == '') {
					window.parent.publicAlert("请选择一条数据");
					return false;
				} else if (obj.length == 1) {
					if(obj[0].file_start=='0'){
					window.parent.publicAlert("选择已归档文件");
					return false;
					}
					
					$.ajax({
								type : "POST",
								url : "arcPubInfo/doAddFileUpdateFileStartByArcId",
								async : false,
								dataType : 'text',
								data : {
									"arcId" : obj[0].arc_id
								},
								success : function(data) {
									if (data == "true") {
				var arcId = obj[0].arc_id;
				date = new Date().getTime();
				var options = {
					"text" : "其他档案-追加归档",
					"id" : date,
					"href" : "pubInfo/goToPubInfoUpdate?id="
							+ $("#typeId").val() + "&pId=" + $("#pId").val()
							+ "&arcId=" + arcId+"&addFuJian=addFuJian",
					"pid" : window.parent
				};
				window.parent.parent.createTab(options);
									}
								},
								error : function(data) {
									/*$("#folderContent")
											.bootstrapTable('refresh');*/
									refreshTable('folderContent','pubInfo/pageList');
								}
							});
				}
			});
			
			
			$('#delete_btn').click(function() {
				var obj = $('#folderContent').bootstrapTable('getSelections');
				if (obj.length > 1 || obj.length == '') {
					window.parent.publicAlert("请选择一条数据");
					return false;
				} else if (obj.length == 1) {
					if(obj[0].file_start=='1'){
					window.parent.publicAlert("请选择未归档文件");
					return false;
					}
					window.parent.publicConfirm("确定删除吗？",obj[0].arc_id);
/*					layer.confirm('确定删除吗？', {
						btn : [ '是', '否' ]
					}, function() {
						$.ajax({
							type : "POST",
							url : "arcPubInfo/doDelArcInfoByArcId",
							async : false,
							dataType : 'text',
							data : {
								"arcId" : obj[0].arc_id
							},
							success : function(data) {
								if (data == "true") {
									window.parent.publicAlert("删除成功！");
									$("#folderContent")
											.bootstrapTable('refresh');
								}
							},
							error : function(data) {
								$("#folderContent")
										.bootstrapTable('refresh');
							}
						});
					});*/
				}
			});

			$('#restore_btn').click(function() {
				var obj = $('#folderContent').bootstrapTable('getSelections');
				if (obj.length > 1 || obj.length == '') {
					window.parent.publicAlert("请选择一条数据");
					return false;
				} else if (obj.length == 1) {
					if(obj[0].is_invalid==2){
						 window.parent.publicAlert("已销毁，无法还原");
						return false;
						}
					if(obj[0].file_start==0){
						 window.parent.publicAlert("未归档,无需还原");
						return false;
						}
					
					$.ajax({
								type : "POST",
								url : "arcPubInfo/doHuanyuanByArcId",
								async : false,
								dataType : 'text',
								data : {
									"id" : obj[0].arc_id
								},
								success : function(data) {
									data=JSON.parse(data);
									if (data.result ==true) {
										window.parent.publicAlert("还原成功！");
										/*$("#folderContent")
												.bootstrapTable('refresh');*/
										refreshTable('folderContent','pubInfo/pageList');
									}
								},
								error : function(data) {
									/*$("#folderContent")
											.bootstrapTable('refresh');*/
									refreshTable('folderContent','pubInfo/pageList');
								}
							});
				}
			});
			
			//导出excel
	$('#export_excel_btn').click(function() {
		//判断是否有选中
		var obj = $('#folderContent').bootstrapTable('getSelections');
		if (obj.length!=''||obj.length==1) {
			$("#selectIds").val(obj[0].arc_id);
		}else{
			$("#selectIds").val("");
		}	
		if($("#input-word").val()!="请输入文件标题查询"&&$("#input-word").val()!=""){
			var arcName=$("#input-word").val();
			$("#search_form")[0].reset();
			$("#arcName").val(arcName);
		}
		var url = "pubInfo/exportExcel?"+$("#search_form").serialize();
		var aLink = document.createElement('a');
	    aLink.href =url;
	    aLink.click();		
	    if($("#input-word").val()!="请输入文件标题查询"&&$("#input-word").val()!=""){
			 $("#arcName").val("");
		}

		});			
		});
/**删除一条数据*/
function deleteData(arc_id){
	$.ajax({
		type : "POST",
		url : "arcPubInfo/doDelArcInfoByArcId",
		async : false,
		dataType : 'text',
		data : {
			"arcId" : arc_id
		},
		success : function(data) {
			if (data == "true") {
				window.parent.publicAlert("删除成功！");
				/*$("#folderContent")
						.bootstrapTable('refresh');*/
				refreshTable('folderContent','pubInfo/pageList');
			}
		},
		error : function(data) {
		/*	$("#folderContent")
					.bootstrapTable('refresh');*/
			refreshTable('folderContent','pubInfo/pageList');
		}
	});
}
		/**
 * 归档状态格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function formatterFileStart (value, row, index) {
	if(row.is_invalid=="1"){
		return '<span class="label label-danger">&nbsp;已作废&nbsp;&nbsp;</span>';
	}
	else if(value == "0"){
		return '<span class="label label-success">&nbsp;未归档&nbsp;&nbsp;</span>';
	}else if (value == "1"){
		return '<span class="label label-warning">&nbsp;已归档&nbsp;&nbsp;</span>';
	}else{
		return "--";
	}
}

/**
 * table序号格式化
 * @param value
 * @param row
 * @param index
 * @returns
 */
function indexFormatter(value, row, index) {
	return index + 1;
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
		return '<span class="label label-danger">未作废</span>';
	}else if (value == "1"){
		return '<span class="label label-warning">已作废</span>';
	}else if (value == "2"){
		return '<span class="label label-success">销&nbsp;&nbsp;毁</span>';
	}else{
		return "--";
	}
}
/**
 * 高级搜索模态框
 */
function advSearchModal(){
	$('#advSearchModal').modal('show');
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
	if(value==null){
		return "<span class='tdClick'>-</span>"
	}
	else if(value.length>30){
		return "<span class='tdClick' title='"+value+"'>"+value.substring(0,29)+"...</span>"
	}else{
		return "<span class='tdClick'>"+value+"</span>"
	}
}
/*
 * table 点击标题弹出查看/办理页面
 */
window.onTdClickTab = {
	 'click .tdClick': function (e, value, row, index) {
			date = new Date().getTime();
			var arcId = row.arc_id;
			var options = {
				"text" : "其他档案-查看",
				"id" : date,
				"href" : "pubInfo/goToPubInfoView?id="
						+ $("#typeId").val() + "&pId=" + $("#pId").val()
						+ "&arcId=" + arcId,
				"pid" : window.parent
			};
			window.parent.parent.createTab(options);
	 }
}