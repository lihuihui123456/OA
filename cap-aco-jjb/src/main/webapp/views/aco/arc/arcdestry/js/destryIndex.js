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
	$('#add_btn').click(function() {
		var date = new Date().getTime();
		var options = {
			"text" : "销毁管理-登记",
			"id" : date,
			"href" : "arcDestry/goToDestryAdd",
			"pid" : window
		};
		window.parent.parent.createTab(options);
	});

	$('#update_btn').click(function() {
		var obj = $('#folderContent').bootstrapTable('getSelections');
		if (obj.length > 1 || obj.length == '') {
			layerAlert("请选择一条数据");
			return false;
		}
		if (obj[0].is_invalid == 2) {
			layerAlert("已销毁，无法修改");
			return false;
		}
		var id = obj[0].id;
		var date = new Date().getTime();
		var options = {
			"text" : "销毁管理-修改",
			"id" : date,
			"href" : "arcDestry/goToDestryUpdate?id=" + id,
			"pid" : window
		};
		window.parent.parent.createTab(options);
	});

	$('#destry_btn').click(function() {
		var obj = $('#folderContent').bootstrapTable('getSelections');
		if (obj.length > 1 || obj.length == '') {
			layerAlert("请选择一条数据");
			return false;
		} else if (obj.length == 1) {
			if (obj[0].is_invalid == 2) {
				layerAlert("已销毁");
				return false;
			}
			$.ajax({
				type : "POST",
				url : "arcDestry/addDestry",
				async : false,
				dataType : 'text',
				data : {
					"id" : obj[0].id
				},
				success : function(data) {
					if (data == "true") {
						layerAlert("销毁成功！");
						/*$("#folderContent").bootstrapTable('refresh');*/
						refreshTable('folderContent','arcDestry/pageListSort');
					}
				},
				error : function(data) {
					/*$("#folderContent").bootstrapTable('refresh');*/
					refreshTable('folderContent','arcDestry/pageListSort');
				}
			});
		}
	});

	$('#view_btn').click(function() {
		var obj = $('#folderContent').bootstrapTable('getSelections');
		if (obj.length > 1 || obj.length == '') {
			layerAlert("请选择一条数据");
			return false;
		}
		var date = new Date().getTime();
		var id = obj[0].id;
		var options = {
			"text" : "销毁管理-查看",
			"id" : date,
			"href" : "arcDestry/goToDestryView?id=" + id,
			"pid" : window
		};
		window.parent.parent.createTab(options);
	});

	$('#delete_btn').click(function() {
		var obj = $('#folderContent').bootstrapTable('getSelections');
		if (obj.length > 1 || obj.length == '') {
			layerAlert("请选择一条数据");
			return false;
		} else if (obj.length == 1) {
			if (obj[0].is_invalid == 2) {
				layerAlert("选择未销毁单");
				return false;
			}
			layer.confirm('确定删除吗？', {
				btn : [ '是', '否' ]
			}, function() {
				$.ajax({
					type : "POST",
					url : "arcDestry/doDelArcDestry",
					async : false,
					dataType : 'text',
					data : {
						"id" : obj[0].id
					},
					success : function(data) {
						if (data == "true") {
							layerAlert("删除成功！");
							/*$("#folderContent").bootstrapTable('refresh');*/
							refreshTable('folderContent','arcDestry/pageListSort');
						}
					},
					error : function(data) {
						/*$("#folderContent").bootstrapTable('refresh');*/
						refreshTable('folderContent','arcDestry/pageListSort');
					}
				});
			});
		}
	});
	/**
	 * 查看原文
	 */
	$('#view_btn').click(function(){
		var selects = $("#folderContent").bootstrapTable('getSelections');  
		if(selects.length==0){
			window.parent.publicAlert("请选择一条数据！");
			return;
		}
		var date = new Date().getTime();
		var id = selects[0].id;
		var options = {
			"text" : "档案销毁-查看",
			"id" : date,
			"href" : "arcDestry/goToDestryView?id="+ id,
			"pid" : window
		};
		window.parent.parent.createTab(options);
	});
	// 还原销毁
	$('#restore_btn').click(function() {
		var obj = $('#folderContent').bootstrapTable('getSelections');
		if (obj.length > 1 || obj.length == '') {
			layerAlert("请选择一条数据");
			return false;
		} else if (obj.length == 1) {
			if (obj[0].is_invalid == 2) {
				layerAlert("已销毁，无法还原");
				return false;
			}
			var now = getNowFormatDate();
			if (now >= obj[0].closingDate) {
				layerAlert("已到期，无法还原");
				return false;
			}
			layer.confirm('确定还原吗？', {
				btn : [ '是', '否' ]
			}, function() {

				$.ajax({
					type : "POST",
					url : "arcDestry/restoreDestry",
					async : false,
					dataType : 'text',
					data : {
						"id" : obj[0].id
					},
					success : function(data) {
						if (data == "true") {
							layerAlert("还原成功！");
							del(obj[0].id);
							/*$("#folderContent").bootstrapTable('refresh');*/
							refreshTable('folderContent','arcDestry/pageListSort');
						}
					},
					error : function(data) {
						/*$("#folderContent").bootstrapTable('refresh');*/
						refreshTable('folderContent','arcDestry/pageListSort');
					}
				});
			});
		}
	});

	// 导出excel
	$('#export_excel_btn').click(function() {		
		//判断是否有选中
		var obj = $('#folderContent').bootstrapTable('getSelections');
		if (obj.length!=''||obj.length==1) {
			$("#selectIds").val(obj[0].id);
		}else{
			$("#selectIds").val("");
		}
				if($("#input-word").val()!="请输入销毁单号查询"&&$("#input-word").val()!=""){
					var nbr=$("#input-word").val();
					$("#search_form")[0].reset();
					$("#nbr").val(nbr);
				}
				var url = "arcDestry/exportExcel?" + $("#search_form").serialize();
				var aLink = document.createElement('a');
				aLink.href = url;
				aLink.click();				
				if($("#input-word").val()!="请输入销毁单号查询"&&$("#input-word").val()!=""){
					 $("#nbr").val("");
				}	

	});
});

function del(id) {
	$.ajax({
		type : "POST",
		url : "arcDestry/doDelArcDestry",
		async : false,
		dataType : 'text',
		data : {
			"id" : id
		},
		success : function(data) {
		},
		error : function(data) {
			/*$("#folderContent").bootstrapTable('refresh');*/
			refreshTable('folderContent','arcDestry/pageListSort');
		}
	});
}
/**
 * 销毁状态格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
/*function formatterFileStart(value, row, index) {
 if (value == "2"){
 return '<span class="label label-warning">&nbsp;已销毁&nbsp;&nbsp;</span>';
 }else{
 return '<span class="label label-danger">&nbsp;未销毁&nbsp;&nbsp;</span>';
 }
 }*/
function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    var hour = date.getHours();
    var min = date.getMinutes();
    var sec = date.getSeconds();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate;
    return currentdate;
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
			var id = row.id;
			var options = {
				"text" : "档案销毁-查看",
				"id" : date,
				"href" : "arcDestry/goToDestryView?id="+ id,
				"pid" : window
			};
			window.parent.parent.createTab(options);
	 }
}
function searchCommon() {
	//普通查询清空高级查询条件
	$("#search_form")[0].reset();
	var sproName = $("#input-word").val();
	if (sproName == '请输入销毁单号查询') {
		sproName = "";
	}else{
		sproName = sproName
	}
	$("#folderContent").bootstrapTable('refresh',{
		url : "arcDestry/pageListSort",
		query:{
			nbr : $.trim(sproName)
		}
	});
}